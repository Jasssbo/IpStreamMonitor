#define MyAppName "AudioStreamMETER"
#define MyAppVersion "2.0.3"
#define MyAppPublisher "Andrea Mazzurana"
#define MyAppExeName "AudioStreamMETER.exe"

; {#SourcePath} è automatico — Inno Setup lo risolve da solo
; basta che dist\ e ffmpeg_bin\ siano nella stessa cartella del .iss
#define SourceApp SourcePath + "dist\AudioStreamMETER"
#define SourceFfmpeg SourcePath + "ffmpeg_bin"

[Setup]
AppId={{B73015F5-B54B-41C0-AAD1-7748A105639C}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL=https://github.com/Jasssbo
AppSupportURL=https://github.com/Jasssbo/AudioStreamMETER/issues
AppUpdatesURL=https://github.com/Jasssbo/AudioStreamMETER/releases

; L'utente sceglie dove installare durante il wizard
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
UninstallDisplayName={#MyAppName}
UninstallDisplayIcon={app}\{#MyAppExeName}

ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=admin
MinVersion=10.0

; Output nella cartella Output\ accanto al .iss — relativo e automatico
OutputDir={#SourcePath}Output
OutputBaseFilename=AudioStreamMETER_installer

; License agreement - user must accept before installing
LicenseFile={#SourcePath}\LICENSE

Compression=lzma
SolidCompression=no
WizardStyle=modern
AppMutex=AudioStreamMETERMutex
UninstallDisplaySize=150000000

[Languages]
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"

[CustomMessages]
italian.CreateStartMenu=Crea collegamento nel Menu Start
english.CreateStartMenu=Create Start Menu shortcut

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"
Name: "startmenuicon"; Description: "{cm:CreateStartMenu}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: "{#SourceApp}\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#SourceApp}\_internal\*"; DestDir: "{app}\_internal"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#SourceFfmpeg}\ffmpeg.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#SourceFfmpeg}\ffplay.exe"; DestDir: "{app}"; Flags: ignoreversion

[Dirs]
Name: "{app}\logs"

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: startmenuicon
Name: "{group}\Disinstalla {#MyAppName}"; Filename: "{uninstallexe}"; Tasks: startmenuicon
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#MyAppName}}"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "taskkill"; Parameters: "/F /IM {#MyAppExeName}"; Flags: runhidden nowait; RunOnceId: "KillApp"
[UninstallDelete]
Type: filesandordirs; Name: "{app}\logs"

[Code]
function InitializeSetup(): Boolean;
begin
  Result := True;
  if not IsWin64 then
  begin
    MsgBox(
      'Questo programma richiede Windows 10 a 64 bit o superiore.',
      mbError, MB_OK
    );
    Result := False;
  end;
end;