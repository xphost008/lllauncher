unit ProgressMethod;

interface

uses
  System.Net.HttpClient, System.Net.HttpClientComponent, System.Generics.Collections, JSON,
  SysUtils, Classes, Math, Windows, StrUtils, Forms, Dialogs, ClipBrd;

type
  TMyProc = reference to procedure;
  TMyThread = class(TThread)
  private
    var
      MyProc: TMyProc;
  public
    constructor Create(CreateSuspended: Boolean; MyProc: TMyProc);
    procedure Execute; override;
    class function CreateAnonymousThread(AProc: TMyProc): TMyThread;
  end;

procedure DownloadStart(url, SavePath, RootPath: String; BiggestThread, SelectMode, LoadSource: Integer; javapath: String = ''; VanillaVersion: String = ''; isShowList: Boolean = false; isShowProgress: Boolean = true);
function GetURLFileName(aURL: String): String;

implementation

uses
  MainMethod, MainForm, LanguageMethod, LauncherMethod;

type
  TDownloadMethod = class
  private
    var
      url, SavePath, RootPath: String;
      BiggestThread, SelectMode: Integer;
      isShowList, isShowProgress: Boolean;
      javapath, VanillaVersion: String;
    function GetFileSize(aurl: String): Integer;
    function GetHTTPNormal(url: String): TStringStream;
    procedure ReceiveData(const Sender: TObject;
      AContentLength, AReadCount: Int64; var AAbort: Boolean);
    function GetHTTPRange(url: String; tstart, tend: Integer;
      showProg: Boolean): TStringStream;
    procedure BackupFile(yuanpath, backuppath: String);
    function ExtractMainClass(jarpath: String): String;
    procedure SimpleForge(profile: String);
    function JudgeMCRule(rl: TJsonObject): Boolean;
    procedure ShowCurrentProgress(current, mmax: Integer);
    procedure RunProcessors(profile: String);
    procedure DownloadCustomFile;
    procedure DownloadMinecraft;
    procedure DownloadJava;
    procedure DownloadForge;
    procedure DownloadModpack;
    constructor InitDownload(url, SavePath, RootPath: String; BiggestThread, SelectMode: Integer; javapath, VanillaVersion: String; isShowList: Boolean; isShowProgress: Boolean);
    procedure StartDownload(LoadSource: Integer);
{$IFDEF DEBUG}
    procedure ReceverError(const Sender: TObject; const AError: String);
{$ENDIF}
    procedure DownloadAsWindow(SavePath, DownloadURL, FileHash, ViewName: String; isLibraries: Boolean; SelectMode: Integer);
  end;
//新的线程模式！
constructor TMyThread.Create(CreateSuspended: Boolean; MyProc: TMyProc);
begin
  inherited Create(CreateSuspended);
  FreeOnTerminate := false;
  self.MyProc := MyProc;
end;
procedure TMyThread.Execute;
begin
  MyProc;
end;
class function TMyThread.CreateAnonymousThread(AProc: TMyProc): TMyThread;
begin
  result := TMyThread.Create(true, AProc);
end;
//获取网址后缀名
function GetURLFileName(aURL: String): String;
begin
  if aurl.LastIndexOf('?') = -1 then aurl := Concat(aurl, '?');
  result := aURL.Substring(aurl.LastIndexOf('/') + 1, aurl.Length - aurl.LastIndexOf('/') - 1 - (aurl.Length - aurl.LastIndexOf('?')));
  if result = '' then result := 'XXX';
