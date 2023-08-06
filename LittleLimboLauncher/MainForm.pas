unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Forms, DateUtils, Dialogs,
  StdCtrls, pngimage, WinXCtrls, ComCtrls, VCLTee.TeCanvas, CheckLst, JSON, ShellAPI,
  IniFiles, Menus, ExtCtrls, Controls, Vcl.MPlayer, Log4Delphi, Vcl.Imaging.jpeg;

type
  Tform_mainform = class(TForm)
    mainmenu_mainpage: TMainMenu;
    n_misc: TMenuItem;
    n_message_board: TMenuItem;
    n_answer_book: TMenuItem;
    n_intro_self: TMenuItem;
    n_lucky_today: TMenuItem;
    n_puzzle_game: TMenuItem;
    popupmenu_view_minecraft_info: TPopupMenu;
    n_view_minecraft_info: TMenuItem;
    popupmenu_view_mod_info: TPopupMenu;
    n_view_mod_website: TMenuItem;
    n_view_mod_profile: TMenuItem;
    n_view_mod_mcmod: TMenuItem;
    pagecontrol_mainpage: TPageControl;
    tabsheet_mainpage_part: TTabSheet;
    label_account_view: TLabel;
    label_open_launcher_time: TLabel;
    label_open_launcher_number: TLabel;
    label_launch_game_number: TLabel;
    label_launch_tips: TLabel;
    image_refresh_background_music: TImage;
    image_refresh_background_image: TImage;
    image_finish_running_mc: TImage;
    image_open_download_prograss: TImage;
    button_launch_game: TButton;
    tabsheet_account_part: TTabSheet;
    label_login_avatar: TLabel;
    image_login_avatar: TImage;
    label_all_account: TLabel;
    label_account_return_value: TLabel;
    combobox_all_account: TComboBox;
    button_add_account: TButton;
    button_delete_account: TButton;
    button_refresh_account: TButton;
    button_account_get_uuid: TButton;
    pagecontrol_account_part: TPageControl;
    tabsheet_account_offline_part: TTabSheet;
    label_offline_name: TLabel;
    label_offline_uuid: TLabel;
    groupbox_offline_skin: TGroupBox;
    radiobutton_steve: TRadioButton;
    radiobutton_alex: TRadioButton;
    radiobutton_zuri: TRadioButton;
    radiobutton_sunny: TRadioButton;
    radiobutton_noor: TRadioButton;
    radiobutton_makena: TRadioButton;
    radiobutton_kai: TRadioButton;
    radiobutton_efe: TRadioButton;
    radiobutton_ari: TRadioButton;
    checkbox_slim: TCheckBox;
    edit_offline_name: TEdit;
    edit_offline_uuid: TEdit;
    button_offline_name_to_uuid: TButton;
    button_offline_uuid_to_name: TButton;
    tabsheet_account_microsoft_part: TTabSheet;
    label_microsoft_callback_link: TLabel;
    button_microsoft_oauth_login: TButton;
    button_microsoft_external_browser: TButton;
    edit_microsoft_callback_link: TEdit;
    tabsheet_account_thirdparty_part: TTabSheet;
    label_thirdparty_server: TLabel;
    label_thirdparty_account: TLabel;
    label_thirdparty_password: TLabel;
    edit_thirdparty_server: TEdit;
    edit_thirdparty_account: TEdit;
    edit_thirdparty_password: TEdit;
    tabsheet_playing_part: TTabSheet;
    label_playing_tip: TLabel;
    pagecontrol_playing_part: TPageControl;
    tabsheet_playing_download_part: TTabSheet;
    label_playing_search_name: TLabel;
    label_playing_search_version: TLabel;
    label_playing_return_value: TLabel;
    label_playing_search_category_modrinth_tip: TLabel;
    label_playing_search_version_tip: TLabel;
    label_playing_search_category_curseforge_tip: TLabel;
    label_playing_search_mode_tip: TLabel;
    label_playing_search_source_tip: TLabel;
    label_playing_search_name_tip: TLabel;
    listbox_playing_search_name: TListBox;
    listbox_playing_search_version: TListBox;
    button_playing_name_previous_page: TButton;
    button_playing_name_next_page: TButton;
    button_playing_version_previous_page: TButton;
    button_playing_version_next_page: TButton;
    edit_playing_search_name: TEdit;
    combobox_playing_search_source: TComboBox;
    combobox_playing_search_mode: TComboBox;
    combobox_playing_search_category_curseforge: TComboBox;
    combobox_playing_search_version: TComboBox;
    checklistbox_playing_search_category_modrinth: TCheckListBox;
    button_open_download_website: TButton;
    button_playing_start_search: TButton;
    button_playing_start_download: TButton;
    tabsheet_playing_manage_part: TTabSheet;
    tabsheet_download_part: TTabSheet;
    label_download_tip: TLabel;
    pagecontrol_download_part: TPageControl;
    tabsheet_download_minecraft_part: TTabSheet;
    label_choose_view_mode: TLabel;
    label_minecraft_version_name: TLabel;
    label_select_minecraft: TLabel;
    label_select_mod_loader: TLabel;
    label_download_return_value: TLabel;
    label_download_biggest_thread: TLabel;
    checklistbox_choose_view_mode: TCheckListBox;
    radiogroup_choose_download_source: TRadioGroup;
    edit_minecraft_version_name: TEdit;
    radiogroup_choose_mod_loader: TRadioGroup;
    listbox_select_minecraft: TListBox;
    button_reset_download_part: TButton;
    listbox_select_mod_loader: TListBox;
    button_load_mod_loader: TButton;
    button_download_start_download_minecraft: TButton;
    scrollbar_download_biggest_thread: TScrollBar;
    tabsheet_download_custom_part: TTabSheet;
    label_custom_download_url: TLabel;
    label_custom_download_name: TLabel;
    label_custom_download_path: TLabel;
    label_custom_download_path_enter: TLabel;
    edit_custom_download_url: TEdit;
    edit_custom_download_name: TEdit;
    button_custom_download_choose_path: TButton;
    button_custom_download_open_path: TButton;
    button_custom_download_start: TButton;
    tabsheet_download_mod_loader_part: TTabSheet;
    label_download_mod_loader_forge: TLabel;
    label_download_mod_loader_fabric: TLabel;
    label_download_mod_loader_quilt: TLabel;
    label_download_mod_loader_neoforge: TLabel;
    listbox_download_mod_loader_forge: TListBox;
    listbox_download_mod_loader_fabric: TListBox;
    listbox_download_mod_loader_quilt: TListBox;
    listbox_download_mod_loader_neoforge: TListBox;
    button_download_mod_loader_download: TButton;
    button_download_mod_loader_refresh: TButton;
    tabsheet_online_part: TTabSheet;
    label_online_tip: TLabel;
    pagecontrol_online_part: TPageControl;
    tabsheet_online_ipv6_part: TTabSheet;
    button_check_ipv6_ip: TButton;
    label_online_ipv6_return_value: TLabel;
    listbox_view_all_ipv6_ip: TListBox;
    label_online_ipv6_port: TLabel;
    edit_online_ipv6_port: TEdit;
    button_copy_ipv6_ip_and_port: TButton;
    button_online_ipv6_tip: TButton;
    label_manage_import_modpack: TLabel;
    listbox_manage_import_modpack: TListBox;
    listbox_manage_import_mod: TListBox;
    listbox_manage_import_map: TListBox;
    listbox_manage_import_resourcepack: TListBox;
    listbox_manage_import_shader: TListBox;
    listbox_manage_import_datapack: TListBox;
    listbox_manage_import_plugin: TListBox;
    label_manage_import_mod: TLabel;
    label_manage_import_map: TLabel;
    label_manage_import_resourcepack: TLabel;
    label_manage_import_shader: TLabel;
    label_manage_import_datapack: TLabel;
    label_manage_import_plugin: TLabel;
    button_disable_choose_playing: TButton;
    button_enable_choose_playing: TButton;
    button_delete_choose_playing: TButton;
    button_rename_choose_playing: TButton;
    button_open_choose_playing: TButton;
    tabsheet_background_part: TTabSheet;
    image_mainpage_background_image: TImage;
    n_official: TMenuItem;
    n_entry_official_website: TMenuItem;
    n_sponsor_author: TMenuItem;
    n_sponsor_bmclapi: TMenuItem;
    n_manual: TMenuItem;
    n_reset_launcher: TMenuItem;
    n_export_argument: TMenuItem;
    n_current_version: TMenuItem;
    n_check_update: TMenuItem;
    n_test_button: TMenuItem;
    n_languages: TMenuItem;
    n_plugins: TMenuItem;
    label_background_tip: TLabel;
    label_standard_color: TLabel;
    button_grass_color: TButton;
    button_sun_color: TButton;
    button_sultan_color: TButton;
    button_sky_color: TButton;
    button_cute_color: TButton;
    button_normal_color: TButton;
    buttoncolor_custom_color: TButtonColor;
    scrollbar_background_window_alpha: TScrollBar;
    label_background_window_alpha: TLabel;
    label_background_window_current_alpha: TLabel;
    groupbox_background_music_setting: TGroupBox;
    button_background_play_music: TButton;
    button_background_pause_music: TButton;
    button_background_stop_music: TButton;
    radiobutton_background_music_open: TRadioButton;
    radiobutton_background_music_launch: TRadioButton;
    radiobutton_background_music_not: TRadioButton;
    groupbox_background_launch_setting: TGroupBox;
    radiobutton_background_launch_hide: TRadioButton;
    radiobutton_background_launch_show: TRadioButton;
    radiobutton_background_launch_exit: TRadioButton;
    groupbox_background_gradient: TGroupBox;
    toggleswitch_background_gradient: TToggleSwitch;
    label_background_mainform_title: TLabel;
    edit_background_mainform_title: TEdit;
    label_background_control_alpha: TLabel;
    scrollbar_background_control_alpha: TScrollBar;
    label_background_control_current_alpha: TLabel;
    tabsheet_launch_part: TTabSheet;
    label_launch_window_size: TLabel;
    label_launch_window_default_tip: TLabel;
    label_launch_java_path: TLabel;
    combobox_launch_select_java_path: TComboBox;
    label_launch_java_logic: TLabel;
    button_launch_full_scan_java: TButton;
    button_launch_basic_scan_java: TButton;
    button_launch_manual_import: TButton;
    button_launch_remove_java: TButton;
    button_launch_download_java_8: TButton;
    button_launch_download_java_17: TButton;
    button_launch_download_java_16: TButton;
    button_launch_official_java: TButton;
    label_launch_custom_info: TLabel;
    edit_launch_custom_info: TEdit;
    label_launch_custom_info_default: TLabel;
    label_launch_game_title: TLabel;
    edit_launch_game_title: TEdit;
    label_launch_game_title_default: TLabel;
    label_launch_pre_launch_script: TLabel;
    edit_launch_pre_launch_script: TEdit;
    button_launch_pre_launch_script_tip: TButton;
    label_launch_default_jvm_argument: TLabel;
    edit_launch_default_jvm_argument: TEdit;
    button_launch_default_jvm_argument_tip: TButton;
    label_launch_additional_jvm_argument: TLabel;
    edit_launch_additional_jvm_argument: TEdit;
    button_launch_additional_jvm_argument_tip: TButton;
    label_launch_additional_game_argument: TLabel;
    edit_launch_additional_game_argument: TEdit;
    button_launch_additional_game_argument_tip: TButton;
    tabsheet_version_part: TTabSheet;
    pagecontrol_version_part: TPageControl;
    label_version_tip: TLabel;
    tabsheet_version_control_part: TTabSheet;
    tabsheet_version_isolation_part: TTabSheet;
    label_select_game_version: TLabel;
    label_select_file_list: TLabel;
    combobox_select_game_version: TComboBox;
    combobox_select_file_list: TComboBox;
    label_version_name: TLabel;
    button_version_choose_any_directory: TButton;
    button_version_create_minecraft: TButton;
    label_version_add_mc_path: TLabel;
    label_version_choose_path: TLabel;
    edit_version_name: TEdit;
    label_version_current_path: TLabel;
    tabsheet_version_export_part: TTabSheet;
    radiogroup_partition_version: TRadioGroup;
    button_add_version_to_list: TButton;
    button_version_complete: TButton;
    button_clear_version_list: TButton;
    button_rename_version_list: TButton;
    button_remove_version_list: TButton;
    button_rename_game_version: TButton;
    button_delete_game_version: TButton;
    label_isolation_current_version: TLabel;
    label_is_open_isolation: TLabel;
    toggleswitch_is_open_isolation: TToggleSwitch;
    label_isolation_java_path: TLabel;
    edit_isolation_java_path: TEdit;
    button_isolation_choose_java: TButton;
    label_isolation_custom_info: TLabel;
    edit_isolation_custom_info: TEdit;
    edit_isolation_window_title: TEdit;
    label_isolation_window_title: TLabel;
    label_isolation_window_size: TLabel;
    edit_isolation_window_width: TEdit;
    label_isolation_window_x: TLabel;
    edit_launch_window_height: TEdit;
    label_launch_game_memory: TLabel;
    scrollbar_launch_game_memory: TScrollBar;
    label_launch_current_memory: TLabel;
    label_isolation_game_memory: TLabel;
    scrollbar_isolation_game_memory: TScrollBar;
    label_isolation_current_memory: TLabel;
    toggleswitch_isolation_open_memory: TToggleSwitch;
    label_isolation_partition: TLabel;
    toggleswitch_isolation_open_partition: TToggleSwitch;
    radiobutton_isolation_open_partition: TRadioButton;
    radiobutton_isolation_close_partition: TRadioButton;
    toggleswitch_isolation_choose_java: TToggleSwitch;
    label_isolation_additional_game: TLabel;
    edit_isolation_additional_game: TEdit;
    label_isolation_additional_jvm: TLabel;
    edit_isolation_additional_jvm: TEdit;
    label_isolation_pre_launch_script: TLabel;
    edit_isolation_pre_launch_script: TEdit;
    label_isolation_tip: TLabel;
    label_export_current_version: TLabel;
    label_export_mode: TLabel;
    radiobutton_export_mcbbs: TRadioButton;
    edit_export_modpack_name: TEdit;
    radiobutton_export_multimc: TRadioButton;
    label_export_mode_more: TLabel;
    label_export_modpack_name: TLabel;
    edit_export_modpack_author: TEdit;
    label_export_modpack_author: TLabel;
    label_export_modpack_version: TLabel;
    edit_export_modpack_version: TEdit;
    edit_export_update_link: TEdit;
    label_export_update_link: TLabel;
    label_export_official_website: TLabel;
    edit_export_official_website: TEdit;
    label_export_mcbbs_tid: TLabel;
    edit_export_mcbbs_tid: TEdit;
    label_export_authentication_server: TLabel;
    edit_export_authentication_server: TEdit;
    label_export_additional_game: TLabel;
    edit_export_additional_game: TEdit;
    label_export_additional_jvm: TLabel;
    edit_export_additional_jvm: TEdit;
    label_export_max_memory: TLabel;
    scrollbar_export_max_memory: TScrollBar;
    memo_export_modpack_profile: TMemo;
    label_export_modpack_profile: TLabel;
    treeview_export_keep_file: TTreeView;
    label_export_keep_file: TLabel;
    button_export_start: TButton;
    label_export_current_memory: TLabel;
    timer_all_ticks: TTimer;
    timer_form_gradient_tick: TTimer;
    scrollbar_background_gradient_value: TScrollBar;
    label_background_gradient_value: TLabel;
    label_background_gradient_current_value: TLabel;
    scrollbar_background_gradient_step: TScrollBar;
    label_background_gradient_step: TLabel;
    label_background_gradient_current_step: TLabel;
    scrollbar_launch_window_width: TScrollBar;
    scrollbar_launch_window_height: TScrollBar;
    label_launch_window_current_height: TLabel;
    label_launch_window_current_width: TLabel;
    label_launch_download_java: TLabel;
    label_launch_window_height_tip: TLabel;
    label_launch_window_width_tip: TLabel;
    procedure button_launch_gameClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pagecontrol_mainpageChange(Sender: TObject);
    procedure pagecontrol_mainpageChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure scrollbar_background_window_alphaChange(Sender: TObject);
    procedure scrollbar_background_control_alphaChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure image_refresh_background_musicClick(Sender: TObject);
    procedure image_refresh_background_imageClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  LauncherVersion = '0.1.3-Beta-3';

