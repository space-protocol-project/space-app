"""Драйверы настоящих модальных окон, добавляемые только в сборку GitHub CI."""
import os
from pathlib import Path
import sys


def insert(path, needle, addition):
    p = Path(path)
    text = p.read_text(encoding='utf-8')
    assert text.count(needle) == 1, needle
    p.write_text(text.replace(needle, addition + '\n' + needle), encoding='utf-8')


if os.environ.get('GITHUB_ACTIONS') != 'true':
    raise SystemExit('Только CI')
if sys.platform == 'darwin':
    path = 'client/vendor/file_selector_macos/macos/file_selector_macos/Sources/file_selector_macos/FileSelectorPlugin.swift'
    insert(path, '    panelController.display(panel, for: viewProvider.view?.window) { (selection: [URL]?) in', '''
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      guard panel.isVisible && panel.canChooseDirectories else { return }
      NSLog("catalog-ci: visible NSOpenPanel")
      NSApp.deactivate()
      NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.finder").first?.activate(options: [.activateIgnoringOtherApps])
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        NSApp.activate(ignoringOtherApps: true)
        panel.makeKeyAndOrderFront(nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { panel.ok(nil) }
      }
    }
''')
    insert('client/macos/Runner/MainFlutterWindow.swift','    super.awakeFromNib()', '''
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      NSApp.activate(ignoringOtherApps: true)
      self.makeKeyAndOrderFront(nil)
    }
''')
else:
    assert os.name == 'nt'
    path = 'client/vendor/file_selector_windows/windows/file_dialog_controller.cpp'
    insert(path, 'HRESULT FileDialogController::Show(HWND parent)', '''
static BOOL CALLBACK SubmitFolder(HWND hwnd, LPARAM timer) {
  wchar_t type[128] = {};
  GetClassNameW(hwnd, type, 128);
  HWND button = GetDlgItem(hwnd, IDOK);
  if (wcscmp(type, L"#32770") || !IsWindowVisible(hwnd) || !IsWindowEnabled(button)) return TRUE;
  KillTimer(nullptr, static_cast<UINT_PTR>(timer));
  SetForegroundWindow(hwnd);
  PostMessageW(button, BM_CLICK, 0, 0);
  return FALSE;
}
static void CALLBACK SelectCurrentFolder(HWND, UINT, UINT_PTR timer, DWORD) {
  EnumThreadWindows(GetCurrentThreadId(), SubmitFolder, static_cast<LPARAM>(timer));
}
''')
    insert(path,'  return dialog_->Show(parent);','  SetTimer(nullptr, 0, 1200, SelectCurrentFolder);')
