unit LaunchMethod;

interface

uses
  Vcl.Controls, JSON, Windows, Math, SysUtils, Forms;

var
  mwindow_width, mwindow_height, mmax_memory: Integer;
  mjava_path, mcustom_info, mwindow_title: String;
  mpre_script, mafter_script, madd_jvm, madd_game: String;
  JavaJSON: TJSONObject;

procedure InitLaunch;
procedure SaveLaunch;

implementation

uses
  MainForm, MainMethod;
//初始化启动设置界面
var f: Boolean = false;
procedure InitLaunch;
var
  status: TMemoryStatus;
begin
  if f then exit;
  f := true;
  JavaJSON := TJSONObject.Create;
  form_mainform.scrollbar_launch_window_width.Max := GetSystemMetrics(SM_CXSCREEN);
  form_mainform.scrollbar_launch_window_height.Max := GetSystemMetrics(SM_CYSCREEN);
  GlobalMemoryStatus(status);
  form_mainform.scrollbar_launch_game_memory.Max := ceil(status.dwTotalPhys / 1024 / 1024);
  if not FileExists(Concat(ExtractFilePath(Application.ExeName), 'LLLauncher\configs\JavaJson.json')) then begin
    JavaJson.AddPair('java', TJsonArray.Create);
    var j := JavaJson.Format;
    SetFile(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\JavaJson.json'), j);
  end else begin
    var j := GetFile(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\', 'JavaJson.json'));
    JavaJson := TJsonObject.ParseJSONValue(j) as TJsonObject;
  end;
end;
//保存启动设置
procedure SaveLaunch;
begin

end;

end.

