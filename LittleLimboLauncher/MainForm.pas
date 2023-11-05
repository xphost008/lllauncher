unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Forms, DateUtils, Dialogs, Zip,
  StdCtrls, pngimage, WinXCtrls, ComCtrls, VCLTee.TeCanvas, CheckLst, JSON, ShellAPI, Math,
  IniFiles, Menus, ExtCtrls, Controls, Vcl.MPlayer, Log4Delphi, Vcl.Imaging.jpeg, Generics.Collections,
  Vcl.Buttons, Vcl.ControlList, Threading, ClipBrd, RegularExpressions, IOUtils, System.StrUtils;

type
  Tform_mainform = class(TForm)
    mainmenu_mainpage: TMainMenu;
    n_misc: TMenuItem;
    n_answer_book: TMenuItem;
    n_intro_self: TMenuItem;
    n_lucky_today: TMenuItem;
    n_puzzle_game: TMenuItem;
    popupmenu_view_minecraft_info: TPopupMenu;
    n_view_minecraft_info: TMenuItem;
    popupmenu_view_mod_info: TPopupMenu;
    n_view_mod_website: TMenuItem;
    n_view_mod_profile: TMenuItem;
    pagecontrol_mainpage: TPageControl;
    tabsheet_mainpage_part: TTabSheet;
    label_account_view: TLabel;
    label_open_launcher_time: TLabel;
    label_open_launcher_number: TLabel;
    label_launch_game_number: TLabel;
    label_launch_tips: TLabel;
    image_refresh_background_music: TImage;
    image_refresh_background_image: TImage;
    image_exit_running_mc: TImage;
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
    button_microsoft_oauth_login: TButton;
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
    label_select_modloader: TLabel;
    label_download_return_value: TLabel;
    label_download_biggest_thread: TLabel;
    checklistbox_choose_view_mode: TCheckListBox;
    radiogroup_choose_download_source: TRadioGroup;
    edit_minecraft_version_name: TEdit;
    radiogroup_choose_mod_loader: TRadioGroup;
    listbox_select_minecraft: TListBox;
    button_reset_download_part: TButton;
    listbox_select_modloader: TListBox;
    button_load_modloader: TButton;
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
    tabsheet_download_modloader_part: TTabSheet;
    label_download_modloader_forge: TLabel;
    label_download_modloader_fabric: TLabel;
    label_download_modloader_quilt: TLabel;
    label_download_modloader_neoforge: TLabel;
    listbox_download_modloader_forge: TListBox;
    listbox_download_modloader_fabric: TListBox;
    listbox_download_modloader_quilt: TListBox;
    listbox_download_modloader_neoforge: TListBox;
    button_download_modloader_download: TButton;
    button_download_modloader_refresh: TButton;
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
    n_support_author: TMenuItem;
    n_support_bmclapi: TMenuItem;
    n_manual: TMenuItem;
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
    tabsheet_version_part: TTabSheet;
    pagecontrol_version_part: TPageControl;
    label_version_tip: TLabel;
    tabsheet_version_control_part: TTabSheet;
    tabsheet_version_isolation_part: TTabSheet;
    tabsheet_version_export_part: TTabSheet;
    timer_all_ticks: TTimer;
    timer_form_gradient_tick: TTimer;
    scrollbar_background_gradient_value: TScrollBar;
    label_background_gradient_value: TLabel;
    label_background_gradient_current_value: TLabel;
    scrollbar_background_gradient_step: TScrollBar;
    label_background_gradient_step: TLabel;
    label_background_gradient_current_step: TLabel;
    n_reset_launcher: TMenuItem;
    label_custom_download_sha1: TLabel;
    edit_custom_download_sha1: TEdit;
    tabsheet_download_progress_part: TTabSheet;
    progressbar_progress_download_bar: TProgressBar;
    label_progress_download_progress: TLabel;
    button_progress_hide_show_details: TButton;
    label_progress_tips: TLabel;
    listbox_progress_download_list: TListBox;
    button_progress_clean_download_list: TButton;
    button_thirdparty_check_authlib_update: TButton;
    groupbox_message_board: TGroupBox;
    memo_message_board: TMemo;
    n_memory_optimize: TMenuItem;
    scrollbox_launch: TScrollBox;
    label_launch_window_size_tips: TLabel;
    label_launch_window_width_tip: TLabel;
    label_launch_window_height_tip: TLabel;
    scrollbar_launch_window_height: TScrollBar;
    scrollbar_launch_window_width: TScrollBar;
    label_launch_java_path: TLabel;
    combobox_launch_select_java_path: TComboBox;
    label_launch_java_logic: TLabel;
    button_launch_full_scan_java: TButton;
    button_launch_basic_scan_java: TButton;
    button_launch_manual_import: TButton;
    button_launch_remove_java: TButton;
    label_launch_download_java: TLabel;
    button_launch_download_java_8: TButton;
    button_launch_download_java_16: TButton;
    button_launch_download_java_17: TButton;
    button_launch_official_java: TButton;
    label_launch_game_memory: TLabel;
    scrollbar_launch_game_memory: TScrollBar;
    label_launch_custom_info: TLabel;
    edit_launch_custom_info: TEdit;
    label_launch_game_title: TLabel;
    edit_launch_game_title: TEdit;
    label_launch_pre_launch_script: TLabel;
    edit_launch_pre_launch_script: TEdit;
    button_launch_pre_launch_script_tip: TButton;
    label_launch_after_launch_script: TLabel;
    edit_launch_after_launch_script: TEdit;
    button_launch_after_launch_script_tip: TButton;
    label_launch_default_jvm_argument: TLabel;
    edit_launch_default_jvm_argument: TEdit;
    button_launch_default_jvm_argument_tip: TButton;
    label_launch_additional_jvm_argument: TLabel;
    edit_launch_additional_jvm_argument: TEdit;
    button_launch_additional_jvm_argument_tip: TButton;
    edit_launch_additional_game_argument: TEdit;
    label_launch_additional_game_argument: TLabel;
    button_launch_additional_game_argument_tip: TButton;
    scrollbox_version: TScrollBox;
    label_select_game_version: TLabel;
    combobox_select_game_version: TComboBox;
    label_select_file_list: TLabel;
    combobox_select_file_list: TComboBox;
    label_version_name: TLabel;
    edit_version_name: TEdit;
    label_version_add_mc_path: TLabel;
    button_version_choose_any_directory: TButton;
    button_version_create_minecraft: TButton;
    button_add_version_to_list: TButton;
    label_version_choose_path: TLabel;
    label_version_current_path: TLabel;
    radiogroup_partition_version: TRadioGroup;
    button_version_complete: TButton;
    button_clear_version_list: TButton;
    button_remove_version_list: TButton;
    button_delete_game_version: TButton;
    button_rename_version_list: TButton;
    button_rename_game_version: TButton;
    scrollbox_isolation: TScrollBox;
    label_isolation_current_version: TLabel;
    label_is_open_isolation: TLabel;
    label_isolation_java_path: TLabel;
    label_isolation_custom_info: TLabel;
    label_isolation_window_title: TLabel;
    label_isolation_window_size: TLabel;
    label_isolation_window_width_tip: TLabel;
    label_isolation_window_height_tip: TLabel;
    label_isolation_game_memory: TLabel;
    label_isolation_partition: TLabel;
    toggleswitch_is_open_isolation: TToggleSwitch;
    edit_isolation_java_path: TEdit;
    button_isolation_choose_java: TButton;
    edit_isolation_custom_info: TEdit;
    edit_isolation_window_title: TEdit;
    toggleswitch_isolation_window_size: TToggleSwitch;
    scrollbar_isolation_window_width: TScrollBar;
    scrollbar_isolation_window_height: TScrollBar;
    toggleswitch_isolation_open_memory: TToggleSwitch;
    scrollbar_isolation_game_memory: TScrollBar;
    toggleswitch_isolation_open_partition: TToggleSwitch;
    checkbox_isolation_is_partition: TCheckBox;
    label_isolation_additional_game: TLabel;
    edit_isolation_additional_game: TEdit;
    label_isolation_additional_jvm: TLabel;
    edit_isolation_additional_jvm: TEdit;
    label_isolation_pre_launch_script: TLabel;
    edit_isolation_pre_launch_script: TEdit;
    label_isolation_after_launch_script: TLabel;
    edit_isolation_after_launch_script: TEdit;
    label_isolation_tip: TLabel;
    scrollbox_export: TScrollBox;
    label_export_current_version: TLabel;
    radiogroup_export_mode: TRadioGroup;
    label_export_mode_more: TLabel;
    label_export_modpack_name: TLabel;
    edit_export_modpack_name: TEdit;
    label_export_modpack_author: TLabel;
    edit_export_modpack_author: TEdit;
    label_export_modpack_version: TLabel;
    edit_export_modpack_version: TEdit;
    label_export_update_link: TLabel;
    edit_export_update_link: TEdit;
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
    label_export_memory: TLabel;
    scrollbar_export_max_memory: TScrollBar;
    label_export_modpack_profile: TLabel;
    memo_export_modpack_profile: TMemo;
    label_export_keep_file: TLabel;
    treeview_export_keep_file: TTreeView;
    button_export_start: TButton;
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
    procedure radiobutton_background_music_openClick(Sender: TObject);
    procedure radiobutton_background_music_launchClick(Sender: TObject);
    procedure radiobutton_background_music_notClick(Sender: TObject);
    procedure radiobutton_background_launch_hideClick(Sender: TObject);
    procedure radiobutton_background_launch_showClick(Sender: TObject);
    procedure radiobutton_background_launch_exitClick(Sender: TObject);
    procedure toggleswitch_background_gradientClick(Sender: TObject);
    procedure scrollbar_background_gradient_valueChange(Sender: TObject);
    procedure scrollbar_background_gradient_stepChange(Sender: TObject);
    procedure buttoncolor_custom_colorClick(Sender: TObject);
    procedure button_grass_colorClick(Sender: TObject);
    procedure button_sun_colorClick(Sender: TObject);
    procedure button_sultan_colorClick(Sender: TObject);
    procedure button_sky_colorClick(Sender: TObject);
    procedure button_cute_colorClick(Sender: TObject);
    procedure button_normal_colorClick(Sender: TObject);
    procedure edit_background_mainform_titleChange(Sender: TObject);
    procedure timer_form_gradient_tickTimer(Sender: TObject);
    procedure button_background_play_musicClick(Sender: TObject);
    procedure button_background_pause_musicClick(Sender: TObject);
    procedure button_background_stop_musicClick(Sender: TObject);
    procedure button_add_accountClick(Sender: TObject);
    procedure combobox_all_accountChange(Sender: TObject);
    procedure button_delete_accountClick(Sender: TObject);
    procedure image_open_download_prograssClick(Sender: TObject);
    procedure radiobutton_steveClick(Sender: TObject);
    procedure radiobutton_alexClick(Sender: TObject);
    procedure radiobutton_zuriClick(Sender: TObject);
    procedure radiobutton_sunnyClick(Sender: TObject);
    procedure radiobutton_noorClick(Sender: TObject);
    procedure radiobutton_makenaClick(Sender: TObject);
    procedure radiobutton_kaiClick(Sender: TObject);
    procedure radiobutton_efeClick(Sender: TObject);
    procedure radiobutton_ariClick(Sender: TObject);
    procedure checkbox_slimClick(Sender: TObject);
    procedure button_microsoft_oauth_loginClick(Sender: TObject);
    procedure button_account_get_uuidClick(Sender: TObject);
    procedure button_refresh_accountClick(Sender: TObject);
    procedure button_progress_hide_show_detailsClick(Sender: TObject);
    procedure button_progress_clean_download_listClick(Sender: TObject);
    procedure button_thirdparty_check_authlib_updateClick(Sender: TObject);
    procedure button_offline_name_to_uuidClick(Sender: TObject);
    procedure button_offline_uuid_to_nameClick(Sender: TObject);
    procedure timer_all_ticksTimer(Sender: TObject);
    procedure n_test_buttonClick(Sender: TObject);
    procedure n_memory_optimizeClick(Sender: TObject);
    procedure combobox_playing_search_sourceChange(Sender: TObject);
    procedure combobox_playing_search_modeChange(Sender: TObject);
    procedure button_playing_start_searchClick(Sender: TObject);
    procedure combobox_playing_search_category_curseforgeChange(
      Sender: TObject);
    procedure checklistbox_playing_search_category_modrinthClick(
      Sender: TObject);
    procedure button_open_download_websiteClick(Sender: TObject);
    procedure button_playing_name_previous_pageClick(Sender: TObject);
    procedure button_playing_name_next_pageClick(Sender: TObject);
    procedure button_playing_version_previous_pageClick(Sender: TObject);
    procedure button_playing_version_next_pageClick(Sender: TObject);
    procedure listbox_playing_search_nameClick(Sender: TObject);
    procedure n_view_mod_profileClick(Sender: TObject);
    procedure n_view_mod_websiteClick(Sender: TObject);
    procedure listbox_playing_search_versionClick(Sender: TObject);
    procedure button_playing_start_downloadClick(Sender: TObject);
    procedure scrollbox_launchMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure pagecontrol_playing_partChange(Sender: TObject);
    procedure WmDropFiles(var Msg: TMessage); message WM_DROPFILES;
    procedure listbox_manage_import_mapClick(Sender: TObject);
    procedure listbox_manage_import_modClick(Sender: TObject);
    procedure listbox_manage_import_resourcepackClick(Sender: TObject);
    procedure listbox_manage_import_shaderClick(Sender: TObject);
    procedure listbox_manage_import_pluginClick(Sender: TObject);
    procedure listbox_manage_import_datapackClick(Sender: TObject);
    procedure button_disable_choose_playingClick(Sender: TObject);
    procedure button_enable_choose_playingClick(Sender: TObject);
    procedure button_delete_choose_playingClick(Sender: TObject);
    procedure button_rename_choose_playingClick(Sender: TObject);
    procedure button_open_choose_playingClick(Sender: TObject);
  private
    { Private declarations }
    procedure PluginMenuClick(Sender: TObject);
    procedure LanguageMenuClick(Sender: TObject);
  public
    { Public declarations }
  end;