var
  form_mainform: Tform_mainform;
  LLLini, OtherIni: TIniFile;
  AppData: String;
  Log: Log4D;
  crash_count: Integer = 0;
  mcpid: Integer = 0;
  Cave, Answer, Lucky: TStringList;
  Intro: array of array of String;
  v: TMediaPlayer;
var
  mopen_time, maccount_view: String;
  mopen_number, mlaunch_number: Integer;
  mred, mgreen, mblue, mwindow_alpha, mcontrol_alpha: Integer;
  mgradient_value, mgradient_step: Integer;
  mis_gradient: Boolean;

implementation

uses
  MainMethod, LaunchMethod, BackgroundMethod, LanguageMethod;

{$R *.dfm}

procedure Tform_mainform.button_launch_gameClick(Sender: TObject);
begin
//  var mm := TTabSheet.Create(pagecontrol_mainpage);
//  with mm do begin
//    mm.Parent := pagecontrol_mainpage;
//  end;
//  pagecontrol_mainpage.ActivePage := mm;
//  image_finish_running_mc.Cursor := crHelp;
//  mm.Show;
//  pagecontrol_mainpage.ActivePage := mm;
//  将控件的窗口样式设置为 WS_EX_LAYERED

//  使用 SetLayeredWindowAttributes 函数设置控件的透明度
//  showmessage('finish!!');
//  self.Color := buttonColor1.SymbolColor;
//  self.Color := 0;
end;
procedure Tform_mainform.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveBackground;
  ShellExecute(Application.Handle, 'open', 'taskkill.exe', '/F /IM LittleLimboLauncher.exe', nil, SW_HIDE);
