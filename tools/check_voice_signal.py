"""Compile the native microphone gain/meter test without Flutter or audio devices."""
from pathlib import Path
import os
import subprocess
import sys
import tempfile


def main():
    root = Path(__file__).resolve().parents[1]
    source = root / 'tools/voice_signal_test.cpp'
    with tempfile.TemporaryDirectory(prefix='space-voice-signal-') as directory:
        work = Path(directory)
        if sys.platform == 'win32':
            vswhere = Path(os.environ['ProgramFiles(x86)']) / 'Microsoft Visual Studio/Installer/vswhere.exe'
            studio = subprocess.check_output([str(vswhere), '-latest', '-products', '*', '-requires',
                                             'Microsoft.VisualStudio.Component.VC.Tools.x86.x64',
                                             '-property', 'installationPath'], text=True).strip()
            if not studio:
                raise RuntimeError('Visual Studio C++ not found')
            dev = Path(studio) / 'Common7/Tools/VsDevCmd.bat'
            binary = work / 'test.exe'
            batch = work / 'build.cmd'
            batch.write_text(f'@echo off\ncall "{dev}" -arch=x64 >nul\n'
                             'if errorlevel 1 exit /b 1\n'
                             f'cl /nologo /std:c++17 /EHsc /W4 /WX /Fe:"{binary}" '
                             f'/Fo:"{work / "test.obj"}" "{source}"\n', encoding='utf-8')
            subprocess.run(['cmd', '/d', '/c', str(batch)], check=True, cwd=work)
        else:
            binary = work / 'test'
            subprocess.run(['c++', '-std=c++17', '-Wall', '-Wextra', '-Werror', '-pthread',
                            str(source), '-o', str(binary)], check=True)
        subprocess.run([str(binary)], check=True)
    print('Native microphone gain, clipping, RMS and concurrent access passed')


if __name__ == '__main__':
    main()
