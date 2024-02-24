unit PluginMethod;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Forms, Vcl.StdCtrls, Vcl.MPlayer,
  System.JSON, Vcl.ExtCtrls, Winapi.ShellAPI,
  System.StrUtils, SysUtils, System.RegularExpressions,
  Vcl.Buttons, JPEG, pngimage, GIFImg;


procedure CreateFirstPluginForm(name, json: String);

implementation

uses
  Log4Delphi, MainForm, MainMethod, MyCustomWindow, LanguageMethod;

type
  PluginForm = class
  private
  var
    FormJSON: TJSONObject;
    FormPlugin: TForm;
    LabelArray: array of TLabel;
    MemoArray: array of TMemo;
    ButtonArray: array of TBitBtn;
    ImageArray: array of TImage;
    ButtonClickArray: array of TJSONArray;
  public
    constructor CreateNewPluginForm(name, json: String);
    procedure ShowForm;
    procedure PluginButtonClick(Sender: TObject);
    destructor DestructorPluginForm;
  end;
var
  temp: String;
procedure PluginForm.PluginButtonClick(Sender: TObject);   
var
  tmplb, tmpmo, tmpbt, tmpig, tpbtc: Integer;
  tmpfo: Boolean;
begin                           
  tpbtc := 0;
  var bname: String := (Sender as TBitbtn).Name;
  var pljarr := FormJSON.GetValue('content') as TJSONArray;
  for var I in pljarr do begin
    var r := I as TJsonObject;      
    if r.GetValue('type').Value = 'button' then begin
      inc(tpbtc);
      var jname := r.GetValue('name').Value;
      if jname.Equals(bname) then begin
        var jrun := ButtonClickArray[tpbtc - 1];
        for var J in jrun do begin
          var K := J as TJSONObject;
          var Ktp := K.GetValue('type').Value;
          if Ktp.Equals('messagebox') then begin
            var tle := '';
            var ctx := '';
            var ico := '';
            try tle := K.GetValue('title').Value; except tle := ''; end;
            try ctx := K.GetValue('context').Value; except ctx := ''; end;                                                         
            try ico := K.GetValue('icon').Value; except ico := 'none'; end;
            var tmpio := 0;
            if ico = 'information' then tmpio := MY_INFORMATION
            else if ico = 'error' then tmpio := MY_ERROR
            else if ico = 'warning' then tmpio := MY_WARNING
            else if ico = 'pass' then tmpio := MY_PASS;
            MyMessageBox(tle, ctx, tmpio, [mybutton.myYes]);
          end else if Ktp.Equals('shell') then begin
            try
              var jy := K.GetValue('implement') as TJsonArray;
              for var Q in jy do begin
                var lt := Q.GetValue<String>;
                RunDOSOnlyWait(lt);
              end;
            except end;      
          end else if Ktp.Equals('change') then begin
            tmplb := 0;
            tmpmo := 0;
            tmpbt := 0;
            tmpig := 0;
            tmpfo := false;
            var ne := K.GetValue('name').Value;   
            if ne = bname then raise Exception.Create('Invaild name');
            if K.GetValue('name').Value = FormJson.GetValue('name').Value then tmpfo := true;    
            if tmpfo then begin
              try FormPlugin.AlphaBlendValue := K.GetValue<Byte>('form_alpha'); except end;
              try FormPlugin.Width := K.GetValue<Integer>('form_width'); except end;
              try FormPlugin.Height := K.GetValue<Integer>('form_height'); except end;
              try
                var colour := K.GetValue('form_color').Value;
                if TRegex.IsMatch(colour.Replace('#', '').ToLower, '^[0-9a-f]{6}') then begin
                  FormPlugin.Color := StringToColor(Concat('$00', colour.Replace('#', '')));
                end;
              except end;
              continue;
            end; 
            for var O in pljarr do begin
              var jr := (O as TJSONObject).GetValue('type').Value;
              if jr = 'label' then begin
                if ne = LabelArray[tmplb].Name then break;
                inc(tmplb);
              end else if jr = 'memo' then begin
                if ne = MemoArray[tmpmo].Name then break;
                inc(tmpmo);
              end else if jr = 'button' then begin
                if ne = ButtonArray[tmpbt].Name then break;
                inc(tmpbt);
              end else if jr = 'image' then begin
                if ne = ImageArray[tmpig].Name then break;
                inc(tmpig);
              end else raise Exception.Create('Invaild type');
            end;
            for var D in pljarr do begin
              var L := D as TJSONObject;
              if ne = L.GetValue('name').Value then begin
                if L.GetValue('type').Value.Equals('label') then begin
                  try LabelArray[tmplb].Caption := K.GetValue('caption').Value; except end;
                  try LabelArray[tmplb].Top := K.GetValue<Integer>('top'); except end;
                  try LabelArray[tmplb].Left := K.GetValue<Integer>('left'); except end;
                  try LabelArray[tmplb].Font.Name := K.GetValue('font').Value; except end;
                  try LabelArray[tmplb].Font.Size := K.GetValue<Integer>('font_size'); except end;
                  try LabelArray[tmplb].Font.Color := StringToColor(Concat('$00', K.GetValue('font_color').Value.Replace('#', '').ToLower)); except end;
                end else if L.GetValue('type').Value.Equals('memo') then begin
                  try
                    var Jo := K.GetValue('lines') as TJsonArray;
                    Jo.ToString;
                    MemoArray[tmpmo].Lines.Clear;
                    for var P in Jo do begin MemoArray[tmpmo].Lines.Add(P.GetValue<String>); end;
                  except end;
                  try MemoArray[tmpmo].Top := K.GetValue<Integer>('top') except end;
                  try MemoArray[tmpmo].Left := K.GetValue<Integer>('left') except end;
                  try MemoArray[tmpmo].Height := K.GetValue<Integer>('height') except end;
                  try MemoArray[tmpmo].Width := K.GetValue<Integer>('width') except end;
                  try MemoArray[tmpmo].Font.Name := K.GetValue('font').Value except end;
                  try MemoArray[tmpmo].Font.Size := K.GetValue<Integer>('font_size') except end;
                  try MemoArray[tmpmo].Font.Color := StringToColor(Concat('$00', K.GetValue('font_color').Value.Replace('#', '').ToLower)); except end;
                end else if L.GetValue('type').Value.Equals('button') then begin
                  try ButtonArray[tmpbt].Caption := K.GetValue('caption').Value; except end;
                  try ButtonArray[tmpbt].Top := K.GetValue<Integer>('top') except end;
                  try ButtonArray[tmpbt].Left := K.GetValue<Integer>('left') except end;
                  try ButtonArray[tmpbt].Height := K.GetValue<Integer>('height') except end;
                  try ButtonArray[tmpbt].Width := K.GetValue<Integer>('width') except end;
                  try ButtonArray[tmpbt].Font.Name := K.GetValue('font').Value except end;
                  try ButtonArray[tmpbt].Font.Size := K.GetValue<Integer>('font_size') except end;
                  try ButtonArray[tmpbt].Font.Color := StringToColor(Concat('$00', K.GetValue('font_color').Value.Replace('#', '').ToLower)); except end;
                  try ButtonClickArray[tmpbt] := K.GetValue('on_click') as TJsonArray; except end;
                end else if L.GetValue('type').Value.Equals('image') then begin
                  try ImageArray[tmpig].Top := K.GetValue<Integer>('top') except end;
                  try ImageArray[tmpig].Left := K.GetValue<Integer>('left') except end;
                  try
                    var hh := K.GetValue<Integer>('height');
                    ImageArray[tmpig].AutoSize := false;
                    ImageArray[tmpig].Height := hh;
                  except ImageArray[tmpig].AutoSize := true; end;
                  try
                    var ww := K.GetValue<Integer>('width');
                    ImageArray[tmpig].AutoSize := false;
                    ImageArray[tmpig].Width := ww;
                  except ImageArray[tmpig].AutoSize := true; end;
                  try
                    var ph := K.GetValue('path').Value;
                    if ph = '' then begin
                      ImageArray[tmpig].Picture := nil;
                    end else if LeftStr(ph, 4) = 'http' then begin
                      var c := GetWebStream(ph);
                      if c = nil then raise Exception.Create('Read Plugin Json Error');
                      var suffix := ph.Substring(ph.LastIndexOf('.'));
                      if (suffix = '.jpg') or (suffix = '.jpeg') then begin
                        var jpg := TJpegImage.Create;
                        jpg.LoadFromStream(c);
                        ImageArray[tmpig].Picture.Bitmap.Assign(jpg);
                      end else if suffix = '.bmp' then begin
                        ImageArray[tmpig].Picture.Bitmap.LoadFromStream(c);
                      end else if suffix = '.png' then begin
                        var png := TPngImage.Create;
                        png.LoadFromStream(c);
                        ImageArray[tmpig].Picture.Bitmap.Assign(png);
                      end else if suffix = '.gif' then begin
                        var gif := TGifImage.Create;
                        gif.LoadFromStream(c);
                        ImageArray[tmpig].Picture.Bitmap.Assign(gif);
                      end;
                    end else begin
                      if not FileExists(ph) then raise Exception.Create('Read Plugin Json Error');
                      if ph.IndexOf('.') = 0 then ph := ph.Replace('.', ExtractFileDir(Application.ExeName));
                      var suffix := ph.Substring(ph.LastIndexOf('.'));
                      if (suffix = '.jpg') or (suffix = '.jpeg') then begin
                        var jpg := TJpegImage.Create;
                        jpg.LoadFromFile(ph);
                        ImageArray[tmpig].Picture.Bitmap.Assign(jpg);
                      end else if suffix = '.bmp' then begin
                        ImageArray[tmpig].Picture.Bitmap.LoadFromFile(ph)
                      end else if suffix = '.png' then begin
                        var png := TPngImage.Create;
                        png.LoadFromFile(ph);
                        ImageArray[tmpig].Picture.Bitmap.Assign(png);
                      end else if suffix = '.gif' then begin
                        var gif := TGifImage.Create;
                        gif.LoadFromFile(ph);
                        ImageArray[tmpig].Picture.Bitmap.Assign(gif);
                      end;
                    end;
                  except end;
                end;
              end;
            end;
          end else if Ktp.Equals('song') then begin
            try
              var mph := K.GetValue('path').Value;
              var songext := RightStr(mph, 4);
              if LeftStr(mph, 4) = 'http' then begin
                var path := Concat(temp, 'LLLauncher\song\tempsong', songext);
                var ss := GetWebStream(mph);
                if ss = nil then begin
                  raise Exception.Create('Cannot Read Song URL');
                end;
                ss.SaveToFile(path);
                v.FileName := path;
                v.Open;
                v.Play;
              end else begin
                if not FileExists(mph) then begin
                  raise Exception.Create('Cannot Read Song Path');
                end;
                v.FileName := mph;
                v.Open;
                v.Play;
              end;
            except end;
          end else if Ktp.Equals('open') then begin
            var jrt := K.GetValue('path').Value;
            if RightStr(jrt, 5).Equals('.json') then begin
              try
                var content := '';
                if LeftStr(jrt, 4).Equals('http') then begin
                  content := GetWebText(jrt);
                end else begin
                  content := GetFile(jrt);
                end;
                var ise := TJsonObject.ParseJSONValue(content) as TJsonObject;
                if ise.GetValue('name').Value = '' then raise Exception.Create('Plugin Format Exception');
                var nee := '';
                nee := ChangeFileExt(ExtractFileName(jrt), '');
                var upp := PluginForm.CreateNewPluginForm(nee, content);
                upp.ShowForm;
                upp.DestructorPluginForm;
              except end;
            end;
          end;
        end;
      end;
    end;
  end;
