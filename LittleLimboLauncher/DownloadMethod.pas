unit DownloadMethod;

interface

uses
  IOUtils, Classes, SysUtils, Forms, Threading, JSON, Winapi.msxml, Windows,
  Winapi.ActiveX, ShellAPI, StrUtils;

procedure InitDownload;
procedure SaveDownload;     
procedure ResetDownload;
procedure CheckMode;         
procedure ChangeModLoader;
procedure ChangeDlSource;
//procedure SoluteLoaderXML(xml: String);
//procedure SoluteForgeJSON(json: String);
//procedure SoluteLoaderJSON(json: String);
procedure LoadModLoader;                        
procedure ViewMinecraftInfo();
procedure DownloadMinecraft;

implementation

uses
  MainForm, MyCustomWindow, LanguageMethod, MainMethod, LauncherMethod, ProgressMethod;

var
  webjson: String;
  mcwe, fabme, quime: String;
  urlsl, reltmr: TStringList;                         
  mrelease, msnapshot, mbeta, malpha, mlll: Boolean;
  mmod_loader: Integer;
  loaderJSON: TJSONArray;

function ReverseJSONArray(jsonArray: TJSONArray): TJSONArray;
begin
  var reversedArray := TJsonArray.Create;
  for var i := jsonArray.Count - 1 downto 0 do begin
    reversedArray.Add(jsonArray.Items[i] as TJsonObject);
  end;
  result := reversedArray;
end;
//解决MCJSON解析。
procedure SoluteMC;
begin
  form_mainform.listbox_select_minecraft.Items.Clear;
  urlsl.Clear;
  reltmr.Clear;
  if webjson = '' then begin
    form_mainform.listbox_select_minecraft.Items.Add(GetLanguage('listbox_select_minecraft.item.get_mc_error'));
    exit;
  end;
  var Rt := TJsonObject.ParseJSONValue(webjson) as TJsonObject;
  var JArr := (Rt.GetValue('versions') as TJsonArray); //获取versions下的所有元素
  form_mainform.listbox_select_minecraft.Items.BeginUpdate;
  for var I := 0 to JArr.Count - 1 do begin //以下皆为判断版本
    var JTmp := JArr[I].GetValue<String>('type');
    if mrelease and (JTmp = 'release')
    or msnapshot and (JTmp = 'snapshot')
    or mbeta and (JTmp = 'old_beta')
    or malpha and (JTmp = 'old_alpha')
    then begin
      form_mainform.listbox_select_minecraft.Items.Add(JArr[I].GetValue<String>('id'));
      urlsl.Add(JArr[I].GetValue<String>('url'));
      reltmr.Add(JArr[I].GetValue<String>('releaseTime'));
    end;
  end;
  form_mainform.listbox_select_minecraft.Items.EndUpdate;
end;
//解析XML
procedure SoluteLoaderXML(xml: String);
begin
  var xmldoc: IXMLDOMDocument2 := CoDOMDocument.Create;
  try
    form_mainform.listbox_select_modloader.Items.BeginUpdate;
    if xml <> '' then begin
      try
        xmldoc.loadXML(xml);
        var mtdt := xmldoc.selectSingleNode('metadata');
        for var I := 0 to mtdt.childNodes.length - 1 do begin
          var veri := mtdt.childNodes[I];
          if veri.nodeName = 'versioning' then begin
            for var J := 0 to veri.childNodes.length - 1 do begin
              var vers := veri.childNodes[J];
              if vers.nodeName = 'versions' then begin
                for var K := 0 to vers.childNodes.length - 1 do begin
                  var ver: String := vers.childNodes[K].text;
                  if ver.Substring(0, ver.IndexOf('-')) = form_mainform.listbox_select_minecraft.Items[form_mainform.listbox_select_minecraft.ItemIndex] then begin
                    form_mainform.listbox_select_modloader.Items.Add(ver);
                  end;
                end;
              end;
            end;
          end;
        end;
      except
        form_mainform.listbox_select_modloader.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
      end;
    end else begin
      form_mainform.listbox_select_modloader.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
    end;
    form_mainform.listbox_select_modloader.Items.EndUpdate;
  finally
    xmldoc := nil;
  end;
  if form_mainform.listbox_select_modloader.Items.Count = 0 then form_mainform.listbox_select_modloader.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
end;
//专门解决Forge的JSON
procedure SoluteForgeJSON(json: String);
begin
  try
    loaderJSON := TJSONObject.ParseJSONValue(json) as TJSONArray;
    for var I in loaderJSON do begin
      var J := I as TJsonObject;
      form_mainform.listbox_select_modloader.Items.Add(J.GetValue('version').Value);
    end;
    if form_mainform.listbox_select_modloader.Items.Count = 0 then form_mainform.listbox_select_modloader.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
  except
    form_mainform.listbox_select_modloader.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
  end;
