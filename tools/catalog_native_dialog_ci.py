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
    project = Path('client/macos/Runner.xcodeproj/project.pbxproj')
    source = project.read_text()
    assert 'com.apple.product-type.bundle.unit-test' in source
    source = source.replace('com.apple.product-type.bundle.unit-test', 'com.apple.product-type.bundle.ui-testing')
    source = source.replace('BUNDLE_LOADER = "$(TEST_HOST)";', 'TEST_TARGET_NAME = Runner; OTHER_LDFLAGS = ""; LD_RUNPATH_SEARCH_PATHS = ("$(inherited)", "$(BUILT_PRODUCTS_DIR)/Space.app/Contents/Frameworks");')
    source = source.replace('TEST_HOST = "$(BUILT_PRODUCTS_DIR)/Space.app/Contents/MacOS/Space";', '')
    project.write_text(source)
    config = Path(os.environ['RUNNER_TEMP']) / 'catalog-focus-xctest.json'
    Path('client/macos/RunnerTests/RunnerTests.swift').write_text(Path('tools/catalog_focus_ui.swift').read_text().replace('__CONFIG__', str(config)))
    insert('client/macos/Runner/MainFlutterWindow.swift','    super.awakeFromNib()', '''
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      NSApp.activate(ignoringOtherApps: true)
      self.makeKeyAndOrderFront(nil)
    }
''')
else:
    assert os.name == 'nt'
    insert('client/windows/runner/flutter_window.cpp','    this->Show();', '''
    SetTimer(GetHandle(), 9874, 1400, [](HWND window, UINT, UINT_PTR timer, DWORD) {
      KillTimer(window, timer);
      ShowWindow(window, SW_MINIMIZE);
      SetTimer(window, 9875, 1000, [](HWND target, UINT, UINT_PTR restore, DWORD) {
        KillTimer(target, restore);
        ShowWindow(target, SW_RESTORE);
        SetActiveWindow(target);
        SetForegroundWindow(target);
        SetFocus(GetWindow(target, GW_CHILD));
      });
    });
''')
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
