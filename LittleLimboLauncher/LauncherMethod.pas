unit LauncherMethod;

interface

uses
  SysUtils, Classes, Windows, IOUtils, StrUtils, JSON, Zip, Forms, IniFiles, Math, Character, DateUtils,
  Dialogs, Generics.Collections;

function GetMCRealPath(path, suffix: string): String;
function GetMCInheritsFrom(selpath, inheritsorjar: String): String;
function ReplaceMCInheritsFrom(yuanjson, gaijson: String): String;
function ConvertNameToPath(name: String): String;
function Unzip(zippath, extpath: String): Boolean;
function JudgeIsolation: String;
function IsJSONError(path: String): Boolean;
procedure StartLaunch(isExportArgs: Boolean);

implementation

uses
  MainMethod, MainForm, MyCustomWindow, LanguageMethod, Log4Delphi, AccountMethod;
function JudgeIsolation: String;
begin
  var ret: Boolean;
  var mcsc := LLLini.ReadInteger('MC', 'SelectMC', -1) - 1;
  var mcct := GetFile(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\MCJson.json'));
  { 此为MC未隔路径 }var mccp := (((TJsonObject.ParseJSONValue(mcct) as TJsonObject).GetValue('mc') as TJsonArray)[mcsc] as TJsonObject).GetValue('path').Value;
  var mcsn := LLLini.ReadInteger('MC', 'SelectVer', -1) - 1;
  var mcnt := GetFile(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\MCSelJson.json'));
  { 此为MC隔离路径 }var msph := (((TJsonObject.ParseJSONValue(mcnt) as TJsonObject).GetValue('mcsel') as TJsonArray)[mcsn] as TJsonObject).GetValue('path').Value;
  var mcyj := GetFile(GetMCRealPath(msph, '.json'));
  var iii := LLLini.ReadInteger('Version', 'SelectIsolation', 4); //以下为判断原版，如果是原版，则返回true，如果不是则返回false。
  var pand: Boolean := (mcyj.IndexOf('com.mumfrey:liteloader:') <> -1) or (mcyj.IndexOf('org.quiltmc:quilt-loader:') <> -1) or (mcyj.IndexOf('net.fabricmc:fabric-loader:') <> -1) or (mcyj.IndexOf('forge') <> -1);
  if iii = 4 then ret := true
  else if iii = 2 then begin
    if not pand then ret := true
    else ret := false;
  end else if iii = 3 then begin
    if pand then ret := true
    else ret := false;
  end else ret := false;
  var IltIni := TIniFile.Create(Concat(msph, '\LLLauncher.ini'));
  if IltIni.ReadBool('Isolation', 'IsIsolation', false) then
    if IltIni.ReadBool('Isolation', 'IsPartition', false) then
      if IltIni.ReadBool('Isolation', 'OpenPartition', false) then
        ret := true;
  if ret then result := msph else result := mccp;
end;
//判断单独的一个Json文件是否为版本Json，如果不是则为false，如果是则为true。
function IsJsonError(path: String): Boolean;
begin
  result := false;
  if FileExists(path) then begin
    if RightStr(path, 5) = '.json' then begin
      var god := GetFile(path);
      try
        var Root := TJsonObject.ParseJSONValue(god) as TJsonObject;
        var dd := Root.GetValue('id').Value;
        var tmp := Root.GetValue('libraries').ToString;
        var ttt := Root.GetValue('mainClass').Value;
        result := true;
      except
        result := false;
      end;
    end;
  end;
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
begin //重新又双叒叕再再再再写一遍。。
  var all := TStringList.Create;
  var sb := TStringBuilder.Create;
  try
    var hou := '';
    if name.LastIndexOf('@') > 0 then begin //不按照@切了，直接判断name里面是否含有@符号，如果有则执行。。
      hou := name.Substring(name.LastIndexOf('@') + 1);
      name := name.Substring(0, name.LastIndexOf('@'));
    end;
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
        if hou.IsEmpty then begin
          all.Add(Concat(c2[I], '.jar'));
        end else begin
          all.Add(Concat(c2[I], '.', hou));
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
  if yuanjson.IsEmpty then begin result := ''; exit; end;  //如果任意一个json为空，则返回空。
  if gaijson.IsEmpty then begin result := ''; exit; end;
  if yuanjson.Equals(gaijson) then begin result := yuanjson; exit; end; //如果两个json一样，则返回原值。
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
// 将字符串里的所有数字/非数字提取出来（如果bo为真，则摘取数字，如果为假，则摘取字符。）
function ExtractNumber(str: String; bo: Boolean): String;
begin
  var Temp := ''; // 设置temp
  if str.Length = 0 then // 判断长度
  begin
    result := ''; // 如果长度等于0，则返回空
    exit;
  end;
  for var I in str do begin // for循环判断长度
    if bo then begin // 如果参数bo为真，则执行，否则执行以下
      if I.IsNumber then // 判断是否为数字
        Temp := Concat(Temp, I); // 是则添加
    end else begin
      if not I.IsNumber then // 判断是否不为数字
        Temp := Concat(Temp, I); // 不是则添加
    end;
  end;
  result := Temp;
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
var
  //非必需参数: javapath、accname、accuuid、accat、acctype、basecode, serpath
  //必需参数: mcpath, mcselpath, maxm, heig, widh, cuif, addion, addgon, serv, port
  isExports: Boolean;
  javapath, mcpath, mcselpath, accname, accuuid, accat, acctype, prels: String;
  //Java路径、MC路径、MC版本路径、账号名称、账号UUID、账号AccessToken、账号类型、前置运行参数。后置运行参数
  maxm, heig, widh: Integer;
  cuif, addion, addgame, basecode, serpath: String;
  //最大内存、窗口高度、窗口宽度、版本类型、额外JVM参数、额外game参数、外置登录元数据base64码、authlib-injector文件路径。

//此函数传参一个json与一个要查询的键，需要的键有jvm或者game。格式的字符串，然后直接查询arguments下的所有键，
function JudgeArguments(json, can: String): String;
begin
  var Rt := TJsonObject.ParseJSONValue(json) as TJsonObject;
  var Rt2 := Rt.GetValue('arguments') as TJsonObject;
  var Rvj := Rt2.GetValue(can) as TJsonArray;
  for var I in rvj do begin
    if I.ToString.IndexOf('rules') <> -1 then continue;
    var s := I.Value;
    if s.ToLower.Contains('fabric') then s := TrimStrm(s);
    if s.ToLower.Contains('mcemu') then s := TrimStrm(s);
    result := Concat(result, ' ', s);
  end;
end;
//解压Natives文件
function UnzipNative(json, path, relpath: String): Boolean;
begin
  result := false;
  var sb := TStringBuilder.Create; // 创建变量
  var Yuan := TStringList.Create;
  var LibNo := TStringList.Create;
  var NoRe := TStringList.Create;
  var ReTemp := TStringList.Create;
  var vername := ExtractFileName(relpath);
  try //解析Json
    var Rt := TJsonObject.ParseJSONValue(json) as TJsonObject;
    var Jr := Rt.GetValue('libraries') as TJsonArray; //获取libraries中的内容
    for var I in Jr do //添加元素，并将name转换成path加入进yuan数组
    begin
      try //找不同游戏，本次找不同你的对手是：Mojang！
        var Jr1 := I as TJsonObject;
        var pdd := true;
        try
          var rl := Jr1.GetValue('rules') as TJsonArray; //获取某一个元素的rule值。
          for var J in rl do begin  //下面开始判断rule值里面的action的os是否支持windows
            var r1 := J as TJsonObject;
            var an := r1.GetValue('action').Value;
            if an = 'allow' then begin
              var r2 := r1.GetValue('os') as TJsonObject;
              var r3 := r2.GetValue('name').Value;
              if r3 <> 'windows' then begin pdd := false; end; //如果支持windows，则pdd为true，反之则为false
            end else if an = 'disallow' then begin
              var r2 := r1.GetValue('os') as TJsonObject;
              var r3 := r2.GetValue('name').Value;
              if r3 = 'windows' then begin pdd := false; end;
            end;
          end;
        except end;
        var Jr2 := Jr1.GetValue('name').Value;
        var Jr3 := Jr1.GetValue('natives') as TJsonObject;
        var Jr4 := Jr3.GetValue('windows').Value.Replace('${arch}', '64');
        if pdd then Yuan.Add(Concat(Jr2, ':', Jr4));
      except
        continue;
      end;
    end;//去除重复
    for var N in Yuan do
      if LibNo.IndexOf(N) = -1 then // 去除重复
        LibNo.Add(N);
    for var G in libNo do begin //去除版本较低的那个，以下为去除不必要的重复
      var KN := G.Replace('.', '').Replace(':', '').Replace('-', '').Replace('/', '');
      var KW := ExtractNumber(KN, false); //摘取字符
      var KM := ExtractNumber(KN, true).Substring(0, 9);  //摘取数字
      var TS := strtoint(KM);
      if ReTemp.IndexOf(KW) = -1 then begin //判断是否
        ReTemp.Add(KW);
        NoRe.Add(G);
      end else if strtoint(ExtractNumber(NoRe[ReTemp.IndexOf(KW)], true).Substring(0, 9)) <= TS then begin
        NoRe.Delete(ReTemp.IndexOf(KW));
        NoRe.Insert(ReTemp.IndexOf(KW), G); // 添加新元素
      end;
    end;
    if not DirectoryExists(Concat(relpath, '\', vername, '-LLL-natives')) then ForceDirectories(Concat(relpath, '\', vername, '-LLL-natives'));
    if NoRe.Count = 0 then begin
      result := true;
      exit;
    end else begin
      for var C in Nore do begin
        if not Unzip(Concat(path, '\libraries\', ConvertNameToPath(C).Replace('/', '\')), Concat(relpath, '\', vername, '-LLL-natives')) then begin
          continue;
        end;
      end; //删除除了dll文件以外的所有文件。
      DeleteRetain(getMCRealDir(relpath, 'natives'), '.dll');
      result := true;
    end;
  finally
    sb.Free; //给所有free掉
    Yuan.Free;
    libNo.Free;
    NoRe.Free;
    ReTemp.Free;
  end;
end;
//获取MC所有类库
function GetMCAllLibs(json, path, relpath: String): String;
begin
  var sb := TStringBuilder.Create; // 创建变量
  var Yuan := TStringList.Create;
  var LibNo := TStringList.Create;
  var NoRe := TStringList.Create;
  var ReTemp := TStringList.Create;
  try //解析Json
    var Rt := TJsonObject.ParseJSONValue(json) as TJsonObject;
    var Jr := Rt.GetValue('libraries') as TJsonArray; //获取libraries中的内容
    for var I in Jr do begin //添加元素，并将name转换成path加入进yuan数组
      //找不同游戏，本次找不同你的对手是：Mojang！
      var pdd := true;
      var Jr2 := I as TJsonObject; //以下，判断是否为64位
      try
        var r1 := Jr2.GetValue('natives').ToString;
        pdd := false;
      except end;
      try
        var r1 := Jr2.GetValue('downloads') as TJsonObject;
        var r2 := r1.GetValue('classifiers').ToString;
        pdd := false;
        var r3 := r1.GetValue('artifact').ToString;
        pdd := true;
      except end;
      try
        var rl := Jr2.GetValue('rules') as TJsonArray; //获取某一个元素的rule值。
        for var J in rl do begin  //下面开始判断rule值里面的action的os是否支持windows
          var r1 := J as TJsonObject;
          var an := r1.GetValue('action').Value;
          if an = 'allow' then begin
            var r2 := r1.GetValue('os') as TJsonObject;
            var r3 := r2.GetValue('name').Value;
            if r3 <> 'windows' then begin pdd := false; end; //如果支持windows，则没有continue，反之则为false
          end else if an = 'disallow' then begin
            var r2 := r1.GetValue('os') as TJsonObject;
            var r3 := r2.GetValue('name').Value;
            if r3 = 'windows' then begin pdd := false; end;
          end;
        end;
      except end;
      if pdd then begin
        Yuan.Add(Jr2.GetValue('name').Value);
      end;
    end; //去除重复
    for var N in Yuan do
      if LibNo.IndexOf(N) = -1 then // 去除重复
        LibNo.Add(N);
    for var G in libNo do begin //去除版本较低的那个，以下为去除不必要的重复
      var KN := G.Replace('.', '').Replace(':', '').Replace('-', '').Replace('@jar', '').Replace('@zip', '');
      var KW := ExtractNumber(KN, false); //摘取字符
      var KM := ExtractNumber(KN, true);  //摘取数字
      if ReTemp.IndexOf(KW) = -1 then begin //判断是否
        ReTemp.Add(KW);
        NoRe.Add(G);
      end else if strtoint64(ExtractNumber(NoRe[ReTemp.IndexOf(KW)], true)) <= strtoint64(KM) then begin
        NoRe.Delete(ReTemp.IndexOf(KW));
        NoRe.Insert(ReTemp.IndexOf(KW), G); // 添加新元素
      end;
    end;
    for var I in NoRe do sb.Append(Concat(path, '\libraries\', ConvertNameToPath(I), ';'));
    var tmp := GetMCRealPath(relpath, '.jar');
    if tmp = '' then begin
      sb.Remove(sb.Length - 1, 1);
    end else begin
      sb.Append(tmp);
    end;
//    var tmp1 := GetMCInheritsFrom(relpath, 'jar');
//    var tmp3 := getMCRealPath(tmp1, '.jar');
//    if tmp3 = '' then begin
//      tmp1 := GetMCInheritsFrom(relpath, 'inheritsFrom');
//      tmp3 := getMCRealPath(tmp1, '.jar');
//    end;
//    if tmp3 = '' then begin
//      tmp3 := Concat(GetMCRealPath(relpath, '.jar'));
//    end;
//    if tmp3 = '' then begin
//      raise Exception.Create('List Libraries Error!');
//    end;
////    if (json.IndexOf('fmlloader') <> -1) or (json.IndexOf('fancymodloader') <> -1) then begin
////      sb.Remove(sb.Length - 1, 1);
////    end else begin
//      sb.Append(tmp3);//拼接最后一个jar
////    end;
    result := sb.ToString;
  finally
    sb.Free;
    Yuan.Free;
    libNo.Free;
    NoRe.Free;
    ReTemp.Free;
  end;
end;
//拼接1.13版本以上的新json文件
function SetParam113(json, mcpv, defjvm, addjvm: String; var param: String): Boolean;
begin
  result := false;
  var Root := TJSONObject.ParseJSONValue(json) as TJSONObject;
  var mcid: String;
  try
    mcid := Root.GetValue('id').Value;
  except
    mcid := ExtractFileName(mcselpath);
  end;
  var jaram := TStringBuilder.Create;
  jaram.Append(defjvm).Append(' ').Append(addjvm);
  if Win32MajorVersion = 10 then jaram.Append(' "-Dos.name=Windows 10" -Dos.version=10.0');
  if addion <> '' then jaram.Append(' ').Append(addion); //拼接额外JVM参数，以下拼接服务器。
  try
    jaram.Append(JudgeArguments(Root.ToString, 'jvm'));
  except exit; end;
  var launver := ExtractNumber(LauncherVersion, true);
  if mcid.CountChar(' ') > 0 then begin
    mcid := Concat('"', mcid, '"');
  end;
  jaram := jaram  //替换字符串模板中的内容。
    .Replace('${natives_directory}', Concat('"', Concat(mcselpath, '\', ExtractFileName(mcselpath), '-LLL-natives'), '"'))
    .Replace('${launcher_name}', 'LLL')
    .Replace('${launcher_version}', launver)
    .Replace('${classpath}', Concat('"', getMCAllLibs(json, mcpath, mcselpath), '"'))
    .Replace('${version_name}', mcid)
    .Replace('${library_directory}', Concat('"', mcpath, '\libraries"'))
    .Replace('${classpath_separator}', ';');
  if basecode <> '' then begin
    var fpath := Concat(AppData, '\LLLauncher\authlib-injector.jar');
    if FileExists(fpath) then begin
      jaram.Append(' -javaagent:').Append(fpath).Append('=').Append(serpath).Append(' -Dauthlibinjector.side=client -Dauthlibinjector.yggdrasil.prefetched=').Append(basecode.Replace(#13, '').Replace(#10, ''));
    end else begin
      form_mainform.label_mainform_tips.Caption := GetLanguage('label_mainform_tips.caption.cannot_find_authlib_file');
      Log.Write('未能找到Authlib-Injector文件，请去账号部分下载一次后再试！', LOG_INFO, LOG_LAUNCH);
      MyMessagebox(GetLanguage('messagebox_launcher.cannot_find_authlib_file.caption'), GetLanguage('messagebox_launcher.cannot_find_authlib_file.text'), MY_ERROR, [mybutton.myOK]);
      param := '';
      result := true;
      exit;
    end;
  end;
  var para := TStringBuilder.Create;
  para.Append(jaram).Append(' -Xmn256m -Xmx').Append(maxm).Append('m ');
  para.Append(Root.GetValue('mainClass').Value);
  try
    para.Append(JudgeArguments(Root.ToString, 'game'));
  except exit; end;
  if not addgame.Contains('--fullScreen') then begin
    para.Append(' --width ').Append(widh).Append(' --height ').Append(heig).Append(' ');
  end else para.Append(' ');
  para := para  //替换字符串模板
    .Replace('${auth_player_name}', accname) //替换美元符号内的内容
    .Replace('${version_name}', mcid)
    .Replace('${game_directory}', Concat('"', mcpv, '"'))
    .Replace('${assets_root}', Concat('"', mcpath, '\assets', '"'))
    .Replace('${assets_index_name}', (Root.GetValue('assetIndex') as TJsonObject).GetValue('id').Value)
    .Replace('${auth_uuid}', accuuid)
    .Replace('${auth_access_token}', accat)
    .Replace('${user_type}', acctype)
    .Replace('${version_type}', cuif); //拼接长度与宽度
  if not addgame.IsEmpty then para.Append(addgame);
  //sboptifine
  if para.ToString.Contains('--tweakClass optifine.OptiFineForgeTweaker') then begin
    para.Replace('--tweakClass optifine.OptiFineForgeTweaker', '').Append(' --tweakClass optifine.OptiFineForgeTweaker');
  end;
  if para.ToString.Contains('--tweakClass optifine.OptiFineTweaker') then begin
    para.Replace('--tweakClass optifine.OptiFineTweaker', '').Append(' --tweakClass optifine.OptiFineForgeTweaker');
  end;
  param := para.ToString;
  result := true;
end;
//拼接1.12版本以下的旧json文件
function SetParam112(json, mcpv, defjvm, addjvm: String; var param: String): Boolean;
begin
  result := false;
  var Root := TJSONObject.ParseJSONValue(json) as TJSONObject;
  var son := Root.GetValue('minecraftArguments').Value; //这里找的是minecraftArguments部分的。
  if son.IsEmpty then raise Exception.Create('Read Minecraft Argument Error');
  var mcid: String;
  try
    mcid := Root.GetValue('id').Value;
  except
    mcid := ExtractFileName(mcselpath);
  end;
  var para := TStringBuilder.Create;
  para.Append(defjvm).Append(' ').Append(addion).Append(' ').Append(addjvm);
  try //尝试查询1.12.2以下版本是否拥有arguments键。以便启动Liteloader。
    para.Append(JudgeArguments(json, 'jvm'));
  except end;
  para.Append(' "-Djava.library.path=').Append(Concat(mcselpath, '\', ExtractFileName(mcselpath), '-LLL-natives')).Append('" -cp "').Append(getMCAllLibs(Root.ToString, mcpath, mcselpath)).Append('"');
  if basecode <> '' then begin
    var fpath := Concat(AppData, '\LLLauncher\authlib-injector.jar');
    if FileExists(fpath) then begin
      para.Append(' -javaagent:').Append(fpath).Append('=').Append(serpath).Append(' -Dauthlibinjector.side=client -Dauthlibinjector.yggdrasil.prefetched=').Append(basecode.Replace(#13, '').Replace(#10, ''));
    end else begin
      form_mainform.label_mainform_tips.Caption := GetLanguage('label_mainform_tips.caption.cannot_find_authlib_file');
      Log.Write('未能找到Authlib-Injector文件，请去账号部分下载一次后再试！', LOG_INFO, LOG_LAUNCH);
      MyMessagebox(GetLanguage('messagebox_launcher.cannot_find_authlib_file.caption'), GetLanguage('messagebox_launcher.cannot_find_authlib_file.text'), MY_ERROR, [mybutton.myOK]);
      param := '';
      result := true;
      exit;
    end;
  end;
  para.Append(' -Xmn256m -Xmx').Append(maxm).Append('m ');
//  var jv := GetFileVersion(javapath);
//  if strtoint(jv.Substring(0, jv.IndexOf('.'))) > 8 then para.Append('--add-exports cpw.mods.bootstraplauncher/cpw.mods.bootstraplauncher=ALL-UNNAMED ');
  para.Append(Root.GetValue('mainClass').Value);
  son := son //替换美元符号内
    .Replace('${auth_player_name}', accname)
    .Replace('${auth_session}', accuuid)
    .Replace('${game_directory}', Concat('"', mcpv, '"'))
    .Replace('${game_assets}', Concat('"', mcpath, '\assets\virtual\legacy', '"'))
    .Replace('${assets_root}', Concat('"', mcpath, '\assets', '"'))
    .Replace('${version_name}', mcid)
    .Replace('${assets_index_name}', (Root.GetValue('assetIndex') as TJsonObject).GetValue('id').Value)
    .Replace('${auth_uuid}', accuuid)
    .Replace('${auth_access_token}', accat)
    .Replace('${user_properties}', '{}')
    .Replace('${user_type}', acctype)
    .Replace('${version_type}', Concat('"', cuif, '"')); //与上面一样了，不做注释了。
  try //尝试查询1.12.2以下版本是否拥有arguments键。以便启动Liteloader。
    para.Append(JudgeArguments(json, 'game'));
  except end;
  para.Append(' ').Append(son);
  if not addgame.IsEmpty then para.Append(' ').Append(addgame);
  //sboptifine
  if para.ToString.Contains('--tweakClass optifine.OptiFineForgeTweaker') then begin
    para.Replace('--tweakClass optifine.OptiFineForgeTweaker', '').Append(' --tweakClass optifine.OptiFineTweaker');
  end;
  if para.ToString.Contains('--tweakClass optifine.OptiFineTweaker') then begin
    para.Replace('--tweakClass optifine.OptiFineTweaker', '').Append(' --tweakClass optifine.OptiFineTweaker');
  end;
  param := para.ToString;
  result := true;
end;
//拼接启动参数！
procedure PutLaunch(isExportArgs: Boolean);
const
  defjvm = '-XX:+UseG1GC -XX:-UseAdaptiveSizePolicy -XX:-OmitStackTraceInFastThrow -Dfml.ignoreInvalidMinecraftCertificates=True -Dfml.ignorePatchDiscrepancies=True -Dlog4j2.formatMsgNoLookups=true';
  addjvm = '-XX:HeapDumpPath=MojangTricksIntelDriversForPerformance_javaw.exe_minecraft.exe.heapdump';
begin
  Log.Write('开始判断json文件内容。', LOG_INFO, LOG_LAUNCH);
  form_mainform.label_mainform_tips.Caption := GetLanguage('label_mainform_tips.caption.set_launch_script');
  var jso := GetMCRealPath(mcselpath, '.json'); //找json路径。直接查找就可以了。
  if not FileExists(jso) then begin
    form_mainform.label_mainform_tips.Caption := GetLanguage('label_mainform_tips.caption.cannot_find_json');
    Log.Write('未能从版本文件夹中找到符合条件的json', LOG_INFO, LOG_LAUNCH);
    MyMessagebox(GetLanguage('messagebox_launcher.cannot_find_json.caption'), GetLanguage('messagebox_launcher.cannot_find_json.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  var jnn := '';
  var jsn := GetFile(jso); //获取json内容。
  var jon := GetMCInheritsFrom(mcselpath, 'inheritsFrom');
  if jon <> mcselpath then begin
    Log.Write('判断成功，有InheritsFrom键。', LOG_INFO, LOG_LAUNCH);
    jnn := GetFile(GetMCRealPath(jon, '.json'));
  end else jnn := jsn;
  try
    if not UnzipNative(jnn, mcpath, mcselpath) then raise Exception.Create('Cannot Unzip Method');
  except
    form_mainform.label_mainform_tips.Caption := GetLanguage('label_mainform_tips.caption.unzip_native_error');
    Log.Write('解压Natives文件夹失误，请重试！', LOG_INFO, LOG_LAUNCH);
    MyMessagebox(GetLanguage('messagebox_launcher.unzip_native_error.caption'), GetLanguage('messagebox_launcher.unzip_native_error.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  var param := '';
  var mcpv := JudgeIsolation;
  try
    if not SetParam113(ReplaceMCInheritsFrom(jsn, jnn), mcpv, defjvm, addjvm, param) then raise Exception.Create('MC Not 1.13 upper');
  except
    try
      if not SetParam112(ReplaceMCInheritsFrom(jsn, jnn), mcpv, defjvm, addjvm, param) then raise Exception.Create('MC Not 1.12 lower');
    except
      form_mainform.label_mainform_tips.Caption := GetLanguage('label_mainform_tips.caption.cannot_set_launch_args');
      Log.Write('解压Natives文件夹失误，请重试！', LOG_INFO, LOG_LAUNCH);
      MyMessagebox(GetLanguage('messagebox_launcher.cannot_set_launch_args.caption'), GetLanguage('messagebox_launcher.cannot_set_launch_args.text'), MY_ERROR, [mybutton.myOK]);
      exit;
    end;
  end;
  if param = '' then exit;
  if isExportArgs then begin
    if MyMessagebox(GetLanguage('messagebox_launcher.is_export_arguments.caption'), GetLanguage('messagebox_launcher.is_export_arguments.text'), MY_INFORMATION, [mybutton.myNo, mybutton.myYes]) = 1 then exit;
    if MyMessagebox(GetLanguage('messagebox_launcher.is_hide_accesstoken.caption'), GetLanguage('messagebox_launcher.is_hide_accesstoken.text'), MY_WARNING, [mybutton.myNo, mybutton.myYes]) = 2 then begin
      var l1 := param.Substring(param.IndexOf('--accessToken') + 14, param.Length);
      var l2 := param.Replace(l1, '');
      var l3 := l1.Substring(l1.IndexOf(' '), l1.Length);
      param := Concat(l2, '********************************', l3);
    end;
    var tir := Now.Format('yyyy-mm-dd_HH.nn.ss');
    var pth := Concat(ExtractFilePath(Application.ExeName), '\LLLauncher\LaunchArguments\args-', tir, '.bat');
    SetFile(pth,
      Concat('@echo off', #13#10,
      '@title 启动游戏：', ExtractFileName(mcselpath), #13#10,
      'echo 正在启动游戏，请稍候……', #13#10,
      'set APPDATA="', mcpv, '"', #13#10,
      'cd /d "', mcpv, '"', #13#10,
      '"', javapath, '" ', param, #13#10,
      'echo 游戏已退出……请按任意键退出程序。', #13#10,
      'pause'));
    Log.Write('导出完成！', LOG_INFO, LOG_LAUNCH);
    MyMessagebox(GetLanguage('messagebox_launcher.export_launch_args_success.caption'), GetLanguage('messagebox_launcher.export_launch_args_success.text'), MY_PASS, [mybutton.myOK]);
    form_mainform.label_mainform_tips.Caption := GetLanguage('label_mainform_tips.caption.export_launch_args_success');
    exit;
  end;
  if MyMessagebox(GetLanguage('messagebox_launcher.args_put_success.caption'), GetLanguage('messagebox_launcher.args_put_success.text'), MY_INFORMATION, [mybutton.myNo, mybutton.myYes]) = 1 then begin
    form_mainform.label_mainform_tips.Caption := GetLanguage('label_mainform_tips.caption.cancel_launch');
    Log.Write('取消启动。', LOG_INFO, LOG_LAUNCH);
    exit;
  end;
  if prels <> '' then begin
    RunDOSOnlyWait(prels);
  end;
  crash_count := GetDirectoryFileCount(Concat(mcpv, '\crash-reports'), '.txt').Count;
  try  //判断启动器的启动次数
    Log.Write('判断启动游戏的次数。', LOG_INFO, LOG_LAUNCH);
    mlaunch_number := Otherini.ReadInteger('Misc', 'StartGame', -1) + 1;
    if mlaunch_number < 0 then raise Exception.Create('Format Exception');
    Otherini.WriteString('Misc', 'StartGame', inttostr(mlaunch_number));
    form_mainform.label_launch_game_number.Caption := GetLanguage('label_launch_game_number.caption').Replace('${launch_game_number}', inttostr(mlaunch_number));
    Log.Write(Concat('判断成功，你已启动了：', inttostr(mlaunch_number)), LOG_INFO, LOG_LAUNCH);
  except
    Log.Write('次数判断失败，已重置。', LOG_ERROR, LOG_LAUNCH);
    Otherini.WriteString('Misc', 'StartGame', '1');
    mlaunch_number := 1;
    form_mainform.label_launch_game_number.Caption := GetLanguage('label_launch_game_number.caption').Replace('${launch_game_number}', inttostr(mlaunch_number + 1));
  end; //判断是否是时候给作者捐款了。
  mcpid := RUNDOSANDGETPID(javapath, param, mcpv);
  form_mainform.label_mainform_tips.Caption := GetLanguage('label_mainform_tips.caption.wait_launch_game');
  Log.Write('游戏启动成功！。', LOG_INFO, LOG_LAUNCH);
  case mlaunch_number of
    100, 200, 300, 400, 600, 800, 1100, 1400, 1700, 2000: Isafdian(true, mlaunch_number);
  end;
end;
//开始游戏！
procedure StartLaunch(isExportArgs: Boolean);
var
  status: TMemoryStatus;
  istoi: Boolean;
  IioIni: TIniFile;
var
  taddgame: String;
begin
  GlobalMemoryStatus(status);
  var mem: Integer := ceil(status.dwTotalPhys / 1024 / 1024);
  form_mainform.label_mainform_tips.Caption := GetLanguage('label_mainform_tips.caption.judge_args');
  try
    Log.Write('开始判断是否选择了登录账号。', LOG_INFO, LOG_LAUNCH);
    var acv := GetFile(Concat(AppData, '\LLLauncher\AccountJson.json'));
    var acn := Otherini.ReadInteger('Account', 'SelectAccount', 0) - 1;
    var accj := (((TJsonObject.ParseJSONValue(acv) as TJsonObject).GetValue('account') as TJsonArray)[acn] as TJsonObject);
    var actp := accj.GetValue('type').Value;
    if actp.Equals('offline') then begin
      if (not mjudge_lang_chinese) and (not OtherIni.ReadBool('Other', 'CanOffline', false)) then begin
        taddgame := '--demo';
      end;
      accname := accj.GetValue('name').Value;
      accuuid := accj.GetValue('uuid').Value;
      accat := accj.GetValue('uuid').Value;
      acctype := 'Legacy';
      Log.Write(Concat('判断成功，你选择的是离线登录，用户名为：', accname), LOG_INFO, LOG_LAUNCH);
    end else if actp = 'oauth' then begin
      var w := 'https://api.minecraftservices.com/minecraft/profile';
      var k := accj.GetValue('access_token').Value;
      Log.Write('判断成功，你选择的是微软登录。', LOG_INFO, LOG_LAUNCH);
      try
        var t := TAccount.GetHttph(k, w);
        var j := TJsonObject.ParseJSONValue(t) as TJsonObject;
        accname := j.GetValue('name').Value;
        accuuid := j.GetValue('id').Value;
        accat := accj.GetValue('access_token').Value;
        acctype := 'msa';
        Log.Write(Concat('判断成功，你选择的是离线登录，用户名为：', accname), LOG_INFO, LOG_LAUNCH);
      except
        form_mainform.label_mainform_tips.Caption := GetLanguage('label_mainform_tips.caption.access_token_expire');
        Log.Write('你的账号Access Token已经过期了。', LOG_ERROR, LOG_LAUNCH);
        MyMessagebox(GetLanguage('messagebox_launcher.access_token_expire.caption'), GetLanguage('messagebox_launcher.access_token_expire.text'), MY_ERROR, [mybutton.myOK]);
        exit;
      end;
    end else if actp = 'thirdparty' then begin
      if not mjudge_lang_chinese then begin
        MyMessagebox(GetLanguage('messagebox_launcher.not_support_thirdparty.caption'), GetLanguage('messagebox_launcher.not_support_thirdparty.text'), MY_ERROR, [mybutton.myOK]);
        Log.Write('目前并不处于中国地区，第三方登录失败！', LOG_ERROR, LOG_LAUNCH);
        form_mainform.label_mainform_tips.Caption := GetLanguage('label_mainform_tips.caption.not_support_third_party');
        exit;
      end;
      var w := Concat(accj.GetValue('server').Value, 'authserver/validate');
      var aj := Concat('{"accessToken":"',
        accj.GetValue('access_token').Value,
        '","clientToken":"',
        accj.GetValue('client_token').Value,
        '"}');
      Log.Write('判断成功，你选择的是第三方/外置登录。', LOG_INFO, LOG_LAUNCH);
      try
        var aa := TAccount.GetHttpf(aj, w);
        if aa = '' then begin
          accat := accj.GetValue('access_token').Value;
          accuuid := accj.GetValue('uuid').Value;
          accname := accj.GetValue('name').Value;
          acctype := 'msa';
          serpath := Concat(accj.GetValue('server').Value);
          basecode := accj.GetValue('base_code').Value;
          Log.Write(Concat('判断成功，你选择的是离线登录，用户名为：', accname), LOG_INFO, LOG_LAUNCH);
        end else raise Exception.Create('Login Authlib Error');
      except
        form_mainform.label_mainform_tips.Caption := GetLanguage('label_mainform_tips.caption.access_token_expire');
        Log.Write('你的账号Access Token已经过期了。', LOG_ERROR, LOG_LAUNCH);
        MyMessagebox(GetLanguage('messagebox_launcher.access_token_expire.caption'), GetLanguage('messagebox_launcher.access_token_expire.text'), MY_ERROR, [mybutton.myOK]);
        exit;
      end;
    end else begin
      form_mainform.label_mainform_tips.Caption := GetLanguage('label_mainform_tips.caption.not_support_login_type');
      Log.Write('不支持的登录方式，请重试！', LOG_ERROR, LOG_LAUNCH);
      MyMessagebox(GetLanguage('messagebox_launcher.not_support_login_type.caption'), GetLanguage('messagebox_launcher.not_support_login_type.text'), MY_ERROR, [mybutton.myOK]);
      exit;
    end;
  except
    form_mainform.label_mainform_tips.Caption := GetLanguage('label_mainform_tips.caption.not_choose_account');
    Log.Write('账号判断失误，你还没有选择任何一个账号。', LOG_ERROR, LOG_LAUNCH);
    MyMessagebox(GetLanguage('messagebox_launcher.not_choose_account.caption'), GetLanguage('messagebox_launcher.not_choose_account.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  try
    Log.Write('开始判断是否选择了MC版本。', LOG_INFO, LOG_LAUNCH);
    var mce := GetFile(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\', 'MCJson.json'));
    var mcn := LLLini.ReadInteger('MC', 'SelectMC', 0) - 1;
    mcpath := (((TJsonObject.ParseJSONValue(mce) as TJsonObject).GetValue('mc') as TJsonArray)[mcn] as TJsonObject).GetValue('path').Value;
    var mcsn := LLLini.ReadInteger('MC', 'SelectVer', 0) - 1;
    var mct := GetFile(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\', 'MCSelJson.json'));
    mcselpath := (((TJsonObject.ParseJSONValue(mct) as TJsonObject).GetValue('mcsel') as TJsonArray)[mcsn] as TJsonObject).GetValue('path').Value;
    IioIni := TIniFile.Create(Concat(mcselpath, '\LLLauncher.ini')); //将IioIni保存为外部独立运行的配置文件。
    istoi := IioIni.ReadBool('Isolation', 'IsIsolation', false);
  except
    form_mainform.label_mainform_tips.Caption := GetLanguage('label_mainform_tips.caption.not_choose_mc_version');
    Log.Write('MC版本判断失误，你还没有选择任何一个MC版本。', LOG_ERROR, LOG_LAUNCH);
    MyMessagebox(GetLanguage('messagebox_launcher.not_choose_mc_version.caption'), GetLanguage('messagebox_launcher.not_choose_mc_version.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  try
    Log.Write('开始判断是否选择了Java。', LOG_INFO, LOG_LAUNCH);
    var jnv := GetFile(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\', 'JavaJson.json'));
    var jan := LLLini.ReadInteger('Java', 'SelectJava', 0) - 1;
    javapath := ((TJsonObject.ParseJSONValue(jnv) as TJsonObject).GetValue('java') as TJsonArray)[jan].GetValue<String>;
    if not FileExists(javapath) then raise Exception.Create('File Not Exists');
    if istoi then begin
      var isojp := IioIni.ReadString('Isolation', 'JavaPath', '');
      if FileExists(isojp) then javapath := isojp;
    end;
  except
    form_mainform.label_mainform_tips.Caption := GetLanguage('label_mainform_tips.caption.not_choose_java');
    Log.Write('Java判断失误，你还没有选择任何一个Java。', LOG_ERROR, LOG_LAUNCH);
    MyMessagebox(GetLanguage('messagebox_launcher.not_choose_java.caption'), GetLanguage('messagebox_launcher.not_choose_java.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  try
    Log.Write('开始判断窗口宽度。', LOG_INFO, LOG_LAUNCH);
    widh := LLLini.ReadInteger('Document', 'WindowsWidth', -1);
    if (widh < 854) or (widh > GetSystemMetrics(SM_CXSCREEN)) then raise Exception.Create('Format Exception');
    Log.Write('开始判断窗口高度。', LOG_INFO, LOG_LAUNCH);
    heig := LLLini.ReadInteger('Document', 'WindowsHeight', -1);
    if (heig < 480) or (heig > GetSystemMetrics(SM_CYSCREEN)) then raise Exception.Create('Format Exception');
  except
    Log.Write('窗口宽高判断失败，已生成默认值', LOG_ERROR, LOG_LAUNCH);
    widh := 854;
    heig := 480;
    LLLini.WriteInteger('Document', 'WindowsWidth', 854);
    LLLini.WriteInteger('Document', 'WindowsHeight', 480);
  end;
  try
    Log.Write('开始判断最大内存', LOG_INFO, LOG_LAUNCH);
    maxm := LLLini.ReadInteger('Document', 'MaxMemory', -1);
    if (maxm < 1024) or (maxm > mem) then raise Exception.Create('Error Message');
  except
    Log.Write('最大内存判断失败，已生成默认值', LOG_ERROR, LOG_LAUNCH);
    maxm := 1024;
    LLLini.WriteInteger('Document', 'MaxMemory', 1024);
  end;
  Log.Write('开始判断自定义信息。', LOG_INFO, LOG_LAUNCH);
  cuif := LLLini.ReadString('Version', 'CustomInfo', '');
  Log.Write('开始判断额外JVM参数。', LOG_INFO, LOG_LAUNCH);
  addion := LLLini.ReadString('Version', 'AdditionalJVM', '');
  Log.Write('开始判断额外game参数。', LOG_INFO, LOG_LAUNCH);
  addgame := LLLini.ReadString('Version', 'AdditionalGame', '');
  Log.Write('开始判断启动前执行命令。', LOG_INFO, LOG_LAUNCH);
  prels := LLLini.ReadString('Version', 'Pre-LaunchScript', '');
  if istoi then begin
    if IioIni.ReadBool('Isolation', 'IsSize', false) then begin
      var tw := IioIni.ReadInteger('Isolation', 'Width', -1);
      if not ((tw < 854) or (tw > GetSystemMetrics(SM_CXSCREEN))) then widh := tw;
      var th := IioIni.ReadInteger('Isolation', 'Height', -1);
      if not ((th < 480) or (th > GetSystemMetrics(SM_CYSCREEN))) then heig := th;
    end;
    if IioIni.ReadBool('Isolation', 'IsMemory', false) then begin
      var tm := IioIni.ReadInteger('Isolation', 'MaxMemory', -1);
      if not ((tm < 1024) or (tm > mem)) then maxm := mem;
    end;
    var tci := IioIni.ReadString('Isolation', 'CustomInfo', '');
    if not (tci.IsEmpty) then cuif := tci;
    var tai := IioIni.ReadString('Isolation', 'AdditionalJVM', '');
    if not (tai.isEmpty) then addion := tai;
    var tag := IioIni.ReadString('Isolation', 'AdditionalGame', '');
    if not (tag.isEmpty) then addgame := tag;
    var tpl := IioIni.ReadString('Isolation', 'Pre-LaunchScript', '');
    if not (tpl.IsEmpty) then prels := tpl;
  end;
  if not taddgame.IsEmpty then addgame := Concat(taddgame, ' ', addgame);
  Log.Write('目前你设置的所有参数都已判断完毕，现在开始拼接启动参数……', LOG_INFO, LOG_LAUNCH);
  PutLaunch(isExportArgs);
end;
end.

