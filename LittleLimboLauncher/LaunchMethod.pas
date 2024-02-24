unit LaunchMethod;

interface

uses
  Vcl.Controls, JSON, Windows, Math, SysUtils, Forms, Classes, IOUtils, StrUtils, Registry,
  Dialogs, Generics.Collections;

var
  mwindow_width, mwindow_height: Integer;
  mmax_memory, mtotal_memory, mavail_memory: Integer;
  mjava_path, mcustom_info, mwindow_title: String;
  mpre_script, mafter_script, madd_jvm, madd_game: String;
  JavaJSON: TJSONObject;
  mcurrent_java: Integer;

procedure InitLaunch;
procedure SaveLaunch;
procedure FullScanJava();
procedure BasicScanJava();
procedure ManualImportJava();
procedure RemoveJava();
procedure DownloadJava(ver: String);

implementation

uses
  MainForm, MainMethod, LanguageMethod, MyCustomWindow, ProgressMethod;
//搜索Java
function SearchJava(path: String): Boolean;
var
  F: TSearchRec;
begin
  result := false;
  if (path = '') then exit;
  if FindFirst(Concat(path, '\*.*'), faAnyFile, F) = 0 then begin  //查找文件并赋值
    try
      repeat  //此处调用了API函数。
        if (F.Attr and faDirectory) > 0 then begin//查找是否为文件，如果是则执行
          if Concat(path, '\', F.Name).ToLower.Contains('recycle.bin') then continue;
          if Concat(path, '\', F.Name).ToLower.Contains('c:\windows') then continue;
          if (F.Name <> '.') and (F.Name <> '..') then //删除首次寻找文件时出现的【.】和【..】字符。
            SearchJava(Concat(path, '\', F.Name)) //重复调用本函数，并且加上文件名。
        end else begin
          if Concat(path, '\', F.Name).ToLower.Contains('recycle.bin') then continue;
          if F.Name = 'javaw.exe' then begin
            var pd := false;
            var fpth := Concat(path, '\', F.Name);
            for var I in JavaJson.GetValue('java') as TJsonArray do begin
              if fpth = I.Value then begin
                pd := true;
                break;
              end;
            end;
            if pd then continue;
            var bit := GetFileBits(fpth);
            if (bit = '32') or (bit.IsEmpty) then continue;
            var vers := GetFileVersion(fpth);
            if vers = '' then continue;
            form_mainform.combobox_launch_select_java_path.Items.Add(Concat('Java(', vers, ')(', bit, ')', fpth));
            (JavaJson.GetValue('java') as TJsonArray).Add(fpth);
          end;
        end;
      until FindNext(F) <> 0; //查询下一个。
    finally
      FindClose(F); //关闭文件查询。
    end;
    result := true;
  end;
end;
//全局搜索Java
procedure FullScanJava();
var
  pan: TArray<String>;
begin
  if MyMessagebox(GetLanguage('messagebox_launch.is_full_scan_java.caption'), GetLanguage('messagebox_launch.is_full_scan_java.text'), MY_INFORMATION, [mybutton.myNo, mybutton.myYes]) = 1 then exit;
  pan := TDirectory.GetLogicalDrives;
  TThread.CreateAnonymousThread(procedure begin
    for var I in pan do begin
      form_mainform.label_launch_java_logic.Caption := GetLanguage('label_launch_java_login.caption.full_scan_java').Replace('${drive}', LeftStr(I, 1));
      try
        SearchJava(LeftStr(I, 2));
//          form_mainform.label_launch_java_logic.Caption := GetLanguage('label_launch_java_login.caption.full_scan_java_error');
  //        MyMessagebox(GetLanguage('messagebox_launch.full_scan_java_error.caption'), GetLanguage('messagebox_launch.full_scan_java_error.text').Replace('${drive}', LeftStr(I, 1)), MY_ERROR, [mybutton.myOK]);
  //        exit;
//        end;
      except end;
    end;
    form_mainform.label_launch_java_logic.Caption := GetLanguage('label_launch_java_login.caption.full_scan_java_success');
    MyMessagebox(GetLanguage('messagebox_launch.full_scan_java_success.caption'), GetLanguage('messagebox_launch.full_scan_java_success.text'), MY_PASS, [mybutton.myOK]);
  end).Start;
end;
//在注册表中扫描Java。。
function SearchJavaOnRegedit: Boolean;
var
  Reg: TRegistry;
begin
  result := false;
  Reg := TRegistry.Create(KEY_READ);
  try
    with Reg do begin
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKey('SOFTWARE\JavaSoft', False) then begin
        var sk := TStringList.Create;
        GetKeyNames(sk);
        for var I in sk do begin
          CloseKey;
          if OpenKey(Concat('SOFTWARE\JavaSoft\', I), False) then begin
            var ak := TStringList.Create;
            GetKeyNames(ak);
            for var J in ak do begin
              CloseKey;
              if OpenKey(Concat('SOFTWARE\JavaSoft\', I, '\', J), False) then begin
                var path := ReadString('JavaHome');
                SearchJava(path);
              end;
            end;
          end;
        end;
        result := true;
      end;
    end;
  finally
    Reg.Free;
  end;
end;
//特定扫描Java
procedure BasicScanJava();
var
  ss: DWORD;
  buf: pchar;
begin
  if MyMessagebox(GetLanguage('messagebox_launch.is_basic_scan_java.caption'), GetLanguage('messagebox_launch.is_basic_scan_java.text'), MY_INFORMATION, [mybutton.myNO, mybutton.myYes]) = 1 then exit;
  GetMem(buf, 255);
  ss := 255;
  GetUserName(buf, ss);
  TThread.CreateAnonymousThread(procedure begin
    form_mainform.label_launch_java_logic.Caption := GetLanguage('label_launch_java_logic.caption.search_regedit');
    if not SearchJavaOnRegedit then begin
      form_mainform.label_launch_java_logic.Caption := GetLanguage('label_launch_java_login.caption.basic_scan_java_search_regedit_error');
      MyMessagebox(GetLanguage('messagebox_launch.basic_scan_java_search_regedit_error.caption'), GetLanguage('messagebox_launch.basic_scan_java_search_regedit_error.text'), MY_ERROR, [mybutton.myOK]);
    end;
    form_mainform.label_launch_java_logic.Caption := GetLanguage('label_launch_java_logic.caption.search_env_path');
    var vir := GetEnvironmentVariable('PATH');
    var sj: TArray<String>;
    sj := SplitString(vir, ';');
    for var I in sj do begin
      if I.ToLower.Contains('c:\windows') then continue;
      SearchJava(I);
    end;
    form_mainform.label_launch_java_logic.Caption := GetLanguage('label_launch_java_logic.caption.search_program');
    if DirectoryExists('C:\Program File\Java') then SearchJava('C:\Program Files\Java');
    form_mainform.label_launch_java_logic.Caption := GetLanguage('label_launch_java_logic.caption.search_official');
    if DirectoryExists(Concat('C:\Users\', strpas(buf), '\AppData\Local\Packages\Microsoft.4297127D64EC6_8wekyb3d8bbwe\LocalCache\Local\runtime')) then
      SearchJava(Concat('C:\Users\', strpas(buf), '\AppData\Local\Packages\Microsoft.4297127D64EC6_8wekyb3d8bbwe\LocalCache\Local\runtime'));
    form_mainform.label_launch_java_logic.Caption := GetLanguage('label_launch_java.logic.caption.search_lllpath');
    if DirectoryExists(Concat(AppData, '\LLLauncher\Java')) then SearchJava(Concat(AppData, '\LLLauncher\Java'));
    form_mainform.label_launch_java_logic.Caption := GetLanguage('label_launch_java_logic.caption.basic_scan_java_success');
    MyMessagebox(GetLanguage('messagebox_launch.basic_scan_java_success.caption'), GetLanguage('messagebox_launch.basic_scan_java_success.text'), MY_PASS, [mybutton.myOK])
  end).Start;
end;
//移除Java
procedure RemoveJava();
begin
  if mcurrent_java = -1 then begin
    MyMessagebox(GetLanguage('messagebox_launch.not_choose_java.caption'), GetLanguage('messagebox_launch.not_choose_java.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  if MyMessagebox(GetLanguage('messagebox_launch.is_remove_java.caption'), GetLanguage('messagebox_launch.is_remove_java.text'), MY_INFORMATION, [mybutton.myNo, mybutton.myYes]) = 1 then exit;
  (JavaJson.GetValue('java') as TJsonArray).Remove(form_mainform.combobox_launch_select_java_path.ItemIndex);
  mcurrent_java := -1;
  form_mainform.combobox_launch_select_java_path.Items.Delete(form_mainform.combobox_launch_select_java_path.ItemIndex);
  form_mainform.combobox_launch_select_java_path.ItemIndex := -1;
  MyMessagebox(GetLanguage('messagebox_launch.remove_java_success.caption'), GetLanguage('messagebox_launch.remove_java_success.text'), MY_PASS, [mybutton.myOK]);
end;
//下载Java的函数
procedure DownloadJava(ver: String);
begin
  var ymeta := 'https://piston-meta.mojang.com/v1/products/java-runtime/2ec0cc96c44e5a76b9c8b7c39df7210883d12871/all.json';
  case mdownload_source of
    2: ymeta := ymeta.Replace('https://piston-meta.mojang.com', 'https://bmclapi2.bangbang93.com');
    3: ymeta := ymeta.Replace('https://piston-meta.mojang.com', 'https://download.mcbbs.net');
  end;
  form_mainform.pagecontrol_mainpage.ActivePage := form_mainform.tabsheet_download_progress_part;
  TThread.CreateAnonymousThread(procedure begin
    var jpath := Concat(AppData, '\LLLauncher\Java\', ver);
    if not DirectoryExists(jpath) then ForceDirectories(jpath);
    form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.java.get_java_metadata'));
    var gmeta := GetWebText(ymeta);
    if gmeta = '' then begin
      MyMessagebox(GetLanguage('messagebox_launch.get_java_metadata_error.caption'), GetLanguage('messagebox_launch.get_java_metadata_error.text'), MY_ERROR, [mybutton.myOK]);
      form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add('downloadlist.java.get_java_metadata_error');
      exit;
    end;
    var metajaon := TJSONObject.ParseJSONValue(gmeta) as TJSONObject;
    var mani := ((((metajaon.GetValue('windows-x64') as TJsonObject).GetValue(ver) as TJsonArray)[0] as TJsonObject).GetValue('manifest') as TJsonObject).GetValue('url').Value;
    var jver := ((((metajaon.GetValue('windows-x64') as TJsonObject).GetValue(ver) as TJsonArray)[0] as TJsonObject).GetValue('version') as TJsonObject).GetValue('name').Value;
    form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.java.get_java_manifest').Replace('${java_version}', jver));
    case mdownload_source of
      2: mani := mani.Replace('https://piston-meta.mojang.com', 'https://bmclapi2.bangbang93.com');
      3: mani := mani.Replace('https://piston-meta.mojang.com', 'https://download.mcbbs.net');
    end;
    var murl := GetWebText(mani);
    if murl = '' then begin
      MyMessagebox(GetLanguage('messagebox_launch.get_java_manifest_error.caption'), GetLanguage('messagebox_launch.get_java_manifest_error.text').Replace('${java_path}', jver), MY_ERROR, [mybutton.myOK]);
      form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.java.get_java_manifest_error').Replace('${java_path}', jver));
      exit;
    end;
    form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.java.get_java_success'));
    DownloadStart(murl, jpath, '', mbiggest_thread, mdownload_source, 3);
    form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.java.download_java_success'));
    MyMessagebox(GetLanguage('messagebox_launch.download_java_success.caption'), GetLanguage('messagebox_launch.download_java_success.text'), MY_PASS, [mybutton.myOK]);
  end).Start;
end;
//手动导入Java
procedure ManualImportJava();
begin
  var CB := TOpenDialog.Create(nil);
  CB.Title := GetLanguage('opendialog_launch.menual_import_java_dialog_title');
  CB.Filter := 'javaw(javaw.exe)|javaw.exe';
  if CB.Execute() then begin
    var jpath := CB.FileName;
    var bit := GetFileBits(jpath);
    if (bit = '32') or (bit = '') then begin
      MyMessagebox(GetLanguage('messagebox_launch.not_support_java_bit.caption'), GetLanguage('messagebox_launch.not_support_java_bit.text'), MY_ERROR, [mybutton.myOK]);
      exit;
    end;
    var ver := GetFileVersion(jpath);
    form_mainform.combobox_launch_select_java_path.ItemIndex := form_mainform.combobox_launch_select_java_path.Items.Add(Concat('Java(', ver, ')(', bit, ')', jpath));
    (JavaJson.GetValue('java') as TJsonArray).Add(jpath);
    mcurrent_java := form_mainform.combobox_launch_select_java_path.ItemIndex;
    MyMessagebox(GetLanguage('messagebox_launch.menual_import_java_success.caption'), GetLanguage('messagebox_launch.menual_import_java_success.text'), MY_PASS, [mybutton.myOK]);
  end;
end;
//初始化启动设置界面
var f: Boolean = false;
procedure InitLaunch;
var
  status: TMemoryStatus;
begin
  if f then exit;
  f := true;
  JavaJSON := TJSONObject.Create;
  form_mainform.scrollbar_launch_window_width.Max := GetSystemMetrics(SM_CXSCREEN) - 1;
  form_mainform.scrollbar_launch_window_height.Max := GetSystemMetrics(SM_CYSCREEN) - 1;
  GlobalMemoryStatus(status);
  form_mainform.scrollbar_launch_max_memory.Max := ceil(status.dwTotalPhys / 1024 / 1024);
  if not FileExists(Concat(ExtractFilePath(Application.ExeName), 'LLLauncher\configs\JavaJson.json')) then begin
    JavaJson.AddPair('java', TJsonArray.Create);
    SetFile(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\JavaJson.json'), JavaJson.Format);
  end else begin
    var j := GetFile(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\JavaJson.json'));
    JavaJson := TJsonObject.ParseJSONValue(j) as TJsonObject;
  end;
  try
    for var I in (JavaJson.GetValue('java') as TJsonArray) do  //获取Java
      form_mainform.combobox_launch_select_java_path.Items.Add(Concat('Java(', GetFileVersion(I.Value), ')(', GetFileBits(I.Value), ')', I.Value));
  except
    JavaJSON := TJSONObject.Create;
    JavaJson.AddPair('java', TJsonArray.Create);
    SetFile(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\JavaJson.json'), JavaJson.Format);
  end;
  try
    mcurrent_java := LLLini.ReadInteger('Java', 'SelectJava', 0) - 1;
    if (mcurrent_java < 0) or (mcurrent_java > (JavaJson.GetValue('java') as TJsonArray).Count) then raise Exception.Create('Format Exception');
    form_mainform.combobox_launch_select_java_path.ItemIndex := mcurrent_java;
  except
    form_mainform.combobox_launch_select_java_path.ItemIndex := -1;
    mcurrent_java := -1;
    LLLini.WriteInteger('Java', 'SelectJava', mcurrent_java + 1); //如果没有，则赋值重新写入文件
  end;
  try //判断长宽
    mwindow_width := LLLini.ReadInteger('Document', 'WindowsWidth', -1);
    mwindow_height := LLLini.ReadInteger('Document', 'WindowsHeight', -1);
    if (mwindow_width < 854) or (mwindow_width > form_mainform.scrollbar_launch_window_width.Max) then raise Exception.Create('Format Exception');
    if (mwindow_height < 480) or (mwindow_height > form_mainform.scrollbar_launch_window_height.Max) then raise Exception.Create('Format Exception');
  except
    mwindow_width := 854;
    mwindow_height := 480;
    LLLini.WriteInteger('Document', 'WindowsWidth', mwindow_width);
    LLLini.WriteInteger('Document', 'WindowsHeight', mwindow_height);
  end;
  try
    mmax_memory := LLLini.ReadInteger('Document', 'MaxMemory', -1);
    if (mmax_memory < 1024) or (mmax_memory > form_mainform.scrollbar_launch_max_memory.Max) then raise Exception.Create('Format Exception');
  except
    mmax_memory := 1024;
    LLLini.WriteInteger('Document', 'MaxMemory', mmax_memory);
  end;
  mcustom_info := LLLini.ReadString('Version', 'CustomInfo', '');
  if mcustom_info = '' then mcustom_info := 'LLL';
  mwindow_title := LLLini.ReadString('Version', 'CustomTitle', '');
  form_mainform.scrollbar_launch_window_width.Position := mwindow_width;
  form_mainform.label_launch_window_width.Caption := GetLanguage('label_launch_window_width.caption').Replace('${window_width}', inttostr(mwindow_width));
  form_mainform.scrollbar_launch_window_height.Position := mwindow_height;
  form_mainform.label_launch_window_height.Caption := GetLanguage('label_launch_window_height.caption').Replace('${window_height}', inttostr(mwindow_height));
  form_mainform.scrollbar_launch_max_memory.Position := mmax_memory;
  form_mainform.label_launch_max_memory.Caption := GetLanguage('label_launch_max_memory.caption').Replace('${memory}', inttostr(mmax_memory)).Replace('${total_memory}', inttostr(mtotal_memory)).Replace('${avail_memory}', inttostr(mavail_memory));
  form_mainform.edit_launch_window_title.Text := mwindow_title;
  form_mainform.edit_launch_custom_info.Text := mcustom_info;
  form_mainform.edit_launch_pre_launch_script.Text := LLLini.ReadString('Version', 'Pre-LaunchScript', '');
  mpre_script := form_mainform.edit_launch_pre_launch_script.Text;
  form_mainform.edit_launch_after_launch_script.Text := LLLini.ReadString('Version', 'After-LaunchScript', '');
  mafter_script := form_mainform.edit_launch_after_launch_script.Text;
  form_mainform.edit_launch_additional_jvm.Text := LLLini.ReadString('Version', 'AdditionalJVM', '');
  madd_jvm := form_mainform.edit_launch_additional_jvm.Text;
  form_mainform.edit_launch_additional_game.Text := LLLini.ReadString('Version', 'AdditionalGame', '');
  madd_game := form_mainform.edit_launch_additional_game.Text;
end;
//保存启动设置
procedure SaveLaunch;
begin
  if JavaJSON = nil then exit;
  SetFile(Concat(ExtractFilePath(Application.ExeName), 'LLLauncher\configs\JavaJson.json'), JavaJSON.Format);
  LLLini.WriteString('Document', 'WindowsHeight', inttostr(mwindow_height));
  LLLini.WriteString('Document', 'WindowsWidth', inttostr(mwindow_width));
  LLLini.WriteString('Document', 'MaxMemory', inttostr(mmax_memory));
  LLLini.WriteString('Version', 'CustomInfo', mcustom_info);
  LLLini.WriteString('Version', 'CustomTitle', mwindow_title);
  LLLini.WriteString('Version', 'AdditionalJVM', madd_jvm);
  LLLini.WriteString('Version', 'AdditionalGame', madd_game);
  LLLini.WriteString('Java', 'SelectJava', inttostr(mcurrent_java + 1));
  LLLini.WriteString('Version', 'Pre-LaunchScript', mpre_script);
  LLLini.WriteString('Version', 'After-LaunchScript', mafter_script);
end;

end.

