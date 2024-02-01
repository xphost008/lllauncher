unit ManageMethod;

interface

uses
  SysUtils, Classes, IOUtils, StrUtils, Winapi.Messages, ShellAPI, Windows, Forms, JSON, pngimage, Threading, IniFiles;

function InitManage: Boolean;
procedure DragFileInWindow(var Msg: TMessage);
procedure ClearDatSelect;
procedure ManageChangeMap;
procedure ManageDisablePlaying;
procedure ManageEnablePlaying;
procedure ManageDeletePlaying;
procedure ManageRenamePlaying;
procedure ManageOpenPlaying;

implementation

uses
  LauncherMethod, MainForm, MyCustomWindow, LanguageMethod, MainMethod, ProgressMethod;

var
  ModSelect: TStringList;
  SavSelect: TStringList;
  ResSelect: TStringList;
  ShaSelect: TStringList;
  DatSelect: TStringList;
  PluSelect: TStringList;
  mcrlpth: String;
  temp: String;
var
  ModPackMetadata: TJSONObject;
//导入整合包函数，按照键值对来获取
function JudgeException(index: Integer; key: String): String;
begin
  try
    case index of
      1: begin
        result := ModPackMetadata.GetValue(key).Value;
      end;
      2: begin
        var dep := ModPackMetadata.GetValue('dependencies') as TJSONObject;
        result := dep.GetValue(key).Value;
      end;
      3: begin
        var dep := ModPackMetadata.GetValue('dependencies') as TJSONObject;
        result := dep.Get(strtoint(key)).JsonString.Value;
      end;
    end;
  except
    result := GetLanguage('picturebox_playing.has_no_data');
  end;