const
  LauncherVersion = '1.0.0-Beta-1';

var
  form_mainform: Tform_mainform;
  LLLini, OtherIni: TIniFile;
  AppData: String;
  Log: Log4D;
  crash_count: Integer = 0;
  mcpid: Integer = 0;
  v: TMediaPlayer;
var
  mopen_time, maccount_view: String;
  mopen_number, mlaunch_number: Integer;
  mred, mgreen, mblue, mwindow_alpha, mcontrol_alpha: Integer;
  mgradient_value, mgradient_step: Integer;
  mis_gradient: Boolean;
  mchoose_skin, mbiggest_thread: Integer;

implementation

uses
  MainMethod, LauncherMethod, BackgroundMethod, LanguageMethod, AccountMethod, MyCustomWindow,
  PluginMethod, PlayingMethod, ManageMethod, LaunchMethod;

var
  Cave, Answer, Lucky: TStringList;
  Intro: array of array of String;

{$R *.dfm}
//任意插件菜单栏点击的事件
procedure Tform_mainform.PluginMenuClick(Sender: TObject);
begin
  //
end;
//任意语言菜单栏点击的事件
procedure Tform_mainform.LanguageMenuClick(Sender: TObject);
begin
  var mi := Sender as TMenuItem;
  Log.Write(Concat('你点击了', mi.Caption, '语言文件，开始加载！'), LOG_START, LOG_INFO);
  var ld := Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\lang');
  if SysUtils.DirectoryExists(ld) then begin
    var Files := TDirectory.GetFiles(ld);
    for var I in Files do begin
      if RightStr(I, 5) = '.json' then begin //如果文件后缀为.json，则执行。
        var lj := TJSONObject.ParseJSONValue(GetFile(I)) as TJsonObject;
        try
          var title := lj.GetValue('file_language_title').Value;
          if mi.Caption.IndexOf(title) <> -1 then begin
            LLLini.WriteString('Language', 'SelectLanguageFile', ChangeFileExt(ExtractFileName(I), ''));
            SetLanguage(ChangeFileExt(ExtractFileName(I), ''));
            MyMessagebox(GetLanguage('messagebox_mainform.change_language.caption'), GetLanguage('messagebox_mainform.change_language.text'), MY_INFORMATION, [mybutton.myOK]);
            exit;
          end else abort;
        except continue; end;
      end;
    end;
  end;
