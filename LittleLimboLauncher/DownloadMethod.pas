unit DownloadMethod;

interface

uses
  System.Net.HttpClient, System.Net.HttpClientComponent, System.Generics.Collections, JSON,
  SysUtils, Classes, Math, Windows, Threading;

procedure DownloadStart(url, SavePath, RootPath: String; BiggestThread, SelectMode, LoadSource: Integer; isShowList: Boolean = true; isShowProgress: Boolean = true);

implementation

uses
  DownloadProgressForm, MainMethod, LanguageMethod;

type
  TDownloadMethod = class
  protected
    function GetFileSize(aurl: String): Integer;
    function GetHTTPNormal(url: String): TStringStream;
    procedure ReceiveData(const Sender: TObject;
      AContentLength, AReadCount: Int64; var AAbort: Boolean);
    function GetHTTPRange(url: String; tstart, tend: Integer;
      showProg: Boolean): TStringStream;
  end;

var
  url, SavePath, RootPath, TempPath: String;
  BiggestThread, SelectMode: Integer;
  isShowList, isShowProgress: Boolean;
  dm: TDownloadMethod;
//在单线程下载的时候，这里会显示下载进度。
procedure TDownloadMethod.ReceiveData(const Sender: TObject;
  AContentLength, AReadCount: Int64; var AAbort: Boolean);
begin
  form_progress.progressbar_progress_download_bar.Max := AContentLength;
  var jd: Currency := 100 * AReadCount / AContentLength; //设置下载进度。这里用100乘以自增sf然后除以最大线程。如果自增达到了与最大线程一样的话，那么就会达到100。
  if isShowProgress then form_progress.label_progress_download_progress.Caption := Concat('下载进度：', floattostr(SimpleRoundTo(jd)), '% | ', inttostr(AReadCount), '/', inttostr(AContentLength));//输出下载进度。给一个标签添加下载进度。使用了保留两位小数。
  if isShowList then form_progress.listbox_progress_download_list.ItemIndex := form_progress.listbox_progress_download_list.Items.Add(Concat('目前已经下载到：', inttostr(AReadCount)));
  if isShowProgress then form_progress.progressbar_progress_download_bar.Position := AReadCount;
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
      ResponseTimeout := 200000;
      ConnectionTimeout := 200000;
      SendTimeout := 200000;
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
      ResponseTimeout := 200000;
      ConnectionTimeout := 200000;
      SendTimeout := 200000;
      ContentType := 'text/html';
      SecureProtocols := [THTTPSecureProtocol.SSL3, THTTPSecureProtocol.TLS12, THTTPSecureProtocol.TLS13];
      HandleRedirects := True;  //可以网址重定向
      OnReceiveData := ReceiveData;
    end;
    try
      var h := http.Get(url, strt);  //获取网络文本
      result := strt; //给最后变量赋值为网络文本的变量，返回
      if h.StatusCode = 404 then result := nil;
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
  result := 0; //设定初始返回值为0
  try
    with http do begin
      AcceptCharSet := 'utf-8'; //设置传输编码为utf-8
      AcceptEncoding := '65001'; //设置传输编码代号为65501
      AcceptLanguage := 'en-US'; //设置传输语言为英语【当然也可以为中文zh-CN，但是不建议。】
      ResponseTimeout := 200000; //设置传输超时为3分20秒。其实就是20万毫秒。
      ConnectionTimeout := 200000; //设置连接超时为3分20秒
      SendTimeout := 200000; //设置发送超时为3分20秒【这里其实不必要设置，因为我们只是获取大小，并不是使用Put传输。Post和Get均不需要设置这个。这里可选哦！】
      SecureProtocols := [THTTPSecureProtocol.SSL3, THTTPSecureProtocol.TLS12, THTTPSecureProtocol.TLS13]; //设置传输协议，可以写很多个，甚至可以写完！
      HandleRedirects := True;  //可以网址重定向
    end;
    try
      form_progress.listbox_progress_download_list.ItemIndex := form_progress.listbox_progress_download_list.Items.Add(GetLanguageText('downloadlist.custom.judge_can_multi_thread_download'));
      var st := http.Head(aURL);
      if st.ContentLength < BiggestThread then begin
        form_progress.listbox_progress_download_list.ItemIndex := form_progress.listbox_progress_download_list.Items.Add(GetLanguageText('downloadlist.custom.url_donot_support_download_in_launcher'));
        result := -3;
        exit;
      end;
      if st.StatusCode <> 206 then begin
        form_progress.listbox_progress_download_list.ItemIndex := form_progress.listbox_progress_download_list.Items.Add(GetLanguageText('downloadlist.custom.url_statucode_is_not_206_and_try_to_cut'));
        var ss := GetHTTPRange(aURL, 1, 10, true);
        if ss.Size > 10 then begin
          ss.SaveToFile(savepath);
          form_progress.listbox_progress_download_list.ItemIndex := form_progress.listbox_progress_download_list.Items.Add(GetLanguageText('downloadlist.custom.not_allow_cut_use_single_thread_download'));
          result := -3;
          exit;
        end else if ss.Size < 10 then begin  //？？？为什么CurseForge但凡如果请求头中包含获取范围的，就直接返回0？？？
          ss := dm.GetHTTPNormal(aurl);
          if ss <> nil then begin
            ss.SaveToFile(savepath);
            form_progress.listbox_progress_download_list.ItemIndex := form_progress.listbox_progress_download_list.Items.Add(GetLanguageText('downloadlist.custom.not_allow_cut_use_single_thread_download'));
            result := -3;
            exit;
          end else begin
            raise Exception.Create('Download Error...');
          end;
        end;
      end;
      result := st.ContentLength;
    except
      form_progress.listbox_progress_download_list.ItemIndex := form_progress.listbox_progress_download_list.Items.Add(GetLanguageText('downloadlist.custom.input_url_error_and_this_url_doesnot_has_file'));
      form_progress.button_progress_clean_download_list.Enabled := true;
      result := -3;
      abort;
    end;
  finally
    http.Free;
  end;
