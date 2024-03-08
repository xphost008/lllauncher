unit MultiPluginMethod;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Forms, Vcl.StdCtrls, Vcl.MPlayer, Generics.Collections,
  System.JSON, Vcl.ExtCtrls, Winapi.ShellAPI, ComCtrls, Types,
  System.StrUtils, SysUtils, Vcl.Buttons, JPEG, pngimage, GIFImg, Vcl.Controls, Vcl.Menus;

type
  TPluginForm = class
  private
    PluginJSON: TJSONObject;
    PluginTabSheet: TTabSheet;
    PluginScrollBox: TScrollBox;
    PluginButton: TList<TBitBtn>;
    PluginLabel: TList<TLabel>;
    PluginMemo: TList<TMemo>;
    PluginEdit: TList<TEdit>;
    PluginScrollBar: TList<TScrollBar>;
    PluginSpeedButton: TList<TSpeedButton>;
    PluginImage: TList<TImage>;
    PluginCombobox: TList<TCombobox>;
    PluginVariableDic: TDictionary<string, string>;
  public
    constructor ConstructorPluginForm(name, json: String);
    procedure PluginControlClick(Sender: TObject);
    procedure PluginControlChange(Sender: TObject);
    procedure PluginControlMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure PluginControlMouseLeave(Sender: TObject);
    procedure PluginControlScroll(Sender: TObject;
      ScrollCode: TScrollCode; var ScrollPos: Integer);
    procedure PluginScrollBoxMouseWheel(Sender: TObject;
      Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
      var Handled: Boolean);
    function VaribaleToValue(text: String): String;
  end;

var
  PluginFormList: TList<TPluginForm>;

implementation

uses
  Log4Delphi, MainForm, MainMethod, MyCustomWindow, LanguageMethod;
//插件变量换成值（在文本的任意位置，将所有变量转换成值）
function TPluginForm.VaribaleToValue(text: String): String;
begin
  for var I in PluginVariableDic do begin
    text := text.Replace(Concat('${', I.Key, '}'), I.Value);
  end;
  result := text;
end;
//控件点击事件
procedure TPluginForm.PluginControlClick(Sender: TObject);
begin
  var nme: String := (Sender as TControl).Name;
  var cont := PluginJSON.GetValue('content') as TJSONArray;
  for var I in cont do begin
    var J := I as TJSONObject;
    if J.GetValue('name').Value.Equals(nme) then begin
      var oc := J.GetValue('on_click') as TJSONArray;
      try
        for var K in oc do begin
          var L := K as TJSONObject;
          
        end;
      except end;
    end;
  end;
end;
//控件鼠标移动事件
procedure TPluginForm.PluginControlMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
begin
  //
end;
//控件鼠标离开事件
procedure TPluginForm.PluginControlMouseLeave(Sender: TObject);
begin
  //
end;
//控件改变事件
procedure TPluginForm.PluginControlChange(Sender: TObject);
begin
  //