end;
//管理部分：数据包列表框点击
procedure Tform_mainform.listbox_manage_import_datapackClick(Sender: TObject);
begin
  listbox_manage_import_mod.ItemIndex := -1;
  listbox_manage_import_shader.ItemIndex := -1;
  listbox_manage_import_resourcepack.ItemIndex := -1;
  listbox_manage_import_plugin.ItemIndex := -1;
end;
//管理部分：地图列表框点击
procedure Tform_mainform.listbox_manage_import_mapClick(Sender: TObject);
begin
  listbox_manage_import_mod.ItemIndex := -1;
  listbox_manage_import_shader.ItemIndex := -1;
  listbox_manage_import_resourcepack.ItemIndex := -1;
  listbox_manage_import_plugin.ItemIndex := -1;
  listbox_manage_import_datapack.ItemIndex := -1;
  listbox_manage_import_datapack.Items.Clear;
  ClearDatSelect;
  ManageChangeMap;
end;
//管理部分：模组列表框点击
procedure Tform_mainform.listbox_manage_import_modClick(Sender: TObject);
begin
  listbox_manage_import_map.ItemIndex := -1;
  listbox_manage_import_shader.ItemIndex := -1;
  listbox_manage_import_resourcepack.ItemIndex := -1;
  listbox_manage_import_plugin.ItemIndex := -1;
  listbox_manage_import_datapack.ItemIndex := -1;
  listbox_manage_import_datapack.Items.Clear;
  ClearDatSelect;
end;
//管理部分：插件列表框点击
procedure Tform_mainform.listbox_manage_import_pluginClick(Sender: TObject);
begin
  listbox_manage_import_map.ItemIndex := -1;
  listbox_manage_import_shader.ItemIndex := -1;
  listbox_manage_import_mod.ItemIndex := -1;
  listbox_manage_import_resourcepack.ItemIndex := -1;
  listbox_manage_import_datapack.ItemIndex := -1;
  listbox_manage_import_datapack.Items.Clear;
  ClearDatSelect;
end;
//管理部分：纹理列表框点击
procedure Tform_mainform.listbox_manage_import_resourcepackClick(
  Sender: TObject);
begin
  listbox_manage_import_map.ItemIndex := -1;
  listbox_manage_import_shader.ItemIndex := -1;
  listbox_manage_import_mod.ItemIndex := -1;
  listbox_manage_import_plugin.ItemIndex := -1;
  listbox_manage_import_datapack.ItemIndex := -1;
  listbox_manage_import_datapack.Items.Clear;
  ClearDatSelect;
end;
//管理部分：光影列表框点击
procedure Tform_mainform.listbox_manage_import_shaderClick(Sender: TObject);
begin
  listbox_manage_import_map.ItemIndex := -1;
  listbox_manage_import_resourcepack.ItemIndex := -1;
  listbox_manage_import_mod.ItemIndex := -1;
  listbox_manage_import_plugin.ItemIndex := -1;
  listbox_manage_import_datapack.ItemIndex := -1;
  listbox_manage_import_datapack.Items.Clear;
  ClearDatSelect;
end;

//玩法部分：名称列表框点击
procedure Tform_mainform.listbox_playing_search_nameClick(Sender: TObject);
begin
  PlayingSelNameList;
end;
//玩法部分：版本列表框点击
procedure Tform_mainform.listbox_playing_search_versionClick(Sender: TObject);
begin
  PlayingSelVerList;
end;

//高危系统库ntdll.dll
function NtSetSystemInformation(SystemInformationClass: DWORD; SystemInformation: Pointer; SystemInformationLength: ULONG): NTSTATUS; stdcall; external 'ntdll.dll';
//提取权限
function TiQuan(uzp: pansichar): Bool;
var
  hToken: THandle;
  ld: TLargeInteger;
  tkp: TOKEN_PRIVILEGES;
  Pre: DWORD;
begin
  result := false;
  if OpenProcessToken(GetCurrentProcess, TOKEN_QUERY or TOKEN_ADJUST_PRIVILEGES, hToken) then begin
    if LookupPrivilegeValueA(nil, uzp, &ld) then begin
      tkp.PrivilegeCount := 1;
      tkp.Privileges[0].Luid := ld;
      tkp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      if AdjustTokenPrivileges(hToken, false, &tkp, 16, nil, pre) then begin
        if GetLastError = ERROR_SUCCESS then result := true;
      end;
    end;
  end;
end;
//内存清理按钮
procedure Tform_mainform.n_memory_optimizeClick(Sender: TObject);
type
  s1 = record
    CurrentSize: ULONG_PTR;
    PeakSize: ULONG_PTR;
    PageFaultCount: ULONG;
    MinimunWorkingSet: ULONG_PTR;
    MaximunWorkingSet: ULONG_PTR;
    CurrentSizeIncludingTransitionInPages: ULONG_PTR;
    PeakSizeIncludingTransitionInPages: ULONG_PTR;
    TransitionRePurposeCount: ULONG;
    Flags: ULONG;
  end;
var
  status: TMemoryStatus;
begin
  if MyMessagebox(GetLanguage('messagebox_mainform.release_memory_optimize_warning.caption'), GetLanguage('messagebox_mainform.release_memory_optimize_warning.text'), MY_ERROR, [mybutton.myNo, mybutton.myYes]) = 1 then exit;
  if TiQuan(SE_PROF_SINGLE_PROCESS_NAME) then begin
    if TiQuan(SE_INCREASE_QUOTA_NAME) then begin
      GlobalMemoryStatus(status);
      var cm := status.dwAvailPhys;
      var i2 := 2;
      var i3 := 3;
      var i4 := 4;
      var i5 := 5;
      var i1: s1;
      i1.MinimunWorkingSet := (Integer.MaxValue) - 1;
      i1.MaximunWorkingSet := (Integer.MaxValue) - 1;
      var re1 := NtSetSystemInformation(21, @i1, sizeof(i1));
      if re1 <> 0 then begin
        MyMessagebox(GetLanguage('messagebox_mainform.cannot_release_first_memory.caption'), GetLanguage('messagebox_mainform.cannot_release_first_memory.text'), MY_ERROR, [mybutton.myOK]);
        exit;
      end;
      var re2 := NtSetSystemInformation(80, @i2, sizeof(i2));
      if re2 <> 0 then begin
        MyMessagebox(GetLanguage('messagebox_mainform.cannot_release_second_memory.caption'), GetLanguage('messagebox_mainform.cannot_release_second_memory.text'), MY_ERROR, [mybutton.myOK]);
        exit;
      end;
      var re3 := NtSetSystemInformation(80, @i3, sizeof(i3));
      if re3 <> 0 then begin
        MyMessagebox(GetLanguage('messagebox_mainform.cannot_release_third_memory.caption'), GetLanguage('messagebox_mainform.cannot_release_third_memory.text'), MY_ERROR, [mybutton.myOK]);
        exit;
      end;
      var re4 := NtSetSystemInformation(80, @i4, sizeof(i4));
      if re4 <> 0 then begin
        MyMessagebox(GetLanguage('messagebox_mainform.cannot_release_forth_memory.caption'), GetLanguage('messagebox_mainform.cannot_release_forth_memory.text'), MY_ERROR, [mybutton.myOK]);
        exit;
      end;
      var re5 := NtSetSystemInformation(80, @i5, sizeof(i5));
      if re5 <> 0 then begin
        MyMessagebox(GetLanguage('messagebox_mainform.cannot_release_fifth_memory.caption'), GetLanguage('messagebox_mainform.cannot_release_fifth_memory.text'), MY_ERROR, [mybutton.myOK]);
        exit;
      end;
      GlobalMemoryStatus(status);
      MyMessagebox(GetLanguage('messagebox_mainform.release_memory_success.caption'), GetLanguage('messagebox_mainform.release_memory_success.text').Replace('${release_memory_value}', floattostr(SimpleRoundTo((status.dwAvailPhys - cm) / 1024 / 1024))), MY_INFORMATION, [mybutton.myOK]);
    end else begin
      MyMessagebox(GetLanguage('messagebox_mainform.cannot_root_seIncreaseQuotaPrivilege.caption'), GetLanguage('messagebox_mainform.cannot_root_seIncreaseQuotaPrivilege.text'), MY_ERROR, [mybutton.myOK]);
    end;
  end else begin
    MyMessagebox(GetLanguage('messagebox_mainform.cannot_root_seProfileSingleProcessPrivilege.caption'), GetLanguage('messagebox_mainform.cannot_root_seProfileSingleProcessPrivilege.text'), MY_ERROR, [mybutton.myOK]);
  end;
