program LittleLimboLauncher;

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {form_mainform},
  LaunchMethod in 'LaunchMethod.pas',
  MainMethod in 'MainMethod.pas',
  Log4Delphi in 'Log4Delphi.pas',
  BackgroundMethod in 'BackgroundMethod.pas',
  LanguageMethod in 'LanguageMethod.pas',
  MyCustomWindow in 'MyCustomWindow.pas',
  AccountMethod in 'AccountMethod.pas',
  DownloadMethod in 'DownloadMethod.pas',
  DownloadProgressForm in 'DownloadProgressForm.pas' {form_progress};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tform_mainform, form_mainform);
  Application.CreateForm(Tform_progress, form_progress);
  Application.Run;
end.
