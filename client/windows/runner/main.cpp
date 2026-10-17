#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>
#include <roapi.h>

#include "flutter_window.h"
#include "utils.h"
#include "notification_activation.h"

// GetMessage возвращает -1 при ошибке, 0 при завершении и >0 для сообщения.
static int RunMessageLoop() {
  MSG message{};
  while (true) {
    const BOOL message_status = ::GetMessage(&message, nullptr, 0, 0);
    if (message_status == -1) return EXIT_FAILURE;
    if (message_status == 0) return EXIT_SUCCESS;
    ::TranslateMessage(&message);
    ::DispatchMessage(&message);
  }
}

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::RoInitialize(RO_INIT_SINGLETHREADED);

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();
  const auto activation = NotificationActivation::Parse(command_line_arguments);
  const HANDLE instance_mutex = NotificationActivation::InstanceMutex();
  if (!instance_mutex) return EXIT_FAILURE;
  if (GetLastError() == ERROR_ALREADY_EXISTS) {
    for (int attempt = 0; attempt < 100; ++attempt) {
      if (NotificationActivation::Forward(activation)) {
        CloseHandle(instance_mutex);
        ::RoUninitialize();
        return EXIT_SUCCESS;
      }
      Sleep(100);
    }
    CloseHandle(instance_mutex);
    ::RoUninitialize();
    return EXIT_FAILURE;
  }

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project, activation);
  Win32Window::Point origin(10, 10);
  Win32Window::Size size(1024, 1024);
  if (!window.Create(L"Space", origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  const int exit_code = RunMessageLoop();

  CloseHandle(instance_mutex);
  ::RoUninitialize();
  return exit_code;
}
