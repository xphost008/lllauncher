unit ExportMethod;

interface

uses
  SysUtils, Windows, Forms, IniFiles, WinXCtrls, Math;

procedure InitIsolation;
procedure InitExport;
procedure IsoMethod(k: Integer; v: String);

implementation

uses
  VersionMethod, MainForm, LanguageMethod, MyCustomWindow;

var
  IsoIni: TIniFile;

procedure InitIsolation;
var
  status: TMemoryStatus;
  mis_isolation, mis_csize, mis_cmemory, mis_partition: Boolean;
begin
  if mselect_ver < 0 then begin
    MyMessagebox(GetLanguage('messagebox_version.no_ver_dir.caption'), GetLanguage('messagebox_version.no_ver_dir.text'), MY_ERROR, [mybutton.myOK]);
    form_mainform.pagecontrol_version_part.ActivePage := form_mainform.tabsheet_version_control_part;
    exit;
  end;
  var sv := MCVersionSelect[mselect_ver];
  form_mainform.label_isolation_current_version.Caption := GetLanguage('label_isolation_current_version.caption').Replace('${current_version}', ExtractFileName(MCVersionSelect[mselect_ver]));
  IsoIni := TIniFile.Create(Concat(sv, '\LLLauncher.ini'));
  form_mainform.scrollbar_isolation_window_width.Max := GetSystemMetrics(SM_CXSCREEN) - 1;
  form_mainform.scrollbar_isolation_window_height.Max := GetSystemMetrics(SM_CYSCREEN) - 1;
  GlobalMemoryStatus(status);
  var mem: Integer := ceil(status.dwTotalPhys / 1024 / 1024);
  form_mainform.scrollbar_isolation_game_memory.Max := mem;
  mis_isolation := IsoIni.ReadBool('Isolation', 'IsIsolation', false);
  if mis_isolation then form_mainform.toggleswitch_is_open_isolation.State := tsson
  else form_mainform.toggleswitch_is_open_isolation.State := tssoff;
  form_mainform.edit_isolation_java_path.Text := IsoIni.ReadString('Isolation', 'JavaPath', '');
  form_mainform.edit_isolation_custom_info.Text := IsoIni.ReadString('Isolation', 'CustomInfo', '');
  form_mainform.edit_isolation_window_title.Text := IsoIni.ReadString('Isolation', 'CustomTitle', '');
  mis_csize := IsoIni.ReadBool('Isolation', 'IsSize', false);
  if mis_csize then form_mainform.toggleswitch_isolation_window_size.State := tsson
  else form_mainform.toggleswitch_isolation_window_size.State := tssoff;
  form_mainform.scrollbar_isolation_window_width.Position := IsoIni.ReadInteger('Isolation', 'Width', 854);
  if (form_mainform.scrollbar_isolation_window_width.Position > form_mainform.scrollbar_isolation_window_width.Max) or (form_mainform.scrollbar_isolation_window_width.Position < 854) then begin
    form_mainform.scrollbar_isolation_window_width.Position := 854;
    IsoIni.WriteInteger('Isolation', 'Width', 854);
  end;
  form_mainform.label_isolation_window_width.Caption := GetLanguage('label_isolation_window_width.caption').Replace('${current_width}', inttostr(form_mainform.scrollbar_isolation_window_width.Position));
  form_mainform.scrollbar_isolation_window_height.Position := IsoIni.ReadInteger('Isolation', 'Height', 480);
  if (form_mainform.scrollbar_isolation_window_height.Position > form_mainform.scrollbar_isolation_window_height.Max) or (form_mainform.scrollbar_isolation_window_height.Position < 480) then begin
    form_mainform.scrollbar_isolation_window_height.Position := 480;
    IsoIni.WriteInteger('Isolation', 'Height', 480);
  end;
  form_mainform.label_isolation_window_height.Caption := GetLanguage('label_isolation_window_height.caption').Replace('${current_height}', inttostr(form_mainform.scrollbar_isolation_window_height.Position));
  mis_cmemory := IsoIni.ReadBool('Isolation', 'IsMemory', false);
  if mis_cmemory then form_mainform.toggleswitch_isolation_open_memory.State := tsson
  else form_mainform.toggleswitch_isolation_open_memory.State := tssoff;
  form_mainform.scrollbar_isolation_game_memory.Position := IsoIni.ReadInteger('Isolation', 'MaxMemory', 1024);
  if (form_mainform.scrollbar_isolation_game_memory.Position > form_mainform.scrollbar_isolation_game_memory.Max) or (form_mainform.scrollbar_isolation_game_memory.Position < 1024) then begin
    form_mainform.scrollbar_isolation_game_memory.Position := 1024;
    IsoIni.WriteInteger('Isolation', 'MaxMemory', 1024);
  end;
  form_mainform.label_isolation_game_memory.Caption := GetLanguage('label_isolation_game_memory.caption').Replace('${current_memory}', inttostr(form_mainform.scrollbar_isolation_game_memory.Position));
  mis_partition := IsoIni.ReadBool('Isolation', 'IsPartition', false);
  if mis_partition then form_mainform.toggleswitch_isolation_open_partition.State := tsson
  else form_mainform.toggleswitch_isolation_open_partition.State := tssoff;
  form_mainform.checkbox_isolation_is_partition.Checked := IsoIni.ReadBool('Isolation', 'OpenPartition', false);
  form_mainform.edit_isolation_additional_game.Text := IsoIni.ReadString('Isolation', 'AdditionalGame', '');
  form_mainform.edit_isolation_additional_jvm.Text := IsoIni.ReadString('Isolation', 'AdditionalJVM', '');
  form_mainform.edit_isolation_pre_launch_script.Text := IsoIni.ReadString('Isolation', 'Pre-LaunchScript', '');
  form_mainform.edit_isolation_after_launch_script.Text := IsoIni.ReadString('Isolation', 'After-LaunchScript', '');
  if mis_isolation then begin
    form_mainform.edit_isolation_java_path.Enabled := true;
    form_mainform.button_isolation_choose_java.Enabled := true;
    form_mainform.edit_isolation_custom_info.Enabled := true;
    form_mainform.edit_isolation_window_title.Enabled := true;
    form_mainform.toggleswitch_isolation_window_size.Enabled := true;
    form_mainform.scrollbar_isolation_window_width.Enabled := true;
    form_mainform.scrollbar_isolation_window_height.Enabled := true;
    form_mainform.toggleswitch_isolation_open_memory.Enabled := true;
    form_mainform.scrollbar_isolation_game_memory.Enabled := true;
    form_mainform.toggleswitch_isolation_open_partition.Enabled := true;
    form_mainform.checkbox_isolation_is_partition.Enabled := true;
    form_mainform.edit_isolation_additional_game.Enabled := true;
    form_mainform.edit_isolation_additional_jvm.Enabled := true;
    form_mainform.edit_isolation_pre_launch_script.Enabled := true;
    form_mainform.edit_isolation_after_launch_script.Enabled := true;
    if mis_csize then begin
      form_mainform.scrollbar_isolation_window_width.Enabled := true;
      form_mainform.scrollbar_isolation_window_height.Enabled := true;
    end else begin
      form_mainform.scrollbar_isolation_window_width.Enabled := false;
      form_mainform.scrollbar_isolation_window_height.Enabled := false;
    end;
    if mis_cmemory then begin
      form_mainform.scrollbar_isolation_game_memory.Enabled := true;
    end else begin
      form_mainform.scrollbar_isolation_game_memory.Enabled := false;
    end;
    if mis_partition then begin
      form_mainform.checkbox_isolation_is_partition.Enabled := true;
    end else begin
      form_mainform.checkbox_isolation_is_partition.Enabled := false;
    end;
  end else begin
    form_mainform.edit_isolation_java_path.Enabled := false;
    form_mainform.button_isolation_choose_java.Enabled := false;
    form_mainform.edit_isolation_custom_info.Enabled := false;
    form_mainform.edit_isolation_window_title.Enabled := false;
    form_mainform.toggleswitch_isolation_window_size.Enabled := false;
    form_mainform.scrollbar_isolation_window_width.Enabled := false;
    form_mainform.scrollbar_isolation_window_height.Enabled := false;
    form_mainform.toggleswitch_isolation_open_memory.Enabled := false;
    form_mainform.scrollbar_isolation_game_memory.Enabled := false;
    form_mainform.toggleswitch_isolation_open_partition.Enabled := false;
    form_mainform.checkbox_isolation_is_partition.Enabled := false;
    form_mainform.edit_isolation_additional_game.Enabled := false;
    form_mainform.edit_isolation_additional_jvm.Enabled := false;
    form_mainform.edit_isolation_pre_launch_script.Enabled := false;
    form_mainform.edit_isolation_after_launch_script.Enabled := false;
  end;
