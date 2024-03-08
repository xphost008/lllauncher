unit MainMethod;

interface         

uses
  Classes, Windows, IOUtils, StrUtils, JSON, Forms, JPEG, PngImage, GIFImg, RegularExpressions, Math, Hash, ShellAPI, Dialogs,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent, SysUtils, NetEncoding, Generics.Collections,
  Tlhelp32;

function GetWebStream(url: String): TStringStream;
function GetWebText(url: String): String;
function TrimStrM(str: String): String;  
function GetFile(path: String): String;
procedure SetFile(path, content: String);
function GetDirectoryFileCount(Dir: String; suffix: String): TStringList;
function IsVersionError(path: String): Boolean;
procedure ResetBackImage(resume: Boolean);
procedure ResetBackMusic(resume: Boolean);
procedure PlayMusic;
function UUIDToHashCode(UUID: String): Int64;
function DeleteDirectory(N: String): Boolean;
function GetFileHash(filename: String): String;
procedure RunDOSOnlyWait(CommandLine: string; second: Integer = Integer.MaxValue);
procedure Isafdian(IsStart: Boolean; awa: Integer);
function RenDirectory(const OldName, NewName: string): boolean;
function GetFileBits(FileName: String): String;
function GetFileVersion(AFileName: string): string;
function GetVanillaVersion(json: String): String;
function RunDOSBack1(CommandLine: string): string;
function JudgeCountry: Boolean;
function ProcessExists(PID: DWORD): Boolean;
function RunDOSAndGetPID(FileName, Parameters: string; dir: string = ''): Integer;
function IPv4ToInt(ipv4: String): UInt;
function getMCRealDir(path, suffix: String): String;
function DeleteRetain(N, suffix: String): Boolean;
function Base64ToStream(base64: String): TStringStream;
function StreamToBase64(pStream: TStringStream): String;
function NameToDefaultUUID(text: String): String;
function ConvertHexToColor(color: String): Integer;
procedure SearchDirProc(path: String; isReadDir: Boolean; isOnly: Boolean; proc: TProc<String>);

var
  MCRootJSON: TJSONObject;
//获取国家代码
function GetUserDefaultGeoName(geoName: LPWSTR; geoNameCount: Integer): Integer; stdcall; external 'kernel32.dll';

implementation

uses
  MainForm, Log4Delphi, LanguageMethod, MyCustomWindow, AccountMethod;
//搜索文件夹函数。
//1. 文件夹路径
//2. 要搜索的后缀
//3. 是否为遍历文件夹
//4. 是否只遍历外层
//5. 执行函数【内含有一个参数，参数为搜索出的文件路径。】
procedure SearchDirProc(path: String; isReadDir: Boolean; isOnly: Boolean; proc: TProc<String>);
var
  F: TSearchRec;
