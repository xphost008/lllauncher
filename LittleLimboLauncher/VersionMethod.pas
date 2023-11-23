unit VersionMethod;

interface

uses
  SysUtils, Windows, Forms, Classes, JSON, IOUtils, IniFiles, ShellAPI;

procedure InitVersion;
procedure SaveVersion;
procedure ChooseVersionDir(name, path: String);
procedure SelVer();
procedure CompleteVersion;

var
  mselect_mc, mselect_ver, misolation_mode: Integer;
  MCVersionList, MCVersionName, MCVersionSelect: TStringList;
  MCJSON, MCSelJSON: TJSONObject;

implementation

uses
  MainMethod, MainForm, LanguageMethod, LauncherMethod, MyCustomWindow;

//选择版本
procedure SelVer();
var
  Dir: TArray<String>;
begin
  form_mainform.combobox_select_game_version.Items.Clear;
  MCVersionSelect.Clear;
  MCSelJSON.RemovePair('mcsel');
  MCSelJson.AddPair('mcsel', TJsonArray.Create);
  try
    var path := MCVersionList[mselect_mc];
    form_mainform.label_version_current_path.Caption := GetLanguage('label_version_current_path.caption').Replace('${current_path}', path);
//    form_mainform.label_version_current_path.Caption := GetLanguage('label_version_current_path.caption').Replace('${current_path}', path);
    var ver := Concat(path, '\versions');
    if DirectoryExists(ver) then begin
      Dir := TDirectory.GetDirectories(ver);
      for var T in Dir do begin
        var ccf := ExtractFileName(T);
        if IsVersionError(T) then ccf := Concat(ccf, GetLanguage('button_launch_game.caption.error.cannot_find_json'))
        else if GetMCInheritsFrom(T, 'inheritsFrom') = '' then ccf := Concat(ccf, GetLanguage('button_launch_game.caption.error.missing_inherits_version'));
        var IsoIni := TIniFile.Create(Concat(T, '\LLLauncher.ini'));
        if IsoIni.ReadBool('Isolation', 'IsIsolation', false) then ccf := Concat(ccf, GetLanguage('button_launch_game.caption.isolation'));
        var isf: String;
        try
          var jso := GetFile(GetMCRealPath(T, '.json')).ToLower;
          var jsn := TJsonObject.ParseJSONValue(jso) as TJsonObject;
          var iin := jsn.GetValue('id').Value;
          if iin.Contains('forge') then isf := '（Forge）'
          else if iin.Contains('fabric') then isf := '（Fabric）'
          else if iin.Contains('quilt') then isf := '（Quilt）'
          else if iin.Contains('neoforge') then isf := '（NeoForge）'
          else if iin.Contains('liteloader') then isf := '（LiteLoader）';
          jsn.GetValue('libraries').ToString;
          if GetMCInheritsFrom(T, 'inheritsFrom') = '' then raise Exception.Create('Has no inheritsFrom');
          if jso.IndexOf('com.mumfrey:liteloader:') <> -1 then isf := '（Liteloader）'
          else if jso.IndexOf('org.quiltmc:quilt-loader:') <> -1 then isf := '（Quilt）'
          else if jso.IndexOf('net.fabricmc:fabric-loader:') <> -1 then isf := '（Fabric）'
          else if jso.IndexOf('net.neoforged') <> -1 then isf := '（NeoForged）'
          else if jso.IndexOf('net.minecraftforge') <> -1 then isf := '（Forge）'
          else isf := '（Vanilla）';
        except
          isf := '（Unknown）';
        end;
        ccf := Concat(isf, ccf);
        MCVersionSelect.Add(T);
        (MCSelJSON.GetValue('mcsel') as TJSONArray).Add(TJSONObject.Create.AddPair('name', ExtractFileName(T)).AddPair('path', T));
        form_mainform.combobox_select_game_version.Items.Add(ccf);
      end;
