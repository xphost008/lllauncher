program LittleLimboLauncher;

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {form_mainform},
  LaunchMethod in 'LaunchMethod.pas',
  MainMethod in 'MainMethod.pas',
  Log4Delphi in 'Log4Delphi.pas',
  BackgroundMethod in 'BackgroundMethod.pas',
  LanguageMethod in 'LanguageMethod.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tform_mainform, form_mainform);
  Application.Run;
end.
