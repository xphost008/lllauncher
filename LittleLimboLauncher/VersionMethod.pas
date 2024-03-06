unit VersionMethod;

interface

uses
  SysUtils, Windows, Forms, Classes, JSON, IOUtils, IniFiles, ShellAPI;

procedure InitVersion;
procedure SaveVersion;
procedure ChooseVersionDir(name, path: String; isShow: Boolean);
procedure SelVer();
procedure CompleteVersion;

var
  mselect_mc, mselect_ver, misolation_mode: Integer;
  MCVersionList, MCVersionName, MCVersionSelect: TStringList;
  MCJSON, MCSelJSON: TJSONObject;

implementation

uses
  MainMethod, MainForm, LanguageMethod, LauncherMethod, MyCustomWindow, ProgressMethod;

//选择版本
procedure SelVer();
begin
  form_mainform.combobox_select_game_version.Items.Clear;
  MCVersionSelect.Clear;
  MCSelJSON.RemovePair('mcsel');
  MCSelJson.AddPair('mcsel', TJsonArray.Create);
  try
    var path := MCVersionList[mselect_mc];
    form_mainform.label_version_current_path.Caption := GetLanguage('label_version_current_path.caption').Replace('${current_path}', path);
    var ver := Concat(path, '\versions');
    if DirectoryExists(ver) then begin
      SearchDirProc(ver, true, true, procedure(T: String) begin
        var ccf := ExtractFileName(T);
        if IsVersionError(T) then ccf := Concat(ccf, GetLanguage('button_launch_game.caption.error.cannot_find_json'))
        else if GetMCInheritsFrom(T, 'inheritsFrom') = '' then ccf := Concat(ccf, GetLanguage('button_launch_game.caption.error.missing_inherits_version'));
        var IsoIni := TIniFile.Create(Concat(T, '\LLLauncher.ini'));
        if IsoIni.ReadBool('Isolation', 'IsIsolation', false) then ccf := Concat(ccf, GetLanguage('button_launch_game.caption.isolation'));
        var isf: String;
        try
          var jso := GetFile(GetMCRealPath(T, '.json')).ToLower;
          if GetMCInheritsFrom(T, 'inheritsFrom') = '' then raise Exception.Create('Has no inheritsFrom');
          (TJsonObject.ParseJSONValue(jso) as TJsonObject).GetValue('id').Value;
          if jso.IndexOf('com.mumfrey:liteloader:') <> -1 then isf := '（Liteloader）'
          else if jso.IndexOf('org.quiltmc:quilt-loader:') <> -1 then isf := '（Quilt）'
          else if jso.IndexOf('net.fabricmc:fabric-loader:') <> -1 then isf := '（Fabric）'
          else if jso.IndexOf('net.neoforged') <> -1 then isf := '（NeoForge）'
          else if jso.IndexOf('net.minecraftforge') <> -1 then isf := '（Forge）'
          else isf := '（Vanilla）';
        except
          isf := '（Unknown）';
        end;
        ccf := Concat(isf, ccf);
        MCVersionSelect.Add(T);
        (MCSelJSON.GetValue('mcsel') as TJSONArray).Add(TJSONObject.Create.AddPair('name', ExtractFileName(T)).AddPair('path', T));
        form_mainform.combobox_select_game_version.Items.Add(ccf);
      end);
      form_mainform.combobox_select_game_version.ItemIndex := mselect_ver;
      LLLini.WriteString('MC', 'SelectMC', inttostr(mselect_mc + 1));
      LLLini.WriteString('MC', 'SelectVer', inttostr(mselect_ver + 1));
    end;
  except end;