end;
procedure PluginForm.ShowForm();
begin
  try
    var mph := FormJSON.GetValue('song').Value;
    if mph = '' then raise Exception.Create('No Song Content');
    if LeftStr(mph, 4) = 'http' then begin
      var songext := mph.Substring(mph.LastIndexOf('.'));
      var path := Concat(temp, 'LLLauncher\song\tempsong', songext);  
      var ss := GetWebStream(mph);
      if ss = nil then begin
        raise Exception.Create('Cannot Import Music');
      end;         
      ss.SaveToFile(path);
      v.FileName := path;
      v.Open;
      v.Play;
    end else begin
      if not FileExists(mph) then begin
        raise Exception.Create('Cannot Import Music');
      end;  
      v.FileName := mph;
      v.Open;
      v.Play;
    end;
  except end;
  try
    var pja := FormJSON.GetValue('form_create') as TJsonArray;
    for var I in pja do begin
      var lt := I.Value;
      RunDOSOnlyWait(lt);
    end;
    pja.Free;
  except end;
  FormPlugin.ShowModal;
  try
    var pja := FormJSON.GetValue('form_close') as TJsonArray;
    for var I in pja do begin
      var lt := I.Value;
      RunDOSOnlyWait(lt);
    end;
    pja.Free;
  except end;
