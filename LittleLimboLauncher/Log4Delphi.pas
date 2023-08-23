unit Log4Delphi;

interface

uses
  System.DateUtils, System.Classes, Winapi.Windows, System.SysUtils, Vcl.Forms,
  Vcl.Dialogs;

type
  Log4D = class
  public
    procedure Write(text: String; MB, LL: Integer);
    procedure WriteWithoutTime(text: String);
    constructor Create; overload;
  private
    pah: String;
  end;

const // Log信息框输出
  LOG_INFO = 1;
  LOG_QUESTION = 2;
  LOG_WARNING = 3;
  LOG_ERROR = 4;
const // Log内部输出
  LOG_LAUNCH = 1;
  LOG_LOAD = 2;
  LOG_START = 3;
  LOG_ACCOUNT = 4;
var
  FileStr: String;
  filesize: Integer;

implementation

uses MainForm;

procedure Log4D.Write(text: String; MB, LL: Integer);
var
  fe: TextFile;
begin
  var tdd := '';
  var tdt := '';
  case MB of
    1: tdd := 'INFO';
    2: tdd := 'QUESTION';
    3: tdd := 'WARNING';
    4: tdd := 'ERROR';
    else raise Exception.Create('Read Log Stream Error');
  end;
  case LL of
    1: tdt := 'Launch';
    2: tdt := 'Load';
    3: tdt := 'Start';
    4: tdt := 'Account';
  end;
  var FileStr := Concat('[', Now.Format('yyyy/mm/dd HH:nn:ss'), ']', '[', tdt, '/', tdd, '] ', text);
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
var
  pph: String;
begin
  pph := Concat(ExtractFilePath(Application.ExeName), 'LLLauncher\Logs');
  if not DirectoryExists(pph) then
    ForceDirectories(pph);
  deleteFile(Concat(pph, '\latest.log'));
  pah := Concat(pph, '\latest.log');
end;

end.

