unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Forms, DateUtils, Dialogs, Zip,
  StdCtrls, pngimage, WinXCtrls, ComCtrls, CheckLst, JSON, ShellAPI, Math, IniFiles, Menus,
  ExtCtrls, Controls, Vcl.MPlayer, Log4Delphi, Vcl.Imaging.jpeg, Generics.Collections, FileCtrl,
  Vcl.Buttons, Threading, ClipBrd, RegularExpressions, IOUtils, System.StrUtils, Types,
  IdBaseComponent, IdComponent, IdCustomTCPServer, IdCustomHTTPServer, NetEncoding,
  IdHTTPServer;

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
    label_mainform_tips: TLabel;
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
    tabsheet_resource_part: TTabSheet;
    label_resource_tip: TLabel;
    pagecontrol_resource_part: TPageControl;
    tabsheet_resource_download_part: TTabSheet;
    label_resource_search_name: TLabel;
    label_resource_search_version: TLabel;
    label_resource_return_value: TLabel;
    label_resource_search_category_modrinth_tip: TLabel;
    label_resource_search_version_tip: TLabel;
    label_resource_search_category_curseforge_tip: TLabel;
    label_resource_search_mode_tip: TLabel;
    label_resource_search_source_tip: TLabel;
    label_resource_search_name_tip: TLabel;
    listbox_resource_search_name: TListBox;
    listbox_resource_search_version: TListBox;
    button_resource_name_previous_page: TButton;
    button_resource_name_next_page: TButton;
    button_resource_version_previous_page: TButton;
    button_resource_version_next_page: TButton;
    edit_resource_search_name: TEdit;
    combobox_resource_search_source: TComboBox;
    combobox_resource_search_mode: TComboBox;
    combobox_resource_search_category_curseforge: TComboBox;
    combobox_resource_search_version: TComboBox;
    checklistbox_resource_search_category_modrinth: TCheckListBox;
    button_open_download_website: TButton;
    button_resource_start_search: TButton;
    button_resource_start_download: TButton;
    tabsheet_resource_manage_part: TTabSheet;
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
    button_disable_choose_resource: TButton;
    button_enable_choose_resource: TButton;
    button_delete_choose_resource: TButton;
    button_rename_choose_resource: TButton;
    button_open_choose_resource: TButton;
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
    n_memory_optimize: TMenuItem;
    scrollbox_launch: TScrollBox;
    label_launch_window_size: TLabel;
    label_launch_window_width: TLabel;
    label_launch_window_height: TLabel;
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
    label_launch_max_memory: TLabel;
    scrollbar_launch_max_memory: TScrollBar;
    label_launch_custom_info: TLabel;
    edit_launch_custom_info: TEdit;
    label_launch_window_title: TLabel;
    edit_launch_window_title: TEdit;
    label_launch_pre_launch_script: TLabel;
    edit_launch_pre_launch_script: TEdit;
    button_launch_pre_launch_script: TButton;
    label_launch_after_launch_script: TLabel;
    edit_launch_after_launch_script: TEdit;
    button_launch_after_launch_script: TButton;
    label_launch_default_jvm: TLabel;
    edit_launch_default_jvm: TEdit;
    button_launch_default_jvm: TButton;
    label_launch_additional_jvm: TLabel;
    edit_launch_additional_jvm: TEdit;
    button_launch_additional_jvm: TButton;
    edit_launch_additional_game: TEdit;
    label_launch_additional_game: TLabel;
    button_launch_additional_game: TButton;
    scrollbox_version: TScrollBox;
    label_select_game_version: TLabel;
    combobox_select_game_version: TComboBox;
    label_select_file_list: TLabel;
    combobox_select_file_list: TComboBox;
    label_version_add_mc_path: TLabel;
    button_version_choose_any_directory: TButton;
    button_version_create_minecraft: TButton;
    label_version_current_path: TLabel;
    radiogroup_partition_version: TRadioGroup;
    button_version_complete: TButton;
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
    label_isolation_window_width: TLabel;
    label_isolation_window_height: TLabel;
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
    button_custom_color: TButton;
    tabsheet_online_octo_part: TTabSheet;
    edit_custom_download_path: TEdit;
    label_export_return_value: TLabel;
    label_message_board: TLabel;
    label_export_add_icon: TLabel;
    image_export_add_icon: TImage;
    button_export_add_icon: TButton;
    c1: TMenuItem;
    button_export_remove_icon: TButton;
    image_mainform_login_avatar: TImage;
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
    procedure combobox_resource_search_sourceChange(Sender: TObject);
    procedure combobox_resource_search_modeChange(Sender: TObject);
    procedure button_resource_start_searchClick(Sender: TObject);
    procedure combobox_resource_search_category_curseforgeChange(
      Sender: TObject);
    procedure checklistbox_resource_search_category_modrinthClick(
      Sender: TObject);
    procedure button_open_download_websiteClick(Sender: TObject);
    procedure button_resource_name_previous_pageClick(Sender: TObject);
    procedure button_resource_name_next_pageClick(Sender: TObject);
    procedure button_resource_version_previous_pageClick(Sender: TObject);
    procedure button_resource_version_next_pageClick(Sender: TObject);
    procedure listbox_resource_search_nameClick(Sender: TObject);
    procedure n_view_mod_profileClick(Sender: TObject);
    procedure n_view_mod_websiteClick(Sender: TObject);
    procedure listbox_resource_search_versionClick(Sender: TObject);
    procedure button_resource_start_downloadClick(Sender: TObject);
    procedure scrollbox_launchMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure pagecontrol_resource_partChange(Sender: TObject);
    procedure WmDropFiles(var Msg: TMessage); message WM_DROPFILES;
    procedure listbox_manage_import_mapClick(Sender: TObject);
    procedure listbox_manage_import_modClick(Sender: TObject);
    procedure listbox_manage_import_resourcepackClick(Sender: TObject);
    procedure listbox_manage_import_shaderClick(Sender: TObject);
    procedure listbox_manage_import_pluginClick(Sender: TObject);
    procedure listbox_manage_import_datapackClick(Sender: TObject);
    procedure button_disable_choose_resourceClick(Sender: TObject);
    procedure button_enable_choose_resourceClick(Sender: TObject);
    procedure button_delete_choose_resourceClick(Sender: TObject);
    procedure button_rename_choose_resourceClick(Sender: TObject);
    procedure button_open_choose_resourceClick(Sender: TObject);
    procedure scrollbar_launch_window_heightChange(Sender: TObject);
    procedure scrollbar_launch_window_widthChange(Sender: TObject);
    procedure combobox_launch_select_java_pathChange(Sender: TObject);
    procedure scrollbar_launch_max_memoryChange(Sender: TObject);
    procedure edit_launch_custom_infoChange(Sender: TObject);
    procedure edit_launch_window_titleChange(Sender: TObject);
    procedure edit_launch_pre_launch_scriptChange(Sender: TObject);
    procedure edit_launch_after_launch_scriptChange(Sender: TObject);
    procedure edit_launch_additional_jvmChange(Sender: TObject);
    procedure edit_launch_additional_gameChange(Sender: TObject);
    procedure scrollbox_versionMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure scrollbox_isolationMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure scrollbox_exportMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure button_launch_pre_launch_scriptClick(Sender: TObject);
    procedure button_launch_after_launch_scriptClick(Sender: TObject);
    procedure button_launch_default_jvmClick(Sender: TObject);
    procedure button_launch_additional_jvmClick(Sender: TObject);
    procedure button_launch_additional_gameClick(Sender: TObject);
    procedure button_launch_full_scan_javaClick(Sender: TObject);
    procedure button_launch_basic_scan_javaClick(Sender: TObject);
    procedure button_launch_manual_importClick(Sender: TObject);
    procedure button_launch_remove_javaClick(Sender: TObject);
    procedure button_launch_download_java_8Click(Sender: TObject);
    procedure button_launch_download_java_16Click(Sender: TObject);
    procedure button_launch_download_java_17Click(Sender: TObject);
    procedure button_launch_official_javaClick(Sender: TObject);
    procedure checklistbox_choose_view_modeClick(Sender: TObject);
    procedure radiogroup_choose_download_sourceClick(Sender: TObject);
    procedure radiogroup_choose_mod_loaderClick(Sender: TObject);
    procedure scrollbar_download_biggest_threadChange(Sender: TObject);
    procedure button_reset_download_partClick(Sender: TObject);
    procedure listbox_select_minecraftClick(Sender: TObject);
    procedure button_load_modloaderClick(Sender: TObject);
    procedure n_view_minecraft_infoClick(Sender: TObject);
    procedure button_custom_colorClick(Sender: TObject);
    procedure button_download_start_download_minecraftClick(Sender: TObject);
    procedure listbox_select_modloaderClick(Sender: TObject);
    procedure pagecontrol_download_partChange(Sender: TObject);
    procedure pagecontrol_download_partChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure button_custom_download_choose_pathClick(Sender: TObject);
    procedure button_custom_download_open_pathClick(Sender: TObject);
    procedure edit_custom_download_pathChange(Sender: TObject);
    procedure button_custom_download_startClick(Sender: TObject);
    procedure button_download_modloader_refreshClick(Sender: TObject);
    procedure button_download_modloader_downloadClick(Sender: TObject);
    procedure listbox_download_modloader_forgeClick(Sender: TObject);
    procedure listbox_download_modloader_fabricClick(Sender: TObject);
    procedure listbox_download_modloader_quiltClick(Sender: TObject);
    procedure listbox_download_modloader_neoforgeClick(Sender: TObject);
    procedure radiogroup_partition_versionClick(Sender: TObject);
    procedure button_version_choose_any_directoryClick(Sender: TObject);
    procedure button_version_create_minecraftClick(Sender: TObject);
    procedure combobox_select_file_listChange(Sender: TObject);
    procedure combobox_select_game_versionChange(Sender: TObject);
    procedure button_rename_version_listClick(Sender: TObject);
    procedure button_remove_version_listClick(Sender: TObject);
    procedure button_rename_game_versionClick(Sender: TObject);
    procedure button_delete_game_versionClick(Sender: TObject);
    procedure pagecontrol_version_partChange(Sender: TObject);
    procedure button_version_completeClick(Sender: TObject);
    procedure toggleswitch_is_open_isolationClick(Sender: TObject);
    procedure edit_isolation_java_pathChange(Sender: TObject);
    procedure button_isolation_choose_javaClick(Sender: TObject);
    procedure edit_isolation_custom_infoChange(Sender: TObject);
    procedure edit_isolation_window_titleChange(Sender: TObject);
    procedure toggleswitch_isolation_window_sizeClick(Sender: TObject);
    procedure scrollbar_isolation_window_widthChange(Sender: TObject);
    procedure scrollbar_isolation_window_heightChange(Sender: TObject);
    procedure toggleswitch_isolation_open_memoryClick(Sender: TObject);
    procedure scrollbar_isolation_game_memoryChange(Sender: TObject);
    procedure toggleswitch_isolation_open_partitionClick(Sender: TObject);
    procedure checkbox_isolation_is_partitionClick(Sender: TObject);
    procedure edit_isolation_additional_gameChange(Sender: TObject);
    procedure edit_isolation_additional_jvmChange(Sender: TObject);
    procedure edit_isolation_pre_launch_scriptChange(Sender: TObject);
    procedure edit_isolation_after_launch_scriptChange(Sender: TObject);
    procedure treeview_export_keep_fileCheckStateChanging(
      Sender: TCustomTreeView; Node: TTreeNode; NewCheckState,
      OldCheckState: TNodeCheckState; var AllowChange: Boolean);
    procedure radiogroup_export_modeClick(Sender: TObject);
    procedure scrollbar_export_max_memoryChange(Sender: TObject);
    procedure button_export_startClick(Sender: TObject);
    procedure n_current_versionClick(Sender: TObject);
    procedure n_reset_launcherClick(Sender: TObject);
    procedure n_check_updateClick(Sender: TObject);
    procedure n_entry_official_websiteClick(Sender: TObject);
    procedure n_support_authorClick(Sender: TObject);
    procedure n_support_bmclapiClick(Sender: TObject);
    procedure button_check_ipv6_ipClick(Sender: TObject);
    procedure listbox_view_all_ipv6_ipClick(Sender: TObject);
    procedure edit_online_ipv6_portChange(Sender: TObject);
    procedure button_copy_ipv6_ip_and_portClick(Sender: TObject);
    procedure button_online_ipv6_tipClick(Sender: TObject);
    procedure n_export_argumentClick(Sender: TObject);
    procedure pagecontrol_account_partChange(Sender: TObject);
    procedure image_exit_running_mcClick(Sender: TObject);
    procedure button_export_add_iconClick(Sender: TObject);
    procedure c1Click(Sender: TObject);
    procedure button_export_remove_iconClick(Sender: TObject);
  private
    { Private declarations }
    procedure PluginMenuClick(Sender: TObject);
    procedure LanguageMenuClick(Sender: TObject);
  public
    { Public declarations }
  end;

