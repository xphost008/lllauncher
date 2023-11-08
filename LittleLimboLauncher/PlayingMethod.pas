unit PlayingMethod;

interface

uses
  JSON, Classes, SysUtils, System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent,
  Threading, ShellAPI, Forms, Windows, ClipBrd, Dialogs;

procedure InitPlaying;
procedure SavePlaying;
procedure PlayingOpenOciWeb();
procedure PlayingSelNameList;
procedure PlayingPageUpName();
procedure PlayingPageDownName();
procedure PlayingPageUpVer;
procedure PlayingPageDownVer;
procedure PlayingSelSource();
procedure PlayingSelMode();
procedure PlayingStartSearch();
procedure PlayingSelCateCurseforge();
procedure PlayingSelCateModrinth;
procedure PlayingOpenVerWeb;
procedure PlayingOpenIntro;
procedure PlayingSelVerList;
procedure PlayingDownload;

implementation
uses
  PrivacyMethod, MainForm, LanguageMethod, MyCustomWindow, MainMethod, ProgressMethod;

const
  BaseCURL = 'https://api.curseforge.com/v1';
  SearchCURL = 'https://api.curseforge.com/v1/mods/search?gameId=432&page_size=50&sortOrder=desc';
  BaseMURL = 'https://api.modrinth.com/v2';
  SearchMURL = 'https://api.modrinth.com/v2/search?limit=50&index=relevance';

var
  src, mode: Integer;
//  modname, vers, cate: String;
  cate: String;
  oset: Integer = 1;
  yset: Integer = 1;
  ModRoot: TJsonObject;
  VersionRoot: TJsonArray;
  SelectRoot: TJsonObject;
  ChooseRoot: TJsonObject;
//获取CurseForge的专属网页请求。
function GetCF(web: String): String;
begin
  var http := TNetHTTPClient.Create(nil);
  var ss := TStringStream.Create('', TEncoding.UTF8, False);
  try
    with http do begin
      AcceptCharSet := 'utf-8';
      AcceptEncoding := '65001';
      AcceptLanguage := 'en-US';
      ResponseTimeout := 200000;
      ConnectionTimeout := 200000;
      SendTimeout := 200000;
      SecureProtocols := [THTTPSecureProtocol.SSL3, THTTPSecureProtocol.TLS12, THTTPSecureProtocol.TLS13];
      HandleRedirects := True;
      ContentType := 'application/json;charset=utf-8';
      Accept := 'application/json';
      CustomHeaders['x-api-key'] := CF_API_KEY; //这里使用了私有函数中的CurseForge API KEY
      Get(web, ss);
      result := ss.DataString;
    end;
  except
    result := '';
  end;