end;
//提取主类
function TDownloadMethod.ExtractMainClass(jarpath: String): String;
begin
  var rdp := Concat(LocalTemp, 'LLLauncher\', inttostr(random(99999)));
  Unzip(jarpath, rdp);
  var cot := TStringList.Create;
  cot.LoadFromFile(Concat(rdp, '\META-INF\MANIFEST.MF'));
  for var I in cot do begin
    if I.IndexOf('Main-Class') <> -1 then begin
      result := I.Substring(12);
      break;
    end;
  end;
  DeleteDirectory(rdp);
end;
//备份文件
procedure TDownloadMethod.BackupFile(yuanpath, backuppath: String);
begin
  try
    if not DirectoryExists(ExtractFilePath(backuppath)) then ForceDirectories(ExtractFilePath(backuppath));
    if not FileExists(yuanpath) then raise Exception.Create('File Not Found!');
    if not FileExists(backuppath) then begin
      CopyFile(pchar(yuanpath), pchar(backuppath), True);
      form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.backup.backup_success').Replace('${backup_file_name}', ExtractFileName(backuppath)));
    end;
  except
    form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.backup.backup_error').Replace('${backup_file_name}', ExtractFileName(backuppath)));
  end;
end;
//第一个是保存位置，第二个是下载网址，第三个是文件hash【如果没有可以为空】，第四个是显示在列表框上的名字，第五个为是否为资源文件，第六个为选择源。
procedure TDownloadMethod.DownloadAsWindow(SavePath, DownloadURL, FileHash, ViewName: String; isLibraries: Boolean; SelectMode: Integer);
label
  Retry;
begin
  var ret := 0;
  if FileExists(SavePath) then begin
    if FileHash = '' then raise Exception.Create('Is Exists');
    if GetFileHash(SavePath).ToLower <> FileHash then begin
      deletefile(pchar(SavePath));
      goto Retry;
    end;
    if isShowList then form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.window.file_is_exists').Replace('${file_exists_name}', ViewName));
    raise Exception.Create('Is Exists');
  end;
  if (SavePath.IndexOf('linux') <> -1) or (SavePath.IndexOf('macos') <> -1) or (SavePath.IndexOf('osx') <> -1) then begin
    raise Exception.Create('Not support');
  end;
  Retry: ;
  var srr := GetWebStream(DownloadURL);
  if srr = nil then begin
    inc(ret);
    if ret < 3 then begin
      form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.window.download_error_retry').Replace('${file_error_name}', ViewName));
      if isLibraries then begin
        case SelectMode of
          1: begin
            form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.window.switch_download_source').Replace('${source_name}', 'BMCLAPI'));
            DownloadURL := DownloadURL.Replace('https://libraries.minecraft.net', 'https://bmclapi2.bangbang93.com/maven');
            DownloadURL := DownloadURL.Replace('https://maven.minecraftforge.net', 'https://bmclapi2.bangbang93.com/maven');
            DownloadURL := DownloadURL.Replace('https://files.minecraftforge.net/maven', 'https://bmclapi2.bangbang93.com/maven');
            DownloadURL := DownloadURL.Replace('http://files.minecraftforge.net/maven', 'https://bmclapi2.bangbang93.com/maven');
            DownloadURL := DownloadURL.Replace('https://maven.fabricmc.net', 'https://bmclapi2.bangbang93.com/maven');
            SelectMode := 2;
          end;
          2: begin
            form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.window.switch_download_source').Replace('${source_name}', 'FORGE'));
            DownloadURL := DownloadURL.Replace('https://bmclapi2.bangbang93.com/maven', 'https://maven.minecraftforge.net');
            SelectMode := 3;
          end;
          3: begin
            form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.window.switch_download_source').Replace('${source_name}', 'FABRIC'));
            DownloadURL := DownloadURL.Replace('https://maven.minecraftforge.net', 'https://maven.fabricmc.net');
            SelectMode := 1;
          end;
        end;
      end else begin
        case SelectMode of
          1: begin
            form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.window.switch_download_source').Replace('${source_name}', 'BMCLAPI'));
            DownloadURL := DownloadURL.Replace('https://resources.download.minecraft.net', 'https://bmclapi2.bangbang93.com/assets');
            SelectMode := 2;
          end;
          2: begin
            form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.window.switch_download_source').Replace('${source_name}', 'Vanilla'));
            DownloadURL := DownloadURL.Replace('https://bmclapi2.bangbang93.com/assets', 'https://resources.download.minecraft.net');
            SelectMode := 1;
          end;
        end;
      end;
      goto Retry;
    end;
    form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.window.retry_threetime_error'));
    raise Exception.Create('Cannot Download');
  end;
  if not DirectoryExists(ExtractFileDir(SavePath)) then ForceDirectories(ExtractFileDir(SavePath));
  form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.window.download_success').Replace('${file_success_name}', ViewName));
  srr.SaveToFile(SavePath);
  srr.Free;
end;
//下载MC资源时显示下载进度
procedure TDownloadMethod.ShowCurrentProgress(current, mmax: Integer);
begin
  form_mainform.progressbar_progress_download_bar.Position := current;
  var jd: Currency := current / mmax * 100;
  form_mainform.label_progress_download_progress.Caption := GetLanguage('label_progress_download_progress.caption').Replace('${download_progress}', floattostr(SimpleRoundTo(jd))).Replace('${download_current_count}', inttostr(current)).Replace('${download_all_count}', inttostr(mmax));
end;
{$IFDEF DEBUG}
//显示某些奇怪的错误……
procedure TDownloadMethod.ReceverError(const Sender: TObject; const AError: String);
begin
  ClipBoard.SetTextBuf(pchar(AError));
  messagebox(0, pchar(AError), '', 0);
end;
{$ENDIF}
//在单线程下载的时候，这里会显示下载进度。
procedure TDownloadMethod.ReceiveData(const Sender: TObject;
  AContentLength, AReadCount: Int64; var AAbort: Boolean);
begin
  form_mainform.progressbar_progress_download_bar.Max := AContentLength;
//  if isShowList then form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(Concat('目前已经下载到：', inttostr(AReadCount)));
  if isShowProgress then ShowCurrentProgress(AReadCount, AContentLength);
end;
//获取特定位置的Http流
function TDownloadMethod.GetHTTPRange(url: String; tstart, tend: Integer;
  showProg: Boolean): TStringStream;
begin
  var http := TNetHttpClient.Create(nil); //初始化
  var strt := TStringStream.Create('', TEncoding.UTF8, False); //初始化一个流
  result := nil; //将result定义为一个nil，因为返回值就是一个流。
  try
    with http do begin //以下与上面一样。
      AcceptCharSet := 'utf-8';
      AcceptEncoding := '65001';
      AcceptLanguage := 'en-US';
      ResponseTimeout := 300000;
      ConnectionTimeout := 300000;
      SendTimeout := 300000;
      SecureProtocols := [THTTPSecureProtocol.SSL3, THTTPSecureProtocol.TLS12, THTTPSecureProtocol.TLS13];
      HandleRedirects := True;
      if showProg then OnReceiveData := ReceiveData;
    end;
    try
      http.GetRange(url, tstart, tend, strt);  //获取网络文件流。要存储的流放在最后面。start和end放在中间
      result := strt; //将Get后的流作为返回值返回。。
    except end;
  finally
    http.Free; //释放资源
  end;
end;
//获取https下载，请求头中不包含请求范围，但是可以显示进度！
function TDownloadMethod.GetHTTPNormal(url: String): TStringStream;
begin
  var http := TNetHttpClient.Create(nil); //给初始变量赋值
  var strt := TStringStream.Create('', TEncoding.UTF8, False);
  try
    with http do begin
      AcceptCharSet := 'utf-8';
      AcceptEncoding := '65001';
      AcceptLanguage := 'en-US';
      ResponseTimeout := 300000;
      ConnectionTimeout := 300000;
      SendTimeout := 300000;
      ContentType := 'text/html';
      SecureProtocols := [THTTPSecureProtocol.SSL3, THTTPSecureProtocol.TLS12, THTTPSecureProtocol.TLS13];
      HandleRedirects := True;  //可以网址重定向
      OnReceiveData := ReceiveData;
{$IFDEF DEBUG}
      OnRequestError := ReceverError;
{$ENDIF}
    end;
    try
      var h := http.Get(url, strt);  //获取网络文本
      result := strt; //给最后变量赋值为网络文本的变量，返回
      if LeftStr(IntToStr(h.StatusCode), 1) = '4' then result := nil;
    except  //如果无法获取，则抛出报错
      result := nil;
    end;
  finally
    http.Free; //释放资源
  end;
end;
//获取文件大小
function TDownloadMethod.GetFileSize(aurl: String): Integer;
begin
  var http := TNetHTTPClient.Create(nil); //建立并且初始化一个TNetHTTPClient。
  try
    with http do begin
      AcceptCharSet := 'utf-8'; //设置传输编码为utf-8
      AcceptEncoding := '65001'; //设置传输编码代号为65501
      AcceptLanguage := 'en-US'; //设置传输语言为英语【当然也可以为中文zh-CN，但是不建议。】
      ResponseTimeout := 300000; //设置传输超时为3分20秒。其实就是20万毫秒。
      ConnectionTimeout := 300000; //设置连接超时为3分20秒
      SendTimeout := 300000; //设置发送超时为3分20秒【这里其实不必要设置，因为我们只是获取大小，并不是使用Put传输。Post和Get均不需要设置这个。这里可选哦！】
      SecureProtocols := [THTTPSecureProtocol.SSL3, THTTPSecureProtocol.TLS12, THTTPSecureProtocol.TLS13]; //设置传输协议，可以写很多个，甚至可以写完！
      HandleRedirects := True;  //可以网址重定向
    end;
    try
      form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.custom.judge_can_multi_thread_download'));
      var st := http.Head(aURL);
      if st.ContentLength < BiggestThread then begin
        form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.custom.url_donot_support_download_in_launcher'));
        result := -3;
        exit;
      end;
      if st.StatusCode <> 206 then begin
        form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.custom.url_statucode_is_not_206_and_try_to_cut'));
        var ss := GetHTTPRange(aURL, 1, 10, true);
        if ss.Size > 10 then begin
          ss.SaveToFile(savepath);
          form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.custom.not_allow_cut_use_single_thread_download'));
          result := -3;
          exit;
        end else if ss.Size < 10 then begin  //？？为什么CurseForge但凡如果请求头中包含获取范围的，就直接返回0？？？
          ss := GetHTTPNormal(aurl);
          if ss <> nil then begin
            ss.SaveToFile(savepath);
            form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.custom.not_allow_cut_use_single_thread_download'));
            result := -3;
            exit;
          end else begin
            raise Exception.Create('Download Error...');
          end;
        end;
      end;
      result := st.ContentLength;
    except
      form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.custom.input_url_error_and_this_url_doesnot_has_file'));
      form_mainform.button_progress_clean_download_list.Enabled := true;
      result := -3;
      exit;
    end;
  finally
    http.Free;
  end;
end;
//单独判断MC的部分Libraries的Rule键值是否正确。
function TDownloadMethod.JudgeMCRule(rl: TJsonObject): Boolean;
begin
  result := true;
  try
    var rq := rl.GetValue('rules') as TJSonArray;
    for var J in rq do begin  //下面开始判断rule值里面的action的os是否支持windows
      var r1 := J as TJsonObject;
      var an := r1.GetValue('action').Value;
      if an = 'allow' then begin
        var r2 := r1.GetValue('os') as TJsonObject;
        var r3 := r2.GetValue('name').Value;
        if r3 <> 'windows' then begin result := false; exit; end;
      end else if an = 'disallow' then begin
        var r2 := r1.GetValue('os') as TJsonObject;
        var r3 := r2.GetValue('name').Value;
        if r3 = 'windows' then begin result := false; exit; end;
      end;
    end;
  except
    result := true;
  end;
end;
//跑Forge的Processors。
procedure TDownloadMethod.RunProcessors(profile: String);
begin
  randomize;
  var profilejson := TJsonObject.ParseJSONValue(profile) as TJsonObject;
  var data := profilejson.GetValue('data') as TJsonObject;
  var processors := profilejson.GetValue('processors') as TJsonArray;
  try
    data.ToString;
    processors.ToString;
  except
    form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.forge.installer_version_lower'));
    exit;
  end;
  form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.forge.start_run_processors'));
  var dic := TDictionary<string, string>.Create;
  for var K in data do begin
    var L := K.JsonString.Value;
    var O := K.JsonValue as TJsonObject;
    var cet := '';
    try
      cet := O.GetValue('client').Value;
    except
      continue;
    end;
    if (LeftStr(cet, 1) = '[') and (RightStr(cet, 1) = ']') then begin
      var rp := Concat('"', RootPath, '\libraries\', ConvertNameToPath(cet.Replace('[', '').Replace(']', '')), '"');
      dic.Add(Concat('{', L, '}'), rp);
    end else begin
      if cet.IndexOf('lzma') <> -1 then begin
        dic.Add(Concat('{', L, '}'), Concat('"', LocalTemp, 'LLLauncher\forgetmp\data\client.lzma"'));
      end else begin
        dic.Add(Concat('{', L, '}'), cet);
      end;
    end;
  end;
  if FileExists(GetMCRealPath(SavePath, '.jar')) then begin
    try
      dic['{MINECRAFT_JAR}'] := Concat(GetMCRealPath(SavePath, '.jar'));
    except
      dic.Add('{MINECRAFT_JAR}', Concat(GetMCRealPath(SavePath, '.jar')));
    end;
  end else begin
    if FileExists(GetMCRealPath(GetMCInheritsFrom(SavePath, 'inheritsFrom'), '.jar')) then begin
      try
        dic['{MINECRAFT_JAR}'] := Concat(GetMCRealPath(GetMCInheritsFrom(SavePath, 'inheritsFrom'), '.jar'));
      except
        dic.Add('{MINECRAFT_JAR}', Concat(GetMCRealPath(GetMCInheritsFrom(SavePath, 'inheritsFrom'), '.jar')));
      end;
    end else begin
      form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.forge.cannot_extra_miencraft_jar'));
      abort;
    end;
  end;
  try
    dic['{INSTALLER}'] := Concat('"', LocalTemp, 'LLLauncher\tmp.jar"');
  except
    dic.Add('{INSTALLER}', Concat('"', LocalTemp, 'LLLauncher\tmp.jar"'));
  end;
  if FileExists(Concat(LocalTemp, 'LLLauncher\forgetmp\data\client.lzma')) then begin
    try
      dic['{BINPATCH}'] := Concat('"', LocalTemp, 'LLLauncher\forgetmp\data\client.lzma"');
    except
      dic.Add('{BINPATCH}', Concat('"', LocalTemp, 'LLLauncher\forgetmp\data\client.lzma"'));
    end;
  end else begin
    form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.forge.cannot_extra_lzma'));
    exit;
  end;
  try
    dic['{ROOT}'] := Concat('"', LocalTemp, 'LLLauncher\', inttostr(random(100000)), '"');
  except
    dic.Add('{ROOT}', Concat('"', LocalTemp, 'LLLauncher\', inttostr(random(100000)), '"'));
  end;
  try
    dic['{SIDE}'] := 'client';
  except
    dic.Add('{SIDE}', 'client');
  end;
  form_mainform.progressbar_progress_download_bar.Max := processors.Count;
  form_mainform.progressbar_progress_download_bar.Position := 0;
  form_mainform.label_progress_download_progress.Caption := GetLanguage('label_progress_download_progress.caption').Replace('${download_progress}', '0').Replace('${download_current_count}', '0').Replace('${download_all_count}', inttostr(processors.Count));
  var TDPCount := 0;
  for var I in processors do begin
    inc(TDPCount);
    var J := I as TJsonObject;
    var run := TStringBuilder.Create;
    run.Append('"').Append(javapath).Append('" -cp "');
    try
      var side := (J.GetValue('sides') as TJsonArray)[0].Value;
      if side = 'server' then begin
        ShowCurrentProgress(TDPCount, processors.Count);
        form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.forge.skip_processors').Replace('${processors_count}', inttostr(TDPCount)));
        continue;
      end;
    except end;
    for var K in J.GetValue('classpath') as TJsonArray do begin
      run.Append(RootPath).Append('\libraries\').Append(ConvertNameToPath(K.Value)).Append(';');
    end;
    var mj := Concat(RootPath, '\libraries\', ConvertNameToPath(J.GetValue('jar').Value));
    run.Append(mj).Append('" ').Append(ExtractMainClass(mj)).Append(' ');
    for var K in J.GetValue('args') as TJsonArray do begin
      if (LeftStr(K.Value, 1) = '[') and (RightStr(K.Value, 1) = ']') then begin
        run.Append('"').Append(RootPath).Append('\libraries\').Append(ConvertNameToPath(K.Value.Replace('[', '').Replace(']', ''))).Append('" ');
      end else begin
        run.Append(K.Value).Append(' ');
      end;
    end;
    var eil := run.ToString;
    for var K in dic do begin
      eil := eil.Replace(K.Key, K.Value);
    end;
    RunDOSOnlyWait(eil);
    try
      for var O in J.GetValue('outputs') as TJSONObject do begin
        var ky := O.JsonString.Value;
        var ve := O.JsonValue.Value;
        for var P in dic do begin
          ky := ky.Replace(P.Key, P.Value);
          ve := ve.Replace(P.Key, P.Value);
        end;
        if (LeftStr(ky, 1) = '"') and (RightStr(ky, 1) = '"') then
          ky := ky.Substring(1, ky.Length - 2);
        if (LeftStr(ve, 1) = '''') and (RightStr(ve, 1) = '''') then
          ve := ve.Substring(1, ve.Length - 2);
        if GetFileHash(ky) <> ve.Substring(1, ve.Length - 2) then begin
          ShowCurrentProgress(TDPCount, processors.Count);
          form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.forge.run_processors_error').Replace('${processors_count}', inttostr(TDPCount)));
          abort;
        end;
      end;
    except end;
    ShowCurrentProgress(TDPCount, processors.Count);
    form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.forge.run_processors_success').Replace('${processors_count}', inttostr(TDPCount)));
  end;
end;
//单独处理Forge的玩意……
procedure TDownloadMethod.SimpleForge(profile: String);
var
  DownloadForgeTask: array of TMyThread;
begin
  var ForgeRoot := '';
  var VanillaRoot := '';
  SetLength(DownloadForgeTask, BiggestThread);
  case SelectMode of
    1: begin
      ForgeRoot := 'https://maven.minecraftforge.net';
      VanillaRoot := 'https://libraries.minecraft.net';
      form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.judge.judge_source_official'));
    end;
    2: begin
      ForgeRoot := 'https://bmclapi2.bangbang93.com/maven';
      VanillaRoot := 'https://bmclapi2.bangbang93.com/maven';
      form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.judge.judge_source_bmclapi'));
    end;
  end;
  var ForgeJSONRoot := TJsonObject.ParseJSONValue(profile
    .Replace('https://libraries.minecraft.net', VanillaRoot)
    .Replace('https://maven.minecraftforge.net', ForgeRoot)) as TJsonObject;
  var ForgeProfileRoot: TJsonArray;
  try
    ForgeProfileRoot := ForgeJSONRoot.GetValue('libraries') as TJsonArray;
    ForgeProfileRoot.ToString;
  except
    try
      ForgeProfileRoot := (ForgeJSONRoot.GetValue('versionInfo') as TJsonObject).GetValue('libraries') as TJsonArray;
      ForgeProfileRoot.ToString;
    except
      form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add('downloadlist.forge.cannot_fine_versioninfo_profile');
      abort;
    end;
  end;
  form_mainform.progressbar_progress_download_bar.Max := ForgeProfileRoot.Count;
  form_mainform.progressbar_progress_download_bar.Position := 0;
  form_mainform.label_progress_download_progress.Caption := GetLanguage('label_progress_download_progress.caption').Replace('${download_progress}', '0').Replace('${download_current_count}', '0').Replace('${download_all_count}', inttostr(ForgeProfileRoot.Count));
  form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.forge.current_download_library'));
  var TDFCount := 0;
  var TVFCount := 0;
  var DownloadForgeLibTask: TMyProc := procedure begin
    while TDFCount < ForgeProfileRoot.Count do begin
      var RealJSON := ForgeProfileRoot[TDFCount] as TJsonObject;
      inc(TDFCount);
      if not JudgeMCRule(RealJSON) then continue;
      try
        var dn := RealJSON.GetValue('downloads') as TJsonObject;
        var da := dn.GetValue('artifact') as TJsonObject;
        var sap := da.GetValue('path').Value;
        var sha := da.GetValue('sha1').Value;
        var usl := da.GetValue('url').Value;
        if usl = '' then usl := Concat(ForgeRoot, '/', sap);
        var sapth := Concat(RootPath, '\libraries\', sap.Replace('/', '\'));
        DownloadAsWindow(sapth, usl, sha, ExtractFileName(sapth), true, SelectMode);
      except end;
      var RealURL := '';
      try RealURL := RealJSON.GetValue('name').Value; except continue; end;
      if RealURL = '' then continue;
      if (RealURL.IndexOf('linux') <> -1) or (RealURL.IndexOf('macos') <> -1) or (RealURL.IndexOf('osx') <> -1) then continue;
      var RealPath := Concat(RootPath, '\libraries\', ConvertNameToPath(RealURL));
      RealURL := Concat(ForgeRoot, '/', ConvertNameToPath(RealURL).Replace('\', '/'));
      try
        var lul := RealJSON.GetValue('url').Value;
        if RightStr(lul, 1) <> '/' then lul := Concat(lul, '/');
        RealURL := Concat(lul, ConvertNameToPath(RealJSON.GetValue('name').Value).Replace('\', '/'));
      except end;
      try DownloadAsWindow(RealPath, RealURL, '', ExtractFileName(RealPath), true, SelectMode); except end;
      inc(TVFCount);
      ShowCurrentProgress(TVFCount, ForgeProfileRoot.Count);
    end;
  end;
  for var I := 0 to BiggestThread - 1 do begin
    DownloadForgeTask[I] := TMyThread.CreateAnonymousThread(DownloadForgeLibTask);
    DownloadForgeTask[I].Start;
  end;
  for var I := 0 to BiggestThread - 1 do begin
    if Assigned(DownloadForgeTask[I]) then begin
      DownloadForgeTask[I].WaitFor;
      DownloadForgeTask[I].Destroy;
    end;
  end;
  RunProcessors(profile);
end;
//下载自定义文件
procedure TDownloadMethod.DownloadCustomFile;
var
  DownloadTask: array of TMyThread;
begin
  var ttime := GetTickCount;
  SetLength(DownloadTask, BiggestThread);
  if BiggestThread = 1 then begin
    form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.custom.thread_one_to_single_thread_download'));
    var ss := GetHTTPNormal(url);
    if ss = nil then begin
      form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.custom.single_thread_download_error'));
      abort;
    end;
    ss.SaveToFile(savepath);
    exit;
  end;
  var filesize := GetFileSize(url);
  if filesize = -3 then begin
    exit;
  end;
  if isShowList then form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.custom.url_allow_multi_thread_download'));
  if isShowList then form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.custom.url_file_size').Replace('${url_file_size}', inttostr(filesize)));
  form_mainform.progressbar_progress_download_bar.Max := BiggestThread;
  form_mainform.progressbar_progress_download_bar.Position := 0;
  form_mainform.label_progress_download_progress.Caption := GetLanguage('label_progress_download_progress.caption').Replace('${download_progress}', '0').Replace('${download_current_count}', '0').Replace('${download_all_count}', inttostr(BiggestThread));
  var fileavg := trunc(filesize / BiggestThread); //记录网络文件除以最大线程后的平均值。
  var sc := 0;
  var sf := 0;
  if not DirectoryExists(Concat(LocalTemp, 'LLLauncher\downloadtmp')) then
    ForceDirectories(Concat(LocalTemp, 'LLLauncher\downloadtmp'));
  var DownloadProc := procedure(dt, tstart, tend: Integer)
  label
    Retry;
  begin
    var TempSavePath := Concat(LocalTemp, 'LLLauncher\downloadtmp', ChangeFileExt(ExtractFileName(savepath), ''), '-', inttostr(dt), '.tmp');
    Retry: ;
    var stt: TStringStream := GetHttpRange(url, tstart, tend, false); //Get特定位置的流。
    if stt = nil then begin
      if IsShowList then form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.custom.cut_download_error'));
      DeleteDirectory(Concat(LocalTemp, 'LLLauncher\downloadtmp')); //删掉所有tmp文件
      abort;
    end else begin
      stt.SaveToFile(TempSavePath);
      if IsShowList then form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.custom.cut_download_success').Replace('${cut_download_count}', inttostr(dt)));
      stt.Free;
    end;
    inc(sf);
    var jd: Currency := 100 * sf / BiggestThread;
    if isShowProgress then form_mainform.progressbar_progress_download_bar.Position := sf;
    if isShowProgress then form_mainform.label_progress_download_progress.Caption := GetLanguage('label_progress_download_progress.caption').Replace('${download_progress}', floattostr(SimpleRoundTo(jd))).Replace('${download_current_count}', inttostr(sf)).Replace('${download_all_count}', inttostr(BiggestThread));
  end;
  var downp: TMyProc := procedure
  begin
    inc(sc);
    var tstart := fileavg * (sc - 1);
    var tend := fileavg * sc - 1;
    if sc = BiggestThread then tend := filesize;
    DownloadProc(sc, tstart, tend);
  end;
  for var I := 0 to BiggestThread - 1 do begin //循环生成【最大线程数量】个任务
    DownloadTask[I] := TMyThread.CreateAnonymousThread(downp);
    DownloadTask[I].Start;
  end;
  for var I := 0 to BiggestThread - 1 do begin
    if Assigned(DownloadTask[I]) then begin
      DownloadTask[I].WaitFor;
      DownloadTask[I].Destroy;
    end;
  end;
  var mStream1 := TMemoryStream.Create;
  var mStream2 := TMemoryStream.Create;
  try
    for var I := 1 to BiggestThread do begin
      var tmpfile := Concat(LocalTemp, 'LLLauncher\downloadtmp', ChangeFileExt(ExtractFileName(savepath), ''), '-', inttostr(i), '.tmp');
      if not FileExists(tmpfile) then begin
        form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.custom.cut_download_join_error'));
        mStream1.Free;
        mStream2.Free;
        abort; //退出函数
      end;
      mStream2.LoadFromFile(tmpfile);
      mStream1.Seek(mStream1.Size, soFromBeginning);
      mStream1.CopyFrom(mStream2, mStream2.Size);
      mStream2.Clear;
    end;
    mStream1.SaveToFile(savepath);
  finally
    mStream1.Free; //释放资源
    mStream2.Free;
  end;
  DeleteDirectory(Concat(LocalTemp, 'LLLauncher\downloadtmp'));
  form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.custom.download_finish').Replace('${download_finish_time}', floattostr((GetTickCount - ttime) / 1000))); //这里记录了耗时【但是这里不是很必要，除非你需要耗时。】
end;
//下载Minecraft
procedure TDownloadMethod.DownloadMinecraft;
var
  DownloadLibraries: array of TMyThread;
  DownloadResource: array of TMyThread;
begin
  var ttime := GetTickCount;
  var SourceJSON := TJSONObject.ParseJSONValue(url) as TJsonObject;
  var VanillaPath := '';
  try
    var yid := SourceJSON.GetValue('inheritsFrom').Value; //查获inheritsForm的下载。。。
    var spf := GetMCInheritsFrom(savepath, 'inheritsFrom');
    if spf = savepath then raise Exception.Create('No InheritsFrom');
    if spf = '' then begin
      form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.mc.json_has_inheritsfrom'));
      var VanillaVer := '';
      case SelectMode of
        1: VanillaVer := 'https://piston-meta.mojang.com/mc/game/version_manifest.json';
        2: VanillaVer := 'https://bmclapi2.bangbang93.com/mc/game/version_manifest.json';
        else abort;
      end;
      if MCRootJSON = nil then begin
        var VanillaJSON := GetWebText(VanillaVer);
        if VanillaJSON = '' then begin
          form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.mc.get_vanilla_json_error'));
          abort;
        end;
        form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.mc.get_vanilla_json_success'));
        MCRootJSON := TJsonObject.ParseJSONValue(VanillaJSON) as TJsonObject;
      end;
      var VersionArray := MCRootJSON.GetValue('versions') as TJsonArray;
      var VanillaURL := '';
      for var I in VersionArray do begin
        var J := I as TJsonObject;
        if J.GetValue('id').Value = yid then begin
          VanillaURL := J.GetValue('url').Value;
          break;
        end;
      end;
      var VersionJSON := GetWebText(VanillaURL);
      if VersionJSON = '' then begin
        form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.mc.get_version_json_error'));
        abort;
      end;
      form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.mc.get_version_json_success'));
      VanillaPath := Concat(ExtractFilePath(SavePath), '\', yid);
      SetFile(Concat(VanillaPath, '\', yid, '.json'), (TJSONObject.ParseJSONValue(VersionJSON) as TJsonObject)
        .AddPair('clientVersion', yid).Format.Replace('\', ''));
    end;
  except end;
  var tmp1 := GetMCInheritsFrom(SavePath, 'inheritsFrom');
  var tmp2 := GetMCRealPath(tmp1, '.json');
  var tmp3 := GetFile(tmp2);
  url := ReplaceMCInheritsFrom(url, tmp3);
  url := url.Replace('\', '');
  var ResourceRoot := '';
  var LibrariesRoot := '';
  case SelectMode of  //修改下载源
    1: begin
      ResourceRoot := 'https://resources.download.minecraft.net';
      LibrariesRoot := 'https://libraries.minecraft.net';
      form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.judge.judge_source_official'));
    end;
    2: begin
      url := url
        .Replace('https://piston-meta.mojang.com', 'https://bmclapi2.bangbang93.com')
        .Replace('https://piston-data.mojang.com', 'https://bmclapi2.bangbang93.com')
        .Replace('https://libraries.minecraft.net', 'https://bmclapi2.bangbang93.com/maven')
        .Replace('https://launchermeta.mojang.com', 'https://bmclapi2.bangbang93.com')
        .Replace('https://launcher.mojang.com', 'https://bmclapi2.bangbang93.com')
        .Replace('https://files.minecraftforge.net/maven', 'https://bmclapi2.bangbang93.com/maven')
        .Replace('http://files.minecraftforge.net/maven', 'https://bmclapi2.bangbang93.com/maven')
        .Replace('https://maven.minecraftforge.net', 'https://bmclapi2.bangbang93.com/maven')
        .Replace('https://maven.fabricmc.net', 'https://bmclapi2.bangbang93.com/maven');
      ResourceRoot := 'https://bmclapi2.bangbang93.com/assets';
      LibrariesRoot := 'https://bmclapi2.bangbang93.com/maven';
      form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.judge.judge_source_bmclapi'));
    end;
    else abort;
  end;
  SetLength(DownloadLibraries, BiggestThread);
  SetLength(DownloadResource, BiggestThread);
  SourceJSON := TJsonObject.ParseJSONValue(url) as TJsonObject;
  if VanillaPath = '' then VanillaPath := tmp1;
  var AssetPath := Concat(RootPath, '\assets\indexes\', (SourceJSON.GetValue('assetIndex') as TJsonObject).GetValue('id').Value, '.json');
  var ClientJSON := (SourceJSON.GetValue('downloads') as TJsonObject).GetValue('client') as TJsonObject;
  var JARURL := ClientJSON.GetValue('url').Value;
  var SHA := ClientJSON.GetValue('sha1').Value;
  var AssetURL := (SourceJSON.GetValue('assetIndex') as TJsonObject).GetValue('url').Value;
  var bo := true;
  SearchDirProc(VanillaPath, false, true, procedure(T: String) begin
    if RightStr(T, 4).Equals('.jar') then begin
      if GetFileHash(T).Equals(SHA) then begin
        form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.mc.main_version_jar_exists'));
        bo := false;
      end;
    end;
  end);
  if bo then begin
    form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.mc.downloading_main_version_jar'));
    DownloadStart(JARURL, Concat(VanillaPath, '\', ExtractFileName(VanillaPath), '.jar'), '', BiggestThread, 0, 1, '', '', false);
    form_mainform.button_progress_clean_download_list.Enabled := false;
    form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.mc.download_main_version_jar_finish'));
  end;
  if not FileExists(AssetPath) then begin
    form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.mc.downloading_asset_index_json'));
    var atd := GetWebText(AssetURL);
    if atd = '' then begin
      form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add('downloadlist.mc.downloading_asset_index_error');
      abort;
    end;
    var atj := TJsonObject.ParseJSONValue(atd) as TJsonObject;
    SetFile(AssetPath, atj.Format);
    form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.mc.download_asset_index_finish'));
  end else begin
    form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.mc.asset_index_json_exists'));
  end;
  var LibrariesJSONRoot := SourceJSON.GetValue('libraries') as TJsonArray;
  form_mainform.progressbar_progress_download_bar.Max := LibrariesJSONRoot.Count;
  form_mainform.progressbar_progress_download_bar.Position := 0;
  form_mainform.label_progress_download_progress.Caption := GetLanguage('label_progress_download_progress.caption').Replace('${download_progress}', '0').Replace('${download_current_count}', '0').Replace('${download_all_count}', inttostr(LibrariesJSONRoot.Count));
  form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.mc.current_download_library'));
  var TDLCount := 0;
  var TVLCount := 0;
  var DownloadLibrariesTask: TMyProc := procedure begin
    while TDLCount < LibrariesJSONRoot.Count do begin
      var RealJSON := LibrariesJSONRoot[TDLCount] as TJSONObject;
      inc(TDLCount);
      if not JudgeMCRule(RealJSON) then begin continue; end;
      try
        var dn := RealJSON.GetValue('downloads') as TJsonObject;
        var da := dn.GetValue('artifact') as TJsonObject;
        var sap := da.GetValue('path').Value;
        var sha := da.GetValue('sha1').Value;
        var usl := da.GetValue('url').Value;
        if usl = '' then usl := Concat(LibrariesRoot, '/', sap);
        var sapth := Concat(RootPath, '\libraries\', sap.Replace('/', '\'));
        DownloadAsWindow(sapth, usl, sha, ExtractFileName(sapth), true, SelectMode);
      except end;
      try
        var dn := RealJSON.GetValue('downloads') as TJsonObject;
        var da := dn.GetValue('classifiers') as TJsonObject;
        var soo := da.GetValue('natives-windows') as TJsonObject;
        var sap := soo.GetValue('path').Value;
        var sha := soo.GetValue('sha1').Value;
        var usl := soo.GetValue('url').Value;
        var sapth := Concat(RootPath, '\libraries\', sap.Replace('/', '\'));
        DownloadAsWindow(sapth, usl, sha, ExtractFileName(sapth), true, SelectMode);
      except end;
      try
        var dn := RealJSON.GetValue('downloads') as TJsonObject;
        var da := dn.GetValue('classifiers') as TJsonObject;
        var soo := da.GetValue(Concat('natives-windows-64')) as TJsonObject;
        var sap := soo.GetValue('path').Value;
        var sha := soo.GetValue('sha1').Value;
        var usl := soo.GetValue('url').Value;
        var sapth := Concat(RootPath, '\libraries\', sap.Replace('/', '\'));
        DownloadAsWindow(sapth, usl, sha, ExtractFileName(sapth), true, SelectMode);
      except end;
      var RealURL := '';
      try RealURL := RealJSON.GetValue('name').Value; except continue; end;
      if RealURL = '' then continue;
      if (RealURL.IndexOf('linux') <> -1) or (RealURL.IndexOf('macos') <> -1) or (RealURL.IndexOf('osx') <> -1) then continue;
      try
        var JSONNative := RealJSON.GetValue('natives') as TJsonObject;
        var JSONArch := JSONNative.GetValue('windows').Value.Replace('${arch}', '64');
        RealURL := Concat(RealURL, ':', JSONArch);
      except end;
      var RealSave := Concat(RootPath, '\libraries\', ConvertNameToPath(RealURL));
      RealURL := Concat(LibrariesRoot, '/', ConvertNameToPath(RealURL).Replace('\', '/'));
      try
        var lul := RealJSON.GetValue('url').Value;
        if RightStr(lul, 1) <> '/' then lul := Concat(lul, '/');
        RealURL := Concat(lul, ConvertNameToPath(RealJSON.GetValue('name').Value).Replace('\', '/'));
      except end;
      try DownloadAsWindow(RealSave, RealURL, '', ExtractFileName(RealSave), true, SelectMode); except end;
      inc(TVLCount);
      ShowCurrentProgress(TVLCount, LibrariesJSONRoot.Count);
    end;
  end;
  for var I := 0 to BiggestThread - 1 do begin
    DownloadLibraries[I] := TMyThread.CreateAnonymousThread(DownloadLibrariesTask);
    DownloadLibraries[I].Start;
  end;
  for var I := 0 to BiggestThread - 1 do begin
    if Assigned(DownloadLibraries[I]) then begin
      DownloadLibraries[I].WaitFor;
      DownloadLibraries[I].Destroy;
    end;
  end;
  var AssetsJSONRoot := (TJsonObject.ParseJSONValue(GetFile(AssetPath)) as TJsonObject).GetValue('objects') as TJSONObject;
  form_mainform.label_progress_download_progress.Caption := GetLanguage('label_progress_download_progress.caption').Replace('${download_progress}', '0').Replace('${download_current_count}', '0').Replace('${download_all_count}', inttostr(AssetsJSONRoot.Count));
  form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.mc.download_library_success'));
  form_mainform.progressbar_progress_download_bar.Max := AssetsJSONRoot.Count;
  form_mainform.progressbar_progress_download_bar.Position := 0;
  var TDACount := 0;
  var TVACount := 0;
  var DownloadAssetsTask: TMyProc := procedure begin
    while TDACount < AssetsJSONRoot.Count do begin
      var sr := AssetsJSONRoot.Pairs[TDACount];
      inc(TDACount);
      var er := sr.JsonString.Value;
      var ne := sr.JsonValue as TJsonObject;
      var hs := ne.GetValue('hash').Value;
      var lsr := LeftStr(hs, 2);
      var lu := Concat(ResourceRoot, '/', lsr, '/', hs);
      var svp := Concat(RootPath, '\assets\objects\', lsr, '\', hs);
      var bfs := Concat(RootPath, '\assets\virtual\legacy\', er.Replace('/', '\'));
      try DownloadAsWindow(svp, lu, hs, er, false, SelectMode); except end;
      BackupFile(svp, bfs);
      inc(TVACount);
      ShowCurrentProgress(TVACount, AssetsJSONRoot.Count);
    end;
  end;
  for var I := 0 to BiggestThread - 1 do begin
    DownloadResource[I] := TMyThread.CreateAnonymousThread(DownloadAssetsTask);
    DownloadResource[I].Start;
  end;
  for var I := 0 to BiggestThread - 1 do begin
    if Assigned(DownloadResource[I]) then begin
      DownloadResource[I].WaitFor;
      DownloadResource[I].Destroy;
    end;
  end;
  form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.mc.download_assets_success'));
  var ProfilePath := Concat(SavePath, '\install_profile.json');
  if FileExists(ProfilePath) then begin
    form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.mc.judge_download_forge'));
    SimpleForge(GetFile(ProfilePath));
  end;
  form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.mc.download_mc_finish').Replace('${download_finish_time}', floattostr((GetTickCount - ttime) / 1000)));
end;
//下载Java
procedure TDownloadMethod.DownloadJava;
var
  DownloadJavaTask: array of TMyThread;
begin
  var ttime := GetTickCount;
  var RootURL := '';
  SetLength(DownloadJavaTask, BiggestThread);
  case SelectMode of
    1: form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.judge.judge_source_official'));
    2: begin
      url := url
        .Replace('https://piston-meta.mojang.com', 'https://bmclapi2.bangbang93.com')
        .Replace('https://launchermeta.mojang.com', 'https://bmclapi2.bangbang93.com');
      form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.judge.judge_source_bmclapi'));
    end;
    else abort;
  end;
  var JavaFileJSON := (TJsonObject.ParseJSONValue(url) as TJsonObject).GetValue('files') as TJSONObject;
  form_mainform.progressbar_progress_download_bar.Max := JavaFileJSON.Count;
  form_mainform.progressbar_progress_download_bar.Position := 0;
  form_mainform.label_progress_download_progress.Caption := GetLanguage('label_progress_download_progress.caption').Replace('${download_progress}', '0').Replace('${download_current_count}', '0').Replace('${download_all_count}', inttostr(JavaFileJSON.Count));
  var TDJCount := 0;
  var TVJCount := 0;
  var DownloadJava: TMyProc := procedure begin
    while TDJCount < JavaFileJSON.Count do begin
      var sr := JavaFileJSON.Pairs[TDJCount];
      inc(TDJCount);
      var er := sr.JsonString.Value;
      var ne := sr.JsonValue as TJsonObject;
      var te := ne.GetValue('type').Value;
      var svp := Concat(savepath, '\', er.Replace('/', '\'));
      if te <> 'directory' then begin
        try
          var robj := (ne.GetValue('downloads') as TJsonObject).GetValue('raw') as TJsonObject;
          var rurl := robj.GetValue('url').Value;
          var rsha := robj.GetValue('sha1').Value;
          DownloadAsWindow(svp, rurl, rsha, er, false, SelectMode);
        except end;
      end;
      inc(TVJCount);
      ShowCurrentProgress(TVJCount, JavaFileJSON.Count);
    end;
  end;
  for var I := 0 to BiggestThread - 1 do begin
    DownloadJavaTask[I] := TMyThread.CreateAnonymousThread(DownloadJava);
    DownloadJavaTask[I].Start;
  end;
  for var I := 0 to BiggestThread - 1 do begin
    DownloadJavaTask[I].WaitFor;
    DownloadJavaTask[I].Destroy;
  end;
  form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.java.download_java_finish').Replace('${download_finish_time}', floattostr((GetTickCount - ttime) / 1000)));
end;
//下载Forge
procedure TDownloadMethod.DownloadForge;
begin
  var ttime := GetTickCount;
  form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.forge.download_forge_installer_start'));
  try
    DownloadStart(url, Concat(LocalTemp, 'LLLauncher\tmp.jar'), '', BiggestThread, 0, 1);
  except
    form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.forge.forge_version_not_allow_install'));
    abort;
  end;
  form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.forge.download_forge_installer_success'));
  if not Unzip(Concat(LocalTemp, 'LLLauncher\tmp.jar'), Concat(LocalTemp, '\LLLauncher\forgetmp')) then begin
    form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.forge.unzip_installer_error'));
    abort;
  end;
  var p1 := Concat(LocalTemp, 'LLLauncher\forgetmp\version.json');
  var p2 := Concat(LocalTemp, 'LLLauncher\forgetmp2\version.json');
  var output := '';
  if FileExists(p1) then begin
    var sh := TJSonObject.ParseJSONValue(GetFile(p1)) as TJsonObject;
    CopyFile(pchar(p1), pchar(Concat(savepath, '\', sh.GetValue('id').Value, '.json')), false);
    output := GetFile(Concat(savepath, '\', sh.GetValue('id').Value, '.json'));
  end else begin
    Unzip(GetMCRealPath(Concat(LocalTemp, 'LLLauncher\forgetmp'), '.jar'), Concat(LocalTemp, '\LLLauncher\forgetmp2'));
    if FileExists(p2) then begin
      var sh := TJSonObject.ParseJSONValue(GetFile(p2)) as TJsonObject;
      CopyFile(pchar(p2), pchar(Concat(savepath, '\', sh.GetValue('id').Value, '.json')), false);
      output := GetFile(Concat(savepath, '\', sh.GetValue('id').Value, '.json'));
    end else begin
      form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add('downloadlist.forge.cannot_find_version_json');
      DeleteDirectory(Concat(LocalTemp, 'LLLauncher'));
      abort;
    end;
  end;
  form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.forge.get_forge_json'));
  var ProfilePath := Concat(LocalTemp, 'LLLauncher\forgetmp\install_profile.json');
  if not FileExists(ProfilePath) then begin
    form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add('downloadlist.forge.cannot_find_installprofile_json');
    DeleteDirectory(Concat(LocalTemp, 'LLLauncher'));
    exit;
  end;
  CopyFile(pchar(ProfilePath), pchar(Concat(savepath, '\install_profile.json')), false);
  form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.forge.copy_installprofile_success_setup_mc'));
  DownloadStart(output, SavePath, RootPath, BiggestThread, SelectMode, 2, javapath, VanillaVersion, isShowList, isShowProgress);
  DeleteDirectory(Concat(LocalTemp, 'LLLauncher'));
  form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.forge.download_forge_success').Replace('${download_finish_time}', floattostr((GetTickCount - ttime) / 1000)));
end;
//下载你可爱的整合包去罢！
procedure TDownloadMethod.DownloadModpack;
begin
  var ttime := GetTickCount;
  form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.modpack.download_modpack_start'));
  var dl := SplitString(url, '@');
  if dl[0].Equals('Modrinth') then begin

  end else if dl[0].Equals('MultiMC') then begin

  end else if dl[0].Equals('MCBBS') then begin

  end else if dl[0].Equals('CurseForge') then begin

  end;
end;
//设置所有参数。
constructor TDownloadMethod.InitDownload(url, SavePath, RootPath: String; BiggestThread, SelectMode: Integer; javapath, VanillaVersion: String; isShowList: Boolean; isShowProgress: Boolean);
begin
  self.url := url;
  self.SavePath := SavePath;
  self.RootPath := RootPath;
  self.BiggestThread := BiggestThread;
  self.SelectMode := SelectMode;
  self.javapath := javapath;
  self.VanillaVersion := VanillaVersion;
  self.isShowList := isShowList;
  self.isShowProgress := isShowProgress;
end;
//通过LoadSource开启对应的下载操作
procedure TDownloadMethod.StartDownload(LoadSource: Integer);
begin
  case LoadSource of
    1: DownloadCustomFile;
    2: DownloadMinecraft;
    3: DownloadJava;
    4: DownloadForge;
    5: DownloadModpack;
    else abort;
  end;
end;
//调用函数
//第一个url是下载链接，如果LoadSource是2、3、4的话，则需要为对应的json。如果Loadsource是5的话，则这里需要指定'Modrinth'、'Curseforge'、'MCBBS'、'MultiMC'，因为程序会自动找到temp路径下的LLLauncher下的importmodpack路径进行导入。
//第二个SavePath是保存路径。当LoadSource为2、4、5的时候，需要为该Minecraft的version文件夹。
//第三个RootPath是根路径，只有LoadSource为2、4、5的时候，则需要指定对应的.minecraft文件夹。否则为空。
//第四个BiggestThread是最大线程。
//第五个SelectMode是下载源，只有1、2，如果为1，则是官方下载源，2为bmclapi。如果是国外则默认全部都是1，无法使用2，如果是下载自定义文件，则指定0即可！
//第六个LoadSource是加载顺序，1为下载自定义文件，2为下载Minecraft，3为下载Java，4为下载Forge，5是导入整合包。
//第七个javapath是本地Java路径，只有LoadSource为4、5时才需要，并且5还必须是整合包模组加载器为Forge时才必须指定，否则为空。
//第八个VanillaVersion是将要下载的MC原版名称，只有LoaderSource为2、4、5时才需要，否则为空。当补全文件时可以为空。
//第九个isShowList为是否展示下载列表框（一般都是False）
//第十个isShowProgress为是否展示下载进度框（一般都是True）
procedure DownloadStart(url, SavePath, RootPath: String; BiggestThread, SelectMode, LoadSource: Integer; javapath: String = ''; VanillaVersion: String = ''; isShowList: Boolean = false; isShowProgress: Boolean = true);
begin
  try
//    form_mainform.button_progress_clean_download_list.Enabled := false;
    TDownloadMethod.InitDownload(url, SavePath, RootPath, BiggestThread, SelectMode, javapath, VanillaVersion, isShowList, isShowProgress).StartDownload(LoadSource);
//    form_mainform.button_progress_clean_download_list.Enabled := true;
  except
    form_mainform.button_progress_clean_download_list.Enabled := true;
    abort;
  end;
end;

end.