begin
  if path = '' then exit;
  if path.IndexOf('\') = -1 then exit;
  if FindFirst(Concat(path, '\*.*'), faAnyFile, F) = 0 then begin //查找文件并赋值
    try
      repeat  //此处调用了API函数。
        var S: String := F.Name;
        if (F.Attr and faDirectory) > 0 then //查找是否为文件夹，如果是则执行
        begin
          if isReadDir then begin
            if (S <> '.') and (S <> '..') then begin
              proc(Concat(path, '\', S));
              if isOnly then continue;
              SearchDirProc(Concat(path, '\', S), isOnly, isReadDir, proc);
            end;
          end else begin
            if isOnly then continue;
            if (S <> '.') and (S <> '..') then
              SearchDirProc(Concat(path, '\', S), isOnly, isReadDir, proc);
          end;
        end
        else begin
          if isReadDir then continue;
          proc(Concat(path, '\', S)); //直接执行。
        end;
      until SysUtils.FindNext(F) <> 0; //查询下一个。
    finally
      FindClose(F); //关闭文件查询。
    end;
  end;
end;
//颜色RGB转换为Color数字
function ConvertHexToColor(color: String): Integer;
begin
  color := color.Substring(1);
  if (color.Length <> 6) or (not TRegex.IsMatch(color, '^[a-fA-F0-9]{6}')) then
    raise Exception.Create('invalid Color value');
  result := rgb(
    strtoint(Concat('$', color.Substring(4, 2))),
    strtoint(Concat('$', color.Substring(2, 2))),
    strtoint(Concat('$', color.Substring(0, 2))));
end;
//该方法用于生成离线模式UUID，但是按照Bukkit方式生成。
//参考网址：https://github.com/PrismarineJS/node-minecraft-protocol/blob/21240f8ab2fd41c76f50b64e3b3a945f50b25b5e/src/datatypes/uuid.js#L14
function NameToDefaultUUID(text: String): String;
begin
  if text.IsEmpty then result := '';
  var byt := THashMD5.GetHashBytes(Concat('OfflinePlayer:', text));
  byt[6] := (byt[6] and $0f) or $30;
  byt[8] := (byt[8] and $3f) or $80;
  var res := '';
  for var I in byt do begin
    res := Concat(res, inttohex(I));
  end;
  result := res.ToLower;
end;
//获取MC真实的文件夹路径
function getMCRealDir(path, suffix: String): String;
var
  Dirs: TArray<String>;
begin
  result := '';
  if DirectoryExists(path) then
  begin
    Dirs := TDirectory.GetDirectories(path);
    for var I in Dirs do begin
      if (I.IndexOf(suffix) <> -1) then begin
        result := I;
        exit;
      end;
    end;
  end;
end;
//删除文件但是保留后缀
function DeleteRetain(N, suffix: String): Boolean;
var
  F: TSearchRec;
begin
  result := false;
  if N = '' then exit;
  if (suffix = '') or (suffix = '.') then exit;
  if N.IndexOf('\') = -1 then exit;
  if FindFirst(Concat(N, '\*.*'), faAnyFile, F) = 0 then begin //查找文件并赋值
    try
      repeat  //此处调用了API函数。
        var S: String := F.Name;
        if (F.Attr and faDirectory) > 0 then //查找是否为文件夹，如果是则执行
        begin
          if (S <> '.') and (S <> '..') then //删除首次寻找文件时出现的【.】和【..】字符。
            DeleteRetain(Concat(N, '\', S), suffix) //重复调用本函数，并且加上文件名。
        end
        else
          if S.Substring(S.LastIndexOf('.', S.Length)) <> suffix then SysUtils.DeleteFile(N + '\' + F.Name); //如果没发现后缀为suffix的话，则执行。
      until SysUtils.FindNext(F) <> 0; //查询下一个。
    finally
      FindClose(F); //关闭文件查询。
    end;
    RemoveDir(N);
    result := true;
  end;
end;
//运行DOS，但显示回显，回显不超过183行可等待。
//已应用于IPv6联机模块，用于显示ipconfig。
function RunDOSBack1(CommandLine: string): string;
var
  HRead, HWrite: THandle;
  StartInfo: TStartupInfo;
  ProceInfo: TProcessInformation;
  b: Boolean;
  sa: TSecurityAttributes;
  inS: THandleStream;
  sRet: TStrings;
begin
  Result := '';
  UniqueString(CommandLine);
  FillChar(sa, sizeof(sa), 0);
  //设置允许继承，否则在NT和2000下无法取得输出结果
  with sa do begin
    nLength := sizeof(sa);
    bInheritHandle := True;
    lpSecurityDescriptor := nil;
  end;
  b := CreatePipe(HRead, HWrite, @sa, 0); //此处建立一个管道。目标是TSecurityAttributes的引用、读入和写出。
  if not b then
    raise Exception.Create(SysErrorMessage(GetLastError));
  FillChar(StartInfo, SizeOf(StartInfo), 0);
  with StartInfo do begin
    cb := SizeOf(StartInfo);  //为Start信息建立初值。
    wShowWindow := SW_HIDE;
    //使用指定的句柄作为标准输入输出的文件句柄,使用指定的显示方式
    dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
    hStdError := HWrite;
    hStdInput := GetStdHandle(STD_INPUT_HANDLE); //HRead;
    hStdOutput := HWrite;
  end;
  b := CreateProcess(
    nil, //lpApplicationName: PChar  //建立进程进行回显。
    PChar(CommandLine), //lpCommandLine: PChar
    nil, //lpProcessAttributes: PSecurityAttributes
    nil, //lpThreadAttributes: PSecurityAttributes
    True, //bInheritHandles: BOOL
    CREATE_NEW_CONSOLE,
    nil,
    nil,
    StartInfo,
    ProceInfo);
  if not b then
    raise Exception.Create(SysErrorMessage(GetLastError));
  WaitForSingleObject(ProceInfo.hProcess, Integer.MaxValue); //这里并不会使用等待命令行执行完毕，直接使用参数等待。
  inS := THandleStream.Create(HRead); //将读出值设置到句柄流里面。
  if inS.Size > 0 then begin
    sRet := TStringList.Create;
    sRet.LoadFromStream(inS);
    Result := sRet.Text;   //将流中的内容读入返回值并返回。
    sRet.Free;
  end else result := '';
  inS.Free;
  CloseHandle(HRead);
  CloseHandle(HWrite);
end;
//将流转成Base64返回
function StreamToBase64(pStream: TStringStream): String;
begin
  if pStream = nil then exit;
  var res := TStringStream.Create('', TEncoding.UTF8, False);
  TNetEncoding.Base64.Encode(pStream, res);
  result := res.DataString;
end;
//将Base64转成流返回
function Base64ToStream(base64: String): TStringStream;
begin
  if base64 = '' then begin result := nil; exit; end;
  result := TStringStream.Create('', TEncoding.UTF8, False);
  var source := TStringStream.Create(base64);
  TNetEncoding.Base64.Decode(source, result);
  result.Position := 0;
end;
//将IPv4地址转成Integer数字
function IPv4ToInt(ipv4: String): UInt; deprecated;
begin
  var spl := SplitString(ipv4, '.');
  result := 0;
  result := result + UInt(strtoint(spl[0])) * UInt($ff) * UInt($ff) * UInt($ff);
  result := result + UInt(strtoint(spl[1])) * UInt($ff) * UInt($ff);
  result := result + UInt(strtoint(spl[2])) * UInt($ff);
  result := result + UInt(strtoint(spl[3]));
end;
//获取根据json原版键值
function GetVanillaVersion(json: String): String;
begin
  var jsonRoot := TJSONObject.ParseJSONValue(json.ToLower) as TJSONObject;
  var mcid := '';
  try
    mcid := jsonRoot.GetValue('inheritsFrom').Value;
    if mcid = '' then raise Exception.Create('Not Support!');
  except
    try
      mcid := jsonRoot.GetValue('clientversion').Value;
      if mcid = '' then raise Exception.Create('Not Support!');
    except
      try
        var patch := jsonRoot.GetValue('patches') as TJsonArray;
        for var I in patch do begin
          var id := I.GetValue<String>('id').ToLower;
          if id = 'game' then begin
            mcid := I.GetValue<String>('version');
          end;
        end;
      except
        try
          var game := (jsonRoot.GetValue('arguments') as TJsonObject).GetValue('game') as TJsonArray;
          for var I := 0 to game.Count - 1 do begin
            if game[I].Value.ToLower = '--fml.mcversion'.ToLower then begin
              mcid := game[I + 1].Value;
            end;
          end;
        except
          try
            var releaseTime := jsonRoot.GetValue('releaseTime').Value;
            var Vv := '';
            case mdownload_source of
              1: Vv := 'https://piston-meta.mojang.com/mc/game/version_manifest.json';
              2: Vv := 'https://bmclapi2.bangbang93.com/mc/game/version_manifest.json';
              else exit;
            end;
            if MCRootJSON = nil then begin
              MCRootJSON := TJsonObject.ParseJSONValue(GetWebText(Vv)) as TJSONObject;
            end;
            for var I in MCRootJSON.GetValue('versions') as TJSONArray do begin
              var J := I as TJsonObject;
              var release := J.GetValue('releaseTime').Value;
              if release = releaseTime then begin
                mcid := J.GetValue('id').Value;
              end;
            end;
          except
            try
              mcid := jsonRoot.GetValue('id').Value;
            except
              MyMessagebox(GetLanguage('messagebox_export.cannot_find_vanilla_key.caption'), GetLanguage('messagebox_export.cannot_find_vanilla_key.text'), MY_ERROR, [mybutton.myOK]);
              exit;
            end;
          end;
        end;
      end;
    end;
  end;
  result := mcid;
end;
//此处可以用获取exe的版本信息。
function GetFileVersion(AFileName: string): string;
var
  n, Len: DWORD;
  Buf : PChar;
  Value: Pointer;
  szName: array [0..255] of Char;
  Transstring: string;
begin
  Len := GetFileVersionInfoSize(PChar(AFileName), n);
  if Len > 0 then begin
    Buf := AllocMem(Len);
    if GetFileVersionInfo(Pchar(AFileName), n, Len, Buf) then begin
      Value := nil;
      VerQueryValue(Buf, '\VarFileInfo\Translation', Value, Len);
      if Value <> nil then
        Transstring := IntToHex(MakeLong(HiWord(LongInt(Value^)),
          LoWord(LongInt(Value^))), 8);
      StrPCopy(szName, '\stringFileInfo\' + Transstring + '\FileVersion');
      if VerQueryValue(Buf, szName, Value, Len) then
        Result := StrPas(Pchar(Value));
    end;
    FreeMem(Buf, n);
  end;
end;
//此处用于判断exe的位数，是32位还是64位程序。
function GetFileBits(FileName: String): String;
var
  b: Byte;
  res: String;
begin
  res := '';
  result := '';
  if not FileExists(FileName) then Exit;
  with TMemoryStream.Create do begin
    LoadFromFile(FileName);
    Position := 0;
    while Position < Size do
    begin
      ReadBuffer(b, 1);
      res := res + Format('%0.2x ', [b]);
      if Position = 800 then break;
    end;
    Free;
  end;
  if res.ToLower.IndexOf('50 45 00 00 4c') <> -1 then Result := '32' else if res.IndexOf('50 45 00 00 64 86') <> -1 then Result := '64' else Result := '';
end;
//重命名任一文件夹的方法
function RenDirectory(const OldName, NewName: string): boolean;
var
  fo: TSHFILEOPSTRUCT;
begin  //简单的从网络上照抄得到的重命名文件夹代码
  FillChar(fo, SizeOf(fo), 0);
  with fo do
  begin
    Wnd := 0;
    wFunc := FO_RENAME;
    pFrom := PChar(OldName + #0);
    pTo := pchar(NewName + #0);
    fFlags := FOF_ALLOWUNDO;
  end;
  Result := (SHFileOperation(fo) = 0);
end;
//获取是否捐款
procedure Isafdian(IsStart: Boolean; awa: Integer);
begin
  {$IFDEF DEBUG}
    exit;
  {$ENDIF}
  //if LauncherVersion.IndexOf('snapshot') <> -1 then exit; //判断并且是否赞助？此只在正式版才有用。
  var say := '';
  var lg := '';
  if IsStart then begin
    Log.Write(Concat('已经被你启动了', inttostr(awa), '次了，为什么不赞助？'), LOG_START, LOG_QUESTION);
    say := GetLanguage('messagebox_mainform.launch_afdian.text').Replace('${launch_number}', inttostr(awa));
  end else begin
    Log.Write(Concat('已经为你打开了', inttostr(awa), '次了，为什么不赞助？'), LOG_START, LOG_QUESTION);
    say := GetLanguage('messagebox_mainform.open_afdian.text').Replace('${open_number}', inttostr(awa));
  end;
  if MyMessagebox(GetLanguage('messagebox_mainform.afdian.caption'), say, MY_INFORMATION, [mybutton.myNo, mybutton.myYes]) = 2 then ShellExecute(Application.Handle, nil, 'https://afdian.net/@Rechalow', nil, nil, SW_SHOWNORMAL);
end;
//根据进程PID判断进程是否存在，如果无法获取则返回false，获取成功则返回true。
function ProcessExists(PID: DWORD): Boolean;
var
  SnapshotHandle: THandle;
  ProcessEntry32: TProcessEntry32;
begin
  Result := False;
  SnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if SnapshotHandle = INVALID_HANDLE_VALUE then
    Exit;
  ProcessEntry32.dwSize := SizeOf(TProcessEntry32);
  if Process32First(SnapshotHandle, ProcessEntry32) then
  begin
    repeat
      if ProcessEntry32.th32ProcessID = PID then
      begin
        Result := True;
        Break;
      end;
    until not Process32Next(SnapshotHandle, ProcessEntry32);
  end;
  CloseHandle(SnapshotHandle);
end;
//运行DOS命令，仅等待。
//应用于插件执行、启动前执行命令、Forge安装Processors（实验性）。
//参数1：命令行。参数2：等待时间【以毫秒做单位。】
procedure RunDOSOnlyWait(CommandLine: string; second: Integer = Integer.MaxValue);
var
  HRead, HWrite: THandle;
  StartInfo: TStartupInfo;
  ProceInfo: TProcessInformation;
  b: Boolean;
  sa: TSecurityAttributes;
begin
  UniqueString(CommandLine);
  FillChar(sa, sizeof(sa), 0);
  //设置允许继承，否则在NT和2000下无法取得输出结果
  with sa do begin
    nLength := sizeof(sa);
    bInheritHandle := True;
    lpSecurityDescriptor := nil;
  end;
  b := CreatePipe(HRead, HWrite, @sa, 0); //此处建立一个管道。目标是TSecurityAttributes的引用、读入和写出。
  if not b then
    raise Exception.Create(SysErrorMessage(GetLastError));
  FillChar(StartInfo, SizeOf(StartInfo), 0);
  with StartInfo do begin
    cb := SizeOf(StartInfo);  //为Start信息建立初值。
    wShowWindow := SW_HIDE;
    //使用指定的句柄作为标准输入输出的文件句柄,使用指定的显示方式
    dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
    hStdError := HWrite;
    hStdInput := GetStdHandle(STD_INPUT_HANDLE); //HRead;
//    hStdOutput := HWrite;
  end;
  b := CreateProcess(
    nil, //lpApplicationName: PChar  //建立进程
    PChar(CommandLine), //lpCommandLine: PChar
    nil, //lpProcessAttributes: PSecurityAttributes
    nil, //lpThreadAttributes: PSecurityAttributes
    True, //bInheritHandles: BOOL
    CREATE_NEW_CONSOLE,
    nil,
    nil,
    StartInfo,
    ProceInfo);
  if not b then
    raise Exception.Create(SysErrorMessage(GetLastError));
  WaitForSingleObject(ProceInfo.hProcess, second); //这里并不会使用等待命令行执行完毕，直接使用参数等待。
  CloseHandle(HWrite);
end;
//运行进程，但是可以得到进程的PID。
function RunDOSAndGetPID(FileName, Parameters: string; dir: string = ''): Integer;
var
  StartupInfo:TStartupInfo;
  ProcessInfo:TProcessInformation;
begin
  if dir.IsEmpty then
    dir := Concat(ExtractFileDir(Application.ExeName));
  FillChar(ProcessInfo, sizeof(ProcessInfo), 0);
  FillChar(StartupInfo, Sizeof(StartupInfo), 0);
  StartupInfo.cb := Sizeof(TStartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := SW_SHOW;
  if CreateProcess(pchar(filename), pchar(Parameters), nil, nil, False, NORMAL_PRIORITY_CLASS,
    nil, pchar(dir), StartupInfo, ProcessInfo) then
    result := ProcessInfo.dwProcessId //这里就是创建进程的PID值
  else result := -1;
end;
//获取文件hash值
function GetFileHash(filename: String): String;
begin
  if not FileExists(filename) then begin
    result := '';
    exit;
  end;
  var pStream := TFileStream.Create(filename, fmOpenRead or fmShareDenyWrite);
  var ss := THashSha1.GetHashString(pStream);
  result := ss.ToLower;
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
//获取网络流
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
//删除任一文件夹的方法，请慎用！
function DeleteDirectory(N: String): Boolean;
var
  F: TSearchRec;
begin
  result := false;
  if (N = '') then exit;
  if N.IndexOf('\') = -1 then N := Concat(N, ':\:\:');
  if not DirectoryExists(N) then begin
    result := true;
    exit;
  end;
  if FindFirst(Concat(N, '\*.*'), faAnyFile, F) = 0 then begin  //查找文件并赋值
    try
      repeat  //此处调用了API函数。
        if (F.Attr and faDirectory) > 0 then begin//查找是否为文件，如果是则执行
          if (F.Name <> '.') and (F.Name <> '..') then //删除首次寻找文件时出现的【.】和【..】字符。
            DeleteDirectory(Concat(N, '\', F.Name)) //重复调用本函数，并且加上文件名。
        end else begin
          DeleteFile(Concat(N, '\', F.Name)); //如果发现了文件，则立刻删除
        end;
      until FindNext(F) <> 0; //查询下一个。
    finally
      FindClose(F); //关闭文件查询。
    end;
    RemoveDir(N); //最终删除总文件夹。
    result := true;
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
    Log.Write('背景图片已被随机加载。', LOG_INFO, LOG_LOAD);
  end else begin
    if resume then
      MyMessageBox(GetLanguage('messagebox_background_reset_image.not_found.caption'), GetLanguage('messagebox_background_reset_image.not_found.text'), MY_ERROR, [mybutton.myYes]);
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
    gif.Animate := true;
    gif.Transparent := true;
    form_mainform.image_mainpage_background_image.Picture.Assign(gif);
    gif.Free;
  end;
  if resume then
    MyMessageBox(GetLanguage('messagebox_background_reset_image.success.caption'), GetLanguage('messagebox_background_reset_image.success.text').Replace('${background_image_filename}', ExtractFileName(imgpth)), MY_INFORMATION, [mybutton.myYes]);
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
      var J := I.Substring(I.LastIndexOf('.'));
      if (J = '.mp3') or (J = '.wav') or (J = '.m4a') then begin
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
      MyMessageBox(GetLanguage('messagebox_background_reset_music.not_found.caption'), GetLanguage('messagebox_background_reset_music.not_found.text'), MY_ERROR, [mybutton.myYes]);
    exit;
  end;
  v.FileName := mic;
  Log.Write('背景音乐已被随机加载。', LOG_INFO, LOG_LOAD);
  if resume then begin
    MyMessageBox(GetLanguage('messagebox_background_reset_music.success.caption'), GetLanguage('messagebox_background_reset_music.success.text').Replace('${background_music_filename}', ExtractFileName(mic)), MY_INFORMATION, [mybutton.myYes]);
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
//判断中文
function JudgeChinese(text: String): Boolean;
begin
  result := false;
  for var I in text do begin
    if (Ord(I) > $4E00) and (Ord(I) < $9FA5) then begin
      result := true;
      break;
    end;
  end;
end;
//获取国家代码【废弃】
function GetCountryCode: String; deprecated;
begin
  result := '';
  var res := GetUserDefaultGeoName(nil, 0);
  if res > 0 then begin
    var gname: LPWSTR := StrAlloc(res);
    var res2 := GetUserDefaultGeoName(gname, res);
    if res2 > 0 then begin
      result := gname;
    end;
  end;
end;
//获取本局域网外网IP【废弃】
//通过http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest匹配。
function GetLocalIP: String; deprecated;
begin
  result := GetWebText('http://www.3322.org/dyndns/getip').Trim;
end;
//判断国家语言
function JudgeCountry: Boolean;
begin
  result := JudgeChinese(RunDOSBack1('systeminfo'));
end;

end.