end;
//开始查询
procedure SelWeb;
begin
  TTask.Run(procedure begin
    case src of
      1: begin
        form_mainform.label_playing_return_value.Caption := GetLanguage('label_playing_return_value.caption.get_curseforge_start');
        var post := Concat(searchCURL, '&index=', inttostr((oset - 1) * 50));
        if form_mainform.edit_playing_search_name.Text <> '' then post := Concat(post, '&searchFilter=', form_mainform.edit_playing_search_name.Text);
        case form_mainform.combobox_playing_search_mode.ItemIndex + 1 of
          1: begin
            post := Concat(post, '&classId=5');
            if strtoint(cate) <> 1 then begin
              case strtoint(cate) of
                2: post := Concat(post, '&categoryId=115');
                3: post := Concat(post, '&categoryId=116');
                4: post := Concat(post, '&categoryId=117');
                5: post := Concat(post, '&categoryId=122');
                6: post := Concat(post, '&categoryId=123');
                7: post := Concat(post, '&categoryId=124');
                8: post := Concat(post, '&categoryId=125');
                9: post := Concat(post, '&categoryId=126');
                10: post := Concat(post, '&categoryId=127');
                11: post := Concat(post, '&categoryId=128');
                12: post := Concat(post, '&categoryId=129');
                13: post := Concat(post, '&categoryId=130');
                14: post := Concat(post, '&categoryId=131');
                15: post := Concat(post, '&categoryId=132');
                16: post := Concat(post, '&categoryId=133');
                17: post := Concat(post, '&categoryId=134');
                18: post := Concat(post, '&categoryId=4672');
              end;
            end;
          end;
          2: begin
            post := Concat(post, '&classId=4471');
            if strtoint(cate) <> 1 then begin
              case strtoint(cate) of
                2: post := Concat(post, '&categoryId=4472');
                3: post := Concat(post, '&categoryId=4473');
                4: post := Concat(post, '&categoryId=4474');
                5: post := Concat(post, '&categoryId=4475');
                6: post := Concat(post, '&categoryId=4476');
                7: post := Concat(post, '&categoryId=4477');
                8: post := Concat(post, '&categoryId=4478');
                9: post := Concat(post, '&categoryId=4479');
                10: post := Concat(post, '&categoryId=4480');
                11: post := Concat(post, '&categoryId=4481');
                12: post := Concat(post, '&categoryId=4482');
                13: post := Concat(post, '&categoryId=4483');
                14: post := Concat(post, '&categoryId=4484');
              end;
            end;
          end;
          3: begin
            post := Concat(post, '&classId=6');
            if strtoint(cate) <> 1 then begin
              case strtoint(cate) of
                2: post := Concat(post, '&categoryId=407');
                3: post := Concat(post, '&categoryId=408');
                4: post := Concat(post, '&categoryId=409');
                5: post := Concat(post, '&categoryId=410');
                6: post := Concat(post, '&categoryId=411');
                7: post := Concat(post, '&categoryId=413');
                8: post := Concat(post, '&categoryId=414');
                9: post := Concat(post, '&categoryId=415');
                10: post := Concat(post, '&categoryId=416');
                11: post := Concat(post, '&categoryId=417');
                12: post := Concat(post, '&categoryId=418');
                13: post := Concat(post, '&categoryId=4843');
                14: post := Concat(post, '&categoryId=419');
                15: post := Concat(post, '&categoryId=420');
                16: post := Concat(post, '&categoryId=421');
                17: post := Concat(post, '&categoryId=422');
                18: post := Concat(post, '&categoryId=423');
                19: post := Concat(post, '&categoryId=424');
                20: post := Concat(post, '&categoryId=425');
                21: post := Concat(post, '&categoryId=427');
                22: post := Concat(post, '&categoryId=428');
                23: post := Concat(post, '&categoryId=429');
                24: post := Concat(post, '&categoryId=430');
                25: post := Concat(post, '&categoryId=432');
                26: post := Concat(post, '&categoryId=433');
                27: post := Concat(post, '&categoryId=4485');
                28: post := Concat(post, '&categoryId=4545');
                29: post := Concat(post, '&categoryId=4773');
                30: post := Concat(post, '&categoryId=5232');
                31: post := Concat(post, '&categoryId=5314');
                32: post := Concat(post, '&categoryId=6145');
                33: post := Concat(post, '&categoryId=434');
                34: post := Concat(post, '&categoryId=435');
                35: post := Concat(post, '&categoryId=436');
                36: post := Concat(post, '&categoryId=4558');
                37: post := Concat(post, '&categoryId=4671');
                38: post := Concat(post, '&categoryId=4906');
                39: post := Concat(post, '&categoryId=5191');
                40: post := Concat(post, '&categoryId=5299');
              end;
            end;
          end;
          4: begin
            post := Concat(post, '&classId=12');
            if strtoint(cate) <> 1 then begin
              case strtoint(cate) of
                2: post := Concat(post, '&categoryId=393');
                3: post := Concat(post, '&categoryId=394');
                4: post := Concat(post, '&categoryId=395');
                5: post := Concat(post, '&categoryId=396');
                6: post := Concat(post, '&categoryId=397');
                7: post := Concat(post, '&categoryId=398');
                8: post := Concat(post, '&categoryId=399');
                9: post := Concat(post, '&categoryId=400');
                10: post := Concat(post, '&categoryId=401');
                11: post := Concat(post, '&categoryId=402');
                12: post := Concat(post, '&categoryId=403');
                13: post := Concat(post, '&categoryId=404');
                14: post := Concat(post, '&categoryId=405');
                15: post := Concat(post, '&categoryId=4465');
                16: post := Concat(post, '&categoryId=5193');
                17: post := Concat(post, '&categoryId=5244');
              end;
            end;
          end;
          5: begin
            post := Concat(post, '&classId=17');
            if strtoint(cate) <> 1 then begin
              case strtoint(cate) of
                2: post := Concat(post, '&categoryId=248');
                3: post := Concat(post, '&categoryId=249');
                4: post := Concat(post, '&categoryId=250');
                5: post := Concat(post, '&categoryId=251');
                6: post := Concat(post, '&categoryId=252');
                7: post := Concat(post, '&categoryId=253');
                8: post := Concat(post, '&categoryId=4464');
              end;
            end;
          end;
          6: begin
            post := Concat(post, '&classId=4559');
            if strtoint(cate) <> 1 then begin
              case strtoint(cate) of
                2: post := Concat(post, '&categoryId=4561');
                3: post := Concat(post, '&categoryId=4562');
                4: post := Concat(post, '&categoryId=4560');
              end;
            end;
          end;
          7: begin
            post := Concat(post, '&classId=4546');
            if strtoint(cate) <> 1 then begin
              case strtoint(cate) of
                2: post := Concat(post, '&categoryId=4547');
                3: post := Concat(post, '&categoryId=5186');
                4: post := Concat(post, '&categoryId=4549');
                5: post := Concat(post, '&categoryId=4478');
                6: post := Concat(post, '&categoryId=4552');
              end;
            end;
          end;
          8: begin
            post := Concat(post, '&classId=6552');
            if strtoint(cate) <> 1 then begin
              case strtoint(cate) of
                2: post := Concat(post, '&categoryId=6554');
                3: post := Concat(post, '&categoryId=6553');
                4: post := Concat(post, '&categoryId=6555');
              end;
            end;
          end;
        end;
        if (form_mainform.combobox_playing_search_version.Text <> '') and (form_mainform.combobox_playing_search_version.Text <> '全部') and (form_mainform.combobox_playing_search_version.Text <> GetLanguage('combobox_playing_search_version.item.all')) then begin
          post := Concat(post, '&gameVersion=', form_mainform.combobox_playing_search_version.Text);
        end;
        form_mainform.listbox_playing_search_name.Items.Clear;
        form_mainform.listbox_playing_search_version.Items.Clear;
        form_mainform.label_playing_return_value.Caption := GetLanguage('label_playing_return_value.caption.is_searching');
        var md := GetCF(post);
        if md = '' then begin
          MyMessageBox(GetLanguage('messagebox_playing.get_curseforge_search_error.caption'), GetLanguage('messagebox_playing.get_curseforge_search_error.text'), MY_ERROR, [mybutton.myOK]);
          form_mainform.label_playing_return_value.Caption := GetLanguage('label_playing_return_value.caption.get_curseforge_search_error');
          exit;
        end;
        form_mainform.listbox_playing_search_name.Items.BeginUpdate;
        try
          ModRoot := TJSONObject.ParseJSONValue(md) as TJSONObject;
          var data := ModRoot.GetValue('data') as TJSONArray;
          for var I in data do begin
            var J := I as TJSONObject;
            form_mainform.listbox_playing_search_name.Items.Add(J.GetValue('name').Value);
          end;
          if form_mainform.listbox_playing_search_name.Items.Count = 0 then raise Exception.Create('No mod found');
          form_mainform.label_playing_return_value.Caption := GetLanguage('label_playing_return_value.caption.curseforge_search_finish');
          form_mainform.listbox_playing_search_name.Items.EndUpdate;
        except
          MyMessageBox(GetLanguage('messagebox_playing.get_curseforge_name_or_version_error.caption'), GetLanguage('messagebox_playing.get_curseforge_name_or_version_error.text'), MY_ERROR, [mybutton.myOK]);
          form_mainform.listbox_playing_search_name.Items.EndUpdate;
          form_mainform.label_playing_return_value.Caption := GetLanguage('label_playing_return_value.caption.get_curseforge_name_or_version_error');
          exit;
        end;
      end;
      2: begin
        form_mainform.label_playing_return_value.Caption := GetLanguage('label_playing_return_value.caption.get_modrinth_start');
        var post := Concat(SearchMURL, '&offset=', inttostr((oset - 1) * 50));
        if form_mainform.edit_playing_search_name.Text <> '' then post := Concat(post, '&query=', form_mainform.edit_playing_search_name.Text);
        post := Concat(post, '&facets=[');
        case form_mainform.combobox_playing_search_mode.ItemIndex + 1 of
          1: begin
            post := Concat(post, '["project_type:mod"]');
            for var I := 0 to form_mainform.checklistbox_playing_search_category_modrinth.Items.Count - 1 do begin
              if form_mainform.checklistbox_playing_search_category_modrinth.Checked[I] then begin
                case I of
                  0: post := Concat(post, ',["categories:adventure"]');
                  1: post := Concat(post, ',["categories:cursed"]');
                  2: post := Concat(post, ',["categories:decoration"]');
                  3: post := Concat(post, ',["categories:economy"]');
                  4: post := Concat(post, ',["categories:equipment"]');
                  5: post := Concat(post, ',["categories:food"]');
                  6: post := Concat(post, ',["categories:game-mechanics"]');
                  7: post := Concat(post, ',["categories:library"]');
                  8: post := Concat(post, ',["categories:magic"]');
                  9: post := Concat(post, ',["categories:management"]');
                  10: post := Concat(post, ',["categories:minigame"]');
                  11: post := Concat(post, ',["categories:mobs"]');
                  12: post := Concat(post, ',["categories:optimization"]');
                  13: post := Concat(post, ',["categories:social"]');
                  14: post := Concat(post, ',["categories:storage"]');
                  15: post := Concat(post, ',["categories:technology"]');
                  16: post := Concat(post, ',["categories:transportation"]');
                  17: post := Concat(post, ',["categories:utility"]');
                  18: post := Concat(post, ',["categories:worldgen"]');
                  19: post := Concat(post, ',["categories:fabric"]');
                  20: post := Concat(post, ',["categories:forge"]');
                  21: post := Concat(post, ',["categories:quilt"]');
                end;
              end;
            end;
          end;
          2: begin
            post := Concat(post, '["project_type:mod"]');
            for var I := 0 to form_mainform.checklistbox_playing_search_category_modrinth.Items.Count - 1 do begin
              if form_mainform.checklistbox_playing_search_category_modrinth.Checked[I] then begin
                case I of
                  0: post := Concat(post, ',["categories:adventure"]');
                  1: post := Concat(post, ',["categories:cursed"]');
                  2: post := Concat(post, ',["categories:decoration"]');
                  3: post := Concat(post, ',["categories:economy"]');
                  4: post := Concat(post, ',["categories:equipment"]');
                  5: post := Concat(post, ',["categories:food"]');
                  6: post := Concat(post, ',["categories:game-mechanics"]');
                  7: post := Concat(post, ',["categories:library"]');
                  8: post := Concat(post, ',["categories:magic"]');
                  9: post := Concat(post, ',["categories:management"]');
                  10: post := Concat(post, ',["categories:minigame"]');
                  11: post := Concat(post, ',["categories:mobs"]');
                  12: post := Concat(post, ',["categories:optimization"]');
                  13: post := Concat(post, ',["categories:social"]');
                  14: post := Concat(post, ',["categories:storage"]');
                  15: post := Concat(post, ',["categories:technology"]');
                  16: post := Concat(post, ',["categories:transportation"]');
                  17: post := Concat(post, ',["categories:utility"]');
                  18: post := Concat(post, ',["categories:worldgen"]');
                  19: post := Concat(post, ',["categories:bukkit"]');
                  20: post := Concat(post, ',["categories:paper"]');
                  21: post := Concat(post, ',["categories:purpur"]');
                  22: post := Concat(post, ',["categories:spigot"]');
                  23: post := Concat(post, ',["categories:sponge"]');
                end;
              end;
            end;
          end;
          3: begin
            post := Concat(post, '["project_type:mod"]');
            for var I := 0 to form_mainform.checklistbox_playing_search_category_modrinth.Items.Count - 1 do begin
              if form_mainform.checklistbox_playing_search_category_modrinth.Checked[I] then begin
                case I of
                  0: post := Concat(post, ',["categories:adventure"]');
                  1: post := Concat(post, ',["categories:cursed"]');
                  2: post := Concat(post, ',["categories:decoration"]');
                  3: post := Concat(post, ',["categories:economy"]');
                  4: post := Concat(post, ',["categories:equipment"]');
                  5: post := Concat(post, ',["categories:food"]');
                  6: post := Concat(post, ',["categories:game-mechanics"]');
                  7: post := Concat(post, ',["categories:library"]');
                  8: post := Concat(post, ',["categories:magic"]');
                  9: post := Concat(post, ',["categories:management"]');
                  10: post := Concat(post, ',["categories:minigame"]');
                  11: post := Concat(post, ',["categories:mobs"]');
                  12: post := Concat(post, ',["categories:optimization"]');
                  13: post := Concat(post, ',["categories:social"]');
                  14: post := Concat(post, ',["categories:storage"]');
                  15: post := Concat(post, ',["categories:technology"]');
                  16: post := Concat(post, ',["categories:transportation"]');
                  17: post := Concat(post, ',["categories:utility"]');
                  18: post := Concat(post, ',["categories:worldgen"]');
                end;
              end;
            end;
          end;
          4: begin
            post := Concat(post, '["project_type:shader"]');
            for var I := 0 to form_mainform.checklistbox_playing_search_category_modrinth.Items.Count - 1 do begin
              if form_mainform.checklistbox_playing_search_category_modrinth.Checked[I] then begin
                case I of
                  0: post := Concat(post, ',["categories:cartoon"]');
                  1: post := Concat(post, ',["categories:cursed"]');
                  2: post := Concat(post, ',["categories:fantasy"]');
                  3: post := Concat(post, ',["categories:realistic"]');
                  4: post := Concat(post, ',["categories:semi-realistic"]');
                  5: post := Concat(post, ',["categories:vanilla-like"]');
                  6: post := Concat(post, ',["categories:atmosphere"]');
                  7: post := Concat(post, ',["categories:bloom"]');
                  8: post := Concat(post, ',["categories:colored-lighting"]');
                  9: post := Concat(post, ',["categories:foliage"]');
                  10: post := Concat(post, ',["categories:path-tracing"]');
                  11: post := Concat(post, ',["categories:pbr"]');
                  12: post := Concat(post, ',["categories:reflections"]');
                  13: post := Concat(post, ',["categories:shadows"]');
                  14: post := Concat(post, ',["categories:potato"]');
                  15: post := Concat(post, ',["categories:low"]');
                  16: post := Concat(post, ',["categories:medium"]');
                  17: post := Concat(post, ',["categories:high"]');
                  18: post := Concat(post, ',["categories:screenshot"]');
                  19: post := Concat(post, ',["categories:canvas"]');
                  20: post := Concat(post, ',["categories:iris"]');
                  21: post := Concat(post, ',["categories:optifine"]');
                  22: post := Concat(post, ',["categories:vanilla"]');
                end;
              end;
            end;
          end;
          5: begin
            post := Concat(post, '["project_type:resourcepack"]');
            for var I := 0 to form_mainform.checklistbox_playing_search_category_modrinth.Items.Count - 1 do begin
              if form_mainform.checklistbox_playing_search_category_modrinth.Checked[I] then begin
                case I of
                  0: post := Concat(post, ',["categories:combat"]');
                  1: post := Concat(post, ',["categories:cursed"]');
                  2: post := Concat(post, ',["categories:decoration"]');
                  3: post := Concat(post, ',["categories:modded"]');
                  4: post := Concat(post, ',["categories:realistic"]');
                  5: post := Concat(post, ',["categories:simplistic"]');
                  6: post := Concat(post, ',["categories:themed"]');
                  7: post := Concat(post, ',["categories:tweaks"]');
                  8: post := Concat(post, ',["categories:utility"]');
                  9: post := Concat(post, ',["categories:vanilla-like"]');
                  10: post := Concat(post, ',["categories:audio"]');
                  11: post := Concat(post, ',["categories:blocks"]');
                  12: post := Concat(post, ',["categories:core-shaders"]');
                  13: post := Concat(post, ',["categories:entities"]');
                  14: post := Concat(post, ',["categories:environment"]');
                  15: post := Concat(post, ',["categories:equipment"]');
                  16: post := Concat(post, ',["categories:fonts"]');
                  17: post := Concat(post, ',["categories:gui"]');
                  18: post := Concat(post, ',["categories:items"]');
                  19: post := Concat(post, ',["categories:locale"]');
                  20: post := Concat(post, ',["categories:models"]');
                  21: post := Concat(post, ',["categories:8x-"]');
                  22: post := Concat(post, ',["categories:16x"]');
                  23: post := Concat(post, ',["categories:32x"]');
                  24: post := Concat(post, ',["categories:48x"]');
                  25: post := Concat(post, ',["categories:64x"]');
                  26: post := Concat(post, ',["categories:128x"]');
                  27: post := Concat(post, ',["categories:256x"]');
                  28: post := Concat(post, ',["categories:''512x%2B''"]');
                end;
              end;
            end;
          end;
          6: begin
            post := Concat(post, '["project_type:modpack"]');
            for var I := 0 to form_mainform.checklistbox_playing_search_category_modrinth.Items.Count - 1 do begin
              if form_mainform.checklistbox_playing_search_category_modrinth.Checked[I] then begin
                case I of
                  0: post := Concat(post, ',["categories:adventure"]');
                  1: post := Concat(post, ',["categories:challenging"]');
                  2: post := Concat(post, ',["categories:combat"]');
                  3: post := Concat(post, ',["categories:kitchen-sink"]');
                  4: post := Concat(post, ',["categories:lightweight"]');
                  5: post := Concat(post, ',["categories:magic"]');
                  6: post := Concat(post, ',["categories:multiplayer"]');
                  7: post := Concat(post, ',["categories:optimization"]');
                  8: post := Concat(post, ',["categories:quests"]');
                  9: post := Concat(post, ',["categories:technology"]');
                  10: post := Concat(post, ',["categories:fabric"]');
                  11: post := Concat(post, ',["categories:forge"]');
                  12: post := Concat(post, ',["categories:quilt"]');
                end;
              end;
            end;
          end;
        end;
        if (form_mainform.combobox_playing_search_version.Text <> '') and (form_mainform.combobox_playing_search_version.Text <> GetLanguage('combobox_playing_search_version.item.all')) and (form_mainform.combobox_playing_search_version.Text <> '全部') then begin
          post := Concat(post, ',["versions:', form_mainform.combobox_playing_search_version.Text, '"]');
        end;
        post := Concat(post, ']');
        ClipBoard.SetTextBuf(pchar(post));
        form_mainform.listbox_playing_search_name.Items.Clear;
        form_mainform.listbox_playing_search_name.Items.Clear;
        var md := GetWebText(post);
        if md = '' then begin
          MyMessageBox(GetLanguage('messagebox_playing.get_modrinth_search_error.caption'), GetLanguage('messagebox_playing.get_modrinth_search_error.text'), MY_ERROR, [mybutton.myOK]);
          form_mainform.label_playing_return_value.Caption := GetLanguage('label_playing_return_value.caption.get_modrinth_search_error');
          exit;
        end;
        form_mainform.listbox_playing_search_name.Items.BeginUpdate;
        try
          ModRoot := TJSONObject.ParseJSONValue(md) as TJSONObject;
          var hits := ModRoot.GetValue('hits') as TJSONArray;
          for var I in hits do begin
            var J := I as TJSONObject;
            form_mainform.listbox_playing_search_name.Items.Add(J.GetValue('title').Value);
          end;
          if form_mainform.listbox_playing_search_name.Items.Count = 0 then raise Exception.Create('No mod found');
          form_mainform.label_playing_return_value.Caption := GetLanguage('label_playing_return_value.caption.modrinth_search_finish');
          form_mainform.listbox_playing_search_name.Items.EndUpdate;
        except
          MyMessageBox(GetLanguage('messagebox_playing.get_modrinth_name_or_version_error.caption'), GetLanguage('messagebox_playing.get_modrinth_name_or_version_error.text'), MY_ERROR, [mybutton.myOK]);
          form_mainform.listbox_playing_search_name.Items.EndUpdate;
          form_mainform.label_playing_return_value.Caption := GetLanguage('label_playing_return_value.caption.get_modrinth_name_or_version_error');
          exit;
        end;
      end;
    end;
  end);
