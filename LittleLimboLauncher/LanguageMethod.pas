unit LanguageMethod;

interface

uses
  SysUtils, Classes, Forms, JSON, Dialogs, Generics.Collections;

procedure InitLanguage();
procedure SetLanguage(lang: Integer);
function GetLanguage(key: String): String;

var
  alllangjson: TList<TJSONObject>;

implementation

uses
  MainMethod, MainForm;

var
  langjson: TJSONObject;
//设置语言
procedure SetLanguage(lang: Integer);
begin
  if lang < 0 then lang := 0;
  langjson := alllangjson[lang].Clone as TJSONObject;
  //以下为页
  form_mainform.tabsheet_mainpage_part.Caption := GetLanguage('tabsheet_mainpage_part.caption');   
  form_mainform.tabsheet_account_part.Caption := GetLanguage('tabsheet_account_part.caption');
  form_mainform.tabsheet_resource_part.Caption := GetLanguage('tabsheet_resource_part.caption');
  form_mainform.tabsheet_download_part.Caption := GetLanguage('tabsheet_download_part.caption');
  form_mainform.tabsheet_online_part.Caption := GetLanguage('tabsheet_online_part.caption');
  form_mainform.tabsheet_background_part.Caption := GetLanguage('tabsheet_background_part.caption');
  form_mainform.tabsheet_launch_part.Caption := GetLanguage('tabsheet_launch_part.caption');
  form_mainform.tabsheet_version_part.Caption := GetLanguage('tabsheet_version_part.caption');
  form_mainform.tabsheet_account_offline_part.Caption := GetLanguage('tabsheet_account_offline_part.caption');
  form_mainform.tabsheet_account_microsoft_part.Caption := GetLanguage('tabsheet_account_microsoft_part.caption');
  form_mainform.tabsheet_account_thirdparty_part.Caption := GetLanguage('tabsheet_account_thirdparty_part.caption');
  form_mainform.tabsheet_resource_download_part.Caption := GetLanguage('tabsheet_resource_download_part.caption');
  form_mainform.tabsheet_resource_manage_part.Caption := GetLanguage('tabsheet_resource_manage_part.caption');
  form_mainform.tabsheet_download_minecraft_part.Caption := GetLanguage('tabsheet_download_minecraft_part.caption');
  form_mainform.tabsheet_download_custom_part.Caption := GetLanguage('tabsheet_download_custom_part.caption');
  form_mainform.tabsheet_download_modloader_part.Caption := GetLanguage('tabsheet_download_modloader_part.caption');
  form_mainform.tabsheet_online_ipv6_part.Caption := GetLanguage('tabsheet_online_ipv6_part.caption');
  form_mainform.tabsheet_online_octo_part.Caption := GetLanguage('tabsheet_online_octo_part.caption');
  form_mainform.tabsheet_version_control_part.Caption := GetLanguage('tabsheet_version_control_part.caption');
  form_mainform.tabsheet_version_isolation_part.Caption := GetLanguage('tabsheet_version_isolation_part.caption');            
  form_mainform.tabsheet_version_export_part.Caption := GetLanguage('tabsheet_version_export_part.caption');   
  //以下为菜单栏              
  form_mainform.n_misc.Caption := GetLanguage('menu_misc.caption');                
  form_mainform.n_answer_book.Caption := GetLanguage('menu_misc_answer.caption');
  form_mainform.n_intro_self.Caption := GetLanguage('menu_misc_intro.caption');                
  form_mainform.n_lucky_today.Caption := GetLanguage('menu_misc_lucky.caption');                
  form_mainform.n_puzzle_game.Caption := GetLanguage('menu_misc_puzzle.caption');                
  form_mainform.n_official.Caption := GetLanguage('menu_official.caption');                
  form_mainform.n_entry_official_website.Caption := GetLanguage('menu_official_entry.caption');                
  form_mainform.n_support_author.Caption := GetLanguage('menu_official_support.caption');                
  form_mainform.n_support_bmclapi.Caption := GetLanguage('menu_official_bmclapi.caption');                
  form_mainform.n_manual.Caption := GetLanguage('menu_manual.caption');                
  form_mainform.n_reset_launcher.Caption := GetLanguage('menu_manual_reset.caption');                
  form_mainform.n_export_argument.Caption := GetLanguage('menu_manual_export.caption');                
  form_mainform.n_current_version.Caption := GetLanguage('menu_manual_version.caption');                
  form_mainform.n_check_update.Caption := GetLanguage('menu_manual_update.caption');
  form_mainform.n_memory_optimize.Caption := GetLanguage('menu_manual_optimize.caption');
  form_mainform.n_test_button.Caption := GetLanguage('menu_manual_test.caption');
  form_mainform.n_languages.Caption := GetLanguage('menu_manual_language.caption');
  form_mainform.n_plugins.Caption := GetLanguage('menu_manual_plugin.caption');
  form_mainform.n_view_mod_profile.Caption := GetLanguage('menu_view_mod_profile.caption');
  form_mainform.n_view_mod_website.Caption := GetLanguage('menu_view_mod_website.caption');
  form_mainform.n_view_minecraft_info.Caption := GetLanguage('menu_view_minecraft_info.caption');
  form_mainform.n_view_mod_info.Caption := GetLanguage('menu_view_mod_info.caption');
  //以下为下载进度窗口
  form_mainform.button_progress_hide_show_details.Caption := GetLanguage('button_progress_hide_show_details.caption.hide');
  form_mainform.button_progress_clean_download_list.Caption := GetLanguage('button_progress_clean_download_list.caption');
  form_mainform.label_progress_tips.Caption := GetLanguage('label_progress_tips.caption');
  //以下为主界面
  form_mainform.groupbox_message_board.Caption := GetLanguage('groupbox_message_board.caption');
  form_mainform.button_launch_game.hint := GetLanguage('button_launch_game.hint');
  form_mainform.image_refresh_background_image.hint := GetLanguage('image_refresh_background_image.hint');     
  form_mainform.image_refresh_background_music.hint := GetLanguage('image_refresh_background_music.hint');
  form_mainform.image_open_download_prograss.hint := GetLanguage('image_open_download_prograss.hint');
  form_mainform.image_exit_running_mc.hint := GetLanguage('image_exit_running_mc.hint');     
  //以下为背景设置         
  form_mainform.label_background_tip.caption := GetLanguage('label_background_tip.caption');   
  form_mainform.label_standard_color.caption := GetLanguage('label_standard_color.caption');   
  form_mainform.button_grass_color.caption := GetLanguage('button_grass_color.caption');   
  form_mainform.button_sun_color.caption := GetLanguage('button_sun_color.caption');   
  form_mainform.button_sultan_color.caption := GetLanguage('button_sultan_color.caption');   
  form_mainform.button_sky_color.caption := GetLanguage('button_sky_color.caption');   
  form_mainform.button_cute_color.caption := GetLanguage('button_cute_color.caption');   
  form_mainform.button_normal_color.caption := GetLanguage('button_normal_color.caption');   
  form_mainform.button_custom_color.caption := GetLanguage('button_custom_color.caption');
  form_mainform.label_background_window_alpha.caption := GetLanguage('label_background_window_alpha.caption');  
  form_mainform.label_background_control_alpha.caption := GetLanguage('label_background_control_alpha.caption');  
  form_mainform.groupbox_background_music_setting.caption := GetLanguage('groupbox_background_music_setting.caption');  
  form_mainform.button_background_play_music.caption := GetLanguage('button_background_play_music.caption');  
  form_mainform.button_background_play_music.hint := GetLanguage('button_background_play_music.hint');  
  form_mainform.button_background_pause_music.caption := GetLanguage('button_background_pause_music.caption');  
  form_mainform.button_background_pause_music.hint := GetLanguage('button_background_pause_music.hint');  
  form_mainform.button_background_stop_music.caption := GetLanguage('button_background_stop_music.caption');    
  form_mainform.button_background_stop_music.hint := GetLanguage('button_background_stop_music.hint');       
  form_mainform.radiobutton_background_music_open.caption := GetLanguage('radiobutton_background_music_open.caption');
  form_mainform.radiobutton_background_music_launch.caption := GetLanguage('radiobutton_background_music_launch.caption'); 
  form_mainform.radiobutton_background_music_not.caption := GetLanguage('radiobutton_background_music_not.caption'); 
  form_mainform.groupbox_background_launch_setting.caption := GetLanguage('groupbox_background_launch_setting.caption'); 
  form_mainform.radiobutton_background_launch_hide.caption := GetLanguage('radiobutton_background_launch_hide.caption'); 
  form_mainform.radiobutton_background_launch_show.caption := GetLanguage('radiobutton_background_launch_show.caption'); 
  form_mainform.radiobutton_background_launch_exit.caption := GetLanguage('radiobutton_background_launch_exit.caption'); 
  form_mainform.label_background_mainform_title.caption := GetLanguage('label_background_mainform_title.caption'); 
  form_mainform.groupbox_background_gradient.caption := GetLanguage('groupbox_background_gradient.caption'); 
  form_mainform.toggleswitch_background_gradient.StateCaptions.CaptionOn := GetLanguage('toggleswitch_background_gradient.on.caption');
  form_mainform.toggleswitch_background_gradient.StateCaptions.CaptionOff := GetLanguage('toggleswitch_background_gradient.off.caption'); 
  form_mainform.label_background_gradient_value.caption := GetLanguage('label_background_gradient_value.caption'); 
  form_mainform.label_background_gradient_step.caption := GetLanguage('label_background_gradient_step.caption');
  //以下为账号部分
  form_mainform.label_login_avatar.Caption := GetLanguage('label_login_avatar.caption');
  form_mainform.label_all_account.Caption := GetLanguage('label_all_account.caption');
  form_mainform.groupbox_offline_skin.Caption := GetLanguage('groupbox_offline_skin.caption');
  form_mainform.label_offline_name.Caption := GetLanguage('label_offline_name.caption');
  form_mainform.edit_offline_name.TextHint := GetLanguage('edit_offline_name.texthint');
  form_mainform.label_offline_uuid.Caption := GetLanguage('label_offline_uuid.caption');
  form_mainform.edit_offline_uuid.TextHint := GetLanguage('edit_offline_uuid.texthint');
  form_mainform.button_microsoft_oauth_login.Caption := GetLanguage('button_microsoft_oauth_login.caption');
  form_mainform.label_thirdparty_server.Caption := GetLanguage('label_thirdparty_server.caption');
  form_mainform.label_thirdparty_account.Caption := GetLanguage('label_thirdparty_account.caption');
  form_mainform.label_thirdparty_password.Caption := GetLanguage('label_thirdparty_password.caption');
  form_mainform.button_thirdparty_check_authlib_update.caption := GetLanguage('button_thirdparty_check_authlib_update.caption');
  form_mainform.button_offline_name_to_uuid.Caption := GetLanguage('button_offline_name_to_uuid.caption');
  form_mainform.button_offline_uuid_to_name.Caption := GetLanguage('button_offline_uuid_to_name.caption');
  form_mainform.button_add_account.Caption := GetLanguage('button_add_account.caption');
  form_mainform.button_delete_account.caption := GetLanguage('button_delete_account.caption');
  form_mainform.button_refresh_account.Caption := GetLanguage('button_refresh_account.caption');
  form_mainform.button_account_get_uuid.Caption := GetLanguage('button_account_get_uuid.caption');
  //以下是资源部分
  form_mainform.label_resource_tip.Caption := GetLanguage('label_resource_tip.caption');
  form_mainform.label_resource_search_name_tip.Caption := GetLanguage('label_resource_search_name_tip.caption');
  form_mainform.label_resource_search_version_tip.Caption := GetLanguage('label_resource_search_version_tip.caption');
  form_mainform.label_resource_search_category_modrinth_tip.Caption := GetLanguage('label_resource_search_category_modrinth_tip.caption');
  form_mainform.label_resource_search_category_curseforge_tip.Caption := GetLanguage('label_resource_search_category_curseforge_tip.caption');
  form_mainform.label_resource_search_mode_tip.Caption := GetLanguage('label_resource_search_mode_tip.caption');
  form_mainform.label_resource_search_source_tip.Caption := GetLanguage('label_resource_search_source_tip.caption');
  form_mainform.button_resource_name_previous_page.Caption := GetLanguage('button_resource_name_previous_page.caption');
  form_mainform.button_resource_version_previous_page.Caption := GetLanguage('button_resource_version_previous_page.caption');
  form_mainform.button_resource_name_next_page.Caption := GetLanguage('button_resource_name_next_page.caption');
  form_mainform.button_resource_version_next_page.Caption := GetLanguage('button_resource_version_next_page.caption');
  form_mainform.button_open_download_website.Caption := GetLanguage('button_open_download_website.caption');
  form_mainform.button_resource_start_download.Caption := GetLanguage('button_resource_start_download.caption');
  form_mainform.button_resource_start_search.Caption := GetLanguage('button_resource_start_search.caption');
  form_mainform.edit_resource_search_name.TextHint := GetLanguage('edit_resource_search_name.texthint');
  //以下是资源管理界面
  form_mainform.label_manage_import_modpack.Caption := GetLanguage('label_manage_import_modpack.caption');
  form_mainform.label_manage_import_mod.Caption := GetLanguage('label_manage_import_mod.caption');
  form_mainform.label_manage_import_map.Caption := GetLanguage('label_manage_import_map.caption');
  form_mainform.label_manage_import_resourcepack.Caption := GetLanguage('label_manage_import_resourcepack.caption');
  form_mainform.label_manage_import_shader.Caption := GetLanguage('label_manage_import_shader.caption');
  form_mainform.label_manage_import_datapack.Caption := GetLanguage('label_manage_import_datapack.caption');
  form_mainform.label_manage_import_plugin.Caption := GetLanguage('label_manage_import_plugin.caption');
  form_mainform.listbox_manage_import_modpack.Hint := GetLanguage('listbox_manage_import_modpack.hint');
  form_mainform.listbox_manage_import_mod.Hint := GetLanguage('listbox_manage_import_modpack.hint');
  form_mainform.listbox_manage_import_map.Hint := GetLanguage('listbox_manage_import_map.hint');
  form_mainform.listbox_manage_import_resourcepack.Hint := GetLanguage('listbox_manage_import_resourcepack.hint');
  form_mainform.listbox_manage_import_shader.Hint := GetLanguage('listbox_manage_import_shader.hint');
  form_mainform.listbox_manage_import_datapack.Hint := GetLanguage('listbox_manage_import_datapack.hint');
  form_mainform.listbox_manage_import_plugin.Hint := GetLanguage('listbox_manage_import_plugin.hint');
  form_mainform.button_disable_choose_resource.Caption := GetLanguage('button_disable_choose_resource.caption');
  form_mainform.button_enable_choose_resource.Caption := GetLanguage('button_enable_choose_resource.caption');
  form_mainform.button_delete_choose_resource.Caption := GetLanguage('button_delete_choose_resource.caption');
  form_mainform.button_rename_choose_resource.Caption := GetLanguage('button_rename_choose_resource.caption');
  form_mainform.button_open_choose_resource.Caption := GetLanguage('button_open_choose_resource.caption');
  form_mainform.button_disable_choose_resource.Hint := GetLanguage('button_disable_choose_resource.hint');
  form_mainform.button_enable_choose_resource.Hint := GetLanguage('button_enable_choose_resource.hint');
  form_mainform.button_delete_choose_resource.Hint := GetLanguage('button_delete_choose_resource.hint');
  form_mainform.button_rename_choose_resource.Hint := GetLanguage('button_rename_choose_resource.hint');
  form_mainform.button_open_choose_resource.Hint := GetLanguage('button_open_choose_resource.hint');
  //以下是启动设置界面
  form_mainform.label_launch_window_size.Caption := GetLanguage('label_launch_window_size.caption');
  form_mainform.label_launch_java_path.Caption := GetLanguage('label_launch_java_path.caption');
  form_mainform.label_launch_java_logic.Caption := GetLanguage('label_launch_java_logic.caption');
  form_mainform.button_launch_full_scan_java.Caption := GetLanguage('button_launch_full_scan_java.caption');
  form_mainform.button_launch_basic_scan_java.Caption := GetLanguage('button_launch_basic_scan_java.caption');
  form_mainform.button_launch_manual_import.Caption := GetLanguage('button_launch_manual_import.caption');
  form_mainform.button_launch_remove_java.Caption := GetLanguage('button_launch_remove_java.caption');
  form_mainform.label_launch_download_java.Caption := GetLanguage('label_launch_download_java.caption');
  form_mainform.button_launch_download_java_8.Caption := GetLanguage('button_launch_download_java_8.caption');
  form_mainform.button_launch_download_java_17.Caption := GetLanguage('button_launch_download_java_17.caption');
  form_mainform.button_launch_download_java_21.Caption := GetLanguage('button_launch_download_java_21.caption');
  form_mainform.button_launch_official_java.Caption := GetLanguage('button_launch_official_java.caption');
  form_mainform.label_launch_custom_info.Caption := GetLanguage('label_launch_custom_info.caption');
  form_mainform.edit_launch_custom_info.TextHint := GetLanguage('edit_launch_custom_info.texthint');
  form_mainform.label_launch_window_title.Caption := GetLanguage('label_launch_window_title.caption');
  form_mainform.edit_launch_window_title.TextHint := GetLanguage('edit_launch_window_title.texthint');
  form_mainform.label_launch_pre_launch_script.Caption := GetLanguage('label_launch_pre_launch_script.caption');
  form_mainform.edit_launch_pre_launch_script.TextHint := GetLanguage('edit_launch_pre_launch_script.texthint');
  form_mainform.button_launch_pre_launch_script.Caption := GetLanguage('button_launch_pre_launch_script.caption');
  form_mainform.label_launch_after_launch_script.Caption := GetLanguage('label_launch_after_launch_script.caption');
  form_mainform.edit_launch_after_launch_script.TextHint := GetLanguage('edit_launch_after_launch_script.texthint');
  form_mainform.button_launch_after_launch_script.Caption := GetLanguage('button_launch_after_launch_script.caption');
  form_mainform.label_launch_default_jvm.Caption := GetLanguage('label_launch_default_jvm.caption');
  form_mainform.button_launch_default_jvm.Caption := GetLanguage('button_launch_default_jvm.caption');
  form_mainform.label_launch_additional_jvm.Caption := GetLanguage('label_launch_additional_jvm.caption');
  form_mainform.edit_launch_additional_jvm.TextHint := GetLanguage('edit_launch_additional_jvm.texthint');
  form_mainform.button_launch_additional_jvm.Caption := GetLanguage('button_launch_additional_jvm.caption');
  form_mainform.label_launch_additional_game.Caption := GetLanguage('label_launch_additional_game.caption');
  form_mainform.edit_launch_additional_game.TextHint := GetLanguage('edit_launch_additional_game.texthint');
  form_mainform.button_launch_additional_game.Caption := GetLanguage('button_launch_additional_game.caption');
  //以下是下载Minecraft部分
  form_mainform.label_download_tip.Caption := GetLanguage('label_download_tip.caption');
  form_mainform.label_choose_view_mode.Caption := GetLanguage('label_choose_view_mode.caption');
  form_mainform.label_select_minecraft.Caption := GetLanguage('label_select_minecraft.caption');
  form_mainform.label_select_modloader.Caption := GetLanguage('label_select_modloader.caption');
  form_mainform.checklistbox_choose_view_mode.Items[0] := GetLanguage('checklistbox_choose_view_mode.release.caption');
  form_mainform.checklistbox_choose_view_mode.Items[1] := GetLanguage('checklistbox_choose_view_mode.snapshot.caption');
  form_mainform.checklistbox_choose_view_mode.Items[2] := GetLanguage('checklistbox_choose_view_mode.beta.caption');
  form_mainform.checklistbox_choose_view_mode.Items[3] := GetLanguage('checklistbox_choose_view_mode.alpha.caption');
  form_mainform.checklistbox_choose_view_mode.Items[4] := GetLanguage('checklistbox_choose_view_mode.special.caption');
  form_mainform.radiogroup_choose_download_source.Caption := GetLanguage('radiogroup_choose_download_source.caption');
  form_mainform.radiogroup_choose_download_source.Items[0] := GetLanguage('radiogroup_choose_download_source.official.caption');
  form_mainform.radiogroup_choose_download_source.Items[1] := GetLanguage('radiogroup_choose_download_source.bmclapi.caption');
  form_mainform.radiogroup_choose_mod_loader.Caption := GetLanguage('radiogroup_choose_mod_loader.caption');
  form_mainform.radiogroup_choose_mod_loader.Items[0] := GetLanguage('radiogroup_choose_mod_loader.forge.caption');
  form_mainform.radiogroup_choose_mod_loader.Items[1] := GetLanguage('radiogroup_choose_mod_loader.fabric.caption');
  form_mainform.radiogroup_choose_mod_loader.Items[2] := GetLanguage('radiogroup_choose_mod_loader.quilt.caption');
  form_mainform.radiogroup_choose_mod_loader.Items[3] := GetLanguage('radiogroup_choose_mod_loader.neoforge.caption');
  form_mainform.button_reset_download_part.Caption := GetLanguage('button_reset_download_part.caption');
  form_mainform.button_load_modloader.Caption := GetLanguage('button_load_modloader.caption');
  form_mainform.label_minecraft_version_name.Caption := GetLanguage('label_minecraft_version_name.caption');
  form_mainform.edit_minecraft_version_name.TextHint := GetLanguage('edit_minecraft_version_name.texthint');
  form_mainform.button_download_start_download_minecraft.Caption := GetLanguage('button_download_start_download_minecraft.caption');
  //以下是自定义下载部分
  form_mainform.label_custom_download_url.Caption := GetLanguage('label_custom_download_url.caption');
  form_mainform.edit_custom_download_url.TextHint := GetLanguage('edit_custom_download_url.texthint');
  form_mainform.label_custom_download_name.Caption := GetLanguage('label_custom_download_name.caption');
  form_mainform.edit_custom_download_name.TextHint := GetLanguage('edit_custom_download_name.texthint');
  form_mainform.label_custom_download_sha1.Caption := GetLanguage('label_custom_download_sha1.caption');
  form_mainform.edit_custom_download_sha1.TextHint := GetLanguage('edit_custom_download_sha1.texthint');
  form_mainform.label_custom_download_path.Caption := GetLanguage('label_custom_download_path.caption');
  form_mainform.edit_custom_download_path.TextHint := GetLanguage('edit_custom_download_path.texthint');
  form_mainform.button_custom_download_choose_path.Caption := GetLanguage('button_custom_download_choose_path.caption');
  form_mainform.button_custom_download_open_path.Caption := GetLanguage('button_custom_download_open_path.caption');
  form_mainform.button_custom_download_start.Caption := GetLanguage('button_custom_download_start.caption');
  //以下是模组加载器手动安装包
  form_mainform.label_download_modloader_forge.Caption := GetLanguage('label_download_modloader_forge.caption');
  form_mainform.label_download_modloader_fabric.Caption := GetLanguage('label_download_modloader_fabric.caption');
  form_mainform.label_download_modloader_quilt.Caption := GetLanguage('label_download_modloader_quilt.caption');
  form_mainform.label_download_modloader_neoforge.Caption := GetLanguage('label_download_modloader_neoforge.caption');
  form_mainform.button_download_modloader_download.Caption := GetLanguage('button_download_modloader_download.caption');
  form_mainform.button_download_modloader_refresh.Caption := GetLanguage('button_download_modloader_refresh.caption');
  //以下是版本设置部分
  form_mainform.label_select_game_version.Caption := GetLanguage('label_select_game_version.caption');
  form_mainform.label_select_file_list.Caption := GetLanguage('label_select_file_list.caption');
  form_mainform.label_version_add_mc_path.Caption := GetLanguage('label_version_add_mc_path.caption');
  form_mainform.button_version_choose_any_directory.Caption := GetLanguage('button_version_choose_any_directory.caption');
  form_mainform.button_game_resource.Caption := GetLanguage('button_game_resource.caption');
  form_mainform.radiogroup_partition_version.Caption := GetLanguage('radiogroup_partition_version.caption');
  form_mainform.radiogroup_partition_version.Items[0] := GetLanguage('radiogroup_partition_version.not_isolation.caption');
  form_mainform.radiogroup_partition_version.Items[1] := GetLanguage('radiogroup_partition_version.isolate_version.caption');
  form_mainform.radiogroup_partition_version.Items[2] := GetLanguage('radiogroup_partition_version.isolate_modloader.caption');
  form_mainform.radiogroup_partition_version.Items[3] := GetLanguage('radiogroup_partition_version.isolate_all.caption');
  form_mainform.button_version_complete.Caption := GetLanguage('button_version_complete.caption');
  form_mainform.button_rename_version_list.Caption := GetLanguage('button_rename_version_list.caption');
  form_mainform.button_remove_version_list.Caption := GetLanguage('button_remove_version_list.caption');
  form_mainform.button_rename_game_version.Caption := GetLanguage('button_rename_game_version.caption');
  form_mainform.button_delete_game_version.Caption := GetLanguage('button_delete_game_version.caption');
  form_mainform.label_version_tip.Caption := GetLanguage('label_version_tip.caption');
  //以下是独立设置部分
  form_mainform.toggleswitch_is_open_isolation.StateCaptions.CaptionOn := GetLanguage('toggleswitch_is_open_isolation.on.caption');
  form_mainform.toggleswitch_is_open_isolation.StateCaptions.CaptionOff := GetLanguage('toggleswitch_is_open_isolation.off.caption');
  form_mainform.label_isolation_java_path.Caption := GetLanguage('label_isolation_java_path.caption');
  form_mainform.edit_isolation_java_path.TextHint := GetLanguage('edit_isolation_java_path.texthint');
  form_mainform.button_isolation_choose_java.Caption := GetLanguage('button_isolation_choose_java.caption');
  form_mainform.label_isolation_custom_info.Caption := GetLanguage('label_isolation_custom_info.caption');
  form_mainform.edit_isolation_custom_info.TextHint := GetLanguage('edit_isolation_custom_info.texthint');
  form_mainform.label_isolation_window_title.Caption := GetLanguage('label_isolation_window_title.caption');
  form_mainform.edit_isolation_window_title.TextHint := GetLanguage('edit_isolation_window_title.texthint');
  form_mainform.label_isolation_window_size.Caption := GetLanguage('label_isolation_window_size.caption');
  form_mainform.toggleswitch_isolation_window_size.StateCaptions.CaptionOn := GetLanguage('toggleswitch_isolation_window_size.on.caption');
  form_mainform.toggleswitch_isolation_window_size.StateCaptions.CaptionOff := GetLanguage('toggleswitch_isolation_window_size.off.caption');
  form_mainform.toggleswitch_isolation_open_memory.StateCaptions.CaptionOn := GetLanguage('toggleswitch_isolation_open_memory.on.caption');
  form_mainform.toggleswitch_isolation_open_memory.StateCaptions.CaptionOff := GetLanguage('toggleswitch_isolation_open_memory.off.caption');
  form_mainform.label_isolation_partition.Caption := GetLanguage('label_isolation_partition.caption');
  form_mainform.toggleswitch_isolation_open_partition.StateCaptions.CaptionOn := GetLanguage('toggleswitch_isolation_open_partition.on.caption');
  form_mainform.toggleswitch_isolation_open_partition.StateCaptions.CaptionOff := GetLanguage('toggleswitch_isolation_open_partition.off.caption');
  form_mainform.checkbox_isolation_is_partition.Caption := GetLanguage('checkbox_isolation_is_partition.caption');
  form_mainform.label_isolation_additional_game.Caption := GetLanguage('label_isolation_additional_game.caption');
  form_mainform.edit_isolation_additional_game.TextHint := GetLanguage('edit_isolation_additional_game.texthint');
  form_mainform.label_isolation_additional_jvm.Caption := GetLanguage('label_isolation_additional_jvm.caption');
  form_mainform.edit_isolation_additional_jvm.TextHint := GetLanguage('edit_isolation_additional_jvm.texthint');
  form_mainform.label_isolation_pre_launch_script.Caption := GetLanguage('label_isolation_pre_launch_script.caption');
  form_mainform.edit_isolation_pre_launch_script.TextHint := GetLanguage('edit_isolation_pre_launch_script.texthint');
  form_mainform.label_isolation_after_launch_script.Caption := GetLanguage('label_isolation_after_launch_script.caption');
  form_mainform.edit_isolation_after_launch_script.TextHint := GetLanguage('edit_isolation_after_launch_script.texthint');
  form_mainform.label_isolation_tip.Caption := GetLanguage('label_isolation_tip.caption');
  //以下是导出部分的！
  form_mainform.radiogroup_export_mode.Caption := GetLanguage('radiogroup_export_mode.caption');
  form_mainform.label_export_mode_more.Caption := GetLanguage('label_export_mode_more.caption');
  form_mainform.label_export_modpack_name.Caption := GetLanguage('label_export_modpack_name.caption');
  form_mainform.edit_export_modpack_name.TextHint := GetLanguage('edit_export_modpack_name.texthint');
  form_mainform.label_export_modpack_author.Caption := GetLanguage('label_export_modpack_author.caption');
  form_mainform.edit_export_modpack_author.TextHint := GetLanguage('edit_export_modpack_author.texthint');
  form_mainform.label_export_modpack_version.Caption := GetLanguage('label_export_modpack_version.caption');
  form_mainform.edit_export_modpack_version.TextHint := GetLanguage('edit_export_modpack_version.texthint');
  form_mainform.label_export_update_link.Caption := GetLanguage('label_export_update_link.caption');
  form_mainform.edit_export_update_link.TextHint := GetLanguage('edit_export_update_link.texthint');
  form_mainform.edit_export_update_link.Hint := GetLanguage('edit_export_update_link.hint');
  form_mainform.label_export_official_website.Caption := GetLanguage('label_export_official_website.caption');
  form_mainform.edit_export_official_website.TextHint := GetLanguage('edit_export_official_website.texthint');
  form_mainform.edit_export_official_website.Hint := GetLanguage('edit_export_official_website.hint');
  form_mainform.label_export_authentication_server.Caption := GetLanguage('label_export_authentication_server.caption');
  form_mainform.edit_export_authentication_server.TextHint := GetLanguage('edit_export_authentication_server.texthint');
  form_mainform.edit_export_authentication_server.Hint := GetLanguage('edit_export_authentication_server.hint');
  form_mainform.label_export_additional_game.Caption := GetLanguage('label_export_additional_game.caption');
  form_mainform.edit_export_additional_game.TextHint := GetLanguage('edit_export_additional_game.texthint');
  form_mainform.edit_export_additional_game.Hint := GetLanguage('edit_export_additional_game.hint');
  form_mainform.label_export_additional_jvm.Caption := GetLanguage('label_export_additional_jvm.caption');
  form_mainform.edit_export_additional_jvm.TextHint := GetLanguage('edit_export_additional_jvm.texthint');
  form_mainform.edit_export_additional_jvm.Hint := GetLanguage('edit_export_additional_jvm.hint');
  form_mainform.label_export_modpack_profile.Caption := GetLanguage('label_export_modpack_profile.caption');
  form_mainform.label_export_keep_file.Caption := GetLanguage('label_export_keep_file.caption');
  form_mainform.button_export_start.Caption := GetLanguage('button_export_start.caption');
  form_mainform.button_export_add_icon.Caption := GetLanguage('button_export_add_icon.caption');
  form_mainform.label_export_add_icon.Caption := GetLanguage('label_export_add_icon.caption');
  //以下是IPv6联机部分
  form_mainform.button_check_ipv6_ip.Caption := GetLanguage('button_check_ipv6_ip.caption');
  form_mainform.label_online_ipv6_port.Caption := GetLanguage('label_online_ipv6_port.caption');
  form_mainform.button_copy_ipv6_ip_and_port.Caption := GetLanguage('button_copy_ipv6_ip_and_port.caption');
  form_mainform.button_online_ipv6_tip.Caption := GetLanguage('button_online_ipv6_tip.caption');
  form_mainform.label_online_ipv6_return_value.Caption := GetLanguage('label_online_ipv6_return_value.caption.current_ipv6_ip').Replace('${ip}', '');
  form_mainform.label_online_tip.Caption := GetLanguage('label_online_tip.caption');
  //插件部分
  form_mainform.tabsheet_plugin_part.Caption := GetLanguage('tabsheet_plugin_part.caption');
  //帮助界面
  form_mainform.tabsheet_help_part.Caption := GetLanguage('tabsheet_help_part.caption');