const
  LauncherVersion = '1.0.0-Beta-4';

var
  form_mainform: Tform_mainform;
  LLLini, OtherIni: TIniFile;
  AppData: String;
  Log: Log4D;
  crash_count: Integer = 0;
  mcpid: Integer = 0;
  v: TMediaPlayer;
var
  mopen_time: String;
  mopen_number, mlaunch_number: Integer;
  mred, mgreen, mblue, mwindow_alpha, mcontrol_alpha: Integer;
  mgradient_value, mgradient_step: Integer;
  mis_gradient: Boolean;
  mchoose_skin, mbiggest_thread, mdownload_source: Integer;
  mjudge_lang_chinese: Boolean;

implementation

(*
 * 大家好！这里是Little Limbo Launcher的源码部分，很高兴能在这里遇见你！
 * 如果你发现了任意的bug，可以自行观看这些源码部分，然后为作者提交pull request！
 * 如果你提交的任意pull request被作者【marge】了之后，你很有可能会被作者写到【传奇贡献人员】里面噢！
 * 如果你的确发现了bug，但是不知道如何解决，你也可以为作者提交一个issue，这个issue可以包含源码中什么文件的第几行。
 * 如果你的issue被作者标记为【solve】，你也很有可能会被作者写到【精品贡献人员】里噢！
 * 自然，如果你有很好的点子，想为作者提出一些建议，也可以发issue噢。
 * 只要作者将其标记为【accept】，你很有可能会被作者写到【优秀贡献人员】里噢！
 * 目前作者的贡献人员等级将分为4等，分别是【传奇】【精品】【优秀】【赞助】。分别对应着各位能为该启动器做出如何的贡献。
 * 其中【赞助】的全称是【赞助人员】，皆在表示为作者捐款10元及以上的金额做出一点点渺小的力量！
 * 如果你赞助的金额很多，但是并未为启动器做出贡献，你也将无法升级！因为贡献人员是为了给玩家做出贡献的提议！
 * 如果你不仅赞助了，而且为作者做出贡献了！你的名字将会不仅存在于【赞助】上，而且还会逐步往上升！直到所有名单里都有你！
 * 也就是说一个人最多可以拥有4个名字存在我的贡献名单上噢！
 * 因此请努力吧！让我们为LLL启动器的未来做出伟大的贡献吧！
 *)

uses
  MainMethod, LauncherMethod, BackgroundMethod, LanguageMethod, AccountMethod, MyCustomWindow, ExportMethod,
  PluginMethod, resourceMethod, ManageMethod, LaunchMethod, DownloadMethod, CustomDlMethod, VersionMethod,
  OnlineIPv6Method;

//var
//  Cave, Answer, Lucky: array of String;
//  Intro: array of array of String;

{$R *.dfm}
//任意插件菜单栏点击的事件
procedure Tform_mainform.PluginMenuClick(Sender: TObject);
begin
  var mi := Sender as TMenuItem;
  var mic := mi.Caption.Replace('&', '').Replace('[', '').Replace(']', '');
  Log.Write(Concat('你点击了', mic, '语言文件，开始加载！'), LOG_START, LOG_INFO);
  var ld := Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\plugins');
  if SysUtils.DirectoryExists(ld) then begin
    var Files := TDirectory.GetFiles(ld);
    for var I in Files do begin
      if RightStr(I, 5) = '.json' then begin //如果文件后缀为.json，则执行。
        if mic.IndexOf(ExtractFileName(I).Replace('&', '').Replace('[', '').Replace(']', '')) <> -1 then begin
          var f := GetFile(I);
          var ise := TJsonObject.ParseJSONValue(GetFile(I)) as TJsonObject;
          try
            f := GetWebText(ise.GetValue('url').Value);
            if f = '' then begin
              Log.Write('插件加载失败', LOG_ERROR, LOG_PLUGIN);
              messagebox(Handle, '获取的URL内容为空，请重新输入一个网址！', '获取的URL内容为空', MB_ICONERROR);
              exit;
            end;
            ise := TJsonObject.ParseJSONValue(f) as TJsonObject;
          except end;
          try
            if ise.GetValue('name').Value = '' then raise Exception.Create('Plugin Format Exception');
          except
            Log.Write(Concat('插件加载失败'), LOG_ERROR, LOG_PLUGIN);
            MyMessagebox(GetLanguage('messagebox_plugin.plugin_grammar_error.caption'), GetLanguage('messagebox_plugin.plugin_grammar_error.text'), MY_ERROR, [mybutton.myOK]);
            exit;
          end;
          Log.Write('插件解析成功，开始执行！', LOG_INFO, LOG_PLUGIN);
          CreateFirstPluginForm(ExtractFileName(I).Replace('.json', ''), f);
          exit;
        end else continue;
      end else if RightStr(I, 4) = '.dll' then begin
        if mic.IndexOf(ExtractFileName(I).Replace('&', '')) <> -1 then begin
          var inst := LoadLibrary(pchar(I));
          FreeLibrary(inst);
        end else continue;
      end else continue;
    end;
  end;
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
          if mi.Caption.Replace('&', '').Contains(title.Replace('&', '')) then begin
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
//下载部分：模组加载器手动安装包：Fabric下载
procedure Tform_mainform.listbox_download_modloader_fabricClick(
  Sender: TObject);
begin
  listbox_download_modloader_forge.ItemIndex := -1;
  listbox_download_modloader_quilt.ItemIndex := -1;
  listbox_download_modloader_neoforge.ItemIndex := -1;
end;
//下载部分：模组加载器手动安装包：Forge下载
procedure Tform_mainform.listbox_download_modloader_forgeClick(Sender: TObject);
begin
  listbox_download_modloader_fabric.ItemIndex := -1;
  listbox_download_modloader_quilt.ItemIndex := -1;
  listbox_download_modloader_neoforge.ItemIndex := -1;
end;
//下载部分：模组加载器手动安装包：NeoForge下载
procedure Tform_mainform.listbox_download_modloader_neoforgeClick(
  Sender: TObject);
