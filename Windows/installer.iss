#define MyAppName "HTTP-StreamMonitor"
#define MyAppVersion "0.1"
#define MyAppPublisher "Andrea Mazzurana"
#define MyAppExeName "HTTP-StreamMonitor.exe"

; {#SourcePath} è automatico — Inno Setup lo risolve da solo
; basta che dist\ e ffmpeg_bin\ siano nella stessa cartella del .iss
#define SourceApp SourcePath + "dist\StreamMonitor"
#define SourceFfmpeg SourcePath + "ffmpeg_bin"
#define SourceMetering SourcePath + "metering_standards"

[Setup]
AppId={{B73015F5-B54B-41C0-AAD1-7748A105639C}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL=https://github.com/Jasssbo
AppSupportURL=https://github.com/Jasssbo/IpAudioStreamMonitor/issues
AppUpdatesURL=https://github.com/Jasssbo/IpAudioStreamMonitor/releases

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
OutputBaseFilename=HTPP-StreamMonitor_installer

Compression=lzma
SolidCompression=no
WizardStyle=modern
AppMutex=IPStreamMonitorMutex
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
Source: "{#SourceMetering}\*"; DestDir: "{app}\metering_standards"; Flags: ignoreversion recursesubdirs createallsubdirs

[Dirs]
Name: "{app}\presets"
Name: "{app}\metering_standards"
Name: "{app}\logs"

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: startmenuicon
Name: "{group}\Disinstalla {#MyAppName}"; Filename: "{uninstallexe}"; Tasks: startmenuicon
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Registry]
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; ValueType: expandsz; ValueName: "Path"; ValueData: "{olddata};{app}"; Check: NeedsAddPath('{app}'); Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\{#MyAppPublisher}\{#MyAppName}"; ValueType: string; ValueName: "InstallPath"; ValueData: "{app}"; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\{#MyAppPublisher}\{#MyAppName}"; ValueType: string; ValueName: "Version"; ValueData: "{#MyAppVersion}"; Flags: uninsdeletekey

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#MyAppName}}"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "taskkill"; Parameters: "/F /IM {#MyAppExeName}"; Flags: runhidden nowait; RunOnceId: "KillApp"
[UninstallDelete]
Type: filesandordirs; Name: "{app}\logs"
Type: dirifempty; Name: "{app}\presets"

[Code]
var
  StartMenuPage: TInputQueryWizardPage;

procedure InitializeWizard();
begin
  StartMenuPage := CreateInputQueryPage(
    wpSelectTasks,
    'Collegamento Menu Start',
    'Personalizza il nome del collegamento nel Menu Start',
    ''
  );
  StartMenuPage.Add('Nome cartella nel Menu Start:', False);
  StartMenuPage.Values[0] := ExpandConstant('{#MyAppName}');
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  StartMenuFolder: string;
  IconPath: string;
begin
  if CurStep = ssPostInstall then
  begin
    if WizardIsTaskSelected('startmenuicon') then  // ← fix warning 2
    begin
      StartMenuFolder := StartMenuPage.Values[0];
      if StartMenuFolder = '' then
        StartMenuFolder := ExpandConstant('{#MyAppName}');
      IconPath := ExpandConstant('{commonprograms}\') + StartMenuFolder;
      ForceDirectories(IconPath);
      CreateShellLink(
        IconPath + '\' + ExpandConstant('{#MyAppName}') + '.lnk',
        ExpandConstant('{#MyAppName}'),
        ExpandConstant('{app}\{#MyAppExeName}'),
        '', '', '', 0, SW_SHOWNORMAL
      );
    end;
  end;
end;

function NeedsAddPath(Param: string): boolean;
var
  OrigPath: string;
begin
  if not RegQueryStringValue(
    HKLM,
    'SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
    'Path', OrigPath)
  then begin
    Result := True;
    exit;
  end;
  Result := Pos(';' + Param + ';', ';' + OrigPath + ';') = 0;
end;

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