end;
constructor PluginForm.CreateNewPluginForm(name, json: String);
begin
  if not DirectoryExists(Concat(temp, 'LLLauncher\song')) then ForceDirectories(Concat(temp, 'LLLauncher\song'));
  FormJSON := TJSONObject.ParseJSONValue(json) as TJSONObject;
  FormPlugin := TForm.Create(nil);
  try
    FormPlugin.Name := FormJSON.GetValue('name').Value;
  except
    MyMessagebox(GetLanguage('messagebox_plugin.lose_form_name.caption'), GetLanguage('messagebox_plugin.lose_form_name.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  FormPlugin.Caption := name;
  var wt: Integer;
  var ht: Integer;
  try
    wt := self.FormJSON.GetValue<Integer>('form_width');
    ht := self.FormJSON.GetValue<Integer>('form_height');
    if (wt > Screen.Width) or (wt < 854) then raise Exception.Create('Plugin Error');
    if (ht > Screen.Height) or (ht < 480) then raise Exception.Create('Plugin Error');
  except
    wt := 854;
    ht := 480;
  end;
  FormPlugin.Width := wt;
  FormPlugin.Height := ht;
  FormPlugin.BorderStyle := TFormBorderStyle.bsSingle;
  FormPlugin.BorderIcons := [TBorderIcon.biSystemMenu, TBorderIcon.biMinimize];
  FormPlugin.AlphaBlend := true;
  FormPlugin.Icon := form_mainform.Icon;
  var colour: TColor;
  try
    var colorStr := FormJSON.GetValue('form_color').Value;
    if TRegex.IsMatch(colorStr.Replace('#', '').ToLower, '^[0-9a-f]{6}') then
      colour := StringToColor(Concat('$00', colorstr.Replace('#', '')))
    else raise Exception.Create('Plugin Error');
  except
    colour := rgb(240, 240, 240);
  end;
  FormPlugin.Color := colour;
  var alpha: Integer;
  try
    alpha := FormJSON.GetValue<Integer>('form_alpha');
    if (alpha < 127) or (alpha > 255) then raise Exception.Create('Plugin Error');
  except
    alpha := 255;
  end;
  FormPlugin.AlphaBlendValue := alpha;
  FormPlugin.Position := poDesktopCenter;
  try
    var pljarr := FormJSON.GetValue('content') as TJSONArray;    
    var ButtonCount := 0;
    var LabelCount := 0;
    var MemoCount := 0;
    var ImageCount := 0;
    var ButtonClickEvent := 0;
    for var I in pljarr do begin
      var j := I as TJSONObject;
      var t := j.GetValue('type').Value;
      if t.Equals('button') then begin
        inc(ButtonCount);
        SetLength(ButtonArray, ButtonCount);
        ButtonArray[ButtonCount - 1] := TBitBtn.Create(FormPlugin);
        ButtonArray[ButtonCount - 1].Parent := FormPlugin;
        ButtonArray[ButtonCount - 1].Name := j.GetValue('name').Value;
        ButtonArray[ButtonCount - 1].Top := j.GetValue<Integer>('top');
        ButtonArray[ButtonCount - 1].Left := j.GetValue<Integer>('left');
        ButtonArray[ButtonCount - 1].Width := j.GetValue<Integer>('width');
        ButtonArray[ButtonCount - 1].Height := j.GetValue<Integer>('height');
        try ButtonArray[ButtonCount - 1].Caption := j.GetValue('caption').Value; except ButtonArray[ButtonCount - 1].Caption := ''; end;
        try ButtonArray[ButtonCount - 1].Font.Name := j.GetValue('font').Value; except ButtonArray[ButtonCount - 1].Font.Name := '宋体'; end;                                                           
        try ButtonArray[ButtonCount - 1].Font.Size := j.GetValue<Integer>('font_size'); except ButtonArray[ButtonCount - 1].Font.Size := 9; end;                                                                             
        try ButtonArray[ButtonCount - 1].Font.Color := StringToColor(Concat('$00', j.GetValue('font_color').Value.Replace('#', '').ToLower)); except ButtonArray[ButtonCount - 1].Font.Color := rgb(0, 0, 0); end;
        try
          var tmp := j.GetValue('on_click') as TJSONArray;
          tmp.ToString;
          inc(ButtonClickEvent);
          SetLength(ButtonClickArray, ButtonClickEvent);
          ButtonClickArray[ButtonClickEvent - 1] := tmp;
          ButtonArray[ButtonCount - 1].OnClick := PluginButtonClick;
        except
          ButtonArray[ButtonCount - 1].OnClick := nil;
        end;
      end else if t.Equals('label') then begin
        inc(LabelCount);
        SetLength(LabelArray, LabelCount);  
        LabelArray[LabelCount - 1] := TLabel.Create(FormPlugin);
        LabelArray[LabelCount - 1].Parent := FormPlugin;
        LabelArray[LabelCount - 1].AutoSize := true;
        LabelArray[LabelCount - 1].Name := j.GetValue('name').Value;
        LabelArray[LabelCount - 1].Top := j.GetValue<Integer>('top');   
        LabelArray[LabelCount - 1].Left := j.GetValue<Integer>('left');   
        LabelArray[LabelCount - 1].Font.Charset := GB2312_CHARSET;
        try LabelArray[LabelCount - 1].Caption := j.GetValue('caption').Value; except LabelArray[LabelCount - 1].Caption := ''; end;
        try LabelArray[LabelCount - 1].Font.Name := j.GetValue('font').Value; except LabelArray[LabelCount - 1].Font.Name := '宋体'; end;
        try LabelArray[LabelCount - 1].Font.Size := j.GetValue<Integer>('font_size'); except LabelArray[LabelCount - 1].Font.Size := 9; end;
        try LabelArray[LabelCount - 1].Font.Color := StringToColor(Concat('$00', j.GetValue('font_color').Value.Replace('#', '').ToLower)); except LabelArray[LabelCount - 1].Font.Color := rgb(0, 0, 0); end;
      end else if t.Equals('memo') then begin
        inc(MemoCount);
        SetLength(MemoArray, MemoCount);
        MemoArray[MemoCount - 1] := TMemo.Create(FormPlugin);
        MemoArray[MemoCount - 1].Parent := FormPlugin;
        MemoArray[MemoCount - 1].Name := j.GetValue('name').Value;
        MemoArray[MemoCount - 1].Top := j.GetValue<Integer>('top');
        MemoArray[MemoCount - 1].Left := j.GetValue<Integer>('left');
        MemoArray[MemoCount - 1].Width := j.GetValue<Integer>('width');
        MemoArray[MemoCount - 1].Height := j.GetValue<Integer>('height');     
        MemoArray[MemoCount - 1].Font.Charset := GB2312_CHARSET;
        MemoArray[MemoCount - 1].ScrollBars := ssboth;
        MemoArray[MemoCount - 1].Lines.Clear;
        try
          var ln := j.GetValue('lines') as TJsonArray;
          for var K in ln do MemoArray[MemoCount - 1].Lines.Add(K.Value);
        except MemoArray[MemoCount - 1].Lines.Clear; end;
        try MemoArray[MemoCount - 1].Font.Name := j.GetValue('font').Value; except MemoArray[MemoCount - 1].Font.Name := '宋体'; end;
        try MemoArray[MemoCount - 1].Font.Size := j.GetValue<Integer>('font_size'); except MemoArray[MemoCount - 1].Font.Size := 9; end;
        try MemoArray[MemoCount - 1].Font.Color := StringToColor(Concat('$00', j.GetValue('font_color').Value.Replace('#', '').ToLower)); except MemoArray[MemoCount - 1].Font.Color := rgb(0, 0, 0); end;
      end else if t.Equals('image') then begin
        inc(ImageCount);
        SetLength(ImageArray, ImageCount);
        ImageArray[ImageCount - 1] := TImage.Create(FormPlugin);
        ImageArray[ImageCount - 1].Parent := FormPlugin;
        ImageArray[ImageCount - 1].Stretch := True;               
        ImageArray[ImageCount - 1].Name := j.GetValue('name').Value;
        ImageArray[ImageCount - 1].Top := j.GetValue<Integer>('top');
        ImageArray[ImageCount - 1].Left := j.GetValue<Integer>('left');
        try ImageArray[ImageCount - 1].Width := j.GetValue<Integer>('width'); except ImageArray[ImageCount - 1].AutoSize := true; end;
        try ImageArray[ImageCount - 1].Height := j.GetValue<Integer>('height'); except ImageArray[ImageCount - 1].AutoSize := true; end;
        var ph := j.GetValue('path').Value;
        if ph <> '' then begin
          if LeftStr(ph, 4) = 'http' then begin
            var c := GetWebStream(ph);
            if c = nil then raise Exception.Create('Read Plugin Json Error');
            var suffix := ph.Substring(ph.LastIndexOf('.'), ph.Length - ph.LastIndexOf('.'));
            if (suffix = '.jpg') or (suffix = '.jpeg') then begin
              var jpg := TJpegImage.Create;
              jpg.LoadFromStream(c);
              ImageArray[ImageCount - 1].Picture.Bitmap.Assign(jpg);
            end else if suffix = '.bmp' then begin
              ImageArray[ImageCount - 1].Picture.Bitmap.LoadFromStream(c);
            end else if suffix = '.png' then begin
              var png := TPngImage.Create;
              png.LoadFromStream(c);
              ImageArray[ImageCount - 1].Picture.Bitmap.Assign(png);
            end else if suffix = '.gif' then begin
              var gif := TGifImage.Create;
              gif.LoadFromStream(c);
              ImageArray[ImageCount - 1].Picture.Bitmap.Assign(gif);
            end;
          end else begin
            if not FileExists(ph) then raise Exception.Create('Read Plugin Json Error');
            if ph.IndexOf('.') = 0 then ph := Concat(ExtractFileDir(Application.ExeName), ph.Substring(1, ph.Length - 1));
            var suffix := ph.Substring(ph.LastIndexOf('.'), ph.Length - ph.LastIndexOf('.'));
            if (suffix = '.jpg') or (suffix = '.jpeg') then begin
              var jpg := TJpegImage.Create;
              jpg.LoadFromFile(ph);
              ImageArray[ImageCount - 1].Picture.Bitmap.Assign(jpg);
            end else if suffix = '.bmp' then begin
              ImageArray[ImageCount - 1].Picture.Bitmap.LoadFromFile(ph)
            end else if suffix = '.png' then begin
              var png := TPngImage.Create;
              png.LoadFromFile(ph);
              ImageArray[ImageCount - 1].Picture.Bitmap.Assign(png);
            end else if suffix = '.gif' then begin
              var gif := TGifImage.Create;
              gif.LoadFromFile(ph);
              ImageArray[ImageCount - 1].Picture.Bitmap.Assign(gif);
            end;
          end;
        end;
      end;
    end;
  except
    MyMessagebox(GetLanguage('messagebox_plugin.lose_content_value.caption'), GetLanguage('messagebox_plugin.lose_content_value.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
end;      
destructor PluginForm.DestructorPluginForm;
begin
  FormPlugin.Free;
end;
procedure CreateFirstPluginForm(name, json: String);     
var
  TempDir: array[0..255] of char;
begin                   
  GetTempPath(255, @TempDir);
  temp := strpas(TempDir);
  var cnpf := PluginForm.CreateNewPluginForm(name, json);
  cnpf.ShowForm;
  cnpf.DestructorPluginForm;
end;

end.