end;
//下载玩法
procedure PlayingDownload;
begin
  if form_mainform.listbox_playing_search_version.ItemIndex <> -1 then begin
    var fnme := '';
    var furl := '';
    if src = 2 then begin
      var frt := ((ChooseRoot.GetValue('files') as TJsonArray)[0] as TJsonObject);
      furl := frt.GetValue('url').Value;
      fnme := frt.GetValue('filename').Value;
    end else begin
      furl := ChooseRoot.GetValue('downloadUrl').Value;
      fnme := ChooseRoot.GetValue('fileName').Value;
    end;
    var od := TSaveDialog.Create(nil);
    od.Filter := '*.*|*.*';
    od.Title := GetLanguage('opendialog_playing.download_dialog.title');
    od.FileName := fnme;
    if od.Execute() then begin
      if FileExists(od.FileName) then begin
        MyMessagebox(GetLanguage('messagebox_playing.file_exists_download_error.caption'), GetLanguage('messagebox_playing.file_exists_download_error.text'), MY_ERROR, [mybutton.myYes]);
        exit;
      end;
      form_mainform.pagecontrol_mainpage.ActivePage := form_mainform.tabsheet_download_progress_part;
      TTask.Run(procedure begin
        form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.playing.start_download'));
        DownloadStart(furl, od.FileName, '', mbiggest_thread, 0, 1);
        form_mainform.listbox_progress_download_list.ItemIndex := form_mainform.listbox_progress_download_list.Items.Add(GetLanguage('downloadlist.playing.download_success'));
        MyMessagebox(GetLanguage('messagebox_playing.download_playing_success.caption'), GetLanguage('messagebox_playing.download_playing_success.text'), MY_PASS, [mybutton.myYes]);
      end);
    end;
  end else begin
    MyMessagebox(GetLanguage('messagebox_playing.no_version_download_error.caption'), GetLanguage('messagebox_playing.no_version_download_error.text'), MY_ERROR, [mybutton.myYes]);
  end;