end;
procedure IsoMethod(k: Integer; v: String);
begin
  case k of
    1:  IsoIni.WriteBool('Isolation', 'IsIsolation', strtobool(v));
    2:  IsoIni.WriteString('Isolation', 'JavaPath', v);
    3:  IsoIni.WriteString('Isolation', 'CustomInfo', v);
    4:  IsoIni.WriteString('Isolation', 'CustomTitle', v);
    5:  IsoIni.WriteBool('Isolation', 'IsSize', strtobool(v));
    6:  IsoIni.WriteInteger('Isolation', 'Width', strtoint(v));
    7:  IsoIni.WriteInteger('Isolation', 'Height', strtoint(v));
    8:  IsoIni.WriteBool('Isolation', 'IsMemory', strtobool(v));
    9:  IsoIni.WriteInteger('Isolation', 'MaxMemory', strtoint(v));
    10: IsoIni.WriteBool('Isolation', 'IsPartition', strtobool(v));
    11: IsoIni.WriteBool('Isolation', 'OpenPartition', strtobool(v));
    12: IsoIni.WriteString('Isolation', 'AdditionalGame', v);
    13: IsoIni.WriteString('Isolation', 'AdditionalJVM', v);
    14: IsoIni.WriteString('Isolation', 'Pre-LaunchScript', v);
    15: IsoIni.WriteString('Isolation', 'After-LaunchScript', v);
    else raise Exception.Create('Not Support Key!');
  end;
end;
procedure InitExport;
begin

end;

end.