end;
//手动补全类库
procedure CompleteVersion;
begin
  if mselect_ver < 0 then begin
    MyMessagebox(GetLanguage('messagebox_version.no_ver_dir.caption'), GetLanguage('messagebox_version.no_ver_dir.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  var selpath := MCVersionSelect[mselect_ver];
  var mcpath := MCVersionList[mselect_mc];
  if IsJSONError(MCVersionSelect[mselect_ver]) then begin
    MyMessagebox(GetLanguage('messagebox_version.complete_no_json_found.caption'), GetLanguage('messagebox_version.complete_no_json_found.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  var yjson := GetFile(GetMCRealPath(selpath, '.json'));
  form_mainform.pagecontrol_mainpage.ActivePage := form_mainform.tabsheet_download_progress_part;
  TThread.CreateAnonymousThread(procedure begin
    form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.version.get_complete_version'));
    form_mainform.button_progress_clean_download_list.Enabled := false;
    DownloadStart(yjson, selpath, mcpath, mbiggest_thread, mdownload_source, 2);
    form_mainform.button_progress_clean_download_list.Enabled := true;
    form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.version.complete_version_success'));
    MyMessagebox(GetLanguage('messagebox_version.complete_version_success.caption'), GetLanguage('messagebox_version.complete_version_success.text'), MY_PASS, [mybutton.myYes]);
  end).Start;
end;
//选择版本文件夹方法
procedure ChooseVersionDir(name, path: String; isShow: Boolean);
begin
  MCVersionList.Add(path);
  MCVersionName.Add(name);
  ((MCJson.GetValue('mc') as TJsonArray).Add(TJsonObject.Create
    .AddPair('name', name) //添加Json元素
    .AddPair('path', path)
  ));
  form_mainform.combobox_select_file_list.ItemIndex := form_mainform.combobox_select_file_list.Items.Add(name);
  mselect_mc := form_mainform.combobox_select_file_list.ItemIndex;
  mselect_ver := -1;
  SelVer;
  if isshow then MyMessagebox(GetLanguage('messagebox_version.select_mc_success.caption'), GetLanguage('messagebox_version.select_mc_success.text'), MY_PASS, [mybutton.myOK]);
end;
//初始化版本部分
var f: Boolean = false;
procedure InitVersion;
begin
  if f then begin
    SelVer();
    exit;
  end;
  f := true;
  MCVersionList := TStringList.Create;
  MCVersionName := TStringList.Create;
  MCVersionSelect := TStringList.Create;
  MCJSON := TJSONObject.Create;
  MCSelJSON := TJSONObject.Create;
  //判断有无json文件，如果没有则执行
  if not FileExists(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\MCJson.json')) then begin //给Json变量初值附上一个JsonArray
    MCJson.AddPair('mc', TJsonArray.Create);
    var j := MCJson.Format;  //将Json格式化
    SetFile(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\MCJson.json'), j);//将字符串保存到外部json账号配置文件
  end else begin //如果有则执行
    var j := GetFile(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\MCJson.json')); //加载配置文件
    MCJson := TJsonObject.ParseJSONValue(j) as TJsonObject; //给Account附上初值。
  end;
  if not FileExists(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\MCSelJson.json')) then begin //给Json变量初值附上一个JsonArray
    MCSelJson.AddPair('mcsel', TJsonArray.Create);
    var j := MCSelJson.Format;  //将Json格式化
    SetFile(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\MCSelJson.json'), j);//将字符串保存到外部json账号配置文件
  end else begin //如果有则执行
    var j := GetFile(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\MCSelJson.json')); //加载配置文件
    MCSelJson := TJsonObject.ParseJSONValue(j) as TJsonObject; //给Account附上初值。
  end;
  try //添加文件列表，并判断游戏文件的规范性，如果规范，则正常输出。
    for var I in (MCJson.GetValue('mc') as TJsonArray) do begin //遍历Json数组
      form_mainform.combobox_select_file_list.Items.Add(I.GetValue<String>('name')); //直接添加所有name
      MCVersionList.Add(I.GetValue<String>('path'));
      MCversionName.Add(I.GetValue<String>('name'));
    end;
    mselect_mc := LLLini.ReadInteger('MC', 'SelectMC', -1) - 1;
    if not (mselect_mc < 0) and not (mselect_mc >= (MCJson.GetValue('mc') as TJsonArray).Count) then begin //如果MC不为空，
      form_mainform.combobox_select_file_list.ItemIndex := mselect_mc;  //当每次调用ItemIndex的时候，都会默认执行一次Change方法。
    end else raise Exception.Create('Format Exception');
    form_mainform.label_version_current_path.Caption := GetLanguage('label_version_current_path.caption').Replace('${current_path}', MCVersionList[mselect_mc]);
  except
    ChooseVersionDir(GetLanguage('combobox_version.current_directory.text'), Concat(ExtractFileDir(Application.ExeName), '\.minecraft'), false);
    ChooseVersionDir(GetLanguage('combobox_version.official_directory.text'), Concat(AppData, '\.minecraft'), false);
    LLLini.WriteInteger('MC', 'SelectMC', 1); //如果没有，则赋值重新写入文件
    form_mainform.combobox_select_file_list.ItemIndex := -0;
    form_mainform.label_version_current_path.Caption := GetLanguage('label_version_current_path.caption').Replace('${current_path}', '');
    mselect_mc := -0;
  end;
  try //添加版本选择，并判断游戏Version文件的规范性，如果规范，则正常输出。
    mselect_ver := LLLini.ReadInteger('MC', 'SelectVer', -1) - 1;
    if (mselect_ver < 0) and not (mselect_ver >= (MCSelJson.GetValue('mcsel') as TJsonArray).Count) then  //如果账号不为空，
      raise Exception.Create('Format Exception');
  except
    LLLini.WriteInteger('MC', 'SelectVer', 0); //如果没有，则赋值重新写入文件
    mselect_ver := -1;
  end;
  try //判断版本隔离（
    misolation_mode := LLLini.ReadInteger('Version', 'SelectIsolation', -1);
    if (misolation_mode < 1) or (misolation_mode > 4) then raise Exception.Create('No Isolation Choose');
    form_mainform.radiogroup_partition_version.ItemIndex := misolation_mode - 1;
  except
    misolation_mode := 4;
    LLLini.WriteInteger('Version', 'SelectIsolation', misolation_mode);
    form_mainform.radiogroup_partition_version.ItemIndex := misolation_mode - 1;
  end;
  SelVer;
end;
//保存版本部分
procedure SaveVersion;
begin
  if MCJSON = nil then exit;
  if form_mainform.combobox_select_file_list.Items[form_mainform.combobox_select_file_list.ItemIndex] = '' then begin
    mselect_mc := -1;
  end;
  if form_mainform.combobox_select_game_version.Items[form_mainform.combobox_select_game_version.ItemIndex] = '' then begin
    mselect_ver := -1;
    form_mainform.button_launch_game.Caption := GetLanguage('button_launch_game.caption.absence');
  end else begin
    form_mainform.button_launch_game.Caption := GetLanguage('button_launch_game.caption').Replace('${launch_version_name}', form_mainform.combobox_select_game_version.Items[form_mainform.combobox_select_game_version.ItemIndex]);
  end;
  SetFile(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\MCJson.json'), MCJson.Format);
  SetFile(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\MCSelJson.json'), MCSelJson.Format);
  LLLini.WriteString('MC', 'SelectMC', inttostr(mselect_mc + 1));
  LLLini.WriteString('MC', 'SelectVer', inttostr(mselect_ver + 1));
  LLLini.WriteString('Version', 'SelectIsolation', inttostr(misolation_mode));
end;

end.