end;
//选择curseforge或者modrinth
procedure SelBox(i: Byte);
begin
  case i of
    1: begin
      form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge.all'));
      case form_mainform.combobox_playing_search_mode.ItemIndex + 1 of
        1: begin
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_bukkitplugins.admin_tools'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_bukkitplugins.anti-griefing_tools'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_bukkitplugins.chat_related'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_bukkitplugins.developed_tools'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_bukkitplugins.economy'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_bukkitplugins.world_editing_and_management'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_bukkitplugins.fixes'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_bukkitplugins.fun'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_bukkitplugins.general'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_bukkitplugins.informational'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_bukkitplugins.mechanics'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_bukkitplugins.website_administration'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_bukkitplugins.world_generators'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_bukkitplugins.role_playing'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_bukkitplugins.miscellaneous'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_bukkitplugins.teleportation'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_bukkitplugins.twitch_integration'));
        end;
        2: begin
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_modpacks.tech'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_modpacks.magic'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_modpacks.sci-fi'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_modpacks.adventure_and_rpg'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_modpacks.exploration'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_modpacks.mini_game'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_modpacks.quests'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_modpacks.hardcore'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_modpacks.map_based'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_modpacks.small_/_light'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_modpacks.extra_large'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_modpacks.combat_/_pvp'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_modpacks.multiplayer'));
        end;
        3: begin
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.biomes'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.ores_and_resources'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.structures'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.dimensions'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.mobs'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.processing'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.player_transport'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.energy,_fluid,_and_item_transport'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.farming'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.energy'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.genetics'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.automation'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.magic'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.storage'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.api_and_library'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.adventure_and_rpg'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.map_and_information'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.cosmetic'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.miscellaneous'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.thermal_expansion'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.tinker''_s_construct'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.industrial_craft'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.thaumcraft'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.buildcraft'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.forestry'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.blood_magic'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.applied_energistics_2'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.craftTweaker'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.galacticraft'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.kubeJS'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.skyblock'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.armor,_tools,_and_weapons'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.server_utility'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.food'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.redstone'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.twitch_integration'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.mCreator'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.utility_&_qoL'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods.education'));
        end;
        4: begin
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_resourcepacks.16x'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_resourcepacks.32x'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_resourcepacks.64x'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_resourcepacks.128x'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_resourcepacks.256x'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_resourcepacks.512x'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_resourcepacks.steampunk'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_resourcepacks.photo_realistic'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_resourcepacks.modern'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_resourcepacks.medieval'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_resourcepacks.traditional'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_resourcepacks.animated'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_resourcepacks.miscellaneous'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_resourcepacks.mod_support'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_resourcepacks.data_packs'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_resourcepacks.font_packs'));
        end;
        5: begin
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_worlds.adventure'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_worlds.creation'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_worlds.game_map'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_worlds.parkour'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_worlds.puzzle'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_worlds.survival'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_worlds.modded_world'));
        end;
        6: begin
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_addons.resource_packs'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_addons.scenarios'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_addons.worlds'));
        end;
        7: begin
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_customization.configuration'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_customization.fancyMenu'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_customization.guidebook'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_customization.quests'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_customization.scripts'));
        end;
        8: begin
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_shaders.fantasy'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_shaders.realistic'));
          form_mainform.combobox_playing_search_category_curseforge.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_shaders.vanilla'));
        end;
      end;
    end;
    2: begin
      case form_mainform.combobox_playing_search_mode.ItemIndex + 1 of
        1: begin
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_mods.adventure'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_mods.cursed'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_mods.decoration'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_mods.economy'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_mods.equipment'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_mods.food'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_mods.game_mechanics'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_mods.library'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_mods.magic'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_mods.management'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_mods.minigame'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_mods.mobs'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_mods.optimization'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_mods.social'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_mods.storage'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_mods.technology'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_mods.transportation'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_mods.utility'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_mods.world_generation'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_mods.fabric'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_mods.forge'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_mods.liteLoader'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_mods.risugami_s_modLoader'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_mods.neoForge'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_mods.quilt'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_mods.rift'));
        end;
        2: begin
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_plugins.adventure'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_plugins.cursed'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_plugins.decoration'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_plugins.economy'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_plugins.equipment'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_plugins.food'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_plugins.game_mechanics'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_plugins.library'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_plugins.magic'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_plugins.management'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_plugins.minigame'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_plugins.mobs'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_plugins.optimization'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_plugins.social'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_plugins.storage'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_plugins.technology'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_plugins.transportation'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_plugins.utility'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_plugins.world_generation'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_plugins.bukkit'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_plugins.folia'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_plugins.paper'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_plugins.purpur'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_plugins.spigot'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_plugins.sponge'));
        end;
        3: begin
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_datapacks.adventure'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_datapacks.cursed'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_datapacks.decoration'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_datapacks.economy'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_datapacks.equipment'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_datapacks.food'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_datapacks.game_mechanics'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_datapacks.library'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_datapacks.magic'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_datapacks.management'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_datapacks.minigame'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_datapacks.mobs'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_datapacks.optimization'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_datapacks.social'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_datapacks.storage'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_datapacks.technology'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_datapacks.transportation'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_datapacks.utility'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_datapacks.world_generation'));
        end;
        4: begin
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_shaders.cartoon'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_shaders.cursed'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_shaders.fantasy'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_shaders.realistic'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_shaders.semi-realistic'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_shaders.vanilla-like'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_shaders.atomsphere'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_shaders.bloom'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_shaders.colored_light'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_shaders.foliage'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_shaders.path_tracing'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_shaders.PBR'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_shaders.reflections'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_shaders.shadows'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_shaders.potato'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_shaders.low'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_shaders.medium'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_shaders.high'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_shaders.screenshot'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_shaders.canvas'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_shaders.iris'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_shaders.optiFine'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_shaders.vanilla'));
        end;
        5: begin
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_resourcepacks.combat'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_resourcepacks.cursed'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_resourcepacks.decoration'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_resourcepacks.modded'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_resourcepacks.realistic'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_resourcepacks.simplistic'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_resourcepacks.themed'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_resourcepacks.tweaks'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_resourcepacks.utility'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_resourcepacks.vanilla-like'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_resourcepacks.audio'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_resourcepacks.blocks'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_resourcepacks.core_shaders'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_resourcepacks.entities'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_resourcepacks.environment'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_resourcepacks.equipment'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_resourcepacks.fonts'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_resourcepacks.GUI'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_resourcepacks.items'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_resourcepacks.locale'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_resourcepacks.models'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_resourcepacks.8x_or_lower'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_resourcepacks.16x'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_resourcepacks.32x'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_resourcepacks.48x'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_resourcepacks.64x'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_resourcepacks.128x'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_resourcepacks.256x'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_resourcepacks.512x_or_higher'));
        end;
        6: begin
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_modpacks.adventure'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_modpacks.challenging'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_modpacks.combat'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_modpacks.kitchen_sink'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_modpacks.lightweight'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_modpacks.magic'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_modpacks.multiplayer'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_modpacks.optimization'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_modpacks.quests'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_modpacks.technology'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_modpacks.fabric'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_modpacks.forge'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_modpacks.neoForge'));
          form_mainform.checklistbox_playing_search_category_modrinth.Items.Add(GetLanguage('checklistbox_playing_search_mode.item.modrinth_modpacks.quilt'));
        end;
      end;
    end;
    3: begin
      form_mainform.combobox_playing_search_mode.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_bukkitplugins'));
      form_mainform.combobox_playing_search_mode.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_modpacks'));
      form_mainform.combobox_playing_search_mode.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_mods'));
      form_mainform.combobox_playing_search_mode.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_resourcepacks'));
      form_mainform.combobox_playing_search_mode.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_worlds'));
      form_mainform.combobox_playing_search_mode.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_addons'));
      form_mainform.combobox_playing_search_mode.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_customization'));
      form_mainform.combobox_playing_search_mode.Items.Add(GetLanguage('combobox_playing_search_mode.item.curseforge_shader'));
    end;
    4: begin
      form_mainform.combobox_playing_search_mode.Items.Add(GetLanguage('combobox_playing_search_mode.item.modrinth_mods'));
      form_mainform.combobox_playing_search_mode.Items.Add(GetLanguage('combobox_playing_search_mode.item.modrinth_plugins'));
      form_mainform.combobox_playing_search_mode.Items.Add(GetLanguage('combobox_playing_search_mode.item.modrinth_data_packs'));
      form_mainform.combobox_playing_search_mode.Items.Add(GetLanguage('combobox_playing_search_mode.item.modrinth_shaders'));
      form_mainform.combobox_playing_search_mode.Items.Add(GetLanguage('combobox_playing_search_mode.item.modrinth_resource_packs'));
      form_mainform.combobox_playing_search_mode.Items.Add(GetLanguage('combobox_playing_search_mode.item.modrinth_modpacks'));
    end;
  end;
