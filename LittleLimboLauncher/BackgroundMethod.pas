unit BackgroundMethod;

interface

uses
  Dialogs, Windows, SysUtils, Forms, WinXCtrls;

procedure InitBackground;
procedure SaveBackground;

var
  mselect_type, mwindow_control: Integer;

implementation

uses
  mainform, LanguageMethod;

var f: Boolean = false;
//初始化背景
procedure InitBackground;
begin
  if f then exit;
  f := true;
  form_mainform.label_background_window_current_alpha.Caption := GetLanguage('label_background_window_current_alpha.caption').Replace('${window_alpha}', inttostr(mwindow_alpha));
  form_mainform.label_background_control_current_alpha.Caption := GetLanguage('label_background_control_current_alpha.caption').Replace('${control_alpha}', inttostr(mcontrol_alpha));
  form_mainform.scrollbar_background_window_alpha.Position := mwindow_alpha;
  form_mainform.scrollbar_background_control_alpha.Position := mcontrol_alpha;
  form_mainform.edit_background_mainform_title.Text := LLLini.ReadString('Misc', 'LauncherName', '');
  try
    mselect_type := LLLini.ReadInteger('Misc', 'SelectType', -1);
    case mselect_type of
      1: form_mainform.radiobutton_background_music_open.Checked := true;
      2: form_mainform.radiobutton_background_music_launch.Checked := true;
      3: form_mainform.radiobutton_background_music_not.Checked := true;
      else raise Exception.Create('Format Exception');
    end;
  except
    mselect_type := 3;
    LLLini.WriteInteger('Misc', 'SelectType', mselect_type);
    form_mainform.radiobutton_background_music_not.Checked := true;
  end;
  try
    mwindow_control := LLLini.ReadInteger('Misc', 'WindowControl', -1);
    case mwindow_control of
      1: form_mainform.radiobutton_background_launch_hide.Checked := true;
      2: form_mainform.radiobutton_background_launch_show.Checked := true;
      3: form_mainform.radiobutton_background_launch_exit.Checked := true;
      else raise Exception.Create('Format Exception');
    end;
  except
    mwindow_control := 2;
    LLLini.WriteInteger('Misc', 'WindowControl', mwindow_control);
    form_mainform.radiobutton_background_launch_show.Checked := true;
  end;
  form_mainform.scrollbar_background_gradient_value.Position := mgradient_value;
  form_mainform.scrollbar_background_gradient_step.Position := mgradient_step;
  form_mainform.label_background_gradient_current_value.Caption := GetLanguage('label_background_gradient_current_value.caption').Replace('${gradient_value}', inttostr(mgradient_value));
  form_mainform.label_background_gradient_current_step.Caption := GetLanguage('label_background_gradient_current_step.caption').Replace('${gradient_step}', inttostr(mgradient_step));
  if mis_gradient then begin
    form_mainform.toggleswitch_background_gradient.State := tsson;
    form_mainform.scrollbar_background_gradient_step.Enabled := true;
    form_mainform.scrollbar_background_gradient_value.Enabled := true;
  end else begin
    form_mainform.toggleswitch_background_gradient.State := tssoff;
    form_mainform.scrollbar_background_gradient_step.Enabled := false;
    form_mainform.scrollbar_background_gradient_value.Enabled := false;
  end;
  form_mainform.edit_background_mainform_title.Text := form_mainform.Caption;
end;
//保存背景
procedure SaveBackground;
begin
  LLLini.WriteInteger('Misc', 'Color', mcolor);
  LLLini.WriteInteger('Misc', 'WindowAlpha', mwindow_alpha);
  LLLini.WriteInteger('Misc', 'ControlAlpha', mcontrol_alpha);
  LLLini.WriteInteger('Misc', 'WindowControl', mwindow_control);
  LLLini.WriteInteger('Misc', 'SelectType', mselect_type);
  LLLini.WriteBool('Misc', 'IsGradient', mis_gradient);
  LLLini.WriteInteger('Misc', 'GradientValue', mgradient_value);
  LLLini.WriteInteger('Misc', 'GradientStep', mgradient_step);
  LLLini.WriteString('Misc', 'LauncherName', form_mainform.Caption);
end;

end.