end;
//测试按钮
procedure Tform_mainform.n_test_buttonClick(Sender: TObject);
//type
//  TTT = record
//    CurrentSize: Currency;
//    PeakSize: Currency;
//    PageFaultCount: ULong;
//    MinimumWorkingSet: Currency;
//    MaximumWorkingSet: Currency;
//  end;
begin
//  showmessage(inttostr(MyMessagebox('', '', MY_ERROR, [mybutton.myYes, mybutton.myNo])));
//      var s: TPoint;
//      s.X := 0;
//      s.Y := 0;
//      s := button_launch_game.ClientToScreen(s);
//      s := form_mainform.ScreenToClient(s);
//      showmessage(inttostr(button_launch_game.Left) + #13#10 + inttostr(button_launch_game.Top) + #13#10 + inttostr(s.X) + #13#10 + inttostr(s.Y));
//  var info1 := 2;
//  var info2 := 3;
//  var info3 := 4;
//  var info4 := 5;
//  var abc: TTT;
//  abc.MinimumWorkingSet := 1.844674407371e+019;
//  abc.MaximumWorkingSet := 1.844674407371e+019;
//  var cd := ULong(GetProcAddress(
//    GetModuleHandleW('ntdll.dll'),
//    'NtSetSystemInformation'));
//  var re0 := NtSetSystemInformation(cd, @abc, sizeof(abc));
//  var re1 := NtSetSystemInformation(80, @info1, sizeof(info1));
//  var re2 := NtSetSystemInformation(80, @info2, sizeof(info2));
//  var re3 := NtSetSystemInformation(80, @info3, sizeof(info3));
//  var re4 := NtSetSystemInformation(80, @info4, sizeof(info4));
//  if re0 <> 0 then showmessage('not 0');
//  if re1 <> 0 then showmessage('not 1');
//  if re2 <> 0 then showmessage('not 2');
//  if re3 <> 0 then showmessage('not 3');
//  if re4 <> 0 then showmessage('not 4');
end;
//玩法部分：打开该模组的简介
procedure Tform_mainform.n_view_mod_profileClick(Sender: TObject);
begin
  PlayingOpenIntro;
end;
//玩法部分：打开该模组的官网。
procedure Tform_mainform.n_view_mod_websiteClick(Sender: TObject);
begin
  PlayingOpenVerWeb;
end;
//背景设置：自定义配色按钮
procedure Tform_mainform.buttoncolor_custom_colorClick(Sender: TObject);
begin
  Color := buttoncolor_custom_color.SymbolColor;
  mred := Color and $FF;
  mgreen := (Color and $FF00) shr 8;
  mblue := (Color and $FF0000) shr 16;
