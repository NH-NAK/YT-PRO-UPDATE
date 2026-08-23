; YT-Downloader Pro Inno Setup 6 Script
; Use Inno Setup 6 Compiler (ISCC) to compile this file to setup.exe

[Setup]
AppName=YT-Downloader Pro
AppVersion=1.0.3
AppPublisher=NH-NAK
DefaultDirName={localappdata}\Programs\YTDownloaderPro
DefaultGroupName=YT-Downloader Pro
OutputDir=.
OutputBaseFilename=YTDownloaderProSetup
SetupIconFile=ui\youtube.ico
Compression=lzma2
SolidCompression=yes
PrivilegesRequired=lowest
DisableWelcomePage=no
DisableDirPage=yes
DisableProgramGroupPage=yes
DisableReadyPage=no
WizardStyle=modern

[Icons]
Name: "{group}\YT-Downloader Pro"; Filename: "{app}\main.exe"; IconFilename: "{app}\main.exe"
Name: "{userdesktop}\YT-Downloader Pro"; Filename: "{app}\main.exe"; IconFilename: "{app}\main.exe"

[Code]
var
  DownloadPage: TDownloadWizardPage;

procedure InitializeWizard();
begin
  // Create native download page with progress bar
  DownloadPage := CreateDownloadPage(
    'Downloading Files', 
    'Please wait while setup downloads the required application files...', 
    nil
  );
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  if CurPageID = wpReady then begin
    DownloadPage.Clear;
    // Download tools.zip containing compiled files directly from GitHub Release (shows 1-100% progress)
    DownloadPage.Add(
      'https://github.com/NH-NAK/YT-PRO-UPDATE/releases/download/FILETOOLSYTPRO/tools.zip', 
      'tools.zip', 
      ''
    );
    DownloadPage.Show;
    try
      DownloadPage.Download;
      Result := True;
    except
      MsgBox(
        'Download failed: ' + GetExceptionMessage + #13#10#13#10 + 
        'Please check your internet connection and try running setup again.', 
        mbError, 
        MB_OK
      );
      Result := False;
    end;
    DownloadPage.Hide;
  end else
    Result := True;
end;

[Run]
; Silent PowerShell command to extract tools.zip directly to install directory
Filename: "powershell.exe"; Parameters: "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command ""Expand-Archive -Path '{tmp}\tools.zip' -DestinationPath '{app}' -Force"""; Flags: runhidden; StatusMsg: "Extracting and installing application files..."

; Option to launch app after installation finishes
Filename: "{app}\main.exe"; Description: "Launch YT-Downloader Pro"; Flags: postinstall nowait skipifsilent
