unit LaunchMethod;

interface

uses
  SysUtils, Classes, Windows, IOUtils, StrUtils, JSON;

function GetMCRealPath(path, suffix: string): String;
function GetMCInheritsFrom(selpath, inheritsorjar: String): String;

implementation

uses
  MainMethod;
// 获取MC的真实文件路径。
function GetMCRealPath(path, suffix: string): String;
var
  Files: TArray<String>;
begin
  result := '';
  if DirectoryExists(path) then begin // 判断文件夹是否存在
    Files := TDirectory.GetFiles(path); // 找到所有文件
    for var I in Files do begin // 遍历文件
      if I.IndexOf(suffix) <> -1 then begin // 是否符合条件
        if suffix = '.json' then begin
          var god := GetFile(I);
          try
            var Root := TJsonObject.ParseJSONValue(god) as TJsonObject;
            var tmp := Root.GetValue('libraries').ToString;
            var ttt := Root.GetValue('mainClass').Value;
            result := I;
            exit;
          except
            continue;
          end;
        end else begin
          result := I;
          exit;
        end;
      end;
    end;
  end;
end;
//获取MC的InheritsFrom或jar键，所对应的MC文件夹。【如果MC不存在InheritsFrom或jar键，则返回原本参数值。如果找不到Json文件，则返回空。如果找到了InheritsFrom键但是却找不到原本的文件夹，则也同样返回空。当一切都满足的时候，则返回找到后的Json文件地址。】
function GetMCInheritsFrom(selpath, inheritsorjar: String): String;
var
  Dirs: TArray<String>;
  Files: TArray<String>;
begin
  result := '';
  if DirectoryExists(selpath) then begin
    var ph := GetMCRealPath(selpath, '.json');
    if FileExists(ph) then begin
      var Rt := TJsonObject.ParseJSONValue(GetFile(ph)) as TJsonObject;
      try
        var ihtf := Rt.GetValue(inheritsorjar).Value;
        if ihtf = '' then raise Exception.Create('Judge Json Error');
        var vdir := ExtractFileDir(selpath);
        Dirs := TDirectory.GetDirectories(vdir);
        for var I in Dirs do begin
          Files := TDirectory.GetFiles(I);
          for var J in Files do begin
            if RightStr(J, 5) = '.json' then begin
              try
                var Rt2 := TJsonObject.ParseJSONValue(GetFile(J)) as TJsonObject;
                var jid := Rt2.GetValue('id').Value;
                var tmp := Rt2.GetValue('libraries').ToString;
                var ttt := Rt2.GetValue('mainClass').Value;
                if jid = ihtf then begin
                  result := I;
                  exit;
                end;
                continue;
              except
                continue;
              end;
            end;
          end;
        end;
      except
        result := selpath;
        if inheritsorjar = 'jar' then result := '';
      end;
    end;
  end;
end;
end.