end;
//导入整合包函数
procedure ImportModPack(path: String);
begin
  if not Unzip(path, Concat(temp, 'LLLauncher\importmodpack')) then begin
    MyMessagebox(GetLanguage('messagebox_manage.cannot_unzip_modpack.caption'), GetLanguage('messagebox_manage.cannot_unzip_modpack.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  if FileExists(Concat(temp, 'LLLauncher\importmodpack\modrinth.index.json')) then begin
    var mi := GetFile(Concat(temp, 'LLLauncher\importmodpack\modrinth.index.json'));
    ModPackMetadata := TJSONObject.ParseJSONValue(mi) as TJSONObject;
    var mcv := JudgeException(2, 'minecraft');
    var ml := JudgeException(3, '1');
    var mlv := JudgeException(2, ml);
    if MyPicMsgBox(JudgeException(1, 'name'), GetLanguage('picturebox_manage.import_modrinth_modpack.text')
      .Replace('${modpack_game}', 'Modrinth')
      .Replace('${modpack_version}', JudgeException(1, 'versionId'))
      .Replace('${modpack_name}', JudgeException(1, 'name'))
      .Replace('${modpack_summary}', JudgeException(1, 'summary'))
      .Replace('${modpack_mcversion}', mcv)
      .Replace('${modpack_modloader}', ml)
      .Replace('${modpack_modloader_version}', mlv), nil) then begin
      try
        var mccp := (((TJsonObject.ParseJSONValue(GetFile(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\MCJson.json'))) as TJsonObject).GetValue('mc') as TJsonArray)[LLLini.ReadInteger('MC', 'SelectMC', -1) - 1] as TJsonObject).GetValue('path').Value;
        var jpth := ((TJsonObject.ParseJSONValue(GetFile(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\MCJson.json'))) as TJSONObject).GetValue('java') as TJSONArray)[LLLini.ReadInteger('Java', 'SelectJava', -1) - 1].Value;
        var mcsp := Concat(mccp, '\versions\', JudgeException(1, 'name'));
        if DirectoryExists(mcsp) then DeleteDirectory(mcsp);
        ForceDirectories(mcsp);
        TTask.Run(procedure begin
          form_mainform.button_progress_clean_download_list.Enabled := false;
          DownloadStart(Concat('Modrinth@', mcv, '@', ml, '@', mlv), mcsp, mccp, mbiggest_thread, mdownload_source, 5, jpth, mcv);
          form_mainform.button_progress_clean_download_list.Enabled := true;
          MyMessagebox(GetLanguage('messagebox_manage.import_modpack_success.caption'), GetLanguage('messagebox_manage.import_modpack_success.text'), MY_PASS, [mybutton.myOK]);
        end);
      except
        MyMessagebox(GetLanguage('messagebox_manage.read_config_error.caption'), GetLanguage('messagebox_manage.read_config_error.text'), MY_ERROR, [mybutton.myYes]);
        exit;
      end;
    end else exit;
  end else if FileExists(Concat(temp, 'LLLauncher\importmodpack\mmc-pack.json')) or FileExists(Concat(temp, 'LLLauncher\importmodpack\instance.cfg')) then begin

  end;
  DeleteDirectory(Concat(temp, 'LLLauncher\importmodpack'));
end;
//复制文件夹
function CopyDir(source, target: string): Boolean;
var
  sop: TSHFileOpStruct;
begin
  with sop do begin
    Wnd := 0;
    wFunc := FO_COPY;
    pFrom := pchar(source);
    pTo := pchar(target);
    fFlags := FOF_ALLOWUNDO;
    hNameMappings := nil;
    lpszProgressTitle := nil;
    fAnyOperationsAborted := false;
  end;
  Result := SHFileOperation(sop) = 0;
end;
//回收文件
function RecycleFile(fileName: String): Boolean;
var
  sop: TSHFileOpStruct;
begin
  with sop do begin
    Wnd := 0;
    wFunc := FO_DELETE;
    pFrom := pchar(filename);
    pTo := '';
    fFlags := FOF_ALLOWUNDO;
  end;
  Result := SHFileOperation(sop) = 0;
end;
//查询玩法文件夹，然后添加到列表框。
procedure SelectPlayingDir();
var
  ModFiles: TArray<String>;
  ResFiles: TArray<String>;
  SavFiles: TArray<String>;
  PluFiles: TArray<String>;
  ShaFiles: TArray<String>;
begin
  form_mainform.listbox_manage_import_mod.Clear;
  ModSelect.Clear;
  form_mainform.listbox_manage_import_map.Clear;
  SavSelect.Clear;
  form_mainform.listbox_manage_import_resourcepack.Clear;
  ResSelect.Clear;
  form_mainform.listbox_manage_import_shader.Clear;
  ShaSelect.Clear;
  form_mainform.listbox_manage_import_datapack.Clear;
  DatSelect.Clear;
  form_mainform.listbox_manage_import_plugin.Clear;
  PluSelect.Clear;
  try //模组
    var rpath := Concat(mcrlpth, '\mods');
    if DirectoryExists(rpath) then begin
      ModFiles := TDirectory.GetFiles(rpath);
      for var T in ModFiles do begin
        var ex := ExtractFileName(T);
        if (RightStr(ex, 4) = '.jar') or (RightStr(ex, 4) = '.zip') then begin
          ModSelect.Add(T);
          form_mainform.listbox_manage_import_mod.Items.Add(ex.Substring(0, ex.Length - 4));
        end else if (RightStr(ex, 13) = '.jar.disabled') or (RightStr(ex, 13) = '.zip.disabled') then begin
          ModSelect.Add(T);
          form_mainform.listbox_manage_import_mod.Items.Add(Concat('[禁用]', ex.Substring(0, ex.Length - 13)));
        end;
      end;
    end;
  except end;
  try //地图
    var rpath := Concat(mcrlpth, '\saves');
    if DirectoryExists(rpath) then begin
      SavFiles := TDirectory.GetDirectories(rpath);
      for var T in SavFiles do begin
        SavSelect.Add(T);
        form_mainform.listbox_manage_import_map.Items.Add(ExtractFilename(T));
      end;
    end;
  except end;
  try //纹理
    var rpath := Concat(mcrlpth, '\resourcepacks');
    if DirectoryExists(rpath) then begin
      ResFiles := TDirectory.GetFiles(rpath);
      for var T in ResFiles do begin
        var ex := ExtractFileName(T);
        if (RightStr(ex, 4) = '.zip') then begin
          ResSelect.Add(T);
          form_mainform.listbox_manage_import_resourcepack.Items.Add(ex.Substring(0, ex.Length - 4));
        end;
      end;
    end;
  except end;
  try //光影
    var rpath := Concat(mcrlpth, '\shaderpacks');
    if DirectoryExists(rpath) then begin
      ShaFiles := TDirectory.GetFiles(rpath);
      for var T in ShaFiles do begin
        var ex := ExtractFileName(T);
        if (RightStr(ex, 4) = '.zip') then begin
          ShaSelect.Add(T);
          form_mainform.listbox_manage_import_shader.Items.Add(ex.Substring(0, ex.Length - 4));
        end;
      end;
    end;
  except end;
  try //插件
    var rpath := Concat(mcrlpth, '\plugins');
    if DirectoryExists(rpath) then begin
      PluFiles := TDirectory.GetFiles(rpath);
      for var T in PluFiles do begin
        var ex := ExtractFileName(T);
        if (RightStr(ex, 4) = '.jar') or (RightStr(ex, 4) = '.zip') then begin
          PluSelect.Add(T);
          form_mainform.listbox_manage_import_plugin.Items.Add(ex.Substring(0, ex.Length - 4));
        end else if (RightStr(ex, 13) = '.jar.disabled') or (RightStr(ex, 13) = '.zip.disabled') then begin
          PluSelect.Add(T);
          form_mainform.listbox_manage_import_plugin.Items.Add(Concat('[禁用]', ex.Substring(0, ex.Length - 13)));
        end;
      end;
    end;
  except end;
end;
//禁用玩法
procedure ManageDisablePlaying;
begin
  var S := '';
  if form_mainform.listbox_manage_import_mod.ItemIndex <> -1 then S := ModSelect[form_mainform.listbox_manage_import_mod.ItemIndex] else
  if form_mainform.listbox_manage_import_plugin.ItemIndex <> -1 then S := PluSelect[form_mainform.listbox_manage_import_plugin.ItemIndex] else begin
    MyMessagebox(GetLanguage('messagebox_manage.disable_playing_not_choose.caption'), GetLanguage('messagebox_manage.disable_playing_not_choose.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  if (RightStr(S, 13) = '.jar.diasbled') or (RightStr(S, 13) = '.zip.disabled') then begin
    MyMessagebox(GetLanguage('messagebox_manage.playing_already_disable.caption'), GetLanguage('messagebox_manage.playing_already_disable.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  RenameFile(S, Concat(S, '.disabled'));
  SelectPlayingDir();
end;
//启用玩法
procedure ManageEnablePlaying;
begin
  var S := '';
  if form_mainform.listbox_manage_import_mod.ItemIndex <> -1 then S := ModSelect[form_mainform.listbox_manage_import_mod.ItemIndex] else
  if form_mainform.listbox_manage_import_plugin.ItemIndex <> -1 then S := PluSelect[form_mainform.listbox_manage_import_plugin.ItemIndex] else begin
    MyMessagebox(GetLanguage('messagebox_manage.enable_playing_not_choose.caption'), GetLanguage('messagebox_manage.enable_playing_not_choose.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  if (RightStr(S, 4) = '.jar') or (RightStr(S, 4) = '.zip') then begin
    MyMessagebox(GetLanguage('messagebox_manage.playing_already_enable.caption'), GetLanguage('messagebox_manage.playing_already_enable.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  RenameFile(S, S.Substring(0, S.LastIndexOf('.')));
  SelectPlayingDir();
end;
procedure ClearDatSelect;
begin
  DatSelect.Clear;
end;
//删除玩法
procedure ManageDeletePlaying;
begin
  var S := '';
  if form_mainform.listbox_manage_import_datapack.ItemIndex <> -1 then S := DatSelect[form_mainform.listbox_manage_import_datapack.ItemIndex]
  else if form_mainform.listbox_manage_import_mod.ItemIndex <> -1 then S := ModSelect[form_mainform.listbox_manage_import_mod.ItemIndex]
  else if form_mainform.listbox_manage_import_map.ItemIndex <> -1 then S := SavSelect[form_mainform.listbox_manage_import_map.ItemIndex]
  else if form_mainform.listbox_manage_import_resourcepack.ItemIndex <> -1 then S := ResSelect[form_mainform.listbox_manage_import_resourcepack.ItemIndex]
  else if form_mainform.listbox_manage_import_shader.ItemIndex <> -1 then S := ShaSelect[form_mainform.listbox_manage_import_shader.ItemIndex]
  else if form_mainform.listbox_manage_import_plugin.ItemIndex <> -1 then S := PluSelect[form_mainform.listbox_manage_import_plugin.ItemIndex]
  else begin
    MyMessagebox(GetLanguage('messagebox_manage.delete_playing_not_choose.caption'), GetLanguage('messagebox_manage.delete_playing_not_choose.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  if MyMessagebox(GetLanguage('messagebox_manage.playing_is_delete.caption'), GetLanguage('messagebox_manage.playing_is_delete.text'), MY_INFORMATION, [mybutton.myNo, mybutton.myYes]) = 1 then exit;
  RecycleFile(S);
  SelectPlayingDir;
end;
//重命名玩法
procedure ManageRenamePlaying;
begin
  var S := '';
  if form_mainform.listbox_manage_import_datapack.ItemIndex <> -1 then S := DatSelect[form_mainform.listbox_manage_import_datapack.ItemIndex]
  else if form_mainform.listbox_manage_import_mod.ItemIndex <> -1 then S := ModSelect[form_mainform.listbox_manage_import_mod.ItemIndex]
  else if form_mainform.listbox_manage_import_map.ItemIndex <> -1 then S := SavSelect[form_mainform.listbox_manage_import_map.ItemIndex]
  else if form_mainform.listbox_manage_import_resourcepack.ItemIndex <> -1 then S := ResSelect[form_mainform.listbox_manage_import_resourcepack.ItemIndex]
  else if form_mainform.listbox_manage_import_shader.ItemIndex <> -1 then S := ShaSelect[form_mainform.listbox_manage_import_shader.ItemIndex]
  else if form_mainform.listbox_manage_import_plugin.ItemIndex <> -1 then S := PluSelect[form_mainform.listbox_manage_import_plugin.ItemIndex]
  else begin
    MyMessagebox(GetLanguage('messagebox_manage.rename_playing_not_choose.caption'), GetLanguage('messagebox_manage.rename_playing_not_choose.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  var rs := MyInputBox(GetLanguage('inputbox_manage.rename_new_name.caption'), GetLanguage('inputbox_manage.rename_new_name.text'), MY_INFORMATION);
  if rs = '' then exit;
  if (form_mainform.listbox_manage_import_map.ItemIndex <> -1) and (form_mainform.listbox_manage_import_datapack.ItemIndex = -1) then begin
    var C := Concat(ExtractFilePath(S), rs);
    RenDirectory(S, C);
  end else begin
    if RightStr(S, 9) = '.disabled' then begin
      var nod := ChangeFileExt(S, '');
      var osuf := nod.Substring(nod.LastIndexOf('.'));
      var ald := Concat(ExtractFilePath(S), rs, osuf, '.disabled');
      RenameFile(S, ald);
    end else begin
      var osuf := S.Substring(S.LastIndexOf('.'));
      var ald := Concat(ExtractFilePath(S), rs, osuf);
      RenameFile(S, ald);
    end;
  end;
  SelectPlayingDir;
end;
//打开文件夹
procedure ManageOpenPlaying;
begin
  var S := '';
  if form_mainform.listbox_manage_import_datapack.ItemIndex <> -1 then S := Concat(SavSelect[form_mainform.listbox_manage_import_map.ItemIndex], '\datapacks')
  else if form_mainform.listbox_manage_import_mod.ItemIndex <> -1 then S := Concat(mcrlpth, '\mods')
  else if form_mainform.listbox_manage_import_map.ItemIndex <> -1 then S := Concat(mcrlpth, '\saves')
  else if form_mainform.listbox_manage_import_resourcepack.ItemIndex <> -1 then S := Concat(mcrlpth, '\resourcepacks')
  else if form_mainform.listbox_manage_import_shader.ItemIndex <> -1 then S := Concat(mcrlpth, '\shaderpacks')
  else if form_mainform.listbox_manage_import_plugin.ItemIndex <> -1 then S := Concat(mcrlpth, '\plugins')
  else begin
    MyMessagebox(GetLanguage('messagebox_manage.open_no_choose_playing.caption'), GetLanguage('messagebox_manage.open_no_choose_playing.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  if not DirectoryExists(S) then ForceDirectories(S);
  ShellExecute(Application.Handle, 'open', 'explorer.exe', pchar(S), nil, SW_SHOWNORMAL);
end;
//拖动到窗口的方法
procedure DragFileInWindow(var Msg: TMessage);
var
  P: array[0..255] of Char;
  i: Word;
  d: TArray<String>;
begin
  i := DragQueryFile(Msg.WParam, $FFFFFFFF, nil, 0);
  var cc: TPoint;
  DragQueryPoint(Msg.WParam, cc);
  var lmod: TPoint;
  lmod.X := 0;
  lmod.Y := 0;
  lmod := form_mainform.listbox_manage_import_mod.ClientToScreen(lmod);
  lmod := form_mainform.ScreenToClient(lmod);
  var lmap: TPoint;
  lmap.X := 0;
  lmap.Y := 0;
  lmap := form_mainform.listbox_manage_import_map.ClientToScreen(lmap);
  lmap := form_mainform.ScreenToClient(lmap);
  var lres: TPoint;
  lres.X := 0;
  lres.Y := 0;
  lres := form_mainform.listbox_manage_import_resourcepack.ClientToScreen(lres);
  lres := form_mainform.ScreenToClient(lres);
  var lsha: TPoint;
  lsha.X := 0;
  lsha.Y := 0;
  lsha := form_mainform.listbox_manage_import_shader.ClientToScreen(lsha);
  lsha := form_mainform.ScreenToClient(lsha);
  var ldat: TPoint;
  ldat.X := 0;
  ldat.Y := 0;
  ldat := form_mainform.listbox_manage_import_datapack.ClientToScreen(ldat);
  ldat := form_mainform.ScreenToClient(ldat);
  var lplu: TPoint;
  lplu.X := 0;
  lplu.Y := 0;
  lplu := form_mainform.listbox_manage_import_plugin.ClientToScreen(lplu);
  lplu := form_mainform.ScreenToClient(lplu);
  var lpak: TPoint;
  lpak.X := 0;
  lpak.Y := 0;
  lpak := form_mainform.listbox_manage_import_modpack.ClientToScreen(lpak);
  lpak := form_mainform.ScreenToClient(lpak);
  var ic := 0;
  //模组
  if (cc.Y > lmod.Y) and
  (cc.Y < lmod.Y + form_mainform.listbox_manage_import_mod.Height) and
  (cc.X > lmod.X) and
  (cc.X < lmod.X + form_mainform.listbox_manage_import_mod.Width) then begin
    for var j := 0 to i - 1 do begin
      DragQueryFile(Msg.WParam, j, @P, sizeof(P));
      var ne := StrPas(P);
      if (RightStr(ExtractFileName(ne), 4) = '.jar') or (RightStr(ExtractFileName(ne), 4) = '.zip') then begin
        if MyMessagebox(GetLanguage('messagebox_manage.drag_file_mod.caption'), GetLanguage('messagebox_manage.drag_file_mod.text').Replace('${drag_file_name}', ExtractFileName(ne)), MY_INFORMATION, [mybutton.myNo, mybutton.myYes]) = 1 then continue;
        var dire := Concat(mcrlpth, '\mods');
        if not DirectoryExists(dire) then ForceDirectories(dire);
        d := TDirectory.GetFiles(dire);
        var boo := False;
        for var k in d do begin
          if ExtractFileName(k) = ExtractFileName(ne) then begin
            if MyMessagebox(GetLanguage('messagebox_manage.drag_mod_repeat.caption'), GetLanguage('messagebox_manage.drag_mod_repeat.text').Replace('${drag_file_name}', ExtractFileName(ne)), MY_INFORMATION, [mybutton.myNo, mybutton.myYes]) = 1 then boo := true;
            break;
          end;
        end;
        if boo then continue;
        CopyFile(pchar(ne), pchar(Concat(dire, '\', ExtractFileName(ne))), false);
        inc(ic);
      end else begin
        MyMessagebox(GetLanguage('messagebox_manage.drag_mod_format_error.caption'), GetLanguage('messagebox_manage.drag_mod_format_error.text').Replace('${drag_file_name}', ExtractFileName(ne)), MY_ERROR, [mybutton.myOK]);
      end;
    end;
  //地图
  end else if (cc.Y > lmap.Y) and
  (cc.Y < lmap.Y + form_mainform.listbox_manage_import_map.Height) and
  (cc.X > lmap.X) and
  (cc.X < lmap.X + form_mainform.listbox_manage_import_map.Width) then begin
    for var j := 0 to i - 1 do begin
      DragQueryFile(Msg.WParam, j, @P, sizeof(P));
      var ne := StrPas(P);
      if (RightStr(ne, 4) = '.zip') then begin
        if MyMessagebox(GetLanguage('messagebox_manage.drag_map_zip.caption'), GetLanguage('messagebox_manage.drag_map_zip.text').Replace('${drag_file_name}', ExtractFileName(ne)), MY_INFORMATION, [mybutton.myNO, mybutton.myYes]) = 1 then continue;
        var dire := Concat(mcrlpth, '\saves');
        if not DirectoryExists(dire) then ForceDirectories(dire);
        d := TDirectory.GetDirectories(dire);
        var boo := false;
        for var k in d do begin
          if ExtractFileName(k) = ChangeFileExt(ExtractFileName(ne), '') then begin
            if MyMessagebox(GetLanguage('messagebox_manage.drag_map_zip_repeat.caption'), GetLanguage('messagebox_manage.drag_map_zip_repeat.text').Replace('${drag_file_name}', ExtractFileName(ne)), MY_INFORMATION, [mybutton.myNO, mybutton.myYes]) = 1 then boo := true else
            DeleteDirectory(k);
            break;
          end;
        end;
        if boo then continue;
        if not Unzip(ne, Concat(dire, '\', ChangeFileExt(ExtractFileName(ne), ''))) then begin
          MyMessagebox(GetLanguage('messagebox_manage.drag_map_unzip_error.caption'), GetLanguage('messagebox_manage.drag_map_unzip_error.text').Replace('${drag_file_name}', ExtractFileName(ne)), MY_ERROR, [mybutton.myOK]);
          continue;
        end;
        inc(ic);
      end else if (DirectoryExists(ne)) then begin
        if MyMessagebox(GetLanguage('messagebox_manage.drag_map_dir.caption'), GetLanguage('messagebox_manage.drag_map_dir.text').Replace('${drag_file_name}', ExtractFileName(ne)), MY_INFORMATION, [mybutton.myNO, mybutton.myYes]) = 1 then continue;
        var dire := Concat(mcrlpth, '\saves');
        if not DirectoryExists(dire) then ForceDirectories(dire);
        d := TDirectory.GetDirectories(dire);
        var boo := false;
        for var k in d do begin
          if ExtractFileName(k) = ChangeFileExt(ExtractFileName(ne), '') then begin
            if MyMessagebox(GetLanguage('messagebox_manage.drag_map_dir_repeat.caption'), GetLanguage('messagebox_manage.drag_map_dir_repeat.text').Replace('${drag_file_name}', ExtractFileName(ne)), MY_INFORMATION, [mybutton.myNO, mybutton.myYes]) = 1 then boo := true;
            DeleteDirectory(k);
            break;
          end;
        end;
        if boo then continue;
        if not DirectoryExists(Concat(dire, '\', ExtractFileName(ne))) then ForceDirectories(Concat(dire, '\', ExtractFileName(ne)));
        CopyDir(ne, Concat(dire, '\', ExtractFileName(ne)));
        inc(ic);
      end else begin
        MyMessagebox(GetLanguage('messagebox_manage.drag_map_format_error.caption'), GetLanguage('messagebox_manage.drag_map_format_error.text').Replace('${drag_file_name}', ExtractFileName(ne)), MY_ERROR, [mybutton.myOK]);
      end;
    end;
  //纹理
  end else if (cc.Y > lres.Y) and
  (cc.Y < lres.Y + form_mainform.listbox_manage_import_resourcepack.Height) and
  (cc.X > lres.X) and
  (cc.X < lres.X + form_mainform.listbox_manage_import_resourcepack.Width) then begin
    for var j := 0 to i - 1 do begin
      DragQueryFile(Msg.WParam, j, @P, sizeof(P));
      var ne := StrPas(P);
      if RightStr(ne, 4) = '.zip' then begin
        if MyMessagebox(GetLanguage('messagebox_manage.drag_resourcepack.caption'), GetLanguage('messagebox_manage.drag_resourcepack.text').Replace('${drag_file_name}', ExtractFileName(ne)), MY_INFORMATION, [mybutton.myNo, mybutton.myYes]) = 1 then continue;
        var dire := Concat(mcrlpth, '\resourcepacks');
        if not DirectoryExists(dire) then ForceDirectories(dire);
        d := TDirectory.GetFiles(dire);
        var boo := false;
        for var k in d do begin
          if ExtractFileName(k) = ExtractFileName(ne) then begin
            if MyMessagebox(GetLanguage('messagebox_manage.drag_resourcepack_repeat.caption'), GetLanguage('messagebox_manage.drag_resourcepack_repeat.text').Replace('${drag_file_name}', ExtractFileName(ne)), MY_INFORMATION, [mybutton.myNo, mybutton.myYes]) = 1 then boo := true;
            break;
          end;
        end;
        if boo then continue;
        CopyFile(pchar(ne), pchar(Concat(dire, '\', ExtractFileName(ne))), False);
        inc(ic);
      end else begin
        MyMessagebox(GetLanguage('messagebox_manage.drag_resourcepack_format_error.caption'), GetLanguage('messagebox_manage.drag_resourcepack_format_error.text').Replace('${drag_file_name}', ExtractFileName(ne)), MY_ERROR, [mybutton.myOK]);
      end;
    end;
  //光影
  end else if (cc.Y > lsha.Y) and
  (cc.Y < lsha.Y + form_mainform.listbox_manage_import_shader.Height) and
  (cc.X > lsha.X) and
  (cc.X < lsha.X + form_mainform.listbox_manage_import_shader.Width) then begin
    for var j := 0 to i - 1 do begin
      DragQueryFile(Msg.WParam, j, @P, sizeof(P));
      var ne := StrPas(P);
      if RightStr(ne, 4) = '.zip' then begin
        if MyMessagebox(GetLanguage('messagebox_manage.drag_shader.caption'), GetLanguage('messagebox_manage.drag_shader.text').Replace('${drag_file_name}', ExtractFileName(ne)), MY_INFORMATION, [mybutton.myNo, mybutton.myYes]) = 1 then continue;
        var dire := Concat(mcrlpth, '\shaderpacks');
        if not DirectoryExists(dire) then ForceDirectories(dire);
        d := TDirectory.GetFiles(dire);
        var boo := false;
        for var k in d do begin
          if ExtractFileName(k) = ExtractFileName(ne) then begin
            if MyMessagebox(GetLanguage('messagebox_manage.drag_shader_repeat.caption'), GetLanguage('messagebox_manage.drag_shader_repeat.text').Replace('${drag_file_name}', ExtractFileName(ne)), MY_INFORMATION, [mybutton.myNo, mybutton.myYes]) = 1 then boo := true;
            break;
          end;
        end;
        if boo then continue;
        CopyFile(pchar(ne), pchar(Concat(dire, '\', ExtractFileName(ne))), False);
        inc(ic);
      end else begin
        MyMessagebox(GetLanguage('messagebox_manage.drag_shader_format_error.caption'), GetLanguage('messagebox_manage.drag_shader_format_error.text').Replace('${drag_file_name}', ExtractFileName(ne)), MY_ERROR, [mybutton.myOK]);
      end;
    end;
  //数据包
  end else if (cc.Y > ldat.Y) and
  (cc.Y < ldat.Y + form_mainform.listbox_manage_import_datapack.Height) and
  (cc.X > ldat.X) and
  (cc.X < ldat.X + form_mainform.listbox_manage_import_datapack.Width) then begin
    if form_mainform.listbox_manage_import_map.ItemIndex = -1 then begin
      MyMessagebox(GetLanguage('messagebox_manage.drag_datapack_no_choose_map_error.caption'), GetLanguage('messagebox_manage.drag_datapack_no_choose_map_error.text'), MY_ERROR, [mybutton.myOK]);
      exit;
    end;
    for var j := 0 to i - 1 do begin
      DragQueryFile(Msg.WParam, j, @P, sizeof(P));
      var ne := StrPas(P);
      if (RightStr(ne, 4) = '.zip') then begin
        if MyMessagebox(GetLanguage('messagebox_manage.drag_datapack.caption'), GetLanguage('messagebox_manage.drag_datapack.text').Replace('${drag_file_name}', ExtractFileName(ne)), MY_INFORMATION, [mybutton.myNo, mybutton.myYes]) = 1 then continue;
        var dire := Concat(SavSelect[form_mainform.listbox_manage_import_map.ItemIndex], '\datapacks');
        if not DirectoryExists(dire) then ForceDirectories(dire);
        d := TDirectory.GetFiles(dire);
        var boo := false;
        for var k in d do begin
          if ExtractFileName(k) = ExtractFileName(ne) then begin
            if MyMessagebox(GetLanguage('messagebox_manage.drag_datapack_repeat.caption'), GetLanguage('messagebox_manage.drag_datapack_repeat.text').Replace('${drag_file_name}', ExtractFileName(ne)), MY_INFORMATION, [mybutton.myNo, mybutton.myYes]) = 1 then boo := true;
            break;
          end;
        end;
        if boo then continue;
        CopyFile(pchar(ne), pchar(Concat(dire, '\', ExtractFileName(ne))), False);
        inc(ic);
      end else begin
        MyMessagebox(GetLanguage('messagebox_manage.drag_shader_format_error.caption'), GetLanguage('messagebox_manage.drag_shader_format_error.text').Replace('${drag_file_name}', ExtractFileName(ne)), MY_ERROR, [mybutton.myOK]);
      end;
    end;
  //插件
  end else if (cc.Y > lplu.Y) and
  (cc.Y < lplu.Y + form_mainform.listbox_manage_import_plugin.Height) and
  (cc.X > lplu.X) and
  (cc.X < lplu.X + form_mainform.listbox_manage_import_plugin.Width) then begin
    for var j := 0 to i - 1 do begin
      DragQueryFile(Msg.WParam, j, @P, sizeof(P));
      var ne := StrPas(P);
      if (RightStr(ne, 4) = '.jar') or (RightStr(ne, 4) = '.zip') then begin
        if MyMessagebox(GetLanguage('messagebox_manage.drag_plugin.caption'), GetLanguage('messagebox_manage.drag_plugin.text').Replace('${drag_file_name}', ExtractFileName(ne)), MY_INFORMATION, [mybutton.myNo, mybutton.myYes]) = 1 then continue;
        var dire := Concat(mcrlpth, '\plugins');
        if not DirectoryExists(dire) then ForceDirectories(dire);
        d := TDirectory.GetFiles(dire);
        var boo := false;
        for var k in d do begin
          if ExtractFileName(k) = ExtractFileName(ne) then begin
            if MyMessagebox(GetLanguage('messagebox_manage.drag_plugin_repeat.caption'), GetLanguage('messagebox_manage.drag_plugin_repeat.text').Replace('${drag_file_name}', ExtractFileName(ne)), MY_INFORMATION, [mybutton.myNo, mybutton.myYes]) = 1 then boo := true;
            break;
          end;
        end;
        if boo then continue;
        CopyFile(pchar(ne), pchar(Concat(dire, '\', ExtractFileName(ne))), False);
        inc(ic);
      end else begin
        MyMessagebox(GetLanguage('messagebox_manage.drag_plugin_format_error.caption'), GetLanguage('messagebox_manage.drag_plugin_format_error.text').Replace('${drag_file_name}', ExtractFileName(ne)), MY_ERROR, [mybutton.myOK]);
      end;
    end;
  //整合包
  end else if (cc.Y > lpak.Y) and
  (cc.Y < lpak.Y + form_mainform.listbox_manage_import_modpack.Height) and
  (cc.X > lpak.X) and
  (cc.X < lpak.X + form_mainform.listbox_manage_import_modpack.Width) then begin
    if i > 1 then begin
      MyMessagebox(GetLanguage('messagebox_manage.drag_modpack_only_one_file.caption'), GetLanguage('messagebox_manage.drag_modpack_only_one_file.text'), MY_ERROR, [mybutton.myOK]);
    end;
    DragQueryFile(Msg.WParam, 0, @P, sizeof(P));
    var ne := strpas(p);
    if (RightStr(ne, 7) = '.mrpack') or (RightStr(ne, 4) = '.zip') then begin
      ImportModPack(ne);
    end else begin
      MyMessagebox(GetLanguage('messagebox_manage.drag_modpack_format_error.caption'), GetLanguage('messagebox_manage.drag_modpack_format_error.text').Replace('${drag_file_name}', ExtractFileName(ne)), MY_ERROR, [mybutton.myOK]);
    end;
  end;
  SelectPlayingDir;
  if ic > 0 then MyMessagebox(GetLanguage('messagebox_manage.drag_file_finish.caption'), GetLanguage('messagebox_manage.drag_file_finish.text'), MY_PASS, [mybutton.myOK]);
end;
//点击地图列表框事件
procedure ManageChangeMap;
var
  dpk: TArray<String>;
begin
  DatSelect.Clear;
  try
    dpk := TDirectory.GetFiles(Concat(SavSelect[form_mainform.listbox_manage_import_map.ItemIndex], '\datapacks\'));
    for var I in dpk do begin
      if RightStr(I, 4) = '.zip' then begin
        DatSelect.Add(I);
        form_mainform.listbox_manage_import_datapack.Items.Add(ChangeFileExt(ExtractFileName(I), ''));
      end;
    end;
  except end;
end;
//初始化玩法管理界面方法
var f: Boolean = false;
function InitManage: Boolean;
var
  p: array [0..255] of char;
begin
  result := true;
  GetTempPath(255, @p);
  temp := strpas(p);
  if f then begin
    try
      mcrlpth := JudgeIsolation;
    except
      result := false;
      exit;
    end;
    SelectPlayingDir;
  end else begin
    ModSelect := TStringList.Create;
    SavSelect := TStringList.Create;
    ResSelect := TStringList.Create;
    ShaSelect := TStringList.Create;
    DatSelect := TStringList.Create;
    PluSelect := TStringList.Create;
    try
      mcrlpth := JudgeIsolation;
//      mcrlpth := 'D:\testdir';
    except
      result := false;
      exit;
    end;
    f := true;
    SelectPlayingDir;
  end;
end;

end.