end;
//打开该玩法的官网。
procedure PlayingOpenVerWeb;
begin
  if form_mainform.listbox_playing_search_name.ItemIndex <> -1 then begin
    if src = 2 then begin
      var slug := SelectRoot.GetValue('slug').Value;
      var url := Concat('https://modrinth.com/', SelectRoot.GetValue('project_type').Value, '/', slug);
      ShellExecute(Application.Handle, nil, pchar(url), nil, nil, SW_SHOWNORMAL);
    end else begin
      var slug := SelectRoot.GetValue('slug').Value;
      var url := '';
      case mode of
        1: url := Concat('https://www.curseforge.com/minecraft/bukkit-plugins/', slug);
        2: url := Concat('https://www.curseforge.com/minecraft/modpacks/', slug);
        3: url := Concat('https://www.curseforge.com/minecraft/mc-mods/', slug);
        4: url := Concat('https://www.curseforge.com/minecraft/texture-packs/', slug);
        5: url := Concat('https://www.curseforge.com/minecraft/worlds/', slug);
        6: url := Concat('https://www.curseforge.com/minecraft/mc-addons/', slug);
        7: url := Concat('https://www.curseforge.com/minecraft/customization/', slug);
        8: url := Concat('https://www.curseforge.com/minecraft/shaders/', slug);
        else exit;
      end;
      ShellExecute(Application.Handle, nil, pchar(url), nil, nil, SW_SHOWNORMAL);
    end;
  end else begin
    MyMessagebox(GetLanguage('messagebox_playing.not_choose_mod_error.caption'), GetLanguage('messagebox_playing.not_choose_mod_error.text'), MY_ERROR, [mybutton.myYes]);
  end;
