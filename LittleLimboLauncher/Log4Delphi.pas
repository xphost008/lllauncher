unit Log4Delphi;

interface

uses
  System.DateUtils, System.Classes, Winapi.Windows, System.SysUtils, Vcl.Forms,
  Vcl.Dialogs;

type
  Log4D = class
  public
    procedure Write(text: String; MB: Integer);
    procedure WriteWithoutTime(text: String);
    constructor Create; overload;
  private
    pah: String;
  end;

const
  LOG_INFO = 1;
  LOG_QUESTION = 2;
  LOG_WARNING = 3;
  LOG_ERROR = 4;

var
  FileStr: String;
  filesize: Integer;

implementation

uses MainForm;

procedure Log4D.Write(text: String; MB: Integer);
var
  fe: TextFile;
begin
  var tdd := '';
  case MB of
    1: tdd := 'INFO';
    2: tdd := 'QUESTION';
    3: tdd := 'WARNING';
    4: tdd := 'ERROR';
    else raise Exception.Create('Read Log Stream Error');
  end;
  var FileStr := Concat('[', Now.Format('yyyy/mm/dd HH:nn:ss'), ']', '[Thread/', tdd, '] ', text);
  try
    AssignFile(fe, pah);
    if FileExists(pah) then begin
      Append(fe);
    end else begin
      Rewrite(fe);
    end;
    writeln(fe, FileStr);
  finally
    CloseFile(fe);
  end;
end;
procedure Log4D.WriteWithoutTime(text: String);
var
  fe: TextFile;
begin
  if FileStr <> '' then begin
    FileStr := Concat(FileStr, #13#10, text);
  end else FileStr := text;
  try
    AssignFile(fe, pah);
    if FileExists(pah) then begin
      Append(fe);
    end else begin
      Rewrite(fe);
    end;
    writeln(fe, FileStr);
  finally
    CloseFile(fe);
  end;
end;
constructor Log4D.Create;
begin
  if not DirectoryExists(Concat(ExtractFilePath(Application.ExeName), 'LLLauncher\Logs')) then
    ForceDirectories(Concat(ExtractFilePath(Application.ExeName), 'LLLauncher\Logs'));
  var tmr := Now.Format('yyyy-mm-dd_HH.nn.ss');
  pah := Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\Logs\Log-', tmr, '.txt');
end;

end.