//      var te := MCVersionSelect[mselect_ver];
      form_mainform.combobox_select_game_version.ItemIndex := mselect_ver;
      LLLini.WriteString('MC', 'SelectMC', inttostr(mselect_mc + 1));
      LLLini.WriteString('MC', 'SelectVer', inttostr(mselect_ver + 1));
    end;
  except end;
end;
//手动补全类库
procedure CompleteVersion;
begin
  //TODO: 补全类库
end;
//选择版本文件夹方法
procedure ChooseVersionDir(name, path: String);
begin
  MCVersionList.Add(path);
  MCVersionName.Add(name);
  ((MCJson.GetValue('mc') as TJsonArray).Add(TJsonObject.Create
    .AddPair('name', name) //添加Json元素
    .AddPair('path', path)
  ));
  form_mainform.combobox_select_file_list.ItemIndex := form_mainform.combobox_select_file_list.Items.Add(name);
  mselect_mc := form_mainform.combobox_select_file_list.ItemIndex + 1;
  mselect_ver := -1;
  SelVer;
  MyMessagebox(GetLanguage('messagebox_version.select_mc_success.caption'), GetLanguage('messagebox_version.select_mc_success.text'), MY_PASS, [mybutton.myOK]);
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
    LLLini.WriteInteger('MC', 'SelectMC', 0); //如果没有，则赋值重新写入文件
    form_mainform.combobox_select_file_list.ItemIndex := -1;
    form_mainform.label_version_current_path.Caption := GetLanguage('label_version_current_path.caption').Replace('${current_path}', '');
    mselect_mc := -1;
  end;
  try //添加版本选择，并判断游戏Version文件的规范性，如果规范，则正常输出。
//    for var I in (MCSelJson.GetValue('mcsel') as TJsonArray) do //遍历Json数组
//    begin//直接添加所有name
//      var C := I.GetValue<String>('name');
//      var T := I.GetValue<String>('path');
//      if IsVersionError(T) then begin //判断版本是否错误，如果错误，则添加为错误版本。
//        C := Concat(C, '（错误，未找到Json）');
//      end else if lch.GetMCInheritsFrom(T, 'inheritsFrom') = '' then begin //判断inheritsForm键，如果有误，则出现无法找到前置版本。
//        C := Concat(C, '（错误，缺少前置版本）');
//      end;
//      var IlnIni := TIniFile.Create(Concat(T, '\LLLauncher.ini'));
//      if IlnIni.ReadString('Isolation', 'IsIsolation', '') = 'True' then C := Concat(C, '（独立）');
//      ComboBox1.Items.Add(C);
//      MCVersionSelect.Add(I.GetValue<String>('path'));
//    end;
    mselect_ver := LLLini.ReadInteger('MC', 'SelectVer', -1) - 1;
    if (mselect_ver < 0) and not (mselect_ver >= (MCSelJson.GetValue('mcsel') as TJsonArray).Count) then  //如果账号不为空，
      raise Exception.Create('Format Exception');
  except
    LLLini.WriteInteger('MC', 'SelectVer', 0); //如果没有，则赋值重新写入文件
    mselect_ver := -1;
  end;
  try
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
    form_mainform.button_launch_game.Caption := GetLanguage('button_launch_game.caption').Replace('${launch_version_name}', form_mainform.combobox_select_game_version.Items[form_mainform.combobox_select_game_version.ItemIndex]);
  end else begin
    form_mainform.button_launch_game.Caption := GetLanguage('button_launch_game.caption.absence');
  end;
  SetFile(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\MCJson.json'), MCJson.Format);
  SetFile(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\MCSelJson.json'), MCSelJson.Format);
  LLLini.WriteString('MC', 'SelectMC', inttostr(mselect_mc + 1));
  LLLini.WriteString('MC', 'SelectVer', inttostr(mselect_ver + 1));
  LLLini.WriteString('Version', 'SelectIsolation', inttostr(misolation_mode));
end;

end.
