#ifndef AppVersion
  #define AppVersion "0.1.0"
#endif
#ifndef AppNumericVersion
  #define AppNumericVersion AppVersion
#endif
[Setup]
AppId={{A1D164D7-8CE9-4FF1-98B7-3D9970218441}
AppName=Space
AppVersion={#AppVersion}
VersionInfoVersion={#AppNumericVersion}
AppPublisher=Space Protocol
AppPublisherURL=https://github.com/space-protocol-project/space-protocol
DefaultDirName={localappdata}\Programs\Space
DefaultGroupName=Space
PrivilegesRequired=lowest
OutputDir=..\dist
OutputBaseFilename=Space-Setup-windows-x64
SetupIconFile=..\client\windows\runner\resources\app_icon.ico
UninstallDisplayIcon={app}\space_client.exe
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
[Languages]
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"
[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"
[Files]
Source: "..\client\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
[Icons]
Name: "{group}\Space"; Filename: "{app}\space_client.exe"
Name: "{autodesktop}\Space"; Filename: "{app}\space_client.exe"; Tasks: desktopicon
[Run]
Filename: "{app}\space_client.exe"; Description: "{cm:LaunchProgram,Space}"; Flags: nowait postinstall skipifsilent
Filename: "{app}\space_client.exe"; Flags: nowait; Check: ShouldRelaunch

[Code]
function ShouldRelaunch: Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 1 to ParamCount do
    if CompareText(ParamStr(I), '/RELAUNCH') = 0 then
      Result := True;
end;