end;
//窗口创建
procedure Tform_mainform.FormCreate(Sender: TObject);
begin
  Log := Log4D.Create;
  Log.Write('窗口创建！', LOG_INFO);
  AppData := GetEnvironmentVariable('AppData');
  Cave := TStringList.Create;
  Answer := TStringList.Create;
  Lucky := TStringList.Create;
  v := TMediaPlayer.Create(nil);
  Log.Write('初始化变量1完毕。', LOG_INFO);
  LLLini := TIniFile.Create(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\LittleLimboLauncher.ini'));
  OtherIni := TIniFile.Create(Concat(AppData, '\LLLauncher\Other.ini'));
  if not SysUtils.DirectoryExists(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher')) then
    SysUtils.ForceDirectories(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher'));
  if not SysUtils.DirectoryExists(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\plugins')) then
    SysUtils.ForceDirectories(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\plugins'));
  if not SysUtils.DirectoryExists(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\BackGroundMusic')) then
    SysUtils.ForceDirectories(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\BackGroundMusic'));
  if not SysUtils.DirectoryExists(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\BackGroundImage')) then
    SysUtils.ForceDirectories(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\BackGroundImage'));
  if not SysUtils.DirectoryExists(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs')) then
    SysUtils.ForceDirectories(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs'));
  if not SysUtils.DirectoryExists(Concat(AppData, '\LLLauncher\')) then
    SysUtils.ForceDirectories(Concat(AppData, '\LLLauncher\'));
  if not SysUtils.FileExists(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\', 'LittleLimboLauncher.ini')) then
  begin
    LLLini.WriteString('Version', 'CustomInfo', 'LLL');
    LLLini.WriteBool('Version', 'ShowRelease', True);
    LLLini.WriteBool('Version', 'ShowSnapshot', False);
    LLLini.WriteBool('Version', 'ShowOldBeta', False);
    LLLini.WriteBool('Version', 'ShowOldAlpha', False);
    LLLini.WriteInteger('Version', 'SelectDownloadSource', 1);
    LLLini.WriteInteger('Version', 'SelectIsolation', 4);
    LLLini.WriteInteger('Version', 'ThreadBiggest', 32);
    LLLini.WriteInteger('Mod', 'SelectModSource', 1);
    LLLini.WriteInteger('Mod', 'SelectModMode', 1);
    LLLini.WriteInteger('Mod', 'SelectModCategory', 1);
    LLLini.WriteString('Mod', 'SelectModVersion', '');
    LLLini.WriteInteger('Mod', 'SelectModLoader', 1);
    LLLini.WriteInteger('Document', 'WindowsHeight', 480);
    LLLini.WriteInteger('Document', 'WindowsWidth', 854);
    LLLini.WriteInteger('Document', 'MaxMemory', 1024);
    LLLini.WriteInteger('Misc', 'Red', 240);
    LLLini.WriteInteger('Misc', 'Green', 240);
    LLLini.WriteInteger('Misc', 'Blue', 240);
    LLLini.WriteInteger('Misc', 'WindowAlpha', 255);
    LLLini.WriteInteger('Misc', 'ControlAlpha', 195);
    LLLini.WriteInteger('Misc', 'WindowControl', 2);
    LLLini.WriteInteger('Misc', 'SelectType', 3);
    LLLini.WriteBool('Misc', 'IsGradient', False);
    LLLini.WriteInteger('Misc', 'GradientValue', 20);
    LLLini.WriteString('Misc', 'LauncherName', 'Little Limbo Launcher (Delphi)');
    LLLini.WriteInteger('Account', 'SelectLoginMode', 1);
  end;
  if not FileExists(Concat(AppData, '\LLLauncher\Other.ini')) then begin
    Otherini.WriteString('Other', 'Random', inttostr(random(2000000) + 1));
    Otherini.WriteString('Misc', 'Launcher', '0');
    Otherini.WriteString('Misc', 'StartGame', '0');
  end;
  Log.Write('初始化变量2完毕。', LOG_INFO); //输出Log
  Log.Write('判断完成窗口创建事件！', LOG_INFO);
end;
//窗口已经开始展示
procedure Tform_mainform.FormShow(Sender: TObject);
begin
  pagecontrol_mainpage.ActivePage := tabsheet_mainpage_part;
  pagecontrol_account_part.ActivePage := tabsheet_account_offline_part;
  pagecontrol_playing_part.ActivePage := tabsheet_playing_download_part;
  pagecontrol_download_part.ActivePage := tabsheet_download_minecraft_part;
  pagecontrol_online_part.ActivePage := tabsheet_online_ipv6_part;
  pagecontrol_version_part.ActivePage := tabsheet_version_control_part;
  v.ParentWindow := Handle;
  v.Visible := False;
  Log.Write('开始判断窗口显示事件！', LOG_INFO);
  try  //判断打开启动器的次数
    Log.Write('开始判断打开启动器次数。', LOG_INFO);
    mopen_number := Otherini.ReadInteger('Misc', 'Launcher', -1) + 1;
    if mopen_number < 1 then raise Exception.Create('Format Exception');
    Otherini.WriteString('Misc', 'Launcher', inttostr(mopen_number));
    Log.Write(Concat('判断成功，打开启动器次数为', inttostr(mopen_number), '次。'), LOG_INFO);
  except
    mopen_number := 1;
    Log.Write('判断打开启动器次数失败，默认降为1次。', LOG_ERROR);
    Otherini.WriteString('Misc', 'Launcher', inttostr(mopen_number));
    label_open_launcher_number.Caption := Concat('打开启动器次数：', inttostr(mopen_number));
  end;
  label_open_launcher_number.Caption := GetLanguageText('label_open_launcher_number.caption').Replace('${open_launcher_number}', inttostr(mopen_number));
  try  //判断启动游戏的次数
    Log.Write(Concat('开始判断启动游戏的次数。'), LOG_INFO);
    mlaunch_number := Otherini.ReadInteger('Misc', 'StartGame', -1);
    if mlaunch_number < 0 then raise Exception.Create('Format Exception');
    Log.Write(Concat('判断成功，启动游戏次数为', inttostr(mlaunch_number), '次。'), LOG_INFO);
  except
    mlaunch_number := 0;
    Log.Write(Concat('判断启动游戏次数失败，默认降为1次。'), LOG_ERROR);
    Otherini.WriteString('Misc', 'StartGame', inttostr(mlaunch_number));
  end;
  label_launch_game_number.Caption := GetLanguageText('label_launch_game_number.caption').Replace('${launch_game_number}', inttostr(mlaunch_number));
  Log.Write(Concat('显示今日打开启动器的日期。'), LOG_INFO);//显示今日日期
  label_open_launcher_time.Caption := GetLanguageText('label_open_launcher_time.caption').Replace('${open_launcher_time}', Now.Format('yyyy/mm/dd HH:nn:ss'));
  try //查找账号并赋值
    Log.Write(Concat('开始查找账号部分是否符合规定。'), LOG_INFO);
    var json := GetFile(Concat(AppData, '\LLLauncher\AccountJson.json'));
    var s := strtoint(OtherIni.ReadString('Account', 'SelectAccount', '')) - 1;
    if s <= -1 then raise Exception.Create('Format Exception');
    maccount_view := (((TJsonObject.ParseJSONValue(json) as TJsonObject).GetValue('account') as TJsonArray)[s] as TJsonObject).GetValue('name').Value;
    Log.Write(Concat('账号判断完毕，欢迎', maccount_view, '。'), LOG_INFO);
    label_account_view.Caption := GetLanguageText('label_account_view.caption.have').Replace('${account_view}', maccount_view);
  except
    maccount_view := '';
    Log.Write(Concat('账号判断失败，宁还暂未登录一个账号。'), LOG_ERROR);
    label_account_view.Caption := GetLanguageText('label_account_view.caption.absence');
  end;
  try  //查询版本是否有误，如果找不到，则暂未选择版本。
    Log.Write('开始判断游戏版本。', LOG_INFO);
    var ssj := strtoint(LLLini.ReadString('MC', 'SelectVer', ''));
    var sjn := GetFile(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\MCSelJson.json'));
    var svr := ((TJsonObject.ParseJSONValue(sjn) as TJsonObject).GetValue('mcsel') as TJsonArray)[ssj - 1] as TJsonObject;
    var svv := svr.GetValue('name').Value;
    var svp := svr.GetValue('path').Value;
    if IsVersionError(svp) then begin
      Log.Write('游戏版本：错误，未找到Json。', LOG_ERROR);
      svv := Concat(svv, GetLanguageText('button_launch_game.caption.error.cannot_find_json'));
    end else if GetMCInheritsFrom(svp, 'inheritsFrom') = '' then begin
      Log.Write('游戏版本：错误，缺少前置版本。', LOG_ERROR);
      svv := Concat(svv, GetLanguageText('button_launch_game.caption.error.missing_inherits_version'));
    end;
    var IltIni := TIniFile.Create(Concat(svp, '\LLLauncher.ini'));
    if IltIni.ReadString('Isolation', 'IsIsolation', '') = 'True' then svv := Concat(svv, GetLanguageText('button_launch_game.caption.isolation'));
    Log.Write(Concat('游戏版本：已确认宁所选版本为：', svv), LOG_INFO);
    button_launch_game.Caption := Concat(GetLanguageText('button_launch_game.caption'), #13, svv);
  except
    Log.Write('游戏版本：找不到所选Version文件夹，判断为暂未选择一个版本。', LOG_ERROR);
    button_launch_game.Caption := Concat(GetLanguageText('button_launch_game.caption.absence'));
  end;
  Log.Write(Concat('开始判断窗口颜色。'), LOG_INFO);
  try //判断RGBA
    mred := LLLini.ReadInteger('Misc', 'Red', -1);
    if (mred > 255) or (mred < 0) then raise Exception.Create('Format Exception');
  except
    Log.Write(Concat('窗口颜色有误，位置：Ini文件的Red红色位置。'), LOG_ERROR);
    mred := 240;
    LLLini.WriteInteger('Misc', 'Red', mred);
  end;
  try
    mgreen := LLLini.ReadInteger('Misc', 'Green', -1);
    if (mgreen > 255) or (mgreen < 0) then raise Exception.Create('Format Exception');
  except
    Log.Write(Concat('窗口颜色有误，位置：Ini文件的Green绿色位置。'), LOG_ERROR);
    mgreen := 240;
    LLLini.WriteInteger('Misc', 'Green', mgreen);
  end;
  try
    mblue := LLLini.ReadInteger('Misc', 'Blue', -1);
    if (mblue > 255) or (mblue < 0) then raise Exception.Create('Format Exception');
  except
    Log.Write(Concat('窗口颜色有误，位置：Ini文件的Blue蓝色位置。'), LOG_ERROR);
    mblue := 240;
    LLLini.WriteInteger('Misc', 'Blue', mblue);
  end;
  Caption := LLLini.ReadString('Misc', 'LauncherName', '');
  try
    mwindow_alpha := LLLini.ReadInteger('Misc', 'WindowAlpha', -1);
    if (mwindow_alpha > 255) or (mwindow_alpha < 127) then raise Exception.Create('Format Exception');
  except
    Log.Write(Concat('窗口透明度有误，位置：Ini文件的WindowAlpha位置。'), LOG_ERROR);
    mwindow_alpha := 255;
    LLLini.WriteInteger('Misc', 'WindowAlpha', mwindow_alpha);
  end;
  AlphaBlendValue := mwindow_alpha;
  try
    mcontrol_alpha := LLLini.ReadInteger('Misc', 'ControlAlpha', -1);
    if (mcontrol_alpha < 63) or (mcontrol_alpha > 195) then raise Exception.Create('Format Exception');
  except
    Log.Write(Concat('窗口透明度有误，位置：Ini文件的ControlAlpha位置。'), LOG_ERROR);
    mcontrol_alpha := 195;
    LLLini.WriteInteger('Misc', 'ControlAlpha', mcontrol_alpha);
  end;
  SetWindowLong(pagecontrol_mainpage.Handle, GWL_EXSTYLE, GetWindowLong(pagecontrol_mainpage.Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
  SetLayeredWindowAttributes(pagecontrol_mainpage.Handle, RGB(255, 255, 255), mcontrol_alpha, LWA_ALPHA);
  Log.Write(Concat('已判断完成，开始应用窗口颜色。'), LOG_INFO);
  Color := rgb(mred, mgreen, mblue); //实装RGBA。
  ResetBackImage(false);
end;
//图片切换按钮
procedure Tform_mainform.image_refresh_background_imageClick(Sender: TObject);
begin
  ResetBackImage(true);
end;
//音乐切换按钮
procedure Tform_mainform.image_refresh_background_musicClick(Sender: TObject);
begin
  ResetBackMusic(true);
end;
//初次切换页
procedure Tform_mainform.pagecontrol_mainpageChange(Sender: TObject);
begin
  if pagecontrol_mainpage.ActivePage = tabsheet_background_part then begin
    InitBackground;
  end;
end;
//切换该页前
procedure Tform_mainform.pagecontrol_mainpageChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  if pagecontrol_mainpage.ActivePage = tabsheet_background_part then begin
    SaveBackground;
  end;
end;
//控件透明度滑动条
procedure Tform_mainform.scrollbar_background_control_alphaChange(
  Sender: TObject);
begin
  mcontrol_alpha := scrollbar_background_control_alpha.Position;
  label_background_control_current_alpha.Caption := GetLanguageText('label_background_control_current_alpha.caption').Replace('${background_control_alpha}', inttostr(mcontrol_alpha));
  SetLayeredWindowAttributes(pagecontrol_mainpage.Handle, RGB(255, 255, 255), mcontrol_alpha, LWA_ALPHA);
end;
//窗口透明度滑动条
procedure Tform_mainform.scrollbar_background_window_alphaChange(
  Sender: TObject);
begin
  mwindow_alpha := scrollbar_background_window_alpha.Position;
  label_background_window_current_alpha.Caption := GetLanguageText('label_background_window_current_alpha.caption').Replace('${background_window_alpha}', inttostr(mwindow_alpha));
  AlphaBlendValue := mwindow_alpha;
end;

end.
