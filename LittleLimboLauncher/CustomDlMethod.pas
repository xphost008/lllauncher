unit CustomDlMethod;

interface

uses
  SysUtils, Forms, Dialogs, FileCtrl, ShellAPI, Windows, Winapi.msxml, Classes,
  Winapi.ActiveX, StrUtils, JSON, Generics.Collections;

procedure InitCustomDl;
procedure SaveCustomDl;
procedure ChangeSavePath;
procedure OpenSavePath;
procedure ChangeSaveEdit;
procedure StartDownloadCustomDl;
procedure RefreshModLoader;
procedure StartDownloadModLoader;

implementation

uses
  MainForm, LanguageMethod, MyCustomWindow, ProgressMethod, MainMethod;
var
  mcustom_path: String;
  loaderJSON: TJSONArray;
//解析NeoForge的JSON
procedure SoluteNeoForgeJSON(json: String);
begin
  try
    loaderJSON := TJSONArray.ParseJSONValue(json) as TJSONArray;
    for var I in loaderJSON as TJSONArray do begin
      var J := I as TJsonObject;
      form_mainform.listbox_download_modloader_neoforge.Items.Add(J.GetValue('version').Value);
    end;
    if form_mainform.listbox_download_modloader_neoforge.Items.Count = 0 then form_mainform.listbox_download_modloader_neoforge.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
  except
    form_mainform.listbox_download_modloader_neoforge.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
  end;
end;
//解析Forge的JSON
procedure SoluteForgeJSON(json: String);
begin
  try
    loaderJSON := TJSONArray.ParseJSONValue(json) as TJSONArray;
    for var I in loaderJSON do begin
      var J := I as TJsonObject;
      form_mainform.listbox_download_modloader_forge.Items.Add(J.GetValue('version').Value);
    end;
    if form_mainform.listbox_download_modloader_forge.Items.Count = 0 then form_mainform.listbox_download_modloader_forge.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
  except
    form_mainform.listbox_download_modloader_forge.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
  end;
end;
//解析旧的NeoForge的XML
procedure SoluteNeoForgeOldXML(xml, mcv: String);
begin
  var xmldoc: IXMLDOMDocument2 := CoDOMDocument.Create;
  try
    form_mainform.listbox_download_modloader_neoforge.Items.BeginUpdate;
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
                  if ver.Substring(0, ver.IndexOf('-')) = mcv then begin
                    form_mainform.listbox_download_modloader_neoforge.Items.Add(ver);
                  end;
                end;
              end;
            end;
          end;
        end;
      except
        form_mainform.listbox_download_modloader_neoforge.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
      end;
    end else begin
      form_mainform.listbox_download_modloader_neoforge.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
    end;
    form_mainform.listbox_download_modloader_neoforge.Items.EndUpdate;
  finally
    xmldoc := nil;
  end;
  if form_mainform.listbox_download_modloader_neoforge.Items.Count = 0 then form_mainform.listbox_download_modloader_neoforge.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
end;
//解析Forge的XML
procedure SoluteForgeXML(xml, mcv: String);
begin
  var xmldoc: IXMLDOMDocument2 := CoDOMDocument.Create;
  try
    form_mainform.listbox_download_modloader_forge.Items.BeginUpdate;
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
                  if ver.Substring(0, ver.IndexOf('-')) = mcv then begin
                    form_mainform.listbox_download_modloader_forge.Items.Add(ver);
                  end;
                end;
              end;
            end;
          end;
        end;
      except
        form_mainform.listbox_download_modloader_forge.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
      end;
    end else begin
      form_mainform.listbox_download_modloader_forge.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
    end;
    form_mainform.listbox_download_modloader_forge.Items.EndUpdate;
  finally
    xmldoc := nil;
  end;
  if form_mainform.listbox_download_modloader_forge.Items.Count = 0 then form_mainform.listbox_download_modloader_forge.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
