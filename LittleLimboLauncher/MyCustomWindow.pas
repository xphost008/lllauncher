unit MyCustomWindow;
interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Threading, Vcl.ExtCtrls;
type
  btn = class(TForm)
    procedure MCWButtonClick(Sender: TObject);
    procedure MCWOKClick(Sender: TObject);
    procedure MCWCancalClick(Sender: TObject);
  end;
  mybutton = (myYes, myOK, myNo, myCancal, myRetry, myAbort, myIgnore, myCustom);

const
  MY_ERROR = 1;
  MY_WARNING = 2;
  MY_INFORMATION = 3;
  MY_PASS = 4;
function MyMessageBox(title, content: String; color: Integer; button: TArray<MyButton>; custom: TArray<String> = []; defbutton: Integer = 1): Integer;
function MyInputBox(title, content: String; color: Integer; defcontent: String = ''; defbutton: Integer = 1): String;
procedure MyPictureBox(title, content: String; web: TStringStream);
implementation
uses LanguageMethod;
var
  bt: btn;
  tbt: array of TButton;
  ResMessage: Integer;
  ResInput: String;
  FormMCW: TForm;
  TitleMCW: TLabel;
  PicTitleMCW: TMemo;
  CutMCW: TLabel;
  ContentMCW: TMemo;
  InputMCW: TEdit;
  OkMCW, CancalMCW: TButton;
  PictureMCW: TImage;
//初始化窗口
procedure InitMCW(nme: String);
begin
  FormMCW := TForm.Create(nil);
  if nme = 'MyPictureBox' then begin
    with FormMCW do begin
      Name := nme;
      ClientHeight := 730;
      ClientWidth := 988;
      Color := clBtnFace;
      BorderStyle := bsDialog;
      Position := poDesktopCenter;
    end;
    PictureMCW := TImage.Create(FormMCW);
    with PictureMCW do begin
      Parent := FormMCW;
      Name := 'Image';
      Left := 8;
      Top := 8;
      Width := 200;
      Height := 200;
      Stretch := true;
    end;
    PicTitleMCW := TMemo.Create(FormMCW);
    with PicTitleMCW do begin
      Parent := FormMCW;
      Name := 'Title';
      Left := 214;
      Top := 8;
      Width := 766;
      Height := 179;
      Font.Charset := ANSI_CHARSET;
      Font.Name := '微软雅黑';
      Font.Height := -25;
      Font.Style := [fsBold];
      Font.Color := clWindowText;
      Color := clbtnface;
      BorderStyle := bsNone;
      ReadOnly := True;
      ScrollBars := ssVertical;
    end;
    CutMCW := TLabel.Create(FormMCW);
    with CutMCW do begin
      Parent := FormMCW;
      Name := 'CutLine';
      Left := 215;
      Top := 193;
      Width := 765;
      Height := 15;
      AutoSize := true;
      Caption := '------------------------------------------------------------------------------------------------------------------------------------------------------';
    end;
    ContentMCW := TMemo.Create(FormMCW);
    with ContentMCW do begin
      Parent := FormMCW;
      Name := 'Content';
      Left := 8;
      Top := 214;
      Width := 972;
      Height := 467;
      Font.Charset := ANSI_CHARSET;
      Font.Color := clWindowText;
      Font.Height := -19;
      Font.Name := '微软雅黑';
      Color := clbtnface;
      BorderStyle := bsNone;
      ReadOnly := True;
      ScrollBars := ssVertical;
    end;
    OkMCW := TButton.Create(FormMCW);
    with OkMCW do begin
      Parent := FormMCW;
      Name := 'PictureOK';
      Left := 851;
      Top := 687;
      Width := 129;
      Height := 39;
      Caption := GetLanguage('picturebox_button_ok.caption');
      OnClick := bt.MCWOKClick;
    end;
    exit;
  end;
  with FormMCW do begin
    Name := nme;
    ClientHeight := 257;
    ClientWidth := 500;
    Color := clBtnFace;
    BorderStyle := bsDialog;
    Position := poDesktopCenter;
  end;
  TitleMCW := TLabel.Create(FormMCW);
  with TitleMCW do begin
    Parent := FormMCW;
    Name := 'Title';
    AutoSize := False;
    Left := 8;
    Top := 8;
    Width := 484;
    Height := 25;
    Font.Charset := ANSI_CHARSET;
    Font.Name := '微软雅黑';
    Font.Height := -20;
    Font.Style := [fsBold];
  end;
  CutMCW := TLabel.Create(FormMCW);
  with CutMCW do begin
    Parent := FormMCW;
    Name := 'CutLine';
    Left := 8;
    Top := 39;
    Width := 485;
    Height := 15;
    AutoSize := true;
    Caption := '-------------------------------------------------------------------------------------------------';
  end;
  ContentMCW := TMemo.Create(FormMCW);
  with ContentMCW do begin
    Parent := FormMCW;
    Name := 'Content';
    Left := 8;
    Top := 60;
    Width := 484;
    Height := 126;
    Font.Color := clWindowText;
    Font.Charset := ANSI_CHARSET;
    Font.Name := '微软雅黑';
    Font.Height := -16;
    Color := clbtnface;
    BorderStyle := bsNone;
    ReadOnly := True;
    ScrollBars := ssVertical;
  end;
  if nme = 'MyInputBox' then begin
    InputMCW := TEdit.Create(FormMCW);
    with InputMCW do begin
      Parent := FormMCW;
      Name := 'Input';
      Left := 8;
      Top := 192;
      Width := 484;
      Height := 23;
      Font.Charset := ANSI_CHARSET;
      Text := '';
    end;
    OkMCW := TButton.Create(FormMCW);
    with OkMCW do begin
      Parent := FormMCW;
      Name := 'InputOk';
      Left := 286;
      Top := 221;
      Width := 100;
      Height := 28;
      Caption := GetLanguage('inputbox_button_yes.caption');
      OnClick := bt.MCWOKClick;
    end;
    CancalMCW := TButton.Create(FormMCW);
    with CancalMCW do begin
      Parent := FormMCW;
      Name := 'InputCancal';
      Left := 392;
      Top := 221;
      Width := 100;
      Height := 28;
      Caption := GetLanguage('inputbox_button_no.caption');
      OnClick := bt.MCWCancalClick;
    end;
  end;