end;
//下载自定义文件
procedure DownloadCustomFile;
var
  DownloadTask: array of ITask;
begin
  var time := GetTickCount;
  SetLength(DownloadTask, BiggestThread);
  if BiggestThread = 1 then begin
    form_progress.listbox_progress_download_list.ItemIndex := form_progress.listbox_progress_download_list.Items.Add(GetLanguageText('downloadlist.custom.thread_one_to_single_thread_download'));
    var ss := dm.GetHTTPNormal(url);
    if ss = nil then begin
      form_progress.listbox_progress_download_list.ItemIndex := form_progress.listbox_progress_download_list.Items.Add(GetLanguageText('downloadlist.custom.single_thread_download_error'));
      abort;
    end;
    ss.SaveToFile(savepath);
    exit;
  end;
  var filesize := dm.GetFileSize(url);
  if filesize = -3 then begin
    exit;
  end;
  if isShowList then form_progress.listbox_progress_download_list.ItemIndex := form_progress.listbox_progress_download_list.Items.Add(GetLanguageText('downloadlist.custom.url_allow_multi_thread_download'));
  if isShowList then form_progress.listbox_progress_download_list.ItemIndex := form_progress.listbox_progress_download_list.Items.Add(GetLanguageText('downloadlist.custom.url_file_size').Replace('${url_file_size}', inttostr(filesize)));
  form_progress.progressbar_progress_download_bar.Max := BiggestThread;
  form_progress.progressbar_progress_download_bar.Position := 0;
  form_progress.label_progress_download_progress.Caption := GetLanguageText('label_progress_download_progress.caption').Replace('${download_progress}', '0').Replace('${download_current_count}', '0').Replace('${download_all_count}', '0');
  var fileavg := trunc(filesize / BiggestThread); //记录网络文件除以最大线程后的平均值。
  var sc := 0;
  var sf := 0;
  var cc := 0;
  if not DirectoryExists(Concat(TempPath, 'LLLauncher\downloadtmp')) then
    ForceDirectories(Concat(TempPath, 'LLLauncher\downloadtmp'));
  var DownloadProc := procedure(dt, tstart, tend: Integer)
  label
    Retry;
  begin
    var TempSavePath := Concat(TempPath, 'LLLauncher\downloadtmp', ChangeFileExt(ExtractFileName(savepath), ''), '-', inttostr(dt), '.tmp');
    Retry: ;
    var stt: TStringStream := dm.GetHttpRange(url, tstart, tend, false); //Get特定位置的流。
    if stt = nil then begin
      if IsShowList then form_progress.listbox_progress_download_list.ItemIndex := form_progress.listbox_progress_download_list.Items.Add(GetLanguageText('downloadlist.custom.single_thread_download_error').Replace('${cut_download_count}', inttostr(dt)));
      inc(cc);
      if cc <= 3 then begin //重试部分
        form_progress.listbox_progress_download_list.ItemIndex := form_progress.listbox_progress_download_list.Items.Add(GetLanguageText('downloadlist.custom.cut_download_retry').Replace('${cut_download_retry}', inttostr(cc)));
        goto Retry;
      end;
      for var c := 1 to BiggestThread do deleteFile(pchar(Concat(TempPath, 'LLLauncher\downloadtmp', ChangeFileExt(ExtractFileName(savepath), ''), '-', inttostr(c), '.tmp'))); //删掉所有tmp文件
      form_progress.listbox_progress_download_list.ItemIndex := form_progress.listbox_progress_download_list.Items.Add(GetLanguageText('downloadlist.custom.retry_threetime_error'));
      form_progress.button_progress_clean_download_list.Enabled := true;
      abort;
    end else begin
      stt.SaveToFile(TempSavePath);
      if IsShowList then form_progress.listbox_progress_download_list.ItemIndex := form_progress.listbox_progress_download_list.Items.Add(GetLanguageText('downloadlist.custom.single_thread_download_success').Replace('${cut_download_count}', inttostr(dt)));
    end;
    inc(sf);
    if isShowProgress then form_progress.progressbar_progress_download_bar.Position := sf;
    var jd: Currency := 100 * sf / BiggestThread;
    if isShowProgress then form_progress.label_progress_download_progress.Caption := GetLanguageText('label_progress_download_progress.caption').Replace('${download_progress}', floattostr(SimpleRoundTo(jd))).Replace('${download_current_count}', inttostr(sf)).Replace('${download_all_count}', inttostr(BiggestThread));
  end;
  var downp: TProc := procedure
  begin
    inc(sc);
    var tstart := fileavg * (sc - 1);
    var tend := fileavg * sc - 1;
    if sc = BiggestThread then tend := filesize;
    DownloadProc(sc, tstart, tend);
  end;
  for var I := 0 to BiggestThread - 1 do begin //循环生成【最大线程数量】个任务
    DownloadTask[I] := TTask.Run(downp);
  end;
  TTask.WaitForAll(DownloadTask);
  var mStream1 := TMemoryStream.Create;
  var mStream2 := TMemoryStream.Create;
  try
    for var I := 1 to BiggestThread do begin
      var tmpfile := Concat(TempPath, 'LLLauncher\downloadtmp', ChangeFileExt(ExtractFileName(savepath), ''), '-', inttostr(i), '.tmp');
      if not FileExists(tmpfile) then begin
        form_progress.listbox_progress_download_list.ItemIndex := form_progress.listbox_progress_download_list.Items.Add('已检测出文件下载并不完整，下载失败！');
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
end;
//下载Minecraft
procedure DownloadMinecraft;
begin
  var time := GetTickCount;
  var SourceJSON := TJSONObject.ParseJSONValue(url) as TJsonObject;