end;
//解析NeoForge的XML
procedure SoluteNeoForgeXML(xml, mcv: String);
begin
  var xmldoc: IXMLDOMDocument2 := CoDOMDocument.Create;
  try
    form_mainform.listbox_download_modloader_neoforge.Items.BeginUpdate;
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
                  var tmp := SplitString(ver, '.');
                  var nver := tmp[0] + '.' + tmp[1];
                  if mcv = nver then begin
                    form_mainform.listbox_download_modloader_neoforge.Items.Add(ver);
                  end;
                end;
              end;
            end;
          end;
        end;
      except
        form_mainform.listbox_download_modloader_neoforge.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
      end;
    end else begin
      form_mainform.listbox_download_modloader_neoforge.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
    end;
    form_mainform.listbox_download_modloader_neoforge.Items.EndUpdate;
  finally
    xmldoc := nil;
  end;
  if form_mainform.listbox_download_modloader_neoforge.Items.Count = 0 then form_mainform.listbox_download_modloader_neoforge.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
end;
//专门解决Fabric的XML
procedure SoluteFabricXML(xml: String);
begin
  var xmldoc: IXMLDOMDocument2 := CoDOMDocument.Create;
  try
    form_mainform.listbox_download_modloader_fabric.Items.BeginUpdate;
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
                  form_mainform.listbox_download_modloader_fabric.Items.Add(ver);
                end;
              end;
            end;
          end;
        end;
      except
        form_mainform.listbox_download_modloader_fabric.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
      end;
    end else begin
      form_mainform.listbox_download_modloader_fabric.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
    end;
    form_mainform.listbox_download_modloader_fabric.Items.EndUpdate;
  finally
    xmldoc := nil;
  end;
  if form_mainform.listbox_download_modloader_fabric.Items.Count = 0 then form_mainform.listbox_download_modloader_fabric.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
end;
//专门解决Quilt的XML
procedure SoluteQuiltXML(xml: String);
begin
  var xmldoc: IXMLDOMDocument2 := CoDOMDocument.Create;
  try
    form_mainform.listbox_download_modloader_quilt.Items.BeginUpdate;
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
                  form_mainform.listbox_download_modloader_quilt.Items.Add(ver);
                end;
              end;
            end;
          end;
        end;
      except
        form_mainform.listbox_download_modloader_quilt.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
      end;
    end else begin
      form_mainform.listbox_download_modloader_quilt.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
    end;
    form_mainform.listbox_download_modloader_quilt.Items.EndUpdate;
  finally
    xmldoc := nil;
  end;
  if form_mainform.listbox_download_modloader_quilt.Items.Count = 0 then form_mainform.listbox_download_modloader_quilt.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