end;
//专门解决别的模组加载器的JSON
procedure SoluteLoaderJSON(json: String);
begin
  try
    loaderJSON := TJsonArray.ParseJSONValue(json) as TJsonArray;
    for var I in loaderJSON do begin
      var J := I as TJsonObject;
      form_mainform.listbox_select_modloader.Items.Add((J.GetValue('loader') as TJsonObject).GetValue('version').Value);
    end;
    if form_mainform.listbox_select_modloader.Items.Count = 0 then form_mainform.listbox_select_modloader.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
  except
    form_mainform.listbox_select_modloader.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
  end;
end;
//解决NeoForge的XML解析
procedure SoluteNeoXML(xml, midver: String);
var
  xmldoc: IXMLDOMDocument2;
begin
  xmldoc := CoDOMDocument.Create;
  try
    form_mainform.listbox_select_modloader.Items.BeginUpdate;
    if xml <> '' then begin
      try
        xmldoc.loadXML(xml);
        var mtdt := xmldoc.selectSingleNode('metadata');
        for var I := 0 to mtdt.childNodes.length - 1 do begin
          var veri := mtdt.childNodes[I];
          if veri.nodeName = 'versioning' then begin
            for var J := 0 to veri.childNodes.length - 1 do begin
              var vers := veri.childNodes[J];
              if vers.nodeName = 'versions' then begin
                for var K := vers.childNodes.length - 1 downto 0 do begin
                  var ver: String := vers.childNodes[K].text;
                  var tmp := SplitString(ver, '.');
                  var nver := tmp[0] + '.' + tmp[1];
                  if midver = nver then begin
                    form_mainform.listbox_select_modloader.Items.Add(ver);
                  end;
                end;
              end;
            end;
          end;
        end;
      except
        form_mainform.listbox_select_modloader.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
      end;
    end else begin
      form_mainform.listbox_select_modloader.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
    end;
    form_mainform.listbox_select_modloader.Items.EndUpdate;
  finally
    xmldoc := nil;
  end;
  if form_mainform.listbox_select_modloader.Items.Count = 0 then form_mainform.listbox_select_modloader.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
end;
//开始下载Minecraft！！
procedure DownloadMinecraft;
var
  Jurl, mcname: String;
  mcs: Integer;
  mcsp: TJSONObject;
