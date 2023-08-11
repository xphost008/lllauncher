unit MainMethod;

interface         

uses
  SysUtils, Classes, Windows, IOUtils, StrUtils, JSON, Forms, JPEG, PngImage, GIFImg, Dialogs, RegularExpressions, Math,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent, NetEncoding;

function GetWebStream(url: String): TStringStream;
function GetWebText(url: String): String;
function TrimStrM(str: String): String;  
function GetFile(path: String): String;
procedure SetFile(path, content: String);     
function isX64: Boolean;                           
function GetDirectoryFileCount(Dir: String; suffix: String): TStringList;
function IsVersionError(path: String): Boolean;
procedure ResetBackImage(resume: Boolean);
procedure ResetBackMusic(resume: Boolean);
procedure PlayMusic;
function UUIDToHashCode(UUID: String): Int64;
procedure JudgeJSONSkin;

implementation

uses
  MainForm, Log4Delphi, LanguageMethod, MyCustomWindow, AccountMethod;

//更换皮肤
procedure JudgeJSONSkin;
begin
  var pla := ((AccountJson.Values['account'] as TJsonArray)[form_mainform.combobox_all_account.ItemIndex] as TJsonObject);
  var pls := pla.GetValue('head_skin').Value;
  var base := TNetEncoding.Base64.DecodeStringToBytes(pls);
  var png := TPngImage.Create;
  try
    png.LoadFromStream(TBytesStream.Create(base));
    form_mainform.image_login_avatar.Picture.Assign(png);
  finally
    png.Free;
  end;
end;
//用UUID强转成HashCode。
function UUIDToHashCode(UUID: String): Int64;
begin
  result := -1;
  if TRegex.IsMatch(UUID, '^[a-f0-9]{32}') then begin
    var most := UUID.Substring(0, 16);
    var least := UUID.Substring(16, 16);
    var mostbin := '';
    var leastbin := '';
    for var I in most do begin
      if I = '0' then mostbin := mostbin + '0000'
      else if I = '1' then mostbin := mostbin + '0001'
      else if I = '2' then mostbin := mostbin + '0010'
      else if I = '3' then mostbin := mostbin + '0011'
      else if I = '4' then mostbin := mostbin + '0100'
      else if I = '5' then mostbin := mostbin + '0101'
      else if I = '6' then mostbin := mostbin + '0110'
      else if I = '7' then mostbin := mostbin + '0111'
      else if I = '8' then mostbin := mostbin + '1000'
      else if I = '9' then mostbin := mostbin + '1001'
      else if I = 'a' then mostbin := mostbin + '1010'
      else if I = 'b' then mostbin := mostbin + '1011'
      else if I = 'c' then mostbin := mostbin + '1100'
      else if I = 'd' then mostbin := mostbin + '1101'
      else if I = 'e' then mostbin := mostbin + '1110'
      else if I = 'f' then mostbin := mostbin + '1111'
    end;
    for var I in least do begin
      if I = '0' then leastbin := leastbin + '0000'
      else if I = '1' then leastbin := leastbin + '0001'
      else if I = '2' then leastbin := leastbin + '0010'
      else if I = '3' then leastbin := leastbin + '0011'
      else if I = '4' then leastbin := leastbin + '0100'
      else if I = '5' then leastbin := leastbin + '0101'
      else if I = '6' then leastbin := leastbin + '0110'
      else if I = '7' then leastbin := leastbin + '0111'
      else if I = '8' then leastbin := leastbin + '1000'
      else if I = '9' then leastbin := leastbin + '1001'
      else if I = 'a' then leastbin := leastbin + '1010'
      else if I = 'b' then leastbin := leastbin + '1011'
      else if I = 'c' then leastbin := leastbin + '1100'
      else if I = 'd' then leastbin := leastbin + '1101'
      else if I = 'e' then leastbin := leastbin + '1110'
      else if I = 'f' then leastbin := leastbin + '1111'
    end;
    var xor1 := '';
    for var I := 1 to mostbin.Length do begin
      if mostbin[I] = leastbin[I] then begin
        xor1 := xor1 + '0';
      end else begin
        xor1 := xor1 + '1';
      end;
    end;
    var mostx := xor1.Substring(0, 32);
    var leastx := xor1.Substring(32, 32);
    var xor2 := '';
    for var I := 1 to mostx.Length do begin
      if mostx[I] = leastx[I] then begin
        xor2 := xor2 + '0';
      end else begin
        xor2 := xor2 + '1';
      end;
    end;
    var ten: Int64 := 0;
    for var I := 1 to xor2.Length do begin
      if xor2[I] = '1' then begin
        ten := ten + Trunc(IntPower(2, xor2.Length - I));
      end;
    end;
    result := ten;
  end;
