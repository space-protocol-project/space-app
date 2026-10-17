import Cocoa
import FlutterMacOS
import UserNotifications

@main
class AppDelegate: FlutterAppDelegate {
  let notifications = NotificationActivation()

  override init() {
    super.init()
    UNUserNotificationCenter.current().delegate = notifications
  }
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}

// Системная карточка хранит только случайный ключ защищённой локальной цели.
final class NotificationActivation: NSObject, UNUserNotificationCenterDelegate {
  private var channel: FlutterMethodChannel?
  private var pending = ""
  private var ready = false

  static func valid(_ token: String) -> Bool {
    token.utf8.count == 32 && token.utf8.allSatisfy {
      (48...57).contains($0) || (97...102).contains($0)
    }
  }

  func attach(_ messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: "space/notification-activation", binaryMessenger: messenger)
    self.channel = channel
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else { return }
      let center = UNUserNotificationCenter.current()
      switch call.method {
      case "initialize": result(nil)
      case "permission":
        center.requestAuthorization(options: [.alert]) { allowed, _ in
          DispatchQueue.main.async { result(allowed) }
        }
      case "initial":
        result(self.start())
      case "show": self.show(call.arguments, result)
      case "clear":
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
        result(nil)
      default: result(FlutterMethodNotImplemented)
      }
    }
  }

  private func show(_ arguments: Any?, _ result: @escaping FlutterResult) {
    guard let args = arguments as? [String: Any],
          let token = args["token"] as? String, Self.valid(token),
          let tag = args["tag"] as? String, tag.count <= 16,
          let title = args["title"] as? String,
          let body = args["body"] as? String else {
      result(FlutterError(code: "notification", message: "Invalid notification", details: nil))
      return
    }
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.userInfo = ["token": token]
    let request = UNNotificationRequest(identifier: "space-" + tag, content: content, trigger: nil)
    let center = UNUserNotificationCenter.current()
    center.getDeliveredNotifications { delivered in
      let oldest = delivered.sorted { $0.date < $1.date }
      let remove = max(0, oldest.count - 63)
      center.removeDeliveredNotifications(withIdentifiers: oldest.prefix(remove).map { $0.request.identifier })
      center.add(request) { error in
        DispatchQueue.main.async {
          if let error = error {
            result(FlutterError(code: "notification", message: error.localizedDescription, details: nil))
          } else {
            result(nil)
          }
        }
      }
    }
  }

  func receive(_ token: String) {
    guard Self.valid(token) else { return }
    if ready {
      channel?.invokeMethod("activate", arguments: token)
    } else {
      pending = token
    }
  }

  func start() -> String {
    ready = true
    let token = pending
    pending = ""
    return token
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
      didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    let token = response.notification.request.content.userInfo["token"] as? String
    DispatchQueue.main.async {
      if response.actionIdentifier == UNNotificationDefaultActionIdentifier, let token = token {
        self.receive(token)
        NSApp.activate(ignoringOtherApps: true)
      }
      completionHandler()
    }
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
      willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert])
  }
}