begin
  if form_mainform.listbox_select_minecraft.ItemIndex = -1 then begin
    MyMessagebox(GetLanguage('messagebox_download.not_choose_download.caption'), GetLanguage('messagebox_download.not_choose_download.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  var mcvname := form_mainform.listbox_select_minecraft.Items[form_mainform.listbox_select_minecraft.ItemIndex];
  mcname := form_mainform.edit_minecraft_version_name.Text;
  if mcname = '' then begin
    MyMessagebox(GetLanguage('messagebox_download.name_is_empty.caption'), GetLanguage('messagebox_download.name_is_empty.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  mcs := LLLini.ReadInteger('MC', 'SelectMC', -1);
//  try
//    mcsp := (((TJsonObject.ParseJSONValue(GetFile(Concat(ExtractFilePath(Application.ExeName), 'LLLauncher\configs\MCJson.json'))) as TJsonObject).GetValue('mc') as TJsonArray)[mcs] as TJsonObject);
//    mcsp.ToString;
//  except
//    MyMessagebox(GetLanguage('messagebox_download.get_mc_dir_error.caption'), GetLanguage('messagebox_download.get_mc_dir_error.text'), MY_ERROR, [mybutton.myOK]);
//    exit;
//  end;
  var mcpath := 'D:\testdir';
//  var mcpath := mcsp.GetValue('path').Value;
  var mcspath := Concat(mcpath, '\versions\', mcname);
  var mcvpath := Concat(mcspath, '\', mcname, '.json');
  if form_mainform.listbox_select_modloader.ItemIndex <> -1 then begin //modloader
    var ldname := form_mainform.listbox_select_modloader.Items[form_mainform.listbox_select_modloader.ItemIndex];
    if ldname.Contains(GetLanguage('listbox_select_modloader.item.has_no_data')) then begin
      MyMessagebox(GetLanguage('messagebox_download.download_no_data.caption'), GetLanguage('messagebox_download.download_no_data.text'), MY_ERROR, [mybutton.myOK]);
      exit;
    end;
    if MyMessagebox(GetLanguage('messagebox_download.is_download_mc.caption'), GetLanguage('messagebox_download.is_download_mc.text'), MY_INFORMATION, [mybutton.myNo, mybutton.myYes]) = 1 then exit;
    DeleteDirectory(mcspath);
    if not DirectoryExists(mcspath) then ForceDirectories(mcspath);
    form_mainform.pagecontrol_mainpage.ActivePage := form_mainform.tabsheet_download_progress_part;
    case mmod_loader of
      1: begin //Forge
        var sjava := LLLini.ReadInteger('Java', 'SelectJava', -1);
        var sjpth := '';
        try
          sjpth := ((TJSONObject.ParseJSONValue(GetFile(Concat(ExtractFilePath(Application.ExeName), 'LLLauncher\configs\JavaJson.json'))) as TJSONObject).GetValue('java') as TJSONArray)[sjava - 1].Value;
        except
          MyMessagebox(GetLanguage('messagebox_download.install_forge_not_choose_java.caption'), GetLanguage('messagebox_download.install_forge_not_choose_java.text'), MY_ERROR, [mybutton.myOK]);
          exit;
        end;
        if MyMessagebox(GetLanguage('messagebox_download.is_install_forge.caption'), GetLanguage('messagebox_download.is_install_forge.text'), MY_WARNING, [mybutton.myNo, mybutton.myYes]) = 1 then exit;
        if MyMessagebox(GetLanguage('messagebox_download.is_install_neoforge.caption'), GetLanguage('messagebox_download.is_install_neoforge.text'), MY_INFORMATION, [mybutton.myNo, mybutton.myYes]) = 2 then begin
          form_mainform.pagecontrol_mainpage.ActivePage := form_mainform.tabsheet_download_part;
          form_mainform.radiogroup_choose_mod_loader.ItemIndex := 4;
          form_mainform.radiogroup_choose_mod_loaderClick(nil);
          form_mainform.button_load_modloaderClick(nil);
        end;
        case mdownload_source of //Forge Official
          1: begin
//            var ldname := form_mainform.listbox_select_modloader.Items[form_mainform.listbox_select_modloader.ItemIndex];
            var dul := Concat('https://maven.minecraftforge.net/net/minecraftforge/forge/', ldname, '/forge-', ldname, '-installer.jar');
            TTask.Run(procedure begin
              form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.download.start_download').Replace('${version}', 'Forge').Replace('${source}', 'Official'));
              form_mainform.button_progress_clean_download_list.Enabled := false;
              DownloadStart(dul, mcspath, mcpath, mbiggest_thread, mdownload_source, 4, sjpth, mcvname, false);
              form_mainform.button_progress_clean_download_list.Enabled := true;
              MyMessagebox(GetLanguage('messagebox_download.download_forge_success.caption'), GetLanguage('messagebox_download.download_forge_success.text'), MY_PASS, [mybutton.myOK]);
            end);
          end;
          2..3: begin //Forge BMCLAPI MCBBS
            //https://bmclapi2.bangbang93.com/forge/download?mcversion=1.7.10&version=10.13.3.1401&branch=1710ls&category=installer&format=jar
            var lv := loaderJSON[form_mainform.listbox_select_modloader.ItemIndex] as TJSONObject;
            var lov := lv.GetValue('version').Value;
            var mcv := lv.GetValue('mcversion').Value;
            var bch := '';
            try
              bch := lv.GetValue('branch').Value;
              if bch = 'null' then raise Exception.Create('No Branch Found');
            except
              bch := '';
            end;
            var jav := '';
            var ctv := '';
            for var I in lv.GetValue('files') as TJSONArray do begin
              if I.GetValue<String>('category') = 'installer' then begin
                ctv := 'installer';
                if I.GetValue<String>('format') = 'jar' then begin
                  jav := 'jar';
                end;
              end;
            end;
            if jav.IsEmpty or ctv.IsEmpty then begin
              MyMessagebox(GetLanguage('messagebox_download.not_support_forge_version.caption'), GetLanguage('messagebox_download.not_support_forge_version.caption'), MY_ERROR, [mybutton.myOK]);
              exit;
            end;
            var dui := '';
            case mdownload_source of
              2: begin
                form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.download.start_download').Replace('${version}', 'Forge').Replace('${source}', 'BMCLAPI'));
                dui := 'https://bmclapi2.bangbang93.com';
              end;
              3: begin
                form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.download.start_download').Replace('${version}', 'Forge').Replace('${source}', 'MCBBS'));
                dui := 'https://download.mcbbs.net';
              end;
            end;
            var dul := '';
            if bch = '' then dul := Concat(dui, '/forge/download?mcversion=', mcv, '&version=', lov, '&category=installer&format=jar')
            else dul := Concat(dui, '/forge/download?mcversion=', mcv, '&version=', lov, '&branch=', bch, '&category=installer&format=jar');
            TTask.Run(procedure begin
              form_mainform.button_progress_clean_download_list.Enabled := false;
              DownloadStart(dul, mcspath, mcpath, mbiggest_thread, mdownload_source, 4, sjpth, mcvname, false);
              form_mainform.button_progress_clean_download_list.Enabled := true;
              MyMessagebox(GetLanguage('messagebox_download.download_forge_success.caption'), GetLanguage('messagebox_download.download_forge_success.text'), MY_PASS, [mybutton.myOK]);
            end);
          end;
        end;
      end;
      2: begin //Fabric
        var ver := form_mainform.listbox_select_minecraft.Items[form_mainform.listbox_select_minecraft.ItemIndex];
        var fver := form_mainform.listbox_select_modloader.Items[form_mainform.listbox_select_modloader.ItemIndex];
        var dul := '';
        case mdownload_source of
          1: begin
            form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.download.start_download').Replace('${version}', 'Fabric').Replace('${source}', 'Official'));
            dul := Concat('https://meta.fabricmc.net/v2/versions/loader/', ver, '/', fver, '/profile/json');
          end;
          2: begin
            form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.download.start_download').Replace('${version}', 'Fabric').Replace('${source}', 'BMCLAPI'));
            dul := Concat('https://bmclapi2.bangbang93.com/fabric-meta/v2/versions/loader/', ver, '/', fver, '/profile/json');
          end;
          3: begin
            form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.download.start_download').Replace('${version}', 'Fabric').Replace('${source}', 'MCBBS'));
            dul := Concat('https://download.mcbbs.net/fabric-meta/v2/versions/loader/', ver, '/', fver, '/profile/json');
          end;
        end;
        TTask.Run(procedure begin
          var ss := GetWebText(dul);
          if ss = '' then begin
            form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.download.get_fabric_metadata_error'));
            abort;
          end;
          var vjn := '';
          try
            vjn := (TJSONObject.ParseJSONValue(ss).Format().Replace('\', ''));
          except
            form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add('downloadlist.download.get_fabric_metadata_error');
            exit;
          end;
          SetFile(mcvpath, vjn);
          form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.download.fabric_metadata_download_success'));
          DownloadStart(vjn, mcspath, mcpath, mbiggest_thread, mdownload_source, 2, '', mcvname, false);
          MyMessagebox(GetLanguage('messagebox_download.download_fabric_success.caption'), GetLanguage('messagebox_download.download_fabric_success.text'), MY_PASS, [mybutton.myOK]);
        end);
      end;
      3: begin //Quilt
        var ver := form_mainform.listbox_select_minecraft.Items[form_mainform.listbox_select_minecraft.ItemIndex];
        var fver := form_mainform.listbox_select_modloader.Items[form_mainform.listbox_select_modloader.ItemIndex];
        var dul := '';
        case mdownload_source of
          1: begin
            form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.download.start_download').Replace('${version}', 'Quilt').Replace('${source}', 'Official'));
            dul := Concat('https://meta.quiltmc.org/v3/versions/loader/', ver, '/', fver, '/profile/json');
          end;
          2: begin
            form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.download.start_download').Replace('${version}', 'Quilt').Replace('${source}', 'BMCLAPI'));
            dul := Concat('https://bmclapi2.bangbang93.com/quilt-meta/v3/versions/loader/', ver, '/', fver, '/profile/json');
          end;
          3: begin
            form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.download.start_download').Replace('${version}', 'Quilt').Replace('${source}', 'MCBBS'));
            dul := Concat('https://download.mcbbs.net/quilt-meta/v3/versions/loader/', ver, '/', fver, '/profile/json');
          end;
        end;
        TTask.Run(procedure begin
          var ss := GetWebText(dul);
          if ss = '' then begin
            form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.download.get_quilt_metadata_error'));
            abort;
          end;
          var vjn := '';
          try
            vjn := (TJSONObject.ParseJSONValue(ss).Format().Replace('\', ''));
          except
            form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add('downloadlist.download.get_fabric_metadata_error');
            exit;
          end;
          SetFile(mcvpath, vjn);
          form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.download.quilt_metadata_download_success'));
          DownloadStart(vjn, mcspath, mcpath, mbiggest_thread, mdownload_source, 2, '', mcvname, false);
          MyMessagebox(GetLanguage('messagebox_download.download_quilt_success.caption'), GetLanguage('messagebox_download.download_quilt_success.text'), MY_PASS, [mybutton.myOK]);
        end);
      end;
      4: begin //NeoForge
        var sjava := LLLini.ReadInteger('Java', 'SelectJava', -1);
        var sjpth := '';
        try
          sjpth := ((TJSONObject.ParseJSONValue(GetFile(Concat(ExtractFilePath(Application.ExeName), 'LLLauncher\configs\JavaJson.json'))) as TJSONObject).GetValue('java') as TJSONArray)[sjava - 1].Value;
        except
          MyMessagebox(GetLanguage('messagebox_download.install_neoforge_not_choose_java.caption'), GetLanguage('messagebox_download.install_neoforge_not_choose_java.text'), MY_ERROR, [mybutton.myOK]);
          exit;
        end;
        case mdownload_source of
          1: begin
            var dul := '';
//            var ldname := form_mainform.listbox_select_modloader.Items[form_mainform.listbox_select_modloader.ItemIndex];
            if form_mainform.listbox_select_minecraft.Items[form_mainform.listbox_select_minecraft.ItemIndex] = '1.20.1' then begin
              dul := Concat('https://maven.neoforged.net/releases/net/neoforged/forge/', ldname, '/forge-', ldname, '-installer.jar');
            end else begin
              dul := Concat('https://maven.neoforged.net/releases/net/neoforged/neoforge/', ldname, '/neoforge-', ldname, '-installer.jar');
            end;
            TTask.Run(procedure begin
              form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.download.start_download').Replace('${version}', 'NeoForge').Replace('${source}', 'Official'));
              form_mainform.button_progress_clean_download_list.Enabled := false;
              DownloadStart(dul, mcspath, mcpath, mbiggest_thread, mdownload_source, 4, sjpth, mcvname, false);
              form_mainform.button_progress_clean_download_list.Enabled := true;
              MyMessagebox(GetLanguage('messagebox_download.download_neoforge_success.caption'), GetLanguage('messagebox_download.download_neoforge_success.text'), MY_PASS, [mybutton.myOK]);
            end);
          end;
          2..3: begin
            var dui := '';
            case mdownload_source of
              2: begin
                form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.download.start_download').Replace('${version}', 'NeoForge').Replace('${source}', 'BMCLAPI'));
                dui := 'https://bmclapi2.bangbang93.com';
              end;
              3: begin
                form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.download.start_download').Replace('${version}', 'NeoForge').Replace('${source}', 'MCBBS'));
                dui := 'https://download.mcbbs.net';
              end;
            end;
            var lv := loaderJSON[form_mainform.listbox_select_modloader.ItemIndex] as TJSONObject;
            var dul := Concat(dui, '/neoforge/version/', lv.GetValue('version').Value, '/download/installer.jar');
            TTask.Run(procedure begin
              form_mainform.button_progress_clean_download_list.Enabled := false;
              DownloadStart(dul, mcspath, mcpath, mbiggest_thread, mdownload_source, 4, sjpth, mcvname, false);
              form_mainform.button_progress_clean_download_list.Enabled := true;
              MyMessagebox(GetLanguage('messagebox_download.download_neoforge_success.caption'), GetLanguage('messagebox_download.download_neoforge_success.text'), MY_PASS, [mybutton.myOK]);
            end);
          end;
        end;
      end;
    end;
  end else begin //vanilla
    jurl := urlsl[form_mainform.listbox_select_minecraft.ItemIndex];
    if MyMessagebox(GetLanguage('messagebox_download.is_download_mc.caption'), GetLanguage('messagebox_download.is_download_mc.text'), MY_INFORMATION, [mybutton.myNo, mybutton.myYes]) = 1 then exit;
    DeleteDirectory(mcspath);
    if not DirectoryExists(mcspath) then ForceDirectories(mcspath);
    form_mainform.pagecontrol_mainpage.ActivePage := form_mainform.tabsheet_download_progress_part;
    case mdownload_source of
      1: begin
        form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.download.start_download').Replace('${version}', 'Vanilla').Replace('${source}', 'Official'));
      end;
      2: begin
        form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.download.start_download').Replace('${version}', 'Vanilla').Replace('${source}', 'BMCLAPI'));
        jurl := jurl.Replace('https://piston-meta.mojang.com', 'https://bmclapi2.bangbang93.com');
      end;
      3: begin
        form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.download.start_download').Replace('${version}', 'Vanilla').Replace('${source}', 'MCBBS'));
        jurl := jurl.Replace('https://piston-meta.mojang.com', 'https://download.mcbbs.net');
      end;
    end;
    TTask.Run(procedure begin
      form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.download.get_mc_metadata'));
      var ss := GetWebText(jurl);
      if ss = '' then begin
        form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.download.get_mc_metadata_error'));
        abort;
      end;
      var vjn := (TJSONObject.ParseJSONValue(ss) as TJSONObject).Format().Replace('\', '');
      SetFile(mcvpath, vjn);
      form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.download.mc_metadata_download_success'));
      DownloadStart(vjn, mcspath, mcpath, mbiggest_thread, mdownload_source, 2, '', mcvname, false);
      MyMessagebox(GetLanguage('messagebox_download.download_mc_success.caption'), GetLanguage('messagebox_download.download_mc_success.text'), MY_PASS, [mybutton.myOK]);
    end)
  end;
end;
//选择显示方式复选列表框点击。
procedure CheckMode;
begin
  mrelease := form_mainform.checklistbox_choose_view_mode.Checked[0];
  msnapshot := form_mainform.checklistbox_choose_view_mode.Checked[1];
  mbeta := form_mainform.checklistbox_choose_view_mode.Checked[2];
  malpha := form_mainform.checklistbox_choose_view_mode.Checked[3];
  mlll := form_mainform.checklistbox_choose_view_mode.Checked[4];
  SoluteMC;
end;
//重置下载界面    
procedure ResetDownload;
begin
  form_mainform.listbox_select_minecraft.Items.Clear;
  form_mainform.listbox_select_modloader.Items.Clear;
  form_mainform.label_download_return_value.Caption := GetLanguage('label_download_return_value.caption.reset_mc_web');
  form_mainform.button_load_modloader.Enabled := false;
  form_mainform.button_reset_download_part.Enabled := false;
  form_mainform.button_download_start_download_minecraft.Enabled := false;
  TTask.Run(procedure begin
    webjson := GetWebText(Concat(mcwe, '/mc/game/version_manifest.json'));   
    SoluteMC;
    form_mainform.label_download_return_value.Caption := GetLanguage('label_downlaod_return_value.caption.reset_mc_web_success');   
    form_mainform.button_load_modloader.Enabled := true;
    form_mainform.button_reset_download_part.Enabled := true; 
    form_mainform.button_download_start_download_minecraft.Enabled := true;
  end);
end;       
//下载源单选框组改变
procedure ChangeDlSource;
begin
  mdownload_source := form_mainform.radiogroup_choose_download_source.ItemIndex + 1;
  form_mainform.listbox_select_modloader.Items.Clear;
  loaderJSON.Free;
  loaderJSON := TJSONArray.Create;
  case mdownload_source of
    1: begin
      mcwe := 'https://piston-meta.mojang.com';
      fabme := 'https://meta.fabricmc.net';
      quime := 'https://meta.quiltmc.org';
      form_mainform.radiogroup_choose_download_source.ItemIndex := 0;
    end;
    2: begin
      mcwe := 'https://bmclapi2.bangbang93.com';
      fabme := 'https://bmclapi2.bangbang93.com/fabric-meta';
      quime := 'https://bmclapi2.bangbang93.com/quilt-meta';
      form_mainform.radiogroup_choose_download_source.ItemIndex := 1;
    end;
    3: begin
      mcwe := 'https://download.mcbbs.net';
      fabme := 'https://download.mcbbs.net/fabric-meta';
      quime := 'https://download.mcbbs.net/quilt-meta';
      form_mainform.radiogroup_choose_download_source.ItemIndex := 2;
    end;
    else begin
      mcwe := 'https://piston-meta.mojang.com';
      fabme := 'https://meta.fabricmc.net';
      quime := 'https://meta.quiltmc.org';
      form_mainform.radiogroup_choose_download_source.ItemIndex := 0;
    end;
  end;
end;
//模组加载器单选框组改变
procedure ChangeModLoader;
begin
  mmod_loader := form_mainform.radiogroup_choose_mod_loader.ItemIndex + 1;
  form_mainform.listbox_select_modloader.Items.Clear;
end;
//加载模组加载器                 
procedure LoadModLoader;          
begin
  if form_mainform.listbox_select_minecraft.ItemIndex <> -1 then begin
    form_mainform.listbox_select_modloader.Items.Clear;
    form_mainform.button_reset_download_part.Enabled := false;
    form_mainform.button_load_modloader.Enabled := false;
    form_mainform.button_download_start_download_minecraft.Enabled := false;
    form_mainform.label_download_return_value.Caption := GetLanguage('label_download_return_value.caption.get_modloader');
    var vername := form_mainform.listbox_select_minecraft.Items[form_mainform.listbox_select_minecraft.ItemIndex];
    TTask.Run(procedure begin
      if mmod_loader = 1 then begin
        if mdownload_source = 1 then begin
          var forgexml := GetWebText(Concat('https://maven.minecraftforge.net/net/minecraftforge/forge/maven-metadata.xml'));
          CoInitialize(nil);
          SoluteLoaderXML(forgexml);
          CoUnInitialize;
        end else if mdownload_source = 2 then begin                                                                           
          var forgejson := GetWebText(Concat('https://bmclapi2.bangbang93.com/forge/minecraft/', vername));
          SoluteForgeJSON(forgejson);
        end else if mdownload_source = 3 then begin
          var forgejson := GetWebText(Concat('https://download.mcbbs.net/forge/minecraft/', vername));
          SoluteForgeJSON(forgejson);
        end;
      end else if mmod_loader = 2 then begin
        var fabricjson := GetWebText(Concat(fabme, '/v2/versions/loader/', vername));
        SoluteLoaderJSON(fabricjson);
      end else if mmod_loader = 3 then begin
        var quiltjson := GetWebText(Concat(quime, '/v3/versions/loader/', vername));
        SoluteLoaderJSON(quiltjson);
      end else if mmod_loader = 4 then begin
        if mdownload_source = 1 then begin
          if vername = '1.20.1' then begin
            var neoxml := GetWebText(Concat('https://maven.neoforged.net/releases/net/neoforged/forge/maven-metadata.xml'));
            CoInitialize(nil);
            SoluteLoaderXML(neoxml);
            CoUnInitialize;
          end else begin
            var tmp: TArray<String>;
            tmp := SplitString(vername, '.');
            try
              var midver := tmp[1] + '.' + tmp[2];
              var neoxml := GetWebText('https://maven.neoforged.net/releases/net/neoforged/neoforge/maven-metadata.xml');
              CoInitialize(nil);
              SoluteNeoXML(neoxml, midver);
              CoUnInitialize;
            except form_mainform.listbox_select_modloader.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data')) end;
          end;
        end else if mdownload_source >= 2 then begin
          var neojson := GetWebText('https://bmclapi2.bangbang93.com/neoforge/list/' + vername);
          SoluteForgeJSON(neojson);
        end else if mdownload_source = 3 then begin
          var neojson := GetWebText('https://download.mcbbs.com/neoforge/list/' + vername);
          SoluteForgeJSON(neojson);
        end;
      end; 
      form_mainform.button_load_modloader.Enabled := true;
      form_mainform.button_reset_download_part.Enabled := true; 
      form_mainform.button_download_start_download_minecraft.Enabled := true;
      form_mainform.label_download_return_value.Caption := GetLanguage('label_download_return_value.caption.get_modloader_success');
    end);
  end else begin
    MyMessagebox(GetLanguage('messagebox_download.not_choose_minecraft_versino.caption'), GetLanguage('messagebox_download.not_choose_minecraft_versino.text'), MY_ERROR, [mybutton.myOK]);
  end;
end;  
//查看Minecraft版本信息        
procedure ViewMinecraftInfo();
var
  te, te2, te3, te4, te5: String;
  tem, tem2, tem3: TArray<String>; //设置初值
begin
  if form_mainform.listbox_select_minecraft.ItemIndex = -1 then
  begin
    MyMessagebox(GetLanguage('messagebox_download.view_mc_info_error.caption'), GetLanguage('messagebox_download.view_mc_info_error.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  var tef := '';
  try
    var Root := TJsonObject.ParseJSONValue(webjson) as TJsonObject; //获取Json
    var JArr := Root.GetValue('versions') as TJsonArray; //获取版本
    for var I := 0 to JArr.Count - 1 do begin//用循环判断版本
      if JArr[I].GetValue<String>('id') = form_mainform.listbox_select_minecraft.Items[form_mainform.listbox_select_minecraft.ItemIndex] then //获取id是否等于选中的版本
      begin  //如果等于则赋值
        te2 := JArr[I].GetValue<String>('type'); //获取类型
        te3 := JArr[I].GetValue<String>('id');   //获取版本名称
        te4 := te3.Substring(0, 1); //切割版本名称，取前一个字符
        te5 := te3.Substring(1, te2.Length + 3); //切割版本名称，取后面所有的字符。
        break;
      end;
    end;
    tem := SplitString(reltmr[form_mainform.listbox_select_minecraft.ItemIndex], '+');
    tem2 := SplitString(tem[0], 'T');
    tem3 := SplitString(tem2[0], '-');
    te := GetLanguage('messagebox_download.is_open_wiki.text').Replace('${year}', tem3[0]).Replace('${month}', tem3[1]).Replace('${day}', tem3[2]).Replace('${time}', tem2[1]); //输出
    if MyMessagebox(te3, te, MY_INFORMATION, [mybutton.myNo, mybutton.myYes]) = 2 then          //      if messagebox(Handle, pchar(te), pchar(te3), MB_YESNO+MB_ICONINFORMATION) = idYes then //判断是否按下是
    begin //如果是，则打开网址。
      if te4 = 'b' then tef := Concat('https://zh.minecraft.wiki/w/Java%E7%89%88Beta_', te5)
      else if te4 = 'a' then tef := Concat('https://zh.minecraft.wiki/w/Java%E7%89%88Alpha_v', te5)
      else if te4 = 'i' then tef := 'https://zh.minecraft.wiki/w/Java%E7%89%88Infdev_20100618'
      else if te4 = 'c' then tef := Concat('https://zh.minecraft.wiki/w/Java%E7%89%88Classic_', te5)
      else if te4 = 'r' then tef := Concat('https://zh.minecraft.wiki/w/Java%E7%89%88pre-Classic_', te3)
      else if te2 = 'snapshot' then tef := Concat('https://zh.minecraft.wiki/w/', te3)
      else tef := Concat('https://zh.minecraft.wiki/w/Java%E7%89%88', te3);
      ShellExecute(Application.Handle, nil, pchar(tef), nil, nil, SW_SHOWNORMAL);
    end; //清除集合。
  except
    MyMessagebox(GetLanguage('messagebox_download.import_mc_info_error.caption'), GetLanguage('messagebox_download.import_mc_info_error.text'), MY_ERROR, [mybutton.myOK]);//      messagebox(Handle, '导入失败，请重试！', '导入失败', MB_ICONERROR);
  end;
end;
//下载界面初始化
var f: Boolean = false;
procedure InitDownload;
begin
  if f then exit;
  f := true;
  urlsl := TStringList.Create;
  reltmr := TStringList.Create;
  loaderJSON := TJSONArray.Create;
  case mdownload_source of
    1: begin
      mcwe := 'https://piston-meta.mojang.com';
      fabme := 'https://meta.fabricmc.net';
      quime := 'https://meta.quiltmc.org';
      form_mainform.radiogroup_choose_download_source.ItemIndex := 0;
    end;
    2: begin
      mcwe := 'https://bmclapi2.bangbang93.com';
      fabme := 'https://bmclapi2.bangbang93.com/fabric-meta';
      quime := 'https://bmclapi2.bangbang93.com/quilt-meta';
      form_mainform.radiogroup_choose_download_source.ItemIndex := 1;
    end;
    3: begin
      mcwe := 'https://download.mcbbs.net';
      fabme := 'https://download.mcbbs.net/fabric-meta';
      quime := 'https://download.mcbbs.net/quilt-meta';
      form_mainform.radiogroup_choose_download_source.ItemIndex := 2;
    end;
    else begin
      mcwe := 'https://piston-meta.mojang.com';
      fabme := 'https://meta.fabricmc.net';
      quime := 'https://meta.quiltmc.org';
      form_mainform.radiogroup_choose_download_source.ItemIndex := 0;
    end;
  end;
  mrelease := LLLini.ReadBool('Version', 'ShowRelease', true);
  form_mainform.checklistbox_choose_view_mode.Checked[0] := mrelease;
  msnapshot := LLLini.ReadBool('Version', 'ShowSnapshot', false);
  form_mainform.checklistbox_choose_view_mode.Checked[1] := msnapshot;
  mbeta := LLLini.ReadBool('Version', 'ShowOldBeta', false);
  form_mainform.checklistbox_choose_view_mode.Checked[2] := mbeta;
  malpha := LLLini.ReadBool('Version', 'ShowOldAlpha', false);
  form_mainform.checklistbox_choose_view_mode.Checked[3] := malpha;
  mlll := LLLini.ReadBool('Version', 'ShowLLLSpecial', false);
  form_mainform.checklistbox_choose_view_mode.Checked[4] := mlll;
  form_mainform.scrollbar_download_biggest_thread.Position := mbiggest_thread;
  try
    mmod_loader := LLLini.ReadInteger('Version', 'SelectModLoader', -1);
    if (mmod_loader < 1) or (mmod_loader > form_mainform.radiogroup_choose_mod_loader.Items.Count) then raise Exception.Create('Format Exception');
  except
    mmod_loader := 1;
    LLLini.WriteInteger('Version', 'SelectModLoader', 1)
  end;
  form_mainform.radiogroup_choose_mod_loader.ItemIndex := mmod_loader - 1;
  form_mainform.listbox_select_minecraft.Items.Clear;
  form_mainform.listbox_select_modloader.Items.Clear;
  form_mainform.label_download_return_value.Caption := GetLanguage('label_download_return_value.caption.get_mc_web');
  form_mainform.button_load_modloader.Enabled := false;
  form_mainform.button_reset_download_part.Enabled := false; 
  form_mainform.button_download_start_download_minecraft.Enabled := false;
  form_mainform.label_download_biggest_thread.Caption := GetLanguage('label_download_biggest_thread.caption').Replace('${biggest_thread}', inttostr(mbiggest_thread));
  TTask.Run(procedure begin 
    webjson := GetWebText(Concat(mcwe, '/mc/game/version_manifest.json'));
    SoluteMC;
    form_mainform.label_download_return_value.Caption := GetLanguage('label_downlaod_return_value.caption.get_mc_web_success');   
    form_mainform.button_load_modloader.Enabled := true;
    form_mainform.button_reset_download_part.Enabled := true; 
    form_mainform.button_download_start_download_minecraft.Enabled := true;
  end);
end;
procedure SaveDownload;
begin
  if loaderJSON = nil then exit;
  LLLini.WriteBool('Version', 'ShowRelease', mrelease);
  LLLini.WriteBool('Version', 'ShowSnapshot', msnapshot);
  LLLini.WriteBool('Version', 'ShowOldBeta', mbeta);
  LLLini.WriteBool('Version', 'ShowOldAlpha', malpha);
  LLLini.WriteInteger('Version', 'SelectDownloadSource', mdownload_source);
  LLLini.WriteInteger('Version', 'ThreadBiggest', mbiggest_thread);
  LLLini.WriteInteger('Version', 'SelectModLoader', mmod_loader);
end;

end.
