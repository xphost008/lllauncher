unit OnlineIPv6Method;

interface

uses
  StrUtils, SysUtils, Windows, ClipBrd, Classes;

procedure InitIPv6Online;
procedure ChangeIPv6List;
procedure ChangeIPv6Port;
procedure CopyIPv6Link;

implementation

uses
  MainForm, LanguageMethod, MainMethod, MyCustomWindow;

var
  mip: String;
//点击开始检测IPv6公网IP的按钮
procedure InitIPv6Online;
begin
  TThread.CreateAnonymousThread(procedure begin
    form_mainform.listbox_view_all_ipv6_ip.Items.Clear;
    form_mainform.label_online_ipv6_return_value.Caption := GetLanguage('label_online_ipv6_return_value.caption.check_ipv6_port');
    var ipcfg := RunDosBack1('cmd.exe /c ipconfig'); //获取ipconfig在命令行中的回显
    var cut: TArray<String>;
    cut := SplitString(ipcfg, #13);
    for var I in cut do begin
      if (I.CountChar(':') = 8) and (I.ToLower.IndexOf('ipv6') <> -1) then begin //判断字符串中冒号数量是否为8
        if (I.IndexOf('临时') = -1) and (I.tolower.IndexOf('temp') = -1) then begin
          var fp := I.Substring(I.IndexOf(':') + 2, I.Length); //判断是否为临时IPv6地址
          var pg := RunDosBack1(Concat('ping -n 1 ', fp));
          if (pg.IndexOf('超时') <> -1) or (pg.tolower.IndexOf('timeout') <> -1) then begin
            form_mainform.listbox_view_all_ipv6_ip.Items.Add(Concat('[', GetLanguage('listbox_view_all_ipv6_ip.caption.forever'), '][', GetLanguage('listbox_view_all_ipv6_ip.caption.timeout'), ']', fp));
          end else begin
            form_mainform.listbox_view_all_ipv6_ip.Items.Add(Concat('[', GetLanguage('listbox_view_all_ipv6_ip.caption.forever'), ']', fp));  //如果不是则添加为永久
          end;
        end else begin
          var fp := I.Substring(I.IndexOf('2'), I.Length);
          var pg := RunDosBack1(Concat('ping -n 1 ', fp));
          if (pg.IndexOf('超时') <> -1) or (pg.tolower.IndexOf('timeout') <> -1) then begin
            form_mainform.listbox_view_all_ipv6_ip.Items.Add(Concat('[', GetLanguage('listbox_view_all_ipv6_ip.caption.temp'), '][', GetLanguage('listbox_view_all_ipv6_ip.caption.timeout'), ']', fp));
          end else begin
            form_mainform.listbox_view_all_ipv6_ip.Items.Add(Concat('[', GetLanguage('listbox_view_all_ipv6_ip.caption.temp'), ']', fp));  //如果不是则添加为永久
          end;
        end;
      end;
    end; //判断是否未检测到IPv6公网地址。
    if form_mainform.listbox_view_all_ipv6_ip.Items.Count = 0 then begin
      form_mainform.label_online_ipv6_return_value.Caption := GetLanguage('label_online_ipv6_return_value.caption.not_support_ipv6');
    end else begin
      form_mainform.label_online_ipv6_return_value.Caption := GetLanguage('label_online_ipv6_return_value.caption.check_ipv6_success');
    end;
  end).Start;
end;
//复制IPv6公网IP与端口
procedure CopyIPv6Link;
begin
  try
    var fo := strtoint(form_mainform.edit_online_ipv6_port.Text);
    if (fo < 1024) or (fo > 65535) then raise Exception.Create('Format Exception');
  except
    MyMessagebox(GetLanguage('messagebox_ipv6.port_enter_error.caption'), GetLanguage('messagebox_ipv6.port_enter_error.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  if mip = '' then begin
    MyMessagebox(GetLanguage('messagebox_ipv6.no_ipv6_choose.caption'), GetLanguage('messagebox_ipv6.no_ipv6_choose.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  ClipBoard.SetTextBuf(pchar(Concat('[', mip, ']:', form_mainform.edit_online_ipv6_port.Text)));
  MyMessagebox(GetLanguage('messagebox_ipv6.copy_link_success.caption'), GetLanguage('messagebox_ipv6.copy_link_success.text'), MY_PASS, [mybutton.myOK]);
end;
//端口号被修改
procedure ChangeIPv6Port;
begin
  if form_mainform.listbox_view_all_ipv6_ip.ItemIndex < 0 then exit;
  form_mainform.label_online_ipv6_return_value.Caption := Concat(GetLanguage('label_online_ipv6_return_value.caption.current_ipv6_ip').Replace('${ip}', mip), ':', form_mainform.edit_online_ipv6_port.Text);
end;
//列表框修改
procedure ChangeIPv6List;
begin
  if form_mainform.listbox_view_all_ipv6_ip.ItemIndex < 0 then exit;
  form_mainform.listbox_view_all_ipv6_ip.Hint := form_mainform.listbox_view_all_ipv6_ip.Items[form_mainform.listbox_view_all_ipv6_ip.ItemIndex];
  mip := form_mainform.listbox_view_all_ipv6_ip.Items[form_mainform.listbox_view_all_ipv6_ip.ItemIndex].Replace(Concat('[', GetLanguage('listbox_view_all_ipv6_ip.caption.forever'), ']'), '').Replace(Concat('[', GetLanguage('listbox_view_all_ipv6_ip.caption.temp'), ']'), '');
  if mip.IndexOf(GetLanguage('listbox_view_all_ipv6_ip.caption.timeout')) <> -1 then begin
    MyMessagebox(GetLanguage('messagebox_ipv6.choose_ip_timeout.caption'), GetLanguage('messagebox_ipv6.choose_ip_timeout.text'), MY_ERROR, [mybutton.myOK]);
    mip := '';
    form_mainform.listbox_view_all_ipv6_ip.ItemIndex := -1;
    exit;
  end;
  form_mainform.label_online_ipv6_return_value.Caption := Concat(GetLanguage('label_online_ipv6_return_value.caption.current_ipv6_ip').Replace('${ip}', mip));
  if form_mainform.edit_online_ipv6_port.Text <> '' then form_mainform.label_online_ipv6_return_value.Caption := Concat(form_mainform.label_online_ipv6_return_value.Caption, ':', form_mainform.edit_online_ipv6_port.Text);
end;

end.