end;
procedure TPluginForm.PluginControlScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  //
end;
//创建插件窗口
constructor TPluginForm.ConstructorPluginForm(name, json: String);
begin
  if not DirectoryExists(Concat(LocalTemp, 'LLLauncher\song')) then ForceDirectories(Concat(LocalTemp, 'LLLauncher\song'));
  PluginJSON := TJSONObject.ParseJSONValue(json) as TJSONObject;
  PluginVariableDic := TDictionary<string, string>.Create;
  PluginButton := TList<TBitBtn>.Create;
  PluginLabel := TList<TLabel>.Create;
  PluginEdit := TList<TEdit>.Create;
  PluginMemo := TList<TMemo>.Create;
  PluginCombobox := TList<TCombobox>.Create;
  PluginScrollBar := TList<TScrollBar>.Create;
  PluginSpeedButton := TList<TSpeedButton>.Create;
  PluginImage := TList<TImage>.Create;
  PluginTabSheet := TTabSheet.Create(form_mainform.pagecontrol_all_plugin_part);
  PluginTabSheet.Parent := form_mainform.pagecontrol_all_plugin_part;
  PluginTabSheet.PageControl := form_mainform.pagecontrol_all_plugin_part;
  try
    PluginTabSheet.Name := PluginJSON.GetValue('plugin_name').Value;
  except
    MyMessagebox(GetLanguage('messagebox_plugin.lose_form_name.caption'), GetLanguage('messagebox_plugin.lose_form_name.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  var desc := '';
  var upt := '';
  var ver := '';
  var atr := '';
  var cap := '';
  try desc := PluginJSON.GetValue('plugin_description').Value; except end;
  try upt := PluginJSON.GetValue('plugin_update_time').Value; except end;
  try ver := PluginJSON.GetValue('plugin_version').Value; except end;
  try atr := PluginJSON.GetValue('plugin_author').Value; except end;
  try cap := PluginJSON.GetValue('form_caption').Value; except end;
  var all := GetLanguage('plugin_tabsheet.get_plugin_info.hint')
                        .Replace('${plugin_caption}', cap)
                        .Replace('${plugin_version}', ver)
                        .Replace('${plugin_author}', atr)
                        .Replace('${plugin_update_time}', upt)
                        .Replace('${plugin_description}', desc);
  PluginTabSheet.Caption := cap;
  PluginScrollBox := TScrollBox.Create(PluginTabSheet);
  with PluginScrollBox do begin
    Name := 'PluginScrollBox';
    Parent := PluginTabSheet;
    ParentColor := false;
    ParentCtl3D := false;
    Ctl3D := true;
    Color := clBtnFace;
    Align := alClient;
    ShowHint := true;
    Hint := all;
    HorzScrollBar.Tracking := true;
    VertScrollBar.Tracking := true;
    OnMouseWheel := PluginScrollBoxMouseWheel;
  end;
  var content := PluginJSON.GetValue('content') as TJSONArray;
  for var I in content do begin
    var obj := I as TJSONObject;
    if obj.GetValue('type').Value.Equals('button') then begin
      PluginButton.Add(TBitBtn.Create(PluginScrollBox));
      with PluginButton[PluginButton.Count - 1] do begin
        Parent := PluginScrollBox;
        Name := obj.GetValue('name').Value;
        ShowHint := true;
        WordWrap := true;
        var pos := obj.GetValue('position') as TJSONArray;
        Left := strtoint(pos[0].Value);
        Top := strtoint(pos[1].Value);
        Width := strtoint(pos[2].Value);
        Height := strtoint(pos[3].Value);
        try Enabled := strtobool(obj.GetValue('enabled').Value); except Enabled := true; end;
        try Visible := strtobool(obj.GetValue('visible').Value); except Visible := true; end;
        try Caption := obj.GetValue('caption').Value; except Caption := ''; end;
        try Font.Color := ConvertHexToColor(obj.GetValue('font_color').Value); except Font.Color := 0; end;
        try Font.Size := strtoint(obj.GetValue('font_size').Value); except Font.Size := 9 end;
        try Font.Name := obj.GetValue('font_style').Value; except Font.Name := '宋体' end;
        try Hint := obj.GetValue('hint').Value; except Hint := '' end;
        OnClick := PluginControlClick;
        OnMouseMove := PluginControlMouseMove;
        OnMouseLeave := PluginControlMouseLeave;
      end;
    end else if obj.GetValue('type').Value.Equals('label') then begin
      PluginLabel.Add(TLabel.Create(PluginScrollBox));
      with PluginLabel[PluginLabel.Count - 1] do begin
        Parent := PluginScrollBox;
        Name := obj.GetValue('name').Value;
        ShowHint := true;
        WordWrap := true;
        AutoSize := false;
        var pos := obj.GetValue('position') as TJSONArray;
        Left := strtoint(pos[0].Value);
        Top := strtoint(pos[1].Value);
        Width := strtoint(pos[2].Value);
        Height := strtoint(pos[3].Value);
        Transparent := false;
        try Enabled := strtobool(obj.GetValue('enabled').Value); except Enabled := true; end;
        try Visible := strtobool(obj.GetValue('visible').Value); except Visible := true; end;
        try Caption := obj.GetValue('caption').Value; except Caption := ''; end;
        try Font.Color := ConvertHexToColor(obj.GetValue('font_color').Value); except Font.Color := 0; end;
        try Font.Size := strtoint(obj.GetValue('font_size').Value); except Font.Size := 9 end;
        try Font.Name := obj.GetValue('font_style').Value; except Font.Name := '宋体' end;
        try Hint := obj.GetValue('hint').Value; except Hint := '' end;
        try Color := ConvertHexToColor(obj.GetValue('back_color').Value); except Color := rgb(255, 255, 255) end;
        OnClick := PluginControlClick;
        OnMouseMove := PluginControlMouseMove;
        OnMouseLeave := PluginControlMouseLeave;
      end;
    end else if obj.GetValue('type').Value.Equals('image') then begin
      PluginImage.Add(TImage.Create(PluginScrollBox));
      with PluginImage[PluginImage.Count - 1] do begin
        Parent := PluginScrollBox;
        Name := obj.GetValue('name').Value;
        ShowHint := true;
        Stretch := true;
        var pos := obj.GetValue('position') as TJSONArray;
        Left := strtoint(pos[0].Value);
        Top := strtoint(pos[1].Value);
        Width := strtoint(pos[2].Value);
        Height := strtoint(pos[3].Value);
        try Hint := obj.GetValue('hint').Value; except Hint := '' end;
        try Enabled := strtobool(obj.GetValue('enabled').Value); except Enabled := true; end;
        try Visible := strtobool(obj.GetValue('visible').Value); except Visible := true; end;
        var imgc := obj.GetValue('image') as TJSONObject;
        try
          var f := imgc.GetValue('base64').Value;
          var s := imgc.GetValue('suffix').Value;
          if s.Equals('png') then begin
            var png := TPngImage.Create;
            try
              png.LoadFromStream(Base64ToStream(f));
              Picture.Assign(png);
            except
              Picture := nil;
            end;
            png.Free;
          end else if s.Equals('jpg') or s.Equals('jpeg') then begin
            var jpg := TJpegImage.Create;
            try
              jpg.LoadFromStream(Base64ToStream(f));
              Picture.Assign(jpg);
            except
              Picture := nil;
            end;
            jpg.Free;
          end else if s.Equals('bmp') then begin
            try
              Picture.Bitmap.LoadFromStream(Base64ToStream(f));
            except
              Picture := nil;
            end;
          end else Picture := nil;
        except
          try
            var f := imgc.GetValue('path').Value;
            var s := imgc.GetValue('suffix').Value;
            if f.IndexOf('.') = 0 then begin
              f := Concat(ExtractFileDir(Application.ExeName), f.Substring(1));
            end;
            if FileExists(f) then begin
              if s.Equals('png') then begin
                var png := TPngImage.Create;
                try
                  png.LoadFromFile(f);
                  Picture.Assign(png);
                except
                  Picture := nil;
                end;
                png.Free;
              end else if s.Equals('jpg') or s.Equals('jpeg') then begin
                var jpg := TJpegImage.Create;
                try
                  jpg.LoadFromFile(f);
                  Picture.Assign(jpg);
                except
                  Picture := nil;
                end;
                jpg.Free;
              end else if s.Equals('bmp') then begin
                try
                  Picture.Bitmap.LoadFromFile(f);
                except
                  Picture := nil;
                end;
              end else Picture := nil;
            end else Picture := nil;
          except
            try
              var f := imgc.GetValue('url').Value;
              var s := imgc.GetValue('suffix').Value;
              var g := GetWebStream(f);
              if s.Equals('png') then begin
                var png := TPngImage.Create;
                try
                  png.LoadFromStream(g);
                  Picture.Assign(png);
                except
                  Picture := nil;
                end;
                png.Free;
              end else if s.Equals('jpg') or s.Equals('jpeg') then begin
                var jpg := TJpegImage.Create;
                try
                  jpg.LoadFromStream(g);
                  Picture.Assign(jpg);
                except
                  Picture := nil;
                end;
                jpg.Free;
              end else if s.Equals('bmp') then begin
                try
                  Picture.Bitmap.LoadFromStream(g);
                except
                  Picture := nil;
                end;
              end else Picture := nil;
            except
              Picture := nil;
            end;
          end;
        end;
        OnClick := PluginControlClick;
        OnMouseMove := PluginControlMouseMove;
        OnMouseLeave := PluginControlMouseLeave;
      end;
    end else if obj.GetValue('type').Value.Equals('edit') then begin
      PluginEdit.Add(TEdit.Create(PluginScrollBox));
      with PluginEdit[PluginEdit.Count - 1] do begin
        Parent := PluginScrollBox;
        Name := obj.GetValue('name').Value;
        AutoSize := false;
        ShowHint := true;
        var pos := obj.GetValue('position') as TJSONArray;
        Left := strtoint(pos[0].Value);
        Top := strtoint(pos[1].Value);
        Width := strtoint(pos[2].Value);
        Height := strtoint(pos[3].Value);
        try Enabled := strtobool(obj.GetValue('enabled').Value); except Enabled := true; end;
        try Visible := strtobool(obj.GetValue('visible').Value); except Visible := true; end;
        try TextHint := obj.GetValue('texthint').Value; except TextHint := '' end;
        try Hint := obj.GetValue('hint').Value; except Hint := '' end;
        try Text := obj.GetValue('text').Value; except Text := '' end;
        try PluginVariableDic.Add(obj.GetValue('result').Value, Text) except end;
        try Font.Color := ConvertHexToColor(obj.GetValue('font_color').Value); except Font.Color := 0; end;
        try Font.Size := strtoint(obj.GetValue('font_size').Value); except Font.Size := 9 end;
        try Font.Name := obj.GetValue('font_style').Value; except Font.Name := '宋体' end;
        OnClick := PluginControlClick;
        OnChange := PluginControlChange;
        OnMouseMove := PluginControlMouseMove;
        OnMouseLeave := PluginControlMouseLeave;
      end;
    end else if obj.GetValue('type').Value.Equals('combobox') then begin
      PluginCombobox.Add(TComboBox.Create(PluginScrollBox));
      with PluginCombobox[PluginCombobox.Count - 1] do begin
        Parent := PluginScrollBox;
        Name := obj.GetValue('name').Value;
        ShowHint := true;
        var pos := obj.GetValue('position') as TJSONArray;
        Style := csDropDownList;
        Left := strtoint(pos[0].Value);
        Top := strtoint(pos[1].Value);
        Width := strtoint(pos[2].Value);
        Height := strtoint(pos[3].Value);
        try Enabled := strtobool(obj.GetValue('enabled').Value); except Enabled := true; end;
        try Visible := strtobool(obj.GetValue('visible').Value); except Visible := true; end;
        try Font.Color := ConvertHexToColor(obj.GetValue('font_color').Value); except Font.Color := 0; end;
        try Font.Size := strtoint(obj.GetValue('font_size').Value); except Font.Size := 9 end;
        try Font.Name := obj.GetValue('font_style').Value; except Font.Name := '宋体' end;
        try
          var item := obj.GetValue('items') as TJSONArray;
          for var O in item do
            Items.Add(O.Value);
        except end;
        try ItemIndex := strtoint(obj.GetValue('itemindex').Value); except ItemIndex := -1 end;
        try PluginVariableDic.Add(obj.GetValue('result').Value, inttostr(ItemIndex)) except end;
        OnDropDown := PluginControlClick;
        OnSelect := PluginControlChange;
      end;
    end else if obj.GetValue('type').Value.Equals('scrollbar') then begin
      PluginScrollBar.Add(TScrollBar.Create(PluginScrollBox));
      with PluginScrollBar[PluginScrollBar.Count - 1] do begin
        Parent := PluginScrollBox;
        Name := obj.GetValue('name').Value;
        ShowHint := true;
        var pos := obj.GetValue('position') as TJSONArray;
        Left := strtoint(pos[0].Value);
        Top := strtoint(pos[1].Value);
        Width := strtoint(pos[2].Value);
        Height := strtoint(pos[3].Value);
        try Enabled := strtobool(obj.GetValue('enabled').Value); except Enabled := true; end;
        try Visible := strtobool(obj.GetValue('visible').Value); except Visible := true; end;
        try Min := strtoint(obj.GetValue('min').Value); except Min := 0; end;
        try Max := strtoint(obj.GetValue('max').Value); except Max := 100; end;
        try Position := strtoint(obj.GetValue('current').Value); except Position := Min; end;
        try 
          var kd := obj.GetValue('kind').Value;
          if(kd.Equals('horz')) then Kind := sbHorizontal
          else if(kd.Equals('vert')) then Kind := sbVertical
          else raise Exception.Create(Concat(kd, ' is not a valid value in here!'));
        except Kind := sbHorizontal end;
        try PluginVariableDic.Add(obj.GetValue('result').Value, inttostr(Position)) except end;
        OnScroll := PluginControlScroll;
      end;
    end else if obj.GetValue('type').Value.Equals('memo') then begin
      PluginMemo.Add(TMemo.Create(PluginScrollBox));
      with PluginMemo[PluginMemo.Count - 1] do begin
        Parent := PluginScrollBox;
        Name := obj.GetValue('name').Value;
        ShowHint := true;
        WordWrap := true;
        var pos := obj.GetValue('position') as TJSONArray;
        Left := strtoint(pos[0].Value);
        Top := strtoint(pos[1].Value);
        Width := strtoint(pos[2].Value);
        Height := strtoint(pos[3].Value);
        try Enabled := strtobool(obj.GetValue('enabled').Value); except Enabled := true; end;
        try Visible := strtobool(obj.GetValue('visible').Value); except Visible := true; end;
        try ReadOnly := strtobool(obj.GetValue('readonly').Value); except ReadOnly := false; end;
        try Font.Color := ConvertHexToColor(obj.GetValue('font_color').Value); except Font.Color := 0; end;
        try Font.Size := strtoint(obj.GetValue('font_size').Value); except Font.Size := 9 end;
        try Font.Name := obj.GetValue('font_style').Value; except Font.Name := '宋体' end;
        var L := '';
        try
          var lne := obj.GetValue('lines') as TJSONArray;
          for var O in lne do begin
            Lines.Add(O.Value);
            L := Concat(O.Value, #13#10);
          end;
        except end;
        try PluginVariableDic.Add(obj.GetValue('result').Value, L) except end;
        OnMouseMove := PluginControlMouseMove;
        OnMouseLeave := PluginControlMouseLeave;
        OnClick := PluginControlClick;
        OnChange := PluginControlChange;
      end;
    end else if obj.GetValue('type').Value.Equals('speedbutton') then begin
      PluginSpeedButton.Add(TSpeedButton.Create(PluginScrollBox));
      with PluginSpeedButton[PluginSpeedButton.Count - 1] do begin
        Parent := PluginScrollBox;
        Name := obj.GetValue('name').Value;
        ShowHint := true;
        var pos := obj.GetValue('position') as TJSONArray;
        Left := strtoint(pos[0].Value);
        Top := strtoint(pos[1].Value);
        Width := strtoint(pos[2].Value);
        Height := strtoint(pos[3].Value);
        try Enabled := strtobool(obj.GetValue('enabled').Value); except Enabled := true; end;
        try Visible := strtobool(obj.GetValue('visible').Value); except Visible := true; end;
        try Font.Color := ConvertHexToColor(obj.GetValue('font_color').Value); except Font.Color := 0; end;
        try Font.Size := strtoint(obj.GetValue('font_size').Value); except Font.Size := 9 end;
        try Font.Name := obj.GetValue('font_style').Value; except Font.Name := '宋体' end;
        var imgc := obj.GetValue('image') as TJSONObject;
        try
          var f := imgc.GetValue('base64').Value;
          var s := imgc.GetValue('suffix').Value;
          if s.Equals('bmp') then begin
            try
              Glyph.LoadFromStream(Base64ToStream(f));
            except
              Glyph := nil;
            end;
          end else Glyph := nil;
        except
          try
            var f := imgc.GetValue('path').Value;
            var s := imgc.GetValue('suffix').Value;
            if f.IndexOf('.') = 0 then begin
              f := Concat(ExtractFileDir(Application.ExeName), f.Substring(1));
            end;
            if FileExists(f) then begin
              if s.Equals('bmp') then begin
                try
                  Glyph.LoadFromFile(f);
                except
                  Glyph := nil;
                end;
              end else Glyph := nil;
            end else Glyph := nil;
          except
            try
              var f := imgc.GetValue('url').Value;
              var s := imgc.GetValue('suffix').Value;
              var g := GetWebStream(f);
              if s.Equals('bmp') then begin
                try
                  Glyph.LoadFromStream(g);
                except
                  Glyph := nil;
                end;
              end else Glyph := nil;
            except
              Glyph := nil;
            end;
          end;
        end;
        try
          var lo := obj.GetValue('layout').Value;
          if lo.Equals('left') then Layout := blGlyphLeft
          else if lo.Equals('right') then Layout := blGlyphRight
          else if lo.Equals('top') then Layout := blGlyphTop
          else if lo.Equals('bottom') then Layout := blGlyphBottom
          else raise Exception.Create(Concat(lo, ' is not a valid value in here!'));
        except Layout := blGlyphLeft end;
        OnClick := PluginControlClick;
        OnMouseMove := PluginControlMouseMove;
        OnMouseLeave := PluginControlMouseLeave;
      end;
    end;
  end;
end;
//插件部分：滑动条框
procedure TPluginForm.PluginScrollBoxMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
var
  LTopLeft, LTopRight, LBottomLeft, LBottomRight: SmallInt;
  LPoint: TPoint;
  ScrollBox: TScrollBox;
begin
  ScrollBox := TScrollBox(Sender);
  LPoint := ScrollBox.ClientToScreen(Point(0,0));
  LTopLeft := LPoint.X;
  LTopRight := LTopLeft + ScrollBox.ClientWidth;
  LBottomLeft := LPoint.Y;
  LBottomRight := LBottomLeft + ScrollBox.ClientWidth;
  if (MousePos.X >= LTopLeft) and
    (MousePos.X <= LTopRight) and
    (MousePos.Y >= LBottomLeft) and
    (MousePos.Y <= LBottomRight) then
  begin
    ScrollBox.VertScrollBar.Position := ScrollBox.VertScrollBar.Position - WheelDelta;
    Handled := True;
  end;
end;
end.