end;
function GetWebStream(url: String): TStringStream;
begin
  var http := TNetHttpClient.Create(nil); //给初始变量赋值
  var strt := TStringStream.Create('', TEncoding.UTF8, False);
  result := nil;
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
    end;
    try
      var h := http.Get(url, strt);  //获取网络文本
      result := strt; //给最后变量赋值为网络文本的变量，返回
      if h.StatusCode = 404 then result := nil;
    except  //如果无法获取，则抛出报错
    end;
  finally
    http.Free; //释放资源
  end;
end;
//获取网络文件
function GetWebText(url: String): String;
begin
  var http := TNetHTTPClient.Create(nil); //给初始变量赋值
  var strt := TStringStream.Create('', TEncoding.UTF8, False);
  result := '';
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
    end;
    try
      var h := http.Get(url, strt);  //获取网络文本
      result := strt.DataString; //给最后变量赋值为网络文本的变量，返回
      if h.StatusCode = 404 then result := '';
    except  //如果无法获取，则抛出报错
    end;
  finally
    http.Free; //释放资源
    strt.Free;
  end;
end;
//播放音乐
procedure PlayMusic;
begin
  if v.FileName <> '' then
  begin
    v.Open;
    v.Play;
  end;
end;
//重置背景图片的方法。
procedure ResetBackImage(resume: Boolean);
var
  Files: TArray<String>;
begin
  randomize;
  var jrr := 0;
  var MList := TStringList.Create;  //遍历文件夹下的BackGround文件夹。
  var path := Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\BackGroundImage');
  if SysUtils.DirectoryExists(path) then begin //如果文件存在，则执行
    Files := TDirectory.GetFiles(path);
    for var I in Files do begin  //添加部分后缀的文件
      var J := ExtractFileExt(I);
      if (J = '.jpg') or (J = '.png') or (J = '.gif') or (J = '.bmp') or (J = '.jpeg') then begin
        MList.Add(I); //给列表添加。
        inc(jrr);
      end;
    end;
  end;
  var imgpth: String; //给列表路径附上空值
  if jrr <> 0 then begin
    imgpth := MList[random(jrr)]; //如果里面有元素，则执行。
    Log.Write('背景图片已被随机加载。', LOG_INFO);
  end else begin
    if resume then
      MyMessageBox(GetLanguageText('messagebox_background_reset_image.not_found.caption'), GetLanguageText('messagebox_background_reset_image.not_found.text'), MY_ERROR, [mybutton.myYes]);
    exit;  //没有元素，则跳出。
  end;
  var suffix := ExtractFileExt(imgpth);
  if (suffix = '.jpg') or (suffix = '.jpeg') then begin
    var jpg := TJpegImage.Create;
    jpg.LoadFromFile(imgpth);
    form_mainform.image_mainpage_background_image.Picture.Assign(jpg);
    jpg.Free;
  end else if suffix = '.bmp' then
    form_mainform.image_mainpage_background_image.Picture.Bitmap.LoadFromFile(imgpth)
  else if suffix = '.png' then begin
    var png := TPngImage.Create;
    png.LoadFromFile(imgpth);
    form_mainform.image_mainpage_background_image.Picture.Assign(png);
    png.Free;
  end else if suffix = '.gif' then begin
    var gif := TGifImage.Create;
    gif.LoadFromFile(imgpth);
//    gif.Animate := true;
//    gif.Transparent := true;
    form_mainform.image_mainpage_background_image.Picture.Assign(gif);
    gif.Free;
  end;
  if resume then
    MyMessageBox(GetLanguageText('messagebox_background_reset_image.success.caption'), GetLanguageText('messagebox_background_reset_image.success.text').Replace('${background_image_filename}', ExtractFileName(imgpth)), MY_INFORMATION, [mybutton.myYes]);
