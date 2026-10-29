// Только CI: этот файл временно заменяет MainFlutterWindow.swift в сборке стенда.
import Cocoa
import FlutterMacOS
import Security

class MainFlutterWindow: NSWindow {
  private var probeChannel: FlutterMethodChannel?

  override func awakeFromNib() {
    let controller = FlutterViewController()
    contentViewController = controller
    setContentSize(NSSize(width: 600, height: 400))
    RegisterGeneratedPlugins(registry: controller)
    let channel = FlutterMethodChannel(
      name: "space/directory-crash-keychain", binaryMessenger: controller.engine.binaryMessenger)
    probeChannel = channel
    channel.setMethodCallHandler { call, result in
      do {
        let probe = try KeychainCrashProbe()
        switch call.method {
        case "verify": result(try probe.verify(call.arguments as? String))
        case "cleanup": result(try probe.cleanup())
        default: result(FlutterMethodNotImplemented)
        }
      } catch {
        // Сообщение содержит только код системной ошибки, без ключей и значений.
        result(FlutterError(code: "keychain-ci", message: String(describing: error), details: nil))
      }
    }
    super.awakeFromNib()
  }
}

private struct KeychainStatus: Error { let status: OSStatus }

private struct KeychainCrashProbe {
  let namespace: String
  let keychain: SecKeychain
  let service = "flutter_secure_storage_service"

  init() throws {
    let env = ProcessInfo.processInfo.environment
    guard env["GITHUB_ACTIONS"] == "true",
      let value = env["DIRECTORY_CRASH_NAMESPACE"],
      value.range(of: "^space-ci-[a-f0-9]{64}$", options: .regularExpression) != nil
    else { throw KeychainStatus(status: errSecParam) }
    namespace = value + "."
    let interaction = SecKeychainSetUserInteractionAllowed(false)
    guard interaction == errSecSuccess else { throw KeychainStatus(status: interaction) }
    guard let path = env["DIRECTORY_CRASH_KEYCHAIN"], let root = env["RUNNER_TEMP"],
      URL(fileURLWithPath: path).resolvingSymlinksInPath().path.hasPrefix(
        URL(fileURLWithPath: root).resolvingSymlinksInPath().path + "/")
    else { throw KeychainStatus(status: errSecParam) }
    var opened: SecKeychain?
    let status = SecKeychainOpen(path, &opened)
    guard status == errSecSuccess, let opened = opened else { throw KeychainStatus(status: status) }
    keychain = opened
  }

  var query: [CFString: Any] {
    [kSecClass: kSecClassGenericPassword, kSecAttrService: service,
     kSecUseDataProtectionKeychain: false, kSecMatchSearchList: [keychain]]
  }

  func verify(_ expected: String?) throws -> Bool {
    guard let expected = expected else { throw KeychainStatus(status: errSecParam) }
    var request = query
    request[kSecAttrAccount] = namespace + "space.directory.v1"
    request[kSecReturnData] = true
    request[kSecMatchLimit] = kSecMatchLimitOne
    var item: CFTypeRef?
    let status = SecItemCopyMatching(request as CFDictionary, &item)
    guard status == errSecSuccess else { throw KeychainStatus(status: status) }
    guard UserDefaults.standard.synchronize() else { return false }
    return (item as? Data) == expected.data(using: .utf8)
  }

  func ownedAccounts() throws -> [String] {
    var request = query
    request[kSecReturnAttributes] = true
    request[kSecMatchLimit] = kSecMatchLimitAll
    var items: CFTypeRef?
    let status = SecItemCopyMatching(request as CFDictionary, &items)
    if status == errSecItemNotFound { return [] }
    guard status == errSecSuccess, let values = items as? [[String: Any]]
    else { throw KeychainStatus(status: status) }
    return values.compactMap { $0[kSecAttrAccount as String] as? String }
      .filter { $0.hasPrefix(namespace) }
  }

  func cleanup() throws -> Bool {
    for account in try ownedAccounts() {
      var request = query
      request[kSecAttrAccount] = account
      let status = SecItemDelete(request as CFDictionary)
      guard status == errSecSuccess else { throw KeychainStatus(status: status) }
    }
    let preferences = UserDefaults.standard
    for key in preferences.dictionaryRepresentation().keys where key.hasPrefix("flutter." + namespace) {
      preferences.removeObject(forKey: key)
    }
    let remaining = try ownedAccounts()
    return preferences.synchronize() && remaining.isEmpty
  }
}