end;
//初始化语言
procedure InitLanguage();
begin
  alllangjson := TList<TJSONObject>.Create;
  var zhcnjson := TJSONObject.Create
    .AddPair('file_language_title', '中文（简体）')
    //以下为页
    .AddPair('tabsheet_mainpage_part.caption', '主界面')
    .AddPair('tabsheet_account_part.caption', '账号部分')
    .AddPair('tabsheet_resource_part.caption', '资源部分')
    .AddPair('tabsheet_download_part.caption', '下载部分')
    .AddPair('tabsheet_online_part.caption', '联机部分')
    .AddPair('tabsheet_background_part.caption', '背景设置')
    .AddPair('tabsheet_launch_part.caption', '启动设置')
    .AddPair('tabsheet_version_part.caption', '版本部分')
    .AddPair('tabsheet_account_offline_part.caption', '离线登录')
    .AddPair('tabsheet_account_microsoft_part.caption', '微软登录')
    .AddPair('tabsheet_account_thirdparty_part.caption', '外置登录')
    .AddPair('tabsheet_resource_download_part.caption', '下载资源')
    .AddPair('tabsheet_resource_manage_part.caption', '资源管理界面')
    .AddPair('tabsheet_download_minecraft_part.caption', '下载Minecraft')
    .AddPair('tabsheet_download_custom_part.caption', '下载自定义文件')
    .AddPair('tabsheet_download_modloader_part.caption', '下载模组加载器手动安装包')
    .AddPair('tabsheet_online_ipv6_part.caption', 'IPv6联机')
    .AddPair('tabsheet_online_octo_part.caption', 'Octo联机')
    .AddPair('tabsheet_version_control_part.caption', '版本控制')
    .AddPair('tabsheet_version_isolation_part.caption', '独立设置')
    .AddPair('tabsheet_version_export_part.caption', '导出整合包')
    .AddPair('tabsheet_plugin_part.caption', '插件部分')
    .AddPair('tabsheet_help_part.caption', '帮助界面')
    //以下为菜单栏
    .AddPair('menu_misc.caption', '杂项')
    .AddPair('menu_misc_answer.caption', '答案之书')
    .AddPair('menu_misc_intro.caption', '自我介绍')
    .AddPair('menu_misc_lucky.caption', '今日人品')
    .AddPair('menu_misc_puzzle.caption', '解谜游戏')      
    .AddPair('menu_official.caption', '官网')
    .AddPair('menu_official_entry.caption', '进入官网')
    .AddPair('menu_official_support.caption', '赞助作者')
    .AddPair('menu_official_bmclapi.caption', '赞助BMCLAPI')
    .AddPair('menu_manual.caption', '更多')
    .AddPair('menu_manual_reset.caption', '重置启动器')
    .AddPair('menu_manual_export.caption', '手动导出启动参数')
    .AddPair('menu_manual_version.caption', '当前版本')
    .AddPair('menu_manual_update.caption', '检查更新')
    .AddPair('menu_manual_optimize.caption', '内存清理')
    .AddPair('menu_manual_test.caption', '测试按钮')
    .AddPair('menu_manual_language.caption', '语言')
    .AddPair('menu_manual_plugin.caption', 'DLL插件')
    .AddPair('menu_view_mod_profile.caption', '打开该模组的简介')
    .AddPair('menu_view_mod_website.caption', '打开该模组的官网')
    .AddPair('menu_view_minecraft_info.caption', '查看Minecraft版本信息')
    .AddPair('menu_view_mod_info.caption', '查看模组信息')
    //以下为信息框
    .AddPair('messagebox_button_yes.caption', '是')
    .AddPair('messagebox_button_ok.caption', '确认')
    .AddPair('messagebox_button_no.caption', '否')
    .AddPair('messagebox_button_cancel.caption', '取消')
    .AddPair('messagebox_button_retry.caption', '重试')
    .AddPair('messagebox_button_abort.caption', '终止')
    .AddPair('messagebox_button_ignore.caption', '忽略')
    .AddPair('inputbox_button_yes.caption', '确认')
    .AddPair('inputbox_button_no.caption', '取消')
    .AddPair('picturebox_button_ok.caption', '确认')
    .AddPair('messagebox_launcher.exit_mc_success.caption', '结束MC运行成功！')
    .AddPair('messagebox_launcher.exit_mc_success.text', '结束MC的运行成功了！但是假如你的游戏是刚刚开始运行的话，有可能会结束不成功。请见谅！')
    .AddPair('messagebox_launcher.illegal_exit.caption', '非法退出游戏')
    .AddPair('messagebox_launcher.illegal_exit.text', '你的MC非法退出了，可能是引发了崩溃。建议将crash-reports内容复制到任何群里进行询问！')
    .AddPair('messagebox_background_reset_image.success.text', Concat('背景图片刷新成功！', #13#10, '名称：${background_image_filename}'))
    .AddPair('messagebox_background_reset_image.success.caption', '刷新成功')
    .AddPair('messagebox_background_reset_image.not_found.text', '背景图片刷新失败，暂未放入文件。')
    .AddPair('messagebox_background_reset_image.not_found.caption', '刷新失败')
    .AddPair('messagebox_background_reset_music.success.text', Concat('背景音乐刷新成功！', #13#10, '名称：${background_music_filename}'))
    .AddPair('messagebox_background_reset_music.success.caption', '刷新成功')
    .AddPair('messagebox_background_reset_music.not_found.text', '背景音乐刷新失败，暂未放入文件。')
    .AddPair('messagebox_background_reset_music.not_found.caption', '刷新失败')
    .AddPair('messagebox_mainform.release_memory_optimize_warning.text', '请问是否立即开始清理内存？LLL启动器将会立即尝试强制清理不需要的内存。此过程中会调用到系统高危函数库【ntdll.dll】，并且需要提权，如果你不确定该库的功能，我不建议你使用该功能。该功能需要以管理员模式启动。')
    .AddPair('messagebox_mainform.release_memory_optimize_warning.caption', '是否开始清理内存')
    .AddPair('messagebox_mainform.cannot_release_first_memory.text', '在清理内存的第一步时出现了严重问题，请重试。')
    .AddPair('messagebox_mainform.cannot_release_first_memory.caption', '清理内存出现问题')
    .AddPair('messagebox_mainform.cannot_release_second_memory.text', '在清理内存的第二步时出现了严重问题，请重试。')
    .AddPair('messagebox_mainform.cannot_release_second_memory.caption', '清理内存出现问题')
    .AddPair('messagebox_mainform.cannot_release_third_memory.text', '在清理内存的第三步时出现了严重问题，请重试。')
    .AddPair('messagebox_mainform.cannot_release_third_memory.caption', '清理内存出现问题')
    .AddPair('messagebox_mainform.cannot_release_forth_memory.text', '在清理内存的第四步时出现了严重问题，请重试。')
    .AddPair('messagebox_mainform.cannot_release_forth_memory.caption', '清理内存出现问题')
    .AddPair('messagebox_mainform.cannot_release_fifth_memory.text', '在清理内存的第五步时出现了严重问题，请重试。')
    .AddPair('messagebox_mainform.cannot_release_fifth_memory.caption', '清理内存出现问题')
    .AddPair('messagebox_mainform.cannot_root_seIncreaseQuotaPrivilege.text', '在提取SeIncreaseQuotaPrivilege权限时出现错误，你似乎没有以管理员模式启动程序。')
    .AddPair('messagebox_mainform.cannot_root_seIncreaseQuotaPrivilege.caption', '提取权限时出现错误')
    .AddPair('messagebox_mainform.cannot_root_seProfileSingleProcessPrivilege.text', '在提取SeProfileSingleProcessPrivilege权限时出现错误，你似乎没有以管理员模式启动程序。')
    .AddPair('messagebox_mainform.cannot_root_seProfileSingleProcessPrivilege.caption', '提取权限时出现错误')
    .AddPair('messagebox_mainform.release_memory_success.text', '清理内存成功！一共清理出${release_memory_value}MB内存！')
    .AddPair('messagebox_mainform.release_memory_success.caption', '清理内存成功')
    .AddPair('messagebox_mainform.show_lll_version.text', '当前你使用的Little Limbo Launcher版本是：${version}')
    .AddPair('messagebox_mainform.show_lll_version.caption', '当前使用启动器版本')
    .AddPair('messagebox_mainform.is_reset_launcher.text', '请问是否需要重置LLL启动器，该操作会删除你目前已存在的所有配置文件，包括插件、语言、背景图、背景音乐等。启动器会直接关闭，你需要手动重新打开一次。是否继续？【简单来说就是删掉{exe}\LLLauncher文件】')
    .AddPair('messagebox_mainform.is_reset_launcher.caption', '是否重置LLL启动器？')
    .AddPair('messagebox_mainform.reset_language_to_chinese.text', '请问你是否需要重置语言文件为中文，该举动将会删掉你的配置文件目录下的zh_cn.json文件，并创建一个新的，之后再加载！')
    .AddPair('messagebox_mainform.reset_language_to_chinese.caption', '是否要重置语言为中文')
    .AddPair('messagebox_mainform.cannot_export_launch_args.text', '你目前所处的国家并不属于中国，无法使用启动脚本导出功能，请见谅！')
    .AddPair('messagebox_mainform.cannot_export_launch_args.caption', '无法使用启动脚本导出')
    .AddPair('messagebox_account_offline_error.cannot_name.text', '你的离线登录名称并不理想，输入错误！请不要输入中文，也不要超过16个字符！不要为空。')
    .AddPair('messagebox_account_offline_error.cannot_name.caption', '错误警告')
    .AddPair('messagebox_account_offline_error.cannot_uuid.text', '你的离线登录UUID输入错误，请输入一串长32位无符号UUID。或者不输入等待随机生成')
    .AddPair('messagebox_account_offline_error.cannot_uuid.caption', '错误警告')
    .AddPair('messagebox_account_offline.add_account_success.text', '离线账号添加成功！')
    .AddPair('messagebox_account_offline.add_account_success.caption', '添加成功')
    .AddPair('messagebox_account.cannot_get_account.text', '你还暂未选择一个账号，无法移除！')
    .AddPair('messagebox_account.cannot_get_account.caption', '暂未选择账号，无法移除')
    .AddPair('messagebox_account.is_remove_account.text', '是否要移除所选的这个账号？')
    .AddPair('messagebox_account.is_remove_account.caption', '是否移除')
    .AddPair('messagebox_account.login_account_too_much.text', '你登录的账号超过32个了，请删掉一些之后再重新登录吧！')
    .AddPair('messagebox_account.login_account_too_much.caption', '登录的账号太多了')
    .AddPair('messagebox_account_thirdparty_error.cannot_get_metadata.text', '皮肤站元数据获取失败，你似乎输入错误了服务器地址，请重试。')
    .AddPair('messagebox_account_thirdparty_error.cannot_get_metadata.caption', '皮肤站元数据获取失败')
    .AddPair('messagebox_account_thirdparty_error.refresh_skin_error.text', '不好意思，你在获取外置登录皮肤时失败，也许是你已经在官网上删掉了该皮肤，请重试！')
    .AddPair('messagebox_account_thirdparty_error.refresh_skin_error.caption', '获取皮肤失败')
    .AddPair('messagebox_account_thirdparty_error.username_or_password_nottrue.text', '你的邮箱或者密码输入错误了，请重新输入！')
    .AddPair('messagebox_account_thirdparty_error.username_or_password_nottrue.caption', '邮箱或密码输入错误')
    .AddPair('messagebox_account_thirdparty_error.accesstoken_invalid.text', '你的登录令牌已经失效了！请重新登录一次吧！')
    .AddPair('messagebox_account_thirdparty_error.accesstoken_invalid.caption', '令牌失效')
    .AddPair('messagebox_account_thirdparty_error.unknown_error.text', '在登录外置登录时发生了未知错误，你可以将其反馈给作者，或者再试一次呢……！')
    .AddPair('messagebox_account_thirdparty_error.unknown_error.caption', '发生了未知错误')
    .AddPair('messagebox_account_thirdparty_error.not_choose_any_skin.text', '登录成功！但是你还未在皮肤站中选择任何一个角色，请试图选择一个角色之后再进行登录吧！')
    .AddPair('messagebox_account_thirdparty_error.not_choose_any_skin.caption', '暂未选择角色')
    .AddPair('inputbox_account_thirdparty.choose_a_role.text', '请输入你需要登录的角色序号：${role_group}')
    .AddPair('inputbox_account_thirdparty.choose_a_role.caption', '请输入角色序号')
    .AddPair('messagebox_account_thirdparty_error.dont_entry_other_char.text', '不要尝试在选择角色的时候输入错误的字符！')
    .AddPair('messagebox_account_thirdparty_error.dont_entry_other_char.caption', '字符输入错误')
    .AddPair('messagebox_account_thirdparty_error.connect_error.text', '你的网络连接超时了，请连接之后再进行网络请求。或者如果你连接了，重试一次即可。')
    .AddPair('messagebox_account_thirdparty_error.connect_error.caption', '连接超时引发的报错')
    .AddPair('messagebox_account_thirdparty.add_account_success.text', '添加成功，已通过外置登录成功添加！')
    .AddPair('messagebox_account_thirdparty.add_account_success.caption', '添加成功')
    .AddPair('messagebox_account_thirdparty_error.account_or_password_empty.text', '账号或密码为空，请重新输入！')
    .AddPair('messagebox_account_thirdparty_error.account_or_password_empty.caption', '账号或密码为空')
    .AddPair('messagebox_account_microsoft_error.not_complete_oauth_login.text', '你还暂未完成你的微软OAuth登录就按下了按钮，请重新获取一次用户代码后再来！')
    .AddPair('messagebox_account_microsoft_error.not_complete_oauth_login.caption', '暂未完成登录')
    .AddPair('messagebox_account_microsoft_error.login_timeout.text', '你在登录过程中超时了！请重新获取一次用户代码后再来！')
    .AddPair('messagebox_account_microsoft_error.login_timeout.caption', '登录超时')
    .AddPair('messagebox_account_microsoft_error.refresh_expire.text', '你的RefreshToken也过期了，看样子你已经很久没重置过账号了呢！请重新登录一次新的账号吧！')
    .AddPair('messagebox_account_microsoft_error.refresh_expire.caption', '刷新密钥过期')
    .AddPair('messagebox_account_microsoft_error.uhs_not_same.text', '你在登录微软账号时，通过xbox与xsts两次获取的uhs不一致，请立即将此latest.log或者此截图发送给作者！')
    .AddPair('messagebox_account_microsoft_error.uhs_not_same.caption', '两次获取的uhs不一致')
    .AddPair('messagebox_account_microsoft_error.not_buy_mc.text', '不好意思，您的Microsoft账户并没有购买Minecraft，请问是否立即前往官网购买？')
    .AddPair('messagebox_account_microsoft_error.not_buy_mc.caption', '暂未购买mc，是否前往商店')
    .AddPair('messagebox_account_microsoft_error.cannot_get_user_code.text', '未能获取到用户代码，你似乎未连接网络，请重试！')
    .AddPair('messagebox_account_microsoft_error.cannot_get_user_code.caption', '未能获取到用户代码')
    .AddPair('inputbox_account_microsoft.start_login.text', '你的用户代码在下面，你可以复制它，然后你需要将其复制到刚刚打开的浏览器窗口中进行登录，登录完毕后，你就可以随意按下下面任意一个按钮继续往下执行，但是切记，你不可以在未登录的情况下按下任意一个按钮！')
    .AddPair('inputbox_account_microsoft.start_login.caption', '已获取用户代码')
    .AddPair('messagebox_account_microsoft.add_account_success.text', '添加成功，已通过微软登录成功添加！')
    .AddPair('messagebox_account_microsoft.add_account_success.caption', '添加成功')
    .AddPair('messagebox_account_microsoft_error.connect_error.text', '连接超时引发的报错')
    .AddPair('messagebox_account_microsoft_error.connect_error.caption', '你的网络连接超时了，请连接之后再进行网络请求。或者如果你连接了，重试一次即可。')
    .AddPair('messagebox_account.not_choose_any_account.text', '你还没有登录账号，请立刻登录一次再尝试获取UUID。')
    .AddPair('messagebox_account.not_choose_any_account.caption', '暂未登录账号')
    .AddPair('messagebox_account.get_current_uuid.text', '你本账号的UUID为：${account_uuid}，是否复制进剪切板？')
    .AddPair('messagebox_account.get_current_uuid.caption', '已得到UUID')
    .AddPair('messagebox_account.not_support_login_way.text', '你选中了不支持的登录方式，请重试！')
    .AddPair('messagebox_account.not_support_login_way.caption', '不支持的登录方式')
    .AddPair('messagebox_account.offline_cannot_refresh.text', '离线模式不需要刷新账号哦！可以换成微软登录或者外置登录来刷新呢！')
    .AddPair('messagebox_account.offline_cannot_refresh.caption', '离线模式不需要刷新账号')
    .AddPair('messagebox_account.refresh_microsoft_error.text', '刷新微软账号失败，有可能是你的Refresh_token已经过期了，也有可能是你的网络连接不好。')
    .AddPair('messagebox_account.refresh_microsoft_error.caption', '刷新微软账号失败')
    .AddPair('messagebox_account.refresh_microsoft_success.text', '刷新微软账号成功！')
    .AddPair('messagebox_account.refresh_microsoft_success.caption', '刷新微软账号成功')
    .AddPair('messagebox_account.refresh_thirdparty_error.text', '刷新外置账号失败，有可能是你的Refresh_token已经过期了，也有可能是你的网络连接不好。')
    .AddPair('messagebox_account.refresh_thirdparty_error.caption', '刷新外置账号失败')
    .AddPair('messagebox_account.refresh_thirdparty_success.text', '刷新外置账号成功！')
    .AddPair('messagebox_account.refresh_thirdparty_success.caption', '刷新外置账号成功')
    .AddPair('messagebox_account.name_to_uuid_error.text', '该用户不存在，请重新输入用户名。')
    .AddPair('messagebox_account.name_to_uuid_error.caption', '该用户不存在')
    .AddPair('messagebox_account.name_not_true.text', '用户名不符合规范，请重新输入！')
    .AddPair('messagebox_account.name_not_true.caption', '用户名不符合规范')
    .AddPair('messagebox_account.uuid_to_name_error.text', '该用户不存在，请重新输入UUID。')
    .AddPair('messagebox_account.uuid_to_name_error.caption', '该用户不存在')
    .AddPair('messagebox_account.uuid_not_true.text', 'UUID不符合规范，请重新输入！')
    .AddPair('messagebox_account.uuid_not_true.caption', 'UUID不符合规范')
    .AddPair('messagebox_account_offline.add_demo_warning.caption', '离线登录警告')
    .AddPair('messagebox_account_offline.add_demo_warning.text', '由于你目前并不处于中国地区，并且你暂未登录过任一正版账号，因此你所登录的离线登录将会被加上--demo。除非你登录一次正版，否则这个标签将会一直加上！')
    .AddPair('messagebox_mainform.launch_afdian.text', Concat('LLL启动器已经帮你启动过${launch_number}次游戏了，真的不打算为作者发电么？【呜呜的请求……】', #13#10, '点是进入作者的爱发电。'))
    .AddPair('messagebox_mainform.open_afdian.text', Concat('LLL启动器已经被你打开过${open_number}次了，真的不打算为作者发电么？【呜呜的请求……】', #13#10, '点是进入作者的爱发电。'))
    .AddPair('messagebox_mainform.afdian.caption', '快点来给我发电吧')
    .AddPair('messagebox_mainform.change_language.text', '当你切换了任意一次语言后，虽然这是实时更改的，但仍然不排除有部分标签没有修改，因此这里建议你重新打开一次启动器。')
    .AddPair('messagebox_mainform.change_language.caption', '建议重启启动器')
    .AddPair('messagebox_resource.get_curseforge_search_error.caption', '获取失败……')
    .AddPair('messagebox_resource.get_curseforge_search_error.text', '获取Curseforge返回结果错误，请重试！')
    .AddPair('messagebox_resource.get_curseforge_name_or_version_error.caption', '获取失败……')
    .AddPair('messagebox_resource.get_curseforge_name_or_version_error.text', '在获取Curseforge时，返回了0个元素，搜素失败！')
    .AddPair('messagebox_resource.get_modrinth_search_error.caption', '获取失败……')
    .AddPair('messagebox_resource.get_modrinth_search_error.text', '获取Modrinth返回结果错误，请重试！')
    .AddPair('messagebox_resource.get_modrinth_name_or_version_error.caption', '获取失败……')
    .AddPair('messagebox_resource.get_modrinth_name_or_version_error.text', '在获取Modrinth时，返回了0个元素，搜素失败！')
    .AddPair('messagebox_resource.get_curseforge_page_error.caption', '返回结果为空，解析失败。')
    .AddPair('messagebox_resource.get_curseforge_page_error.text', '在对Curseforge版本进行翻页或者点击列表框时，返回结果为空，解析失败。')
    .AddPair('messagebox_resource.get_modrinth_page_error.caption', '返回结果为空，解析失败。')
    .AddPair('messagebox_resource.get_modrinth_page_error.text', '在对Modrinth版本进行翻页或者点击列表框时，返回结果为空，解析失败。')
    .AddPair('messagebox_resource.version_pageup_error.caption', '版本上一页失败')
    .AddPair('messagebox_resource.version_pageup_error.text', '已经是第一页啦！不要再上一页啦！')
    .AddPair('messagebox_resource.version_pagedown_error.caption', '版本下一页失败')
    .AddPair('messagebox_resource.version_pagedown_error.text', '已经是最后一页啦！不要再下一页啦！')
    .AddPair('messagebox_resource.name_pageup_error.caption', '名称上一页失败')
    .AddPair('messagebox_resource.name_pageup_error.text', '已经是第一页啦！不要再上一页啦！')
    .AddPair('messagebox_resource.name_pagedown_error.caption', '名称下一页失败')
    .AddPair('messagebox_resource.name_pagedown_error.text', '已经是最后一页啦！不要再下一页啦！')
    .AddPair('messagebox_resource.not_choose_mod_error.caption', '暂未选择模组。')
    .AddPair('messagebox_resource.not_choose_mod_error.text', '暂未选择任意模组，无法打开官网，请重试。')
    .AddPair('messagebox_resource.open_intro_error.caption', '打开简介失败')
    .AddPair('messagebox_resource.open_intro_error.text', '打开简介失败，请尝试选择任意一个资源版本后，再尝试打开简介。')
    .AddPair('picturebox_resource.open_curseforge_intro_success.text', Concat(
            '项目ID：${p_id}', #13#10,
            '项目隶属：${classId}', #13#10,
            '项目slug：${slug}', #13#10,
            '项目标题：${name}', #13#10,
            '项目作者：${authors}', #13#10,
            '项目简介：${summary}', #13#10,
            '项目类型：${categories}', #13#10,
            '项目下载量：${p_downloadCount}', #13#10,
//            '项目关注量：${follows}', #13#10,
            '项目创建日期：${dateCreated}', #13#10,
            '项目最新版本：${dateModified}', #13#10,
            '项目最新版本：${gameVersion}', #13#10,
//            '项目许可证：${license}', #13#10,
            '-----------------------------------------------------------------------------------------------------------------------', #13#10,
            '所选ID：${id}', #13#10,
            '所选名称：${fileName}', #13#10,
            '所选版本名：${displayName}', #13#10,
            '所选下载量：${downloadCount}', #13#10,
            '所选发布状态：${releaseType}', #13#10,
            '所选发布日期：${fileDate}', #13#10,
            '所选MC版本/加载器：${gameVersions}'
//            '所选加载器：${loaders}', #13#10,
//            '所选更新日志：${changelog}', #13#10
            ))
    .AddPair('picturebox_resource.open_modrinth_intro_success.text', Concat(
            '项目ID：${project_id}', #13#10,
            '项目隶属：${project_type}', #13#10,
            '项目slug：${slug}', #13#10,
            '项目标题：${title}', #13#10,
            '项目作者：${author}', #13#10,
            '项目简介：${description}', #13#10,
            '项目类型：${categories}', #13#10,
            '项目下载量：${p_downloads}', #13#10,
            '项目关注量：${follows}', #13#10,
            '项目创建日期：${date_created}', #13#10,
            '项目最后更新日期：${latest_version}', #13#10,
            '项目最新版本：${date_modified}', #13#10,
            '项目许可证：${license}', #13#10,
            '-----------------------------------------------------------------------------------------------------------------------', #13#10,
            '所选ID：${id}', #13#10,
            '所选名称：${name}', #13#10,
            '所选版本名：${version_number}', #13#10,
            '所选下载量：${downloads}', #13#10,
            '所选发布状态：${version_type}', #13#10,
            '所选发布日期：${date_published}', #13#10,
            '所选支持MC版本：${game_versions}', #13#10,
            '所选加载器：${loaders}', #13#10,
            '所选更新日志：${changelog}'))
    .AddPair('picturebox_resource.has_no_data', '暂无数据。')
    .AddPair('messagebox_resource.no_version_download_error.caption', '暂未选择任意版本')
    .AddPair('messagebox_resource.no_version_download_error.text', '您还暂未选择任意资源的版本，无法下载，请选择一个之后重试。')
    .AddPair('opendialog_resource.download_dialog.title', '请选择你要保存的路径：')
    .AddPair('messagebox_resource.file_exists_download_error.caption', '文件已存在')
    .AddPair('messagebox_resource.file_exists_download_error.text', '你要下载的路径已存在一个同名文件，请删除这个文件后再重新尝试下载。')
    .AddPair('messagebox_resource.download_resource_success.caption', '下载完成')
    .AddPair('messagebox_resource.download_resource_success.text', '资源下载已完成！')
    .AddPair('messagebox_resource.open_manage_error.caption', '打开资源管理界面失败')
    .AddPair('messagebox_resource.open_manage_error.text', '打开资源管理界面失败，你似乎并未选中任一游戏文件夹，请去选中一次再来！')
    .AddPair('messagebox_manage.drag_file_mod.caption', '您安装的是模组')
    .AddPair('messagebox_manage.drag_file_mod.text', '你需要安装的是【模组】，名称为：${drag_file_name}，请问是否继续？')
    .AddPair('messagebox_manage.drag_mod_repeat.caption', '你的模组有重复')
    .AddPair('messagebox_manage.drag_mod_repeat.text', '你想安装的模组有重复名称的文件，文件名是：${drag_file_name}，是否需要替换？')
    .AddPair('messagebox_manage.drag_mod_format_error.caption', '安装文件格式错误')
    .AddPair('messagebox_manage.drag_mod_format_error.text', '你想安装的模组文件格式不为jar或zip，文件名是：${drag_file_name}，无法安装，请重试！')
    .AddPair('messagebox_manage.drag_map_zip.caption', '您安装的是地图')
    .AddPair('messagebox_manage.drag_map_zip.text', '你需要安装的是【地图】的zip格式包，名称为：${drag_file_name}，请问是否继续？')
    .AddPair('messagebox_manage.drag_map_zip_repeat.caption', '你的地图有重复')
    .AddPair('messagebox_manage.drag_map_zip_repeat.text', '你想安装的地图有重复名称的文件，文件名是：${drag_file_name}，是否需要替换？')
    .AddPair('messagebox_manage.drag_map_unzip_error.caption', '解压地图zip失败')
    .AddPair('messagebox_manage.drag_map_unzip_error.text', '解压地图的zip失败，你是否给该zip包上了密码锁，或者该zip包无法解压，请重试。')
    .AddPair('messagebox_manage.drag_map_dir.caption', '您安装的是地图')
    .AddPair('messagebox_manage.drag_map_dir.text', '你需要安装的是【地图】的文件夹格式包，名称为：${drag_file_name}，请问是否继续？')
    .AddPair('messagebox_manage.drag_map_dir_repeat.caption', '你的地图有重复')
    .AddPair('messagebox_manage.drag_map_dir_repeat.text', '你想安装的地图有重复名称的文件，文件名是：${drag_file_name}，是否需要替换？')
    .AddPair('messagebox_manage.drag_map_format_error.caption', '安装文件格式错误')
    .AddPair('messagebox_manage.drag_map_format_error.text', '你想安装的地图文件格式不为文件夹或zip，文件名是：${drag_file_name}，无法安装，请重试！')
    .AddPair('messagebox_manage.drag_resourcepack.caption', '您安装的是纹理')
    .AddPair('messagebox_manage.drag_resourcepack.text', '你需要安装的是【纹理】，名称为：${drag_file_name}，请问是否继续？')
    .AddPair('messagebox_manage.drag_resourcepack_repeat.caption', '你的纹理有重复')
    .AddPair('messagebox_manage.drag_resourcepack_repeat.text', '你想安装的纹理有重复名称的文件，文件名是：${drag_file_name}，是否需要替换？')
    .AddPair('messagebox_manage.drag_resourcepack_format_error.caption', '安装文件格式错误')
    .AddPair('messagebox_manage.drag_resourcepack_format_error.text', '你想安装的纹理文件格式不为zip，文件名是：${drag_file_name}，无法安装，请重试！')
    .AddPair('messagebox_manage.drag_shader.caption', '您安装的是光影')
    .AddPair('messagebox_manage.drag_shader.text', '你需要安装的是【光影】，名称为：${drag_file_name}，请问是否继续？')
    .AddPair('messagebox_manage.drag_shader_repeat.caption', '你的光影有重复')
    .AddPair('messagebox_manage.drag_shader_repeat.text', '你想安装的光影有重复名称的文件，文件名是：${drag_file_name}，是否需要替换？')
    .AddPair('messagebox_manage.drag_shader_format_error.caption', '安装文件格式错误')
    .AddPair('messagebox_manage.drag_shader_format_error.text', '你想安装的光影文件格式不为zip，文件名是：${drag_file_name}，无法安装，请重试！')
    .AddPair('messagebox_manage.drag_plugin.caption', '您安装的是插件')
    .AddPair('messagebox_manage.drag_plugin.text', '你需要安装的是【插件】，名称为：${drag_file_name}，请问是否继续？')
    .AddPair('messagebox_manage.drag_plugin_repeat.caption', '你的插件有重复')
    .AddPair('messagebox_manage.drag_plugin_repeat.text', '你想安装的插件有重复名称的文件，文件名是：${drag_file_name}，是否需要替换？')
    .AddPair('messagebox_manage.drag_plugin_format_error.caption', '安装文件格式错误')
    .AddPair('messagebox_manage.drag_plugin_format_error.text', '你想安装的插件文件格式不为jar或zip，文件名是：${drag_file_name}，无法安装，请重试！')
    .AddPair('messagebox_manage.drag_datapack_no_choose_map_error.caption', '暂未选择地图')
    .AddPair('messagebox_manage.drag_datapack_no_choose_map_error.text', '你还未选择任意一个地图，无法导入数据包，请重试！')
    .AddPair('messagebox_manage.drag_datapack.caption', '您安装的时数据包')
    .AddPair('messagebox_manage.drag_datapack.text', '你需要安装的是【数据包】，名称为：${drag_file_name}，请问是否继续？')
    .AddPair('messagebox_manage.drag_datapack_repeat.caption', '你的数据包有重复')
    .AddPair('messagebox_manage.drag_datapack_repeat.text', '你想安装的数据包有重复名称的文件，文件名是：${drag_file_name}，是否需要替换？')
    .AddPair('messagebox_manage.drag_datapack_format_error.caption', '安装文件格式错误')
    .AddPair('messagebox_manage.drag_datapack_format_error.text', '你想安装的数据包文件格式不为zip，文件名是：${drag_file_name}，无法安装，请重试！')
    .AddPair('messagebox_manage.drag_file_finish.caption', '安装完成')
    .AddPair('messagebox_manage.drag_file_finish.text', '所有文件安装完成！')
    .AddPair('messagebox_manage.disable_resource_not_choose.caption', '无法禁用')
    .AddPair('messagebox_manage.disable_resource_not_choose.text', '你选中的资源不是模组或者插件，又或者你暂未选中任一资源，无法禁用，请重试。')
    .AddPair('messagebox_manage.resource_already_disable.caption', '已被禁用')
    .AddPair('messagebox_manage.resource_already_disable.text', '你选中的资源已被禁用，无法重复禁用，请重试。')
    .AddPair('messagebox_manage.enable_resource_not_choose.caption', '无法启用')
    .AddPair('messagebox_manage.enable_resource_not_choose.text', '你选中的资源不是模组或者插件，又或者你暂未选中任一资源，无法启用，请重试。')
    .AddPair('messagebox_manage.resource_already_enable.caption', '已被启用')
    .AddPair('messagebox_manage.resource_already_enable.text', '你选中的资源已被启用，无法重复启用，请重试')
    .AddPair('messagebox_manage.delete_resource_not_choose.caption', '无法删除！')
    .AddPair('messagebox_manage.delete_resource_not_choose.text', '你还暂未选中任一资源，无法删除，请重试。')
    .AddPair('messagebox_manage.resource_is_delete.caption', '请问是否删除')
    .AddPair('messagebox_manage.resource_is_delete.text', '是否删除掉此资源？会将其放入回收站。')
    .AddPair('messagebox_manage.rename_resource_not_choose.caption', '无法重命名')
    .AddPair('messagebox_manage.rename_resource_not_choose.text', '你还暂未选中任一资源，无法重命名，请重试。')
    .AddPair('inputbox_manage.rename_new_name.caption', '请输入命名的新名称')
    .AddPair('inputbox_manage.rename_new_name.text', '在下方输入命名的新名称，如果留空或者按取消则保持原名。')
    .AddPair('messagebox_manage.open_no_choose_resource.caption', '无法打开文件夹')
    .AddPair('messagebox_manage.open_no_choose_resource.text', '你还暂未选择任一资源，无法通过资源管理器打开')
    .AddPair('messagebox_launch.pre_launch_script_tip.caption', '前置启动脚本命令提示')
    .AddPair('messagebox_launch.pre_launch_script_tip.text', Concat('在书写该参数的时候，你需要注意一点，你当然可以选择书写shutdown -s -t 0，也可以选择调出你默认的服务端代码，甚至可以打开vscode。', #13#10,
            '但是请注意，此处命令只是会在启动游戏之前先默认执行一遍哦！而不是在启动游戏之后忽然给你执行一次，如果填入错误的话，本启动器将不会给出任何的错误提示哦！', #13#10,
            '顺带提一句，请使用【<空格>&<空格>】来分隔，如果你需要执行多行命令的话。目前暂未实现使用快捷键来指定目录，例如【使用{minecraft}指定mc当前目录】等功能哦！', #13#10,
            '当执行指令的时候，如果你愿意的话，你可以用C语言写一个无限循环，然后让启动器执行这个exe，但是该启动器会卡死，因为启动器会一直等待执行命令完毕才会启动MC。'))
    .AddPair('messagebox_launch.after_launch_script_tip.caption', '后置启动脚本命令提示')
    .AddPair('messagebox_launch.after_launch_script_tip.text', Concat('在书写该参数的时候，倒是可以写shutdown -s -t 0了，因为有可能你玩完游戏之后就会关机。', #13#10,
            '本参数的意思是当你结束MC运行的时候，开始执行该指令。如果在此期间，你手动关闭了本启动器，则不会执行该指令语句。', #13#10,
            '填入错误也不会有任何提示，并且也请使用【<空格>&<空格>】来分割多条指令，目前暂未实现快捷键指定目录。例如【使用{minecraft}指定mc当前目录】等功能。', #13#10,
            '如果该处有无限循环指令，则启动器将会一直等待下去【也就是卡死】，直到该指令执行完毕，才会松开句柄使得启动器恢复成可操作模式。'))
    .AddPair('messagebox_launch.default_jvm_tip.caption', '默认JVM参数提示')
    .AddPair('messagebox_launch.default_jvm_tip.text', Concat('默认JVM参数：这个是默认会在游戏启动中添加的参数，已设置ReadOnly。不要试图修改它，如果必要的话，请在以下的额外JVM参数下修改。'))
    .AddPair('messagebox_launch.additional_jvm_tip.caption', '额外JVM参数提示')
    .AddPair('messagebox_launch.additional_jvm_tip.text', Concat('额外JVM参数：这个会将你输入的参数名当做启动脚本的jvm参数最后一个新增上去。顺带一提，请用空格分隔你的参数，还有，非专业人士请勿修改。'))
    .AddPair('messagebox_launch.additional_game_tip.caption', '额外Game参数提示')
    .AddPair('messagebox_launch.additional_game_tip.text', Concat('额外game参数，又称额外游戏参数：这个会将你输入的参数名当作启动脚本的最后一个新增上去，顺带一提，请用空格分隔你的参数，还有，非专业人士请勿修改。', #13#10,
            '关于额外game参数的提示：不仅可以输入以下Hint中的参数，你还可以输入quickPlayMultiplayer然后附带<服务器地址>:<服务器端口>来进入服务器，其中如果服务器没有端口，则默认为25565。甚至可以适用quickPlayRealms，后面附带你的Realms代号。', #13#10,
            '自然，除了这些，你还可以指定quickPlayPath，该值接受一个log【输出】路径，你可以填入这个log，它将会记录你进入的世界的所有类型，你可以根据这些类型来填写quickPlay啥啥的参数。其实以上所有参数仅适用于23w14a以上，若你在其以下，你依旧需要在此指定--server和--port，如果一个服务器没有端口，则默认是25565。', #13#10,
            '不仅如此，你还可以在此输入--demo进入试玩模式或--fullScreen进入全屏，具体内容请参见：https://zh.minecraft.wiki/w/23w14a，切记，如果你的MC版本低于23w14a，你将无法使用以上quick等参数，只能使用--server、--port。'))
    .AddPair('messagebox_launch.is_full_scan_java.caption', '全盘扫描Java')
    .AddPair('messagebox_launch.is_full_scan_java.text', '你选择的是全盘扫描Java，可能会卡很久很久，耗时非常长，在此期间请勿关闭启动器哦！是否继续？')
    .AddPair('messagebox_launch.full_scan_java_error.caption', '扫描Java失败')
    .AddPair('messagebox_launch.full_scan_java_error.text', '扫描${drive}盘时出错，你是否给予了足够的权限？请尝试使用管理员启动程序后再试。')
    .AddPair('messagebox_launch.full_scan_java_success.caption', '扫描Java成功')
    .AddPair('messagebox_launch.full_scan_java_success.text', '所有磁盘全部扫描完毕，所有Java已添加至下拉框！')
    .AddPair('messagebox_launch.is_basic_scan_java.caption', '特定扫描Java')
    .AddPair('messagebox_launch.is_basic_scan_java.text', '你选择的是特定扫描Java，用时应该不会很久，在此期间请勿关闭启动器哦！是否继续？')
    .AddPair('messagebox_launch.basic_scan_java_search_regedit_error.caption', '特定扫描Java失败')
    .AddPair('messagebox_launch.basic_scan_java_search_regedit_error.text', '扫描注册表时出错，你是否给予了足够的权限？请尝试使用管理员启动程序后再试。')
    .AddPair('messagebox_launch.basic_scan_java_success.caption', '特定扫描Java成功')
    .AddPair('messagebox_launch.basic_scan_java_success.text', '所有特定目录全部扫描完毕，所有Java已添加至下拉框！')
    .AddPair('opendialog_launch.menual_import_java_dialog_title', '请选择Javaw文件')
    .AddPair('messagebox_launch.not_support_java_bit.caption', '不支持的Java位数')
    .AddPair('messagebox_launch.not_support_java_bit.text', '这个Java文件是32位Java，或者位数不支持显示，请重试。')
    .AddPair('messagebox_launch.menual_import_java_success.caption', '添加成功')
    .AddPair('messagebox_launch.menual_import_java_success.text', '手动添加Java成功！')
    .AddPair('messagebox_launch.not_choose_java.caption', '暂未选中Java')
    .AddPair('messagebox_launch.not_choose_java.text', '你目前还暂未选中任意Java，无法直接移除Java，请重试！')
    .AddPair('messagebox_launch.is_remove_java.caption', '是否移除Java')
    .AddPair('messagebox_launch.is_remove_java.text', '是否要移除当前选中的Java？')
    .AddPair('messagebox_launch.remove_java_success.caption', '移除Java成功')
    .AddPair('messagebox_launch.remove_java_success.text', '移除Java成功，但是你可以重新使用手动导入或者特定导入来导入这个Java。')
    .AddPair('messagebox_launch.get_java_metadata_error.caption', '获取Java元数据失败')
    .AddPair('messagebox_launch.get_java_metadata_error.text', '获取Java的元数据失败，你似乎并没有联网，或者该下载源不支持下载Java，请联网后再尝试。')
    .AddPair('messagebox_launch.get_java_manifest_error.caption', '获取Java版本元数据失败')
    .AddPair('messagebox_launch.get_java_manifest_error.text', '由于未知原因，获取Java(${java_version})(64)的版本元数据失败，请重试！')
    .AddPair('messagebox_launch.download_java_success.caption', '下载Java成功')
    .AddPair('messagebox_launch.download_java_success.text', '下载Java成功了，现在你可以通过特定扫描来导入Java了！')
    .AddPair('inputbox_launch.select_java_web.caption', '请选择你要下载的Java官网')
    .AddPair('inputbox_launch.select_java_web.text', '如果你不信任LLL下载的Java，你可以自行在此处输入你想进入的Java官网（这里给几个官网，推荐指数从上往下。），LLL会通过你电脑的默认浏览器打开官网。输入前面的序号即可：')
    .AddPair('messagebox_launch.open_java_web_error.caption', '输入的数字有误')
    .AddPair('messagebox_launch.open_java_web_error.text', '你输入了不支持的序号，请重新输入！')
    .AddPair('messagebox_download.not_choose_minecraft_versino.caption', '暂未选择Minecraft版本')
    .AddPair('messagebox_download.not_choose_minecraft_versino.text', '你还暂未选择任意Minecraft版本，无法加载模组加载器。')
    .AddPair('messagebox_download.view_mc_info_error.caption', '暂未选择Minecraft版本')
    .AddPair('messagebox_download.view_mc_info_error.text', '你还暂未选择任意Minecraft版本，无法查看信息。')
    .AddPair('messagebox_download.is_open_wiki.text', Concat('发布时间：${year}年${month}月${day}日${time}', #13#10, '是否打开Wiki查看更详情信息？'))
    .AddPair('messagebox_download.import_mc_info_error.caption', '无法读取MC信息')
    .AddPair('messagebox_download.import_mc_info_error.text', '查看MC信息时，无法读取该MC版本信息，请联系作者修复！')
    .AddPair('messagebox_download.not_choose_download.caption', '暂未选择Minecraft版本')
    .AddPair('messagebox_download.not_choose_download.text', '你还暂未选择任意Minecraft版本，无法下载MC。')
    .AddPair('messagebox_download.name_is_empty.caption', '名称为空')
    .AddPair('messagebox_download.name_is_empty.text', '你为此下载的Minecraft命的名称为空，请试着输入一个名称后再来。')
    .AddPair('messagebox_download.get_mc_dir_error.caption', '读取文件错误')
    .AddPair('messagebox_download.get_mc_dir_error.text', '你还暂未选中任意MC文件夹，请去版本设置里选中一个后再来！')
    .AddPair('messagebox_download.is_download_mc.caption', '将会被替换，是否继续')
    .AddPair('messagebox_download.is_download_mc.text', '如果你需要下载一个新版本的话，该版本会替换掉你原有的{minecraft}\versions\{version_name}文件夹下的所有内容，如果你开了版本隔离，请务必确保已经备份了版本。并且由LLL启动器下载的MC版本将很有可能不会被PCL2、HMCL、BakaXL等启动器识别并启动，请酌情选择。请点击是继续……')
    .AddPair('messagebox_download.install_forge_not_choose_java.caption', '暂未选中Java')
    .AddPair('messagebox_download.install_forge_not_choose_java.text', '你在安装Forge的时候，暂未选中任意Java文件，在安装Forge时必须要选中任一Java文件才能继续。')
    .AddPair('messagebox_download.download_no_data.caption', '暂无数据')
    .AddPair('messagebox_download.download_no_data.text', '你选择的模组加载器列表框元素是暂无数据，请重新选择一次模组加载器版本！')
    .AddPair('messagebox_download.is_install_forge.caption', '很大的不稳定性，是否继续')
    .AddPair('messagebox_download.is_install_forge.text', '特别提示：目前Forge自动安装极其不稳定，请慎重考虑是否需要使用LLL启动器自动安装。【如果在此处遇到了bug，请暂时不要反馈，作者已经在修了。。bug包括但不限于跑处理器的时候线程卡死等问题】，一旦点击是则视你默认遵守自动安装模组加载器所承担的一切后果【哪怕是启动器出现的下载问题。】如有疑惑，请与作者进行沟通。')
    .AddPair('messagebox_download.is_install_neoforge.caption', '是否跳转到安装NeoForged')
    .AddPair('messagebox_download.is_install_neoforge.text', '特别提示：如果你需要安装1.20.1或者以上版本的Forge，您可以考虑安装NeoForged，它是由cpw掌管的Forge，尽管如此，NeoForged也支持当今的几乎所有的原Forge版本的模组，您可以试试看。是否立刻跳转到NeoForged下载？【按否则立即以该版本安装。】')
    .AddPair('messagebox_download.not_support_forge_version.caption', '不受支持的Forge版本')
    .AddPair('messagebox_download.not_support_forge_version.text', '该Forge版本暂不受支持，因为里面没有installer，请重新选择一个受支持的Forge版本吧！')
    .AddPair('messagebox_download.download_forge_success.caption', '下载Forge成功')
    .AddPair('messagebox_download.download_forge_success.text', '下载Forge成功！现在你可以进入版本选择选择该版本进行游玩了！')
    .AddPair('messagebox_download.download_fabric_success.caption', '下载Fabric成功')
    .AddPair('messagebox_download.download_fabric_success.text', '下载Fabric成功！现在你可以进入版本选择选择该版本进行游玩了！')
    .AddPair('messagebox_download.download_quilt_success.caption', '下载Quilt成功')
    .AddPair('messagebox_download.download_quilt_success.text', '下载Quilt成功！现在你可以进入版本选择选择该版本进行游玩了！')
    .AddPair('messagebox_download.install_neoforge_not_choose_java.caption', '暂未选中Java')
    .AddPair('messagebox_download.install_neoforge_not_choose_java.text', '你在安装NeoForge的时候，暂未选中任意Java文件，在安装NeoForge时必须要选中任一Java文件才能继续。')
    .AddPair('messagebox_download.download_neoforge_success.caption', '下载NeoForge成功')
    .AddPair('messagebox_download.download_neoforge_success.text', '下载NeoForge成功！现在你可以进入版本选择选择该版本进行游玩了！')
    .AddPair('messagebox_download.download_mc_success.caption', '下载MC原版成功')
    .AddPair('messagebox_download.download_mc_success.text', '下载MC原版成功！现在你可以进入版本选择选择该版本进行游玩了！')
    .AddPair('selectdialog_customdl.select_save_path', '请选择自定义下载保存路径')
    .AddPair('messagebox_customdl.open_save_path_error.caption', '打开保存路径失败')
    .AddPair('messagebox_customdl.open_save_path_error.text', '你的保存路径输入得不正确，文件夹不存在或者路径有误，请重试！')
    .AddPair('messagebox_customdl.not_enter_url.caption', '暂未输入网址')
    .AddPair('messagebox_customdl.not_enter_url.text', '暂未输入网址，无法下载！')
    .AddPair('messagebox_customdl.path_not_exist.caption', '路径不存在')
    .AddPair('messagebox_customdl.path_not_exist.text', '路径不存在，无法下载！')
    .AddPair('messagebox_customdl.file_is_exists.caption', '已存在同名文件')
    .AddPair('messagebox_customdl.file_is_exists.text', '已存在同名的文件在你的路径下，是否直接替换？')
    .AddPair('messagebox_customdl.check_hash_success.caption', '检查文件Hash成功')
    .AddPair('messagebox_customdl.check_hash_success.text', '自定义下载完成！并且检查文件sha1成功！现在你可以去看下载的文件了！')
    .AddPair('messagebox_customdl.check_hash_error.caption', '检查文件Hash失败')
    .AddPair('messagebox_customdl.check_hash_error.text', '自定义下载完成！但是检查文件sha1失败了，你似乎输入了错误的文件sha1值，又或者是LLL启动器拼接文件时出错了……谁懂呢！请重试吧！')
    .AddPair('messagebox_customdl.custom_download_success.caption', '自定义下载完成')
    .AddPair('messagebox_customdl.custom_download_success.text', '自定义下载完成！未采取检查文件sha1方式，请去路径下查看吧！')
    .AddPair('messagebox_customdl.custom_download_error.caption', '自定义下载失败。')
    .AddPair('messagebox_customdl.custom_download_error.text', '自定义下载失败，可能原因应该是LLL启动器未能为你的文件拆分进行合并处理，又或者是有某单个文件下载失败导致未能拼接，请重试，请重试！')
    .AddPair('messagebod_modloader.not_choose_modloader.caption', '暂未选择任意版本')
    .AddPair('messagebod_modloader.not_choose_modloader.text', '你还暂未选择任意模组加载器版本进行手动安装包下载呢！请重试！【Forge和NeoForge需要去《下载Minecraft》中选择任一Minecraft版本才能下载噢！】')
    .AddPair('messagebox_modloader.download_modloader_success.caption', '下载成功')
    .AddPair('messagebox_modloader.download_modloader_success.text', '下载模组加载器手动安装包成功！现在你可以去文件夹中查看了！')
    .AddPair('messagebox_version.select_mc_success.caption', '选择成功')
    .AddPair('messagebox_version.select_mc_success.text', '选择MC文件夹成功！')
    .AddPair('selectdialog_version.select_mc_path', '请选择MC文件夹')
    .AddPair('inputbox_version.select_mc_name.caption', '请输入MC文件名')
    .AddPair('inputbox_version.select_mc_name.text', '请输入你要为这个文件夹命的名称，这里建议输入类似于【联机】等的这些有标识性的名字。')
    .AddPair('inputbox_version.select_new_mc_name.caption', '请输入MC文件名')
    .AddPair('inputbox_version.select_new_mc_name.text', '请输入你要为这个文件夹命的名称，，这里你选择的是此exe文件夹下的【.minecraft】文件夹，这里建议输入类似于【联机】等的这些有标识性的名字。')
    .AddPair('messagebox_version.path_is_exists.caption', '路径有重复')
    .AddPair('messagebox_version.path_is_exists.text', '你的文件夹路径有重复的，请重新再选择一个或者给此文件夹改名吧！')
    .AddPair('messagebox_version.create_minecraft_dir.caption', '创建成功')
    .AddPair('messagebox_version.create_minecraft_dir.text', '已为此exe路径下创建了一个名为.minecraft文件名的文件夹了！')
    .AddPair('messagebox_version.no_mc_dir.caption', '暂未选择MC文件夹')
    .AddPair('messagebox_version.no_mc_dir.text', '你还未选择任意一个文件夹呢，请去选择一个后重试！')
    .AddPair('inputbox_version.enter_mc_rename.caption', '请输入更改的名称')
    .AddPair('inputbox_version.enter_mc_rename.text', '请输入你需要更改的名称，留空或点击取消则退出。')
    .AddPair('messagebox_version.rename_mc_success.caption', '修改名称成功')
    .AddPair('messagebox_version.rename_mc_success.text', '修改名称成功了！现在你可以进行选择了！')
    .AddPair('messagebox_version.is_remove_mc_dir.caption', '是否移除文件列表')
    .AddPair('messagebox_version.is_remove_mc_dir.text', '是否移除文件列表？移除之后不会对文件有所修改。')
    .AddPair('messagebox_version.remove_mc_dir_success.caption', '移除成功')
    .AddPair('messagebox_version.remove_mc_dir_success.text', '移除文件列表成功！')
    .AddPair('messagebox_version.no_ver_dir.caption', '暂未选择MC版本')
    .AddPair('messagebox_version.no_ver_dir.text', '你还未选择任意一个MC的版本呢，请先点击添加一个MC文件夹，再选择一个MC版本，然后再重试！')
    .AddPair('inputbox_version.enter_ver_rename.caption', '请输入更改的名称')
    .AddPair('inputbox_version.enter_ver_rename.text', '请输入你需要更改的名称，留空或点击取消则退出。【在这里更改名称后可能导致PCL2、HMCL、BakaXL等主流启动器无法启动，请酌情修改！】')
    .AddPair('messagebox_version.rename_ver_success.caption', '重命名成功')
    .AddPair('messagebox_version.rename_ver_success.text', '重命名成功！')
    .AddPair('messagebox_version.rename_ver_error.caption', '重命名失败')
    .AddPair('messagebox_version.rename_ver_error.text', '重命名失败了，可能是LLL权限不足的原因，也有可能是该文件受保护，请取消后再试！')
    .AddPair('messagebox_version.is_delete_ver.caption', '是否删除该MC版本')
    .AddPair('messagebox_version.is_delete_ver.text', '由于该操作会直接删除{minecraft}\versions\{versionname}下的所有文件，且该操作不可逆。如果你开启了版本隔离，请确保你已经备份了该版本。该版本将会被彻底删除！是否继续？')
    .AddPair('messagebox_version.delete_ver_success.caption', '删除成功')
    .AddPair('messagebox_version.delete_ver_success.text', '删除成功！现在你必须重新从下载部分中下载该版本才能恢复了！')
    .AddPair('messagebox_version.delete_ver_error.caption', '删除失败')
    .AddPair('messagebox_version.delete_ver_error.text', '删除版本失败了，可能是LLL权限不足的原因，也有可能是该文件受保护，请取消后再试！')
    .AddPair('messagebox_version.cannot_find_vanilla_key.caption', '选择的版本内无JSON')
    .AddPair('messagebox_version.cannot_find_vanilla_key.text', '你选择的版本的文件夹里无JSON文件，如果是你误删了的话，请备份一次版本，重新去下载部分里下载一次吧！')
    .AddPair('messagebox_version.complete_version_success.caption', '补全文件成功')
    .AddPair('messagebox_version.complete_version_success.text', '补全文件成功了！现在该版本的资源是齐全的！')
    .AddPair('messagebox_export.cannot_find_vanilla_key.caption', '无法找到原版键')
    .AddPair('messagebox_export.cannot_find_vanilla_key.text', '无法找到原版的键值，请找到你的版本json文件，在里面的根对象中，新建一个键值对，键名是clientVersion，键值是【该版本的原版版本】。例如该版本是1.20.1-forge-47.1.0，则原版键值就是1.20.1。如果本身就是原版的话，就填写原版值即可！如果是快照版的话，也填入快照版的id即可！【例如1.20.3-pre2，填1.20.3-pre2即可！】')
    .AddPair('messagebox_export.not_choose_mode.caption', '暂未选择导出方式')
    .AddPair('messagebox_export.not_choose_mode.text', '你还暂未选择任一导出方式，请选择一个后再尝试！')
    .AddPair('messagebox_export.not_enter_name.caption', '暂未输入整合包名称')
    .AddPair('messagebox_export.not_enter_name.text', '你还暂未输入整合包名称，请输入后再尝试！')
    .AddPair('messagebox_export.not_enter_author.caption', '暂未输入整合包作者')
    .AddPair('messagebox_export.not_enter_author.text', '你还暂未输入整合包作者，请输入后再尝试！')
    .AddPair('messagebox_export.not_enter_version.caption', '暂未输入整合包版本')
    .AddPair('messagebox_export.not_enter_version.text', '你还暂未输入整合包版本，请输入后再尝试！')
    .AddPair('messagebox_export.update_link_error.caption', '整合包更新链接输入错误')
    .AddPair('messagebox_export.update_link_error.text', '整合包更新链接输入错误，请重新输入后再尝试！')
    .AddPair('messagebox_export.official_website_error.caption', '整合包官方网站输入错误')
    .AddPair('messagebox_export.official_website_error.text', '整合包官方网站输入错误，请重新输入后再尝试！')
    .AddPair('messagebox_export.authentication_server_error.caption', '整合包认证服务器输入错误')
    .AddPair('messagebox_export.authentication_server_error.text', '整合包认证服务器输入错误，请重新输入后再尝试！')
    .AddPair('messagebox_export.no_export_file.caption', '暂未选中任一导出文件')
    .AddPair('messagebox_export.no_export_file.text', '暂未选中任一导出文件，你必须至少选择一个文件后再进行导出，请重试！')
    .AddPair('savedialog_export.choose_export_path', '请选择整合包导出的保存路径')
    .AddPair('messagebox_export.export_file_exists.caption', '文件已存在')
    .AddPair('messagebox_export.export_file_exists.text', '你所选择的整合包导出路径已有一个相同文件名的文件，请删除或者重命名后再尝试！')
    .AddPair('messagebox_export.export_success.caption', '导出完成')
    .AddPair('messagebox_export.export_success.text', '你的整合包已导出完成，现在你可以去目录里面查看了！')
    .AddPair('messagebox_ipv6.choose_ip_timeout.caption', '超时IP不予选择')
    .AddPair('messagebox_ipv6.choose_ip_timeout.text', '你不能选择这个IP，因为这个IP在ping的时候超时了！')
    .AddPair('messagebox_ipv6.port_enter_error.caption', '端口输入错误')
    .AddPair('messagebox_ipv6.port_enter_error.text', '你的游戏端口输入错误啦！请输入1024~65536之间，并且只能为数字！')
    .AddPair('messagebox_ipv6.no_ipv6_choose.caption', '暂未选中任意IPv6地址')
    .AddPair('messagebox_ipv6.no_ipv6_choose.text', '暂未选中任意IPv6地址，请至少扫描一次后，选中任一IPv6地址再复制！')
    .AddPair('messagebox_ipv6.copy_link_success.caption', '复制成功')
    .AddPair('messagebox_ipv6.copy_link_success.text', '复制链接成功！现在你可以将链接发送给你的好友进行联机了！')
    .AddPair('messagebox_ipv6.online_tips.caption', 'IPv6联机提示')
    .AddPair('messagebox_ipv6.online_tips.text', Concat('亲爱的玩家：', #13#10,
            '这里你将体验到使用IPv6公网进行联机的功能。在此有以下几点要求：', #13#10,
            '1.你的电脑必须支持IPv6公网，这样才能检测得出公网地址。如果不支持，你需要去网上寻找教程来开启IPv6公网。', #13#10,
            '2.你的电脑网络环境必须要好，如果网络环境不好，那么再出色的联机方式也无力回天。', #13#10,
            '3.你必须对MC多人联机的机制有所了解，例如如何打开MC的多人联机，显示端口等。', #13#10,
            '4.此联机模式必须双方均拥有IPv6公网IP连接，如果有一方未有，则无法联机。', #13#10,
            '5.此功能必须在MC启动参数中不能有【-Djava.net.preferIPv4Stack=true】，如果必须有，则你需要联系该启动器作者将其删除。', #13#10,
            '6.或者，如果必须有以上参数，则你可以在启动器中设置额外JVM参数，复制上方参数，并将上方的true改为false即可。', #13#10,
            '点进联机部分，首先点击一次【开始检测IPv6公网IP】，如果有IPv6，则底下的列表框将会显示你目前所有IPv6地址。', #13#10,
            '如果列表框中一项也没有，则说明你没有IPv6地址，则参考第一点要求。', #13#10,
            '此时在列表框中随便点击一项IP【会有临时和永久的显示】', #13#10,
            '然后在文本框内输入你游戏内的端口号，此时下面的Label框会产生改变。', #13#10,
            '然后点击复制IPv6公网IP，此时IP会复制进剪切板，然后将IP地址发给你的好友 ', #13#10,
            '即可开始联机之旅！'))
    .AddPair('messagebox_account.area_not_chinese.caption', '国家地区不为中国')
    .AddPair('messagebox_account.area_not_chinese.text', '目前你的国家地区不为中国，你无法使用第三方外置登录，请使用微软登录！')
    .AddPair('messagebox_download.area_not_chinese.caption', '国家地区不为中国')
    .AddPair('messagebox_download.area_not_chinese.text', '目前你的国家地区不为中国，你无法使用除官方以外的任何下载源，请使用官方下载源！')
    .AddPair('messagebox_export.area_not_chinese.caption', '国家地区不为中国')
    .AddPair('messagebox_export.area_not_chinese.text', '目前你的国家地区不为中国，你无法使用MCBBS导出源，请使用MultiMC导出源！')
    .AddPair('messagebox_launcher.not_choose_mc_version.caption', '暂未选择MC版本')
    .AddPair('messagebox_launcher.not_choose_mc_version.text', '你还暂未选择任一MC版本，请去选择一个后再来吧！')
    .AddPair('messagebox_launcher.not_choose_java.caption', '暂未选择Java')
    .AddPair('messagebox_launcher.not_choose_java.text', '你还暂未选择任一Java，请去选择一个后再来吧！')
    .AddPair('messagebox_launcher.access_token_expire.caption', 'Access Token已过期')
    .AddPair('messagebox_launcher.access_token_expire.text', '你的Access Token已过期了，请去账号部分刷新一次账号或者重新登录一次吧！')
    .AddPair('messagebox_launcher.not_support_thirdparty.caption', '登录方式不支持')
    .AddPair('messagebox_launcher.not_support_thirdparty.text', '目前由于你并不处于中国地区，因此无法使用第三方外置登录启动游戏，你似乎导入成了别人的账号配置文件，请重试！')
    .AddPair('messagebox_launcher.not_support_login_type.caption', '不支持的登录方式')
    .AddPair('messagebox_launcher.not_support_login_type.text', '你使用了一种并不受支持的登录方式，你似乎修改了账号配置文件中的内容，请立即修改回来！')
    .AddPair('messagebox_launcher.not_choose_account.caption', '暂未选择账号')
    .AddPair('messagebox_launcher.not_choose_account.text', '你还暂未选择任一账号，请去选择一个后再来吧！')
    .AddPair('messagebox_launcher.cannot_find_json.caption', '未找到JSON错误')
    .AddPair('messagebox_launcher.cannot_find_json.text', '版本错误，未从版本文件夹中找到json文件！')
    .AddPair('messagebox_launcher.unzip_native_error.caption', '未能成功解压Natives文件夹')
    .AddPair('messagebox_launcher.unzip_native_error.text', '未能成功解压Natives文件夹，请将此报错上传给作者，同时请尝试使用别的启动器启动一次后再尝试用LLL启动器！')
    .AddPair('messagebox_launcher.cannot_set_launch_args.caption', '无法拼接启动参数')
    .AddPair('messagebox_launcher.cannot_set_launch_args.text', '你的版本JSON似乎有误，无法解析版本JSON文件，请重试！')
    .AddPair('messagebox_launcher.cannot_find_authlib_file.caption', '找不到Authlib-Injector文件')
    .AddPair('messagebox_launcher.cannot_find_authlib_file.text', '找不到Authlib-Injector文件，请进入账号部分重新下载一次！')
    .AddPair('messagebox_launcher.is_export_arguments.caption', '是否进行启动脚本导出')
    .AddPair('messagebox_launcher.is_export_arguments.text', '是否进行启动脚本导出？将导出至【{exe}\LLLauncher\LaunchArguments\args】目录下。')
    .AddPair('messagebox_launcher.is_hide_accesstoken.caption', '是否将AccessToken进行打码')
    .AddPair('messagebox_launcher.is_hide_accesstoken.text', '在此做个声明：如果你的登录方式为【微软登录/外置登录】，则请你慎重的考虑选择“否”不进行打码，因为AccessToken实在是太重要了，即使它只有24小时有效期。你绝对不可以将附有AccessToken启动令牌的启动参数随意发给别人！【ps：自然，如果选择否的话，则你后续将无法使用该启动脚本进行正版登录。】')
    .AddPair('messagebox_launcher.export_launch_args_success.caption', '导出成功')
    .AddPair('messagebox_launcher.export_launch_args_success.text', '启动参数导出成功！现在你可以去文件夹里查看了！')
    .AddPair('messagebox_launcher.args_put_success.caption', '参数拼接成功')
    .AddPair('messagebox_launcher.args_put_success.text', '参数拼接成功！是否立刻启动游戏？')
    .AddPair('messagebox_plugin.lose_content_value.caption', '缺失了某个必要值')
    .AddPair('messagebox_plugin.lose_content_value.text', '该插件于content中缺失了某个必要值，请尝试修改后再点击！')
    .AddPair('messagebox_plugin.lose_form_name.caption', '窗口缺少了name值')
    .AddPair('messagebox_plugin.lose_form_name.text', '该插件在窗口处缺失了name值，请尝试修改后再点击！')
    .AddPair('messagebox_plugin.plugin_grammar_error.caption', '窗口缺失了plugin_name值')
    .AddPair('messagebox_plugin.plugin_grammar_error.text', '该插件在窗口处缺失了plugin_name值，请尝试修改后再点击！')
    .AddPair('messagebox_manage.drag_modpack_only_one_file.caption', '无法拖入多个文件')
    .AddPair('messagebox_manage.drag_modpack_only_one_file.text', '无法在导入整合包的时候拖入多个文件，你只能拖入一个！')
    .AddPair('messagebox_manage.drag_modpack_format_error.caption', '整合包格式不符')
    .AddPair('messagebox_manage.drag_modpack_format_error.text', '拖入的整合包只允许【mrpack】或者【zip】后缀的文件，无法拖入别的！')
    .AddPair('messagebox_manage.cannot_unzip_modpack.caption', '解压整合包失败')
    .AddPair('messagebox_manage.cannot_unzip_modpack.caption', '解压整合包失败了！你似乎给整合包上了密码，或者这个整合包不是正确的整合包，请重试！')
    .AddPair('opendialog_export.add_icon', '请选择你要添加的图标')
    .AddPair('picturebox_manage.import_modrinth_modpack.text', Concat(
            '整合包类型：${modpack_game}', #13#10,
            '整合包名称：${modpack_name}', #13#10,
            '整合包版本：${modpack_version}', #13#10,
            '整合包简介：${modpack_summary}', #13#10,
            '-----------------------------------------------------------------------------------------------------------------------', #13#10,
            '整合包MC版本：${modpack_mcversion}', #13#10,
            '整合包模组加载器：${modpack_modloader}', #13#10,
            '整合包模组加载器版本：${modpack_modloader_version}', #13#10,
            '是否继续安装？点是即安装。'))
    .AddPair('messagebox_manage.read_config_error.caption', '读取配置文件失败！')
    .AddPair('messagebox_manage.read_config_error.text', '读取配置文件失败了！你似乎没有选中任意游戏文件夹或者Java，请去选中一个再来！')
    .AddPair('messagebox_manage.cannot_read_modloader_type.caption', '无法读取模组加载器')
    .AddPair('messagebox_manage.cannot_read_modloader_type.text', '你在导入整合包的时候，选择了不受支持的模组加载器。如果你非要玩这个整合包，请使用别的启动器导入一次吧！')
    .AddPair('picturebox_manage.import_multimc_modpack.text', Concat(
            '整合包类型：${modpack_game}', #13#10,
            '整合包名称：${modpack_name}', #13#10,
            '整合包简介：${modpack_summary}', #13#10,
            '-----------------------------------------------------------------------------------------------------------------------', #13#10,
            '整合包MC版本：${modpack_mcversion}', #13#10,
            '整合包模组加载器：${modpack_modloader}', #13#10,
            '整合包模组加载器版本：${modpack_modloader_version}', #13#10,
            '是否继续安装？点是即安装。'))
    .AddPair('picturebox_manage.import_mcbbs_modpack.text', Concat(
            '整合包类型：${modpack_game}', #13#10,
            '整合包名称：${modpack_name}', #13#10,
            '整合包版本：${modpack_version}', #13#10,
            '整合包作者：${modpack_author}', #13#10,
            '整合包简介：${modpack_summary}', #13#10,
            '整合包更新链接：${modpack_update_url}', #13#10,
            '整合包官方网站：${modpack_official_url}', #13#10,
            '整合包外置登录服务器官网：${modpack_server}', #13#10,
            '-----------------------------------------------------------------------------------------------------------------------', #13#10,
            '整合包MC版本：${modpack_mcversion}', #13#10,
            '整合包模组加载器：${modpack_modloader}', #13#10,
            '整合包模组加载器版本：${modpack_modloader_version}', #13#10,
            '是否继续安装？点是即安装。'))
    .AddPair('messagebox_manage.not_support_modpack_type.caption', '不受支持的整合包格式！')
    .AddPair('messagebox_manage.not_support_modpack_type.text', '在你导入的这个整合包中，并不存在modrinth.index.json、manifest.json、mcbbs.packmeta、mmc-pack.json中的任意一个，请重新下载你的整合包并重试！【或者直接解压缩至versions文件夹中也行。】')
    .AddPair('picturebox_manage.import_curseforge_modpack.text', Concat(
            '整合包类型：${modpack_game}', #13#10,
            '整合包名称：${modpack_name}', #13#10,
            '整合包版本：${modpack_version}', #13#10,
            '整合包作者：${modpack_author}', #13#10,
            '-----------------------------------------------------------------------------------------------------------------------', #13#10,
            '整合包MC版本：${modpack_mcversion}', #13#10,
            '整合包模组加载器：${modpack_modloader}', #13#10,
            '整合包模组加载器版本：${modpack_modloader_version}', #13#10,
            '是否继续安装？点是即安装。'))
    .AddPair('messagebox_manage.import_modpack_success.caption', '安装整合包成功！')
    .AddPair('messagebox_manage.import_modpack_success.text', '恭喜安装整合包成功了！现在你可以去玩了！')
    .AddPair('messagebox_open.is_open_document.caption', '第一次打开启动器')
    .AddPair('messagebox_open.is_open_document.text', '已检测出你目前是第一次打开该启动器，请问是否打开新手帮助文档来查看一些设置应该怎么设置？')
    .AddPair('messagebox_plugin.plugin_suffix_error.caption', '插件部分加载失败')
    .AddPair('messagebox_plugin.plugin_suffix_error.text', '插件部分检测到suffix值。但是似乎suffix值不是json，于是加载失败啦！')
    .AddPair('messagebox_plugin.plugin_context_error.caption', '插件部分加载失败')
    .AddPair('messagebox_plugin.plugin_context_error.text', '插件部分检测内容为空，加载失败！')
    .AddPair('picturebox_manage.check_mod_info_fabric.text', Concat(
            '模组隶属加载器：${mod_game}',
            '模组ID：${mod_id}',
            '模组版本：${mod_version}',
            '模组名称：${mod_name}'
    ))
    //以下为下载进度列表框
    .AddPair('label_progress_download_progress.caption', '下载进度：${download_progress}% | ${download_current_count}/${download_all_count}')
    .AddPair('downloadlist.custom.judge_can_multi_thread_download', '正在判断是否可以多线程下载。')
    .AddPair('downloadlist.custom.url_donot_support_download_in_launcher', '该网址不支持启动器下载，请使用浏览器下载吧！')
    .AddPair('downloadlist.custom.input_url_error_and_this_url_doesnot_has_file', '网址输入错误，该网址下无任何文件。')
    .AddPair('downloadlist.custom.url_statucode_is_not_206_and_try_to_cut', '该网站请求代码不为206，正在对其进行分段……')
    .AddPair('downloadlist.custom.not_allow_cut_use_single_thread_download', '该网站不允许分段下载，已用单线程将该文件下载下来。')
    .AddPair('downloadlist.custom.url_allow_multi_thread_download', '该网站支持多线程下载！')
    .AddPair('downloadlist.custom.url_file_size', '文件长度：${url_file_size}')
    .AddPair('downloadlist.custom.thread_one_to_single_thread_download', '由于你选择的线程是单线程，现在将直接采取单线程的下载方式。')
    .AddPair('downloadlist.custom.single_thread_download_error', '单线程下载失败，请重试。')
    .AddPair('downloadlist.custom.cut_download_error', '分段下载已下载失败，请重试！')
    .AddPair('downloadlist.custom.cut_download_success', '分段下载已下载完成：${cut_download_count}')
    .AddPair('downloadlist.custom.cut_download_join_error', '已检测出文件下载并不完整，下载失败！')
    .AddPair('downloadlist.custom.download_finish', '下载已完成！耗时：${download_finish_time}秒。')
    .AddPair('downloadlist.judge.judge_source_official', '已检测出你的下载源为：官方')
    .AddPair('downloadlist.judge.judge_source_bmclapi', '已检测出你的下载源为：BMCLAPI')
    .AddPair('downloadlist.mc.json_has_inheritsfrom', '你下载的版本json有inheritsFrom键')
    .AddPair('downloadlist.mc.get_vanilla_json_error', '获取原版MC版本失败')
    .AddPair('downloadlist.mc.get_vanilla_json_success', '获取原版MC版本成功')
    .AddPair('downloadlist.mc.get_version_json_error', '获取MC版本JSON失败')
    .AddPair('downloadlist.mc.get_version_json_success', '获取MC版本JSON成功')
    .AddPair('downloadlist.mc.mc_vanilla_id_not_found', '未能找到JSON中的原版键值，下载失败！')
    .AddPair('downloadlist.mc.downloading_main_version_jar', '正在下载主版本jar文件')
    .AddPair('downloadlist.mc.download_main_version_jar_finish', '主版本jar文件下载完成')
    .AddPair('downloadlist.mc.main_version_jar_exists', '已存在主版本jar文件')
    .AddPair('downloadlist.mc.downloading_asset_index_json', '正在下载资源索引JSON文件')
    .AddPair('downloadlist.mc.downloading_asset_index_error', '下载资源索引JSON文件时网络错误，请重试……')
    .AddPair('downloadlist.mc.download_asset_index_finish', '资源索引JSON文件下载完成')
    .AddPair('downloadlist.mc.asset_index_json_exists', '已存在资源索引JSON文件')
    .AddPair('downloadlist.mc.current_download_library', '正在下载资源库文件，请保持网络通畅，并且时刻注意进度条。')
    .AddPair('downloadlist.mc.download_library_success', '下载MC库文件成功，现在开始下载资源文件。')
    .AddPair('downloadlist.mc.download_assets_success', '下载MC资源文件成功，现在开始判断下载的是否为forge。')
    .AddPair('downloadlist.mc.judge_download_forge', '已在version文件夹中找到install_profile.json，判断你下载的是Forge。')
    .AddPair('downloadlist.mc.download_mc_finish', '下载MC已完成，耗时：${download_finish_time}秒。')
    .AddPair('downloadlist.window.file_is_exists', '已存在：${file_exists_name}')
    .AddPair('downloadlist.window.download_error_retry', '下载失败，正在重试：${file_error_name}')
    .AddPair('downloadlist.window.switch_download_source', '正在切换下载源：${source_name}')
    .AddPair('downloadlist.window.retry_threetime_error', '重试3次后依旧失败，下载失败！')
    .AddPair('downloadlist.window.download_success', '下载成功：${file_success_name}')
    .AddPair('downloadlist.backup.backup_success', '已备份：${backup_file_name}')
    .AddPair('downloadlist.backup.backup_error', '备份失败：${backup_file_name}')
    .AddPair('downloadlist.java.download_java_finish', '下载Java已完成，耗时${download_finish_time}秒。')
    .AddPair('downloadlist.forge.forge_version_not_allow_install', '该版本的forge不允许自动安装，请重试……')
    .AddPair('downloadlist.forge.download_forge_installer_start', '正在下载Forge安装器jar中。')
    .AddPair('downloadlist.forge.download_forge_installer_success', '下载Forge安装器jar成功。')
    .AddPair('downloadlist.forge.unzip_installer_error', '安装器jar解压缩失败，请重试！')
    .AddPair('downloadlist.forge.cannot_find_version_json', '未能从安装器jar中解包找到version.json，该版本不支持forge自动安装。')
    .AddPair('downloadlist.forge.get_forge_json', '已提取出version.json，正在下载原版MC。')
    .AddPair('downloadlist.forge.cannot_find_installprofile_json', '未能从安装器jar中解包找到install_profile.json，该版本不支持forge自动安装。')
    .AddPair('downloadlist.forge.cannot_fine_versioninfo_profile', '未能在install_profile.json中找到特需库下载，请重试！')
    .AddPair('downloadlist.forge.current_download_library', '正在下载Forge必要库文件。')
    .AddPair('downloadlist.forge.copy_installprofile_success_setup_mc', '已在安装包中找到install_profile，现在开始下载！')
    .AddPair('downloadlist.forge.installer_version_lower', '由于你安装的forge版本过低，因此无需跑forge处理器。')
    .AddPair('downloadlist.forge.cannot_extra_lzma', '无法提取出lzma文件，也许是因为你要下载的Forge版本过低了。')
    .AddPair('downloadlist.forge.start_run_processors', '现在正在开始用单线程跑Forge处理器中……')
    .AddPair('downloadlist.forge.not_choose_any_java', '你暂未选中任何一个Java，无法跑Forge处理器，请重试！')
    .AddPair('downloadlist.forge.skip_processors', '已跳过：${processors_count}')
    .AddPair('downloadlist.forge.run_processors_error', '运行失败：${processors_count}')
    .AddPair('downloadlist.forge.run_processors_success', '已完成：${processors_count}')
    .AddPair('downloadlist.forge.download_forge_success', '下载Forge已完成，耗时：${download_finish_time}秒')
    .AddPair('downloadlist.forge.cannot_extra_miencraft_jar', '无法检测出Minecraft原版Jar包，请将此错误反馈给作者！')
    .AddPair('downloadlist.authlib.check_authlib_update', '正在检查Authlib-Injector是否有更新')
    .AddPair('downloadlist.authlib.check_authlib_error', '检测Authlib失败，请重试。')
    .AddPair('downloadlist.authlib.authlib_has_update', '已检测出Authlib更新，正在下载')
    .AddPair('downloadlist.authlib.download_authlib_error', 'Authlib-Injector下载失败，请重试！')
    .AddPair('downloadlist.authlib.downlaod_authlib_success', 'Authlib-Injector下载成功！')
    .AddPair('downloadlist.resource.start_download', '正在下载该资源……')
    .AddPair('downloadlist.resource.download_success', '资源下载已完成')
    .AddPair('downloadlist.java.get_java_metadata', '正在获取Java总元数据中……')
    .AddPair('downloadlist.java.get_java_metadata_error', '获取Java元数据失败！你似乎没有联网。请重试。')
    .AddPair('downloadlist.java.get_java_manifest', '正在获取Java(${java_version})(64)版本元数据中……')
    .AddPair('downloadlist.java.get_java_manifest_error', '由于未知原因，获取Java(${java_version})(64)版本元数据失败！')
    .AddPair('downloadlist.java.get_java_success', '获取Java所有的元数据成功！现在开始下载！')
    .AddPair('downloadlist.java.download_java_success', '下载Java成功！现在你可以通过特定扫描来找到Java了。')
    .AddPair('downloadlist.download.start_download', '已检测出你想要的下载是：${version}，下载源：${source}')
    .AddPair('downloadlist.download.get_fabric_metadata_error', '在读取Fabric的元数据时出现错误，你似乎没有联网，请重试！')
    .AddPair('downloadlist.download.fabric_metadata_download_success', '下载Fabric元数据成功！现在开始下载MC')
    .AddPair('downloadlist.download.get_quilt_metadata_error', '在读取Quilt的元数据时出现错误，你似乎没有联网，请重试！')
    .AddPair('downloadlist.download.quilt_metadata_download_success', '下载Quilt元数据成功！现在开始下载MC')
    .AddPair('downloadlist.download.get_mc_metadata', '正在开始下载MC元数据')
    .AddPair('downloadlist.download.get_mc_metadata_error', '获取MC元数据失败，请重试！')
    .AddPair('downloadlist.download.mc_metadata_download_success', '获取MC元数据成功，开始下载MC！')
    .AddPair('downloadlist.customdl.start_custom_download', '正在下载自定义文件……')
    .AddPair('downloadlist.modloader.download_success', '下载模组加载器手动安装包完成！现在可以去文件夹中查看了！')
    .AddPair('downloadlist.version.get_complete_version', '正在补全该版本的资源索引……')
    .AddPair('downloadlist.version.complete_version_success', '补全资源完成！')
    .AddPair('downloadlist.modpack.download_modpack_start', '正在下载整合包中……')
    .AddPair('downloadlist.source.download_failure', '下载失败，请重试！')
    //以下为下载进度窗口
    .AddPair('button_progress_hide_show_details.caption.show', '显示详情')
    .AddPair('button_progress_hide_show_details.caption.hide', '隐藏详情')
    .AddPair('button_progress_clean_download_list.caption', '清空下载信息列表框')
    .AddPair('label_progress_tips.caption', '一旦开始下载就停止不了了！')
    //以下为主窗口
    .AddPair('groupbox_message_board.caption', '留言板（点我可以更换留言板噢！）')
    .AddPair('label_account_view.caption.absence', '你还暂未登录任何一个账号，登录后即可在这里查看欢迎语！')
    .AddPair('label_account_view.caption.have', '你好啊：${account_view}，祝你有个愉快的一天！')
    .AddPair('label_open_launcher_time.caption', '打开启动器时间：${open_launcher_time}')
    .AddPair('label_open_launcher_number.caption', '打开启动器次数：${open_launcher_number}')
    .AddPair('label_launch_game_number.caption', '启动游戏的次数：${launch_game_number}')
    .AddPair('button_launch_game.caption.error.cannot_find_json', '（错误，未找到JSON）')
    .AddPair('button_launch_game.caption.error.missing_inherits_version', '（错误，缺少前置版本）')
    .AddPair('button_launch_game.caption.isolation', '（独立）')
    .AddPair('button_launch_game.caption.absence', Concat('开始游戏', #13#10, '你还暂未选中一个版本哦！'))
    .AddPair('button_launch_game.caption', Concat('开始游戏', #13#10, '${launch_version_name}'))
    .AddPair('button_launch_game.hint', '开始玩MC！')
    .AddPair('image_refresh_background_image.hint', '刷新你的背景图片')
    .AddPair('image_refresh_background_music.hint', '刷新你的背景音乐')
    .AddPair('image_open_download_prograss.hint', '打开下载进度界面')
    .AddPair('image_exit_running_mc.hint', '调用taskkill函数，强制结束你当前正在运行的MC')
    //以下为背景设置
    .AddPair('label_background_tip.caption', '这里是背景部分，你可以选择自己喜欢的背景颜色【说实话只是边框而已啦……】')
    .AddPair('label_standard_color.caption', '这里是标准配色，按一下直接应用')
    .AddPair('button_grass_color.caption', '小草绿')
    .AddPair('button_sun_color.caption', '日落黄')
    .AddPair('button_sultan_color.caption', '苏丹红')
    .AddPair('button_sky_color.caption', '天空蓝')
    .AddPair('button_cute_color.caption', '可爱粉')
    .AddPair('button_normal_color.caption', '默认白')
    .AddPair('button_custom_color.caption', '自定义配色')
    .AddPair('label_background_window_alpha.caption', '设置窗口透明度【只允许127~255，因为过低会导致启动器不见】')
    .AddPair('label_background_window_current_alpha.caption', '当前选中：${window_alpha}')
    .AddPair('label_background_control_alpha.caption', '设置控件透明度【只允许63~191，因为过高会导致背景图片不见，过低会导致控件不见】')
    .AddPair('label_background_control_current_alpha.caption', '当前选中：${control_alpha}')
    .AddPair('groupbox_background_music_setting.caption', '背景音乐设置')
    .AddPair('button_background_play_music.caption', '播放音乐')
    .AddPair('button_background_play_music.hint', '手动播放上被挂起与已经放完的音乐，如果未点主界面刷新音乐则会重新随机播放一次。')
    .AddPair('button_background_pause_music.caption', '暂停音乐')
    .AddPair('button_background_pause_music.hint', '点此只是会将音乐暂停，点击播放音乐后将会按照上次暂停时长接着播放。')
    .AddPair('button_background_stop_music.caption', '停止音乐')
    .AddPair('button_background_stop_music.hint', '点此会记录下mp3文件名，再点击播放音乐时会从头播放。')
    .AddPair('radiobutton_background_music_open.caption', '打开启动器时播放')
    .AddPair('radiobutton_background_music_launch.caption', '启动游戏时播放')
    .AddPair('radiobutton_background_music_not.caption', '不自动播放')
    .AddPair('groupbox_background_launch_setting.caption', '启动游戏设置部分')
    .AddPair('radiobutton_background_launch_hide.caption', '启动MC时隐藏窗口')
    .AddPair('radiobutton_background_launch_show.caption', '启动MC时显示窗口')
    .AddPair('radiobutton_background_launch_exit.caption', '启动MC时退出窗口')
    .AddPair('label_background_mainform_title.caption', '设置启动器标题')
    .AddPair('groupbox_background_gradient.caption', '窗口渐变产生')
    .AddPair('toggleswitch_background_gradient.on.caption', '开启渐变')
    .AddPair('toggleswitch_background_gradient.off.caption', '关闭渐变')
    .AddPair('label_background_gradient_value.caption', '渐变值')       
    .AddPair('label_background_gradient_current_value.caption', '当前选中：${gradient_value}')
    .AddPair('label_background_gradient_step.caption', '渐变步长')
    .AddPair('label_background_gradient_current_step.caption', '当前选中：${gradient_step}')
    //以下为账号部分
    .AddPair('combobox_all_account.offline_tip', '（离线）')
    .AddPair('combobox_all_account.microsoft_tip', '（微软）')
    .AddPair('combobox_all_account.thirdparty_tip', '（外置）')
    .AddPair('label_login_avatar.caption', '登录头像')
    .AddPair('label_all_account.caption', '所有账号')
    .AddPair('groupbox_offline_skin.caption', '切换离线皮肤（仅修改UUID项）【仅支持22w45a以上】')
    .AddPair('label_offline_name.caption', '名称')
    .AddPair('edit_offline_name.texthint', '请输入离线模式昵称')
    .AddPair('label_offline_uuid.caption', 'UUID')
    .AddPair('edit_offline_uuid.texthint', '输入32位16进制的UUID【可以留空，留空则随机生成一个UUID】')
    .AddPair('button_offline_name_to_uuid.caption', '通过正版用户名获取正版UUID')
    .AddPair('button_offline_uuid_to_name.caption', '通过正版UUID获取正版用户名')
    .AddPair('button_microsoft_oauth_login.caption', 'OAuth验证流登录')
    .AddPair('label_thirdparty_server.caption', '服务器')
    .AddPair('label_thirdparty_account.caption', '账号')
    .AddPair('label_thirdparty_password.caption', '密码')
    .AddPair('button_thirdparty_check_authlib_update.caption', '检测Authlib是否有更新')
    .AddPair('button_add_account.caption', '添加账号')
    .AddPair('button_delete_account.caption', '删除账号')
    .AddPair('button_refresh_account.caption', '刷新账号')
    .AddPair('button_account_get_uuid.caption', '查看账号UUID')
    .AddPair('label_account_return_value.caption.not_login', '未登录。')
    .AddPair('label_account_return_value.caption.logined', '已登录，玩家名称：${player_name}')
    .AddPair('label_account_return_value.caption.offline_get_avatar', '正在尝试根据离线UUID获取正版用户大头像……')
    .AddPair('label_account_return_value.caption.add_offline_success', '添加成功！已通过UUID获取离线皮肤！')
    .AddPair('label_account_return_value.caption.thirdparty_cannot_get_metadata', '外置登录添加失败，请重试。')
    .AddPair('label_account_return_value.caption.thirdparty_cannot_refresh_skin', '重置外置登录时失败，也许官网皮肤已被删除。')
    .AddPair('label_account_return_value.caption.thirdparty_unknown_error', '在登录时发生了未知错误，请重试！')
    .AddPair('label_account_return_value.caption.thirdparty_accesstoken_invalid', '你的登录令牌已经失效，请尝试重新登录一次吧！')
    .AddPair('label_account_return_value.caption.thirdparty_username_or_password_nottrue', '外置登录时，邮箱或密码输入错误。')
    .AddPair('label_account_return_value.caption.thirdparty_not_choose_skin', '暂未在皮肤站中选取任意一个角色。')
    .AddPair('label_account_return_value.caption.add_account_success_and_get_avatar', '添加完毕账号，现在开始获取皮肤大头像。')
    .AddPair('label_account_return_value.caption.thirdparty_entry_other_char', '选择角色时输入错误的字符。')
    .AddPair('label_account_return_value.caption.thirdparty_login_start', '正在添加外置登录……')
    .AddPair('label_account_return_value.caption.connect_error', '由于网络原因添加失败，请重试！')
    .AddPair('label_account_return_value.caption.add_thirdparty_success', '添加成功！已通过外置登录成功添加！')
    .AddPair('label_account_return_value.caption.microsoft_not_complete_oauth_login', '登录失败，暂未完成登录。')
    .AddPair('label_account_return_value.caption.microsoft_login_timeout', '登录失败，登录超时。')
    .AddPair('label_account_return_value.caption.microsoft_refresh_expire', '重置失败，刷新密钥同样过期，请重新登录一次账号。')
    .AddPair('label_account_return_value.caption.microsoft_uhs_not_same', '登录失败，xbox与xsts获取的uhs不一致。')
    .AddPair('label_account_return_value.caption.get_oauth_user_code', '正在获取用户代码')
    .AddPair('label_account_return_value.caption.post_microsoft', '正在请求microsoft中……')
    .AddPair('label_account_return_value.caption.post_xbox', '请求完毕microsoft，正在请求xbox中……')
    .AddPair('label_account_return_value.caption.post_xsts', '请求完毕xbox，正在请求xsts中……')
    .AddPair('label_account_return_value.caption.post_mc', '请求完毕xsts，正在请求mc中……')
    .AddPair('label_account_return_value.caption.get_has_mc', '请求完毕xsts，正在请求mc中……')
    .AddPair('label_account_return_value.caption.microsoft_get_avatar', '获取游戏成功，现在正在获取用户大头像中……')
    .AddPair('label_account_return_value.caption.not_buy_mc', '登录失败，您暂未拥有游戏。')
    .AddPair('label_account_return_value.caption.cannot_get_user_code', '未能获取用户代码，登录失败。')
    .AddPair('label_account_return_value.caption.add_microsoft_success', '添加成功！已通过微软登录成功添加！')
    .AddPair('label_account_return_value.caption.check_authlib_update', '正在检查Authlib是否有更新。')
    .AddPair('label_account_return_value.caption.check_authlib_error', '检测Authlib更新失败。')
    .AddPair('label_account_return_value.caption.check_authlib_success', '检测Authlib完毕，你的Authlib是最新的啦！')
    .AddPair('label_account_return_value.caption.refresh_microsoft_start', '正在重置微软账号……')
    .AddPair('label_account_return_value.caption.refresh_microsoft_error', '重置微软失败，RefreshToken也已过期，请尝试登录吧。')
    .AddPair('label_account_return_value.caption.refresh_thirdparty_start', '正在重置外置账号……')
    .AddPair('label_account_return_value.caption.refresh_thirdparty_error', '重置外置失败，RefreshToken也已过期，请尝试登录吧。')
    .AddPair('label_account_return_value.caption.name_to_uuid_start', '正在通过正版用户名获取正版账号的UUID')
    .AddPair('label_account_return_value.caption.name_to_uuid_error', '该用户不存在。')
    .AddPair('label_account_return_value.caption.name_to_uuid_success', '获取成功，UUID已正确填写在栏中！')
    .AddPair('label_account_return_value.caption.uuid_to_name_start', '正在通过正版UUID获取正版账号用户名')
    .AddPair('label_account_return_value.caption.uuid_to_name_error', '该用户不存在。')
    .AddPair('label_account_return_value.caption.uuid_to_name_success', '获取成功，名称已正确填写在栏中！')
    //以下是资源部分
    .AddPair('label_resource_tip.caption', '此部分用于下载MC的附加资源，建议每次搜新资源时，都右击一次搜索版本框查看简介噢！')
    .AddPair('label_resource_search_name_tip.caption', '搜索名称')
    .AddPair('edit_resource_search_name.texthint', '输入搜索名称【只能输入英文】')
    .AddPair('label_resource_search_source_tip.caption', '搜索源')
    .AddPair('label_resource_search_mode_tip.caption', '搜索方式')
    .AddPair('label_resource_search_category_curseforge_tip.caption', '搜索类型（Curseforge）')
    .AddPair('label_resource_search_version_tip.caption', '搜索版本')
    .AddPair('label_resource_search_category_modrinth_tip.caption', '搜索类型（Modrinth）')
    .AddPair('label_resource_return_value.caption.get_curseforge_start', '正在获取Curseforge资源')
    .AddPair('label_resource_return_value.caption.get_modrinth_start', '正在获取Modrinth资源')
    .AddPair('button_resource_name_previous_page.caption', '名称（上一页）')
    .AddPair('button_resource_name_next_page.caption', '名称（下一页）')
    .AddPair('button_resource_version_previous_page.caption', '版本（上一页）')
    .AddPair('button_resource_version_next_page.caption', '版本（下一页）')
    .AddPair('button_open_download_website.caption', '打开下载源官网')
    .AddPair('button_resource_start_search.caption', '开始搜索')
    .AddPair('button_resource_start_download.caption', '开始下载')
    .AddPair('combobox_resource_search_version.item.all', '全部')
    .AddPair('combobox_resource_search_mode.item.curseforge.all', '全部')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins', 'Bukkit插件')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.admin_tools', 'Admin Tools')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.anti-griefing_tools', 'Anti-Griefing Tools')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.chat_related', 'Chat Related')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.developed_tools', 'Developer Tools')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.economy', 'Economy')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.world_editing_and_management', 'World Editing and Management')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.fixes', 'Fixes')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.fun', 'Fun')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.general', 'General')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.informational', 'Informational')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.mechanics', 'Mechanics')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.website_administration', 'Website Administration')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.world_generators', 'World Generators')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.role_resource', 'Role resource')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.miscellaneous', 'Miscellaneous')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.teleportation', 'Teleportation')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.twitch_integration', 'Twitch Integration')
    .AddPair('combobox_resource_search_mode.item.curseforge_modpacks', '整合包')
    .AddPair('combobox_resource_search_mode.item.curseforge_modpacks.tech', 'Tech')
    .AddPair('combobox_resource_search_mode.item.curseforge_modpacks.magic', 'Magic')
    .AddPair('combobox_resource_search_mode.item.curseforge_modpacks.sci-fi', 'Sci-fi')
    .AddPair('combobox_resource_search_mode.item.curseforge_modpacks.adventure_and_rpg', 'Adventure and RPG')
    .AddPair('combobox_resource_search_mode.item.curseforge_modpacks.exploration', 'Exploration')
    .AddPair('combobox_resource_search_mode.item.curseforge_modpacks.mini_game', 'Mini Game')
    .AddPair('combobox_resource_search_mode.item.curseforge_modpacks.quests', 'Quests')
    .AddPair('combobox_resource_search_mode.item.curseforge_modpacks.hardcore', 'Hardcore')
    .AddPair('combobox_resource_search_mode.item.curseforge_modpacks.map_based', 'Map Based')
    .AddPair('combobox_resource_search_mode.item.curseforge_modpacks.small_/_light', 'Small / Light')
    .AddPair('combobox_resource_search_mode.item.curseforge_modpacks.extra_large', 'Extra Large')
    .AddPair('combobox_resource_search_mode.item.curseforge_modpacks.combat_/_pvp', 'Combat / PVP')
    .AddPair('combobox_resource_search_mode.item.curseforge_modpacks.multiplayer', 'Multiplayer')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods', '模组')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.biomes', 'Biomes')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.ores_and_resources', 'Ores and Resources')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.structures', 'Structures')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.dimensions', 'Dimensions')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.mobs', 'Mobs')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.processing', 'Processing')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.player_transport', 'Player Transport')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.energy,_fluid,_and_item_transport', 'Energy Fluid, and Item Transport')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.farming', 'Farming')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.energy', 'Energy')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.genetics', 'Genetics')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.automation', 'Automation')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.magic', 'Magic')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.storage', 'Storage')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.api_and_library', 'API and Library')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.adventure_and_rpg', 'Adventure and RPG')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.map_and_information', 'Map and Information')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.cosmetic', 'Cosmetic')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.miscellaneous', 'Miscellaneous')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.thermal_expansion', 'Thermal Expansion')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.tinker''_s_construct', 'Tkinter''s Construct')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.industrial_craft', 'Industrial Craft')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.thaumcraft', 'Thaumcraft')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.buildcraft', 'Buildcraft')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.forestry', 'Forestry')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.blood_magic', 'Blood Magic')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.applied_energistics_2', 'Applied Energistics 2')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.craftTweaker', 'CraftTweater')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.galacticraft', 'Galacticraft')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.kubeJS', 'KubeJS')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.skyblock', 'Skyblock')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.armor,_tools,_and_weapons', 'Armor, Tools and Weapons')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.server_utility', 'Server Utility')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.food', 'Food')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.redstone', 'Redstone')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.twitch_integration', 'Twitch Integration')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.mCreator', 'MCreator')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.utility_&_qoL', 'Utility & QoL')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.education', 'Education')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks', '纹理')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks.16x', '16x')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks.32x', '32x')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks.64x', '64x')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks.128x', '128x')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks.256x', '256x')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks.512x', '512x')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks.steampunk', 'Steampunk')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks.photo_realistic', 'Photo Realistic')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks.modern', 'Modern')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks.medieval', 'Medieval')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks.traditional', 'Traditional')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks.animated', 'Animated')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks.miscellaneous', 'Miscellaneous')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks.mod_support', 'Mod Support')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks.data_packs', 'Data Packs')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks.font_packs', 'Font Packs')
    .AddPair('combobox_resource_search_mode.item.curseforge_worlds', '地图')
    .AddPair('combobox_resource_search_mode.item.curseforge_worlds.adventure', 'Adventure')
    .AddPair('combobox_resource_search_mode.item.curseforge_worlds.creation', 'Creation')
    .AddPair('combobox_resource_search_mode.item.curseforge_worlds.game_map', 'Game Map')
    .AddPair('combobox_resource_search_mode.item.curseforge_worlds.parkour', 'Parkour')
    .AddPair('combobox_resource_search_mode.item.curseforge_worlds.puzzle', 'Puzzle')
    .AddPair('combobox_resource_search_mode.item.curseforge_worlds.survival', 'Survival')
    .AddPair('combobox_resource_search_mode.item.curseforge_worlds.modded_world', 'Modded World')
    .AddPair('combobox_resource_search_mode.item.curseforge_addons', '附加包')
    .AddPair('combobox_resource_search_mode.item.curseforge_addons.resource_packs', 'Resource Packs')
    .AddPair('combobox_resource_search_mode.item.curseforge_addons.scenarios', 'Scenarios')
    .AddPair('combobox_resource_search_mode.item.curseforge_addons.worlds', 'Worlds')
    .AddPair('combobox_resource_search_mode.item.curseforge_customization', '自定义')
    .AddPair('combobox_resource_search_mode.item.curseforge_customization.configuration', 'Configuration')
    .AddPair('combobox_resource_search_mode.item.curseforge_customization.fancyMenu', 'FancyMenu')
    .AddPair('combobox_resource_search_mode.item.curseforge_customization.guidebook', 'Guidebook')
    .AddPair('combobox_resource_search_mode.item.curseforge_customization.quests', 'Quests')
    .AddPair('combobox_resource_search_mode.item.curseforge_customization.scripts', 'Scripts')
    .AddPair('combobox_resource_search_mode.item.curseforge_shader', '光影')
    .AddPair('combobox_resource_search_mode.item.curseforge_shaders.fantasy', 'Fantasy')
    .AddPair('combobox_resource_search_mode.item.curseforge_shaders.realistic', 'Realistic')
    .AddPair('combobox_resource_search_mode.item.curseforge_shaders.vanilla', 'Vanilla')
    .AddPair('combobox_resource_search_mode.item.modrinth.all', '全部')
    .AddPair('combobox_resource_search_mode.item.modrinth_mods', '模组')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.adventure', 'Adventure')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.cursed', 'Cursed')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.decoration', 'Decoration')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.economy', 'Economy')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.equipment', 'Equipment')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.food', 'Food')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.game_mechanics', 'Game Mechanics')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.library', 'Library')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.magic', 'Magic')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.management', 'Management')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.minigame', 'Minigame')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.mobs', 'Mobs')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.optimization', 'Optimization')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.social', 'Social')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.storage', 'Storage')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.technology', 'Technology')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.transportation', 'Transportation')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.utility', 'Utility')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.world_generation', 'World Generation')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.fabric', 'Fabric')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.forge', 'Forge')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.liteLoader', 'Liteloader')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.risugami_s_modLoader', 'Risugami''s ModLoader')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.neoForge', 'NeoForge')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.quilt', 'Quilt')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.rift', 'Rift')
    .AddPair('combobox_resource_search_mode.item.modrinth_plugins', '插件')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.adventure', 'Adventure')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.cursed', 'Cursed')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.decoration', 'Decoration')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.economy', 'Economy')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.equipment', 'Equipment')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.food', 'Food')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.game_mechanics', 'Game Mechanics')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.library', 'Library')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.magic', 'Magic')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.management', 'Management')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.minigame', 'Minigame')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.mobs', 'Mobs')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.optimization', 'Optimization')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.social', 'Social')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.storage', 'Storage')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.technology', 'Technology')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.transportation', 'Transportation')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.utility', 'Utility')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.world_generation', 'World Generation')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.bukkit', 'Bukkit')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.folia', 'Folia')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.paper', 'Paper')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.purpur', 'Purpur')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.spigot', 'Spigot')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.sponge', 'Sponge')
    .AddPair('combobox_resource_search_mode.item.modrinth_data_packs', '数据包')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.adventure', 'Adventure')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.cursed', 'Cursed')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.decoration', 'Decoration')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.economy', 'Economy')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.equipment', 'Equipment')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.food', 'Food')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.game_mechanics', 'Game Mechanics')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.library', 'Library')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.magic', 'Magic')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.management', 'Management')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.minigame', 'Minigame')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.mobs', 'Mobs')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.optimization', 'Optimization')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.social', 'Social')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.storage', 'Storage')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.technology', 'Technology')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.transportation', 'Transportation')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.utility', 'Utility')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.world_generation', 'World Generation')
    .AddPair('combobox_resource_search_mode.item.modrinth_shaders', '光影')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.cartoon', 'Cartoon')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.cursed', 'Cursed')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.fantasy', 'Fantasy')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.realistic', 'Realistic')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.semi-realistic', 'Semi-Realistic')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.vanilla-like', 'Vanilla-Like')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.atomsphere', 'Atomsphere')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.bloom', 'Bloom')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.colored_light', 'Colored Light')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.foliage', 'Foliage')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.path_tracing', 'Path Tracing')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.PBR', 'PBR')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.reflections', 'Reflections')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.shadows', 'Shadows')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.potato', 'Potato')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.low', 'Low')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.medium', 'Medium')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.high', 'High')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.screenshot', 'Screenshot')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.canvas', 'Canvas')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.iris', 'Iris')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.optiFine', 'Optifine')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.vanilla', 'Vanilla')
    .AddPair('combobox_resource_search_mode.item.modrinth_resource_packs', '纹理')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.combat', 'Combat')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.cursed', 'Cursed')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.decoration', 'Decoration')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.modded', 'Modded')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.realistic', 'Realistic')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.simplistic', 'Simplistic')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.themed', 'Themed')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.tweaks', 'Tweaks')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.utility', 'Utility')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.vanilla-like', 'Vanilla-Like')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.audio', 'Audio')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.blocks', 'Blocks')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.core_shaders', 'Core Shaders')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.entities', 'Entities')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.environment', 'Environment')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.equipment', 'Equipment')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.fonts', 'Fonts')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.GUI', 'GUI')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.items', 'Items')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.locale', 'Locale')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.models', 'Models')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.8x_or_lower', '8x or Lower')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.16x', '16x')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.32x', '32x')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.48x', '48x')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.64x', '64x')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.128x', '128x')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.256x', '256x')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.512x_or_higher', '512x or Higher')
    .AddPair('combobox_resource_search_mode.item.modrinth_modpacks', '整合包')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_modpacks.adventure', 'Adventure')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_modpacks.challenging', 'Challenging')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_modpacks.combat', 'Combat')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_modpacks.kitchen_sink', 'Kitchen Sink')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_modpacks.lightweight', 'Lightweight')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_modpacks.magic', 'Magic')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_modpacks.multiplayer', 'Multiplayer')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_modpacks.optimization', 'Optimization')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_modpacks.quests', 'Quests')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_modpacks.technology', 'Technology')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_modpacks.fabric', 'Fabric')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_modpacks.forge', 'Forge')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_modpacks.neoForge', 'NeoForge')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_modpacks.quilt', 'Quilt')
    .AddPair('label_resource_return_value.caption.is_searching', '正在搜素资源……')
    .AddPair('label_resource_return_value.caption.curseforge_search_finish', '搜索Curseforge成功！')
    .AddPair('label_resource_return_value.caption.get_curseforge_search_error', '获取Curseforge返回结果错误，请重试！')
    .AddPair('label_resource_return_value.caption.get_curseforge_name_or_version_error', '获取Curseforge时，返回了0个元素，获取失败！')
    .AddPair('label_resource_return_value.caption.modrinth_search_finish', '搜索Modrinth成功！')
    .AddPair('label_resource_return_value.caption.get_modrinth_search_error', '获取Modrinth返回结果错误，请重试！')
    .AddPair('label_resource_return_value.caption.get_modrinth_name_or_version_error', '获取Modrinth时，返回了0个元素，获取失败！')
    .AddPair('label_resource_search_name.caption.page', '搜索（名称）【第${page}页】')
    .AddPair('label_resource_search_version.caption.page', '搜索（版本）【第${page}页】')
    //资源管理界面
    .AddPair('label_manage_import_modpack.caption', '整合包导入（暂未完成）')
    .AddPair('label_manage_import_mod.caption', '模组管理')
    .AddPair('label_manage_import_map.caption', '地图管理')
    .AddPair('label_manage_import_resourcepack.caption', '纹理管理')
    .AddPair('label_manage_import_shader.caption', '光影管理')
    .AddPair('label_manage_import_datapack.caption', '数据包管理')
    .AddPair('label_manage_import_plugin.caption', '插件管理')
    .AddPair('listbox_manage_import_modpack.hint', '将整合包拖入此列表框以供添加，仅支持【zip或mrpack】后缀的文件。')
    .AddPair('listbox_manage_import_mod.hint', '将模组拖入此列表框以供添加，仅支持【jar或zip】后缀的文件。')
    .AddPair('listbox_manage_import_map.hint', '将地图拖入此列表框以供添加，仅支持【zip】后缀的文件或【文件夹】。')
    .AddPair('listbox_manage_import_resourcepack.hint', '将纹理拖入此列表框以供添加，仅支持【zip】后缀的文件。')
    .AddPair('listbox_manage_import_shader.hint', '将光影拖入此列表框以供添加，仅支持【zip】后缀的文件。')
    .AddPair('listbox_manage_import_datapack.hint', '将数据包拖入此列表框以供添加，仅支持【zip】后缀的文件。前提是需要选中任一地图文件。')
    .AddPair('listbox_manage_import_plugin.hint', '将插件拖入此列表框以供添加，仅支持【jar或zip】后缀的文件。')
    .AddPair('button_disable_choose_resource.caption', '禁用选中')
    .AddPair('button_enable_choose_resource.caption', '启用选中')
    .AddPair('button_delete_choose_resource.caption', '删除选中')
    .AddPair('button_rename_choose_resource.caption', '重命名选中')
    .AddPair('button_open_choose_resource.caption', '打开选中的文件夹')
    .AddPair('button_disable_choose_resource.hint', '仅能禁用模组和插件，已被禁用的资源将无法被再次禁用')
    .AddPair('button_enable_choose_resource.hint', '仅能启用模组和插件，已被启用的资源将无法被再次启用')
    .AddPair('button_delete_choose_resource.hint', '删除选中的资源，当同时选中数据包和地图时将会优先删除数据包。【将会放入回收站】')
    .AddPair('button_rename_choose_resource.hint', '重命名选中的资源，当地图与数据包同时选中时将会优先重命名数据包。')
    .AddPair('button_open_choose_resource.hint', '用资源管理器打开你所选择的资源。当地图与数据包同时选中时将会优先打开地图文件夹中的datapacks文件夹。')
    //启动设置界面
    .AddPair('label_launch_window_height.caption', '高度，当前选中：${window_height}')
    .AddPair('label_launch_window_width.caption', '宽度，当前选中：${window_width}')
    .AddPair('label_launch_max_memory.caption', '游戏内存【系统总内存：${total_memory}，剩余内存：${avail_memory}，当前选中：${memory}】')
    .AddPair('label_launch_window_size.caption', '游戏窗口大小，默认854x480')
    .AddPair('label_launch_java_path.caption', 'Java路径')
    .AddPair('label_launch_java_logic.caption', 'Java逻辑')
    .AddPair('button_launch_full_scan_java.caption', '全盘扫描')
    .AddPair('button_launch_basic_scan_java.caption', '特定扫描')
    .AddPair('button_launch_manual_import.caption', '手动导入')
    .AddPair('button_launch_remove_java.caption', '移除Java')
    .AddPair('label_launch_download_java.caption', '下载Java')
    .AddPair('button_launch_download_java_8.caption', '下载Java8')
    .AddPair('button_launch_download_java_17.caption', '下载Java17')
    .AddPair('button_launch_download_java_21.caption', '下载Java21')
    .AddPair('button_launch_official_java.caption', '打开Java官网')
    .AddPair('label_launch_custom_info.caption', '自定义信息（默认LLLauncher）')
    .AddPair('edit_launch_custom_info.texthint', '随便填')
    .AddPair('label_launch_window_title.caption', '窗口标题（默认即默认）')
    .AddPair('edit_launch_window_title.texthint', '随便填')
    .AddPair('label_launch_pre_launch_script.caption', '前置启动脚本')
    .AddPair('edit_launch_pre_launch_script.texthint', '非专业人士请勿修改本行')
    .AddPair('button_launch_pre_launch_script.caption', '查看该行提示')
    .AddPair('label_launch_after_launch_script.caption', '后置启动脚本')
    .AddPair('edit_launch_after_launch_script.texthint', '非专业人士请勿修改本行')
    .AddPair('button_launch_after_launch_script.caption', '查看该行提示')
    .AddPair('label_launch_default_jvm.caption', '默认JVM参数')
    .AddPair('button_launch_default_jvm.caption', '查看该行提示')
    .AddPair('label_launch_additional_jvm.caption', '额外JVM参数')
    .AddPair('edit_launch_additional_jvm.texthint', '非专业人士请勿修改本行')
    .AddPair('button_launch_additional_jvm.caption', '查看该行提示')
    .AddPair('label_launch_additional_game.caption', '额外Game参数')
    .AddPair('edit_launch_additional_game.texthint', '非专业人士请勿修改本行')
    .AddPair('button_launch_additional_game.caption', '查看该行提示')
    .AddPair('label_launch_java_login.caption.full_scan_java', 'Java逻辑，正在扫描${drive}盘……')
    .AddPair('label_launch_java_login.caption.full_scan_java_error', 'Java逻辑，全盘扫描Java失败')
    .AddPair('label_launch_java_login.caption.full_scan_java_success', 'Java逻辑，全盘扫描Java成功')
    .AddPair('label_launch_java_logic.caption.search_regedit', 'Java逻辑，正在扫描注册表')
    .AddPair('label_launch_java_login.caption.basic_scan_java_search_regedit_error', 'Java逻辑，全盘扫描Java失败')
    .AddPair('label_launch_java_logic.caption.search_env_path', 'Java逻辑，正在扫描环境变量')
    .AddPair('label_launch_java_logic.caption.search_program', 'Java逻辑，正在扫描C:\Program File\Java')
    .AddPair('label_launch_java.logic.caption.search_lllpath', 'Java逻辑，正在扫描LLL特定目录')
    .AddPair('label_launch_java_logic.caption.basic_scan_java_success', 'Java逻辑，特定扫描Java成功')
    //以下是下载部分
    .AddPair('label_download_return_value.caption.get_mc_web', '正在获取MC元数据……')
    .AddPair('label_downlaod_return_value.caption.get_mc_web_success', '初步导入MC元数据成功！')
    .AddPair('listbox_select_minecraft.item.get_mc_error', 'MC导入失败，请重试。')
    .AddPair('label_download_biggest_thread.caption', '最大线程：${biggest_thread}')
    .AddPair('label_download_return_value.caption.reset_mc_web', '正在重置MC元数据……')
    .AddPair('label_downlaod_return_value.caption.reset_mc_web_success', '重置导入MC元数据成功！')
    .AddPair('listbox_select_modloader.item.has_no_data', '暂无数据！')
    .AddPair('label_download_return_value.caption.get_modloader', '正在获取模组加载器……')
    .AddPair('label_download_return_value.caption.get_modloader_success', '获取模组加载器成功！')
    .AddPair('label_download_tip.caption', '这里是下载部分，你可以体验到自定义文件下载，还有Minecraft下载！这也是为数不多的支持NeoForge的启动器哦！')
    .AddPair('label_choose_view_mode.caption', '选择显示方式')
    .AddPair('label_select_minecraft.caption', 'Minecraft版本选择')
    .AddPair('label_select_modloader.caption', '模组加载器选择')
    .AddPair('checklistbox_choose_view_mode.release.caption', '显示正式')
    .AddPair('checklistbox_choose_view_mode.snapshot.caption', '显示快照')
    .AddPair('checklistbox_choose_view_mode.beta.caption', '显示Beta')
    .AddPair('checklistbox_choose_view_mode.alpha.caption', '显示Alpha')
    .AddPair('checklistbox_choose_view_mode.special.caption', '显示LLL特供')
    .AddPair('radiogroup_choose_download_source.caption', '选择下载源')
    .AddPair('radiogroup_choose_download_source.official.caption', '官方下载源')
    .AddPair('radiogroup_choose_download_source.bmclapi.caption', 'BMCLAPI')
    .AddPair('radiogroup_choose_mod_loader.caption', '选择模组加载器')
    .AddPair('radiogroup_choose_mod_loader.forge.caption', 'Forge')
    .AddPair('radiogroup_choose_mod_loader.fabric.caption', 'Fabric')
    .AddPair('radiogroup_choose_mod_loader.quilt.caption', 'Quilt')
    .AddPair('radiogroup_choose_mod_loader.neoforge.caption', 'NeoForge')
    .AddPair('button_reset_download_part.caption', '重置下载界面')
    .AddPair('button_load_modloader.caption', '加载模组加载器')
    .AddPair('label_minecraft_version_name.caption', '下载版本名称')
    .AddPair('edit_minecraft_version_name.texthint', '请输入版本名称')
    .AddPair('button_download_start_download_minecraft.caption', '开始自动安装Minecraft❤点我自动安装❤')
    //以下是自定义下载部分
    .AddPair('label_custom_download_url.caption', '下载网址输入（不支持百度网盘等）')
    .AddPair('edit_custom_download_url.texthint', '这里输入下载网址')
    .AddPair('label_custom_download_name.caption', '文件名称输入（可空，留空则默认为网址后缀名）')
    .AddPair('edit_custom_download_name.texthint', '这里输入文件名称')
    .AddPair('label_custom_download_sha1.caption', '文件sha1输入（可空）')
    .AddPair('edit_custom_download_sha1.texthint', '这里输入文件sha1，主要用于下载完成后校验文件是否完整，如果不知道可以留空。')
    .AddPair('label_custom_download_path.caption', '保存路径（可空，留空则为本exe路径下）')
    .AddPair('edit_custom_download_path.texthint', '这里输入文件下载路径，可以手动填，也可以点击下方选择路径填写。')
    .AddPair('button_custom_download_choose_path.caption', '选择路径')
    .AddPair('button_custom_download_open_path.caption', '打开路径')
    .AddPair('button_custom_download_start.caption', '开始下载')
    //以下是模组加载器手动安装包
    .AddPair('label_download_modloader_forge.caption', 'Forge版本选择')
    .AddPair('label_download_modloader_fabric.caption', 'Fabric版本选择')
    .AddPair('label_download_modloader_quilt.caption', 'Quilt版本选择')
    .AddPair('label_download_modloader_neoforge.caption', 'NeoForge版本选择')
    .AddPair('button_download_modloader_download.caption', '开始下载')
    .AddPair('button_download_modloader_refresh.caption', '刷新版本')
    //以下是版本设置部分
    .AddPair('label_version_current_path.caption', '当前选中版本：${current_path}')
    .AddPair('label_select_game_version.caption', '选择游戏版本')
    .AddPair('label_select_file_list.caption', '选择文件列表')
    .AddPair('label_version_add_mc_path.caption', '添加MC路径')
    .AddPair('button_version_choose_any_directory.caption', '请选择任一文件夹')
    .AddPair('button_game_resource.caption', '修改该版本游戏资源')
    .AddPair('radiogroup_partition_version.caption', '版本隔离')
    .AddPair('radiogroup_partition_version.not_isolation.caption', '不使用版本隔离')
    .AddPair('radiogroup_partition_version.isolate_version.caption', '隔离【正式版/快照版/远古Beta版/远古Alpha版】')
    .AddPair('radiogroup_partition_version.isolate_modloader.caption', '隔离【Forge/Fabric/Quilt/NeoForge】等版')
    .AddPair('radiogroup_partition_version.isolate_all.caption', '隔离全部版本')
    .AddPair('button_version_complete.caption', '手动补全该版本的类库')
    .AddPair('button_rename_version_list.caption', '重命名文件列表')
    .AddPair('button_remove_version_list.caption', '移除文件列表')
    .AddPair('button_rename_game_version.caption', '重命名游戏版本')
    .AddPair('button_delete_game_version.caption', '删除游戏版本')
    .AddPair('label_version_tip.caption', '这里是版本部分，你可以操作游戏文件夹，还可以选择版本隔离，还可以为独立版本设计，甚至可以导出整合包噢！')
    .AddPair('combobox_version.current_directory.text', '当前文件夹')
    .AddPair('combobox_version.official_directory.text', '官方文件夹')
    //以下是独立设置部分
    .AddPair('label_isolation_current_version.caption', '当前选中版本：${current_version}')
    .AddPair('label_isolation_window_width.caption', '宽，当前选中：${current_width}')
    .AddPair('label_isolation_window_height.caption', '高，当前选中：${current_height}')
    .AddPair('label_isolation_game_memory.caption', '游戏内存，当前选中：${current_memory}')
    .AddPair('toggleswitch_is_open_isolation.on.caption', '开')
    .AddPair('toggleswitch_is_open_isolation.off.caption', '关')
    .AddPair('label_isolation_java_path.caption', 'Java路径')
    .AddPair('edit_isolation_java_path.texthint', '这里输入Java路径【留空则全局应用】')
    .AddPair('button_isolation_choose_java.caption', '选择路径')
    .AddPair('label_isolation_custom_info.caption', '自定义信息')
    .AddPair('edit_isolation_custom_info.texthint', '这里填入自定义信息【留空则全局应用】')
    .AddPair('label_isolation_window_title.caption', '窗口标题')
    .AddPair('edit_isolation_window_title.texthint', '启动MC后的窗口标题【留空则全局应用】')
    .AddPair('label_isolation_window_size.caption', '窗口大小')
    .AddPair('toggleswitch_isolation_window_size.on.caption', '开启独立')
    .AddPair('toggleswitch_isolation_window_size.off.caption', '全局应用')
    .AddPair('toggleswitch_isolation_open_memory.on.caption', '开启独立')
    .AddPair('toggleswitch_isolation_open_memory.off.caption', '全局应用')
    .AddPair('label_isolation_partition.caption', '是否隔离（打勾则单独隔离，否则单独不隔离）')
    .AddPair('toggleswitch_isolation_open_partition.on.caption', '开启独立')
    .AddPair('toggleswitch_isolation_open_partition.off.caption', '全局应用')
    .AddPair('checkbox_isolation_is_partition.caption', '开启独立版本隔离')
    .AddPair('label_isolation_additional_game.caption', '额外Game参数')
    .AddPair('edit_isolation_additional_game.texthint', '输入额外game参数-非专业人士请勿修改【留空则全局应用】')
    .AddPair('label_isolation_additional_jvm.caption', '额外JVM参数')
    .AddPair('edit_isolation_additional_jvm.texthint', '输入额外jvm参数-非专业人士请勿修改【留空则全局应用】')
    .AddPair('label_isolation_pre_launch_script.caption', '前置启动脚本')
    .AddPair('edit_isolation_pre_launch_script.texthint', '输入前置启动脚本-非专业人士请勿修改【留空则全局应用】')
    .AddPair('label_isolation_after_launch_script.caption', '后置启动脚本')
    .AddPair('edit_isolation_after_launch_script.texthint', '输入后置启动脚本-非专业人士请勿修改【留空则全局应用】')
    .AddPair('label_isolation_tip.caption', '以上，只要是开启了全局应用开关，或者是修改了文本框内容【指不为空】，则默认应用全局设置噢！')
    //以下是整合包导出部分
    .AddPair('label_export_current_version.caption', '当前选中版本：${current_version}')
    .AddPair('label_export_return_value.caption.initialize', '正在初始化整合包导出的文件树……')
    .AddPair('label_export_return_value.caption.init_success', '初始化文件树完成！')
    .AddPair('label_export_memory.caption', '最大内存，当前选中：${max_memory}')
    .AddPair('label_export_return_value.caption.scan_file', '正在扫描已选中文件，请勿关闭此窗口……')
    .AddPair('label_export_return_value.caption.copy_file', '正在判断文件以用于导入，请勿关闭此窗口……')
    .AddPair('label_export_return_value.caption.scan_file_finish', '扫描文件完成，正在复制文件……')
    .AddPair('label_export_return_value.caption.copy_file_finish', '扫描复制完成，弹出保存路径窗口……')
    .AddPair('label_export_return_value.caption.is_export', '正在打包成zip，请勿关闭，请等待信息框弹出……')
    .AddPair('label_export_return_value.caption.export_success', '打包完成！你现在可以去查到zip包了！')
    .AddPair('radiogroup_export_mode.caption', '导出方式')
    .AddPair('label_export_mode_more.caption', '更多导出方式敬请期待噢！')
    .AddPair('label_export_modpack_name.caption', '整合包名称')
    .AddPair('edit_export_modpack_name.texthint', '此处输入你的整合包名称【必填项】')
    .AddPair('label_export_modpack_author.caption', '整合包作者')
    .AddPair('edit_export_modpack_author.texthint', '此处输入你的整合包作者【必填项】')
    .AddPair('label_export_modpack_version.caption', '整合包版本')
    .AddPair('edit_export_modpack_version.texthint', '此处输入你的整合包版本【必填项】')
    .AddPair('label_export_update_link.caption', '整合包更新链接')
    .AddPair('edit_export_update_link.texthint', '此处输入你的整合包更新链接【选填项】')
    .AddPair('edit_export_update_link.hint', '例如【https://example.com/manifact.json】，只需输入【https://example.com】即可。')
    .AddPair('label_export_official_website.caption', '整合包官方网站')
    .AddPair('edit_export_official_website.texthint', '此处输入你的整合包官方网站【选填项】')
    .AddPair('edit_export_official_website.hint', '此处填写你整合包的官方网址，例如curseforge就填网址。填全称。')
    .AddPair('label_export_authentication_server.caption', '认证服务器')
    .AddPair('edit_export_authentication_server.texthint', '此处输入你的整合包认证服务器【选填项】')
    .AddPair('edit_export_authentication_server.hint', '此处仅限外置登录，如果你不确定，请留空。该处只能填入类似于【littleskin.cn】这种外置登录皮肤站根目录')
    .AddPair('label_export_additional_game.caption', '额外Game')
    .AddPair('edit_export_additional_game.texthint', '此处输入你的整合包额外Game参数【选填项】')
    .AddPair('edit_export_additional_game.hint', '用空格分割你的额外Game参数。')
    .AddPair('label_export_additional_jvm.caption', '额外JVM')
    .AddPair('edit_export_additional_jvm.texthint', '此处输入你的整合包额外JVM参数')
    .AddPair('edit_export_additional_jvm.hint', '用空格分割你的额外JVM参数。')
    .AddPair('label_export_modpack_profile.caption', '整合包简介')
    .AddPair('label_export_keep_file.caption', '需要保留的文件')
    .AddPair('button_export_start.caption', '♥点我导出♥')
    .AddPair('label_export_add_icon.caption', '为整合包添加图标（ps：允许任意像素，但建议200x200即可，仅限png，暂不支持jpg等）')
    .AddPair('button_export_add_icon.caption', '选择图标文件')
    //以下是联机IPv6部分
    .AddPair('label_online_ipv6_return_value.caption.check_ipv6_port', '正在检测你的IPv6公网IP中……')
    .AddPair('listbox_view_all_ipv6_ip.caption.timeout', '超时')
    .AddPair('listbox_view_all_ipv6_ip.caption.forever', '永久')
    .AddPair('listbox_view_all_ipv6_ip.caption.temp', '临时')
    .AddPair('label_online_ipv6_return_value.caption.not_support_ipv6', '你的局域网网络暂不支持IPv6连接，如果你确信自己拥有IPv6而LLL无法识别出来时，请联系作者！')
    .AddPair('label_online_ipv6_return_value.caption.check_ipv6_success', '检测IPv6成功！现在你可以在列表框里查看了！')
    .AddPair('label_online_ipv6_return_value.caption.current_ipv6_ip', '你选中的IPv6地址是：[${ip}]')
    .AddPair('button_check_ipv6_ip.caption', '开始检测IPv6公网IP')
    .AddPair('label_online_ipv6_port.caption', '请输入你在游戏中的端口【1024~65536】')
    .AddPair('button_copy_ipv6_ip_and_port.caption', '复制IPv6公网IP与端口')
    .AddPair('button_online_ipv6_tip.caption', 'IPv6联机提示')
    .AddPair('label_online_tip.caption', '这里是联机部分，你可以在这里找一个你所想要的联机方式进行联机噢！')
    //以下是启动游戏时的语言
    .AddPair('label_mainform_tips.caption.judge_args', '正在开始判断配置文件是否有误……')
    .AddPair('label_mainform_tips.caption.not_choose_mc_version', 'MC版本判断失误，你还没有选择任一MC版本。')
    .AddPair('label_mainform_tips.caption.not_choose_java', 'Java判断失误，你还没有选择任一Java。')
    .AddPair('label_mainform_tips.caption.access_token_expire', '你的Access Token已过期，请尝试重新登录一次吧【或者点击刷新账号】！')
    .AddPair('label_mainform_tips.caption.not_support_third_party', '目前并不处在中国，暂不支持第三方外置登录！请重试！')
    .AddPair('label_mainform_tips.caption.not_support_login_type', '不支持的登录方式，也许你修改了账号配置中的数据，请立即改回来！')
    .AddPair('label_mainform_tips.caption.not_choose_account', '账号判断失误，你还没有选择任一账号。')
    .AddPair('label_mainform_tips.caption.set_launch_script', '现在开始拼接启动参数……')
    .AddPair('label_mainform_tips.caption.cannot_find_json', '版本错误，未从版本文件夹中找到符合标准的json文件！……')
    .AddPair('label_mainform_tips.caption.unzip_native_error', '未能成功解压Natives文件。')
    .AddPair('label_mainform_tips.caption.cannot_set_launch_args', '无法拼接MC启动参数，请仔细的检查你的MC版本JSON是否有误！')
    .AddPair('label_mainform_tips.caption.cannot_find_authlib_file', '找不到Authlib-Injector文件，请进入账号部分下载一个后再尝试！')
    .AddPair('label_mainform_tips.caption.export_launch_args_success', '启动参数导出成功！')
    .AddPair('label_mainform_tips.caption.wait_launch_game', '游戏启动成功！正在等待打开游戏窗口中……')
    .AddPair('label_mainform_tips.caption.launch_game_success', '窗口打开成功！可以开始玩游戏了！')
    .AddPair('label_mainform_tips.caption.cancel_launch', '取消启动。')
    //以下是插件语言
    .AddPair('plugin_tabsheet.get_plugin_info.hint', Concat(
                '插件名称；${plugin_caption}', #13#10,
                '插件版本：${plugin_version}', #13#10,
                '插件作者：${plugin_author}', #13#10,
                '插件版权：${plugin_copyright}', #13#10,
                '插件更新时间：${plugin_update_time}', #13#10,
                '插件简介：${plugin_description}'))
    .AddPair('plugin_menu_back.caption', '回退')
    ;
  alllangjson.Add(zhcnjson);