end;
procedure btn.MCWOKClick(Sender: TObject);
begin
  if (Sender as TButton).Name = 'PictureOK' then begin
    FormMCW.Close;
  end else begin
    ResInput := InputMCW.Text;
    FormMCW.Close;
  end;
end;
procedure btn.MCWCancalClick(Sender: TObject);
begin
  ResInput := '';
  FormMCW.Close;
end;
procedure btn.MCWButtonClick(Sender: TObject);
begin
  case (Sender as TButton).Left of
    74: ResMessage := 4;
    180: ResMessage := 3;
    286: ResMessage := 2;
    392: ResMessage := 1;
  end;
  FormMCW.Close;
end;
//自定义信息框
function MyMessageBox(title, content: String; color: Integer; button: TArray<MyButton>; custom: TArray<String> = []; defbutton: Integer = 1): Integer;
begin
  TThread.Synchronize(nil, procedure begin
    InitMCW('MyMessageBox');
    ContentMCW.Lines.Clear;
    TitleMCW.Caption := title;
    ContentMCW.Lines.Add(content);
    case color of
      MY_ERROR: begin TitleMCW.Font.Color := rgb(255, 10, 10); CutMCW.Font.Color := clRed; end;
      MY_WARNING: begin TitleMCW.Font.Color := rgb(255, 215, 10); CutMCW.Font.Color := clYellow; end;
      MY_INFORMATION: begin TitleMCW.Font.Color := rgb(10, 10, 255); CutMCW.Font.Color := clBlue; end;
      MY_PASS: begin TitleMCW.Font.Color := rgb(10, 192, 10); CutMCW.Font.Color := clGreen; end;
      else raise Exception.Create('So much color');
    end;
    var len := Length(button);
    if (len < 1) or (len > 4) then raise Exception.Create('So much button');
    SetLength(tbt, len);
    for var I := 0 to len - 1 do begin
      tbt[I] := TButton.Create(FormMCW);
      tbt[I].Parent := FormMCW;
      tbt[I].Width := 100;
      tbt[I].Height := 50;
      tbt[I].Top := 192;
      tbt[I].WordWrap := true;
      case I of
        0: tbt[I].Left := 392;
        1: tbt[I].Left := 286;
        2: tbt[I].Left := 180;
        3: tbt[I].Left := 74;
      end;
      tbt[I].OnClick := bt.MCWButtonClick;
    end;
    if (defbutton > len) or (defbutton < 1) then raise Exception.Create('So much default button');
    tbt[defbutton - 1].Default := true;
    var O := 0;
    var P := 0;
    for var I := 0 to len - 1 do begin
      case button[I] of
        myYes: tbt[O].Caption := GetLanguage('messagebox_button_yes.caption');
        myOK: tbt[O].Caption := GetLanguage('messagebox_button_ok.caption');
        myNo: tbt[O].Caption := GetLanguage('messagebox_button_no.caption');
        myCancal: tbt[O].Caption := GetLanguage('messagebox_button_cancel.caption');
        myRetry: tbt[O].Caption := GetLanguage('messagebox_button_retry.caption');
        myAbort: tbt[O].Caption := GetLanguage('messagebox_button_abort.caption');
        myIgnore: tbt[O].Caption := GetLanguage('messagebox_button_ignore.caption');
        myCustom: begin tbt[O].Caption := custom[P]; inc(P); end;
      end;
      inc(O);
    end;
    FormMCW.ShowModal;
  end);
  Result := ResMessage;
end;
//自定义输入框
function MyInputBox(title, content: String; color: Integer; defcontent: String = ''; defbutton: Integer = 1): String;
begin
  TThread.Synchronize(nil, procedure begin
    InitMCW('MyInputBox');
    if (defbutton > 2) or (defbutton < 1) then raise Exception.Create('So much default button');
    ContentMCW.Lines.Clear;
    TitleMCW.Caption := title;
    ContentMCW.Lines.Add(content);
    case color of
      MY_ERROR: begin TitleMCW.Font.Color := clRed; CutMCW.Font.Color := clRed; end;
      MY_WARNING: begin TitleMCW.Font.Color := clYellow; CutMCW.Font.Color := clYellow; end;
      MY_INFORMATION: begin TitleMCW.Font.Color := clBlue; CutMCW.Font.Color := clBlue; end;
      MY_PASS: begin TitleMCW.Font.Color := clGreen; CutMCW.Font.Color := clGreen; end;
      else raise Exception.Create('So much color');
    end;
    case defbutton of
      1: OkMCW.Default := true;
      2: CancalMCW.Default := true;
      else raise Exception.Create('Not Support');
    end;
    InputMCW.Text := defcontent;
    FormMCW.ShowModal;
  end);
  Result := ResInput;
end;
//自定义图片信息框【专用于模组信息显示】
procedure MyPictureBox(title, content: String; web: TStringStream);
begin
  InitMCW('MyPictureBox');
  PicTitleMCW.Lines.Clear;
  ContentMCW.Lines.Clear;
  PicTitleMCW.Lines.Add(title);
  ContentMCW.Lines.Add(content);
  try PictureMCW.Picture.LoadFromStream(web); except end;
  FormMCW.ShowModal;
end;
end.