end;
//在点击名称列表框的时候，搜索版本的方法。
procedure SelVer();
begin
  case src of
    1: begin
      SelectRoot := (ModRoot.GetValue('data') as TJSONArray)[form_mainform.listbox_playing_search_name.ItemIndex] as TJSONObject;
      var mid := SelectRoot.GetValue('id').Value;
      mid := GetCF(Concat(BaseCURL, '/mods/', mid, '/files?pageSize=50&index=', inttostr((yset - 1) * 50)));
      if mid = '' then begin
        MyMessagebox(GetLanguage('messagebox_playing.get_curseforge_page_error.caption'), GetLanguage('messagebox_playing.get_curseforge_page_error.text'), MY_ERROR, [mybutton.myOK]);
        exit;
      end;
      var trt := TJSONObject.ParseJSONValue(mid) as TJSONObject;
      VersionRoot := trt.GetValue('data') as TJSONArray;
      form_mainform.listbox_playing_search_version.Items.Clear;
      form_mainform.listbox_playing_search_version.Items.BeginUpdate;
      for var I in VersionRoot do
        form_mainform.listbox_playing_search_version.Items.Add((I as TJsonObject).GetValue('fileName').Value);
      form_mainform.listbox_playing_search_version.Items.EndUpdate;
    end;
    2: begin
      SelectRoot := (ModRoot.GetValue('hits') as TJSONArray)[form_mainform.listbox_playing_search_name.ItemIndex] as TJSONObject;
      var vsr := SelectRoot.GetValue('slug').Value;
      vsr := GetWebText(Concat(BaseMURL, '/project/', vsr, '/version'));
      if vsr = '' then begin
        MyMessagebox(GetLanguage('messagebox_playing.get_modrinth_page_error.caption'), GetLanguage('messagebox_playing.get_modrinth_page_error.text'), MY_ERROR, [mybutton.myOK]);
        exit;
      end;
      VersionRoot := TJsonObject.ParseJSONValue(vsr) as TJsonArray;
      form_mainform.listbox_playing_search_version.Items.Clear;
      form_mainform.listbox_playing_search_version.Items.BeginUpdate;
      for var I in VersionRoot do
        form_mainform.listbox_playing_search_version.Items.Add((((I as TJsonObject).GetValue('files') as TJsonArray)[0] as TJsonObject).GetValue('filename').Value);
      form_mainform.listbox_playing_search_version.Items.EndUpdate;
    end;
  end;
end;
//打开选择的官网：
procedure PlayingOpenOciWeb();
begin
  var web := '';
  if (form_mainform.combobox_playing_search_source.ItemIndex = 0) and (form_mainform.combobox_playing_search_mode.ItemIndex = 0) then
    web := 'https://www.curseforge.com/minecraft/bukkit-plugins'
  else if (form_mainform.combobox_playing_search_source.ItemIndex = 0) and (form_mainform.combobox_playing_search_mode.ItemIndex = 1) then
    web := 'https://www.curseforge.com/minecraft/modpacks'
  else if (form_mainform.combobox_playing_search_source.ItemIndex = 0) and (form_mainform.combobox_playing_search_mode.ItemIndex = 2) then
    web := 'https://www.curseforge.com/minecraft/mc-mods'
  else if (form_mainform.combobox_playing_search_source.ItemIndex = 0) and (form_mainform.combobox_playing_search_mode.ItemIndex = 3) then
    web := 'https://www.curseforge.com/minecraft/texture-packs'
  else if (form_mainform.combobox_playing_search_source.ItemIndex = 0) and (form_mainform.combobox_playing_search_mode.ItemIndex = 4) then
    web := 'https://www.curseforge.com/minecraft/worlds'
  else if (form_mainform.combobox_playing_search_source.ItemIndex = 0) and (form_mainform.combobox_playing_search_mode.ItemIndex = 5) then
    web := 'https://www.curseforge.com/minecraft/add-ons'
  else if (form_mainform.combobox_playing_search_source.ItemIndex = 0) and (form_mainform.combobox_playing_search_mode.ItemIndex = 6) then
    web := 'https://www.curseforge.com/minecraft/customization'
  else if (form_mainform.combobox_playing_search_source.ItemIndex = 0) and (form_mainform.combobox_playing_search_mode.ItemIndex = 7) then
    web := 'https://www.curseforge.com/minecraft/shaders'
  else if (form_mainform.combobox_playing_search_source.ItemIndex = 1) and (form_mainform.combobox_playing_search_mode.ItemIndex = 0) then
    web := 'https://modrinth.com/mods'
  else if (form_mainform.combobox_playing_search_source.ItemIndex = 1) and (form_mainform.combobox_playing_search_mode.ItemIndex = 1) then
    web := 'https://modrinth.com/plugins'
  else if (form_mainform.combobox_playing_search_source.ItemIndex = 1) and (form_mainform.combobox_playing_search_mode.ItemIndex = 2) then
    web := 'https://modrinth.com/datapacks'
  else if (form_mainform.combobox_playing_search_source.ItemIndex = 1) and (form_mainform.combobox_playing_search_mode.ItemIndex = 3) then
    web := 'https://modrinth.com/shaders'
  else if (form_mainform.combobox_playing_search_source.ItemIndex = 1) and (form_mainform.combobox_playing_search_mode.ItemIndex = 4) then
    web := 'https://modrinth.com/resourcepacks'
  else if (form_mainform.combobox_playing_search_source.ItemIndex = 1) and (form_mainform.combobox_playing_search_mode.ItemIndex = 5) then
    web := 'https://modrinth.com/modpacks'
  else exit;
  ShellExecute(Application.Handle, nil, pchar(web), nil, nil, SW_SHOWNORMAL)
end;
procedure PlayingSelVerList;
begin
  if (form_mainform.listbox_playing_search_version.ItemIndex <> -1) then begin
    form_mainform.listbox_playing_search_version.Hint := form_mainform.listbox_playing_search_version.Items[form_mainform.listbox_playing_search_version.ItemIndex];
    ChooseRoot := VersionRoot[form_mainform.listbox_playing_search_version.ItemIndex] as TJsonObject;
  end;