end;
//开始下载模组加载器手动安装包
procedure StartDownloadModLoader;
begin
  if form_mainform.listbox_download_modloader_forge.ItemIndex <> -1 then begin
    var ml := form_mainform.listbox_download_modloader_forge.Items[form_mainform.listbox_download_modloader_forge.ItemIndex];
    if ml.Contains(GetLanguage('listbox_select_modloader.item.has_no_data')) then begin
      MyMessagebox(GetLanguage('messagebox_modloader.not_choose_modloader.caption'), GetLanguage('messagebox_modloader.not_choose_modloader.text'), MY_ERROR, [mybutton.myOK]);
      exit;
    end;
    var path := Concat(mcustom_path, '\forge-', ml, '-installer.jar');
    case mdownload_source of
      1: begin
        var dui := Concat('https://maven.minecraftforge.net/net/minecraftforge/forge/', ml, '/forge-', ml, '-installer.jar');
        form_mainform.pagecontrol_mainpage.ActivePage := form_mainform.tabsheet_download_progress_part;
        TThread.CreateAnonymousThread(procedure begin
          form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.download.start_download').Replace('${version}', 'Forge').Replace('${source}', '官方'));
          form_mainform.button_progress_clean_download_list.Enabled := false;
          DownloadStart(dui, path, '', mbiggest_thread, 0, 1);
          form_mainform.button_progress_clean_download_list.Enabled := true;
          form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.modloader.download_success'));
          MyMessagebox(GetLanguage('messagebox_modloader.download_modloader_success.caption'), GetLanguage('messagebox_modloader.download_modloader_success.text'), MY_PASS, [mybutton.myOK]);
        end).Start;
      end;
      2: begin
        var mcv := (loaderJSON[form_mainform.listbox_download_modloader_forge.ItemIndex] as TJSONObject).GetValue('mcversion').Value;
        var fov := (loaderJSON[form_mainform.listbox_download_modloader_forge.ItemIndex] as TJSONObject).GetValue('version').Value;
        var dui := Concat('https://bmclapi2.bangbang93.com/forge/download?mcversion=', mcv, '&version=', fov, '&category=installer&format=jar');
        var src := 'BMCLAPI';
        try
          var bch := (loaderJSON[form_mainform.listbox_download_modloader_forge.ItemIndex] as TJSONObject).GetValue('branch').Value;
          if bch <> 'null' then begin
            dui := Concat(dui, '&branch=', bch);
          end;
        except end;
        form_mainform.pagecontrol_mainpage.ActivePage := form_mainform.tabsheet_download_progress_part;
        TThread.CreateAnonymousThread(procedure begin
          form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.download.start_download').Replace('${version}', 'Forge').Replace('${source}', src));
          form_mainform.button_progress_clean_download_list.Enabled := false;
          DownloadStart(dui, path, '', mbiggest_thread, 0, 1);
          form_mainform.button_progress_clean_download_list.Enabled := true;
          form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.modloader.download_success'));
          MyMessagebox(GetLanguage('messagebox_modloader.download_modloader_success.caption'), GetLanguage('messagebox_modloader.download_modloader_success.text'), MY_PASS, [mybutton.myOK]);
        end).Start;
      end;
    end;
  end else if form_mainform.listbox_download_modloader_fabric.ItemIndex <> -1 then begin
    var ml := form_mainform.listbox_download_modloader_fabric.Items[form_mainform.listbox_download_modloader_fabric.ItemIndex];
    if ml.Contains(GetLanguage('listbox_select_modloader.item.has_no_data')) then begin
      MyMessagebox(GetLanguage('messagebox_modloader.not_choose_modloader.caption'), GetLanguage('messagebox_modloader.not_choose_modloader.text'), MY_ERROR, [mybutton.myOK]);
      exit;
    end;
    var dui := '';
    var src := '';
    var path := Concat(mcustom_path, '\fabric-installer-', ml, '.jar');
    case mdownload_source of
      1: begin
        dui := Concat('https://maven.fabricmc.net/net/fabricmc/fabric-installer/', ml, '/fabric-installer-', ml, '.jar');
        src := 'Official';
      end;
      2: begin
        dui := Concat('https://bmclapi2.bangbang93.com/maven/net/fabricmc/fabric-installer/', ml, '/fabric-installer-', ml, '.jar');
        src := 'BMCLAPI';
      end;
    end;
    form_mainform.pagecontrol_mainpage.ActivePage := form_mainform.tabsheet_download_progress_part;
    TThread.CreateAnonymousThread(procedure begin
      form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.download.start_download').Replace('${version}', 'Fabric').Replace('${source}', src));
      form_mainform.button_progress_clean_download_list.Enabled := false;
      DownloadStart(dui, path, '', mbiggest_thread, 0, 1);
      form_mainform.button_progress_clean_download_list.Enabled := true;
      form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.modloader.download_success'));
      MyMessagebox(GetLanguage('messagebox_modloader.download_modloader_success.caption'), GetLanguage('messagebox_modloader.download_modloader_success.text'), MY_PASS, [mybutton.myOK]);
    end).Start;
  end else if form_mainform.listbox_download_modloader_quilt.ItemIndex <> -1 then begin
    var ml := form_mainform.listbox_download_modloader_quilt.Items[form_mainform.listbox_download_modloader_quilt.ItemIndex];
    if ml.Contains(GetLanguage('listbox_select_modloader.item.has_no_data')) then begin
      MyMessagebox(GetLanguage('messagebox_modloader.not_choose_modloader.caption'), GetLanguage('messagebox_modloader.not_choose_modloader.text'), MY_ERROR, [mybutton.myOK]);
      exit;
    end;
    var path := Concat(mcustom_path, '\quilt-installer-', ml, '.jar');
    var dui := '';
    var src := '';
    case mdownload_source of
      1: begin
        dui := Concat('https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/', ml, '/quilt-installer-', ml, '.jar');
        src := 'Official';
      end;
      2: begin
        dui := Concat('https://bmclapi2.bangbang93.com/maven/org/quiltmc/quilt-installer/', ml, '/quilt-installer-', ml, '.jar');
        src := 'BMCLAPI';
      end;
    end;
    form_mainform.pagecontrol_mainpage.ActivePage := form_mainform.tabsheet_download_progress_part;
    TThread.CreateAnonymousThread(procedure begin
      form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.download.start_download').Replace('${version}', 'Quilt').Replace('${source}', src));
      form_mainform.button_progress_clean_download_list.Enabled := false;
      DownloadStart(dui, path, '', mbiggest_thread, 0, 1);
      form_mainform.button_progress_clean_download_list.Enabled := true;
      form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.modloader.download_success'));
      MyMessagebox(GetLanguage('messagebox_modloader.download_modloader_success.caption'), GetLanguage('messagebox_modloader.download_modloader_success.text'), MY_PASS, [mybutton.myOK]);
    end).Start;
  end else if form_mainform.listbox_download_modloader_neoforge.ItemIndex <> -1 then begin
    var ml := form_mainform.listbox_download_modloader_neoforge.Items[form_mainform.listbox_download_modloader_neoforge.ItemIndex];
    if ml.Contains(GetLanguage('listbox_select_modloader.item.has_no_data')) then begin
      MyMessagebox(GetLanguage('messagebox_modloader.not_choose_modloader.caption'), GetLanguage('messagebox_modloader.not_choose_modloader.text'), MY_ERROR, [mybutton.myOK]);
      exit;
    end;
    case mdownload_source of
      1: begin
        var path := '';
        var dui := '';
        if form_mainform.listbox_select_minecraft.Items[form_mainform.listbox_select_minecraft.ItemIndex] = '1.20.1' then begin
          path := Concat(mcustom_path, '\forge-', ml, '-installer.jar');
          dui := Concat('https://maven.neoforged.net/releases/net/neoforged/forge/', ml, '/forge-', ml, '-installer.jar')
        end else begin
          path := Concat(mcustom_path, '\neoforge-', ml, '-installer.jar');
          dui := Concat('https://maven.neoforged.net/releases/net/neoforged/neoforge/', ml, '/neoforge-', ml, '-installer.jar');
        end;
        form_mainform.pagecontrol_mainpage.ActivePage := form_mainform.tabsheet_download_progress_part;
        TThread.CreateAnonymousThread(procedure begin
          form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.download.start_download').Replace('${version}', 'NeoForge').Replace('${source}', 'Official'));
          form_mainform.button_progress_clean_download_list.Enabled := false;
          DownloadStart(dui, path, '', mbiggest_thread, 0, 1);
          form_mainform.button_progress_clean_download_list.Enabled := true;
          form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.modloader.download_success'));
          MyMessagebox(GetLanguage('messagebox_modloader.download_modloader_success.caption'), GetLanguage('messagebox_modloader.download_modloader_success.text'), MY_PASS, [mybutton.myOK]);
        end).Start;
      end;
      2: begin
        var path := '';
        if form_mainform.listbox_select_minecraft.Items[form_mainform.listbox_select_minecraft.ItemIndex] = '1.20.1' then begin
          path := Concat(mcustom_path, '\forge-', ml, '-installer.jar');
        end else begin
          path := Concat(mcustom_path, '\neoforge-', ml, '-installer.jar');
        end;
        var dui := Concat('https://bmclapi2.bangbang93.com/neoforge/version/', ml, '/download/installer.jar');
        var src := 'BMCLAPI';
        form_mainform.pagecontrol_mainpage.ActivePage := form_mainform.tabsheet_download_progress_part;
        TThread.CreateAnonymousThread(procedure begin
          form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.download.start_download').Replace('${version}', 'NeoForge').Replace('${source}', src));
          form_mainform.button_progress_clean_download_list.Enabled := false;
          DownloadStart(dui, path, '', mbiggest_thread, 0, 1);
          form_mainform.button_progress_clean_download_list.Enabled := true;
          form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.modloader.download_success'));
          MyMessagebox(GetLanguage('messagebox_modloader.download_modloader_success.caption'), GetLanguage('messagebox_modloader.download_modloader_success.text'), MY_PASS, [mybutton.myOK]);
        end).Start;
      end;
    end;
  end else begin
    MyMessagebox(GetLanguage('messagebod_modloader.not_choose_modloader.caption'), GetLanguage('messagebod_modloader.not_choose_modloader.text'), MY_ERROR, [mybutton.myOK]);
  end;
