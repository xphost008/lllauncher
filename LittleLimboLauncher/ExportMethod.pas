unit ExportMethod;

interface

uses
  Windows, SysUtils, Forms, IniFiles, WinXCtrls, Math, JSON, Classes, Threading, 
  ComCtrls, StrUtils, DateUtils, Dialogs, Zip, pngimage, NetEncoding;

procedure InitIsolation;
procedure InitExport;
procedure IsoMethod(k: Integer; v: String);
procedure SelectNode(AllCheck: Boolean; ANode: TTreeNode);
procedure StartExport;
procedure ImportModPackIcon(path: String);
procedure RemoveModPackIcon;

implementation

uses
  VersionMethod, MainForm, LanguageMethod, MyCustomWindow, MainMethod, LauncherMethod;

var
  IsoIni: TIniFile;

var
  mexport_mcpath, mexport_mcname, mexport_mcid, mexport_vanillaid, mexport_loader, mexport_loadversion: String;
  NodePath: TStringList;
  mpicon: String = '';
//导入整合包图标
procedure ImportModPackIcon(path: String);
begin
  if FileExists(path) then begin
    var ss := TMemoryStream.Create;
    var s2 := TStringStream.Create;
    var pg := TPngImage.Create;
    try
      ss.LoadFromFile(path);
      pg.LoadFromStream(ss);
      form_mainform.image_export_add_icon.Picture.Assign(pg);
      ss.Position := 0;
      TNetEncoding.Base64.Encode(ss, s2);
      mpicon := s2.DataString;
    finally
      ss.Free;
      s2.Free;
      pg.Free;
    end;
  end;
end;
//移除整合包图标
procedure RemoveModPackIcon;
begin
  form_mainform.image_export_add_icon.Picture := nil;
  mpicon := '';
end;
//与下一个一致，使用递归解决。
procedure GetAllChildNodes(ANode: TTreeNode; var NodeChecked: TStringList);
var
  vNode: TTreeNode;
begin
  vNode := ANode.getFirstChild;
  while vNode <> nil do begin
    NodeChecked.Add(IfThen(vnode.Checked, 'True', 'False'));
    GetAllChildNodes(vNode, NodeChecked);
    vNode := ANode.GetNextChild(vNode);
  end;
end;
//遍历所有子文件树
procedure VisitAllNodes(ATreeView: TTreeView; var NodeChecked: TStringList);
var
  vNode: TTreeNode;
begin
  vNode := ATreeView.Items.GetFirstNode;
  while vNode <> nil do begin
    NodeChecked.Add(IfThen(vnode.Checked, 'True', 'False'));
    GetAllChildNodes(vNode, NodeChecked);
    vNode := vNode.getNextSibling;
  end;