end;
function JudgeException(index: Integer; key: String): String;
begin
  try
    case index of
      1: begin
        var sel := SelectRoot.GetValue(key).Value;
        if sel = '12' then result := 'resourcepack'
        else if sel = '17' then result := 'map'
        else if sel = '4471' then result := 'modpack'
        else if sel = '5' then result := 'bukkit-plugin'
        else if sel = '6' then result := 'mod'
        else raise Exception.Create('No Result');
      end;
      2: result := SelectRoot.GetValue(key).Value;
      3: result := ChooseRoot.GetValue(key).Value;
      4: result := ChooseRoot.GetValue(key).Format;
      5: begin
        var trt := TJsonArray.Create;
        var r := SelectRoot.GetValue(key) as TJsonArray;
        for var o in r do begin
          var j := o as TJsonObject;
          trt.Add(j.GetValue('name').Value);
        end;
        result := trt.Format;
      end;
      6: begin
        var sel := ChooseRoot.GetValue(key).Value;
        if sel = '1' then result := 'Release'
        else if sel = '2' then result := 'Beta'
        else if sel = '3' then result := 'Alpha';
      end;
      7: begin
        var sel := SelectRoot.GetValue(key).ToString;
        var tt := TJsonArray.Create;
        for var J in TJsonArray.ParseJSONValue(sel) as TJsonArray do begin
          var K := J as TJsonObject;
          tt.Add(K.GetValue('name').Value);
        end;
        result := tt.Format;
      end;
      8: result := SelectRoot.GetValue(key).Format;
      9: result := ((SelectRoot.GetValue('latestFilesIndexes') as TJsonArray)[0] as TJsonObject).GetValue(key).Value;
    end;
  except
    result := '暂无数据';
  end;
end;
procedure PlayingOpenIntro;
begin
  if form_mainform.listbox_playing_search_version.ItemIndex <> -1 then begin
    if src = 2 then begin
      var icourl := JudgeException(2, 'icon_url');
      var icoss := GetWebStream(icourl);
      MyPictureBox(JudgeException(2, 'title'),
        GetLanguage('mypicturebox_playing.open_modrinth_intro_success.text')
            .Replace('${project_id}', JudgeException(2, 'project_id'))
            .Replace('${project_type}', JudgeException(2, 'project_type'))
            .Replace('${slug}', JudgeException(2, 'slug'))
            .Replace('${title}', JudgeException(2, 'title'))
            .Replace('${author}', JudgeException(2, 'author'))
            .Replace('${description}', JudgeException(2, 'description'))
            .Replace('${categories}', JudgeException(8, 'categories'))
            .Replace('${p_downloads}', JudgeException(2, 'downloads'))
            .Replace('${follows}', JudgeException(2, 'follows'))
            .Replace('${date_created}', JudgeException(2, 'date_created'))
            .Replace('${date_modified}', JudgeException(2, 'date_modified'))
            .Replace('${latest_version}', JudgeException(2, 'latest_version'))
            .Replace('${license}', JudgeException(2, 'license'))
            .Replace('${id}', JudgeException(3, 'id'))
            .Replace('${name}', JudgeException(3, 'name'))
            .Replace('${version_number}', JudgeException(3, 'version_number'))
            .Replace('${downloads}', JudgeException(3, 'downloads'))
            .Replace('${version_type}', JudgeException(3, 'version_type'))
            .Replace('${date_published}', JudgeException(3, 'date_published'))
            .Replace('${game_versions}', JudgeException(4, 'game_versions'))
            .Replace('${loaders}', JudgeException(4, 'loaders'))
            .Replace('${changelog}', JudgeException(3, 'changelog'))
      , icoss);
    end else begin
      var icourl := '';
      var icoss: TStringStream := nil;
      try
        icourl := (SelectRoot.GetValue('logo') as TJsonObject).GetValue('thumbnailUrl').Value;
        icoss := GetWebStream(icourl);
      except end;
      var t := ((SelectRoot.GetValue('latestFilesIndexes') as TJsonArray)[0] as TJsonObject).GetValue('gameVersion').Value;
      MyPictureBox(JudgeException(2, 'name'),
        GetLanguage('mypicturebox_playing.open_curseforge_intro_success.text')
            .Replace('${p_id}', JudgeException(2, 'id'))
            .Replace('${classId}', JudgeException(1, 'classId'))
            .Replace('${slug}', JudgeException(2, 'slug'))
            .Replace('${name}', JudgeException(2, 'name'))
            .Replace('${authors}', JudgeException(5, 'authors'))
            .Replace('${summary}', JudgeException(2, 'summary'))
            .Replace('${categories}', JudgeException(7, 'categories'))
            .Replace('${p_downloadCount}', JudgeException(2, 'downloadCount'))
//            .Replace('${follows}', JudgeException(2, 'follows'))
            .Replace('${dateCreated}', JudgeException(2, 'dateCreated'))
            .Replace('${dateModified}', JudgeException(2, 'dateModified'))
            .Replace('${gameVersion}', JudgeException(9, 'gameVersion'))
//            .Replace('${license}', JudgeException(9, 'license'))
            .Replace('${id}', JudgeException(3, 'id'))
            .Replace('${fileName}', JudgeException(3, 'fileName'))
            .Replace('${displayName}', JudgeException(3, 'displayName'))
            .Replace('${downloadCount}', JudgeException(3, 'downloadCount'))
            .Replace('${releaseType}', JudgeException(6, 'releaseType'))
            .Replace('${fileDate}', JudgeException(3, 'fileDate'))
            .Replace('${gameVersions}', JudgeException(4, 'gameVersions'))
//            .Replace('${loaders}', JudgeException(4, 'loaders'))
//            .Replace('${changelog}', JudgeException(3, 'changelog'))
      , icoss);
    end;
  end else begin
    MyMessagebox(GetLanguage('messagebox_playing.open_intro_error.caption'), GetLanguage('messagebox_playing.open_intro_error.text'), MY_ERROR, [mybutton.myOK]);
  end;
end;
//名称列表框点击
procedure PlayingSelNameList;
begin
  if (form_mainform.listbox_playing_search_name.Items.Count <> 0) and (form_mainform.listbox_playing_search_name.ItemIndex <> -1) then begin
    form_mainform.listbox_playing_search_name.Hint := form_mainform.listbox_playing_search_name.Items[form_mainform.listbox_playing_search_name.ItemIndex];
    yset := 1;
    SelVer;
  end;
