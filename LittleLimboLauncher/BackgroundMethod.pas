unit BackgroundMethod;

interface

uses
  Dialogs, Windows, SysUtils, Forms, WinXCtrls;

procedure InitBackground;
procedure SaveBackground;

implementation

uses
  mainform, LanguageMethod;


var
  mselect_type, mwindow_control: Integer;
var f: Boolean = false;
//³õÊ¼»¯±³¾°
procedure InitBackground;
begin
  if f then exit;
  f := true;
  form_mainform.buttoncolor_custom_color.SymbolColor := rgb(mred, mgreen, mblue);
  form_mainform.label_background_window_current_alpha.Caption := GetLanguageText('label_background_window_current_alpha.caption').Replace('${background_window_alpha}', inttostr(mwindow_alpha));
  form_mainform.label_background_control_current_alpha.Caption := GetLanguageText('label_background_control_current_alpha.caption').Replace('${background_control_alpha}', inttostr(mcontrol_alpha));
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
  mgradient_value := LLLini.ReadInteger('Misc', 'GradientValue', -1);
  try
    if (mgradient_value > 100) or (mgradient_value < 1) then raise Exception.Create('Format Exception');
  except
    mgradient_value := 20;
    LLLini.WriteInteger('Misc', 'GradientValue', mgradient_value);
  end;
  mgradient_step := LLLini.ReadInteger('Misc', 'GradientStep', -1);
  try
    if (mgradient_step > 10) or (mgradient_step < 1) then raise Exception.Create('Format Exception');
  except
    mgradient_step := 10;
    LLLini.WriteInteger('Misc', 'GradientStep', mgradient_step);
  end;
  form_mainform.scrollbar_background_gradient_value.Position := mgradient_value;
  form_mainform.scrollbar_background_gradient_step.Position := mgradient_step;
  form_mainform.label_background_gradient_current_value.Caption := GetLanguageText('label_background_gradient_current_value.caption').Replace('${gradient_value}', inttostr(mgradient_value));
  form_mainform.label_background_gradient_current_step.Caption := GetLanguageText('label_background_gradient_current_step.caption').Replace('${gradient_step}', inttostr(mgradient_step));
  mis_gradient := LLLini.ReadBool('Misc', 'IsGradient', False);
  if mis_gradient then begin
    form_mainform.toggleswitch_background_gradient.State := tsson;
    form_mainform.scrollbar_background_gradient_step.Enabled := true;
    form_mainform.scrollbar_background_gradient_value.Enabled := true;
  end else begin
    form_mainform.toggleswitch_background_gradient.State := tssoff;
    form_mainform.scrollbar_background_gradient_step.Enabled := false;
    form_mainform.scrollbar_background_gradient_value.Enabled := false;
  end;
end;
//±£´æ±³¾°
procedure SaveBackground;
begin
  LLLini.WriteInteger('Misc', 'Red', mred);
  LLLini.WriteInteger('Misc', 'Green', mgreen);
  LLLini.WriteInteger('Misc', 'Blue', mblue);
  LLLini.WriteInteger('Misc', 'WindowAlpha', mwindow_alpha);
  LLLini.WriteInteger('Misc', 'ControlAlpha', mcontrol_alpha);
  LLLini.WriteInteger('Misc', 'WindowControl', mwindow_control);
  LLLini.WriteInteger('Misc', 'SelectType', mselect_type);
  LLLini.WriteBool('Misc', 'IsGradient', mis_gradient);
  LLLini.WriteInteger('Misc', 'GradientValue', mgradient_value);
  LLLini.WriteInteger('Misc', 'GradientStep', mgradient_step);
end;

end.
