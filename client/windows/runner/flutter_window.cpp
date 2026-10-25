#include "flutter_window.h"

#include <optional>
#include <flutter/standard_method_codec.h>

#include "flutter/generated_plugin_registrant.h"

namespace {
std::optional<unsigned int> ThemeColor(const flutter::EncodableMap& args, const char* key) {
  const auto item = args.find(flutter::EncodableValue(key));
  if (item == args.end()) return std::nullopt;
  if (const auto value = std::get_if<int64_t>(&item->second)) {
    if (*value >= 0 && *value <= 0xFFFFFFFFLL) return static_cast<unsigned int>(*value);
  }
  if (const auto value = std::get_if<int32_t>(&item->second)) {
    if (*value >= 0) return static_cast<unsigned int>(*value);
  }
  return std::nullopt;
}
}  // namespace

FlutterWindow::FlutterWindow(const flutter::DartProject& project,
                             const std::string& activation)
    : project_(project), activation_(activation) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());
  theme_channel_ = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
      flutter_controller_->engine()->messenger(), "space/window-theme",
      &flutter::StandardMethodCodec::GetInstance());
  theme_channel_->SetMethodCallHandler([this](const auto& call, auto result) {
    if (call.method_name() != "set") { result->NotImplemented(); return; }
    const auto* args = call.arguments() ? std::get_if<flutter::EncodableMap>(call.arguments()) : nullptr;
    if (!args) { result->Error("arguments", "Некорректная тема окна"); return; }
    const auto dark_item = args->find(flutter::EncodableValue("dark"));
    const auto* dark = dark_item == args->end() ? nullptr : std::get_if<bool>(&dark_item->second);
    const auto background = ThemeColor(*args, "background");
    const auto foreground = ThemeColor(*args, "foreground");
    if (!dark || !background || !foreground) { result->Error("arguments", "Некорректные цвета окна"); return; }
    SetAppTheme(*dark, *background, *foreground);
    result->Success();
  });
  notifications_ = std::make_unique<NotificationActivation>(
      flutter_controller_->engine()->messenger());
  notifications_->Receive(activation_);
  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  flutter_controller_->engine()->SetNextFrameCallback([&]() {
    this->Show();
  });

  // Flutter can complete the first frame before the "show window" callback is
  // registered. The following call ensures a frame is pending to ensure the
  // window is shown. It is a no-op if the first frame hasn't completed yet.
  flutter_controller_->ForceRedraw();

  return true;
}

void FlutterWindow::OnDestroy() {
  theme_channel_ = nullptr;
  notifications_ = nullptr;
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  if (message == WM_COPYDATA && notifications_) {
    const auto* data = reinterpret_cast<const COPYDATASTRUCT*>(lparam);
    if (data && data->dwData == NotificationActivation::kCopyData &&
        data->cbData == 33 && data->lpData) {
      const auto* token = static_cast<const char*>(data->lpData);
      if (token[32] == '\0') {
        notifications_->Receive(std::string(token, 32));
        return 1;
      }
    }
    return 0;
  }
  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  if (message == WM_FONTCHANGE && flutter_controller_) {
    flutter_controller_->engine()->ReloadSystemFonts();
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}
