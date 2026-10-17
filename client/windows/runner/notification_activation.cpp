#include "notification_activation.h"

#include <flutter/standard_method_codec.h>
#include <winrt/Windows.Foundation.h>
#include <winrt/Windows.Data.Xml.Dom.h>
#include <winrt/Windows.UI.Notifications.h>
#include <algorithm>
#include <cwctype>
#include "utils.h"

namespace {
using flutter::EncodableValue;
using flutter::EncodableMap;
constexpr wchar_t kScheme[] = L"Software\\Classes\\space-notification";

bool ValidToken(const std::string& token) {
  return token.size() == 32 &&
      std::all_of(token.begin(), token.end(), [](char c) {
        return (c >= '0' && c <= '9') || (c >= 'a' && c <= 'f');
      });
}

std::wstring Executable() {
  std::wstring path(32768, L'\0');
  const DWORD size = GetModuleFileNameW(nullptr, path.data(),
                                       static_cast<DWORD>(path.size()));
  if (size == 0 || size >= path.size()) return {};
  path.resize(size);
  return path;
}

void RegistryString(HKEY key, const wchar_t* name, const std::wstring& value) {
  const auto status = RegSetValueExW(key, name, 0, REG_SZ,
      reinterpret_cast<const BYTE*>(value.c_str()),
      static_cast<DWORD>((value.size() + 1) * sizeof(wchar_t)));
  winrt::check_win32(status);
}

void RegisterProtocol() {
  const auto path = Executable();
  if (path.empty()) throw winrt::hresult_error(E_FAIL);
  HKEY raw = nullptr;
  winrt::check_win32(RegCreateKeyExW(HKEY_CURRENT_USER, kScheme, 0, nullptr,
      0, KEY_SET_VALUE | KEY_CREATE_SUB_KEY, nullptr, &raw, nullptr));
  struct CloseKey { HKEY value; ~CloseKey() { RegCloseKey(value); } } root{raw};
  RegistryString(raw, nullptr, L"URL:Space notification");
  RegistryString(raw, L"URL Protocol", L"");
  HKEY command = nullptr;
  winrt::check_win32(RegCreateKeyExW(raw, L"shell\\open\\command", 0,
      nullptr, 0, KEY_SET_VALUE, nullptr, &command, nullptr));
  CloseKey close_command{command};
  RegistryString(command, nullptr, L"\"" + path + L"\" \"%1\"");
}

std::string Field(const EncodableMap& args, const char* key) {
  return std::get<std::string>(args.at(EncodableValue(key)));
}

void ShowToast(const EncodableMap& args) {
  using namespace winrt::Windows::UI::Notifications;
  const auto token = Field(args, "token");
  if (!ValidToken(token)) throw winrt::hresult_invalid_argument();
  RegisterProtocol();
  winrt::Windows::Data::Xml::Dom::XmlDocument document;
  document.LoadXml(L"<toast activationType='protocol'><visual>"
      L"<binding template='ToastGeneric'><text/><text/></binding>"
      L"</visual><audio silent='true'/></toast>");
  document.DocumentElement().SetAttribute(L"launch",
      winrt::to_hstring("space-notification:" + token));
  const auto texts = document.GetElementsByTagName(L"text");
  texts.Item(0).AppendChild(document.CreateTextNode(winrt::to_hstring(Field(args, "title"))));
  texts.Item(1).AppendChild(document.CreateTextNode(winrt::to_hstring(Field(args, "body"))));
  ToastNotification toast(document);
  toast.Tag(winrt::to_hstring(Field(args, "tag")));
  toast.Group(L"messages");
  toast.ExpirationTime(winrt::clock::now() + std::chrono::hours(24 * 7));
  ToastNotificationManager::CreateToastNotifier(winrt::to_hstring(Field(args, "appId"))).Show(toast);
}

struct ForwardData { std::string token; std::wstring executable; bool delivered = false; };
BOOL CALLBACK ForwardWindow(HWND window, LPARAM param) {
  auto& data = *reinterpret_cast<ForwardData*>(param);
  wchar_t class_name[128]{};
  GetClassNameW(window, class_name, 128);
  if (wcscmp(class_name, L"FLUTTER_RUNNER_WIN32_WINDOW") != 0) return TRUE;
  DWORD pid = 0;
  GetWindowThreadProcessId(window, &pid);
  HANDLE process = OpenProcess(PROCESS_QUERY_LIMITED_INFORMATION, FALSE, pid);
  if (!process) return TRUE;
  wchar_t path[32768]{};
  DWORD size = 32768;
  const BOOL read = QueryFullProcessImageNameW(process, 0, path, &size);
  CloseHandle(process);
  if (!read || _wcsicmp(path, data.executable.c_str()) != 0) return TRUE;
  if (data.token.empty()) {
    ShowWindowAsync(window, SW_RESTORE);
    SetForegroundWindow(window);
    data.delivered = true;
    return FALSE;
  }
  COPYDATASTRUCT copy{NotificationActivation::kCopyData,
      static_cast<DWORD>(data.token.size() + 1), data.token.data()};
  DWORD_PTR result = 0;
  data.delivered = SendMessageTimeoutW(window, WM_COPYDATA, 0,
      reinterpret_cast<LPARAM>(&copy), SMTO_ABORTIFHUNG, 2000, &result) && result == 1;
  return data.delivered ? FALSE : TRUE;
}
}  // namespace

NotificationActivation::NotificationActivation(flutter::BinaryMessenger* messenger)
    : channel_(std::make_unique<flutter::MethodChannel<EncodableValue>>(
          messenger, "space/notification-activation",
          &flutter::StandardMethodCodec::GetInstance())) {
  channel_->SetMethodCallHandler([this](const auto& call, auto result) {
    try {
      if (call.method_name() == "initial") {
        ready_ = true;
        result->Success(EncodableValue(pending_));
        pending_.clear();
      } else if (call.method_name() == "show") {
        ShowToast(std::get<EncodableMap>(*call.arguments()));
        result->Success();
      } else if (call.method_name() == "clear") {
        const auto& args = std::get<EncodableMap>(*call.arguments());
        winrt::Windows::UI::Notifications::ToastNotificationManager::History().Clear(
            winrt::to_hstring(Field(args, "appId")));
        result->Success();
      } else {
        result->NotImplemented();
      }
    } catch (...) {
      result->Error("notification", "Notification activation failed");
    }
  });
}

void NotificationActivation::Receive(const std::string& token) {
  if (!ValidToken(token)) return;
  if (!ready_) { pending_ = token; return; }
  channel_->InvokeMethod("activate", std::make_unique<EncodableValue>(token));
}

std::string NotificationActivation::Parse(const std::vector<std::string>& arguments) {
  constexpr char prefix[] = "space-notification:";
  if (arguments.size() != 1 || arguments[0].rfind(prefix, 0) != 0) return {};
  const auto token = arguments[0].substr(sizeof(prefix) - 1);
  return ValidToken(token) ? token : std::string();
}

bool NotificationActivation::Forward(const std::string& token) {
  if (!token.empty() && !ValidToken(token)) return false;
  ForwardData data{token, Executable(), false};
  EnumWindows(ForwardWindow, reinterpret_cast<LPARAM>(&data));
  return data.delivered;
}

HANDLE NotificationActivation::InstanceMutex() {
  unsigned long long hash = 14695981039346656037ull;
  for (const auto c : Executable()) {
    hash ^= static_cast<unsigned long long>(towlower(c));
    hash *= 1099511628211ull;
  }
  const auto name = L"Local\\Space.Notification." + std::to_wstring(hash);
  return CreateMutexW(nullptr, FALSE, name.c_str());
}