end;
//账号部分：获取账号UUID
procedure Tform_mainform.button_account_get_uuidClick(Sender: TObject);
begin
  if combobox_all_account.ItemIndex = -1 then begin
    MyMessagebox(GetLanguage('messagebox_account.not_choose_any_account.caption'), GetLanguage('messagebox_account.not_choose_any_account.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  var uuid := ((AccountJSON.GetValue('account') as TJsonArray)[combobox_all_account.ItemIndex] as TJsonObject).GetValue('uuid').Value;
  if MyMessagebox(GetLanguage('messagebox_account.get_current_uuid.caption'), GetLanguage('messagebox_account.get_current_uuid.text').Replace('${account_uuid}', uuid), MY_INFORMATION, [mybutton.myNo, mybutton.myYes]) = 2 then begin
    ClipBoard.SetTextBuf(pchar(uuid));
  end;
end;
//账号部分：添加账号
procedure Tform_mainform.button_add_accountClick(Sender: TObject);
begin
  if combobox_all_account.Items.Count > 32 then begin
    MyMessagebox(GetLanguage('messagebox_account.login_account_too_much.caption'), GetLanguage('messagebox_account.login_account_too_much.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  if pagecontrol_account_part.ActivePage = tabsheet_account_offline_part then begin
    OfflineLogin(edit_offline_name.Text, edit_offline_uuid.Text);
  end else if pagecontrol_account_part.ActivePage = tabsheet_account_thirdparty_part then begin
    ThirdPartyLogin(edit_thirdparty_server.Text, edit_thirdparty_account.Text, edit_thirdparty_password.Text);
  end else if pagecontrol_account_part.ActivePage = tabsheet_account_microsoft_part then begin
    MyMessagebox(GetLanguage('messagebox_account.not_support_login_way.caption'), GetLanguage('messagebox_account.not_support_login_way.text'), MY_ERROR, [mybutton.myOK]);
  end;
end;
//背景设置：暂停音乐
procedure Tform_mainform.button_background_pause_musicClick(Sender: TObject);
begin
  if v.FileName = '' then
    exit;
  v.Pause;
end;
//背景设置：播放音乐
procedure Tform_mainform.button_background_play_musicClick(Sender: TObject);
begin
  if v.FileName = '' then begin
    ResetBackMusic(true);
  end else begin
    if v.Mode = mpPaused then
      v.Resume
    else
      PlayMusic;
  end;
end;
//背景设置：停止音乐
procedure Tform_mainform.button_background_stop_musicClick(Sender: TObject);
begin
  if v.FileName = '' then
    exit;
  v.Stop;
  v.Position := 0;
end;
//背景设置：可爱粉
procedure Tform_mainform.button_cute_colorClick(Sender: TObject);
begin
  mred := 255;
  mgreen := 110;
  mblue := 180;
  Color := rgb(mred, mgreen, mblue);
  buttoncolor_custom_color.SymbolColor := Color;
end;
//账号部分：删除账号
procedure Tform_mainform.button_delete_accountClick(Sender: TObject);
begin
  combobox_all_account.ItemIndex := DeleteAccount(combobox_all_account.ItemIndex);
end;
//玩法管理界面：删除选中
procedure Tform_mainform.button_delete_choose_playingClick(Sender: TObject);
begin
  ManageDeletePlaying;
end;
//玩法管理界面：禁用选中
procedure Tform_mainform.button_disable_choose_playingClick(Sender: TObject);
begin
  ManageDisablePlaying;
end;
//玩法管理界面：启用选中
procedure Tform_mainform.button_enable_choose_playingClick(Sender: TObject);
begin
  ManageEnablePlaying;
end;
//背景设置：小草绿
procedure Tform_mainform.button_grass_colorClick(Sender: TObject);
begin
  mred := 50;
  mgreen := 205;
  mblue := 50;
  Color := rgb(mred, mgreen, mblue);
  buttoncolor_custom_color.SymbolColor := Color;
end;
//主界面：启动游戏按钮
procedure Tform_mainform.button_launch_gameClick(Sender: TObject);
begin
//
end;
//微软OAuth登录
procedure Tform_mainform.button_microsoft_oauth_loginClick(Sender: TObject);
begin
  OAuthLogin;
end;
//背景设置：默认白
procedure Tform_mainform.button_normal_colorClick(Sender: TObject);
begin
  mred := 240;
  mgreen := 240;
  mblue := 240;
  Color := rgb(mred, mgreen, mblue);
  buttoncolor_custom_color.SymbolColor := Color;
end;
//账号部分：通过正版用户名获取正版UUID
procedure Tform_mainform.button_offline_name_to_uuidClick(Sender: TObject);
begin
  var e: String := edit_offline_name.Text;
  if (e = '') or (not TRegex.IsMatch(e, '^[a-zA-Z0-9_]+$')) or (e.Length < 3) or (e.Length > 16) then begin
    MyMessagebox(GetLanguage('messagebox_account.name_not_true.caption'), GetLanguage('messagebox_account.name_not_true.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  label_account_return_value.Caption := GetLanguage('label_account_return_value.caption.name_to_uuid_start');
  TTask.Run(procedure begin
    edit_offline_uuid.Text := NameToUUID(e);
  end);
end;
//账号部分：通过正版UUID获取正版用户名
procedure Tform_mainform.button_offline_uuid_to_nameClick(Sender: TObject);
begin
  var e: String := edit_offline_uuid.Text;
  if not TRegex.IsMatch(e, '^[a-f0-9]{32}') then begin
    MyMessagebox(GetLanguage('messagebox_account.uuid_not_true.caption'), GetLanguage('messagebox_account.uuid_not_true.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  label_account_return_value.Caption := GetLanguage('label_account_return_value.caption.uuid_to_name_start');
  TTask.Run(procedure begin
    edit_offline_name.Text := UUIDToName(e);
  end);
end;
//玩法管理界面：打开选中的文件夹
procedure Tform_mainform.button_open_choose_playingClick(Sender: TObject);
begin
  ManageOpenPlaying;
end;
//打开下载源官网
procedure Tform_mainform.button_open_download_websiteClick(Sender: TObject);
begin
  PlayingOpenOciWeb();
end;
//玩法界面：名称下一页
procedure Tform_mainform.button_playing_name_next_pageClick(Sender: TObject);
begin
  PlayingPageDownName();
end;
//玩法界面：名称上一页
procedure Tform_mainform.button_playing_name_previous_pageClick(
  Sender: TObject);
begin
  PlayingPageUpName();
end;
//玩法界面：开始下载
procedure Tform_mainform.button_playing_start_downloadClick(Sender: TObject);
begin
  PlayingDownload;
end;
//下载进度界面：清空列表框
procedure Tform_mainform.button_playing_start_searchClick(Sender: TObject);
begin
  PlayingStartSearch;
end;
//玩法界面：版本下一页
procedure Tform_mainform.button_playing_version_next_pageClick(Sender: TObject);
begin
  PlayingPageDownVer();
end;
//玩法界面：版本上一页
procedure Tform_mainform.button_playing_version_previous_pageClick(
  Sender: TObject);
begin
  PlayingPageUpVer();
end;
//下载窗口：清除列表框
procedure Tform_mainform.button_progress_clean_download_listClick(
  Sender: TObject);
begin
  progressbar_progress_download_bar.Position := 0;
  listbox_progress_download_list.Items.Clear;
  label_progress_download_progress.Caption := GetLanguage('label_progress_download_progress.caption').Replace('${download_progress}', '0').Replace('${download_current_count}', '0').Replace('${download_all_count}', '0');
end;
//下载进度界面：显示/隐藏详情
procedure Tform_mainform.button_progress_hide_show_detailsClick(
  Sender: TObject);
begin
  if listbox_progress_download_list.Visible then begin
    button_progress_hide_show_details.Caption := GetLanguage('button_progress_hide_show_details.caption.show');
    listbox_progress_download_list.Visible := false;
  end else begin
    button_progress_hide_show_details.Caption := GetLanguage('button_progress_hide_show_details.caption.hide');
    listbox_progress_download_list.Visible := true;
  end;
end;
//刷新账号
procedure Tform_mainform.button_refresh_accountClick(Sender: TObject);
begin
  if combobox_all_account.ItemIndex = -1 then begin
    MyMessagebox(GetLanguage('messagebox_account.not_choose_any_account.caption'), GetLanguage('messagebox_account.not_choose_any_account.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  RefreshAccount(combobox_all_account.ItemIndex);
end;
//玩法管理界面：重命名选中
procedure Tform_mainform.button_rename_choose_playingClick(Sender: TObject);
begin
  ManageRenamePlaying;
end;
//背景设置：天空蓝
procedure Tform_mainform.button_sky_colorClick(Sender: TObject);
begin
  mred := 0;
  mgreen := 191;
  mblue := 255;
  Color := rgb(mred, mgreen, mblue);
  buttoncolor_custom_color.SymbolColor := Color;
end;
//背景设置：苏丹红
procedure Tform_mainform.button_sultan_colorClick(Sender: TObject);
begin
  mred := 189;
  mgreen := 0;
  mblue := 0;
  Color := rgb(mred, mgreen, mblue);
  buttoncolor_custom_color.SymbolColor := Color;
end;
//背景设置：日落黄
procedure Tform_mainform.button_sun_colorClick(Sender: TObject);
begin
  mred := 255;
  mgreen := 215;
  mblue := 0;
  Color := rgb(mred, mgreen, mblue);
  buttoncolor_custom_color.SymbolColor := Color;
end;
//账号部分：检测Authlib是否有更新
procedure Tform_mainform.button_thirdparty_check_authlib_updateClick(
  Sender: TObject);
begin
  InitAuthlib;
end;
//账号部分：离线登录：Slim
procedure Tform_mainform.checkbox_slimClick(Sender: TObject);
begin
  edit_offline_uuid.Text := JudgeOfflineSkin(mchoose_skin, checkbox_slim.Checked);
end;
//搜索类型改变复选组（Modrinth）
procedure Tform_mainform.checklistbox_playing_search_category_modrinthClick(
  Sender: TObject);
begin
  PlayingSelCateModrinth;
end;
//账号部分：所有账号下拉框改变事件
procedure Tform_mainform.combobox_all_accountChange(Sender: TObject);
begin
  if combobox_all_account.ItemIndex = -1 then exit;
  var pla := ((AccountJson.Values['account'] as TJsonArray)[combobox_all_account.ItemIndex] as TJsonObject);
  maccount_view := pla.GetValue('name').Value;
  JudgeJSONSkin(combobox_all_account.ItemIndex);
  label_account_return_value.Caption := GetLanguage('label_account_return_value.caption.logined').Replace('${player_name}', maccount_view);
end;
//搜索类型改变下拉框（Curseforge）
procedure Tform_mainform.combobox_playing_search_category_curseforgeChange(
  Sender: TObject);
begin
  PlayingSelCateCurseforge;
end;
//搜索方式修改的下拉框
procedure Tform_mainform.combobox_playing_search_modeChange(Sender: TObject);
begin
  PlayingSelMode;
end;
//搜索源修改的下拉框
procedure Tform_mainform.combobox_playing_search_sourceChange(Sender: TObject);
begin
  PlayingSelSource;
end;
//背景设置：窗口标题
procedure Tform_mainform.edit_background_mainform_titleChange(Sender: TObject);
begin
  Caption := edit_background_mainform_title.Text;
end;
//主界面：窗口关闭事件
procedure Tform_mainform.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveBackground;
  SaveAccount;
  SavePlaying;
  SaveLaunch;
  ShellExecute(Application.Handle, 'open', 'taskkill.exe', '/F /IM LittleLimboLauncher.exe', nil, SW_HIDE);
end;
procedure Tform_mainform.WmDropFiles(var Msg: TMessage);
begin
  if pagecontrol_mainpage.ActivePage = tabsheet_playing_part then begin
    if pagecontrol_playing_part.ActivePage = tabsheet_playing_manage_part then begin
      DragFileInWindow(Msg);
    end;
  end;
  DragFinish(msg.WParam);
end;
//主界面：窗口创建事件
procedure Tform_mainform.FormCreate(Sender: TObject);
begin
  Log := Log4D.Create;
  Log.Write('窗口创建！', LOG_INFO, LOG_START);
  AppData := GetEnvironmentVariable('AppData');
  Cave := TStringList.Create;
  Answer := TStringList.Create;
  Lucky := TStringList.Create;
  v := TMediaPlayer.Create(form_mainform);
  Log.Write('初始化变量1完毕。', LOG_INFO, LOG_START);
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
  if not SysUtils.FileExists(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\', 'LittleLimboLauncher.ini')) then begin
    LLLini.WriteString('Version', 'CustomInfo', 'LLLauncher');
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
    LLLini.WriteInteger('Misc', 'ControlAlpha', 191);
    LLLini.WriteInteger('Misc', 'WindowControl', 2);
    LLLini.WriteInteger('Misc', 'SelectType', 3);
    LLLini.WriteBool('Misc', 'IsGradient', False);
    LLLini.WriteInteger('Misc', 'GradientValue', 20);
    LLLini.WriteString('Misc', 'LauncherName', 'Little Limbo Launcher');
    LLLini.WriteInteger('Account', 'SelectLoginMode', 1);
    LLLini.WriteString('Language', 'SelectLanguageFile', 'zh_cn');
  end;
  if not FileExists(Concat(AppData, '\LLLauncher\Other.ini')) then begin
    Otherini.WriteString('Other', 'Random', inttostr(random(2000000) + 1));
    Otherini.WriteString('Misc', 'Launcher', '0');
    Otherini.WriteString('Misc', 'StartGame', '0');
  end;
  Log.Write('初始化变量2完毕。', LOG_INFO, LOG_START); //输出Log
  Log.Write('判断完成窗口创建事件！', LOG_INFO, LOG_START);
  ChangeWindowMessageFilter(WM_DROPFILES, MSGFLT_ADD);
  ChangeWindowMessageFilter(WM_COPYDATA, MSGFLT_ADD);
  ChangeWindowMessageFilter(WM_COPYGLOBALDATA, MSGFLT_ADD);
//  DragAcceptFiles(tabsheet_playing_manage_part.Handle, true);
  DragAcceptFiles(self.Handle, true);
  InitLanguage;
end;
//主界面：窗口展示事件
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
  Log.Write('正在读取语言文件……', LOG_INFO, LOG_START);
  var langtle := LLLini.ReadString('Language', 'SelectLanguageFile', '');
  SetLanguage(langtle);
  Log.Write('开始判断窗口显示事件！', LOG_INFO, LOG_START);
  try  //判断打开启动器的次数
    Log.Write('开始判断打开启动器次数。', LOG_INFO, LOG_START);
    mopen_number := Otherini.ReadInteger('Misc', 'Launcher', -1) + 1;
    if mopen_number < 1 then raise Exception.Create('Format Exception');
    Otherini.WriteString('Misc', 'Launcher', inttostr(mopen_number));
    Log.Write(Concat('判断成功，打开启动器次数为', inttostr(mopen_number), '次。'), LOG_INFO, LOG_START);
  except
    mopen_number := 1;
    Log.Write('判断打开启动器次数失败，默认降为1次。', LOG_ERROR, LOG_START);
    Otherini.WriteString('Misc', 'Launcher', inttostr(mopen_number));
  end;
  label_open_launcher_number.Caption := GetLanguage('label_open_launcher_number.caption').Replace('${open_launcher_number}', inttostr(mopen_number));
  try  //判断启动游戏的次数
    Log.Write(Concat('开始判断启动游戏的次数。'), LOG_INFO, LOG_START);
    mlaunch_number := Otherini.ReadInteger('Misc', 'StartGame', -1);
    if mlaunch_number < 0 then raise Exception.Create('Format Exception');
    Log.Write(Concat('判断成功，启动游戏次数为', inttostr(mlaunch_number), '次。'), LOG_INFO, LOG_START);
  except
    mlaunch_number := 0;
    Log.Write(Concat('判断启动游戏次数失败，默认降为1次。'), LOG_ERROR, LOG_START);
    Otherini.WriteString('Misc', 'StartGame', inttostr(mlaunch_number));
  end;
  label_launch_game_number.Caption := GetLanguage('label_launch_game_number.caption').Replace('${launch_game_number}', inttostr(mlaunch_number));
  Log.Write(Concat('显示今日打开启动器的日期。'), LOG_INFO, LOG_START);//显示今日日期
  label_open_launcher_time.Caption := GetLanguage('label_open_launcher_time.caption').Replace('${open_launcher_time}', Now.Format('yyyy/mm/dd HH:nn:ss'));
  try //查找账号并赋值
    Log.Write(Concat('开始查找账号部分是否符合规定。'), LOG_INFO, LOG_START);
    var json := GetFile(Concat(AppData, '\LLLauncher\AccountJson.json'));
    var s := strtoint(OtherIni.ReadString('Account', 'SelectAccount', '')) - 1;
    if s <= -1 then raise Exception.Create('Format Exception');
    maccount_view := (((TJsonObject.ParseJSONValue(json) as TJsonObject).GetValue('account') as TJsonArray)[s] as TJsonObject).GetValue('name').Value;
    Log.Write(Concat('账号判断完毕，欢迎', maccount_view, '。'), LOG_INFO, LOG_START);
    label_account_view.Caption := GetLanguage('label_account_view.caption.have').Replace('${account_view}', maccount_view);
  except
    maccount_view := '';
    Log.Write(Concat('账号判断失败，宁还暂未登录一个账号。'), LOG_ERROR, LOG_START);
    label_account_view.Caption := GetLanguage('label_account_view.caption.absence');
  end;
  try  //查询版本是否有误，如果找不到，则暂未选择版本。
    Log.Write('开始判断游戏版本。', LOG_INFO, LOG_START);
    var ssj := strtoint(LLLini.ReadString('MC', 'SelectVer', ''));
    var sjn := GetFile(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\MCSelJson.json'));
    var svr := ((TJsonObject.ParseJSONValue(sjn) as TJsonObject).GetValue('mcsel') as TJsonArray)[ssj - 1] as TJsonObject;
    var svv := svr.GetValue('name').Value;
    var svp := svr.GetValue('path').Value;
    if IsVersionError(svp) then begin
      Log.Write('游戏版本：错误，未找到Json。', LOG_ERROR, LOG_START);
      svv := Concat(svv, GetLanguage('button_launch_game.caption.error.cannot_find_json'));
    end else if GetMCInheritsFrom(svp, 'inheritsFrom') = '' then begin
      Log.Write('游戏版本：错误，缺少前置版本。', LOG_ERROR, LOG_START);
      svv := Concat(svv, GetLanguage('button_launch_game.caption.error.missing_inherits_version'));
    end;
    var IltIni := TIniFile.Create(Concat(svp, '\LLLauncher.ini'));
    if IltIni.ReadString('Isolation', 'IsIsolation', '') = 'True' then svv := Concat(svv, GetLanguage('button_launch_game.caption.isolation'));
    Log.Write(Concat('游戏版本：已确认宁所选版本为：', svv), LOG_INFO, LOG_START);
    button_launch_game.Caption := GetLanguage('button_launch_game.caption').Replace('${launch_version_name}', svv);
  except
    Log.Write('游戏版本：找不到所选Version文件夹，判断为暂未选择一个版本。', LOG_ERROR, LOG_START);
    button_launch_game.Caption := GetLanguage('button_launch_game.caption.absence');
  end;
  Log.Write(Concat('开始判断窗口颜色。'), LOG_INFO, LOG_START);
  try //判断RGBA
    mred := LLLini.ReadInteger('Misc', 'Red', -1);
    if (mred > 255) or (mred < 0) then raise Exception.Create('Format Exception');
  except
    Log.Write(Concat('窗口颜色有误，位置：Ini文件的Red红色位置。'), LOG_ERROR, LOG_START);
    mred := 240;
    LLLini.WriteInteger('Misc', 'Red', mred);
  end;
  try
    mgreen := LLLini.ReadInteger('Misc', 'Green', -1);
    if (mgreen > 255) or (mgreen < 0) then raise Exception.Create('Format Exception');
  except
    Log.Write(Concat('窗口颜色有误，位置：Ini文件的Green绿色位置。'), LOG_ERROR, LOG_START);
    mgreen := 240;
    LLLini.WriteInteger('Misc', 'Green', mgreen);
  end;
  try
    mblue := LLLini.ReadInteger('Misc', 'Blue', -1);
    if (mblue > 255) or (mblue < 0) then raise Exception.Create('Format Exception');
  except
    Log.Write(Concat('窗口颜色有误，位置：Ini文件的Blue蓝色位置。'), LOG_ERROR, LOG_START);
    mblue := 240;
    LLLini.WriteInteger('Misc', 'Blue', mblue);
  end;
  Caption := LLLini.ReadString('Misc', 'LauncherName', '');
  try
    mwindow_alpha := LLLini.ReadInteger('Misc', 'WindowAlpha', -1);
    if (mwindow_alpha > 255) or (mwindow_alpha < 127) then raise Exception.Create('Format Exception');
  except
    Log.Write(Concat('窗口透明度有误，位置：Ini文件的WindowAlpha位置。'), LOG_ERROR, LOG_START);
    mwindow_alpha := 255;
    LLLini.WriteInteger('Misc', 'WindowAlpha', mwindow_alpha);
  end;
  AlphaBlendValue := mwindow_alpha;
  try
    mcontrol_alpha := LLLini.ReadInteger('Misc', 'ControlAlpha', -1);
    if (mcontrol_alpha < 63) or (mcontrol_alpha > 191) then raise Exception.Create('Format Exception');
  except
    Log.Write(Concat('窗口透明度有误，位置：Ini文件的ControlAlpha位置。'), LOG_ERROR, LOG_START);
    mcontrol_alpha := 191;
    LLLini.WriteInteger('Misc', 'ControlAlpha', mcontrol_alpha);
  end;
  mis_gradient := LLLini.ReadBool('Misc', 'IsGradient', False);
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
  try
    mbiggest_thread := LLLini.ReadInteger('Version', 'ThreadBiggest', -1);
    if (mbiggest_thread < 1) or (mbiggest_thread > 256) then raise Exception.Create('Format Exception');
  except
    Log.Write(Concat('最大线程有误，位置：Ini文件的ThreadBiggest位置。'), LOG_ERROR, LOG_START);
    mbiggest_thread := 32;
    LLLini.WriteInteger('Misc', 'ControlAlpha', mbiggest_thread);
  end;
  timer_form_gradient_tick.Interval := mgradient_value;
  SetWindowLong(pagecontrol_mainpage.Handle, GWL_EXSTYLE, GetWindowLong(pagecontrol_mainpage.Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
  SetLayeredWindowAttributes(pagecontrol_mainpage.Handle, RGB(255, 255, 255), mcontrol_alpha, LWA_ALPHA);
  Log.Write(Concat('已判断完成，开始应用窗口颜色。'), LOG_INFO, LOG_START);
  Color := rgb(mred, mgreen, mblue); //实装RGBA。
  ResetBackImage(false);
end;
//打开下载界面
procedure Tform_mainform.image_open_download_prograssClick(Sender: TObject);
begin
  pagecontrol_mainpage.ActivePage := self.tabsheet_download_progress_part;
end;
//主界面：图片切换按钮
procedure Tform_mainform.image_refresh_background_imageClick(Sender: TObject);
begin
  ResetBackImage(true);
end;
//主界面：音乐切换按钮
procedure Tform_mainform.image_refresh_background_musicClick(Sender: TObject);
begin
  ResetBackMusic(true);
end;
//主界面：初次切换页
procedure Tform_mainform.pagecontrol_mainpageChange(Sender: TObject);
begin
  if pagecontrol_mainpage.ActivePage = tabsheet_background_part then
    InitBackground
  else if pagecontrol_mainpage.ActivePage = tabsheet_account_part then
    InitAccount
  else if pagecontrol_mainpage.ActivePage = tabsheet_playing_part then
    InitPlaying
  else if pagecontrol_mainpage.ActivePage = tabsheet_launch_part then
    InitLaunch
end;
//主界面：切换该页前
procedure Tform_mainform.pagecontrol_mainpageChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  if pagecontrol_mainpage.ActivePage = tabsheet_background_part then
    SaveBackground
  else if pagecontrol_mainpage.ActivePage = tabsheet_account_part then
    SaveAccount
  else if pagecontrol_mainpage.ActivePage = tabsheet_playing_part then
    SavePlaying
  else if pagecontrol_mainpage.ActivePage = tabsheet_launch_part then
    SaveLaunch
end;
//玩法部分：玩法管理界面/下载玩法切换。
procedure Tform_mainform.pagecontrol_playing_partChange(Sender: TObject);
begin
  if pagecontrol_playing_part.ActivePage = tabsheet_playing_manage_part then begin
    if not InitManage then begin
      MyMessagebox(GetLanguage('messagebox_playing.open_manage_error.caption'), GetLanguage('messagebox_playing.open_manage_error.text'), MY_ERROR, [mybutton.myOK]);
      pagecontrol_playing_part.ActivePage := tabsheet_playing_download_part;
      exit;
    end;
  end;
end;
//账号部分：离线登录：Alex
procedure Tform_mainform.radiobutton_alexClick(Sender: TObject);
begin
  mchoose_skin := 0;
  edit_offline_uuid.Text := JudgeOfflineSkin(mchoose_skin, checkbox_slim.Checked);
end;
//账号部分：离线登录：Ari
procedure Tform_mainform.radiobutton_ariClick(Sender: TObject);
begin
  mchoose_skin := 1;
  edit_offline_uuid.Text := JudgeOfflineSkin(mchoose_skin, checkbox_slim.Checked);
end;
//背景设置：启动游戏时退出窗口的单选框
procedure Tform_mainform.radiobutton_background_launch_exitClick(
  Sender: TObject);
begin
  mwindow_control := 3;
end;
//背景设置：启动游戏时隐藏窗口的单选框
procedure Tform_mainform.radiobutton_background_launch_hideClick(
  Sender: TObject);
begin
  mwindow_control := 1;
end;
//背景设置：启动游戏时显示窗口的单选框
procedure Tform_mainform.radiobutton_background_launch_showClick(
  Sender: TObject);
begin
  mwindow_control := 2;
end;
//背景设置：启动游戏时播放音乐的单选框
procedure Tform_mainform.radiobutton_background_music_launchClick(
  Sender: TObject);
begin
  mselect_type := 2;
end;
//背景设置：不播放音乐的单选框
procedure Tform_mainform.radiobutton_background_music_notClick(Sender: TObject);
begin
  mselect_type := 3;
end;
//背景设置：打开启动器时播放音乐的单选框
procedure Tform_mainform.radiobutton_background_music_openClick(
  Sender: TObject);
begin
  mselect_type := 1;
end;
//账号部分：离线登录：Efe
procedure Tform_mainform.radiobutton_efeClick(Sender: TObject);
begin
  mchoose_skin := 2;
  edit_offline_uuid.Text := JudgeOfflineSkin(mchoose_skin, checkbox_slim.Checked);
end;
//账号部分：离线登录：Kai
procedure Tform_mainform.radiobutton_kaiClick(Sender: TObject);
begin
  mchoose_skin := 3;
  edit_offline_uuid.Text := JudgeOfflineSkin(mchoose_skin, checkbox_slim.Checked);
end;
//账号部分：离线登录：Makena
procedure Tform_mainform.radiobutton_makenaClick(Sender: TObject);
begin
  mchoose_skin := 4;
  edit_offline_uuid.Text := JudgeOfflineSkin(mchoose_skin, checkbox_slim.Checked);
end;
//账号部分：离线登录：Noor
procedure Tform_mainform.radiobutton_noorClick(Sender: TObject);
begin
  mchoose_skin := 5;
  edit_offline_uuid.Text := JudgeOfflineSkin(mchoose_skin, checkbox_slim.Checked);
end;
//账号部分：离线登录：Steve
procedure Tform_mainform.radiobutton_steveClick(Sender: TObject);
begin
  mchoose_skin := 6;
  edit_offline_uuid.Text := JudgeOfflineSkin(mchoose_skin, checkbox_slim.Checked);
end;
//账号部分：离线登录：Sunny
procedure Tform_mainform.radiobutton_sunnyClick(Sender: TObject);
begin
  mchoose_skin := 7;
  edit_offline_uuid.Text := JudgeOfflineSkin(mchoose_skin, checkbox_slim.Checked);
end;
//账号部分：离线登录：Zuri
procedure Tform_mainform.radiobutton_zuriClick(Sender: TObject);
begin
  mchoose_skin := 8;
  edit_offline_uuid.Text := JudgeOfflineSkin(mchoose_skin, checkbox_slim.Checked);
end;
//背景设置：控件透明度滑动条
procedure Tform_mainform.scrollbar_background_control_alphaChange(
  Sender: TObject);
begin
  mcontrol_alpha := scrollbar_background_control_alpha.Position;
  label_background_control_current_alpha.Caption := GetLanguage('label_background_control_current_alpha.caption').Replace('${control_alpha}', inttostr(mcontrol_alpha));
  SetLayeredWindowAttributes(pagecontrol_mainpage.Handle, RGB(255, 255, 255), mcontrol_alpha, LWA_ALPHA);
end;
//背景设置：窗口渐变产生步长滑动条
procedure Tform_mainform.scrollbar_background_gradient_stepChange(
  Sender: TObject);
begin
  mgradient_step := scrollbar_background_gradient_step.Position;
  label_background_gradient_current_step.Caption := GetLanguage('label_background_gradient_current_step.caption').Replace('${gradient_step}', inttostr(mgradient_step));
end;
//背景设置：窗口渐变产生值滑动条
procedure Tform_mainform.scrollbar_background_gradient_valueChange(
  Sender: TObject);
begin
  mgradient_value := scrollbar_background_gradient_value.Position;
  label_background_gradient_current_value.Caption := GetLanguage('label_background_gradient_current_value.caption').Replace('${gradient_value}', inttostr(mgradient_value));
end;
//背景设置：窗口透明度滑动条
procedure Tform_mainform.scrollbar_background_window_alphaChange(
  Sender: TObject);
begin
  mwindow_alpha := scrollbar_background_window_alpha.Position;
  label_background_window_current_alpha.Caption := GetLanguage('label_background_window_current_alpha.caption').Replace('${window_alpha}', inttostr(mwindow_alpha));
  AlphaBlendValue := mwindow_alpha;
end;
//启动设置：滑动条框
procedure Tform_mainform.scrollbox_launchMouseWheel(Sender: TObject;
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
//主窗口：总体计时器
var open_form: Boolean = true;
procedure Tform_mainform.timer_all_ticksTimer(Sender: TObject);
begin
  if open_form then begin
    open_form := false;
    try
      Log.Write('开始判断是否播放音乐。', LOG_START, LOG_INFO);
      var p := LLLini.ReadInteger('Misc', 'SelectType', -1);
      if (p < 1) or (p > 3) then raise Exception.Create('Format Exception');
      if p = 1 then PlayMusic;
    except
      Log.Write('是否打开启动器时播放音乐的ini配置文件不符。', LOG_START, LOG_ERROR);
      LLLini.WriteInteger('Misc', 'SelectType', 3);
    end;
    Log.Write('开始判断是否需要捐款。', LOG_START, LOG_INFO);
    case mopen_number of
      100: Isafdian(false, mopen_number);
      200: Isafdian(false, mopen_number);
      300: Isafdian(false, mopen_number);
      500: Isafdian(false, mopen_number);
      700: Isafdian(false, mopen_number);
      1000: Isafdian(false, mopen_number);
      1300: Isafdian(false, mopen_number);
      1800: Isafdian(false, mopen_number);
      2400: Isafdian(false, mopen_number);
      3000: Isafdian(false, mopen_number);
    end;
    Log.Write('开始判断插件是否存在于文件夹中，并且后缀为Json或dll。', LOG_START, LOG_INFO);
    var pdir := Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\plugins');
    if SysUtils.DirectoryExists(pdir) then begin
      var Files := TDirectory.GetFiles(pdir);
      for var I in Files do begin //遍历plugins文件夹
        if (RightStr(I, 5) = '.json') or (RightStr(I, 4) = '.dll') then begin //如果文件后缀为.json或者dll，则执行。
          var TM := TMenuItem.Create(mainmenu_mainpage); //设置一个菜单栏
          TM.OnClick := PluginMenuClick; //给菜单栏设置点击事件。
          TM.Caption := ExtractFileName(I); //给菜单栏设置标题，为Json的名字。
          mainmenu_mainpage.Items[4].Add(TM); //给主菜单栏添加这个菜单。
          Log.Write(Concat('判定成功，插件文件名为：', I), LOG_START, LOG_INFO);
        end else continue; //如果不为json或dll，则继续。
      end;
    end;
    Log.Write('开始判断语言是否存在于文件夹中，并且后缀为Json。', LOG_START, LOG_INFO);
    var ldir := Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\lang');
    if SysUtils.DirectoryExists(ldir) then begin
      var Files := TDirectory.GetFiles(ldir);
      for var I in Files do begin //遍历plugins文件夹
        if (RightStr(I, 5) = '.json') then begin //如果文件后缀为.json或者dll，则执行。
          var json := TJsonObject.ParseJSONValue(GetFile(I)) as TJsonObject;
          var title := json.GetValue('file_language_title').Value;
          var TM := TMenuItem.Create(mainmenu_mainpage); //设置一个菜单栏
          TM.OnClick := LanguageMenuClick; //给菜单栏设置点击事件。
          TM.Caption := title; //给菜单栏设置标题，为Json的名字。
          mainmenu_mainpage.Items[3].Add(TM); //给主菜单栏添加这个菜单。
          Log.Write(Concat('判定成功，语言文件名为：', I), LOG_START, LOG_INFO);
        end else continue; //如果不为json或dll，则继续。
      end;
    end;
  end;
end;
//主窗口：窗口渐变产生计时器
var mgradient_temp: Integer = 0;
procedure Tform_mainform.timer_form_gradient_tickTimer(Sender: TObject);
begin
  if mis_gradient then begin
    mgradient_temp := mgradient_temp + mgradient_step;
    if mgradient_temp >= mwindow_alpha then begin
      timer_form_gradient_tick.Enabled := False;
      AlphaBlendValue := LLLini.ReadInteger('Misc', 'WindowAlpha', -1);
    end else AlphaBlendValue := mgradient_temp;
  end else timer_form_gradient_tick.Enabled := false;
end;
//背景设置：窗口渐变产生开关
procedure Tform_mainform.toggleswitch_background_gradientClick(Sender: TObject);
begin
  if toggleswitch_background_gradient.IsOn then begin
    scrollbar_background_gradient_value.Enabled := true;
  end else begin
    scrollbar_background_gradient_value.Enabled := false;
  end;
  scrollbar_background_gradient_step.Enabled := scrollbar_background_gradient_value.Enabled;
  mis_gradient := scrollbar_background_gradient_value.Enabled;
end;

end.