end;
//刷新模组加载器版本
procedure RefreshModLoader;
var
  it: array of TMyThread;
begin
  SetLength(it, 4);
  form_mainform.button_download_modloader_download.Enabled := false;
  form_mainform.button_download_modloader_refresh.Enabled := false;
  form_mainform.listbox_download_modloader_forge.Items.Clear;
  form_mainform.listbox_download_modloader_fabric.Items.Clear;
  form_mainform.listbox_download_modloader_quilt.Items.Clear;
  form_mainform.listbox_download_modloader_neoforge.Items.Clear;
  TThread.CreateAnonymousThread(procedure begin
    case mdownload_source of
      1: begin
        it[0] := TMyThread.CreateAnonymousThread(procedure begin
          try
            var mcver := form_mainform.listbox_select_minecraft.Items[form_mainform.listbox_select_minecraft.ItemIndex];
            var forve := GetWebText('https://maven.minecraftforge.net/net/minecraftforge/forge/maven-metadata.xml');
            CoInitialize(nil); SoluteForgeXML(forve, mcver); CoUnInitialize;
          except
            form_mainform.listbox_download_modloader_forge.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
          end;
        end);
        it[0].Start;
        it[1] := TMyThread.CreateAnonymousThread(procedure begin
          var fabve := GetWebText('https://maven.fabricmc.net/net/fabricmc/fabric-installer/maven-metadata.xml');
          SoluteFabricXML(fabve);
        end);
        it[1].Start;
        it[2] := TMyThread.CreateAnonymousThread(procedure begin
          var quive := GetWebText('https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/maven-metadata.xml');
          SoluteQuiltXML(quive);
        end);
        it[2].Start;
        it[3] := TMyThread.CreateAnonymousThread(procedure begin
          try
            var mcver := form_mainform.listbox_select_minecraft.Items[form_mainform.listbox_select_minecraft.ItemIndex];
            var tmp := SplitString(mcver, '.');
            var midver := tmp[1] + '.' + tmp[2];
            if mcver = '1.20.1' then begin
              var neove := GetWebText('https://maven.neoforged.net/releases/net/neoforged/forge/maven-metadata.xml');
              CoInitialize(nil); SoluteNeoForgeOldXML(neove, mcver); CoUnInitialize;
            end else begin
              var neove := GetWebText('https://maven.neoforged.net/releases/net/neoforged/neoforge/maven-metadata.xml');
              CoInitialize(nil); SoluteNeoForgeXML(neove, midver); CoUnInitialize;
            end;
          except
            form_mainform.listbox_download_modloader_neoforge.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
          end;
        end);
        it[3].Start;
      end;
      2: begin
        it[0] := TMyThread.CreateAnonymousThread(procedure begin
          try
            var mcver := form_mainform.listbox_select_minecraft.Items[form_mainform.listbox_select_minecraft.ItemIndex];
            var forve := GetWebText(Concat('https://bmclapi2.bangbang93.com/forge/minecraft/', mcver));
            CoInitialize(nil); SoluteForgeJSON(forve); CoUnInitialize;
          except
            form_mainform.listbox_download_modloader_forge.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
          end;
        end);
        it[0].Start;
        it[1] := TMyThread.CreateAnonymousThread(procedure begin
          var fabve := GetWebText('https://bmclapi2.bangbang93.com/maven/net/fabricmc/fabric-installer/maven-metadata.xml');
          SoluteFabricXML(fabve);
        end);
        it[1].Start;
        it[2] := TMyThread.CreateAnonymousThread(procedure begin
          var quive := GetWebText('https://bmclapi2.bangbang93.com/maven/org/quiltmc/quilt-installer/maven-metadata.xml');
          SoluteQuiltXML(quive);
        end);
        it[2].Start;
        it[3] := TMyThread.CreateAnonymousThread(procedure begin
          try
            var mcver := form_mainform.listbox_select_minecraft.Items[form_mainform.listbox_select_minecraft.ItemIndex];
            var forve := GetWebText(Concat('https://bmclapi2.bangbang93.com/neoforge/list/', mcver));
            CoInitialize(nil); SoluteNeoForgeJSON(forve); CoUnInitialize;
          except
            form_mainform.listbox_download_modloader_neoforge.Items.Add(GetLanguage('listbox_select_modloader.item.has_no_data'));
          end;
        end);
        it[3].Start;
      end;
    end;
    for var I := 0 to 3 do begin
      if Assigned(it[I]) then begin
        it[I].WaitFor;
        it[I].Destroy;
      end;
    end;
    form_mainform.button_download_modloader_download.Enabled := true;
    form_mainform.button_download_modloader_refresh.Enabled := true;
  end);
