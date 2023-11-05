unit LauncherMethod;

interface

uses
  SysUtils, Classes, Windows, IOUtils, StrUtils, JSON, Zip, Forms, IniFiles;

function GetMCRealPath(path, suffix: string): String;
function GetMCInheritsFrom(selpath, inheritsorjar: String): String;
function ReplaceMCInheritsFrom(yuanjson, gaijson: String): String;
function ConvertNameToPath(name: String): String;
function Unzip(zippath, extpath: String): Boolean;
function JudgeIsolation: String;

implementation

uses
  MainMethod, MainForm;
function JudgeIsolation: String;
begin
  var ret: Boolean;
  var mcsc := strtoint(LLLini.ReadString('MC', 'SelectMC', '')) - 1;
  var mcct := GetFile(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\', 'MCJson.json'));
  { 此为MC未隔路径 }var mccp := (((TJsonObject.ParseJSONValue(mcct) as TJsonObject).GetValue('mc') as TJsonArray)[mcsc] as TJsonObject).GetValue('path').Value;
  var mcsn := strtoint(LLLini.ReadString('MC', 'SelectVer', '')) - 1;
  var mcnt := GetFile(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\', 'MCSelJson.json'));
  { 此为MC隔离路径 }var msph := (((TJsonObject.ParseJSONValue(mcnt) as TJsonObject).GetValue('mcsel') as TJsonArray)[mcsn] as TJsonObject).GetValue('path').Value;
  var mcyj := GetFile(GetMCRealPath(msph, '.json'));
  var iii := LLLini.ReadString('Version', 'SelectIsolation', ''); //以下为判断原版，如果是原版，则返回true，如果不是则返回false。
  var pand: Boolean := (mcyj.IndexOf('com.mumfrey:liteloader:') <> -1) or (mcyj.IndexOf('org.quiltmc:quilt-loader:') <> -1) or (mcyj.IndexOf('net.fabricmc:fabric-loader:') <> -1) or (mcyj.IndexOf('forge') <> -1);
  if iii = '4' then ret := true
  else if iii = '2' then begin
    if not pand then ret := true
    else ret := false;
  end else if iii = '3' then begin
    if pand then ret := true
    else ret := false;
  end else ret := false;
  var IltIni := TIniFile.Create(Concat(msph, '\LLLauncher.ini'));
  if IltIni.ReadString('Isolation', 'IsIsolation', '').ToLower = 'true' then
    if IltIni.ReadString('Isolation', 'Partition', '').ToLower = 'true' then
      ret := true;
  if ret then result := msph else result := mccp;
end;
//解压Zip
function Unzip(zippath, extpath: String): Boolean;
begin
  result := false;
  if not DirectoryExists(extpath) then ForceDirectories(extpath);
  if not FileExists(zippath) then begin result := false; exit; end;
  var zp := TZipFile.Create;
  try
    try
      zp.Open(zippath, zmRead); //打开压缩包
      zp.ExtractAll(extpath); //解压压缩包
      result := true;
    except end;
  finally
    zp.Free;
  end;
end;
// 将名称转换成路径 （此方法简称，把json中的name文件转换成path的格式。）
function ConvertNameToPath(name: String): String;
begin //重新再再再再写一遍。。
  var all := TStringList.Create;
  var sb := TStringBuilder.Create;
  try
    var hou: TArray<String> := SplitString(name, '@'); //先按照@切割一遍
    name := hou[0];
    var n1 := name.Substring(0, name.IndexOf(':'));
    var n2 := name.Substring(name.IndexOf(':') + 1, name.Length);
    var c1 := SplitString(n1, '.');
    for var I in c1 do all.Add(Concat(I, '\'));
    var c2: TArray<String> := SplitString(n2, ':');
    for var I := 0 to Length(c2) - 1 do begin
      if Length(c2) >= 3 then begin
        if I < Length(c2) - 1 then begin
          all.Add(Concat(c2[I], '\'));
        end;
      end else all.Add(Concat(c2[I], '\'));
    end;
    for var I := 0 to Length(c2) - 1 do begin
      if I < Length(c2) - 1 then begin
        all.Add(Concat(c2[I], '-'));
      end else begin
        try
          all.Add(Concat(c2[I], '.', hou[1]))
        except
          all.Add(Concat(c2[I], '.jar'));
        end;
      end;
    end;
    for var I in all do sb.Append(I);
    result := sb.ToString;
  finally
    all.Free;
    sb.Free;
  end;
end;
//反馈给程序——将原来的MCJson与有着InheritsFrom键的JSON给合并之后再返回。
function ReplaceMCInheritsFrom(yuanjson, gaijson: String): String;
begin
  if yuanjson = '' then begin result := ''; exit; end;  //如果任意一个json为空，则返回空。
  if gaijson = '' then begin result := ''; exit; end;
  if yuanjson = gaijson then begin result := yuanjson; exit; end; //如果两个json一样，则返回原值。
  yuanjson := yuanjson.Replace('\', '');
  gaijson := gaijson.Replace('\', '');
  var Rty := TJsonObject.ParseJSONValue(yuanjson) as TJsonObject;
  var Rtg := TJsonObject.ParseJSONValue(gaijson) as TJsonObject;
  Rtg.RemovePair('mainClass');
  Rtg.AddPair('mainClass', Rty.GetValue('mainClass').Value);
  Rtg.RemovePair('id');
  Rtg.AddPair('id', Rty.GetValue('id').Value);
  try
    for var I in (Rty.GetValue('libraries') as TJsonArray) do
      (Rtg.GetValue('libraries') as TJsonArray).Add(I as TJsonObject);
  except end;
  try
    for var I in ((Rty.GetValue('arguments') as TJsonObject).GetValue('jvm') as TJsonArray) do
      ((Rtg.GetValue('arguments') as TJsonObject).GetValue('jvm') as TJsonArray).Add(I.Value);
  except end;
  try
    for var I in ((Rty.GetValue('arguments') as TJsonObject).GetValue('game') as TJsonArray) do begin
      ((Rtg.GetValue('arguments') as TJsonObject).GetValue('game') as TJsonArray).Add(I.Value);
    end;
  except end;
  try
    var ma := Rty.GetValue('minecraftArguments').Value;
    Rtg.RemovePair('minecraftArguments');
    Rtg.AddPair('minecraftArguments', ma);
  except end;
  result := Rtg.ToString;
end;
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