end;
//重置背景音乐的方法。
procedure ResetBackMusic(resume: Boolean);
var
  Files: TArray<String>;
begin
  randomize;
  var jrr := 0;
  var MList := TStringList.Create;
  var path := Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\BackGroundMusic');
  if SysUtils.DirectoryExists(path) then begin
    Files := TDirectory.GetFiles(path);
    for var I in Files do begin //遍历
      var J := I.Substring(I.LastIndexOf('.'), I.Length - I.LastIndexOf('.'));
      if (J = '.mp3') or (J = '.wav') or (J = 'm4a') then begin
        MList.Add(I);
        inc(jrr);
      end;
    end;
  end;
  var mic: String;
  if jrr <> 0 then begin
    mic := MList[random(jrr)];
  end else begin
    if resume then
      MyMessageBox(GetLanguageText('messagebox_background_reset_music.not_found.caption'), GetLanguageText('messagebox_background_reset_music.not_found.text'), MY_ERROR, [mybutton.myYes]);
    exit;
  end;
  v.FileName := mic;
  Log.Write('背景音乐已被随机加载。', LOG_INFO);
  if resume then begin
    MyMessageBox(GetLanguageText('messagebox_background_reset_music.success.caption'), GetLanguageText('messagebox_background_reset_music.success.text').Replace('${background_music_filename}', ExtractFileName(mic)), MY_INFORMATION, [mybutton.myYes]);
    PlayMusic;
  end;
end;
//判断版本是否有误
function IsVersionError(path: String): Boolean;
var
  Files: TArray<String>;
begin
  result := true;
  if DirectoryExists(path) then // 判断文件夹是否存在
  begin
    Files := TDirectory.GetFiles(path); // 找到所有文件
    for var I in Files do begin // 遍历文件
      if I.IndexOf('.json') <> -1 then begin
        var god := GetFile(I);
        try
          var Root := TJsonObject.ParseJSONValue(god) as TJsonObject;
          Root.GetValue('id');
          Root.GetValue('libraries');
          result := false;
          exit;
        except
          continue;
        end;
      end;
    end;
  end;
end;
//去除字符串空格
function TrimStrM(str: String): String;
var
  i: Integer;
begin
  repeat  //使用循环遍历字符串
    i := pos(' ', str); //获取空格字符在字符串的位置。
    var j := length(str); //获取字符串的长度
    if i > 0 then  //如果字符串内有空格
      str := copy(str, 1, i - 1) + copy(str, i + 1, j - i); //前面为复制字符串前面的字符，
  until i = 0;
  str := str.Replace(#13, '').Replace(#10, '');
  Result := str;
end; 
//获取文件    
function GetFile(path: String): String;
begin
  result := '';
  if not FileExists(path) then exit;
  var ss := TStringStream.Create('', TEncoding.UTF8, False);
  try
    ss.LoadFromFile(path); //直接读取
    result := ss.DataString;
  finally
    ss.Free;
  end;
end;
//保存文件
procedure SetFile(path, content: String);
begin
  if not SysUtils.DirectoryExists(ExtractFilePath(path)) then
    SysUtils.ForceDirectories(ExtractFilePath(path));
  var ss := TStringStream.Create('', TEncoding.UTF8, False);
  try
    ss.WriteString(content);
    ss.SaveToFile(path);
  finally
    ss.Free;
  end;
end;        
//获取电脑系统是否为64位。   
function isX64: Boolean;
var
  si: SYSTEM_INFO;
begin
  GetNativeSystemInfo(&si); // = 9 表示的是 AMD64
  if(si.wProcessorArchitecture = PROCESSOR_ARCHITECTURE_AMD64 {9}) or
    (si.wProcessorArchitecture = PROCESSOR_ARCHITECTURE_IA64) then
    Result := True
  else
    Result := False;
end;          
//获取文件内总数量【第一个参数为文件夹，第二个参数为该文件的特征，返回值是该文件的文件列表。】。
function GetDirectoryFileCount(Dir: String; suffix: String): TStringList;
var
  d: TArray<String>;
begin
  result := TStringList.Create;
  if not DirectoryExists(Dir) then exit;
  d := TDirectory.GetFiles(dir);
  for var I in d do begin
    if RightStr(I, suffix.Length) = suffix then begin
      result.Add(I);
    end;
  end;
end;

end.
