unit DownloadProgressForm;
interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls;
type
  Tform_progress = class(TForm)
    progressbar_progress_download_bar: TProgressBar;
    listbox_progress_download_list: TListBox;
    button_progress_clean_download_list: TButton;
    label_progress_download_progress: TLabel;
    button_progress_cancel_download: TButton;
    button_progress_hide_show_details: TButton;
    button_progress_exit: TButton;
    label_progress_tips: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure button_progress_clean_download_listClick(Sender: TObject);
    procedure button_progress_hide_show_detailsClick(Sender: TObject);
    procedure button_progress_exitClick(Sender: TObject);
    procedure button_progress_cancel_downloadClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  form_progress: Tform_progress;
implementation
uses MainForm, DownloadMethod;
{$R *.dfm}
//清空列表框的按钮
procedure Tform_progress.button_progress_clean_download_listClick(Sender: TObject);
begin
  progressbar_progress_download_bar.Position := 0;
  listbox_progress_download_list.Items.Clear;
  label_progress_download_progress.Caption := '下载进度：0%';
end;
//取消下载的按钮。
//尝试制作取消下载功能【第一次（2023.3.24-20:32）尝试：失败】
procedure Tform_progress.button_progress_cancel_downloadClick(Sender: TObject);
begin
  messagebox(Application.Handle, '暂未完成，请稍后！', '暂未完成', MB_ICONWARNING);
end;
//隐藏/显示详情的方法
procedure Tform_progress.button_progress_hide_show_detailsClick(Sender: TObject);
begin
  if listbox_progress_download_list.Visible then begin
    button_progress_hide_show_details.Caption := '显示详情【Show Details】';
    listbox_progress_download_list.Visible := false;
  end else begin
    button_progress_hide_show_details.Caption := '隐藏详情【Hide Details】';
    listbox_progress_download_list.Visible := true;
  end;
end;
//完成的按钮
procedure Tform_progress.button_progress_exitClick(Sender: TObject);
begin
  Close;
end;
//窗口创建的按钮
procedure Tform_progress.FormCreate(Sender: TObject);
var
  tr, tg, tb, ta: Integer;
begin
  try //判断RGBA
    tr := strtoint(LLLini.ReadString('Misc', 'r', ''));
    if (tr > 255) or (tr < 0) then raise Exception.Create('Format Exception');
  except
    tr := 240;
    LLLini.WriteString('Misc', 'r', '240');
  end;
  try
    tg := strtoint(LLLini.ReadString('Misc', 'g', ''));
    if (tg > 255) or (tg < 0) then raise Exception.Create('Format Exception');
  except
    tg := 240;
    LLLini.WriteString('Misc', 'g', '240');
  end;
  try
    tb := strtoint(LLLini.ReadString('Misc', 'b', ''));
    if (tb > 255) or (tb < 0) then raise Exception.Create('Format Exception');
  except
    tb := 240;
    LLLini.WriteString('Misc', 'b', '240');
  end;
  try
    ta := strtoint(LLLini.ReadString('Misc', 'a', ''));
    if (ta > 255) or (ta < 127) then raise Exception.Create('Format Exception');
  except
    ta := 255;
    LLLini.WriteString('Misc', 'a', '255');
  end;
  //实装RGBA。
  Color := rgb(tr, tg, tb);
  AlphaBlendValue := ta;
end;
end.