begin
  listbox_download_modloader_fabric.ItemIndex := -1;
  listbox_download_modloader_quilt.ItemIndex := -1;
  listbox_download_modloader_forge.ItemIndex := -1;
end;
//下载部分：模组加载器手动安装包：Quilt下载
procedure Tform_mainform.listbox_download_modloader_quiltClick(Sender: TObject);
begin
  listbox_download_modloader_fabric.ItemIndex := -1;
  listbox_download_modloader_forge.ItemIndex := -1;
  listbox_download_modloader_neoforge.ItemIndex := -1;
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
procedure Tform_mainform.listbox_resource_search_nameClick(Sender: TObject);
begin
  resourceSelNameList;
end;
//玩法部分：版本列表框点击
procedure Tform_mainform.listbox_resource_search_versionClick(Sender: TObject);
begin
  resourceSelVerList;
end;
//下载部分：Minecraft版本选择
procedure Tform_mainform.listbox_select_minecraftClick(Sender: TObject);
begin
  try
    form_mainform.edit_minecraft_version_name.Text := form_mainform.listbox_select_minecraft.Items[form_mainform.listbox_select_minecraft.ItemIndex];
    listbox_select_modloader.ItemIndex := -1;
    listbox_select_modloader.Items.Clear;
  except end;
end;
//下载部分：模组加载器列表框
procedure Tform_mainform.listbox_select_modloaderClick(Sender: TObject);
begin
  try
    form_mainform.edit_minecraft_version_name.Text := Concat(form_mainform.listbox_select_minecraft.Items[form_mainform.listbox_select_minecraft.ItemIndex], '-', form_mainform.listbox_select_modloader.Items[form_mainform.listbox_select_modloader.ItemIndex]);
  except end;
end;
//联机IPv6：列表框点击
procedure Tform_mainform.listbox_view_all_ipv6_ipClick(Sender: TObject);
begin
  ChangeIPv6List;
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
//检查更新
procedure Tform_mainform.n_check_updateClick(Sender: TObject);
begin
  MyMessagebox('暂时无法更新', '暂时无法查询，请去https://github.com/rechalow/lllauncher中手动找到下载一栏查看更新！', MY_INFORMATION, [mybutton.myOK]);
end;
//当前版本
procedure Tform_mainform.n_current_versionClick(Sender: TObject);
begin
  MyMessagebox(GetLanguage('messagebox_mainform.show_lll_version.caption'), GetLanguage('messagebox_mainform.show_lll_version.text').Replace('${version}', LauncherVersion), MY_INFORMATION, [mybutton.myOK]);
end;
//进入官网
procedure Tform_mainform.n_entry_official_websiteClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, nil, 'https://github.com/rechalow/lllauncher', nil, nil, SW_SHOWNORMAL);
end;
//手动导出启动参数
procedure Tform_mainform.n_export_argumentClick(Sender: TObject);
begin
  if mjudge_lang_chinese then begin
    StartLaunch(true);
  end else begin
    MyMessagebox(GetLanguage('messagebox_mainform.cannot_export_launch_args.caption'), GetLanguage('messagebox_mainform.cannot_export_launch_args.text'), MY_ERROR, [mybutton.myOK]);
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
  if MyMessagebox(GetLanguage('messagebox_mainform.release_memory_optimize_warning.caption'), GetLanguage('messagebox_mainform.release_memory_optimize_warning.text'), MY_WARNING, [mybutton.myNo, mybutton.myYes]) = 1 then exit;
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
//        exit;
      end;
      var re2 := NtSetSystemInformation(80, @i2, sizeof(i2));
      if re2 <> 0 then begin
        MyMessagebox(GetLanguage('messagebox_mainform.cannot_release_second_memory.caption'), GetLanguage('messagebox_mainform.cannot_release_second_memory.text'), MY_ERROR, [mybutton.myOK]);
//        exit;
      end;
      var re3 := NtSetSystemInformation(80, @i3, sizeof(i3));
      if re3 <> 0 then begin
        MyMessagebox(GetLanguage('messagebox_mainform.cannot_release_third_memory.caption'), GetLanguage('messagebox_mainform.cannot_release_third_memory.text'), MY_ERROR, [mybutton.myOK]);
//        exit;
      end;
      var re4 := NtSetSystemInformation(80, @i4, sizeof(i4));
      if re4 <> 0 then begin
        MyMessagebox(GetLanguage('messagebox_mainform.cannot_release_forth_memory.caption'), GetLanguage('messagebox_mainform.cannot_release_forth_memory.text'), MY_ERROR, [mybutton.myOK]);
//        exit;
      end;
      var re5 := NtSetSystemInformation(80, @i5, sizeof(i5));
      if re5 <> 0 then begin
        MyMessagebox(GetLanguage('messagebox_mainform.cannot_release_fifth_memory.caption'), GetLanguage('messagebox_mainform.cannot_release_fifth_memory.text'), MY_ERROR, [mybutton.myOK]);
//        exit;
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
begin
  showmessage(IntToStr(MyMultiButtonBox('Hello', MY_ERROR, ['World!', 'Who are you', 'you are pig!', 'good morning', 'nice to meet you', 'wtf you say!', 'are you crazy?', 'meow', 'hhhh'])));
end;
//下载部分：查看MC版本信息
procedure Tform_mainform.n_view_minecraft_infoClick(Sender: TObject);
begin
  ViewMinecraftInfo;
end;
//玩法部分：打开该模组的简介
procedure Tform_mainform.n_view_mod_profileClick(Sender: TObject);
begin
  resourceOpenIntro;
end;
//玩法部分：打开该模组的官网。
procedure Tform_mainform.n_view_mod_websiteClick(Sender: TObject);
begin
  resourceOpenVerWeb;
end;
//联机部分：开始检测IPv6地址
procedure Tform_mainform.button_check_ipv6_ipClick(Sender: TObject);
begin
  InitIPv6Online;
end;
//IPv6联机：复制链接
procedure Tform_mainform.button_copy_ipv6_ip_and_portClick(Sender: TObject);
begin
  CopyIPv6Link;
end;
//背景设置：自定义配色按钮
procedure Tform_mainform.button_custom_colorClick(Sender: TObject);
begin
  var CD := TColorDialog.Create(nil);
  if CD.Execute() then begin
    var cor := CD.Color;
    mred := cor and $FF;
    mgreen := (cor and $FF00) shr 8;
    mblue := (cor and $FF0000) shr 16;
    self.Color := rgb(mred, mgreen, mblue);
  end;
end;
//自定义下载：选择路径
procedure Tform_mainform.button_custom_download_choose_pathClick(
  Sender: TObject);
begin
  ChangeSavePath;
end;
//自定义下载：打开路径
procedure Tform_mainform.button_custom_download_open_pathClick(Sender: TObject);
begin
  OpenSavePath;
end;
//开始下载自定义文件下载
procedure Tform_mainform.button_custom_download_startClick(Sender: TObject);
begin
  StartDownloadCustomDl;
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
  self.Color := rgb(mred, mgreen, mblue);
end;
//账号部分：删除账号
procedure Tform_mainform.button_delete_accountClick(Sender: TObject);
begin
  combobox_all_account.ItemIndex := DeleteAccount(combobox_all_account.ItemIndex);
end;
//玩法管理界面：删除选中
procedure Tform_mainform.button_delete_choose_resourceClick(Sender: TObject);
begin
  ManageDeleteresource;