end;
//检查导出的是否有误。
function PackCheckError: Boolean;
begin                                                      
  result := false;  
  if form_mainform.radiogroup_export_mode.ItemIndex = -1 then begin
    MyMessagebox(GetLanguage('messagebox_export.not_choose_mode.caption'), GetLanguage('messagebox_export.not_choose_mode.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  if form_mainform.edit_export_modpack_name.Text = '' then begin
    MyMessagebox(GetLanguage('messagebox_export.not_enter_name.caption'), GetLanguage('messagebox_export.not_enter_name.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  if form_mainform.edit_export_modpack_author.Text = '' then begin
    MyMessagebox(GetLanguage('messagebox_export.not_enter_author.caption'), GetLanguage('messagebox_export.not_enter_author.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  if form_mainform.edit_export_modpack_version.Text = '' then begin
    MyMessagebox(GetLanguage('messagebox_export.not_enter_version.caption'), GetLanguage('messagebox_export.not_enter_version.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  if form_mainform.radiogroup_export_mode.ItemIndex = 0 then begin
    if (form_mainform.edit_export_update_link.Text <> '') and (LeftStr(form_mainform.edit_export_update_link.Text, 7) <> 'http://') and (LeftStr(form_mainform.edit_export_update_link.Text, 8) <> 'https://') then begin
      MyMessagebox(GetLanguage('messagebox_export.update_link_error.caption'), GetLanguage('messagebox_export.update_link_error.text'), MY_ERROR, [mybutton.myOK]);
      exit;
    end;
    if (form_mainform.edit_export_official_website.Text <> '') and (LeftStr(form_mainform.edit_export_official_website.Text, 7) <> 'http://') and (LeftStr(form_mainform.edit_export_official_website.Text, 8) <> 'https://') then begin
      MyMessagebox(GetLanguage('messagebox_export.official_website_error.caption'), GetLanguage('messagebox_export.official_website_error.text'), MY_ERROR, [mybutton.myOK]);
      exit;
    end;
    var tmp: Integer;
    var tid: String := form_mainform.edit_export_mcbbs_tid.Text;
    if (tid <> '') and (TryStrToInt(tid, tmp)) then begin
      MyMessagebox(GetLanguage('messagebox_export.official_website_error.caption'), GetLanguage('messagebox_export.official_website_error.text'), MY_ERROR, [mybutton.myOK]);
      exit;
    end;       
    if (form_mainform.edit_export_authentication_server.Text <> '') and (LeftStr(form_mainform.edit_export_authentication_server.Text, 7) <> 'http://') and (LeftStr(form_mainform.edit_export_authentication_server.Text, 8) <> 'https://') then begin
      MyMessagebox(GetLanguage('messagebox_export.authentication_server_error.caption'), GetLanguage('messagebox_export.authentication_server_error.text'), MY_ERROR, [mybutton.myOK]);
      exit;
    end;
  end;
  case form_mainform.radiogroup_export_mode.ItemIndex of
    0: begin
      if (form_mainform.edit_export_update_link.Text <> '') and (LeftStr(form_mainform.edit_export_update_link.Text, 7) <> 'http://') and (LeftStr(form_mainform.edit_export_update_link.Text, 8) <> 'https://') then begin
        MyMessagebox(GetLanguage('messagebox_export.update_link_error.caption'), GetLanguage('messagebox_export.update_link_error.text'), MY_ERROR, [mybutton.myOK]);
        exit;
      end;
      if (form_mainform.edit_export_official_website.Text <> '') and (LeftStr(form_mainform.edit_export_official_website.Text, 7) <> 'http://') and (LeftStr(form_mainform.edit_export_official_website.Text, 8) <> 'https://') then begin
        MyMessagebox(GetLanguage('messagebox_export.official_website_error.caption'), GetLanguage('messagebox_export.official_website_error.text'), MY_ERROR, [mybutton.myOK]);
        exit;
      end;
      var tmp: Integer;
      var tid: String := form_mainform.edit_export_mcbbs_tid.Text;
      if (tid <> '') and (TryStrToInt(tid, tmp)) then begin
        MyMessagebox(GetLanguage('messagebox_export.official_website_error.caption'), GetLanguage('messagebox_export.official_website_error.text'), MY_ERROR, [mybutton.myOK]);
        exit;
      end;       
      if (form_mainform.edit_export_authentication_server.Text <> '') and (LeftStr(form_mainform.edit_export_authentication_server.Text, 7) <> 'http://') and (LeftStr(form_mainform.edit_export_authentication_server.Text, 8) <> 'https://') then begin
        MyMessagebox(GetLanguage('messagebox_export.authentication_server_error.caption'), GetLanguage('messagebox_export.authentication_server_error.text'), MY_ERROR, [mybutton.myOK]);
        exit;
      end;
    end;
  end;
  var boo := true;
  for var I in form_mainform.treeview_export_keep_file.Items do begin
    if I.Checked then begin
      boo := false;
      break;
    end;
  end;
  if boo then begin
    MyMessagebox(GetLanguage('messagebox_export.no_export_file.caption'), GetLanguage('messagebox_export.no_export_file.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  result := true;
end;      
//复制所有文件到目标文件夹里面
procedure CopyFileOver(filelist: TStringList; targetPath: String);
begin
  if not DirectoryExists(targetPath) then ForceDirectories(targetPath);
  for var I in filelist do begin
    var rlpth := Concat(targetPath, '\', I.Replace(Concat(mexport_mcpath, '\'), ''));
    if not DirectoryExists(ExtractFileDir(rlpth)) then ForceDirectories(ExtractFileDir(rlpth));
    CopyFile(pchar(I), pchar(rlpth), False);
  end;
end;
function GetMCBBSMeta(var NodeReal: TStringList): String;
begin
  var desc: String := '';
  for var I := 0 to form_mainform.memo_export_modpack_profile.Lines.Count - 1 do begin
    if I = form_mainform.memo_export_modpack_profile.Lines.Count - 1 then begin
      desc := Concat(desc, form_mainform.memo_export_modpack_profile.Lines[I]);
      break;
    end;
    desc := Concat(desc, Concat(form_mainform.memo_export_modpack_profile.Lines[I], #10));
  end;
  var root := TJSONObject.Create;
  root
    .AddPair('manifestType', 'minecraftModpack')
    .AddPair('manifestVersion', 2)
    .AddPair('name', form_mainform.edit_export_modpack_name.Text)
    .AddPair('author', form_mainform.edit_export_modpack_author.Text)
    .AddPair('version', form_mainform.edit_export_modpack_version.Text)
    .AddPair('description', desc)
    .AddPair('fileApi', form_mainform.edit_export_update_link.Text)
    .AddPair('url', form_mainform.edit_export_official_website.Text)
    .AddPair('forceUpdate', false)
    .AddPair('origin', TJsonArray.Create);
  if mpicon <> '' then
    root.AddPair('icon', mpicon);
  if form_mainform.edit_export_mcbbs_tid.Text <> '' then begin
    (root.GetValue('origin') as TJSONArray)
      .Add(TJSONObject.Create
       .AddPair('type', 'mcbbs')
       .AddPair('id', strtoint(form_mainform.edit_export_mcbbs_tid.Text)));
  end;        
  if mexport_loader = 'vanilla' then begin
    root
      .AddPair('addons', TJsonArray.Create
        .Add(TJsonObject.Create
          .AddPair('id', 'game')
          .AddPair('version', mexport_mcid)));  
  end else begin
    root
      .AddPair('addons', TJsonArray.Create
        .Add(TJsonObject.Create
          .AddPair('id', 'game')
          .AddPair('version', mexport_mcid))
        .Add(TJsonObject.Create
          .AddPair('id', mexport_loader)
          .AddPair('version', mexport_loadversion)));
  end;
  root.AddPair('files', TJSONArray.Create);
  for var i in NodeReal do begin
    (root.GetValue('files') as TJsonArray)
      .Add(TJsonObject.Create
        .AddPair('type', 'addon')
        .AddPair('path', I.Replace(Concat(mexport_mcpath, '\'), '').Replace('\', '/'))
        .AddPair('hash', GetFileHash(I))
        .AddPair('force', true));
  end;
  root
    .AddPair('settings', TJsonObject.Create
      .AddPair('install_mods', true)
      .AddPair('install_resourcepack', true))
    .AddPair('launcherInfo', TJsonObject.Create
      .AddPair('minMemory', form_mainform.scrollbar_export_max_memory.Position)
      .AddPair('launchArgument', TJsonArray.Create)
      .AddPair('javaArgument', TJsonArray.Create));
  if form_mainform.edit_export_additional_jvm.Text <> '' then begin
    var cutargs: TArray<String>;
    cutargs := SplitString(form_mainform.edit_export_additional_jvm.Text, ' ');
    for var I in cutargs do
      ((root.GetValue('launcherInfo') as TJsonObject).GetValue('launchArgument') as TJsonArray)
        .Add(I);
  end;
  if form_mainform.edit_export_additional_game.Text <> '' then begin
    var cutargs: TArray<String>;
    cutargs := SplitString(form_mainform.edit_export_additional_game.Text, ' ');
    for var I in cutargs do
      ((root.GetValue('launcherInfo') as TJsonObject).GetValue('javaArgument') as TJsonArray)
        .Add(I);                                                         
  end;
  if form_mainform.edit_export_authentication_server.Text <> '' then begin
    root
      .AddPair('serverInfo', TJsonObject.Create
        .AddPair('authlibInjectorServer', form_mainform.edit_export_authentication_server.Text)
        .AddPair('authlibInjectorAllowOnlineMode', false));
  end;
  result := root.Format();
end;
function GetMultiMCFiles: TArray<String>;
begin
  SetLength(result, 2);
  var root := TJsonObject.Create;
  root.AddPair('formatVersion', 1);
  if mpicon <> '' then
    root.AddPair('icon', mpicon);
  root.AddPair('components', TJsonArray.Create.Add(TJsonObject.Create
    .AddPair('important', true)
    .AddPair('dependencyOnly', false)
    .AddPair('uid', 'net.minecraft')
    .AddPair('version', mexport_mcid)));
  if mexport_vanillaid <> '' then begin
    (root.GetValue('components') as TJsonArray).Add(TJsonObject.Create
      .AddPair('important', false)
      .AddPair('dependencyOnly', false)
      .AddPair('uid', mexport_vanillaid)
      .AddPair('version', mexport_loadversion))
  end;
  result[0] := root.Format();
  var desc: String := '';
  for var I := 0 to form_mainform.memo_export_modpack_profile.Lines.Count - 1 do begin
    if I = form_mainform.memo_export_modpack_profile.Lines.Count - 1 then begin
      desc := Concat(desc, form_mainform.memo_export_modpack_profile.Lines[I]);
      break;
    end;
    desc := Concat(desc, Concat(form_mainform.memo_export_modpack_profile.Lines[I], '\n'));
  end;
  var tme := Now.Format('yyyy/mm/dd HH:nn:ss');
  var cfg := Concat(
    '#Auto generated by Little Limbo Launcher', #10,
    '#generated time:', tme, #10,
    'notes=', desc, #10,
    'WrapperCommand=', #10,
    'ShowConsoleOnError=true', #10,
    'OverrideJavaLocation=false', #10,
    'MaxMemAlloc=2048', #10,
    'MinecraftWinHeight=480', #10,
    'OverrideMemory=true', #10,
    'PreLaunchCommand=', #10,
    'MinMemAlloc=', inttostr(form_mainform.scrollbar_export_max_memory.Position), #10,
    'OverrideJavaArgs=true', #10,
    'JvmArgs=', #10,
    'name=', form_mainform.edit_export_modpack_name.Text, '-', form_mainform.edit_export_modpack_version.Text, #10,
    'LaunchMaximized=false', #10,
    'OverrideWindow=true', #10,
    'ShowConsole=false', #10,
    'MinecraftWinWidth=854', #10,
    'AutoCloseConsole=false', #10,
    'InstanceType=OneSix', #10,
    'OverrideCommands=true', #10,
    'OverrideConsole=true', #10
  );
  result[1] := cfg;
end;
//初始化所有文件的方法
procedure ChooseDirectory(T: TTreeView; N: String; R: TTreeNode; IsFirst: Boolean);
var
  F: TSearchRec;
  I: TTreeNode;
begin
  with T.Items do begin
    BeginUpdate;
    if (N = '') then exit;
    if N.IndexOf('\') = -1 then N := Concat(N, '===\:\:=nodir====');
    if FindFirst(Concat(N, '\*.*'), faDirectory, F) = 0 then begin  //查找文件并赋值
      try
        repeat  //此处调用了API函数。
          if (F.Name <> '.') and (F.Name <> '..') then begin //删除首次寻找文件时出现的【.】和【..】字符。
            var lr := LowerCase(F.Name);
            if IsFirst then begin
              if (lr = 'versions') or
              (lr = 'assets') or
              (lr = 'libraries') or
              (lr = 'logs') or
              (lr = 'crash-reports') or
              (lr.IndexOf('natives') <> -1) or
              (lr = 'launcher_profiles.json') or   
              (lr = 'install_profile.json') or
              (RightStr(lr, 4) = '.jar') or
              (lr = '===zip===') then continue;
            end;
            if RightStr(lr, 4) = '.log' then continue;
            if ((F.Attr and faDirectory) = faDirectory) then begin //查找是否为文件，如果是则执行
              if (F.Attr and faDirectory > 0) then begin
                NodePath.Add(Concat(N, '\', F.Name));
                R := AddChild(R, F.Name);
              end;
              I := R.Parent;
              ChooseDirectory(T, Concat(N, '\', F.Name), R, False); //重复调用本函数，并且加上文件名。
              R := I;
            end else begin
              if IsJSONError(Concat(N, '\', F.Name)) then continue;
              NodePath.Add(Concat(N, '\', F.Name));
              AddChild(R, F.Name); //添加子节点
            end;
          end;
        until FindNext(F) <> 0; //查询下一个。
      finally
        FindClose(F); //关闭文件查询。
      end;
    end;
    EndUpdate;
  end;
end;         
//导出部分：选择文件树文件查询
procedure SelectNode(AllCheck: Boolean; ANode: TTreeNode);
var
  tNode: TTreeNode;
begin
  tNode := ANode.getFirstChild;
  if not AllCheck then begin
    while tNode <> nil do begin
      tNode.Checked := true;
      SelectNode(AllCheck, tNode);
      tNode := ANode.GetNextChild(tNode);
    end;
  end else begin
    while tNode <> nil do begin
      tNode.Checked := false;
      SelectNode(AllCheck, tNode);
      tNode := ANode.GetNextChild(tNode);
    end;
  end;
end;
//加载导出部分
procedure LoadExport(pmcath, pmcnme, pmcid, pmuid, ploader, ploadver: String);      
var
  status: TMemoryStatus;
begin                              
  GlobalMemoryStatus(status);
  var mem: Integer := ceil(status.dwTotalPhys / 1024 / 1024);
  form_mainform.scrollbar_export_max_memory.Max := mem;
  form_mainform.treeview_export_keep_file.Items.Clear;
  NodePath.Clear;
  mexport_mcpath := pmcath;
  mexport_mcname := pmcnme;
  mexport_mcid := pmcid;
  mexport_vanillaid := pmuid;
  mexport_loader := ploader;
  mexport_loadversion := ploadver;                        
  form_mainform.label_export_memory.Caption := GetLanguage('label_export_memory.caption').Replace('${max_memory}', '1024');
  form_mainform.scrollbar_export_max_memory.Position := 1024;
  form_mainform.label_export_current_version.Caption := GetLanguage('label_export_current_version.caption').Replace('${current_version}', mexport_mcname);
  TTask.Run(procedure begin
    form_mainform.label_export_return_value.Caption := GetLanguage('label_export_return_value.caption.initialize');
    ChooseDirectory(form_mainform.treeview_export_keep_file, mexport_mcpath, nil, true);                        
    form_mainform.label_export_return_value.Caption := GetLanguage('label_export_return_value.caption.init_success');
  end);
end;     
//初始化导出部分
procedure InitIsolation;
var
  status: TMemoryStatus;
  mis_isolation, mis_csize, mis_cmemory, mis_partition: Boolean;
begin
  if mselect_ver < 0 then begin
    MyMessagebox(GetLanguage('messagebox_version.no_ver_dir.caption'), GetLanguage('messagebox_version.no_ver_dir.text'), MY_ERROR, [mybutton.myOK]);
    form_mainform.pagecontrol_version_part.ActivePage := form_mainform.tabsheet_version_control_part;
    exit;
  end;
  var sv := MCVersionSelect[mselect_ver];
  form_mainform.label_isolation_current_version.Caption := GetLanguage('label_isolation_current_version.caption').Replace('${current_version}', ExtractFileName(MCVersionSelect[mselect_ver]));
  IsoIni := TIniFile.Create(Concat(sv, '\LLLauncher.ini'));
  form_mainform.scrollbar_isolation_window_width.Max := GetSystemMetrics(SM_CXSCREEN) - 1;
  form_mainform.scrollbar_isolation_window_height.Max := GetSystemMetrics(SM_CYSCREEN) - 1;
  GlobalMemoryStatus(status);
  var mem: Integer := ceil(status.dwTotalPhys / 1024 / 1024);
  form_mainform.scrollbar_isolation_game_memory.Max := mem;
  mis_isolation := IsoIni.ReadBool('Isolation', 'IsIsolation', false);
  if mis_isolation then form_mainform.toggleswitch_is_open_isolation.State := tsson
  else form_mainform.toggleswitch_is_open_isolation.State := tssoff;
  form_mainform.edit_isolation_java_path.Text := IsoIni.ReadString('Isolation', 'JavaPath', '');
  form_mainform.edit_isolation_custom_info.Text := IsoIni.ReadString('Isolation', 'CustomInfo', '');
  form_mainform.edit_isolation_window_title.Text := IsoIni.ReadString('Isolation', 'CustomTitle', '');
  mis_csize := IsoIni.ReadBool('Isolation', 'IsSize', false);
  if mis_csize then form_mainform.toggleswitch_isolation_window_size.State := tsson
  else form_mainform.toggleswitch_isolation_window_size.State := tssoff;
  form_mainform.scrollbar_isolation_window_width.Position := IsoIni.ReadInteger('Isolation', 'Width', 854);
  if (form_mainform.scrollbar_isolation_window_width.Position > form_mainform.scrollbar_isolation_window_width.Max) or (form_mainform.scrollbar_isolation_window_width.Position < 854) then begin
    form_mainform.scrollbar_isolation_window_width.Position := 854;
    IsoIni.WriteInteger('Isolation', 'Width', 854);
  end;
  form_mainform.label_isolation_window_width.Caption := GetLanguage('label_isolation_window_width.caption').Replace('${current_width}', inttostr(form_mainform.scrollbar_isolation_window_width.Position));
  form_mainform.scrollbar_isolation_window_height.Position := IsoIni.ReadInteger('Isolation', 'Height', 480);
  if (form_mainform.scrollbar_isolation_window_height.Position > form_mainform.scrollbar_isolation_window_height.Max) or (form_mainform.scrollbar_isolation_window_height.Position < 480) then begin
    form_mainform.scrollbar_isolation_window_height.Position := 480;
    IsoIni.WriteInteger('Isolation', 'Height', 480);
  end;
  form_mainform.label_isolation_window_height.Caption := GetLanguage('label_isolation_window_height.caption').Replace('${current_height}', inttostr(form_mainform.scrollbar_isolation_window_height.Position));
  mis_cmemory := IsoIni.ReadBool('Isolation', 'IsMemory', false);
  if mis_cmemory then form_mainform.toggleswitch_isolation_open_memory.State := tsson
  else form_mainform.toggleswitch_isolation_open_memory.State := tssoff;
  form_mainform.scrollbar_isolation_game_memory.Position := IsoIni.ReadInteger('Isolation', 'MaxMemory', 1024);
  if (form_mainform.scrollbar_isolation_game_memory.Position > form_mainform.scrollbar_isolation_game_memory.Max) or (form_mainform.scrollbar_isolation_game_memory.Position < 1024) then begin
    form_mainform.scrollbar_isolation_game_memory.Position := 1024;
    IsoIni.WriteInteger('Isolation', 'MaxMemory', 1024);
  end;
  form_mainform.label_isolation_game_memory.Caption := GetLanguage('label_isolation_game_memory.caption').Replace('${current_memory}', inttostr(form_mainform.scrollbar_isolation_game_memory.Position));
  mis_partition := IsoIni.ReadBool('Isolation', 'IsPartition', false);
  if mis_partition then form_mainform.toggleswitch_isolation_open_partition.State := tsson
  else form_mainform.toggleswitch_isolation_open_partition.State := tssoff;
  form_mainform.checkbox_isolation_is_partition.Checked := IsoIni.ReadBool('Isolation', 'OpenPartition', false);
  form_mainform.edit_isolation_additional_game.Text := IsoIni.ReadString('Isolation', 'AdditionalGame', '');
  form_mainform.edit_isolation_additional_jvm.Text := IsoIni.ReadString('Isolation', 'AdditionalJVM', '');
  form_mainform.edit_isolation_pre_launch_script.Text := IsoIni.ReadString('Isolation', 'Pre-LaunchScript', '');
  form_mainform.edit_isolation_after_launch_script.Text := IsoIni.ReadString('Isolation', 'After-LaunchScript', '');
  if mis_isolation then begin
    form_mainform.edit_isolation_java_path.Enabled := true;
    form_mainform.button_isolation_choose_java.Enabled := true;
    form_mainform.edit_isolation_custom_info.Enabled := true;
    form_mainform.edit_isolation_window_title.Enabled := true;
    form_mainform.toggleswitch_isolation_window_size.Enabled := true;
    form_mainform.scrollbar_isolation_window_width.Enabled := true;
    form_mainform.scrollbar_isolation_window_height.Enabled := true;
    form_mainform.toggleswitch_isolation_open_memory.Enabled := true;
    form_mainform.scrollbar_isolation_game_memory.Enabled := true;
    form_mainform.toggleswitch_isolation_open_partition.Enabled := true;
    form_mainform.checkbox_isolation_is_partition.Enabled := true;
    form_mainform.edit_isolation_additional_game.Enabled := true;
    form_mainform.edit_isolation_additional_jvm.Enabled := true;
    form_mainform.edit_isolation_pre_launch_script.Enabled := true;
    form_mainform.edit_isolation_after_launch_script.Enabled := true;
    if mis_csize then begin
      form_mainform.scrollbar_isolation_window_width.Enabled := true;
      form_mainform.scrollbar_isolation_window_height.Enabled := true;
    end else begin
      form_mainform.scrollbar_isolation_window_width.Enabled := false;
      form_mainform.scrollbar_isolation_window_height.Enabled := false;
    end;
    if mis_cmemory then begin
      form_mainform.scrollbar_isolation_game_memory.Enabled := true;
    end else begin
      form_mainform.scrollbar_isolation_game_memory.Enabled := false;
    end;
    if mis_partition then begin
      form_mainform.checkbox_isolation_is_partition.Enabled := true;
    end else begin
      form_mainform.checkbox_isolation_is_partition.Enabled := false;
    end;
  end else begin
    form_mainform.edit_isolation_java_path.Enabled := false;
    form_mainform.button_isolation_choose_java.Enabled := false;
    form_mainform.edit_isolation_custom_info.Enabled := false;
    form_mainform.edit_isolation_window_title.Enabled := false;
    form_mainform.toggleswitch_isolation_window_size.Enabled := false;
    form_mainform.scrollbar_isolation_window_width.Enabled := false;
    form_mainform.scrollbar_isolation_window_height.Enabled := false;
    form_mainform.toggleswitch_isolation_open_memory.Enabled := false;
    form_mainform.scrollbar_isolation_game_memory.Enabled := false;
    form_mainform.toggleswitch_isolation_open_partition.Enabled := false;
    form_mainform.checkbox_isolation_is_partition.Enabled := false;
    form_mainform.edit_isolation_additional_game.Enabled := false;
    form_mainform.edit_isolation_additional_jvm.Enabled := false;
    form_mainform.edit_isolation_pre_launch_script.Enabled := false;
    form_mainform.edit_isolation_after_launch_script.Enabled := false;
  end;
end;
//检测独立版本方法
procedure IsoMethod(k: Integer; v: String);
begin
  case k of
    1:  IsoIni.WriteBool('Isolation', 'IsIsolation', strtobool(v));
    2:  IsoIni.WriteString('Isolation', 'JavaPath', v);
    3:  IsoIni.WriteString('Isolation', 'CustomInfo', v);
    4:  IsoIni.WriteString('Isolation', 'CustomTitle', v);
    5:  IsoIni.WriteBool('Isolation', 'IsSize', strtobool(v));
    6:  IsoIni.WriteInteger('Isolation', 'Width', strtoint(v));
    7:  IsoIni.WriteInteger('Isolation', 'Height', strtoint(v));
    8:  IsoIni.WriteBool('Isolation', 'IsMemory', strtobool(v));
    9:  IsoIni.WriteInteger('Isolation', 'MaxMemory', strtoint(v));
    10: IsoIni.WriteBool('Isolation', 'IsPartition', strtobool(v));
    11: IsoIni.WriteBool('Isolation', 'OpenPartition', strtobool(v));
    12: IsoIni.WriteString('Isolation', 'AdditionalGame', v);
    13: IsoIni.WriteString('Isolation', 'AdditionalJVM', v);
    14: IsoIni.WriteString('Isolation', 'Pre-LaunchScript', v);
    15: IsoIni.WriteString('Isolation', 'After-LaunchScript', v);
    else raise Exception.Create('Not Support Key!');
  end;
end;
var
  f: Boolean = true;
//初始化导出部分
procedure InitExport;
begin
  if mselect_ver < 0 then begin
    MyMessagebox(GetLanguage('messagebox_version.no_ver_dir.caption'), GetLanguage('messagebox_version.no_ver_dir.text'), MY_ERROR, [mybutton.myOK]);
    form_mainform.pagecontrol_version_part.ActivePage := form_mainform.tabsheet_version_control_part;
    exit;
  end;
  if f then begin
    NodePath := TStringList.Create;
  end;
  f := false;
  var json := GetFile(GetMCRealPath(MCVersionSelect[mselect_ver], '.json')).ToLower;
  var jsonRoot := TJSONObject.ParseJSONValue(json) as TJSONObject;
  var cname := ExtractFileName(MCVersionSelect[mselect_ver]);
  var rcth: String;
  var pand: Boolean := (json.IndexOf('com.mumfrey:liteloader:') <> -1) or (json.IndexOf('org.quiltmc:quilt-loader:') <> -1) or (json.IndexOf('net.fabricmc:fabric-loader:') <> -1) or (json.IndexOf('net.minecraftforge') <> -1) or (json.IndexOf('net.neoforged') <> -1);
  if misolation_mode = 4 then rcth := MCVersionSelect[mselect_ver]
  else if misolation_mode = 3 then begin
    if pand then rcth := MCVersionSelect[mselect_ver]
    else rcth := MCVersionList[mselect_mc];
  end else if misolation_mode = 2 then begin
    if not pand then rcth := MCVersionSelect[mselect_ver]
    else rcth := MCVersionList[mselect_mc];
  end else rcth := MCVersionList[mselect_mc];
  var IltIni := TIniFile.Create(Concat(MCVersionSelect[mselect_ver], '\LLLauncher.ini'));
  var isoz := IltIni.ReadString('Isolation', 'IsIsolation', '').ToLower;
  var isol := IltIni.ReadString('Isolation', 'Partition', '').ToLower;
  if isoz = 'true' then
    if isol = 'true' then
      rcth := MCVersionSelect[mselect_ver];
  var mcid := '';
  var isloader := '';
  var islver := '';
  var muid := '';
  try
    var game := (jsonRoot.GetValue('arguments') as TJsonObject).GetValue('game') as TJsonArray;
    for var I := 0 to game.Count - 1 do begin //此处如果库文件找不到【net.minecraftforge.forge:】则执行
      if game[I].Value.ToLower.Equals('--fml.forgeversion') then begin //开始查找其arguments/game中是否有--fml.forgeVersion键
        isloader := 'forge';
        islver := game[I + 1].Value;
        muid := 'net.minecraftforge';
        break;
      end else if game[I].Value.ToLower.Equals('--fml.neoforgeversion') then begin
        isloader := 'neoforge';
        islver := game[I + 1].Value;
        muid := 'net.neoforged';
        break;
      end;
    end;
  except end;
  if isloader.IsEmpty then begin //forge需要额外的判断一次。
    for var I in jsonRoot.GetValue('libraries') as TJSONArray do begin
      var ne := I.GetValue<String>('name'); //遍历库文件
      if ne.Contains('quilt-loader') then begin //查询是否有关键字符串
        isloader := 'quilt'; //一旦查到则执行，此处为切割出版本名
        islver := ne.Substring(0, ne.LastIndexOf(':') + 1);
        islver := ne.Replace(islver, ''); //切割出版本号。
        muid := 'org.quiltmc.quilt-loader';
        break;
      end else if ne.Contains('liteloader') then begin
        isloader := 'liteloader';
        islver := ne.Substring(0, ne.LastIndexOf(':') + 1);
        islver := ne.Replace(islver, '').ToUpper;
        muid := 'com.mumfrey.liteloader';
        break;
      end else if ne.Contains('fabric-loader') then begin
        isloader := 'fabric';
        islver := ne.Substring(0, ne.LastIndexOf(':') + 1);
        islver := ne.Replace(islver, '');
        muid := 'net.fabricmc.fabric-loader';
        break;
      end else if (ne.Contains('minecraftforge:forge') or ne.Contains('fmlloader')) and (ne.CountChar(':') = 2) then begin
        isloader := 'forge';
        islver := ne.Substring(0, ne.LastIndexOf(':') + 1);
        islver := ne.Replace(islver, '');
        islver := islver.Substring(islver.IndexOf('-') + 1, islver.Length);
        muid := 'net.minecraftforge';
        break;
      end else if ne.Contains('neoforged:neoforge') then begin
        isloader := 'neoforge';
        islver := ne.Substring(0, ne.LastIndexOf(':') + 1);
        islver := ne.Replace(islver, '');
        muid := 'net.neoforged';
        break;
      end else isloader := 'vanilla';
    end;
  end;
  mcid := GetVanillaVersion(json);
  if mcid = '' then begin
    MyMessagebox(GetLanguage('messagebox_export.cannot_find_vanilla_key.caption'), GetLanguage('messagebox_export.cannot_find_vanilla_key.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  LoadExport(rcth, cname, mcid, muid, isloader, islver);
end;
//开始导出咯！
procedure StartExport;
begin
  TTask.Run(procedure begin
    if not PackCheckError() then exit;
    form_mainform.label_export_return_value.Caption := GetLanguage('label_export_return_value.caption.scan_file');
    var NodeChecked := TStringList.Create;
    var NodeReal := TStringList.Create;
    VisitAllNodes(form_mainform.treeview_export_keep_file, NodeChecked);
    form_mainform.label_export_return_value.Caption := GetLanguage('label_export_return_value.caption.copy_file');
    var TempPath := TStringList.Create;
    for var I := 0 to NodePath.Count - 1 do begin
      if FileExists(NodePath[I]) then begin
        TempPath.Add(NodePath[I]);
        if strtobool(NodeChecked[I]) then
          NodeReal.Add(TempPath[TempPath.Count - 1]);
      end;
    end;
    form_mainform.label_export_return_value.Caption := GetLanguage('label_export_return_value.caption.scan_file_finish');
    case form_mainform.radiogroup_export_mode.ItemIndex of
      0: begin
        CopyFileOver(NodeReal, Concat(mexport_mcpath, '\===zip===\overrides'));
        SetFile(Concat(mexport_mcpath, '\===zip===\mcbbs.packmeta'), GetMCBBSMeta(NodeReal));
      end;
      1: begin
        CopyFileOver(NodeReal, Concat(mexport_mcpath, '\===zip===\.minecraft'));
        var mtmc := GetMultiMCFiles();
        SetFile(Concat(mexport_mcpath, '\===zip===\mmc-pack.json'), mtmc[0]);
        SetFile(Concat(mexport_mcpath, '\===zip===\instance.cfg'), mtmc[1]);
      end;
    end;
    form_mainform.label_export_return_value.Caption := GetLanguage('label_export_return_value.caption.copy_file_finish');
    TThread.Synchronize(nil, procedure begin
      var od := TSaveDialog.Create(nil);
      od.Filter := '*.zip|*.zip';
      od.Title := GetLanguage('savedialog_export.choose_export_path');
      od.FileName := form_mainform.edit_export_modpack_name.Text;
      if od.Execute() then begin
        if RightStr(od.FileName, 4) <> '.zip' then od.FileName := Concat(od.FileName, '.zip');
        if FileExists(od.FileName) then begin
          MyMessagebox(GetLanguage('messagebox_export.export_file_exists.caption'), GetLanguage('messagebox_export.export_file_exists.text'), MY_ERROR, [mybutton.myOK]);
          exit;
        end;
        TTask.Run(procedure begin
          form_mainform.label_export_return_value.Caption := GetLanguage('label_export_return_value.caption.is_export');
          TZipFile.ZipDirectoryContents(od.FileName, Concat(mexport_mcpath, '\===zip==='));
          DeleteDirectory(Concat(mexport_mcpath, '\===zip==='));                                 
          form_mainform.label_export_return_value.Caption := GetLanguage('label_export_return_value.caption.export_success');
          MyMessagebox(GetLanguage('messagebox_export.export_success.caption'), GetLanguage('messagebox_export.export_success.text'), MY_PASS, [mybutton.myOK]);
        end);
      end;
    end);
  end);
end;

end.