end;
//开始自定义下载。
procedure StartDownloadCustomDl;
begin
  var url := form_mainform.edit_custom_download_url.Text;
  if url = '' then begin
    MyMessagebox(GetLanguage('messagebox_customdl.not_enter_url.caption'), GetLanguage('messagebox_customdl.not_enter_url.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  var path := mcustom_path;
  if path = '' then path := ExtractFileDir(Application.ExeName);
  if not SysUtils.DirectoryExists(path) then begin
    MyMessagebox(GetLanguage('messagebox_customdl.path_not_exist.caption'), GetLanguage('messagebox_customdl.path_not_exist.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  var name := form_mainform.edit_custom_download_name.Text;
  if name = '' then name := GetURLFileName(url);
  path := Concat(path, '\', name);
  var sha := form_mainform.edit_custom_download_sha1.Text;
  form_mainform.pagecontrol_mainpage.ActivePage := form_mainform.tabsheet_download_progress_part;
  if FileExists(path) then begin
    if MyMessagebox(GetLanguage('messagebox_customdl.file_is_exists.caption'), GetLanguage('messagebox_customdl.file_is_exists.text'), MY_INFORMATION, [mybutton.myNo, mybutton.myYes]) = 2 then begin
      TThread.CreateAnonymousThread(procedure begin
        form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.customdl.start_custom_download'));
        DownloadStart(url, path, '', mbiggest_thread, 0, 1);
        if FileExists(path) then begin
          if sha <> '' then begin
            if GetFileHash(path) = sha then begin
              MyMessagebox(GetLanguage('messagebox_customdl.check_hash_success.caption'), GetLanguage('messagebox_customdl.check_hash_success.text'), MY_PASS, [mybutton.myOK]);
            end else begin
              MyMessagebox(GetLanguage('messagebox_customdl.check_hash_error.caption'), GetLanguage('messagebox_customdl.check_hash_error.text'), MY_ERROR, [mybutton.myOK]);
            end;
          end else begin
            MyMessagebox(GetLanguage('messagebox_customdl.custom_download_success.caption'), GetLanguage('messagebox_customdl.custom_download_success.text'), MY_PASS, [mybutton.myOK]);
          end;
        end else begin
          MyMessagebox(GetLanguage('messagebox_customdl.custom_download_error.caption'), GetLanguage('messagebox_customdl.custom_download_error.text'), MY_ERROR, [mybutton.myOK]);
        end;
      end).Start;
    end;
  end else begin
    TThread.CreateAnonymousThread(procedure begin
      form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.customdl.start_custom_download'));
      DownloadStart(url, path, '', mbiggest_thread, 0, 1);
      if FileExists(path) then begin
        if sha <> '' then begin
          if GetFileHash(path) = sha then begin
            MyMessagebox(GetLanguage('messagebox_customdl.check_hash_success.caption'), GetLanguage('messagebox_customdl.check_hash_success.text'), MY_PASS, [mybutton.myOK]);
          end else begin
            MyMessagebox(GetLanguage('messagebox_customdl.check_hash_error.caption'), GetLanguage('messagebox_customdl.check_hash_error.text'), MY_ERROR, [mybutton.myOK]);
          end;
        end else begin
          MyMessagebox(GetLanguage('messagebox_customdl.custom_download_success.caption'), GetLanguage('messagebox_customdl.custom_download_success.text'), MY_PASS, [mybutton.myOK]);
        end;
      end else begin
        MyMessagebox(GetLanguage('messagebox_customdl.custom_download_error.caption'), GetLanguage('messagebox_customdl.custom_download_error.text'), MY_ERROR, [mybutton.myOK]);
      end;
    end).Start;
  end;
end;
//保存路径编辑框输入
procedure ChangeSaveEdit;
begin
  mcustom_path := form_mainform.edit_custom_download_path.Text;
end;
//打开下载路径
procedure OpenSavePath;
begin
  if SysUtils.DirectoryExists(mcustom_path) then begin
    ShellExecute(Application.Handle, 'open', 'explorer.exe', pchar(mcustom_path), nil, SW_SHOWNORMAL);
  end else begin
    MyMessagebox(GetLanguage('messagebox_customdl.open_save_path_error.caption'), GetLanguage('messagebox_customdl.open_save_path_error.text'), MY_ERROR, [mybutton.myOK]);
  end;
end;
//修改保存路径
procedure ChangeSavePath;
begin
  if SelectDirectory(GetLanguage('selectdialog_customdl.select_save_path'), '', mcustom_path) then begin
    form_mainform.edit_custom_download_path.Text := mcustom_path;
  end;
end;
//初始化
procedure InitCustomDl;
begin
  mcustom_path := LLLini.ReadString('Version', 'SelectSaveDirectory', '');
  if (mcustom_path = '') or (not SysUtils.DirectoryExists(mcustom_path)) then begin
    mcustom_path := ExtractFileDir(Application.ExeName);
    LLLini.WriteString('Version', 'SelectSaveDirectory', mcustom_path)
  end;
  form_mainform.edit_custom_download_path.Text := mcustom_path;
end;
//保存
procedure SaveCustomDl;
begin
  if (mcustom_path = '') or (not SysUtils.DirectoryExists(mcustom_path)) then begin
    mcustom_path := '';
  end;
  LLLini.WriteString('Version', 'SelectSaveDirectory', mcustom_path)
end;

end.
