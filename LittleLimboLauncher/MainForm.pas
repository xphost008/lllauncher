unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.ImageCollection,
  Vcl.CheckLst, Vcl.ButtonGroup, Vcl.Buttons, Vcl.ControlList,
  VCLTee.TeCanvas, Vcl.Imaging.pngimage, Vcl.ComCtrls, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent, Vcl.WinXCtrls,
  Vcl.Imaging.jpeg;

type
  TForm1 = class(TForm)
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
    tabsheet_mainform_part: TTabSheet;
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
    label_background_window_alpha_value: TLabel;
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
    edit_background_gradient_speed: TEdit;
    edit_background_gradient_step: TEdit;
    label_background_mainform_title: TLabel;
    edit_background_mainform_title: TEdit;
    label_background_control_alpha: TLabel;
    scrollnar_background_control_alpha: TScrollBar;
    label_background_control_alpha_value: TLabel;
    tabsheet_launch_part: TTabSheet;
    label_launch_window_size: TLabel;
    label_launch_window_width: TEdit;
    label_launch_window_x: TLabel;
    label_launch_window_height: TEdit;
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
    procedure button_launch_gameClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.button_launch_gameClick(Sender: TObject);
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

procedure TForm1.FormShow(Sender: TObject);
begin
//  buttoncolor1.SymbolColor := rgb(255, 0, 255);
//  SetWindowLong(pagecontrol_mainpage.Handle, GWL_EXSTYLE, GetWindowLong(pagecontrol_mainpage.Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
//  SetLayeredWindowAttributes(pagecontrol_mainpage.Handle, RGB(255, 255, 255), 162, LWA_ALPHA);
end;

end.