//    SetFile(Concat(ExtractFilePath(Application.ExeName), 'LLLauncher\lang\zh_cn.json'), zhcnjson.Format);
//  end;

//  if not FileExists(Concat(ExtractFilePath(Application.ExeName), 'LLLauncher\lang\en_us.json')) then begin
  var enusjson := TJSONObject.Create
    .AddPair('file_language_title', 'English(US)')
    //以下为页
    .AddPair('tabsheet_mainpage_part.caption', 'Main Form')
    .AddPair('tabsheet_account_part.caption', 'Account Part')
    .AddPair('tabsheet_resource_part.caption', 'Resource Part')
    .AddPair('tabsheet_download_part.caption', 'Download Part')
    .AddPair('tabsheet_online_part.caption', 'Online Part')
    .AddPair('tabsheet_background_part.caption', 'Background Part')
    .AddPair('tabsheet_launch_part.caption', 'Launch Part')
    .AddPair('tabsheet_version_part.caption', 'Version Part')
    .AddPair('tabsheet_account_offline_part.caption', 'Offline Login')
    .AddPair('tabsheet_account_microsoft_part.caption', 'Microsoft Login')
    .AddPair('tabsheet_account_thirdparty_part.caption', 'Third-party Login')
    .AddPair('tabsheet_resource_download_part.caption', 'Download Resource Part')
    .AddPair('tabsheet_resource_manage_part.caption', 'Manage Resource Part')
    .AddPair('tabsheet_download_minecraft_part.caption', 'Download Minecraft')
    .AddPair('tabsheet_download_custom_part.caption', 'Download Custom File')
    .AddPair('tabsheet_download_modloader_part.caption', 'Download Mod Loader')
    .AddPair('tabsheet_online_ipv6_part.caption', 'IPv6 Online')
    .AddPair('tabsheet_online_octo_part.caption', 'Octo Online')
    .AddPair('tabsheet_version_control_part.caption', 'Version Control')
    .AddPair('tabsheet_version_isolation_part.caption', 'Isolation Setting')
    .AddPair('tabsheet_version_export_part.caption', 'Export Modpack')
    .AddPair('tabsheet_plugin_part.caption', 'Plugin Part')
    .AddPair('tabsheet_help_part.caption', 'Help Part')
    //以下为菜单栏
    .AddPair('menu_misc.caption', 'Misc')
    .AddPair('menu_misc_answer.caption', 'Answer Book')
    .AddPair('menu_misc_intro.caption', 'Intro Me')
    .AddPair('menu_misc_lucky.caption', 'Today Lucky')
    .AddPair('menu_misc_puzzle.caption', 'Puzzle Game')      
    .AddPair('menu_official.caption', 'Official Website')
    .AddPair('menu_official_entry.caption', 'Entry Official Website')
    .AddPair('menu_official_support.caption', 'Support Authod')
    .AddPair('menu_official_bmclapi.caption', 'Support BMCLAPI')
    .AddPair('menu_manual.caption', 'More')
    .AddPair('menu_manual_reset.caption', 'Reset Launcher')
    .AddPair('menu_manual_export.caption', 'Export Launch Argument')
    .AddPair('menu_manual_version.caption', 'Current Version')
    .AddPair('menu_manual_update.caption', 'Check Update')
    .AddPair('menu_manual_optimize.caption', 'Memory Reduct')
    .AddPair('menu_manual_test.caption', 'Test Button')
    .AddPair('menu_manual_language.caption', 'Launcher')
    .AddPair('menu_manual_plugin.caption', 'DLL Plugin')
    .AddPair('menu_view_mod_profile.caption', 'Open this mod Profile')
    .AddPair('menu_view_mod_website.caption', 'Open this mod official url')
    .AddPair('menu_view_minecraft_info.caption', 'View Minecraft Info')
    .AddPair('menu_view_mod_info', 'View Mod Information')
    //以下为信息框
    .AddPair('messagebox_button_yes.caption', 'Yes')
    .AddPair('messagebox_button_ok.caption', 'OK')
    .AddPair('messagebox_button_no.caption', 'No')
    .AddPair('messagebox_button_cancel.caption', 'Cancel')
    .AddPair('messagebox_button_retry.caption', 'Retry')
    .AddPair('messagebox_button_abort.caption', 'Abort')
    .AddPair('messagebox_button_ignore.caption', 'Ignore')
    .AddPair('inputbox_button_yes.caption', 'OK')
    .AddPair('inputbox_button_no.caption', 'Cancel')
    .AddPair('picturebox_button_ok.caption', 'OK')
    .AddPair('messagebox_launcher.exit_mc_success.caption', 'Exit Minecraft Successfully')
    .AddPair('messagebox_launcher.exit_mc_success.text', 'Successfully to Exit Minecraft! But if your game just start, maybe it cannot exit, please forgive me!')
    .AddPair('messagebox_launcher.illegal_exit.caption', 'Illegal to Exit Mineraft')
    .AddPair('messagebox_launcher.illegal_exit.text', 'Your Minecraft has exited illegally, maybe the game just crashed, I suggest you to send your crash-report to any group and look for some help!')
    .AddPair('messagebox_background_reset_image.success.text', Concat('Successfully to refresh Background Image!', #13#10, 'Name: ${background_image_filename}'))
    .AddPair('messagebox_background_reset_image.success.caption', 'Background Image refresh successfully')
    .AddPair('messagebox_background_reset_image.not_found.text', 'Failure to refrsh Background Image, you may not have placed any file in the Directory.')
    .AddPair('messagebox_background_reset_image.not_found.caption', 'Background Image refresh failure')
    .AddPair('messagebox_background_reset_music.success.text', Concat('Successfully to refresh Background Music!', #13#10, 'Name: ${background_music_filename}'))
    .AddPair('messagebox_background_reset_music.success.caption', 'Background Music refresh successfully')
    .AddPair('messagebox_background_reset_music.not_found.text', 'Failure to refrsh Background Music, you may not have placed any file in the Directory.')
    .AddPair('messagebox_background_reset_music.not_found.caption', 'Background Music refresh failure')
    .AddPair('messagebox_mainform.release_memory_optimize_warning.text', 'Do you want to start reduct memory immediately? This launcher will try to clean your computer memory forcibly. This procedure will be called system function by [ntdll.dll]. and will be authorization, if you not sure this library function, I dont suggestion you used this function. btw, This function need to launch by Administrator.')
    .AddPair('messagebox_mainform.release_memory_optimize_warning.caption', 'Are you sure to start memory reduct?')
    .AddPair('messagebox_mainform.cannot_release_first_memory.text', 'A problem is appear when clean memory step 1, please retry!')
    .AddPair('messagebox_mainform.cannot_release_first_memory.caption', 'Memory reduct failure')
    .AddPair('messagebox_mainform.cannot_release_second_memory.text', 'A problem is appear when clean memory step 2, please retry!')
    .AddPair('messagebox_mainform.cannot_release_second_memory.caption', 'Memory reduct failure')
    .AddPair('messagebox_mainform.cannot_release_third_memory.text', 'A problem is appear when clean memory step 3, please retry!')
    .AddPair('messagebox_mainform.cannot_release_third_memory.caption', 'Memory reduct failure')
    .AddPair('messagebox_mainform.cannot_release_forth_memory.text', 'A problem is appear when clean memory step 4, please retry!')
    .AddPair('messagebox_mainform.cannot_release_forth_memory.caption', 'Memory reduct failure')
    .AddPair('messagebox_mainform.cannot_release_fifth_memory.text', 'A problem is appear when clean memory step 5, please retry!')
    .AddPair('messagebox_mainform.cannot_release_fifth_memory.caption', 'Memory reduct failure')
    .AddPair('messagebox_mainform.cannot_root_seIncreaseQuotaPrivilege.text', 'An error is appear when authorizate SeIncreaseQuotaPrivilege, you may did not launch by administrator.')
    .AddPair('messagebox_mainform.cannot_root_seIncreaseQuotaPrivilege.caption', 'An error is appear when Authorizate')
    .AddPair('messagebox_mainform.cannot_root_seProfileSingleProcessPrivilege.text', 'An error is appear when authorizate SeProfileSingleProcessPrivilege, you may did not launch by administrator.')
    .AddPair('messagebox_mainform.cannot_root_seProfileSingleProcessPrivilege.caption', 'An error is appear when Authorizate')
    .AddPair('messagebox_mainform.release_memory_success.text', 'Memory Reduct Successfully! clean ${release_memory_value} MB memory!')
    .AddPair('messagebox_mainform.release_memory_success.caption', 'Memory Reduct Successfully')
    .AddPair('messagebox_mainform.show_lll_version.text', 'Current Little Limbo Launcher version you are using is: ${version}')
    .AddPair('messagebox_mainform.show_lll_version.caption', 'Current using launcher version')
    .AddPair('messagebox_mainform.is_reset_launcher.text', 'Are you sure to reset launcher? This control will delete all your exist config file. include plugin, language, background image, background music and other. This launcher will close, you need to manual open this launcher. Continue? [just that delete {exe}\LLLauncher directory!]')
    .AddPair('messagebox_mainform.is_reset_launcher.caption', 'Are you sure to reset launcher?')
    .AddPair('messagebox_mainform.reset_language_to_chinese.text', 'Do you want to reset Language to Chinese? This action will delete your zh_cn.json config, and create a new. and loading later.')
    .AddPair('messagebox_mainform.reset_language_to_chinese.caption', 'Are you sure to reset language to Chinese?')
    .AddPair('messagebox_mainform.cannot_export_launch_args.text', 'Your country not belong to China, you cannot export launch script, please forgive me.')
    .AddPair('messagebox_mainform.cannot_export_launch_args.caption', 'cannot export launch script')
    .AddPair('messagebox_account_offline_error.cannot_name.text', 'Your offline login name not true, please do not entry Chinese, and do not more than 16 character, do not empty!')
    .AddPair('messagebox_account_offline_error.cannot_name.caption', 'error alert')
    .AddPair('messagebox_account_offline_error.cannot_uuid.text', 'Your offline login UUID not true, please entry 32-bit unsigned UUID, or not input and wait generated.')
    .AddPair('messagebox_account_offline_error.cannot_uuid.caption', 'error alert')
    .AddPair('messagebox_account_offline.add_account_success.text', 'Offline account add successfully!')
    .AddPair('messagebox_account_offline.add_account_success.caption', 'Add successfully')
    .AddPair('messagebox_account.cannot_get_account.text', 'you has no account select, cannot remove.')
    .AddPair('messagebox_account.cannot_get_account.caption', 'no account select, cannot remove')
    .AddPair('messagebox_account.is_remove_account.text', 'Are you sure to remove this account?')
    .AddPair('messagebox_account.is_remove_account.caption', 'Are you sure to remove')
    .AddPair('messagebox_account.login_account_too_much.text', 'You login account is more than 32, please remove some account and retry to add the other!')
    .AddPair('messagebox_account.login_account_too_much.caption', 'Login too much account')
    .AddPair('messagebox_account_thirdparty_error.cannot_get_metadata.text', 'Yggdrasil API get failure, maybe you entry error url, please retry!')
    .AddPair('messagebox_account_thirdparty_error.cannot_get_metadata.caption', 'Yggdrasil API get failure')
    .AddPair('messagebox_account_thirdparty_error.refresh_skin_error.text', 'I am so sorry, you failure to get skin, maybe you delete this Skin in website, please retry!')
    .AddPair('messagebox_account_thirdparty_error.refresh_skin_error.caption', 'failure to get skin')
    .AddPair('messagebox_account_thirdparty_error.username_or_password_nottrue.text', 'Your email or password entry error, please retry!')
    .AddPair('messagebox_account_thirdparty_error.username_or_password_nottrue.caption', 'email or password entry error')
    .AddPair('messagebox_account_thirdparty_error.accesstoken_invalid.text', 'Your Access Token is expire, please login again.')
    .AddPair('messagebox_account_thirdparty_error.accesstoken_invalid.caption', 'Access Token is expire')
    .AddPair('messagebox_account_thirdparty_error.unknown_error.text', 'Login ThirdParty appear unknown error, please send it to author, or try again.')
    .AddPair('messagebox_account_thirdparty_error.unknown_error.caption', 'appear unknown error')
    .AddPair('messagebox_account_thirdparty_error.not_choose_any_skin.text', 'Login successfully! but you have not choose any skin in skinlib, please choose and retry!')
    .AddPair('messagebox_account_thirdparty_error.not_choose_any_skin.caption', 'not choose any skin')
    .AddPair('inputbox_account_thirdparty.choose_a_role.text', 'Please entry skin number: ${role_group}')
    .AddPair('inputbox_account_thirdparty.choose_a_role.caption', 'please entry skin number')
    .AddPair('messagebox_account_thirdparty_error.dont_entry_other_char.text', 'Do not try to entry other character in here, please retry!')
    .AddPair('messagebox_account_thirdparty_error.dont_entry_other_char.caption', 'entry character error')
    .AddPair('messagebox_account_thirdparty_error.connect_error.text', 'Your network connect timeout, please reconnect your network and retry!')
    .AddPair('messagebox_account_thirdparty_error.connect_error.caption', 'network connect timeout')
    .AddPair('messagebox_account_thirdparty.add_account_success.text', 'Add successfully, already logined by ThirdParty login.')
    .AddPair('messagebox_account_thirdparty.add_account_success.caption', 'Add successfully')
    .AddPair('messagebox_account_thirdparty_error.account_or_password_empty.text', 'Username or password is empty, please retry.')
    .AddPair('messagebox_account_thirdparty_error.account_or_password_empty.caption', 'Username or password is empty')
    .AddPair('messagebox_account_microsoft_error.not_complete_oauth_login.text', 'Your press ok button before completing your OAuth login, Please retry!')
    .AddPair('messagebox_account_microsoft_error.not_complete_oauth_login.caption', 'press button in advence')
    .AddPair('messagebox_account_microsoft_error.login_timeout.text', 'Your network connect timeout, please reconnect your network and retry!')
    .AddPair('messagebox_account_microsoft_error.login_timeout.caption', 'network connect timeout')
    .AddPair('messagebox_account_microsoft_error.refresh_expire.text', '你的RefreshToken也过期了，看样子你已经很久没重置过账号了呢！请重新登录一次新的账号吧！')
    .AddPair('messagebox_account_microsoft_error.refresh_expire.caption', '刷新密钥过期')
    .AddPair('messagebox_account_microsoft_error.uhs_not_same.text', '你在登录微软账号时，通过xbox与xsts两次获取的uhs不一致，请立即将此latest.log或者此截图发送给作者！')
    .AddPair('messagebox_account_microsoft_error.uhs_not_same.caption', '两次获取的uhs不一致')
    .AddPair('messagebox_account_microsoft_error.not_buy_mc.text', '不好意思，您的Microsoft账户并没有购买Minecraft，请问是否立即前往官网购买？')
    .AddPair('messagebox_account_microsoft_error.not_buy_mc.caption', '暂未购买mc，是否前往商店')
    .AddPair('messagebox_account_microsoft_error.cannot_get_user_code.text', '未能获取到用户代码，你似乎未连接网络，请重试！')
    .AddPair('messagebox_account_microsoft_error.cannot_get_user_code.caption', '未能获取到用户代码')
    .AddPair('inputbox_account_microsoft.start_login.text', '你的用户代码在下面，你可以复制它，然后你需要将其复制到刚刚打开的浏览器窗口中进行登录，登录完毕后，你就可以随意按下下面任意一个按钮继续往下执行，但是切记，你不可以在未登录的情况下按下任意一个按钮！')
    .AddPair('inputbox_account_microsoft.start_login.caption', '已获取用户代码')
    .AddPair('messagebox_account_microsoft.add_account_success.text', '添加成功，已通过微软登录成功添加！')
    .AddPair('messagebox_account_microsoft.add_account_success.caption', '添加成功')
    .AddPair('messagebox_account_microsoft_error.connect_error.text', '连接超时引发的报错')
    .AddPair('messagebox_account_microsoft_error.connect_error.caption', '你的网络连接超时了，请连接之后再进行网络请求。或者如果你连接了，重试一次即可。')
    .AddPair('messagebox_account.not_choose_any_account.text', '你还没有登录账号，请立刻登录一次再尝试获取UUID。')
    .AddPair('messagebox_account.not_choose_any_account.caption', '暂未登录账号')
    .AddPair('messagebox_account.get_current_uuid.text', '你本账号的UUID为：${account_uuid}，是否复制进剪切板？')
    .AddPair('messagebox_account.get_current_uuid.caption', '已得到UUID')
    .AddPair('messagebox_account.not_support_login_way.text', '你选中了不支持的登录方式，请重试！')
    .AddPair('messagebox_account.not_support_login_way.caption', '不支持的登录方式')
    .AddPair('messagebox_account.offline_cannot_refresh.text', '离线模式不需要刷新账号哦！可以换成微软登录或者外置登录来刷新呢！')
    .AddPair('messagebox_account.offline_cannot_refresh.caption', '离线模式不需要刷新账号')
    .AddPair('messagebox_account.refresh_microsoft_error.text', '刷新微软账号失败，有可能是你的Refresh_token已经过期了，也有可能是你的网络连接不好。')
    .AddPair('messagebox_account.refresh_microsoft_error.caption', '刷新微软账号失败')
    .AddPair('messagebox_account.refresh_microsoft_success.text', '刷新微软账号成功！')
    .AddPair('messagebox_account.refresh_microsoft_success.caption', '刷新微软账号成功')
    .AddPair('messagebox_account.refresh_thirdparty_error.text', '刷新外置账号失败，有可能是你的Refresh_token已经过期了，也有可能是你的网络连接不好。')
    .AddPair('messagebox_account.refresh_thirdparty_error.caption', '刷新外置账号失败')
    .AddPair('messagebox_account.refresh_thirdparty_success.text', '刷新外置账号成功！')
    .AddPair('messagebox_account.refresh_thirdparty_success.caption', '刷新外置账号成功')
    .AddPair('messagebox_account.name_to_uuid_error.text', '该用户不存在，请重新输入用户名。')
    .AddPair('messagebox_account.name_to_uuid_error.caption', '该用户不存在')
    .AddPair('messagebox_account.name_not_true.text', '用户名不符合规范，请重新输入！')
    .AddPair('messagebox_account.name_not_true.caption', '用户名不符合规范')
    .AddPair('messagebox_account.uuid_to_name_error.text', '该用户不存在，请重新输入UUID。')
    .AddPair('messagebox_account.uuid_to_name_error.caption', '该用户不存在')
    .AddPair('messagebox_account.uuid_not_true.text', 'UUID不符合规范，请重新输入！')
    .AddPair('messagebox_account.uuid_not_true.caption', 'UUID不符合规范')
    .AddPair('messagebox_account_offline.add_demo_warning.caption', '离线登录警告')
    .AddPair('messagebox_account_offline.add_demo_warning.text', '由于你目前并不处于中国地区，并且你暂未登录过任一正版账号，因此你所登录的离线登录将会被加上--demo。除非你登录一次正版，否则这个标签将会一直加上！')
    .AddPair('messagebox_mainform.launch_afdian.text', Concat('LLL启动器已经帮你启动过${launch_number}次游戏了，真的不打算为作者发电么？【呜呜的请求……】', #13#10, '点是进入作者的爱发电。'))
    .AddPair('messagebox_mainform.open_afdian.text', Concat('LLL启动器已经被你打开过${open_number}次了，真的不打算为作者发电么？【呜呜的请求……】', #13#10, '点是进入作者的爱发电。'))
    .AddPair('messagebox_mainform.afdian.caption', '快点来给我发电吧')
    .AddPair('messagebox_mainform.change_language.text', '当你切换了任意一次语言后，虽然这是实时更改的，但仍然不排除有部分标签没有修改，因此这里建议你重新打开一次启动器。')
    .AddPair('messagebox_mainform.change_language.caption', '建议重启启动器')
    .AddPair('messagebox_resource.get_curseforge_search_error.caption', '获取失败……')
    .AddPair('messagebox_resource.get_curseforge_search_error.text', '获取Curseforge返回结果错误，请重试！')
    .AddPair('messagebox_resource.get_curseforge_name_or_version_error.caption', '获取失败……')
    .AddPair('messagebox_resource.get_curseforge_name_or_version_error.text', '在获取Curseforge时，返回了0个元素，搜素失败！')
    .AddPair('messagebox_resource.get_modrinth_search_error.caption', '获取失败……')
    .AddPair('messagebox_resource.get_modrinth_search_error.text', '获取Modrinth返回结果错误，请重试！')
    .AddPair('messagebox_resource.get_modrinth_name_or_version_error.caption', '获取失败……')
    .AddPair('messagebox_resource.get_modrinth_name_or_version_error.text', '在获取Modrinth时，返回了0个元素，搜素失败！')
    .AddPair('messagebox_resource.get_curseforge_page_error.caption', '返回结果为空，解析失败。')
    .AddPair('messagebox_resource.get_curseforge_page_error.text', '在对Curseforge版本进行翻页或者点击列表框时，返回结果为空，解析失败。')
    .AddPair('messagebox_resource.get_modrinth_page_error.caption', '返回结果为空，解析失败。')
    .AddPair('messagebox_resource.get_modrinth_page_error.text', '在对Modrinth版本进行翻页或者点击列表框时，返回结果为空，解析失败。')
    .AddPair('messagebox_resource.version_pageup_error.caption', '版本上一页失败')
    .AddPair('messagebox_resource.version_pageup_error.text', '已经是第一页啦！不要再上一页啦！')
    .AddPair('messagebox_resource.version_pagedown_error.caption', '版本下一页失败')
    .AddPair('messagebox_resource.version_pagedown_error.text', '已经是最后一页啦！不要再下一页啦！')
    .AddPair('messagebox_resource.name_pageup_error.caption', '名称上一页失败')
    .AddPair('messagebox_resource.name_pageup_error.text', '已经是第一页啦！不要再上一页啦！')
    .AddPair('messagebox_resource.name_pagedown_error.caption', '名称下一页失败')
    .AddPair('messagebox_resource.name_pagedown_error.text', '已经是最后一页啦！不要再下一页啦！')
    .AddPair('messagebox_resource.not_choose_mod_error.caption', '暂未选择模组。')
    .AddPair('messagebox_resource.not_choose_mod_error.text', '暂未选择任意模组，无法打开官网，请重试。')
    .AddPair('messagebox_resource.open_intro_error.caption', '打开简介失败')
    .AddPair('messagebox_resource.open_intro_error.text', '打开简介失败，请尝试选择任意一个资源版本后，再尝试打开简介。')
    .AddPair('picturebox_resource.open_curseforge_intro_success.text', Concat(
            '项目ID：${p_id}', #13#10,
            '项目隶属：${classId}', #13#10,
            '项目slug：${slug}', #13#10,
            '项目标题：${name}', #13#10,
            '项目作者：${authors}', #13#10,
            '项目简介：${summary}', #13#10,
            '项目类型：${categories}', #13#10,
            '项目下载量：${p_downloadCount}', #13#10,
//            '项目关注量：${follows}', #13#10,
            '项目创建日期：${dateCreated}', #13#10,
            '项目最新版本：${dateModified}', #13#10,
            '项目最新版本：${gameVersion}', #13#10,
//            '项目许可证：${license}', #13#10,
            '-----------------------------------------------------------------------------------------------------------------------', #13#10,
            '所选ID：${id}', #13#10,
            '所选名称：${fileName}', #13#10,
            '所选版本名：${displayName}', #13#10,
            '所选下载量：${downloadCount}', #13#10,
            '所选发布状态：${releaseType}', #13#10,
            '所选发布日期：${fileDate}', #13#10,
            '所选MC版本/加载器：${gameVersions}'
//            '所选加载器：${loaders}', #13#10,
//            '所选更新日志：${changelog}', #13#10
            ))
    .AddPair('picturebox_resource.open_modrinth_intro_success.text', Concat(
            '项目ID：${project_id}', #13#10,
            '项目隶属：${project_type}', #13#10,
            '项目slug：${slug}', #13#10,
            '项目标题：${title}', #13#10,
            '项目作者：${author}', #13#10,
            '项目简介：${description}', #13#10,
            '项目类型：${categories}', #13#10,
            '项目下载量：${p_downloads}', #13#10,
            '项目关注量：${follows}', #13#10,
            '项目创建日期：${date_created}', #13#10,
            '项目最后更新日期：${latest_version}', #13#10,
            '项目最新版本：${date_modified}', #13#10,
            '项目许可证：${license}', #13#10,
            '-----------------------------------------------------------------------------------------------------------------------', #13#10,
            '所选ID：${id}', #13#10,
            '所选名称：${name}', #13#10,
            '所选版本名：${version_number}', #13#10,
            '所选下载量：${downloads}', #13#10,
            '所选发布状态：${version_type}', #13#10,
            '所选发布日期：${date_published}', #13#10,
            '所选支持MC版本：${game_versions}', #13#10,
            '所选加载器：${loaders}', #13#10,
            '所选更新日志：${changelog}'))
    .AddPair('picturebox_resource.has_no_data', '暂无数据。')
    .AddPair('messagebox_resource.no_version_download_error.caption', '暂未选择任意版本')
    .AddPair('messagebox_resource.no_version_download_error.text', '您还暂未选择任意资源的版本，无法下载，请选择一个之后重试。')
    .AddPair('opendialog_resource.download_dialog.title', '请选择你要保存的路径：')
    .AddPair('messagebox_resource.file_exists_download_error.caption', '文件已存在')
    .AddPair('messagebox_resource.file_exists_download_error.text', '你要下载的路径已存在一个同名文件，请删除这个文件后再重新尝试下载。')
    .AddPair('messagebox_resource.download_resource_success.caption', '下载完成')
    .AddPair('messagebox_resource.download_resource_success.text', '资源下载已完成！')
    .AddPair('messagebox_resource.open_manage_error.caption', '打开资源管理界面失败')
    .AddPair('messagebox_resource.open_manage_error.text', '打开资源管理界面失败，你似乎并未选中任一游戏文件夹，请去选中一次再来！')
    .AddPair('messagebox_manage.drag_file_mod.caption', '您安装的是模组')
    .AddPair('messagebox_manage.drag_file_mod.text', '你需要安装的是【模组】，名称为：${drag_file_name}，请问是否继续？')
    .AddPair('messagebox_manage.drag_mod_repeat.caption', '你的模组有重复')
    .AddPair('messagebox_manage.drag_mod_repeat.text', '你想安装的模组有重复名称的文件，文件名是：${drag_file_name}，是否需要替换？')
    .AddPair('messagebox_manage.drag_mod_format_error.caption', '安装文件格式错误')
    .AddPair('messagebox_manage.drag_mod_format_error.text', '你想安装的模组文件格式不为jar或zip，文件名是：${drag_file_name}，无法安装，请重试！')
    .AddPair('messagebox_manage.drag_map_zip.caption', '您安装的是地图')
    .AddPair('messagebox_manage.drag_map_zip.text', '你需要安装的是【地图】的zip格式包，名称为：${drag_file_name}，请问是否继续？')
    .AddPair('messagebox_manage.drag_map_zip_repeat.caption', '你的地图有重复')
    .AddPair('messagebox_manage.drag_map_zip_repeat.text', '你想安装的地图有重复名称的文件，文件名是：${drag_file_name}，是否需要替换？')
    .AddPair('messagebox_manage.drag_map_unzip_error.caption', '解压地图zip失败')
    .AddPair('messagebox_manage.drag_map_unzip_error.text', '解压地图的zip失败，你是否给该zip包上了密码锁，或者该zip包无法解压，请重试。')
    .AddPair('messagebox_manage.drag_map_dir.caption', '您安装的是地图')
    .AddPair('messagebox_manage.drag_map_dir.text', '你需要安装的是【地图】的文件夹格式包，名称为：${drag_file_name}，请问是否继续？')
    .AddPair('messagebox_manage.drag_map_dir_repeat.caption', '你的地图有重复')
    .AddPair('messagebox_manage.drag_map_dir_repeat.text', '你想安装的地图有重复名称的文件，文件名是：${drag_file_name}，是否需要替换？')
    .AddPair('messagebox_manage.drag_map_format_error.caption', '安装文件格式错误')
    .AddPair('messagebox_manage.drag_map_format_error.text', '你想安装的地图文件格式不为文件夹或zip，文件名是：${drag_file_name}，无法安装，请重试！')
    .AddPair('messagebox_manage.drag_resourcepack.caption', '您安装的是纹理')
    .AddPair('messagebox_manage.drag_resourcepack.text', '你需要安装的是【纹理】，名称为：${drag_file_name}，请问是否继续？')
    .AddPair('messagebox_manage.drag_resourcepack_repeat.caption', '你的纹理有重复')
    .AddPair('messagebox_manage.drag_resourcepack_repeat.text', '你想安装的纹理有重复名称的文件，文件名是：${drag_file_name}，是否需要替换？')
    .AddPair('messagebox_manage.drag_resourcepack_format_error.caption', '安装文件格式错误')
    .AddPair('messagebox_manage.drag_resourcepack_format_error.text', '你想安装的纹理文件格式不为zip，文件名是：${drag_file_name}，无法安装，请重试！')
    .AddPair('messagebox_manage.drag_shader.caption', '您安装的是光影')
    .AddPair('messagebox_manage.drag_shader.text', '你需要安装的是【光影】，名称为：${drag_file_name}，请问是否继续？')
    .AddPair('messagebox_manage.drag_shader_repeat.caption', '你的光影有重复')
    .AddPair('messagebox_manage.drag_shader_repeat.text', '你想安装的光影有重复名称的文件，文件名是：${drag_file_name}，是否需要替换？')
    .AddPair('messagebox_manage.drag_shader_format_error.caption', '安装文件格式错误')
    .AddPair('messagebox_manage.drag_shader_format_error.text', '你想安装的光影文件格式不为zip，文件名是：${drag_file_name}，无法安装，请重试！')
    .AddPair('messagebox_manage.drag_plugin.caption', '您安装的是插件')
    .AddPair('messagebox_manage.drag_plugin.text', '你需要安装的是【插件】，名称为：${drag_file_name}，请问是否继续？')
    .AddPair('messagebox_manage.drag_plugin_repeat.caption', '你的插件有重复')
    .AddPair('messagebox_manage.drag_plugin_repeat.text', '你想安装的插件有重复名称的文件，文件名是：${drag_file_name}，是否需要替换？')
    .AddPair('messagebox_manage.drag_plugin_format_error.caption', '安装文件格式错误')
    .AddPair('messagebox_manage.drag_plugin_format_error.text', '你想安装的插件文件格式不为jar或zip，文件名是：${drag_file_name}，无法安装，请重试！')
    .AddPair('messagebox_manage.drag_datapack_no_choose_map_error.caption', '暂未选择地图')
    .AddPair('messagebox_manage.drag_datapack_no_choose_map_error.text', '你还未选择任意一个地图，无法导入数据包，请重试！')
    .AddPair('messagebox_manage.drag_datapack.caption', '您安装的时数据包')
    .AddPair('messagebox_manage.drag_datapack.text', '你需要安装的是【数据包】，名称为：${drag_file_name}，请问是否继续？')
    .AddPair('messagebox_manage.drag_datapack_repeat.caption', '你的数据包有重复')
    .AddPair('messagebox_manage.drag_datapack_repeat.text', '你想安装的数据包有重复名称的文件，文件名是：${drag_file_name}，是否需要替换？')
    .AddPair('messagebox_manage.drag_datapack_format_error.caption', '安装文件格式错误')
    .AddPair('messagebox_manage.drag_datapack_format_error.text', '你想安装的数据包文件格式不为zip，文件名是：${drag_file_name}，无法安装，请重试！')
    .AddPair('messagebox_manage.drag_file_finish.caption', '安装完成')
    .AddPair('messagebox_manage.drag_file_finish.text', '所有文件安装完成！')
    .AddPair('messagebox_manage.disable_resource_not_choose.caption', '无法禁用')
    .AddPair('messagebox_manage.disable_resource_not_choose.text', '你选中的资源不是模组或者插件，又或者你暂未选中任一资源，无法禁用，请重试。')
    .AddPair('messagebox_manage.resource_already_disable.caption', '已被禁用')
    .AddPair('messagebox_manage.resource_already_disable.text', '你选中的资源已被禁用，无法重复禁用，请重试。')
    .AddPair('messagebox_manage.enable_resource_not_choose.caption', '无法启用')
    .AddPair('messagebox_manage.enable_resource_not_choose.text', '你选中的资源不是模组或者插件，又或者你暂未选中任一资源，无法启用，请重试。')
    .AddPair('messagebox_manage.resource_already_enable.caption', '已被启用')
    .AddPair('messagebox_manage.resource_already_enable.text', '你选中的资源已被启用，无法重复启用，请重试')
    .AddPair('messagebox_manage.delete_resource_not_choose.caption', '无法删除！')
    .AddPair('messagebox_manage.delete_resource_not_choose.text', '你还暂未选中任一资源，无法删除，请重试。')
    .AddPair('messagebox_manage.resource_is_delete.caption', '请问是否删除')
    .AddPair('messagebox_manage.resource_is_delete.text', '是否删除掉此资源？会将其放入回收站。')
    .AddPair('messagebox_manage.rename_resource_not_choose.caption', '无法重命名')
    .AddPair('messagebox_manage.rename_resource_not_choose.text', '你还暂未选中任一资源，无法重命名，请重试。')
    .AddPair('inputbox_manage.rename_new_name.caption', '请输入命名的新名称')
    .AddPair('inputbox_manage.rename_new_name.text', '在下方输入命名的新名称，如果留空或者按取消则保持原名。')
    .AddPair('messagebox_manage.open_no_choose_resource.caption', '无法打开文件夹')
    .AddPair('messagebox_manage.open_no_choose_resource.text', '你还暂未选择任一资源，无法通过资源管理器打开')
    .AddPair('messagebox_launch.pre_launch_script_tip.caption', '前置启动脚本命令提示')
    .AddPair('messagebox_launch.pre_launch_script_tip.text', Concat('在书写该参数的时候，你需要注意一点，你当然可以选择书写shutdown -s -t 0，也可以选择调出你默认的服务端代码，甚至可以打开vscode。', #13#10,
            '但是请注意，此处命令只是会在启动游戏之前先默认执行一遍哦！而不是在启动游戏之后忽然给你执行一次，如果填入错误的话，本启动器将不会给出任何的错误提示哦！', #13#10,
            '顺带提一句，请使用【<空格>&<空格>】来分隔，如果你需要执行多行命令的话。目前暂未实现使用快捷键来指定目录，例如【使用{minecraft}指定mc当前目录】等功能哦！', #13#10,
            '当执行指令的时候，如果你愿意的话，你可以用C语言写一个无限循环，然后让启动器执行这个exe，但是该启动器会卡死，因为启动器会一直等待执行命令完毕才会启动MC。'))
    .AddPair('messagebox_launch.after_launch_script_tip.caption', '后置启动脚本命令提示')
    .AddPair('messagebox_launch.after_launch_script_tip.text', Concat('在书写该参数的时候，倒是可以写shutdown -s -t 0了，因为有可能你玩完游戏之后就会关机。', #13#10,
            '本参数的意思是当你结束MC运行的时候，开始执行该指令。如果在此期间，你手动关闭了本启动器，则不会执行该指令语句。', #13#10,
            '填入错误也不会有任何提示，并且也请使用【<空格>&<空格>】来分割多条指令，目前暂未实现快捷键指定目录。例如【使用{minecraft}指定mc当前目录】等功能。', #13#10,
            '如果该处有无限循环指令，则启动器将会一直等待下去【也就是卡死】，直到该指令执行完毕，才会松开句柄使得启动器恢复成可操作模式。'))
    .AddPair('messagebox_launch.default_jvm_tip.caption', '默认JVM参数提示')
    .AddPair('messagebox_launch.default_jvm_tip.text', Concat('默认JVM参数：这个是默认会在游戏启动中添加的参数，已设置ReadOnly。不要试图修改它，如果必要的话，请在以下的额外JVM参数下修改。'))
    .AddPair('messagebox_launch.additional_jvm_tip.caption', '额外JVM参数提示')
    .AddPair('messagebox_launch.additional_jvm_tip.text', Concat('额外JVM参数：这个会将你输入的参数名当做启动脚本的jvm参数最后一个新增上去。顺带一提，请用空格分隔你的参数，还有，非专业人士请勿修改。'))
    .AddPair('messagebox_launch.additional_game_tip.caption', '额外Game参数提示')
    .AddPair('messagebox_launch.additional_game_tip.text', Concat('额外game参数，又称额外游戏参数：这个会将你输入的参数名当作启动脚本的最后一个新增上去，顺带一提，请用空格分隔你的参数，还有，非专业人士请勿修改。', #13#10,
            '关于额外game参数的提示：不仅可以输入以下Hint中的参数，你还可以输入quickPlayMultiplayer然后附带<服务器地址>:<服务器端口>来进入服务器，其中如果服务器没有端口，则默认为25565。甚至可以适用quickPlayRealms，后面附带你的Realms代号。', #13#10,
            '自然，除了这些，你还可以指定quickPlayPath，该值接受一个log【输出】路径，你可以填入这个log，它将会记录你进入的世界的所有类型，你可以根据这些类型来填写quickPlay啥啥的参数。其实以上所有参数仅适用于23w14a以上，若你在其以下，你依旧需要在此指定--server和--port，如果一个服务器没有端口，则默认是25565。', #13#10,
            '不仅如此，你还可以在此输入--demo进入试玩模式或--fullScreen进入全屏，具体内容请参见：https://www.mcbbs.net/thread-1447730-1-1.html，切记，如果你的MC版本低于23w14a，你将无法使用以上quick等参数，只能使用--server、--port。'))
    .AddPair('messagebox_launch.is_full_scan_java.caption', '全盘扫描Java')
    .AddPair('messagebox_launch.is_full_scan_java.text', '你选择的是全盘扫描Java，可能会卡很久很久，耗时非常长，在此期间请勿关闭启动器哦！是否继续？')
    .AddPair('messagebox_launch.full_scan_java_error.caption', '扫描Java失败')
    .AddPair('messagebox_launch.full_scan_java_error.text', '扫描${drive}盘时出错，你是否给予了足够的权限？请尝试使用管理员启动程序后再试。')
    .AddPair('messagebox_launch.full_scan_java_success.caption', '扫描Java成功')
    .AddPair('messagebox_launch.full_scan_java_success.text', '所有磁盘全部扫描完毕，所有Java已添加至下拉框！')
    .AddPair('messagebox_launch.is_basic_scan_java.caption', '特定扫描Java')
    .AddPair('messagebox_launch.is_basic_scan_java.text', '你选择的是特定扫描Java，用时应该不会很久，在此期间请勿关闭启动器哦！是否继续？')
    .AddPair('messagebox_launch.basic_scan_java_search_regedit_error.caption', '特定扫描Java失败')
    .AddPair('messagebox_launch.basic_scan_java_search_regedit_error.text', '扫描注册表时出错，你是否给予了足够的权限？请尝试使用管理员启动程序后再试。')
    .AddPair('messagebox_launch.basic_scan_java_success.caption', '特定扫描Java成功')
    .AddPair('messagebox_launch.basic_scan_java_success.text', '所有特定目录全部扫描完毕，所有Java已添加至下拉框！')
    .AddPair('opendialog_launch.menual_import_java_dialog_title', '请选择Javaw文件')
    .AddPair('messagebox_launch.not_support_java_bit.caption', '不支持的Java位数')
    .AddPair('messagebox_launch.not_support_java_bit.text', '这个Java文件是32位Java，或者位数不支持显示，请重试。')
    .AddPair('messagebox_launch.menual_import_java_success.caption', '添加成功')
    .AddPair('messagebox_launch.menual_import_java_success.text', '手动添加Java成功！')
    .AddPair('messagebox_launch.not_choose_java.caption', '暂未选中Java')
    .AddPair('messagebox_launch.not_choose_java.text', '你目前还暂未选中任意Java，无法直接移除Java，请重试！')
    .AddPair('messagebox_launch.is_remove_java.caption', '是否移除Java')
    .AddPair('messagebox_launch.is_remove_java.text', '是否要移除当前选中的Java？')
    .AddPair('messagebox_launch.remove_java_success.caption', '移除Java成功')
    .AddPair('messagebox_launch.remove_java_success.text', '移除Java成功，但是你可以重新使用手动导入或者特定导入来导入这个Java。')
    .AddPair('messagebox_launch.get_java_metadata_error.caption', '获取Java元数据失败')
    .AddPair('messagebox_launch.get_java_metadata_error.text', '获取Java的元数据失败，你似乎并没有联网，或者该下载源不支持下载Java，请联网后再尝试。')
    .AddPair('messagebox_launch.get_java_manifest_error.caption', '获取Java版本元数据失败')
    .AddPair('messagebox_launch.get_java_manifest_error.text', '由于未知原因，获取Java(${java_version})(64)的版本元数据失败，请重试！')
    .AddPair('messagebox_launch.download_java_success.caption', '下载Java成功')
    .AddPair('messagebox_launch.download_java_success.text', '下载Java成功了，现在你可以通过特定扫描来导入Java了！')
    .AddPair('inputbox_launch.select_java_web.caption', '请选择你要下载的Java官网')
    .AddPair('inputbox_launch.select_java_web.text', '如果你不信任LLL下载的Java，你可以自行在此处输入你想进入的Java官网（这里给几个官网，推荐指数从上往下。），LLL会通过你电脑的默认浏览器打开官网。输入前面的序号即可：')
    .AddPair('messagebox_launch.open_java_web_error.caption', '输入的数字有误')
    .AddPair('messagebox_launch.open_java_web_error.text', '你输入了不支持的序号，请重新输入！')
    .AddPair('messagebox_download.not_choose_minecraft_versino.caption', '暂未选择Minecraft版本')
    .AddPair('messagebox_download.not_choose_minecraft_versino.text', '你还暂未选择任意Minecraft版本，无法加载模组加载器。')
    .AddPair('messagebox_download.view_mc_info_error.caption', '暂未选择Minecraft版本')
    .AddPair('messagebox_download.view_mc_info_error.text', '你还暂未选择任意Minecraft版本，无法查看信息。')
    .AddPair('messagebox_download.is_open_wiki.text', Concat('发布时间：${year}年${month}月${day}日${time}', #13#10, '是否打开Wiki查看更详情信息？'))
    .AddPair('messagebox_download.import_mc_info_error.caption', '无法读取MC信息')
    .AddPair('messagebox_download.import_mc_info_error.text', '查看MC信息时，无法读取该MC版本信息，请联系作者修复！')
    .AddPair('messagebox_download.not_choose_download.caption', '暂未选择Minecraft版本')
    .AddPair('messagebox_download.not_choose_download.text', '你还暂未选择任意Minecraft版本，无法下载MC。')
    .AddPair('messagebox_download.name_is_empty.caption', '名称为空')
    .AddPair('messagebox_download.name_is_empty.text', '你为此下载的Minecraft命的名称为空，请试着输入一个名称后再来。')
    .AddPair('messagebox_download.get_mc_dir_error.caption', '读取文件错误')
    .AddPair('messagebox_download.get_mc_dir_error.text', '你还暂未选中任意MC文件夹，请去版本设置里选中一个后再来！')
    .AddPair('messagebox_download.is_download_mc.caption', '将会被替换，是否继续')
    .AddPair('messagebox_download.is_download_mc.text', '如果你需要下载一个新版本的话，该版本会替换掉你原有的{minecraft}\versions\{version_name}文件夹下的所有内容，如果你开了版本隔离，请务必确保已经备份了版本。并且由LLL启动器下载的MC版本将很有可能不会被PCL2、HMCL、BakaXL等启动器识别并启动，请酌情选择。请点击是继续……')
    .AddPair('messagebox_download.install_forge_not_choose_java.caption', '暂未选中Java')
    .AddPair('messagebox_download.install_forge_not_choose_java.text', '你在安装Forge的时候，暂未选中任意Java文件，在安装Forge时必须要选中任一Java文件才能继续。')
    .AddPair('messagebox_download.download_no_data.caption', '暂无数据')
    .AddPair('messagebox_download.download_no_data.text', '你选择的模组加载器列表框元素是暂无数据，请重新选择一次模组加载器版本！')
    .AddPair('messagebox_download.is_install_forge.caption', '很大的不稳定性，是否继续')
    .AddPair('messagebox_download.is_install_forge.text', '特别提示：目前Forge自动安装极其不稳定，请慎重考虑是否需要使用LLL启动器自动安装。【如果在此处遇到了bug，请暂时不要反馈，作者已经在修了。。bug包括但不限于跑处理器的时候线程卡死等问题】，一旦点击是则视你默认遵守自动安装模组加载器所承担的一切后果【哪怕是启动器出现的下载问题。】如有疑惑，请与作者进行沟通。')
    .AddPair('messagebox_download.is_install_neoforge.caption', '是否跳转到安装NeoForged')
    .AddPair('messagebox_download.is_install_neoforge.text', '特别提示：如果你需要安装1.20.1或者以上版本的Forge，您可以考虑安装NeoForged，它是由cpw掌管的Forge，尽管如此，NeoForged也支持当今的几乎所有的原Forge版本的模组，您可以试试看。是否立刻跳转到NeoForged下载？【按否则立即以该版本安装。】')
    .AddPair('messagebox_download.not_support_forge_version.caption', '不受支持的Forge版本')
    .AddPair('messagebox_download.not_support_forge_version.text', '该Forge版本暂不受支持，因为里面没有installer，请重新选择一个受支持的Forge版本吧！')
    .AddPair('messagebox_download.download_forge_success.caption', '下载Forge成功')
    .AddPair('messagebox_download.download_forge_success.text', '下载Forge成功！现在你可以进入版本选择选择该版本进行游玩了！')
    .AddPair('messagebox_download.download_fabric_success.caption', '下载Fabric成功')
    .AddPair('messagebox_download.download_fabric_success.text', '下载Fabric成功！现在你可以进入版本选择选择该版本进行游玩了！')
    .AddPair('messagebox_download.download_quilt_success.caption', '下载Quilt成功')
    .AddPair('messagebox_download.download_quilt_success.text', '下载Quilt成功！现在你可以进入版本选择选择该版本进行游玩了！')
    .AddPair('messagebox_download.install_neoforge_not_choose_java.caption', '暂未选中Java')
    .AddPair('messagebox_download.install_neoforge_not_choose_java.text', '你在安装NeoForge的时候，暂未选中任意Java文件，在安装NeoForge时必须要选中任一Java文件才能继续。')
    .AddPair('messagebox_download.download_neoforge_success.caption', '下载NeoForge成功')
    .AddPair('messagebox_download.download_neoforge_success.text', '下载NeoForge成功！现在你可以进入版本选择选择该版本进行游玩了！')
    .AddPair('messagebox_download.download_mc_success.caption', '下载MC原版成功')
    .AddPair('messagebox_download.download_mc_success.text', '下载MC原版成功！现在你可以进入版本选择选择该版本进行游玩了！')
    .AddPair('selectdialog_customdl.select_save_path', '请选择自定义下载保存路径')
    .AddPair('messagebox_customdl.open_save_path_error.caption', '打开保存路径失败')
    .AddPair('messagebox_customdl.open_save_path_error.text', '你的保存路径输入得不正确，文件夹不存在或者路径有误，请重试！')
    .AddPair('messagebox_customdl.not_enter_url.caption', '暂未输入网址')
    .AddPair('messagebox_customdl.not_enter_url.text', '暂未输入网址，无法下载！')
    .AddPair('messagebox_customdl.path_not_exist.caption', '路径不存在')
    .AddPair('messagebox_customdl.path_not_exist.text', '路径不存在，无法下载！')
    .AddPair('messagebox_customdl.file_is_exists.caption', '已存在同名文件')
    .AddPair('messagebox_customdl.file_is_exists.text', '已存在同名的文件在你的路径下，是否直接替换？')
    .AddPair('messagebox_customdl.check_hash_success.caption', '检查文件Hash成功')
    .AddPair('messagebox_customdl.check_hash_success.text', '自定义下载完成！并且检查文件sha1成功！现在你可以去看下载的文件了！')
    .AddPair('messagebox_customdl.check_hash_error.caption', '检查文件Hash失败')
    .AddPair('messagebox_customdl.check_hash_error.text', '自定义下载完成！但是检查文件sha1失败了，你似乎输入了错误的文件sha1值，又或者是LLL启动器拼接文件时出错了……谁懂呢！请重试吧！')
    .AddPair('messagebox_customdl.custom_download_success.caption', '自定义下载完成')
    .AddPair('messagebox_customdl.custom_download_success.text', '自定义下载完成！未采取检查文件sha1方式，请去路径下查看吧！')
    .AddPair('messagebox_customdl.custom_download_error.caption', '自定义下载失败。')
    .AddPair('messagebox_customdl.custom_download_error.text', '自定义下载失败，可能原因应该是LLL启动器未能为你的文件拆分进行合并处理，又或者是有某单个文件下载失败导致未能拼接，请重试，请重试！')
    .AddPair('messagebod_modloader.not_choose_modloader.caption', '暂未选择任意版本')
    .AddPair('messagebod_modloader.not_choose_modloader.text', '你还暂未选择任意模组加载器版本进行手动安装包下载呢！请重试！【Forge和NeoForge需要去《下载Minecraft》中选择任一Minecraft版本才能下载噢！】')
    .AddPair('messagebox_modloader.download_modloader_success.caption', '下载成功')
    .AddPair('messagebox_modloader.download_modloader_success.text', '下载模组加载器手动安装包成功！现在你可以去文件夹中查看了！')
    .AddPair('messagebox_version.select_mc_success.caption', '选择成功')
    .AddPair('messagebox_version.select_mc_success.text', '选择MC文件夹成功！')
    .AddPair('selectdialog_version.select_mc_path', '请选择MC文件夹')
    .AddPair('inputbox_version.select_mc_name.caption', '请输入MC文件名')
    .AddPair('inputbox_version.select_mc_name.text', '请输入你要为这个文件夹命的名称，这里建议输入类似于【联机】等的这些有标识性的名字。')
    .AddPair('inputbox_version.select_new_mc_name.caption', '请输入MC文件名')
    .AddPair('inputbox_version.select_new_mc_name.text', '请输入你要为这个文件夹命的名称，，这里你选择的是此exe文件夹下的【.minecraft】文件夹，这里建议输入类似于【联机】等的这些有标识性的名字。')
    .AddPair('messagebox_version.path_is_exists.caption', '路径有重复')
    .AddPair('messagebox_version.path_is_exists.text', '你的文件夹路径有重复的，请重新再选择一个或者给此文件夹改名吧！')
    .AddPair('messagebox_version.create_minecraft_dir.caption', '创建成功')
    .AddPair('messagebox_version.create_minecraft_dir.text', '已为此exe路径下创建了一个名为.minecraft文件名的文件夹了！')
    .AddPair('messagebox_version.no_mc_dir.caption', '暂未选择MC文件夹')
    .AddPair('messagebox_version.no_mc_dir.text', '你还未选择任意一个文件夹呢，请去选择一个后重试！')
    .AddPair('inputbox_version.enter_mc_rename.caption', '请输入更改的名称')
    .AddPair('inputbox_version.enter_mc_rename.text', '请输入你需要更改的名称，留空或点击取消则退出。')
    .AddPair('messagebox_version.rename_mc_success.caption', '修改名称成功')
    .AddPair('messagebox_version.rename_mc_success.text', '修改名称成功了！现在你可以进行选择了！')
    .AddPair('messagebox_version.is_remove_mc_dir.caption', '是否移除文件列表')
    .AddPair('messagebox_version.is_remove_mc_dir.text', '是否移除文件列表？移除之后不会对文件有所修改。')
    .AddPair('messagebox_version.remove_mc_dir_success.caption', '移除成功')
    .AddPair('messagebox_version.remove_mc_dir_success.text', '移除文件列表成功！')
    .AddPair('messagebox_version.no_ver_dir.caption', '暂未选择MC版本')
    .AddPair('messagebox_version.no_ver_dir.text', '你还未选择任意一个MC的版本呢，请先点击添加一个MC文件夹，再选择一个MC版本，然后再重试！')
    .AddPair('inputbox_version.enter_ver_rename.caption', '请输入更改的名称')
    .AddPair('inputbox_version.enter_ver_rename.text', '请输入你需要更改的名称，留空或点击取消则退出。【在这里更改名称后可能导致PCL2、HMCL、BakaXL等主流启动器无法启动，请酌情修改！】')
    .AddPair('messagebox_version.rename_ver_success.caption', '重命名成功')
    .AddPair('messagebox_version.rename_ver_success.text', '重命名成功！')
    .AddPair('messagebox_version.rename_ver_error.caption', '重命名失败')
    .AddPair('messagebox_version.rename_ver_error.text', '重命名失败了，可能是LLL权限不足的原因，也有可能是该文件受保护，请取消后再试！')
    .AddPair('messagebox_version.is_delete_ver.caption', '是否删除该MC版本')
    .AddPair('messagebox_version.is_delete_ver.text', '由于该操作会直接删除{minecraft}\versions\{versionname}下的所有文件，且该操作不可逆。如果你开启了版本隔离，请确保你已经备份了该版本。该版本将会被彻底删除！是否继续？')
    .AddPair('messagebox_version.delete_ver_success.caption', '删除成功')
    .AddPair('messagebox_version.delete_ver_success.text', '删除成功！现在你必须重新从下载部分中下载该版本才能恢复了！')
    .AddPair('messagebox_version.delete_ver_error.caption', '删除失败')
    .AddPair('messagebox_version.delete_ver_error.text', '删除版本失败了，可能是LLL权限不足的原因，也有可能是该文件受保护，请取消后再试！')
    .AddPair('messagebox_version.cannot_find_vanilla_key.caption', '选择的版本内无JSON')
    .AddPair('messagebox_version.cannot_find_vanilla_key.text', '你选择的版本的文件夹里无JSON文件，如果是你误删了的话，请备份一次版本，重新去下载部分里下载一次吧！')
    .AddPair('messagebox_version.complete_version_success.caption', '补全文件成功')
    .AddPair('messagebox_version.complete_version_success.text', '补全文件成功了！现在该版本的资源是齐全的！')
    .AddPair('messagebox_export.cannot_find_vanilla_key.caption', '无法找到原版键')
    .AddPair('messagebox_export.cannot_find_vanilla_key.text', '无法找到原版的键值，请找到你的版本json文件，在里面的根对象中，新建一个键值对，键名是clientVersion，键值是【该版本的原版版本】。例如该版本是1.20.1-forge-47.1.0，则原版键值就是1.20.1。如果本身就是原版的话，就填写原版值即可！如果是快照版的话，也填入快照版的id即可！【例如1.20.3-pre2，填1.20.3-pre2即可！】')
    .AddPair('messagebox_export.not_choose_mode.caption', '暂未选择导出方式')
    .AddPair('messagebox_export.not_choose_mode.text', '你还暂未选择任一导出方式，请选择一个后再尝试！')
    .AddPair('messagebox_export.not_enter_name.caption', '暂未输入整合包名称')
    .AddPair('messagebox_export.not_enter_name.text', '你还暂未输入整合包名称，请输入后再尝试！')
    .AddPair('messagebox_export.not_enter_author.caption', '暂未输入整合包作者')
    .AddPair('messagebox_export.not_enter_author.text', '你还暂未输入整合包作者，请输入后再尝试！')
    .AddPair('messagebox_export.not_enter_version.caption', '暂未输入整合包版本')
    .AddPair('messagebox_export.not_enter_version.text', '你还暂未输入整合包版本，请输入后再尝试！')
    .AddPair('messagebox_export.update_link_error.caption', '整合包更新链接输入错误')
    .AddPair('messagebox_export.update_link_error.text', '整合包更新链接输入错误，请重新输入后再尝试！')
    .AddPair('messagebox_export.official_website_error.caption', '整合包官方网站输入错误')
    .AddPair('messagebox_export.official_website_error.text', '整合包官方网站输入错误，请重新输入后再尝试！')
    .AddPair('messagebox_export.authentication_server_error.caption', '整合包认证服务器输入错误')
    .AddPair('messagebox_export.authentication_server_error.text', '整合包认证服务器输入错误，请重新输入后再尝试！')
    .AddPair('messagebox_export.no_export_file.caption', '暂未选中任一导出文件')
    .AddPair('messagebox_export.no_export_file.text', '暂未选中任一导出文件，你必须至少选择一个文件后再进行导出，请重试！')
    .AddPair('savedialog_export.choose_export_path', '请选择整合包导出的保存路径')
    .AddPair('messagebox_export.export_file_exists.caption', '文件已存在')
    .AddPair('messagebox_export.export_file_exists.text', '你所选择的整合包导出路径已有一个相同文件名的文件，请删除或者重命名后再尝试！')
    .AddPair('messagebox_export.export_success.caption', '导出完成')
    .AddPair('messagebox_export.export_success.text', '你的整合包已导出完成，现在你可以去目录里面查看了！')
    .AddPair('messagebox_ipv6.choose_ip_timeout.caption', '超时IP不予选择')
    .AddPair('messagebox_ipv6.choose_ip_timeout.text', '你不能选择这个IP，因为这个IP在ping的时候超时了！')
    .AddPair('messagebox_ipv6.port_enter_error.caption', '端口输入错误')
    .AddPair('messagebox_ipv6.port_enter_error.text', '你的游戏端口输入错误啦！请输入1024~65536之间，并且只能为数字！')
    .AddPair('messagebox_ipv6.no_ipv6_choose.caption', '暂未选中任意IPv6地址')
    .AddPair('messagebox_ipv6.no_ipv6_choose.text', '暂未选中任意IPv6地址，请至少扫描一次后，选中任一IPv6地址再复制！')
    .AddPair('messagebox_ipv6.copy_link_success.caption', '复制成功')
    .AddPair('messagebox_ipv6.copy_link_success.text', '复制链接成功！现在你可以将链接发送给你的好友进行联机了！')
    .AddPair('messagebox_ipv6.online_tips.caption', 'IPv6联机提示')
    .AddPair('messagebox_ipv6.online_tips.text', Concat('亲爱的玩家：', #13#10,
            '这里你将体验到使用IPv6公网进行联机的功能。在此有以下几点要求：', #13#10,
            '1.你的电脑必须支持IPv6公网，这样才能检测得出公网地址。如果不支持，你需要去网上寻找教程来开启IPv6公网。', #13#10,
            '2.你的电脑网络环境必须要好，如果网络环境不好，那么再出色的联机方式也无力回天。', #13#10,
            '3.你必须对MC多人联机的机制有所了解，例如如何打开MC的多人联机，显示端口等。', #13#10,
            '4.此联机模式必须双方均拥有IPv6公网IP连接，如果有一方未有，则无法联机。', #13#10,
            '5.此功能必须在MC启动参数中不能有【-Djava.net.preferIPv4Stack=true】，如果必须有，则你需要联系该启动器作者将其删除。', #13#10,
            '6.或者，如果必须有以上参数，则你可以在启动器中设置额外JVM参数，复制上方参数，并将上方的true改为false即可。', #13#10,
            '点进联机部分，首先点击一次【开始检测IPv6公网IP】，如果有IPv6，则底下的列表框将会显示你目前所有IPv6地址。', #13#10,
            '如果列表框中一项也没有，则说明你没有IPv6地址，则参考第一点要求。', #13#10,
            '此时在列表框中随便点击一项IP【会有临时和永久的显示】', #13#10,
            '然后在文本框内输入你游戏内的端口号，此时下面的Label框会产生改变。', #13#10,
            '然后点击复制IPv6公网IP，此时IP会复制进剪切板，然后将IP地址发给你的好友 ', #13#10,
            '即可开始联机之旅！'))
    .AddPair('messagebox_account.area_not_chinese.caption', '国家地区不为中国')
    .AddPair('messagebox_account.area_not_chinese.text', '目前你的国家地区不为中国，你无法使用第三方外置登录，请使用微软登录！')
    .AddPair('messagebox_download.area_not_chinese.caption', '国家地区不为中国')
    .AddPair('messagebox_download.area_not_chinese.text', '目前你的国家地区不为中国，你无法使用除官方以外的任何下载源，请使用官方下载源！')
    .AddPair('messagebox_export.area_not_chinese.caption', '国家地区不为中国')
    .AddPair('messagebox_export.area_not_chinese.text', '目前你的国家地区不为中国，你无法使用MCBBS导出源，请使用MultiMC导出源！')
    .AddPair('messagebox_launcher.not_choose_mc_version.caption', '暂未选择MC版本')
    .AddPair('messagebox_launcher.not_choose_mc_version.text', '你还暂未选择任一MC版本，请去选择一个后再来吧！')
    .AddPair('messagebox_launcher.not_choose_java.caption', '暂未选择Java')
    .AddPair('messagebox_launcher.not_choose_java.text', '你还暂未选择任一Java，请去选择一个后再来吧！')
    .AddPair('messagebox_launcher.access_token_expire.caption', 'Access Token已过期')
    .AddPair('messagebox_launcher.access_token_expire.text', '你的Access Token已过期了，请去账号部分刷新一次账号或者重新登录一次吧！')
    .AddPair('messagebox_launcher.not_support_thirdparty.caption', '登录方式不支持')
    .AddPair('messagebox_launcher.not_support_thirdparty.text', '目前由于你并不处于中国地区，因此无法使用第三方外置登录启动游戏，你似乎导入成了别人的账号配置文件，请重试！')
    .AddPair('messagebox_launcher.not_support_login_type.caption', '不支持的登录方式')
    .AddPair('messagebox_launcher.not_support_login_type.text', '你使用了一种并不受支持的登录方式，你似乎修改了账号配置文件中的内容，请立即修改回来！')
    .AddPair('messagebox_launcher.not_choose_account.caption', '暂未选择账号')
    .AddPair('messagebox_launcher.not_choose_account.text', '你还暂未选择任一账号，请去选择一个后再来吧！')
    .AddPair('messagebox_launcher.cannot_find_json.caption', '未找到JSON错误')
    .AddPair('messagebox_launcher.cannot_find_json.text', '版本错误，未从版本文件夹中找到json文件！')
    .AddPair('messagebox_launcher.unzip_native_error.caption', '未能成功解压Natives文件夹')
    .AddPair('messagebox_launcher.unzip_native_error.text', '未能成功解压Natives文件夹，请将此报错上传给作者，同时请尝试使用别的启动器启动一次后再尝试用LLL启动器！')
    .AddPair('messagebox_launcher.cannot_set_launch_args.caption', '无法拼接启动参数')
    .AddPair('messagebox_launcher.cannot_set_launch_args.text', '你的版本JSON似乎有误，无法解析版本JSON文件，请重试！')
    .AddPair('messagebox_launcher.cannot_find_authlib_file.caption', '找不到Authlib-Injector文件')
    .AddPair('messagebox_launcher.cannot_find_authlib_file.text', '找不到Authlib-Injector文件，请进入账号部分重新下载一次！')
    .AddPair('messagebox_launcher.is_export_arguments.caption', '是否进行启动脚本导出')
    .AddPair('messagebox_launcher.is_export_arguments.text', '是否进行启动脚本导出？将导出至【{exe}\LLLauncher\LaunchArguments\args】目录下。')
    .AddPair('messagebox_launcher.is_hide_accesstoken.caption', '是否将AccessToken进行打码')
    .AddPair('messagebox_launcher.is_hide_accesstoken.text', '在此做个声明：如果你的登录方式为【微软登录/外置登录】，则请你慎重的考虑选择“否”不进行打码，因为AccessToken实在是太重要了，即使它只有24小时有效期。你绝对不可以将附有AccessToken启动令牌的启动参数随意发给别人！【ps：自然，如果选择否的话，则你后续将无法使用该启动脚本进行正版登录。】')
    .AddPair('messagebox_launcher.export_launch_args_success.caption', '导出成功')
    .AddPair('messagebox_launcher.export_launch_args_success.text', '启动参数导出成功！现在你可以去文件夹里查看了！')
    .AddPair('messagebox_launcher.args_put_success.caption', '参数拼接成功')
    .AddPair('messagebox_launcher.args_put_success.text', '参数拼接成功！是否立刻启动游戏？')
    .AddPair('messagebox_plugin.lose_content_value.caption', '缺失了某个必要值')
    .AddPair('messagebox_plugin.lose_content_value.text', '该插件于content中缺失了某个必要值，请尝试修改后再点击！')
    .AddPair('messagebox_plugin.lose_form_name.caption', '窗口缺少了name值')
    .AddPair('messagebox_plugin.lose_form_name.text', '该插件在窗口处缺失了name值，请尝试修改后再点击！')
    .AddPair('messagebox_plugin.plugin_grammar_error.caption', '窗口缺失了plugin_name值')
    .AddPair('messagebox_plugin.plugin_grammar_error.text', '该插件在窗口处缺失了plugin_name值，请尝试修改后再点击！')
    .AddPair('messagebox_manage.drag_modpack_only_one_file.caption', '无法拖入多个文件')
    .AddPair('messagebox_manage.drag_modpack_only_one_file.text', '无法在导入整合包的时候拖入多个文件，你只能拖入一个！')
    .AddPair('messagebox_manage.drag_modpack_format_error.caption', '整合包格式不符')
    .AddPair('messagebox_manage.drag_modpack_format_error.text', '拖入的整合包只允许【mrpack】或者【zip】后缀的文件，无法拖入别的！')
    .AddPair('messagebox_manage.cannot_unzip_modpack.caption', '解压整合包失败')
    .AddPair('messagebox_manage.cannot_unzip_modpack.caption', '解压整合包失败了！你似乎给整合包上了密码，或者这个整合包不是正确的整合包，请重试！')
    .AddPair('opendialog_export.add_icon', '请选择你要添加的图标')
    .AddPair('picturebox_manage.import_modrinth_modpack.text', Concat(
            '整合包类型：${modpack_game}', #13#10,
            '整合包名称：${modpack_name}', #13#10,
            '整合包版本：${modpack_version}', #13#10,
            '整合包简介：${modpack_summary}', #13#10,
            '-----------------------------------------------------------------------------------------------------------------------', #13#10,
            '整合包MC版本：${modpack_mcversion}', #13#10,
            '整合包模组加载器：${modpack_modloader}', #13#10,
            '整合包模组加载器版本：${modpack_modloader_version}', #13#10,
            '是否继续安装？点是即安装。'))
    .AddPair('messagebox_manage.read_config_error.caption', '读取配置文件失败！')
    .AddPair('messagebox_manage.read_config_error.text', '读取配置文件失败了！你似乎没有选中任意游戏文件夹或者Java，请去选中一个再来！')
    .AddPair('messagebox_manage.cannot_read_modloader_type.caption', '无法读取模组加载器')
    .AddPair('messagebox_manage.cannot_read_modloader_type.text', '你在导入整合包的时候，选择了不受支持的模组加载器。如果你非要玩这个整合包，请使用别的启动器导入一次吧！')
    .AddPair('picturebox_manage.import_multimc_modpack.text', Concat(
            '整合包类型：${modpack_game}', #13#10,
            '整合包名称：${modpack_name}', #13#10,
            '整合包简介：${modpack_summary}', #13#10,
            '-----------------------------------------------------------------------------------------------------------------------', #13#10,
            '整合包MC版本：${modpack_mcversion}', #13#10,
            '整合包模组加载器：${modpack_modloader}', #13#10,
            '整合包模组加载器版本：${modpack_modloader_version}', #13#10,
            '是否继续安装？点是即安装。'))
    .AddPair('picturebox_manage.import_mcbbs_modpack.text', Concat(
            '整合包类型：${modpack_game}', #13#10,
            '整合包名称：${modpack_name}', #13#10,
            '整合包版本：${modpack_version}', #13#10,
            '整合包作者：${modpack_author}', #13#10,
            '整合包简介：${modpack_summary}', #13#10,
            '整合包更新链接：${modpack_update_url}', #13#10,
            '整合包官方网站：${modpack_official_url}', #13#10,
            '整合包外置登录服务器官网：${modpack_server}', #13#10,
            '-----------------------------------------------------------------------------------------------------------------------', #13#10,
            '整合包MC版本：${modpack_mcversion}', #13#10,
            '整合包模组加载器：${modpack_modloader}', #13#10,
            '整合包模组加载器版本：${modpack_modloader_version}', #13#10,
            '是否继续安装？点是即安装。'))
    .AddPair('messagebox_manage.not_support_modpack_type.caption', '不受支持的整合包格式！')
    .AddPair('messagebox_manage.not_support_modpack_type.text', '在你导入的这个整合包中，并不存在modrinth.index.json、manifest.json、mcbbs.packmeta、mmc-pack.json中的任意一个，请重新下载你的整合包并重试！【或者直接解压缩至versions文件夹中也行。】')
    .AddPair('picturebox_manage.import_curseforge_modpack.text', Concat(
            '整合包类型：${modpack_game}', #13#10,
            '整合包名称：${modpack_name}', #13#10,
            '整合包版本：${modpack_version}', #13#10,
            '整合包作者：${modpack_author}', #13#10,
            '-----------------------------------------------------------------------------------------------------------------------', #13#10,
            '整合包MC版本：${modpack_mcversion}', #13#10,
            '整合包模组加载器：${modpack_modloader}', #13#10,
            '整合包模组加载器版本：${modpack_modloader_version}', #13#10,
            '是否继续安装？点是即安装。'))
    .AddPair('messagebox_manage.import_modpack_success.caption', '安装整合包成功！')
    .AddPair('messagebox_manage.import_modpack_success.text', '恭喜安装整合包成功了！现在你可以去玩了！')
    .AddPair('messagebox_open.is_open_document.caption', '第一次打开启动器')
    .AddPair('messagebox_open.is_open_document.text', '已检测出你目前是第一次打开该启动器，请问是否打开新手帮助文档来查看一些设置应该怎么设置？')
    .AddPair('messagebox_plugin.plugin_suffix_error.caption', '插件部分加载失败')
    .AddPair('messagebox_plugin.plugin_suffix_error.text', '插件部分检测到suffix值。但是似乎suffix值不是json，于是加载失败啦！')
    .AddPair('messagebox_plugin.plugin_context_error.caption', '插件部分加载失败')
    .AddPair('messagebox_plugin.plugin_context_error.text', '插件部分检测内容为空，加载失败！')
    //以下为下载进度列表框
    .AddPair('label_progress_download_progress.caption', '下载进度：${download_progress}% | ${download_current_count}/${download_all_count}')
    .AddPair('downloadlist.custom.judge_can_multi_thread_download', '正在判断是否可以多线程下载。')
    .AddPair('downloadlist.custom.url_donot_support_download_in_launcher', '该网址不支持启动器下载，请使用浏览器下载吧！')
    .AddPair('downloadlist.custom.input_url_error_and_this_url_doesnot_has_file', '网址输入错误，该网址下无任何文件。')
    .AddPair('downloadlist.custom.url_statucode_is_not_206_and_try_to_cut', '该网站请求代码不为206，正在对其进行分段……')
    .AddPair('downloadlist.custom.not_allow_cut_use_single_thread_download', '该网站不允许分段下载，已用单线程将该文件下载下来。')
    .AddPair('downloadlist.custom.url_allow_multi_thread_download', '该网站支持多线程下载！')
    .AddPair('downloadlist.custom.url_file_size', '文件长度：${url_file_size}')
    .AddPair('downloadlist.custom.thread_one_to_single_thread_download', '由于你选择的线程是单线程，现在将直接采取单线程的下载方式。')
    .AddPair('downloadlist.custom.single_thread_download_error', '单线程下载失败，请重试。')
    .AddPair('downloadlist.custom.cut_download_error', '分段下载已下载失败，请重试！')
    .AddPair('downloadlist.custom.cut_download_success', '分段下载已下载完成：${cut_download_count}')
    .AddPair('downloadlist.custom.cut_download_join_error', '已检测出文件下载并不完整，下载失败！')
    .AddPair('downloadlist.custom.download_finish', '下载已完成！耗时：${download_finish_time}秒。')
    .AddPair('downloadlist.judge.judge_source_official', '已检测出你的下载源为：官方')
    .AddPair('downloadlist.judge.judge_source_bmclapi', '已检测出你的下载源为：BMCLAPI')
    .AddPair('downloadlist.mc.json_has_inheritsfrom', '你下载的版本json有inheritsFrom键')
    .AddPair('downloadlist.mc.get_vanilla_json_error', '获取原版MC版本失败')
    .AddPair('downloadlist.mc.get_vanilla_json_success', '获取原版MC版本成功')
    .AddPair('downloadlist.mc.get_version_json_error', '获取MC版本JSON失败')
    .AddPair('downloadlist.mc.get_version_json_success', '获取MC版本JSON成功')
    .AddPair('downloadlist.mc.mc_vanilla_id_not_found', '未能找到JSON中的原版键值，下载失败！')
    .AddPair('downloadlist.mc.downloading_main_version_jar', '正在下载主版本jar文件')
    .AddPair('downloadlist.mc.download_main_version_jar_finish', '主版本jar文件下载完成')
    .AddPair('downloadlist.mc.main_version_jar_exists', '已存在主版本jar文件')
    .AddPair('downloadlist.mc.downloading_asset_index_json', '正在下载资源索引JSON文件')
    .AddPair('downloadlist.mc.downloading_asset_index_error', '下载资源索引JSON文件时网络错误，请重试……')
    .AddPair('downloadlist.mc.download_asset_index_finish', '资源索引JSON文件下载完成')
    .AddPair('downloadlist.mc.asset_index_json_exists', '已存在资源索引JSON文件')
    .AddPair('downloadlist.mc.current_download_library', '正在下载资源库文件，请保持网络通畅，并且时刻注意进度条。')
    .AddPair('downloadlist.mc.download_library_success', '下载MC库文件成功，现在开始下载资源文件。')
    .AddPair('downloadlist.mc.download_assets_success', '下载MC资源文件成功，现在开始判断下载的是否为forge。')
    .AddPair('downloadlist.mc.judge_download_forge', '已在version文件夹中找到install_profile.json，判断你下载的是Forge。')
    .AddPair('downloadlist.mc.download_mc_finish', '下载MC已完成，耗时：${download_finish_time}秒。')
    .AddPair('downloadlist.window.file_is_exists', '已存在：${file_exists_name}')
    .AddPair('downloadlist.window.download_error_retry', '下载失败，正在重试：${file_error_name}')
    .AddPair('downloadlist.window.switch_download_source', '正在切换下载源：${source_name}')
    .AddPair('downloadlist.window.retry_threetime_error', '重试3次后依旧失败，下载失败！')
    .AddPair('downloadlist.window.download_success', '下载成功：${file_success_name}')
    .AddPair('downloadlist.backup.backup_success', '已备份：${backup_file_name}')
    .AddPair('downloadlist.backup.backup_error', '备份失败：${backup_file_name}')
    .AddPair('downloadlist.java.download_java_finish', '下载Java已完成，耗时${download_finish_time}秒。')
    .AddPair('downloadlist.forge.forge_version_not_allow_install', '该版本的forge不允许自动安装，请重试……')
    .AddPair('downloadlist.forge.download_forge_installer_start', '正在下载Forge安装器jar中。')
    .AddPair('downloadlist.forge.download_forge_installer_success', '下载Forge安装器jar成功。')
    .AddPair('downloadlist.forge.unzip_installer_error', '安装器jar解压缩失败，请重试！')
    .AddPair('downloadlist.forge.cannot_find_version_json', '未能从安装器jar中解包找到version.json，该版本不支持forge自动安装。')
    .AddPair('downloadlist.forge.get_forge_json', '已提取出version.json，正在下载原版MC。')
    .AddPair('downloadlist.forge.cannot_find_installprofile_json', '未能从安装器jar中解包找到install_profile.json，该版本不支持forge自动安装。')
    .AddPair('downloadlist.forge.cannot_fine_versioninfo_profile', '未能在install_profile.json中找到特需库下载，请重试！')
    .AddPair('downloadlist.forge.current_download_library', '正在下载Forge必要库文件。')
    .AddPair('downloadlist.forge.copy_installprofile_success_setup_mc', '已在安装包中找到install_profile，现在开始下载！')
    .AddPair('downloadlist.forge.installer_version_lower', '由于你安装的forge版本过低，因此无需跑forge处理器。')
    .AddPair('downloadlist.forge.cannot_extra_lzma', '无法提取出lzma文件，也许是因为你要下载的Forge版本过低了。')
    .AddPair('downloadlist.forge.start_run_processors', '现在正在开始用单线程跑Forge处理器中……')
    .AddPair('downloadlist.forge.not_choose_any_java', '你暂未选中任何一个Java，无法跑Forge处理器，请重试！')
    .AddPair('downloadlist.forge.skip_processors', '已跳过：${processors_count}')
    .AddPair('downloadlist.forge.run_processors_error', '运行失败：${processors_count}')
    .AddPair('downloadlist.forge.run_processors_success', '已完成：${processors_count}')
    .AddPair('downloadlist.forge.download_forge_success', '下载Forge已完成，耗时：${download_finish_time}秒')
    .AddPair('downloadlist.forge.cannot_extra_miencraft_jar', '无法检测出Minecraft原版Jar包，请将此错误反馈给作者！')
    .AddPair('downloadlist.authlib.check_authlib_update', '正在检查Authlib-Injector是否有更新')
    .AddPair('downloadlist.authlib.check_authlib_error', '检测Authlib失败，请重试。')
    .AddPair('downloadlist.authlib.authlib_has_update', '已检测出Authlib更新，正在下载')
    .AddPair('downloadlist.authlib.download_authlib_error', 'Authlib-Injector下载失败，请重试！')
    .AddPair('downloadlist.authlib.downlaod_authlib_success', 'Authlib-Injector下载成功！')
    .AddPair('downloadlist.resource.start_download', '正在下载该资源……')
    .AddPair('downloadlist.resource.download_success', '资源下载已完成')
    .AddPair('downloadlist.java.get_java_metadata', '正在获取Java总元数据中……')
    .AddPair('downloadlist.java.get_java_metadata_error', '获取Java元数据失败！你似乎没有联网。请重试。')
    .AddPair('downloadlist.java.get_java_manifest', '正在获取Java(${java_version})(64)版本元数据中……')
    .AddPair('downloadlist.java.get_java_manifest_error', '由于未知原因，获取Java(${java_version})(64)版本元数据失败！')
    .AddPair('downloadlist.java.get_java_success', '获取Java所有的元数据成功！现在开始下载！')
    .AddPair('downloadlist.java.download_java_success', '下载Java成功！现在你可以通过特定扫描来找到Java了。')
    .AddPair('downloadlist.download.start_download', '已检测出你想要的下载是：${version}，下载源：${source}')
    .AddPair('downloadlist.download.get_fabric_metadata_error', '在读取Fabric的元数据时出现错误，你似乎没有联网，请重试！')
    .AddPair('downloadlist.download.fabric_metadata_download_success', '下载Fabric元数据成功！现在开始下载MC')
    .AddPair('downloadlist.download.get_quilt_metadata_error', '在读取Quilt的元数据时出现错误，你似乎没有联网，请重试！')
    .AddPair('downloadlist.download.quilt_metadata_download_success', '下载Quilt元数据成功！现在开始下载MC')
    .AddPair('downloadlist.download.get_mc_metadata', '正在开始下载MC元数据')
    .AddPair('downloadlist.download.get_mc_metadata_error', '获取MC元数据失败，请重试！')
    .AddPair('downloadlist.download.mc_metadata_download_success', '获取MC元数据成功，开始下载MC！')
    .AddPair('downloadlist.customdl.start_custom_download', '正在下载自定义文件……')
    .AddPair('downloadlist.modloader.download_success', '下载模组加载器手动安装包完成！现在可以去文件夹中查看了！')
    .AddPair('downloadlist.version.get_complete_version', '正在补全该版本的资源索引……')
    .AddPair('downloadlist.version.complete_version_success', '补全资源完成！')
    .AddPair('downloadlist.modpack.download_modpack_start', '正在下载整合包中……')
    .AddPair('downloadlist.source.download_failure', '下载失败，请重试！')
    //以下为下载进度窗口
    .AddPair('button_progress_hide_show_details.caption.show', '显示详情')
    .AddPair('button_progress_hide_show_details.caption.hide', '隐藏详情')
    .AddPair('button_progress_clean_download_list.caption', '清空下载信息列表框')
    .AddPair('label_progress_tips.caption', '一旦开始下载就停止不了了！')
    //以下为主窗口
    .AddPair('groupbox_message_board.caption', '留言板（点我可以更换留言板噢！）')
    .AddPair('label_account_view.caption.absence', '你还暂未登录任何一个账号，登录后即可在这里查看欢迎语！')
    .AddPair('label_account_view.caption.have', '你好啊：${account_view}，祝你有个愉快的一天！')
    .AddPair('label_open_launcher_time.caption', '打开启动器时间：${open_launcher_time}')
    .AddPair('label_open_launcher_number.caption', '打开启动器次数：${open_launcher_number}')
    .AddPair('label_launch_game_number.caption', '启动游戏的次数：${launch_game_number}')
    .AddPair('button_launch_game.caption.error.cannot_find_json', '（错误，未找到JSON）')
    .AddPair('button_launch_game.caption.error.missing_inherits_version', '（错误，缺少前置版本）')
    .AddPair('button_launch_game.caption.isolation', '（独立）')
    .AddPair('button_launch_game.caption.absence', Concat('开始游戏', #13#10, '你还暂未选中一个版本哦！'))
    .AddPair('button_launch_game.caption', Concat('开始游戏', #13#10, '${launch_version_name}'))
    .AddPair('button_launch_game.hint', '开始玩MC！')
    .AddPair('image_refresh_background_image.hint', '刷新你的背景图片')
    .AddPair('image_refresh_background_music.hint', '刷新你的背景音乐')
    .AddPair('image_open_download_prograss.hint', '打开下载进度界面')
    .AddPair('image_exit_running_mc.hint', '调用taskkill函数，强制结束你当前正在运行的MC')
    //以下为背景设置
    .AddPair('label_background_tip.caption', '这里是背景部分，你可以选择自己喜欢的背景颜色【说实话只是边框而已啦……】')
    .AddPair('label_standard_color.caption', '这里是标准配色，按一下直接应用')
    .AddPair('button_grass_color.caption', '小草绿')
    .AddPair('button_sun_color.caption', '日落黄')
    .AddPair('button_sultan_color.caption', '苏丹红')
    .AddPair('button_sky_color.caption', '天空蓝')
    .AddPair('button_cute_color.caption', '可爱粉')
    .AddPair('button_normal_color.caption', '默认白')
    .AddPair('button_custom_color.caption', '自定义配色')
    .AddPair('label_background_window_alpha.caption', '设置窗口透明度【只允许127~255，因为过低会导致启动器不见】')
    .AddPair('label_background_window_current_alpha.caption', '当前选中：${window_alpha}')
    .AddPair('label_background_control_alpha.caption', '设置控件透明度【只允许63~191，因为过高会导致背景图片不见，过低会导致控件不见】')
    .AddPair('label_background_control_current_alpha.caption', '当前选中：${control_alpha}')
    .AddPair('groupbox_background_music_setting.caption', '背景音乐设置')
    .AddPair('button_background_play_music.caption', '播放音乐')
    .AddPair('button_background_play_music.hint', '手动播放上被挂起与已经放完的音乐，如果未点主界面刷新音乐则会重新随机播放一次。')
    .AddPair('button_background_pause_music.caption', '暂停音乐')
    .AddPair('button_background_pause_music.hint', '点此只是会将音乐暂停，点击播放音乐后将会按照上次暂停时长接着播放。')
    .AddPair('button_background_stop_music.caption', '停止音乐')
    .AddPair('button_background_stop_music.hint', '点此会记录下mp3文件名，再点击播放音乐时会从头播放。')
    .AddPair('radiobutton_background_music_open.caption', '打开启动器时播放')
    .AddPair('radiobutton_background_music_launch.caption', '启动游戏时播放')
    .AddPair('radiobutton_background_music_not.caption', '不自动播放')
    .AddPair('groupbox_background_launch_setting.caption', '启动游戏设置部分')
    .AddPair('radiobutton_background_launch_hide.caption', '启动MC时隐藏窗口')
    .AddPair('radiobutton_background_launch_show.caption', '启动MC时显示窗口')
    .AddPair('radiobutton_background_launch_exit.caption', '启动MC时退出窗口')
    .AddPair('label_background_mainform_title.caption', '设置启动器标题')
    .AddPair('groupbox_background_gradient.caption', '窗口渐变产生')
    .AddPair('toggleswitch_background_gradient.on.caption', '开启渐变')
    .AddPair('toggleswitch_background_gradient.off.caption', '关闭渐变')
    .AddPair('label_background_gradient_value.caption', '渐变值')       
    .AddPair('label_background_gradient_current_value.caption', '当前选中：${gradient_value}')
    .AddPair('label_background_gradient_step.caption', '渐变步长')
    .AddPair('label_background_gradient_current_step.caption', '当前选中：${gradient_step}')
    //以下为账号部分
    .AddPair('combobox_all_account.offline_tip', '（离线）')
    .AddPair('combobox_all_account.microsoft_tip', '（微软）')
    .AddPair('combobox_all_account.thirdparty_tip', '（外置）')
    .AddPair('label_login_avatar.caption', '登录头像')
    .AddPair('label_all_account.caption', '所有账号')
    .AddPair('groupbox_offline_skin.caption', '切换离线皮肤（仅修改UUID项）【仅支持22w45a以上】')
    .AddPair('label_offline_name.caption', '名称')
    .AddPair('edit_offline_name.texthint', '请输入离线模式昵称')
    .AddPair('label_offline_uuid.caption', 'UUID')
    .AddPair('edit_offline_uuid.texthint', '输入32位16进制的UUID【可以留空，留空则随机生成一个UUID】')
    .AddPair('button_offline_name_to_uuid.caption', '通过正版用户名获取正版UUID')
    .AddPair('button_offline_uuid_to_name.caption', '通过正版UUID获取正版用户名')
    .AddPair('button_microsoft_oauth_login.caption', 'OAuth验证流登录')
    .AddPair('label_thirdparty_server.caption', '服务器')
    .AddPair('label_thirdparty_account.caption', '账号')
    .AddPair('label_thirdparty_password.caption', '密码')
    .AddPair('button_thirdparty_check_authlib_update.caption', '检测Authlib是否有更新')
    .AddPair('button_add_account.caption', '添加账号')
    .AddPair('button_delete_account.caption', '删除账号')
    .AddPair('button_refresh_account.caption', '刷新账号')
    .AddPair('button_account_get_uuid.caption', '查看账号UUID')
    .AddPair('label_account_return_value.caption.not_login', '未登录。')
    .AddPair('label_account_return_value.caption.logined', '已登录，玩家名称：${player_name}')
    .AddPair('label_account_return_value.caption.offline_get_avatar', '正在尝试根据离线UUID获取正版用户大头像……')
    .AddPair('label_account_return_value.caption.add_offline_success', '添加成功！已通过UUID获取离线皮肤！')
    .AddPair('label_account_return_value.caption.thirdparty_cannot_get_metadata', '外置登录添加失败，请重试。')
    .AddPair('label_account_return_value.caption.thirdparty_cannot_refresh_skin', '重置外置登录时失败，也许官网皮肤已被删除。')
    .AddPair('label_account_return_value.caption.thirdparty_unknown_error', '在登录时发生了未知错误，请重试！')
    .AddPair('label_account_return_value.caption.thirdparty_accesstoken_invalid', '你的登录令牌已经失效，请尝试重新登录一次吧！')
    .AddPair('label_account_return_value.caption.thirdparty_username_or_password_nottrue', '外置登录时，邮箱或密码输入错误。')
    .AddPair('label_account_return_value.caption.thirdparty_not_choose_skin', '暂未在皮肤站中选取任意一个角色。')
    .AddPair('label_account_return_value.caption.add_account_success_and_get_avatar', '添加完毕账号，现在开始获取皮肤大头像。')
    .AddPair('label_account_return_value.caption.thirdparty_entry_other_char', '选择角色时输入错误的字符。')
    .AddPair('label_account_return_value.caption.thirdparty_login_start', '正在添加外置登录……')
    .AddPair('label_account_return_value.caption.connect_error', '由于网络原因添加失败，请重试！')
    .AddPair('label_account_return_value.caption.add_thirdparty_success', '添加成功！已通过外置登录成功添加！')
    .AddPair('label_account_return_value.caption.microsoft_not_complete_oauth_login', '登录失败，暂未完成登录。')
    .AddPair('label_account_return_value.caption.microsoft_login_timeout', '登录失败，登录超时。')
    .AddPair('label_account_return_value.caption.microsoft_refresh_expire', '重置失败，刷新密钥同样过期，请重新登录一次账号。')
    .AddPair('label_account_return_value.caption.microsoft_uhs_not_same', '登录失败，xbox与xsts获取的uhs不一致。')
    .AddPair('label_account_return_value.caption.get_oauth_user_code', '正在获取用户代码')
    .AddPair('label_account_return_value.caption.post_microsoft', '正在请求microsoft中……')
    .AddPair('label_account_return_value.caption.post_xbox', '请求完毕microsoft，正在请求xbox中……')
    .AddPair('label_account_return_value.caption.post_xsts', '请求完毕xbox，正在请求xsts中……')
    .AddPair('label_account_return_value.caption.post_mc', '请求完毕xsts，正在请求mc中……')
    .AddPair('label_account_return_value.caption.get_has_mc', '请求完毕xsts，正在请求mc中……')
    .AddPair('label_account_return_value.caption.microsoft_get_avatar', '获取游戏成功，现在正在获取用户大头像中……')
    .AddPair('label_account_return_value.caption.not_buy_mc', '登录失败，您暂未拥有游戏。')
    .AddPair('label_account_return_value.caption.cannot_get_user_code', '未能获取用户代码，登录失败。')
    .AddPair('label_account_return_value.caption.add_microsoft_success', '添加成功！已通过微软登录成功添加！')
    .AddPair('label_account_return_value.caption.check_authlib_update', '正在检查Authlib是否有更新。')
    .AddPair('label_account_return_value.caption.check_authlib_error', '检测Authlib更新失败。')
    .AddPair('label_account_return_value.caption.check_authlib_success', '检测Authlib完毕，你的Authlib是最新的啦！')
    .AddPair('label_account_return_value.caption.refresh_microsoft_start', '正在重置微软账号……')
    .AddPair('label_account_return_value.caption.refresh_microsoft_error', '重置微软失败，RefreshToken也已过期，请尝试登录吧。')
    .AddPair('label_account_return_value.caption.refresh_thirdparty_start', '正在重置外置账号……')
    .AddPair('label_account_return_value.caption.refresh_thirdparty_error', '重置外置失败，RefreshToken也已过期，请尝试登录吧。')
    .AddPair('label_account_return_value.caption.name_to_uuid_start', '正在通过正版用户名获取正版账号的UUID')
    .AddPair('label_account_return_value.caption.name_to_uuid_error', '该用户不存在。')
    .AddPair('label_account_return_value.caption.name_to_uuid_success', '获取成功，UUID已正确填写在栏中！')
    .AddPair('label_account_return_value.caption.uuid_to_name_start', '正在通过正版UUID获取正版账号用户名')
    .AddPair('label_account_return_value.caption.uuid_to_name_error', '该用户不存在。')
    .AddPair('label_account_return_value.caption.uuid_to_name_success', '获取成功，名称已正确填写在栏中！')
    //以下是资源部分
    .AddPair('label_resource_tip.caption', '此部分用于下载MC的附加资源，建议每次搜新资源时，都右击一次搜索版本框查看简介噢！')
    .AddPair('label_resource_search_name_tip.caption', '搜索名称')
    .AddPair('edit_resource_search_name.texthint', '输入搜索名称【只能输入英文】')
    .AddPair('label_resource_search_source_tip.caption', '搜索源')
    .AddPair('label_resource_search_mode_tip.caption', '搜索方式')
    .AddPair('label_resource_search_category_curseforge_tip.caption', '搜索类型（Curseforge）')
    .AddPair('label_resource_search_version_tip.caption', '搜索版本')
    .AddPair('label_resource_search_category_modrinth_tip.caption', '搜索类型（Modrinth）')
    .AddPair('label_resource_return_value.caption.get_curseforge_start', '正在获取Curseforge资源')
    .AddPair('label_resource_return_value.caption.get_modrinth_start', '正在获取Modrinth资源')
    .AddPair('button_resource_name_previous_page.caption', '名称（上一页）')
    .AddPair('button_resource_name_next_page.caption', '名称（下一页）')
    .AddPair('button_resource_version_previous_page.caption', '版本（上一页）')
    .AddPair('button_resource_version_next_page.caption', '版本（下一页）')
    .AddPair('button_open_download_website.caption', '打开下载源官网')
    .AddPair('button_resource_start_search.caption', '开始搜索')
    .AddPair('button_resource_start_download.caption', '开始下载')
    .AddPair('combobox_resource_search_version.item.all', '全部')
    .AddPair('combobox_resource_search_mode.item.curseforge.all', '全部')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins', 'Bukkit插件')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.admin_tools', 'Admin Tools')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.anti-griefing_tools', 'Anti-Griefing Tools')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.chat_related', 'Chat Related')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.developed_tools', 'Developer Tools')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.economy', 'Economy')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.world_editing_and_management', 'World Editing and Management')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.fixes', 'Fixes')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.fun', 'Fun')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.general', 'General')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.informational', 'Informational')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.mechanics', 'Mechanics')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.website_administration', 'Website Administration')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.world_generators', 'World Generators')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.role_resource', 'Role resource')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.miscellaneous', 'Miscellaneous')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.teleportation', 'Teleportation')
    .AddPair('combobox_resource_search_mode.item.curseforge_bukkitplugins.twitch_integration', 'Twitch Integration')
    .AddPair('combobox_resource_search_mode.item.curseforge_modpacks', '整合包')
    .AddPair('combobox_resource_search_mode.item.curseforge_modpacks.tech', 'Tech')
    .AddPair('combobox_resource_search_mode.item.curseforge_modpacks.magic', 'Magic')
    .AddPair('combobox_resource_search_mode.item.curseforge_modpacks.sci-fi', 'Sci-fi')
    .AddPair('combobox_resource_search_mode.item.curseforge_modpacks.adventure_and_rpg', 'Adventure and RPG')
    .AddPair('combobox_resource_search_mode.item.curseforge_modpacks.exploration', 'Exploration')
    .AddPair('combobox_resource_search_mode.item.curseforge_modpacks.mini_game', 'Mini Game')
    .AddPair('combobox_resource_search_mode.item.curseforge_modpacks.quests', 'Quests')
    .AddPair('combobox_resource_search_mode.item.curseforge_modpacks.hardcore', 'Hardcore')
    .AddPair('combobox_resource_search_mode.item.curseforge_modpacks.map_based', 'Map Based')
    .AddPair('combobox_resource_search_mode.item.curseforge_modpacks.small_/_light', 'Small / Light')
    .AddPair('combobox_resource_search_mode.item.curseforge_modpacks.extra_large', 'Extra Large')
    .AddPair('combobox_resource_search_mode.item.curseforge_modpacks.combat_/_pvp', 'Combat / PVP')
    .AddPair('combobox_resource_search_mode.item.curseforge_modpacks.multiplayer', 'Multiplayer')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods', '模组')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.biomes', 'Biomes')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.ores_and_resources', 'Ores and Resources')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.structures', 'Structures')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.dimensions', 'Dimensions')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.mobs', 'Mobs')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.processing', 'Processing')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.player_transport', 'Player Transport')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.energy,_fluid,_and_item_transport', 'Energy Fluid, and Item Transport')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.farming', 'Farming')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.energy', 'Energy')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.genetics', 'Genetics')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.automation', 'Automation')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.magic', 'Magic')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.storage', 'Storage')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.api_and_library', 'API and Library')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.adventure_and_rpg', 'Adventure and RPG')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.map_and_information', 'Map and Information')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.cosmetic', 'Cosmetic')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.miscellaneous', 'Miscellaneous')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.thermal_expansion', 'Thermal Expansion')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.tinker''_s_construct', 'Tkinter''s Construct')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.industrial_craft', 'Industrial Craft')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.thaumcraft', 'Thaumcraft')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.buildcraft', 'Buildcraft')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.forestry', 'Forestry')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.blood_magic', 'Blood Magic')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.applied_energistics_2', 'Applied Energistics 2')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.craftTweaker', 'CraftTweater')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.galacticraft', 'Galacticraft')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.kubeJS', 'KubeJS')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.skyblock', 'Skyblock')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.armor,_tools,_and_weapons', 'Armor, Tools and Weapons')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.server_utility', 'Server Utility')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.food', 'Food')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.redstone', 'Redstone')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.twitch_integration', 'Twitch Integration')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.mCreator', 'MCreator')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.utility_&_qoL', 'Utility & QoL')
    .AddPair('combobox_resource_search_mode.item.curseforge_mods.education', 'Education')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks', '纹理')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks.16x', '16x')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks.32x', '32x')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks.64x', '64x')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks.128x', '128x')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks.256x', '256x')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks.512x', '512x')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks.steampunk', 'Steampunk')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks.photo_realistic', 'Photo Realistic')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks.modern', 'Modern')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks.medieval', 'Medieval')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks.traditional', 'Traditional')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks.animated', 'Animated')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks.miscellaneous', 'Miscellaneous')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks.mod_support', 'Mod Support')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks.data_packs', 'Data Packs')
    .AddPair('combobox_resource_search_mode.item.curseforge_resourcepacks.font_packs', 'Font Packs')
    .AddPair('combobox_resource_search_mode.item.curseforge_worlds', '地图')
    .AddPair('combobox_resource_search_mode.item.curseforge_worlds.adventure', 'Adventure')
    .AddPair('combobox_resource_search_mode.item.curseforge_worlds.creation', 'Creation')
    .AddPair('combobox_resource_search_mode.item.curseforge_worlds.game_map', 'Game Map')
    .AddPair('combobox_resource_search_mode.item.curseforge_worlds.parkour', 'Parkour')
    .AddPair('combobox_resource_search_mode.item.curseforge_worlds.puzzle', 'Puzzle')
    .AddPair('combobox_resource_search_mode.item.curseforge_worlds.survival', 'Survival')
    .AddPair('combobox_resource_search_mode.item.curseforge_worlds.modded_world', 'Modded World')
    .AddPair('combobox_resource_search_mode.item.curseforge_addons', '附加包')
    .AddPair('combobox_resource_search_mode.item.curseforge_addons.resource_packs', 'Resource Packs')
    .AddPair('combobox_resource_search_mode.item.curseforge_addons.scenarios', 'Scenarios')
    .AddPair('combobox_resource_search_mode.item.curseforge_addons.worlds', 'Worlds')
    .AddPair('combobox_resource_search_mode.item.curseforge_customization', '自定义')
    .AddPair('combobox_resource_search_mode.item.curseforge_customization.configuration', 'Configuration')
    .AddPair('combobox_resource_search_mode.item.curseforge_customization.fancyMenu', 'FancyMenu')
    .AddPair('combobox_resource_search_mode.item.curseforge_customization.guidebook', 'Guidebook')
    .AddPair('combobox_resource_search_mode.item.curseforge_customization.quests', 'Quests')
    .AddPair('combobox_resource_search_mode.item.curseforge_customization.scripts', 'Scripts')
    .AddPair('combobox_resource_search_mode.item.curseforge_shader', '光影')
    .AddPair('combobox_resource_search_mode.item.curseforge_shaders.fantasy', 'Fantasy')
    .AddPair('combobox_resource_search_mode.item.curseforge_shaders.realistic', 'Realistic')
    .AddPair('combobox_resource_search_mode.item.curseforge_shaders.vanilla', 'Vanilla')
    .AddPair('combobox_resource_search_mode.item.modrinth.all', '全部')
    .AddPair('combobox_resource_search_mode.item.modrinth_mods', '模组')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.adventure', 'Adventure')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.cursed', 'Cursed')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.decoration', 'Decoration')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.economy', 'Economy')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.equipment', 'Equipment')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.food', 'Food')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.game_mechanics', 'Game Mechanics')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.library', 'Library')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.magic', 'Magic')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.management', 'Management')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.minigame', 'Minigame')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.mobs', 'Mobs')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.optimization', 'Optimization')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.social', 'Social')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.storage', 'Storage')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.technology', 'Technology')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.transportation', 'Transportation')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.utility', 'Utility')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.world_generation', 'World Generation')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.fabric', 'Fabric')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.forge', 'Forge')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.liteLoader', 'Liteloader')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.risugami_s_modLoader', 'Risugami''s ModLoader')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.neoForge', 'NeoForge')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.quilt', 'Quilt')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_mods.rift', 'Rift')
    .AddPair('combobox_resource_search_mode.item.modrinth_plugins', '插件')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.adventure', 'Adventure')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.cursed', 'Cursed')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.decoration', 'Decoration')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.economy', 'Economy')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.equipment', 'Equipment')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.food', 'Food')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.game_mechanics', 'Game Mechanics')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.library', 'Library')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.magic', 'Magic')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.management', 'Management')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.minigame', 'Minigame')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.mobs', 'Mobs')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.optimization', 'Optimization')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.social', 'Social')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.storage', 'Storage')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.technology', 'Technology')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.transportation', 'Transportation')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.utility', 'Utility')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.world_generation', 'World Generation')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.bukkit', 'Bukkit')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.folia', 'Folia')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.paper', 'Paper')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.purpur', 'Purpur')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.spigot', 'Spigot')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_plugins.sponge', 'Sponge')
    .AddPair('combobox_resource_search_mode.item.modrinth_data_packs', '数据包')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.adventure', 'Adventure')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.cursed', 'Cursed')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.decoration', 'Decoration')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.economy', 'Economy')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.equipment', 'Equipment')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.food', 'Food')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.game_mechanics', 'Game Mechanics')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.library', 'Library')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.magic', 'Magic')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.management', 'Management')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.minigame', 'Minigame')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.mobs', 'Mobs')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.optimization', 'Optimization')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.social', 'Social')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.storage', 'Storage')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.technology', 'Technology')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.transportation', 'Transportation')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.utility', 'Utility')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_datapacks.world_generation', 'World Generation')
    .AddPair('combobox_resource_search_mode.item.modrinth_shaders', '光影')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.cartoon', 'Cartoon')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.cursed', 'Cursed')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.fantasy', 'Fantasy')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.realistic', 'Realistic')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.semi-realistic', 'Semi-Realistic')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.vanilla-like', 'Vanilla-Like')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.atomsphere', 'Atomsphere')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.bloom', 'Bloom')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.colored_light', 'Colored Light')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.foliage', 'Foliage')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.path_tracing', 'Path Tracing')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.PBR', 'PBR')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.reflections', 'Reflections')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.shadows', 'Shadows')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.potato', 'Potato')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.low', 'Low')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.medium', 'Medium')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.high', 'High')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.screenshot', 'Screenshot')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.canvas', 'Canvas')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.iris', 'Iris')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.optiFine', 'Optifine')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_shaders.vanilla', 'Vanilla')
    .AddPair('combobox_resource_search_mode.item.modrinth_resource_packs', '纹理')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.combat', 'Combat')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.cursed', 'Cursed')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.decoration', 'Decoration')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.modded', 'Modded')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.realistic', 'Realistic')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.simplistic', 'Simplistic')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.themed', 'Themed')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.tweaks', 'Tweaks')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.utility', 'Utility')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.vanilla-like', 'Vanilla-Like')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.audio', 'Audio')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.blocks', 'Blocks')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.core_shaders', 'Core Shaders')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.entities', 'Entities')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.environment', 'Environment')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.equipment', 'Equipment')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.fonts', 'Fonts')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.GUI', 'GUI')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.items', 'Items')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.locale', 'Locale')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.models', 'Models')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.8x_or_lower', '8x or Lower')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.16x', '16x')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.32x', '32x')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.48x', '48x')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.64x', '64x')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.128x', '128x')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.256x', '256x')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_resourcepacks.512x_or_higher', '512x or Higher')
    .AddPair('combobox_resource_search_mode.item.modrinth_modpacks', '整合包')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_modpacks.adventure', 'Adventure')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_modpacks.challenging', 'Challenging')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_modpacks.combat', 'Combat')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_modpacks.kitchen_sink', 'Kitchen Sink')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_modpacks.lightweight', 'Lightweight')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_modpacks.magic', 'Magic')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_modpacks.multiplayer', 'Multiplayer')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_modpacks.optimization', 'Optimization')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_modpacks.quests', 'Quests')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_modpacks.technology', 'Technology')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_modpacks.fabric', 'Fabric')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_modpacks.forge', 'Forge')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_modpacks.neoForge', 'NeoForge')
    .AddPair('checklistbox_resource_search_mode.item.modrinth_modpacks.quilt', 'Quilt')
    .AddPair('label_resource_return_value.caption.is_searching', '正在搜素资源……')
    .AddPair('label_resource_return_value.caption.curseforge_search_finish', '搜索Curseforge成功！')
    .AddPair('label_resource_return_value.caption.get_curseforge_search_error', '获取Curseforge返回结果错误，请重试！')
    .AddPair('label_resource_return_value.caption.get_curseforge_name_or_version_error', '获取Curseforge时，返回了0个元素，获取失败！')
    .AddPair('label_resource_return_value.caption.modrinth_search_finish', '搜索Modrinth成功！')
    .AddPair('label_resource_return_value.caption.get_modrinth_search_error', '获取Modrinth返回结果错误，请重试！')
    .AddPair('label_resource_return_value.caption.get_modrinth_name_or_version_error', '获取Modrinth时，返回了0个元素，获取失败！')
    .AddPair('label_resource_search_name.caption.page', '搜索（名称）【第${page}页】')
    .AddPair('label_resource_search_version.caption.page', '搜索（版本）【第${page}页】')
    //资源管理界面
    .AddPair('label_manage_import_modpack.caption', '整合包导入（暂未完成）')
    .AddPair('label_manage_import_mod.caption', '模组管理')
    .AddPair('label_manage_import_map.caption', '地图管理')
    .AddPair('label_manage_import_resourcepack.caption', '纹理管理')
    .AddPair('label_manage_import_shader.caption', '光影管理')
    .AddPair('label_manage_import_datapack.caption', '数据包管理')
    .AddPair('label_manage_import_plugin.caption', '插件管理')
    .AddPair('listbox_manage_import_modpack.hint', '将整合包拖入此列表框以供添加，仅支持【zip或mrpack】后缀的文件。')
    .AddPair('listbox_manage_import_mod.hint', '将模组拖入此列表框以供添加，仅支持【jar或zip】后缀的文件。')
    .AddPair('listbox_manage_import_map.hint', '将地图拖入此列表框以供添加，仅支持【zip】后缀的文件或【文件夹】。')
    .AddPair('listbox_manage_import_resourcepack.hint', '将纹理拖入此列表框以供添加，仅支持【zip】后缀的文件。')
    .AddPair('listbox_manage_import_shader.hint', '将光影拖入此列表框以供添加，仅支持【zip】后缀的文件。')
    .AddPair('listbox_manage_import_datapack.hint', '将数据包拖入此列表框以供添加，仅支持【zip】后缀的文件。前提是需要选中任一地图文件。')
    .AddPair('listbox_manage_import_plugin.hint', '将插件拖入此列表框以供添加，仅支持【jar或zip】后缀的文件。')
    .AddPair('button_disable_choose_resource.caption', '禁用选中')
    .AddPair('button_enable_choose_resource.caption', '启用选中')
    .AddPair('button_delete_choose_resource.caption', '删除选中')
    .AddPair('button_rename_choose_resource.caption', '重命名选中')
    .AddPair('button_open_choose_resource.caption', '打开选中的文件夹')
    .AddPair('button_disable_choose_resource.hint', '仅能禁用模组和插件，已被禁用的资源将无法被再次禁用')
    .AddPair('button_enable_choose_resource.hint', '仅能启用模组和插件，已被启用的资源将无法被再次启用')
    .AddPair('button_delete_choose_resource.hint', '删除选中的资源，当同时选中数据包和地图时将会优先删除数据包。【将会放入回收站】')
    .AddPair('button_rename_choose_resource.hint', '重命名选中的资源，当地图与数据包同时选中时将会优先重命名数据包。')
    .AddPair('button_open_choose_resource.hint', '用资源管理器打开你所选择的资源。当地图与数据包同时选中时将会优先打开地图文件夹中的datapacks文件夹。')
    //启动设置界面
    .AddPair('label_launch_window_height.caption', '高度，当前选中：${window_height}')
    .AddPair('label_launch_window_width.caption', '宽度，当前选中：${window_width}')
    .AddPair('label_launch_max_memory.caption', '游戏内存【系统总内存：${total_memory}，剩余内存：${avail_memory}，当前选中：${memory}】')
    .AddPair('label_launch_window_size.caption', '游戏窗口大小，默认854x480')
    .AddPair('label_launch_java_path.caption', 'Java路径')
    .AddPair('label_launch_java_logic.caption', 'Java逻辑')
    .AddPair('button_launch_full_scan_java.caption', '全盘扫描')
    .AddPair('button_launch_basic_scan_java.caption', '特定扫描')
    .AddPair('button_launch_manual_import.caption', '手动导入')
    .AddPair('button_launch_remove_java.caption', '移除Java')
    .AddPair('label_launch_download_java.caption', '下载Java')
    .AddPair('button_launch_download_java_8.caption', '下载Java8')
    .AddPair('button_launch_download_java_17.caption', '下载Java17')
    .AddPair('button_launch_download_java_21.caption', '下载Java21')
    .AddPair('button_launch_official_java.caption', '打开Java官网')
    .AddPair('label_launch_custom_info.caption', '自定义信息（默认LLLauncher）')
    .AddPair('edit_launch_custom_info.texthint', '随便填')
    .AddPair('label_launch_window_title.caption', '窗口标题（默认即默认）')
    .AddPair('edit_launch_window_title.texthint', '随便填')
    .AddPair('label_launch_pre_launch_script.caption', '前置启动脚本')
    .AddPair('edit_launch_pre_launch_script.texthint', '非专业人士请勿修改本行')
    .AddPair('button_launch_pre_launch_script.caption', '查看该行提示')
    .AddPair('label_launch_after_launch_script.caption', '后置启动脚本')
    .AddPair('edit_launch_after_launch_script.texthint', '非专业人士请勿修改本行')
    .AddPair('button_launch_after_launch_script.caption', '查看该行提示')
    .AddPair('label_launch_default_jvm.caption', '默认JVM参数')
    .AddPair('button_launch_default_jvm.caption', '查看该行提示')
    .AddPair('label_launch_additional_jvm.caption', '额外JVM参数')
    .AddPair('edit_launch_additional_jvm.texthint', '非专业人士请勿修改本行')
    .AddPair('button_launch_additional_jvm.caption', '查看该行提示')
    .AddPair('label_launch_additional_game.caption', '额外Game参数')
    .AddPair('edit_launch_additional_game.texthint', '非专业人士请勿修改本行')
    .AddPair('button_launch_additional_game.caption', '查看该行提示')
    .AddPair('label_launch_java_login.caption.full_scan_java', 'Java逻辑，正在扫描${drive}盘……')
    .AddPair('label_launch_java_login.caption.full_scan_java_error', 'Java逻辑，全盘扫描Java失败')
    .AddPair('label_launch_java_login.caption.full_scan_java_success', 'Java逻辑，全盘扫描Java成功')
    .AddPair('label_launch_java_logic.caption.search_regedit', 'Java逻辑，正在扫描注册表')
    .AddPair('label_launch_java_login.caption.basic_scan_java_search_regedit_error', 'Java逻辑，全盘扫描Java失败')
    .AddPair('label_launch_java_logic.caption.search_env_path', 'Java逻辑，正在扫描环境变量')
    .AddPair('label_launch_java_logic.caption.search_program', 'Java逻辑，正在扫描C:\Program File\Java')
    .AddPair('label_launch_java.logic.caption.search_lllpath', 'Java逻辑，正在扫描LLL特定目录')
    .AddPair('label_launch_java_logic.caption.basic_scan_java_success', 'Java逻辑，特定扫描Java成功')
    //以下是下载部分
    .AddPair('label_download_return_value.caption.get_mc_web', '正在获取MC元数据……')
    .AddPair('label_downlaod_return_value.caption.get_mc_web_success', '初步导入MC元数据成功！')
    .AddPair('listbox_select_minecraft.item.get_mc_error', 'MC导入失败，请重试。')
    .AddPair('label_download_biggest_thread.caption', '最大线程：${biggest_thread}')
    .AddPair('label_download_return_value.caption.reset_mc_web', '正在重置MC元数据……')
    .AddPair('label_downlaod_return_value.caption.reset_mc_web_success', '重置导入MC元数据成功！')
    .AddPair('listbox_select_modloader.item.has_no_data', '暂无数据！')
    .AddPair('label_download_return_value.caption.get_modloader', '正在获取模组加载器……')
    .AddPair('label_download_return_value.caption.get_modloader_success', '获取模组加载器成功！')
    .AddPair('label_download_tip.caption', '这里是下载部分，你可以体验到自定义文件下载，还有Minecraft下载！这也是为数不多的支持NeoForge的启动器哦！')
    .AddPair('label_choose_view_mode.caption', '选择显示方式')
    .AddPair('label_select_minecraft.caption', 'Minecraft版本选择')
    .AddPair('label_select_modloader.caption', '模组加载器选择')
    .AddPair('checklistbox_choose_view_mode.release.caption', '显示正式')
    .AddPair('checklistbox_choose_view_mode.snapshot.caption', '显示快照')
    .AddPair('checklistbox_choose_view_mode.beta.caption', '显示Beta')
    .AddPair('checklistbox_choose_view_mode.alpha.caption', '显示Alpha')
    .AddPair('checklistbox_choose_view_mode.special.caption', '显示LLL特供')
    .AddPair('radiogroup_choose_download_source.caption', '选择下载源')
    .AddPair('radiogroup_choose_download_source.official.caption', '官方下载源')
    .AddPair('radiogroup_choose_download_source.bmclapi.caption', 'BMCLAPI')
    .AddPair('radiogroup_choose_mod_loader.caption', '选择模组加载器')
    .AddPair('radiogroup_choose_mod_loader.forge.caption', 'Forge')
    .AddPair('radiogroup_choose_mod_loader.fabric.caption', 'Fabric')
    .AddPair('radiogroup_choose_mod_loader.quilt.caption', 'Quilt')
    .AddPair('radiogroup_choose_mod_loader.neoforge.caption', 'NeoForge')
    .AddPair('button_reset_download_part.caption', '重置下载界面')
    .AddPair('button_load_modloader.caption', '加载模组加载器')
    .AddPair('label_minecraft_version_name.caption', '下载版本名称')
    .AddPair('edit_minecraft_version_name.texthint', '请输入版本名称')
    .AddPair('button_download_start_download_minecraft.caption', '开始自动安装Minecraft❤点我自动安装❤')
    //以下是自定义下载部分
    .AddPair('label_custom_download_url.caption', '下载网址输入（不支持百度网盘等）')
    .AddPair('edit_custom_download_url.texthint', '这里输入下载网址')
    .AddPair('label_custom_download_name.caption', '文件名称输入（可空，留空则默认为网址后缀名）')
    .AddPair('edit_custom_download_name.texthint', '这里输入文件名称')
    .AddPair('label_custom_download_sha1.caption', '文件sha1输入（可空）')
    .AddPair('edit_custom_download_sha1.texthint', '这里输入文件sha1，主要用于下载完成后校验文件是否完整，如果不知道可以留空。')
    .AddPair('label_custom_download_path.caption', '保存路径（可空，留空则为本exe路径下）')
    .AddPair('edit_custom_download_path.texthint', '这里输入文件下载路径，可以手动填，也可以点击下方选择路径填写。')
    .AddPair('button_custom_download_choose_path.caption', '选择路径')
    .AddPair('button_custom_download_open_path.caption', '打开路径')
    .AddPair('button_custom_download_start.caption', '开始下载')
    //以下是模组加载器手动安装包
    .AddPair('label_download_modloader_forge.caption', 'Forge版本选择')
    .AddPair('label_download_modloader_fabric.caption', 'Fabric版本选择')
    .AddPair('label_download_modloader_quilt.caption', 'Quilt版本选择')
    .AddPair('label_download_modloader_neoforge.caption', 'NeoForge版本选择')
    .AddPair('button_download_modloader_download.caption', '开始下载')
    .AddPair('button_download_modloader_refresh.caption', '刷新版本')
    //以下是版本设置部分
    .AddPair('label_version_current_path.caption', '当前选中版本：${current_path}')
    .AddPair('label_select_game_version.caption', '选择游戏版本')
    .AddPair('label_select_file_list.caption', '选择文件列表')
    .AddPair('label_version_add_mc_path.caption', '添加MC路径')
    .AddPair('button_version_choose_any_directory.caption', '请选择任一文件夹')
    .AddPair('button_game_resource.caption', '修改该版本游戏资源')
    .AddPair('radiogroup_partition_version.caption', '版本隔离')
    .AddPair('radiogroup_partition_version.not_isolation.caption', '不使用版本隔离')
    .AddPair('radiogroup_partition_version.isolate_version.caption', '隔离【正式版/快照版/远古Beta版/远古Alpha版】')
    .AddPair('radiogroup_partition_version.isolate_modloader.caption', '隔离【Forge/Fabric/Quilt/NeoForge】等版')
    .AddPair('radiogroup_partition_version.isolate_all.caption', '隔离全部版本')
    .AddPair('button_version_complete.caption', '手动补全该版本的类库')
    .AddPair('button_rename_version_list.caption', '重命名文件列表')
    .AddPair('button_remove_version_list.caption', '移除文件列表')
    .AddPair('button_rename_game_version.caption', '重命名游戏版本')
    .AddPair('button_delete_game_version.caption', '删除游戏版本')
    .AddPair('label_version_tip.caption', '这里是版本部分，你可以操作游戏文件夹，还可以选择版本隔离，还可以为独立版本设计，甚至可以导出整合包噢！')
    .AddPair('combobox_version.current_directory.text', '当前文件夹')
    .AddPair('combobox_version.official_directory.text', '官方文件夹')
    //以下是独立设置部分
    .AddPair('label_isolation_current_version.caption', '当前选中版本：${current_version}')
    .AddPair('label_isolation_window_width.caption', '宽，当前选中：${current_width}')
    .AddPair('label_isolation_window_height.caption', '高，当前选中：${current_height}')
    .AddPair('label_isolation_game_memory.caption', '游戏内存，当前选中：${current_memory}')
    .AddPair('toggleswitch_is_open_isolation.on.caption', '开')
    .AddPair('toggleswitch_is_open_isolation.off.caption', '关')
    .AddPair('label_isolation_java_path.caption', 'Java路径')
    .AddPair('edit_isolation_java_path.texthint', '这里输入Java路径【留空则全局应用】')
    .AddPair('button_isolation_choose_java.caption', '选择路径')
    .AddPair('label_isolation_custom_info.caption', '自定义信息')
    .AddPair('edit_isolation_custom_info.texthint', '这里填入自定义信息【留空则全局应用】')
    .AddPair('label_isolation_window_title.caption', '窗口标题')
    .AddPair('edit_isolation_window_title.texthint', '启动MC后的窗口标题【留空则全局应用】')
    .AddPair('label_isolation_window_size.caption', '窗口大小')
    .AddPair('toggleswitch_isolation_window_size.on.caption', '开启独立')
    .AddPair('toggleswitch_isolation_window_size.off.caption', '全局应用')
    .AddPair('toggleswitch_isolation_open_memory.on.caption', '开启独立')
    .AddPair('toggleswitch_isolation_open_memory.off.caption', '全局应用')
    .AddPair('label_isolation_partition.caption', '是否隔离（打勾则单独隔离，否则单独不隔离）')
    .AddPair('toggleswitch_isolation_open_partition.on.caption', '开启独立')
    .AddPair('toggleswitch_isolation_open_partition.off.caption', '全局应用')
    .AddPair('checkbox_isolation_is_partition.caption', '开启独立版本隔离')
    .AddPair('label_isolation_additional_game.caption', '额外Game参数')
    .AddPair('edit_isolation_additional_game.texthint', '输入额外game参数-非专业人士请勿修改【留空则全局应用】')
    .AddPair('label_isolation_additional_jvm.caption', '额外JVM参数')
    .AddPair('edit_isolation_additional_jvm.texthint', '输入额外jvm参数-非专业人士请勿修改【留空则全局应用】')
    .AddPair('label_isolation_pre_launch_script.caption', '前置启动脚本')
    .AddPair('edit_isolation_pre_launch_script.texthint', '输入前置启动脚本-非专业人士请勿修改【留空则全局应用】')
    .AddPair('label_isolation_after_launch_script.caption', '后置启动脚本')
    .AddPair('edit_isolation_after_launch_script.texthint', '输入后置启动脚本-非专业人士请勿修改【留空则全局应用】')
    .AddPair('label_isolation_tip.caption', '以上，只要是开启了全局应用开关，或者是修改了文本框内容【指不为空】，则默认应用全局设置噢！')
    //以下是整合包导出部分
    .AddPair('label_export_current_version.caption', '当前选中版本：${current_version}')
    .AddPair('label_export_return_value.caption.initialize', '正在初始化整合包导出的文件树……')
    .AddPair('label_export_return_value.caption.init_success', '初始化文件树完成！')
    .AddPair('label_export_memory.caption', '最大内存，当前选中：${max_memory}')
    .AddPair('label_export_return_value.caption.scan_file', '正在扫描已选中文件，请勿关闭此窗口……')
    .AddPair('label_export_return_value.caption.copy_file', '正在判断文件以用于导入，请勿关闭此窗口……')
    .AddPair('label_export_return_value.caption.scan_file_finish', '扫描文件完成，正在复制文件……')
    .AddPair('label_export_return_value.caption.copy_file_finish', '扫描复制完成，弹出保存路径窗口……')
    .AddPair('label_export_return_value.caption.is_export', '正在打包成zip，请勿关闭，请等待信息框弹出……')
    .AddPair('label_export_return_value.caption.export_success', '打包完成！你现在可以去查到zip包了！')
    .AddPair('radiogroup_export_mode.caption', '导出方式')
    .AddPair('label_export_mode_more.caption', '更多导出方式敬请期待噢！')
    .AddPair('label_export_modpack_name.caption', '整合包名称')
    .AddPair('edit_export_modpack_name.texthint', '此处输入你的整合包名称【必填项】')
    .AddPair('label_export_modpack_author.caption', '整合包作者')
    .AddPair('edit_export_modpack_author.texthint', '此处输入你的整合包作者【必填项】')
    .AddPair('label_export_modpack_version.caption', '整合包版本')
    .AddPair('edit_export_modpack_version.texthint', '此处输入你的整合包版本【必填项】')
    .AddPair('label_export_update_link.caption', '整合包更新链接')
    .AddPair('edit_export_update_link.texthint', '此处输入你的整合包更新链接【选填项】')
    .AddPair('edit_export_update_link.hint', '例如【https://example.com/manifact.json】，只需输入【https://example.com】即可。')
    .AddPair('label_export_official_website.caption', '整合包官方网站')
    .AddPair('edit_export_official_website.texthint', '此处输入你的整合包官方网站【选填项】')
    .AddPair('edit_export_official_website.hint', '此处填写你整合包的官方网址，例如curseforge就填网址。填全称。')
    .AddPair('label_export_authentication_server.caption', '认证服务器')
    .AddPair('edit_export_authentication_server.texthint', '此处输入你的整合包认证服务器【选填项】')
    .AddPair('edit_export_authentication_server.hint', '此处仅限外置登录，如果你不确定，请留空。该处只能填入类似于【littleskin.cn】这种外置登录皮肤站根目录')
    .AddPair('label_export_additional_game.caption', '额外Game')
    .AddPair('edit_export_additional_game.texthint', '此处输入你的整合包额外Game参数【选填项】')
    .AddPair('edit_export_additional_game.hint', '用空格分割你的额外Game参数。')
    .AddPair('label_export_additional_jvm.caption', '额外JVM')
    .AddPair('edit_export_additional_jvm.texthint', '此处输入你的整合包额外JVM参数')
    .AddPair('edit_export_additional_jvm.hint', '用空格分割你的额外JVM参数。')
    .AddPair('label_export_modpack_profile.caption', '整合包简介')
    .AddPair('label_export_keep_file.caption', '需要保留的文件')
    .AddPair('button_export_start.caption', '♥点我导出♥')
    .AddPair('label_export_add_icon.caption', '为整合包添加图标（ps：允许任意像素，但建议200x200即可，仅限png，暂不支持jpg等）')
    .AddPair('button_export_add_icon.caption', '选择图标文件')
    //以下是联机IPv6部分
    .AddPair('label_online_ipv6_return_value.caption.check_ipv6_port', '正在检测你的IPv6公网IP中……')
    .AddPair('listbox_view_all_ipv6_ip.caption.timeout', '超时')
    .AddPair('listbox_view_all_ipv6_ip.caption.forever', '永久')
    .AddPair('listbox_view_all_ipv6_ip.caption.temp', '临时')
    .AddPair('label_online_ipv6_return_value.caption.not_support_ipv6', '你的局域网网络暂不支持IPv6连接，如果你确信自己拥有IPv6而LLL无法识别出来时，请联系作者！')
    .AddPair('label_online_ipv6_return_value.caption.check_ipv6_success', '检测IPv6成功！现在你可以在列表框里查看了！')
    .AddPair('label_online_ipv6_return_value.caption.current_ipv6_ip', '你选中的IPv6地址是：[${ip}]')
    .AddPair('button_check_ipv6_ip.caption', '开始检测IPv6公网IP')
    .AddPair('label_online_ipv6_port.caption', '请输入你在游戏中的端口【1024~65536】')
    .AddPair('button_copy_ipv6_ip_and_port.caption', '复制IPv6公网IP与端口')
    .AddPair('button_online_ipv6_tip.caption', 'IPv6联机提示')
    .AddPair('label_online_tip.caption', '这里是联机部分，你可以在这里找一个你所想要的联机方式进行联机噢！')
    //以下是启动游戏时的语言
    .AddPair('label_mainform_tips.caption.judge_args', '正在开始判断配置文件是否有误……')
    .AddPair('label_mainform_tips.caption.not_choose_mc_version', 'MC版本判断失误，你还没有选择任一MC版本。')
    .AddPair('label_mainform_tips.caption.not_choose_java', 'Java判断失误，你还没有选择任一Java。')
    .AddPair('label_mainform_tips.caption.access_token_expire', '你的Access Token已过期，请尝试重新登录一次吧【或者点击刷新账号】！')
    .AddPair('label_mainform_tips.caption.not_support_third_party', '目前并不处在中国，暂不支持第三方外置登录！请重试！')
    .AddPair('label_mainform_tips.caption.not_support_login_type', '不支持的登录方式，也许你修改了账号配置中的数据，请立即改回来！')
    .AddPair('label_mainform_tips.caption.not_choose_account', '账号判断失误，你还没有选择任一账号。')
    .AddPair('label_mainform_tips.caption.set_launch_script', '现在开始拼接启动参数……')
    .AddPair('label_mainform_tips.caption.cannot_find_json', '版本错误，未从版本文件夹中找到符合标准的json文件！……')
    .AddPair('label_mainform_tips.caption.unzip_native_error', '未能成功解压Natives文件。')
    .AddPair('label_mainform_tips.caption.cannot_set_launch_args', '无法拼接MC启动参数，请仔细的检查你的MC版本JSON是否有误！')
    .AddPair('label_mainform_tips.caption.cannot_find_authlib_file', '找不到Authlib-Injector文件，请进入账号部分下载一个后再尝试！')
    .AddPair('label_mainform_tips.caption.export_launch_args_success', '启动参数导出成功！')
    .AddPair('label_mainform_tips.caption.wait_launch_game', '游戏启动成功！正在等待打开游戏窗口中……')
    .AddPair('label_mainform_tips.caption.launch_game_success', '窗口打开成功！可以开始玩游戏了！')
    .AddPair('label_mainform_tips.caption.cancel_launch', '取消启动。')
    //以下是插件语言
    .AddPair('plugin_tabsheet.get_plugin_info.hint', Concat(
                '插件名称；${plugin_caption}', #13#10,
                '插件版本：${plugin_version}', #13#10,
                '插件作者：${plugin_author}', #13#10,
                '插件版权：${plugin_copyright}', #13#10,
                '插件更新时间：${plugin_update_time}', #13#10,
                '插件简介：${plugin_description}'))
    .AddPair('plugin_menu_back.caption', '回退')
    ;
   alllangjson.Add(enusjson);
end;

//根据多国化语言，获取对应文本
function GetLanguage(key: String): String;
begin
  try
    result := langjson.GetValue(key).Value;
  except
    result := key;
  end;
end;

end.