end;
//版本设置：删除游戏版本
procedure Tform_mainform.button_delete_game_versionClick(Sender: TObject);
begin
  if mselect_ver < 0 then begin
    MyMessagebox(GetLanguage('messagebox_version.no_ver_dir.caption'), GetLanguage('messagebox_version.no_ver_dir.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  if MyMessagebox(GetLanguage('messagebox_version.is_delete_ver.caption'), GetLanguage('messagebox_version.is_delete_ver.text'), MY_WARNING, [mybutton.myNo, mybutton.myYes]) = 1 then exit;
  if DeleteDirectory(MCVersionSelect[mselect_ver]) then begin
    mselect_ver := -1;
    SelVer;
    MyMessagebox(GetLanguage('messagebox_version.delete_ver_success.caption'), GetLanguage('messagebox_version.delete_ver_success.text'), MY_PASS, [mybutton.myOK]);
  end else begin
    MyMessagebox(GetLanguage('messagebox_version.delete_ver_error.caption'), GetLanguage('messagebox_version.delete_ver_error.text'), MY_ERROR, [mybutton.myOK]);
  end;
end;
//玩法管理界面：禁用选中
procedure Tform_mainform.button_disable_choose_resourceClick(Sender: TObject);
begin
  ManageDisableresource;
end;
//下载部分：模组加载器手动安装包：开始下载
procedure Tform_mainform.button_download_modloader_downloadClick(
  Sender: TObject);
begin
  StartDownloadModLoader;
end;
//下载部分：模组加载器手动安装包：刷新版本
procedure Tform_mainform.button_download_modloader_refreshClick(
  Sender: TObject);
begin
  RefreshModLoader;
end;
//开始自动安装Minecraft
procedure Tform_mainform.button_download_start_download_minecraftClick(
  Sender: TObject);
begin
  DownloadMinecraft;
end;
//玩法管理界面：启用选中
procedure Tform_mainform.button_enable_choose_resourceClick(Sender: TObject);
begin
  ManageEnableresource;
end;
//整合包导入图标
procedure Tform_mainform.button_export_add_iconClick(Sender: TObject);
begin
  var OD := TOpenDialog.Create(nil);
  OD.Title := GetLanguage('opendialog_export.add_icon');
  OD.Filter := '*.png|*.png';
  if OD.Execute() then begin
    var ph := OD.FileName;
    ImportModPackIcon(ph);
  end;
end;
//移除图标文件
procedure Tform_mainform.button_export_remove_iconClick(Sender: TObject);
begin
  RemoveModPackIcon;
end;
//整合包导出：开始导出咯！
procedure Tform_mainform.button_export_startClick(Sender: TObject);
begin
  StartExport;
end;
//背景设置：小草绿
procedure Tform_mainform.button_grass_colorClick(Sender: TObject);
begin
  mred := 50;
  mgreen := 205;
  mblue := 50;
  self.Color := rgb(mred, mgreen, mblue);
end;
//独立设置：Java路径选择按钮
procedure Tform_mainform.button_isolation_choose_javaClick(Sender: TObject);
begin
  var CB := TOpenDialog.Create(nil);
  CB.Title := GetLanguage('opendialog_launch.menual_import_java_dialog_title');
  CB.Filter := 'javaw(javaw.exe)|javaw.exe';
  if CB.Execute() then begin
    var jpath := CB.FileName;
    edit_isolation_java_path.Text := jpath;
    edit_isolation_java_pathChange(Sender);
  end;
end;
//启动设置；额外Game参数
procedure Tform_mainform.button_launch_additional_gameClick(Sender: TObject);
begin
  MyMessagebox(GetLanguage('messagebox_launch.additional_game_tip.caption'), GetLanguage('messagebox_launch.additional_game_tip.text'), MY_INFORMATION, [mybutton.myYes]);
end;
//启动设置：额外JVM参数
procedure Tform_mainform.button_launch_additional_jvmClick(Sender: TObject);
begin
  MyMessagebox(GetLanguage('messagebox_launch.additional_jvm_tip.caption'), GetLanguage('messagebox_launch.additional_jvm_tip.text'), MY_INFORMATION, [mybutton.myYes]);
end;
//启动设置：后置启动脚本
procedure Tform_mainform.button_launch_after_launch_scriptClick(
  Sender: TObject);
begin
  MyMessagebox(GetLanguage('messagebox_launch.after_launch_script_tip.caption'), GetLanguage('messagebox_launch.after_launch_script_tip.text'), MY_INFORMATION, [mybutton.myYes]);
end;
//特定扫描Java
procedure Tform_mainform.button_launch_basic_scan_javaClick(Sender: TObject);
begin
  BasicScanJava();
end;
//启动设置：默认JVM参数
procedure Tform_mainform.button_launch_default_jvmClick(Sender: TObject);
begin
  MyMessagebox(GetLanguage('messagebox_launch.default_jvm_tip.caption'), GetLanguage('messagebox_launch.default_jvm_tip.text'), MY_INFORMATION, [mybutton.myYes]);
end;
//下载Java16
procedure Tform_mainform.button_launch_download_java_16Click(Sender: TObject);
begin
  DownloadJava('java-runtime-alpha');
end;
//下载Java17
procedure Tform_mainform.button_launch_download_java_17Click(Sender: TObject);
begin
  DownloadJava('java-runtime-gamma');
end;
//下载Java8
procedure Tform_mainform.button_launch_download_java_8Click(Sender: TObject);
begin
  DownloadJava('jre-legacy');
end;
//全盘扫描Java
procedure Tform_mainform.button_launch_full_scan_javaClick(Sender: TObject);
begin
  FullScanJava();
end;
//主界面：启动游戏按钮
procedure Tform_mainform.button_launch_gameClick(Sender: TObject);
begin
  StartLaunch(false);
end;
//启动设置：手动导入Java
procedure Tform_mainform.button_launch_manual_importClick(Sender: TObject);
begin
  ManualImportJava();
end;
//打开Java官网
procedure Tform_mainform.button_launch_official_javaClick(Sender: TObject);
var
  offname: TArray<string>;
  offurl: TArray<string>;
  ul: String;
begin
  offname := [
            '(Oracle)',
            '(Microsoft)',
            '(Eclipse Temurin)',
            '(Bell Soft)',
            '(Azul Zulu)',
            '(Open Logic)',
            '(Red Hat)',
            '(Amazon Corretto)',
            '(jdk)'
  ];
  offurl := [
            'https://www.oracle.com/java/technologies/downloads/',
            'https://learn.microsoft.com/zh-cn/java/openjdk/download',
            'https://adoptium.net/temurin/releases/',
            'https://bell-sw.com/pages/downloads/',
            'https://www.azul.com/downloads/?package=jdk',
            'https://www.openlogic.com/openjdk-downloads',
            'https://developers.redhat.com/products/openjdk/download',
            'https://aws.amazon.com/cn/corretto/',
            'https://jdk.java.net'
  ];
  var i := MyMultiButtonBox(GetLanguage('inputbox_launch.select_java_web.caption'), MY_INFORMATION, offname);
  if i = 0 then exit;
  ul := offurl[i - 1];
  ShellExecute(Application.Handle, nil, pchar(ul), nil, nil, SW_SHOWNORMAL);
end;
//启动设置：前置启动脚本
procedure Tform_mainform.button_launch_pre_launch_scriptClick(Sender: TObject);
begin
  MyMessagebox(GetLanguage('messagebox_launch.pre_launch_script_tip.caption'), GetLanguage('messagebox_launch.pre_launch_script_tip.text'), MY_INFORMATION, [mybutton.myYes]);
end;
//启动设置：移除Java
procedure Tform_mainform.button_launch_remove_javaClick(Sender: TObject);
begin
  RemoveJava;
end;
//下载部分：加载模组加载器
procedure Tform_mainform.button_load_modloaderClick(Sender: TObject);
begin
  LoadModLoader;
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
  self.Color := rgb(mred, mgreen, mblue);
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
//IPv6联机：联机提示
procedure Tform_mainform.button_online_ipv6_tipClick(Sender: TObject);
begin
  MyMessagebox(GetLanguage('messagebox_ipv6.online_tips.caption'), GetLanguage('messagebox_ipv6.online_tips.text'), MY_INFORMATION, [mybutton.myOK])
end;
//玩法管理界面：打开选中的文件夹
procedure Tform_mainform.button_open_choose_resourceClick(Sender: TObject);
begin
  ManageOpenresource;
end;
//打开下载源官网
procedure Tform_mainform.button_open_download_websiteClick(Sender: TObject);
begin
  resourceOpenOciWeb();
end;
//玩法界面：名称下一页
procedure Tform_mainform.button_resource_name_next_pageClick(Sender: TObject);
begin
  resourcePageDownName();
end;
//玩法界面：名称上一页
procedure Tform_mainform.button_resource_name_previous_pageClick(
  Sender: TObject);
begin
  resourcePageUpName();
end;
//玩法界面：开始下载
procedure Tform_mainform.button_resource_start_downloadClick(Sender: TObject);
begin
  resourceDownload;
end;
//下载进度界面：清空列表框
procedure Tform_mainform.button_resource_start_searchClick(Sender: TObject);
begin
  resourceStartSearch;
end;
//玩法界面：版本下一页
procedure Tform_mainform.button_resource_version_next_pageClick(Sender: TObject);
begin
  resourcePageDownVer();
end;
//玩法界面：版本上一页
procedure Tform_mainform.button_resource_version_previous_pageClick(
  Sender: TObject);
begin
  resourcePageUpVer();
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
//版本设置：移除文件列表
procedure Tform_mainform.button_remove_version_listClick(Sender: TObject);
begin
  if mselect_mc < 0 then begin
    MyMessagebox(GetLanguage('messagebox_version.no_mc_dir.caption'), GetLanguage('messagebox_version.no_mc_dir.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  if MyMessagebox(GetLanguage('messagebox_version.is_remove_mc_dir.caption'), GetLanguage('messagebox_version.is_remove_mc_dir.text'), MY_INFORMATION, [mybutton.myNo, mybutton.myYes]) = 1 then exit;
  (MCJson.GetValue('mc') as TJsonArray).Remove(combobox_select_file_list.ItemIndex); //移除Json
  combobox_select_game_version.Clear;
  MCVersionList.Delete(combobox_select_file_list.ItemIndex);
  MCVersionName.Delete(combobox_select_file_list.ItemIndex);
  combobox_select_file_list.Items.Delete(combobox_select_file_list.ItemIndex);
  mselect_mc := -1;
  mselect_ver := -1;
  combobox_select_file_list.ItemIndex := -1;
  label_version_current_path.Caption := GetLanguage('label_version_current_path.caption').Replace('${current_path}', '');
  MyMessagebox(GetLanguage('messagebox_version.remove_mc_dir_success.caption'), GetLanguage('messagebox_version.remove_mc_dir_success.text'), MY_PASS, [mybutton.myOK]);
end;
//玩法管理界面：重命名选中
procedure Tform_mainform.button_rename_choose_resourceClick(Sender: TObject);
begin
  ManageRenameresource;
end;
//版本设置：重命名游戏版本
procedure Tform_mainform.button_rename_game_versionClick(Sender: TObject);
begin
  if mselect_ver < 0 then begin
    MyMessagebox(GetLanguage('messagebox_version.no_ver_dir.caption'), GetLanguage('messagebox_version.no_ver_dir.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  var CB := MyInputBox(GetLanguage('inputbox_version.enter_ver_rename.caption'), GetLanguage('inputbox_version.enter_ver_rename.text'), MY_INFORMATION);
  if CB = '' then exit;
  var tpv := mselect_ver; //将原始记录添加一个至本目标。至一个临时变量。
  var mcp := MCVersionSelect[mselect_ver];  //获取MC查询版本后的文件目录
  var tmp := ExtractFileDir(mcp);   //消除最后一个文件夹目录
  var newmcp := Concat(tmp, '\', cb); //将cb目录添加
  var bo := RenDirectory(mcp, newmcp);  //调用重命名文件夹的指令。
  SelVer; //添加最后一个
  mselect_ver := tpv; //给目标赋值
  combobox_select_game_version.ItemIndex := mselect_ver;
  if bo then MyMessagebox(GetLanguage('messagebox_version.rename_ver_success.caption'), GetLanguage('messagebox_version.rename_ver_success.text'), MY_PASS, [mybutton.myOK])
  else MyMessagebox(GetLanguage('messagebox_version.rename_ver_error.caption'), GetLanguage('messagebox_version.rename_ver_error.caption'), MY_ERROR, [mybutton.myOK]);
end;
//版本设置：重命名文件列表
procedure Tform_mainform.button_rename_version_listClick(Sender: TObject);
begin
  if mselect_mc < 0 then begin
    MyMessagebox(GetLanguage('messagebox_version.no_mc_dir.caption'), GetLanguage('messagebox_version.no_mc_dir.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  var CB := MyInputBox(GetLanguage('inputbox_version.enter_mc_rename.caption'), GetLanguage('inputbox_version.enter_mc_rename.text'), MY_INFORMATION);
  if CB = '' then exit;
  ((MCJson.GetValue('mc') as TJsonArray)[form_mainform.combobox_select_file_list.ItemIndex] as TJsonObject).RemovePair('name');
  ((MCJson.GetValue('mc') as TJsonArray)[form_mainform.combobox_select_file_list.ItemIndex] as TJsonObject).AddPair('name', cb);
  MCVersionName.Delete(mselect_mc); //删除原元素并添加新元素。
  MCVersionName.Insert(mselect_mc, cb);
  combobox_select_file_list.Items.Delete(mselect_mc);
  combobox_select_file_list.Items.Insert(mselect_mc, cb);
  combobox_select_file_list.ItemIndex := mselect_mc;
  MyMessagebox(GetLanguage('messagebox_version.rename_mc_success.caption'), GetLanguage('messagebox_version.rename_mc_success.text'), MY_PASS, [mybutton.myOK]);
end;
//下载部分：重置下载界面
procedure Tform_mainform.button_reset_download_partClick(Sender: TObject);
begin
  ResetDownload;
end;
//背景设置：天空蓝
procedure Tform_mainform.button_sky_colorClick(Sender: TObject);
begin
  mred := 0;
  mgreen := 191;
  mblue := 255;
  self.Color := rgb(mred, mgreen, mblue);
end;
//背景设置：苏丹红
procedure Tform_mainform.button_sultan_colorClick(Sender: TObject);
begin
  mred := 189;
  mgreen := 0;
  mblue := 0;
  self.Color := rgb(mred, mgreen, mblue);
end;
//背景设置：日落黄
procedure Tform_mainform.button_sun_colorClick(Sender: TObject);
begin
  mred := 255;
  mgreen := 215;
  mblue := 0;
  self.Color := rgb(mred, mgreen, mblue);
end;
//账号部分：检测Authlib是否有更新
procedure Tform_mainform.button_thirdparty_check_authlib_updateClick(
  Sender: TObject);
begin
  InitAuthlib;
end;
//选择任意文件夹按钮
procedure Tform_mainform.button_version_choose_any_directoryClick(
  Sender: TObject);
var
  path: String;
  name: String;
begin
  if SelectDirectory(GetLanguage('selectdialog_version.select_mc_path'), '', path) then begin
    if MCVersionList.Contains(path) then begin
      MyMessagebox(GetLanguage('messagebox_version.path_is_exists.caption'), GetLanguage('messagebox_version.path_is_exists.text'), MY_ERROR, [mybutton.myOK]);
      exit;
    end;
    name := MyInputBox(GetLanguage('inputbox_version.select_mc_name.caption'), GetLanguage('inputbox_version.select_mc_name.text'), MY_INFORMATION);
    if name = '' then exit;
    ChooseVersionDir(name, path);
  end;
end;
//版本设置：手动补全版本类库
procedure Tform_mainform.button_version_completeClick(Sender: TObject);
begin
  CompleteVersion;
end;
//新建.minecraft文件夹按钮
procedure Tform_mainform.button_version_create_minecraftClick(Sender: TObject);
var
  path: String;
  name: String;
begin
  path := Concat(ExtractFileDir(Application.ExeName), '\.minecraft');
  if MCVersionList.Contains(path) then begin
    MyMessagebox(GetLanguage('messagebox_version.path_is_exists.caption'), GetLanguage('messagebox_version.path_is_exists.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  name := MyInputBox(GetLanguage('inputbox_version.select_new_mc_name.caption'), GetLanguage('inputbox_version.select_new_mc_name.text'), MY_INFORMATION);
  if name = '' then exit;
  if not SysUtils.DirectoryExists(path) then begin
    MyMessagebox(GetLanguage('messagebox_version.create_minecraft_dir.caption'), GetLanguage('messagebox_version.create_minecraft_dir.text'), MY_INFORMATION, [mybutton.myOK]);
    SysUtils.ForceDirectories(path);
  end;
  ChooseVersionDir(name, path);
end;
//重设语言为中文
procedure Tform_mainform.c1Click(Sender: TObject);
begin
  if MyMessagebox(GetLanguage('messagebox_mainform.reset_language_to_chinese.caption'), GetLanguage('messagebox_mainform.reset_language_to_chinese.text'), MY_WARNING, [mybutton.myNo, mybutton.myYes]) = 1 then exit;
  deletefile(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\lang\zh_cn.json'));
  InitLanguage;
  SetLanguage('zh_cn');
  LLLini.WriteString('Language', 'SelectLanguageFile', 'zh_cn');
end;
//独立设置：开启单独隔离
procedure Tform_mainform.checkbox_isolation_is_partitionClick(Sender: TObject);
begin
  IsoMethod(11, booltostr(checkbox_isolation_is_partition.Checked));
end;
//账号部分：离线登录：Slim
procedure Tform_mainform.checkbox_slimClick(Sender: TObject);
begin
  edit_offline_uuid.Text := JudgeOfflineSkin(mchoose_skin, checkbox_slim.Checked);
end;
//下载部分：选择显示方式
procedure Tform_mainform.checklistbox_choose_view_modeClick(Sender: TObject);
begin
  CheckMode;
end;
//搜索类型改变复选组（Modrinth）
procedure Tform_mainform.checklistbox_resource_search_category_modrinthClick(
  Sender: TObject);
begin
  resourceSelCateModrinth;
end;
//账号部分：所有账号下拉框改变事件
procedure Tform_mainform.combobox_all_accountChange(Sender: TObject);
begin
  if combobox_all_account.ItemIndex = -1 then exit;
  var pla := ((AccountJson.Values['account'] as TJsonArray)[combobox_all_account.ItemIndex] as TJsonObject);
  JudgeJSONSkin(combobox_all_account.ItemIndex);
  label_account_return_value.Caption := GetLanguage('label_account_return_value.caption.logined').Replace('${player_name}', pla.GetValue('name').Value);
end;
//启动设置：Java下拉框修改
procedure Tform_mainform.combobox_launch_select_java_pathChange(
  Sender: TObject);
begin
  mcurrent_java := combobox_launch_select_java_path.ItemIndex;
end;
//搜索类型改变下拉框（Curseforge）
procedure Tform_mainform.combobox_resource_search_category_curseforgeChange(
  Sender: TObject);
begin
  resourceSelCateCurseforge;
end;
//搜索方式修改的下拉框
procedure Tform_mainform.combobox_resource_search_modeChange(Sender: TObject);
begin
  resourceSelMode;
end;
//搜索源修改的下拉框
procedure Tform_mainform.combobox_resource_search_sourceChange(Sender: TObject);
begin
  resourceSelSource;
end;
//版本设置：文件列表下拉框改变
procedure Tform_mainform.combobox_select_file_listChange(Sender: TObject);
begin
  mselect_mc := combobox_select_file_list.ItemIndex;
  mselect_ver := -1;
  SelVer;
end;
//版本设置：游戏版本下拉框改变
procedure Tform_mainform.combobox_select_game_versionChange(Sender: TObject);
begin
  mselect_ver := combobox_select_game_version.ItemIndex;
end;
//背景设置：窗口标题
procedure Tform_mainform.edit_background_mainform_titleChange(Sender: TObject);
begin
  Caption := edit_background_mainform_title.Text;
end;
//自定义下载：路径输入
procedure Tform_mainform.edit_custom_download_pathChange(Sender: TObject);
begin
  ChangeSaveEdit;
end;
//独立设置：额外Game参数输入框
procedure Tform_mainform.edit_isolation_additional_gameChange(Sender: TObject);
begin
  IsoMethod(12, edit_isolation_additional_game.Text);
end;
//独立设置：额外JVM参数输入框
procedure Tform_mainform.edit_isolation_additional_jvmChange(Sender: TObject);
begin
  IsoMethod(13, edit_isolation_additional_jvm.Text);
end;
//独立设置：后置启动脚本
procedure Tform_mainform.edit_isolation_after_launch_scriptChange(
  Sender: TObject);
begin
  IsoMethod(15, edit_isolation_after_launch_script.Text);
end;
//独立设置：自定义信息输入框
procedure Tform_mainform.edit_isolation_custom_infoChange(Sender: TObject);
begin
  IsoMethod(3, form_mainform.edit_isolation_custom_info.Text);
end;
//独立设置：Java路径输入框
procedure Tform_mainform.edit_isolation_java_pathChange(Sender: TObject);
begin
  IsoMethod(2, form_mainform.edit_isolation_java_path.Text);
end;
//独立设置：前置启动脚本
procedure Tform_mainform.edit_isolation_pre_launch_scriptChange(
  Sender: TObject);
begin
  IsoMethod(14, edit_isolation_pre_launch_script.Text);
end;
//独立设置：窗口标题输入框
procedure Tform_mainform.edit_isolation_window_titleChange(Sender: TObject);
begin
  IsoMethod(4, form_mainform.edit_isolation_window_title.Text);
end;
//启动设置：额外game参数
procedure Tform_mainform.edit_launch_additional_gameChange(Sender: TObject);
begin
  madd_game := edit_launch_additional_game.Text;
end;
//启动设置：额外JVM参数
procedure Tform_mainform.edit_launch_additional_jvmChange(Sender: TObject);
begin
  madd_jvm := edit_launch_additional_jvm.Text;
end;
//启动设置：后置启动脚本
procedure Tform_mainform.edit_launch_after_launch_scriptChange(Sender: TObject);
begin
  mafter_script := edit_launch_after_launch_script.Text;
end;
//启动设置：自定义信息
procedure Tform_mainform.edit_launch_custom_infoChange(Sender: TObject);
begin
  mcustom_info := edit_launch_custom_info.Text;
end;
//启动设置：前置启动脚本
procedure Tform_mainform.edit_launch_pre_launch_scriptChange(Sender: TObject);
begin
  mpre_script := edit_launch_pre_launch_script.Text;
end;
//启动设置：窗口标题
procedure Tform_mainform.edit_launch_window_titleChange(Sender: TObject);
begin
  mwindow_title := edit_launch_window_title.Text;
end;
//IPv6联机：端口号被修改
procedure Tform_mainform.edit_online_ipv6_portChange(Sender: TObject);
begin
  ChangeIPv6Port;
end;
//主界面：窗口关闭事件
procedure Tform_mainform.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveBackground;
  SaveAccount;
  Saveresource;
  SaveLaunch;
  SaveDownload;
  SaveCustomDl;
  SaveVersion;
  ShellExecute(Application.Handle, 'open', 'taskkill.exe', '/F /IM LittleLimboLauncher.exe', nil, SW_HIDE);
end;
procedure Tform_mainform.WmDropFiles(var Msg: TMessage);
begin
  if pagecontrol_mainpage.ActivePage = tabsheet_resource_part then begin
    if pagecontrol_resource_part.ActivePage = tabsheet_resource_manage_part then begin
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
    LLLini.WriteBool('Version', 'ShowLLLSpecial', False);
    LLLini.WriteInteger('Version', 'SelectDownloadSource', 1);
    LLLini.WriteInteger('Version', 'SelectModLoader', 1);
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
    Otherini.WriteInteger('Other', 'Random', random(2000000) + 1);
    Otherini.WriteBool('Other', 'AllowOffline', false);
    Otherini.WriteInteger('Misc', 'Launcher', 0);
    Otherini.WriteInteger('Misc', 'StartGame', 0);
  end;
  Log.Write('初始化变量2完毕。', LOG_INFO, LOG_START); //输出Log
  Log.Write('判断完成窗口创建事件！', LOG_INFO, LOG_START);
  ChangeWindowMessageFilter(WM_DROPFILES, MSGFLT_ADD);
  ChangeWindowMessageFilter(WM_COPYDATA, MSGFLT_ADD);
  ChangeWindowMessageFilter(WM_COPYGLOBALDATA, MSGFLT_ADD);
//  DragAcceptFiles(tabsheet_resource_manage_part.Handle, true);
  DragAcceptFiles(self.Handle, true);
  InitLanguage;
end;
//主界面：窗口展示事件
procedure Tform_mainform.FormShow(Sender: TObject);
begin
  pagecontrol_mainpage.ActivePage := tabsheet_mainpage_part;
  pagecontrol_account_part.ActivePage := tabsheet_account_microsoft_part;
  pagecontrol_resource_part.ActivePage := tabsheet_resource_download_part;
  pagecontrol_download_part.ActivePage := tabsheet_download_minecraft_part;
  pagecontrol_online_part.ActivePage := tabsheet_online_ipv6_part;
  pagecontrol_version_part.ActivePage := tabsheet_version_control_part;
  scrollbox_launch.VertScrollBar.Position := 0;
  scrollbox_version.VertScrollBar.Position := 0;
  scrollbox_isolation.VertScrollBar.Position := 0;
  scrollbox_export.VertScrollBar.Position := 0;
  v.ParentWindow := Handle;
  v.Visible := False;
  v.AutoOpen := false;
  if OtherIni.ReadString('Other', 'Lang', '') = '' then begin
    if JudgeCountry then begin
      mjudge_lang_chinese := true;
      OtherIni.WriteBool('Other', 'Lang', true);
    end else begin
      mjudge_lang_chinese := false;
      OtherIni.WriteBool('Other', 'Lang', false);
    end;
  end else begin
    if OtherIni.ReadBool('Other', 'Lang', false) then begin
      mjudge_lang_chinese := true;
    end else begin
      mjudge_lang_chinese := false;
    end;
  end;
  form_mainform.label_mainform_tips.Caption := '';
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
    var s := OtherIni.ReadInteger('Account', 'SelectAccount', -1) - 1;
    if s <= -1 then raise Exception.Create('Format Exception');
    var acv := (((TJsonObject.ParseJSONValue(json) as TJsonObject).GetValue('account') as TJsonArray)[s] as TJsonObject);
    var acn := acv.GetValue('name').Value;
    var aca := acv.GetValue('head_skin').Value;
    var base := TNetEncoding.Base64.DecodeStringToBytes(aca);
    var png := TPngImage.Create;
    try
      png.LoadFromStream(TBytesStream.Create(base));
      image_mainform_login_avatar.Picture.Assign(png);
    finally
      png.Free;
    end;
    Log.Write(Concat('账号判断完毕，欢迎', acn, '。'), LOG_INFO, LOG_START);
    label_account_view.Caption := GetLanguage('label_account_view.caption.have').Replace('${account_view}', acn);
  except
    Log.Write(Concat('账号判断失败，宁还暂未登录一个账号。'), LOG_ERROR, LOG_START);
    label_account_view.Caption := GetLanguage('label_account_view.caption.absence');
  end;
  try  //查询版本是否有误，如果找不到，则暂未选择版本。
    Log.Write('开始判断游戏版本。', LOG_INFO, LOG_START);
    mselect_ver := LLLini.ReadInteger('MC', 'SelectVer', -1);
    mselect_mc := LLLini.ReadInteger('MC', 'SelectMC', -1);
    var sjn := GetFile(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\MCSelJson.json'));
    var svr := ((TJsonObject.ParseJSONValue(sjn) as TJsonObject).GetValue('mcsel') as TJsonArray)[mselect_ver - 1] as TJsonObject;
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
    if IltIni.ReadBool('Isolation', 'IsIsolation', false) then svv := Concat(svv, GetLanguage('button_launch_game.caption.isolation'));
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
  try
    mdownload_source := LLLini.ReadInteger('Version', 'SelectDownloadSource', -1);
    if (mdownload_source < 1) or (mdownload_source > 3) then raise Exception.Create('Format Exception');
  except
    mdownload_source := 1;
    LLLini.WriteInteger('Version', 'SelectDownloadSource', 1);
  end;
  if not mjudge_lang_chinese then begin
    if mdownload_source <> 1 then begin
      mdownload_source := 1;
      LLLini.WriteInteger('Version', 'SelectDownloadSource', 1);
    end;
  end;
  timer_form_gradient_tick.Interval := mgradient_value;
  SetWindowLong(pagecontrol_mainpage.Handle, GWL_EXSTYLE, GetWindowLong(pagecontrol_mainpage.Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
  SetLayeredWindowAttributes(pagecontrol_mainpage.Handle, RGB(255, 255, 255), mcontrol_alpha, LWA_ALPHA);
  Log.Write(Concat('已判断完成，开始应用窗口颜色。'), LOG_INFO, LOG_START);
  Color := rgb(mred, mgreen, mblue); //实装RGBA。
  ResetBackImage(false);
end;
//强制结束MC
procedure Tform_mainform.image_exit_running_mcClick(Sender: TObject);
begin
  if image_exit_running_mc.Cursor = crHandPoint then begin
    ShellExecute(Application.Handle, 'open', 'taskkill.exe', pchar(Concat('/F /PID ', inttostr(mcpid))), nil, SW_SHOWNORMAL);
    mcpid := 0;
    Log.Write('宁结束了MC的运行。', LOG_INFO, LOG_LAUNCH);
    MyMessagebox(GetLanguage('messagebox_launcher.exit_mc_success.caption'), GetLanguage('messagebox_launcher.exit_mc_success.text'), MY_PASS, [mybutton.myOK]);
  end;
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
//账号部分：页切换！
procedure Tform_mainform.pagecontrol_account_partChange(Sender: TObject);
begin
  if not mjudge_lang_chinese then begin
    if pagecontrol_account_part.ActivePage = tabsheet_account_thirdparty_part then begin
      MyMessagebox(GetLanguage('messagebox_account.area_not_chinese.caption'), GetLanguage('messagebox_account.area_not_chinese.text'), MY_ERROR, [mybutton.myOK]);
      pagecontrol_account_part.ActivePage := tabsheet_account_microsoft_part;
    end;
  end;
end;
//下载部分：初次切换页
procedure Tform_mainform.pagecontrol_download_partChange(Sender: TObject);
begin
  if pagecontrol_download_part.ActivePage = tabsheet_download_custom_part then
    InitCustomDl
  else if pagecontrol_download_part.ActivePage = tabsheet_download_modloader_part then begin
    InitCustomDl;
    RefreshModLoader;
  end;
end;
//下载部分：切换页面前
procedure Tform_mainform.pagecontrol_download_partChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  if pagecontrol_download_part.ActivePage = tabsheet_download_custom_part then
    SaveCustomDl;
end;
//主界面：初次切换页
procedure Tform_mainform.pagecontrol_mainpageChange(Sender: TObject);
begin
  if pagecontrol_mainpage.ActivePage = tabsheet_background_part then
    InitBackground
  else if pagecontrol_mainpage.ActivePage = tabsheet_account_part then
    InitAccount
  else if pagecontrol_mainpage.ActivePage = tabsheet_resource_part then
    Initresource
  else if pagecontrol_mainpage.ActivePage = tabsheet_launch_part then
    InitLaunch
  else if pagecontrol_mainpage.ActivePage = tabsheet_download_part then
    InitDownload
  else if pagecontrol_mainpage.ActivePage = tabsheet_version_part then
    InitVersion
end;
//主界面：切换该页前
procedure Tform_mainform.pagecontrol_mainpageChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  if pagecontrol_mainpage.ActivePage = tabsheet_background_part then
    SaveBackground
  else if pagecontrol_mainpage.ActivePage = tabsheet_account_part then
    SaveAccount
  else if pagecontrol_mainpage.ActivePage = tabsheet_resource_part then
    Saveresource
  else if pagecontrol_mainpage.ActivePage = tabsheet_launch_part then
    SaveLaunch
  else if pagecontrol_mainpage.ActivePage = tabsheet_download_part then begin
    SaveDownload;
    SaveCustomDl;
  end else if pagecontrol_mainpage.ActivePage = tabsheet_version_part then
    SaveVersion;
end;
//玩法部分：玩法管理界面/下载玩法切换。
procedure Tform_mainform.pagecontrol_resource_partChange(Sender: TObject);
begin
  if pagecontrol_resource_part.ActivePage = tabsheet_resource_manage_part then begin
    if not InitManage then begin
      MyMessagebox(GetLanguage('messagebox_resource.open_manage_error.caption'), GetLanguage('messagebox_resource.open_manage_error.text'), MY_ERROR, [mybutton.myOK]);
      pagecontrol_resource_part.ActivePage := tabsheet_resource_download_part;
      exit;
    end;
  end;
end;
//版本部分：切换页
procedure Tform_mainform.pagecontrol_version_partChange(Sender: TObject);
begin
  if pagecontrol_version_part.ActivePage = tabsheet_version_isolation_part then
    InitIsolation
  else if pagecontrol_version_part.ActivePage = tabsheet_version_export_part then
    InitExport
  else if pagecontrol_version_part.ActivePage = tabsheet_version_control_part then
    SelVer;
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
//下载部分：选择下载源
procedure Tform_mainform.radiogroup_choose_download_sourceClick(
  Sender: TObject);
begin
  ChangeDlSource;
end;
//下载部分：选择模组加载器
procedure Tform_mainform.radiogroup_choose_mod_loaderClick(Sender: TObject);
begin
  ChangeModLoader;
end;
//导出部分：选择导出格式
procedure Tform_mainform.radiogroup_export_modeClick(Sender: TObject);
begin
  case radiogroup_export_mode.ItemIndex of
    0: begin
      if not mjudge_lang_chinese then begin
        MyMessagebox(GetLanguage('messagebox_export.area_not_chinese.caption'), GetLanguage('messagebox_export.area_not_chinese.text'), MY_ERROR, [mybutton.myOK]);
        radiogroup_export_mode.ItemIndex := 0;
        radiogroup_export_modeClick(Sender);
        exit;
      end;
      self.edit_export_update_link.Enabled := true;
      self.edit_export_official_website.Enabled := true;
      self.edit_export_mcbbs_tid.Enabled := true;
      self.edit_export_authentication_server.Enabled := true;
      self.edit_export_additional_game.Enabled := true;
      self.edit_export_additional_jvm.Enabled := true;
    end;
    1: begin
      self.edit_export_update_link.Enabled := false;
      self.edit_export_official_website.Enabled := false;
      self.edit_export_mcbbs_tid.Enabled := false;
      self.edit_export_authentication_server.Enabled := false;
      self.edit_export_additional_game.Enabled := false;
      self.edit_export_additional_jvm.Enabled := false;
    end;
    else exit;
  end;
end;
//版本设置：版本隔离选项卡
procedure Tform_mainform.radiogroup_partition_versionClick(Sender: TObject);
begin
  misolation_mode := radiogroup_partition_version.ItemIndex + 1;
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
//下载部分：最大线程修改
procedure Tform_mainform.scrollbar_download_biggest_threadChange(
  Sender: TObject);
begin
  mbiggest_thread := scrollbar_download_biggest_thread.Position;
  label_download_biggest_thread.Caption := GetLanguage('label_download_biggest_thread.caption').Replace('${biggest_thread}', inttostr(mbiggest_thread));
end;
//导出设置：最大内存设置
procedure Tform_mainform.scrollbar_export_max_memoryChange(Sender: TObject);
begin
  label_export_memory.Caption := GetLanguage('label_export_memory.caption').Replace('${max_memory}', inttostr(scrollbar_export_max_memory.Position));
end;
//独立设置：最大内存滑动条。
procedure Tform_mainform.scrollbar_isolation_game_memoryChange(Sender: TObject);
begin
  label_isolation_game_memory.Caption := GetLanguage('label_isolation_game_memory.caption').Replace('${current_memory}', inttostr(scrollbar_isolation_game_memory.Position));
  IsoMethod(9, inttostr(scrollbar_isolation_game_memory.Position));
end;
//独立设置：窗口高度滑动条。
procedure Tform_mainform.scrollbar_isolation_window_heightChange(
  Sender: TObject);
begin
  label_isolation_window_height.Caption := GetLanguage('label_isolation_window_height.caption').Replace('${current_height}', inttostr(scrollbar_isolation_window_height.Position));
  IsoMethod(7, inttostr(scrollbar_isolation_window_height.Position));
end;
//独立设置：窗口宽度滑动条。
procedure Tform_mainform.scrollbar_isolation_window_widthChange(
  Sender: TObject);
begin
  label_isolation_window_width.Caption := GetLanguage('label_isolation_window_width.caption').Replace('${current_width}', inttostr(scrollbar_isolation_window_width.Position));
  IsoMethod(6, inttostr(scrollbar_isolation_window_width.Position));
end;
//启动设置：游戏内存大小
procedure Tform_mainform.scrollbar_launch_max_memoryChange(Sender: TObject);
begin
  mmax_memory := scrollbar_launch_max_memory.Position;        
  label_launch_max_memory.Caption := GetLanguage('label_launch_max_memory.caption').Replace('${max_memory}', inttostr(mmax_memory));
end;
//启动设置：游戏窗口大小：高度
procedure Tform_mainform.scrollbar_launch_window_heightChange(Sender: TObject);
begin
  mwindow_height := scrollbar_launch_window_height.Position;
  label_launch_window_height.Caption := GetLanguage('label_launch_window_height.caption').Replace('${window_height}', inttostr(mwindow_height));
end;
//启动设置：游戏窗口大小：宽度
procedure Tform_mainform.scrollbar_launch_window_widthChange(Sender: TObject);
begin
  mwindow_width := scrollbar_launch_window_width.Position;      
  label_launch_window_width.Caption := GetLanguage('label_launch_window_width.caption').Replace('${window_width}', inttostr(mwindow_width));
end;     
//版本设置-导出整合包：滑动条框
procedure Tform_mainform.scrollbox_exportMouseWheel(Sender: TObject;
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
//版本设置-独立设置：滑动条框
procedure Tform_mainform.scrollbox_isolationMouseWheel(Sender: TObject;
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
//版本设置-版本控制：滑动条框
procedure Tform_mainform.scrollbox_versionMouseWheel(Sender: TObject;
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
var
  open_form: Boolean = true;
  u, l, m: Boolean;
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
    u := false;
    l := True;
    m := false;
    Log.Write('开始判断是否需要捐款。', LOG_START, LOG_INFO);
    case mopen_number of
      100, 200, 300, 500, 700, 1000, 1300, 1800, 2400, 3000: Isafdian(false, mopen_number);
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
  if mcpid > 0 then begin
    if not u then begin
      self.image_exit_running_mc.Cursor := crHandPoint;
      var find_lwjgl := FindWindow('LWJGL', nil);
      var find_sunawtframe := FindWindow('SunAwtFrame', nil);
      var find_glfw30 := FindWindow('GLFW30', nil);
      m := true;
      if (find_lwjgl <> 0) or (find_sunawtframe <> 0) or (find_glfw30 <> 0) then begin
        u := true;
        try
          Log.Write(Concat('启动游戏后，开始判定是否播放音乐。'), LOG_INFO, LOG_LAUNCH);
          var p := strtoint(LLLini.ReadString('Misc', 'SelectType', ''));
          if p = 2 then PlayMusic; //读取外部文件是否为2，如果是，则播放音乐。
        except
          Log.Write(Concat('判定失败，默认返回不播放音乐。'), LOG_ERROR, LOG_LAUNCH);
          LLLini.WriteString('Misc', 'SelectType', '3'); //如果都不是，则输出值。
        end;
        self.label_mainform_tips.Caption := GetLanguage('label_mainform_tips.caption.launch_game_success');
        var tile := LLLini.ReadString('Version', 'CustomTitle', '');
        var mcsn := strtoint(LLLini.ReadString('MC', 'SelectVer', '')) - 1;
        var mct := GetFile(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\MCSelJson.json'));
        var mcspth := (((TJsonObject.ParseJSONValue(mct) as TJsonObject).GetValue('mcsel') as TJsonArray)[mcsn] as TJsonObject).GetValue('path').Value;
        var IltIni := TIniFile.Create(Concat(mcspth, '\LLLauncher.ini'));
        Log.Write('开始判断窗口标题', LOG_INFO, LOG_LAUNCH);
        if IltIni.ReadBool('Isolation', 'IsIsolation', false) then begin
          var tite := IltIni.ReadString('Isolation', 'CustomTitle', '');
          if tite <> '' then tile := tite;
        end;
        if tile <> '' then begin
          Log.Write(Concat('判断成功！窗口标题为：', tile), LOG_INFO, LOG_LAUNCH);
          SetWindowText(find_lwjgl, tile);
          SetWindowText(find_sunawtframe, tile);
          SetWindowText(find_glfw30, tile);
        end;
//        DeleteFile(Concat(JudgeIsolation(), '\logs\latest.log'));
        if mwindow_control = 1 then self.Hide;//如果选中启动时隐藏启动器，则执行。隐藏主窗口
        if mwindow_control = 3 then Application.Terminate;
      end;
    end else begin
      if not ProcessExists(mcpid) then begin
        mcpid := -1;
      end;
    end;
  end else begin
    if l then begin
      l := false;
      image_exit_running_mc.Cursor := crNo;
      exit;
    end;
    if u or m then begin
      image_exit_running_mc.Cursor := crNo;
      if mwindow_control = 1 then self.Show; //显示主窗口
      u := false;
      m := false;
      mcpid := -1;  //以下判断后置启动脚本
      var als := LLLini.ReadString('Version', 'After-LaunchScript', '');
      if als.IsEmpty then begin
        var mcsn := LLLini.ReadInteger('MC', 'SelectVer', -1) - 1;
        var mcnt := GetFile(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher\configs\MCSelJson.json'));
        var msph := (((TJsonObject.ParseJSONValue(mcnt) as TJsonObject).GetValue('mcsel') as TJsonArray)[mcsn] as TJsonObject).GetValue('path').Value;
        var tini := TIniFile.Create(Concat(msph, '\LLLauncher.ini'));
        if tini.ReadBool('Isolation', 'IsIsolation', false) then begin
          var tls := tini.ReadString('Isolation', 'After-LaunchScript', '');
          if tls <> '' then als := tls;
        end;
      end;
      if not als.IsEmpty then
        RunDOSOnlyWait(als);
      var mcpve := JudgeIsolation;
      try
        var lat := GetDirectoryFileCount(Concat(mcpve, '\crash-reports'), '.txt');
        if lat.Count <> crash_count then begin
          var crash_log := GetFile(lat[lat.Count - 1]);
          // TODO: 写崩溃的日志。。。
          MyMessagebox(GetLanguage('messagebox_launcher.illegal_exit.caption'), GetLanguage('messagebox_launcher.illegal_exit.text'), MY_WARNING, [mybutton.myOK]);
          exit;
        end;
//        var lat := GetOutsideDocument(Concat(mcpve, '\logs\latest.log'));
//        if lat = '' then raise Exception.Create('File is No Content Exception');
        // TODO: 写崩溃的日志。。。
      except
//        messagebox(Handle, 'latest.log暂未出现。程序已经崩溃，可能是由于你强制退出，也有可能是窗口暂未出现程序就已经崩溃。', '非法退出游戏', MB_ICONWARNING);
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
//独立设置：开启/关闭游戏内存大小
procedure Tform_mainform.toggleswitch_isolation_open_memoryClick(
  Sender: TObject);
begin
  if toggleswitch_isolation_open_memory.State = tsson then begin
    scrollbar_isolation_game_memory.Enabled := true;
    IsoMethod(8, booltostr(true));
  end else begin
    scrollbar_isolation_game_memory.Enabled := false;
    IsoMethod(8, booltostr(false));
  end;
end;
//独立设置：开启/关闭单独隔离
procedure Tform_mainform.toggleswitch_isolation_open_partitionClick(
  Sender: TObject);
begin
  if toggleswitch_isolation_open_partition.State = tsson then begin
    checkbox_isolation_is_partition.Enabled := true;
    IsoMethod(10, booltostr(true));
  end else begin
    checkbox_isolation_is_partition.Enabled := false;
    IsoMethod(10, booltostr(false));
  end;
end;
//独立设置：开启/关闭窗口大小
procedure Tform_mainform.toggleswitch_isolation_window_sizeClick(
  Sender: TObject);
begin
  if toggleswitch_isolation_window_size.State = tsson then begin
    scrollbar_isolation_window_width.Enabled := true;
    scrollbar_isolation_window_height.Enabled := true;
    IsoMethod(5, booltostr(true));
  end else begin
    scrollbar_isolation_window_width.Enabled := false;
    scrollbar_isolation_window_height.Enabled := false;
    IsoMethod(5, booltostr(false));
  end;
end;
//独立设置：开启/关闭独立版本设置
procedure Tform_mainform.toggleswitch_is_open_isolationClick(Sender: TObject);
begin
  if toggleswitch_is_open_isolation.State = tsson then begin
    edit_isolation_java_path.Enabled := true;
    button_isolation_choose_java.Enabled := true;
    edit_isolation_custom_info.Enabled := true;
    edit_isolation_window_title.Enabled := true;
    toggleswitch_isolation_window_size.Enabled := true;
    scrollbar_isolation_window_width.Enabled := true;
    scrollbar_isolation_window_height.Enabled := true;
    toggleswitch_isolation_open_memory.Enabled := true;
    scrollbar_isolation_game_memory.Enabled := true;
    toggleswitch_isolation_open_partition.Enabled := true;
    checkbox_isolation_is_partition.Enabled := true;
    edit_isolation_additional_game.Enabled := true;
    edit_isolation_additional_jvm.Enabled := true;
    edit_isolation_pre_launch_script.Enabled := true;
    edit_isolation_after_launch_script.Enabled := true;
    if toggleswitch_isolation_window_size.State = tsson then begin
      scrollbar_isolation_window_width.Enabled := true;
      scrollbar_isolation_window_height.Enabled := true;
    end else begin
      scrollbar_isolation_window_width.Enabled := false;
      scrollbar_isolation_window_height.Enabled := false;
    end;
    if toggleswitch_isolation_open_memory.State = tsson then begin
      scrollbar_isolation_game_memory.Enabled := true;
    end else begin
      scrollbar_isolation_game_memory.Enabled := false;
    end;
    if toggleswitch_isolation_open_partition.State = tsson then begin
      checkbox_isolation_is_partition.Enabled := true;
    end else begin
      checkbox_isolation_is_partition.Enabled := false;
    end;
  end else begin
    edit_isolation_java_path.Enabled := false;
    button_isolation_choose_java.Enabled := false;
    edit_isolation_custom_info.Enabled := false;
    edit_isolation_window_title.Enabled := false;
    toggleswitch_isolation_window_size.Enabled := false;
    scrollbar_isolation_window_width.Enabled := false;
    scrollbar_isolation_window_height.Enabled := false;
    toggleswitch_isolation_open_memory.Enabled := false;
    scrollbar_isolation_game_memory.Enabled := false;
    toggleswitch_isolation_open_partition.Enabled := false;
    checkbox_isolation_is_partition.Enabled := false;
    edit_isolation_additional_game.Enabled := false;
    edit_isolation_additional_jvm.Enabled := false;
    edit_isolation_pre_launch_script.Enabled := false;
    edit_isolation_after_launch_script.Enabled := false;
  end;
  IsoMethod(1, booltostr(toggleswitch_is_open_isolation.State = tsson));
end;
//导出部分：文件树修改方法
procedure Tform_mainform.treeview_export_keep_fileCheckStateChanging(
  Sender: TCustomTreeView; Node: TTreeNode; NewCheckState,
  OldCheckState: TNodeCheckState; var AllowChange: Boolean);
begin
  SelectNode(Node.Checked, Node);
end;
//主界面：重置启动器菜单栏方法
procedure Tform_mainform.n_reset_launcherClick(Sender: TObject);
begin
  if MyMessagebox(GetLanguage('messagebox_mainform.is_reset_launcher.caption'), GetLanguage('messagebox_mainform.is_reset_launcher.text'), MY_WARNING, [mybutton.myNo, mybutton.myYes]) = 1 then exit;
  DeleteDirectory(Concat(ExtractFileDir(Application.ExeName), '\LLLauncher'));
  Application.Terminate;
end;
//主界面：赞助作者菜单栏
procedure Tform_mainform.n_support_authorClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, nil, 'https://afdian.net/a/Rechalow', nil, nil, SW_SHOWNORMAL);
end;
//主界面：赞助BMCLAPI菜单栏
procedure Tform_mainform.n_support_bmclapiClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, nil, 'https://bmclapidoc.bangbang93.com', nil, nil, SW_SHOWNORMAL);
end;

end.
