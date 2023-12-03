unit LauncherMethod;

interface

uses
  SysUtils, Classes, Windows, IOUtils, StrUtils, JSON, Zip, Forms, IniFiles, Math;

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
  var mcct := GetFile(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\', 'MCJson.json'));
  { 此为MC未隔路径 }var mccp := (((TJsonObject.ParseJSONValue(mcct) as TJsonObject).GetValue('mc') as TJsonArray)[mcsc] as TJsonObject).GetValue('path').Value;
  var mcsn := LLLini.ReadInteger('MC', 'SelectVer', -1) - 1;
  var mcnt := GetFile(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\', 'MCSelJson.json'));
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
    if IltIni.ReadBool('Isolation', 'Partition', false) then
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
var
  //非必需参数: javapath、accname、accuuid、accat、acctype、basecode, serpath
  //必需参数: mcpath, mcselpath, maxm, heig, widh, cuif, addion, addgon, serv, port
  isExports: Boolean;
  javapath, mcpath, mcselpath, accname, accuuid, accat, acctype, prels, afels: String;
  //Java路径、MC路径、MC版本路径、账号名称、账号UUID、账号AccessToken、账号类型、前置运行参数。后置运行参数
  maxm, heig, widh: Integer;
  cuif, addion, addgame, basecode, serpath: String;
  //最大内存、窗口高度、窗口宽度、版本类型、额外JVM参数、额外game参数、外置登录元数据base64码、authlib-injector文件路径。
//开始游戏！
procedure StartLaunch(isExportArgs: Boolean);
var
  status: TMemoryStatus;
  istoi: Boolean;
  IioIni: TIniFile;
var
  addgame: String;
begin
  GlobalMemoryStatus(status);
  var mem: Integer := ceil(status.dwTotalPhys / 1024 / 1024);
  form_mainform.label_launch_tips.Caption := GetLanguage('label_launch_tips.caption.judge_args');
  try
    Log.Write('开始判断是否选择了登录账号。', LOG_INFO, LOG_LAUNCH);
    var acv := GetFile(Concat(AppData, '\LLLauncher\AccountJson.json'));
    var acn := Otherini.ReadInteger('Account', 'SelectAccount', 0) - 1;
    var accj := (((TJsonObject.ParseJSONValue(acv) as TJsonObject).GetValue('account') as TJsonArray)[acn] as TJsonObject);
    var actp := accj.GetValue('type').Value;
    if actp.Equals('offline') then begin
      if (not mjudge_lang_chinese) and (not OtherIni.ReadBool('Other', 'CanOffline', false)) then begin
        addgame := Concat(addgame, '--demo');
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
        form_mainform.label_launch_tips.Caption := GetLanguage('label_launch_tips.caption.access_token_expire');
        Log.Write('你的账号Access Token已经过期了。', LOG_ERROR, LOG_LAUNCH);
        MyMessagebox(GetLanguage('messagebox_launcher.access_token_expire.caption'), GetLanguage('messagebox_launcher.access_token_expire.text'), MY_ERROR, [mybutton.myOK]);
        exit;
      end;
    end else if actp = 'thirdparty' then begin
      if not mjudge_lang_chinese then begin
        MyMessagebox(GetLanguage('messagebox_launcher.not_support_thirdparty.caption'), GetLanguage('messagebox_launcher.not_support_thirdparty.text'), MY_ERROR, [mybutton.myOK]);
        Log.Write('目前并不处于中国地区，第三方登录失败！', LOG_ERROR, LOG_LAUNCH);
        form_mainform.label_launch_tips.Caption := GetLanguage('label_launch_tips.caption.not_support_third_party');
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
          acctype := 'Mojang';
          serpath := Concat(accj.GetValue('server').Value, 'api/yggdrasil');
          basecode := accj.GetValue('base_code').Value;
          Log.Write(Concat('判断成功，你选择的是离线登录，用户名为：', accname), LOG_INFO, LOG_LAUNCH);
        end else raise Exception.Create('Login Authlib Error');
      except
        form_mainform.label_launch_tips.Caption := GetLanguage('label_launch_tips.caption.access_token_expire');
        Log.Write('你的账号Access Token已经过期了。', LOG_ERROR, LOG_LAUNCH);
        MyMessagebox(GetLanguage('messagebox_launcher.access_token_expire.caption'), GetLanguage('messagebox_launcher.access_token_expire.text'), MY_ERROR, [mybutton.myOK]);
        exit;
      end;
    end else begin
      form_mainform.label_launch_tips.Caption := GetLanguage('label_launch_tips.caption.not_support_login_type');
      Log.Write('不支持的登录方式，请重试！', LOG_ERROR, LOG_LAUNCH);
        MyMessagebox(GetLanguage('messagebox_launcher.not_support_login_type.caption'), GetLanguage('messagebox_launcher.not_support_login_type.text'), MY_ERROR, [mybutton.myOK]);
    end;
  except
    form_mainform.label_launch_tips.Caption := GetLanguage('label_launch_tips.caption.not_choose_account');
    Log.Write('账号判断失误，你还没有选择任何一个账号。', LOG_ERROR, LOG_LAUNCH);
    MyMessagebox(GetLanguage('messagebox_launcher.not_choose_account.caption'), GetLanguage('messagebox_launcher.not_choose_account.text'), MY_ERROR, [mybutton.myOK]);
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
    form_mainform.label_launch_tips.Caption := GetLanguage('label_launch_tips.caption.not_choose_mc_version');
    Log.Write('MC版本判断失误，你还没有选择任何一个MC版本。', LOG_ERROR, LOG_LAUNCH);
    MyMessagebox(GetLanguage('messagebox_launcher.not_choose_mc_version.caption'), GetLanguage('messagebox_launcher.not_choose_mc_version.text'), MY_ERROR, [mybutton.myOK]);
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
    form_mainform.label_launch_tips.Caption := GetLanguage('label_launch_tips.caption.not_choose_java');
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
  Log.Write('开始判断启动后执行命令。', LOG_INFO, LOG_LAUNCH);
  afels := LLLini.ReadString('Version', 'After-LaunchScript', '');
  if istoi then begin
    if IioIni.ReadBool('Isolation', 'IsSize', false) then begin

    end;
  end;
end;
end.