end;
//版本：上一页
procedure PlayingPageUpVer;
begin
  if yset <= 1 then begin
    MyMessagebox(GetLanguage('messagebox_playing.version_pageup_error.caption'), GetLanguage('messagebox_playing.version_pageup_error.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  dec(yset);
  SelVer;
  form_mainform.label_playing_search_version.Caption := GetLanguage('label_playing_search_version.caption.page').Replace('${page}', inttostr(yset));
end;
//版本：下一页
procedure PlayingPageDownVer;
begin
  if form_mainform.listbox_playing_search_version.Count < 50 then begin
    MyMessagebox(GetLanguage('messagebox_playing.version_pagedown_error.caption'), GetLanguage('messagebox_playing.version_pagedown_error.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  inc(yset);
  SelVer;
  form_mainform.label_playing_search_version.Caption := GetLanguage('label_playing_search_version.caption.page').Replace('${page}', inttostr(yset));
end;
//名称：上一页
procedure PlayingPageUpName();
begin
  if oset <= 1 then begin
    MyMessagebox(GetLanguage('messagebox_playing.name_pageup_error.caption'), GetLanguage('messagebox_playing.name_pageup_error.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  dec(oset);
  SelWeb;
  form_mainform.label_playing_search_name.Caption := GetLanguage('label_playing_search_name.caption.page').Replace('${page}', inttostr(oset));
end;
//名称：下一页
procedure PlayingPageDownName();
begin
  if form_mainform.listbox_playing_search_name.Items.Count < 50 then begin
    MyMessagebox(GetLanguage('messagebox_playing.name_pagedown_error.caption'), GetLanguage('messagebox_playing.name_pagedown_error.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  inc(oset);
  SelWeb;
  form_mainform.label_playing_search_name.Caption := GetLanguage('label_playing_search_name.caption.page').Replace('${page}', inttostr(oset));
end;
//搜索源下拉框选择
procedure PlayingSelSource();
begin
  form_mainform.combobox_playing_search_mode.Items.Clear;
  form_mainform.combobox_playing_search_category_curseforge.Items.Clear;
  form_mainform.checklistbox_playing_search_category_modrinth.Items.Clear;
  case form_mainform.combobox_playing_search_source.ItemIndex + 1 of
    1: begin
      form_mainform.checklistbox_playing_search_category_modrinth.Enabled := false;
      form_mainform.combobox_playing_search_category_curseforge.Enabled := true;
      SelBox(3);
    end;
    2: begin
      form_mainform.checklistbox_playing_search_category_modrinth.Enabled := true;
      form_mainform.combobox_playing_search_category_curseforge.Enabled := false;
      SelBox(4);
    end;
  end;
  form_mainform.combobox_playing_search_mode.ItemIndex := 0;
  PlayingSelMode;
end;
//搜索方式下拉框选择
procedure PlayingSelMode();
begin
  form_mainform.combobox_playing_search_category_curseforge.Items.Clear;
  form_mainform.checklistbox_playing_search_category_modrinth.Items.Clear;
  case form_mainform.combobox_playing_search_source.ItemIndex + 1 of
    1: begin
      SelBox(1);
      cate := '1';
      form_mainform.combobox_playing_search_category_curseforge.ItemIndex := 0;
    end;
    2: begin
      SelBox(2);
      cate := '';
    end;
  end;
end;
//开始搜索
procedure PlayingStartSearch();
begin
  src := form_mainform.combobox_playing_search_source.ItemIndex + 1;
  mode := form_mainform.combobox_playing_search_mode.ItemIndex + 1;
  oset := 1;
  SelWeb;
  form_mainform.label_playing_search_name.Caption := GetLanguage('label_playing_search_name.caption.page').Replace('${page}', '1');
end;
//搜索类型下拉框选择（Curseforge）
procedure PlayingSelCateCurseforge();
begin
  cate := inttostr(form_mainform.combobox_playing_search_category_curseforge.ItemIndex + 1);
end;
//搜索类型多选列表框（Modrinth）
procedure PlayingSelCateModrinth;
begin
  if form_mainform.checklistbox_playing_search_category_modrinth.Checked[form_mainform.checklistbox_playing_search_category_modrinth.ItemIndex] then cate := Concat(cate, inttostr(form_mainform.checklistbox_playing_search_category_modrinth.ItemIndex + 1), ',')
  else cate := cate.Replace(Concat(inttostr(form_mainform.checklistbox_playing_search_category_modrinth.ItemIndex + 1), ','), '');
end;
//进入函数
var pd: Boolean = False;
procedure InitPlaying;
begin
  if pd then exit;
  pd := true;
  //初始化
  ModRoot := TJsonObject.Create;
  VersionRoot := TJsonArray.Create;
  SelectRoot := TJsonObject.Create;
  ChooseRoot := TJsonObject.Create;
  try
    src := LLLini.ReadInteger('Mod', 'SelectModSource', -1);
    if (src > form_mainform.combobox_playing_search_source.Items.Count) or (src < 1) then raise Exception.Create('Select Mod Mode Error');
    form_mainform.combobox_playing_search_source.ItemIndex := src - 1;
  except
    LLLini.WriteInteger('Mod', 'SelectModSource', 1);
    src := 1;
    form_mainform.combobox_playing_search_source.ItemIndex := 0;
  end;
  case src of
    1: begin
      SelBox(3);
      try
        mode := LLLini.ReadInteger('Mod', 'SelectModMode', -1);
        if (mode > form_mainform.combobox_playing_search_mode.Items.Count) or (mode < 1) then raise Exception.Create('Select Mod Mode Error');
        form_mainform.combobox_playing_search_mode.ItemIndex := mode - 1;
      except
        LLLini.WriteInteger('Mod', 'SelectModMode', 1);
        mode := 1;
        form_mainform.combobox_playing_search_mode.ItemIndex := 0;
      end;
      SelBox(1);
      try
        cate := LLLini.ReadString('Mod', 'SelectModCategory', '');
        if (strtoint(cate) < 1) or (strtoint(cate) > form_mainform.combobox_playing_search_category_curseforge.Items.Count) then raise Exception.Create('Select Mod Mode Error');
        form_mainform.combobox_playing_search_category_curseforge.ItemIndex := strtoint(cate) - 1;
      except
        LLLini.WriteInteger('Mod', 'SelectModCategory', 1);
        cate := '1';
        form_mainform.combobox_playing_search_category_curseforge.ItemIndex := 0;
      end;
    end;
    2: begin
      SelBox(4);
      try
        mode := LLLini.ReadInteger('Mod', 'SelectModMode', -1);
        if (mode > form_mainform.combobox_playing_search_mode.Items.Count) or (mode < 1) then raise Exception.Create('Select Mod Mode Error');
        form_mainform.combobox_playing_search_mode.ItemIndex := mode - 1;
      except
        LLLini.WriteInteger('Mod', 'SelectModMode', 1);
        mode := 1;
        form_mainform.combobox_playing_search_mode.ItemIndex := 0;
      end;
      SelBox(2);
      try
        cate := LLLini.ReadString('Mod', 'SelectModCategory', '');
        var sl := TStringList.Create;
        ExtractStrings([','], [], pchar(cate), sl);
        for var I in sl do begin
          if (strtoint(I) > form_mainform.checklistbox_playing_search_category_modrinth.Items.Count) or (strtoint(I) < 1) then raise Exception.Create('Select Mod Mode Error')
          else form_mainform.checklistbox_playing_search_category_modrinth.Checked[strtoint(I) - 1] := true;
        end;
        sl.Free;
      except
        for var I := 0 to form_mainform.checklistbox_playing_search_category_modrinth.Items.Count - 1 do form_mainform.checklistbox_playing_search_category_modrinth.Checked[I] := false;
        cate := '';
        LLLini.WriteString('Mod', 'SelectModCategory', '');
      end;
    end;
  end;
  var vers := LLLini.ReadString('Mod', 'SelectModVersion', '');
  if vers = '' then
    form_mainform.combobox_playing_search_version.Text := GetLanguage('combobox_playing_search_version.item.all')
  else
    form_mainform.combobox_playing_search_version.Text := vers;
  selweb;
end;
//保存函数
procedure SavePlaying;
begin
  LLLini.WriteString('Mod', 'SelectModSource', inttostr(form_mainform.combobox_playing_search_source.ItemIndex + 1));
  LLLini.WriteString('Mod', 'SelectModMode', inttoStr(form_mainform.combobox_playing_search_mode.ItemIndex + 1));
  LLLini.WriteString('Mod', 'SelectModVersion', form_mainform.combobox_playing_search_version.Text);
  LLLini.WriteString('Mod', 'SelectModCategory', cate);
end;
end.
