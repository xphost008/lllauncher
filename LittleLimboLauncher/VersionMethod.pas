unit VersionMethod;

interface

uses
  SysUtils, Windows, Forms, JSON;

procedure InitVersion;

implementation

//初始化版本部分
var f: Boolean = false;
procedure InitVersion;
begin
  if f then exit;
  f := true;

end;
//保存版本部分
procedure SaveVersion;
begin

end;

end.
