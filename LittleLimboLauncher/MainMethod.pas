unit MainMethod;

interface         

uses
  SysUtils, Classes, Windows, IOUtils, StrUtils, JSON, Forms, JPEG, PngImage, GIFImg;

function TrimStrM(str: String): String;  
function GetFile(path: String): String;
procedure SetFile(path, content: String);     
function isX64: Boolean;                           
function GetDirectoryFileCount(Dir: String; suffix: String): TStringList;
function IsVersionError(path: String): Boolean;
procedure ResetBackImage(resume: Boolean);
procedure ResetBackMusic(resume: Boolean);

implementation

uses
  MainForm, Log4Delphi;

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
      messagebox(form_mainform.Handle, '背景图片刷新失败，暂未放入文件。', '刷新失败', MB_ICONERROR);
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
    messagebox(form_mainform.Handle, pchar(Concat('背景图片刷新成功！', #13#10, '名称：', ExtractFileName(imgpth))), '刷新成功', MB_ICONINFORMATION);
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
      messagebox(form_mainform.Handle, '背景音乐刷新失败，暂未放入文件。', '刷新失败', MB_ICONERROR);
    exit;
  end;
  v.FileName := mic;
  Log.Write('背景音乐已被随机加载。', LOG_INFO);
  if resume then begin
    messagebox(form_mainform.Handle, pchar(Concat('背景音乐刷新成功！', #13#10, '名称：', ExtractFileName(mic))), '刷新成功', MB_ICONINFORMATION);
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