end;
//下载Java
procedure DownloadJava;
begin
  // TODO
end;
//下载Forge
procedure DownloadForge;
begin
  // TODO
end;
//调用函数
//第一个url是下载链接，如果LoadSource是1、2、3的话，则需要为对应的json。
//第二个SavePath是保存路径。
//第三个RootPath是根路径，只有LoadSource为1、3的时候，则需要指定对应的.minecraft文件夹，savepath为versions文件夹。
//第四个BiggestThread是最大线程。
//第五个SelectMode是下载源，只有1、2、3，如果为1，则是官方下载源，2为bmclapi，3为MCBBS。如果是国外则默认全部都是1，无法使用2、3
//第六个LoadSource是加载顺序，1为下载自定义文件，2为下载Minecraft，3为下载Java，4为下载Forge。
//第七个isShowList为是否展示下载列表框
//第八个isShowProgress为是否展示下载进度框
procedure DownloadStart(url, SavePath, RootPath: String; BiggestThread, SelectMode, LoadSource: Integer; isShowList: Boolean = true; isShowProgress: Boolean = true);
var
  TempTemp: array [0..255] of char;
begin
  form_progress.button_progress_clean_download_list.Enabled := false;
  DownloadMethod.url := url;
  DownloadMethod.SavePath := SavePath;
  DownloadMethod.BiggestThread := BiggestThread;
  DownloadMethod.SelectMode := SelectMode;
  DownloadMethod.isShowList := isShowList;
  DownloadMethod.isShowProgress := isShowProgress;
  DownloadMethod.RootPath := RootPath;
  case LoadSource of
    0: DownloadCustomFile;
    1: DownloadMinecraft;
    2: DownloadJava;
    3: DownloadForge;
  end;
  form_progress.button_progress_clean_download_list.Enabled := true;
  GetTempPath(255, @TempTemp);
  TempPath := strpas(TempTemp);
end;

end.
