unit MultiPluginMethod;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Forms, Vcl.StdCtrls, Vcl.MPlayer, Generics.Collections,
  System.JSON, Vcl.ExtCtrls, Winapi.ShellAPI, ComCtrls,
  System.StrUtils, SysUtils, System.RegularExpressions,
  Vcl.Buttons, JPEG, pngimage, GIFImg, Vcl.Controls;

procedure CreateFirstPluginForm(name, json: String);

implementation

uses
  Log4Delphi, MainForm, MainMethod, MyCustomWindow, LanguageMethod;
type
  TPluginForm = class
  private
    PluginJSON: TJSONObject;
    PluginTabSheet: TTabSheet;
    PluginScrollBox: TScrollBox;
    PluginButton: TList<TBitBtn>;
    PluginLabel: TList<TLabel>;
    PluginMemo: TList<TMemo>;
    PluginScrollBar: TList<TScrollBar>;
    PluginSpeedButton: TList<TSpeedButton>;
    PluginImage: TList<TImage>;
    PluginCombobox: TList<TCombobox>;
    PluginVariableDic: TDictionary<string, string>;
  public
    constructor ConstructorPluginForm(name, json: String);
    procedure ShowTabSheet;
    procedure PluginControlClick(Sender: TObject);
    procedure PluginControlMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure PluginControlMouseLeave(Sender: TObject);
    function VaribaleToValue(text: String): String;
  end;
var
  temp: String;
  PluginFormList: TList<TPluginForm>;
  index: Integer;
//插件变量换成值（在文本的任意位置，将所有变量转换成值）
function TPluginForm.VaribaleToValue(text: String): String;
begin
  for var I in PluginVariableDic do begin
    text := text.Replace(I.Key, I.Value);
  end;
  result := text;
end;
//控件点击事件
procedure TPluginForm.PluginControlClick(Sender: TObject);
begin
  //
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
//创建插件窗口
constructor TPluginForm.ConstructorPluginForm(name, json: String);
begin
  if not DirectoryExists(Concat(temp, 'LLLauncher\song')) then ForceDirectories(Concat(temp, 'LLLauncher\song'));
  PluginJSON := TJSONObject.ParseJSONValue(json) as TJSONObject;
  PluginVariableDic := TDictionary<string, string>.Create;
  PluginButton := TList<TBitBtn>.Create;
  PluginLabel := TList<TLabel>.Create;
  PluginMemo := TList<TMemo>.Create;
  PluginScrollBar := TList<TScrollBar>.Create;
  PluginSpeedButton := TList<TSpeedButton>.Create;
  PluginImage := TList<TImage>.Create;
  PluginCombobox := TList<TCombobox>.Create;
  PluginTabSheet := TTabSheet.Create(form_mainform.pagecontrol_mainpage);
  PluginTabSheet.Parent := form_mainform.pagecontrol_mainpage;
  try
    PluginTabSheet.Name := PluginJSON.GetValue('plugin_name').Value;
  except
    MyMessagebox(GetLanguage('messagebox_plugin.lose_form_name.caption'), GetLanguage('messagebox_plugin.lose_form_name.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  PluginTabSheet.ShowHint := true;
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
  with PluginTabSheet do begin
    Hint := all;
    Caption := cap;
    TabVisible := false;
  end;
  PluginScrollBox := TScrollBox.Create(PluginTabSheet);
  with PluginScrollBox do begin
    Name := 'PluginScrollBox';
    Parent := PluginTabSheet;
    ParentColor := false;
    Align := alClient;
    HorzScrollBar.Tracking := true;
    VertScrollBar.Tracking := true;
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
        var pos := obj.GetValue('position') as TJSONArray;
        Left := strtoint(pos[0].Value);
        Top := strtoint(pos[1].Value);
        Width := strtoint(pos[2].Value);
        Height := strtoint(pos[3].Value);
        try Caption := obj.GetValue('caption').Value; except Caption := ''; end;
        try Font.Color := ConvertHexToColor(obj.GetValue('font_color').Value); except Font.Color := 0; end;
        try Font.Size := obj.GetValue<Integer>('font_size'); except Font.Size := 9 end;
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
        AutoSize := false;
        var pos := obj.GetValue('position') as TJSONArray;
        Left := strtoint(pos[0].Value);
        Top := strtoint(pos[1].Value);
        Width := strtoint(pos[2].Value);
        Height := strtoint(pos[3].Value);
        Transparent := false;
        try Caption := obj.GetValue('caption').Value; except Caption := ''; end;
        try Font.Color := ConvertHexToColor(obj.GetValue('font_color').Value); except Font.Color := 0; end;
        try Font.Size := obj.GetValue<Integer>('font_size'); except Font.Size := 9 end;
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
      end;
    end;
  end;
end;
//显示窗口
procedure TPluginForm.ShowTabSheet;
begin

end;
//创建首个插件窗口
procedure CreateFirstPluginForm(name, json: String);
var
  TempDir: array[0..255] of char;
begin
  GetTempPath(255, @TempDir);
  temp := strpas(TempDir);
  index := 0;
  PluginFormList := TList<TPluginForm>.Create;
  PluginFormList.Add(TPluginForm.ConstructorPluginForm(name, json));
  PluginFormList[0].ShowTabSheet;
end;
end.
