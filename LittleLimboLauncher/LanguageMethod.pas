unit LanguageMethod;

interface

uses
  SysUtils, Classes, Forms, JSON, Dialogs, Generics.Collections;

procedure InitLanguage();
procedure SetLanguage(lang: String);
function GetLanguage(key: String): String;

implementation

uses
  MainMethod, MainForm;

var
  langjson: TJSONObject;

procedure SetLanguage(lang: String);
begin                                                                                          
  if lang = '' then lang := 'zh_cn';
  var langpath := Concat(ExtractFilePath(Application.ExeName), 'LLLauncher\lang\', lang, '.json');
  langjson := TJSONObject.ParseJSONValue(GetFile(langpath)) as TJSONObject;
  //以下为页
  form_mainform.tabsheet_mainpage_part.Caption := GetLanguage('tabsheet_mainpage_part.caption');   
  form_mainform.tabsheet_account_part.Caption := GetLanguage('tabsheet_account_part.caption');
  form_mainform.tabsheet_playing_part.Caption := GetLanguage('tabsheet_playing_part.caption');
  form_mainform.tabsheet_download_part.Caption := GetLanguage('tabsheet_download_part.caption');
  form_mainform.tabsheet_online_part.Caption := GetLanguage('tabsheet_online_part.caption');
  form_mainform.tabsheet_background_part.Caption := GetLanguage('tabsheet_background_part.caption');
  form_mainform.tabsheet_launch_part.Caption := GetLanguage('tabsheet_launch_part.caption');
  form_mainform.tabsheet_version_part.Caption := GetLanguage('tabsheet_version_part.caption');
  form_mainform.tabsheet_account_offline_part.Caption := GetLanguage('tabsheet_account_offline_part.caption');
  form_mainform.tabsheet_account_microsoft_part.Caption := GetLanguage('tabsheet_account_microsoft_part.caption');
  form_mainform.tabsheet_account_thirdparty_part.Caption := GetLanguage('tabsheet_account_thirdparty_part.caption');
  form_mainform.tabsheet_playing_download_part.Caption := GetLanguage('tabsheet_playing_download_part.caption');
  form_mainform.tabsheet_playing_manage_part.Caption := GetLanguage('tabsheet_playing_manage_part.caption');
  form_mainform.tabsheet_download_custom_part.Caption := GetLanguage('tabsheet_download_custom_part.caption');
  form_mainform.tabsheet_download_modloader_part.Caption := GetLanguage('tabsheet_download_modloader_part.caption');
  form_mainform.tabsheet_online_ipv6_part.Caption := GetLanguage('tabsheet_online_ipv6_part.caption');
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
  form_mainform.n_test_button.Caption := GetLanguage('menu_manual_test.caption');
  form_mainform.n_languages.Caption := GetLanguage('menu_manual_language.caption');
  form_mainform.n_plugins.Caption := GetLanguage('menu_manual_plugin.caption');
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
  form_mainform.buttoncolor_custom_color.caption := GetLanguage('buttoncolor_custom_color.caption');    
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
  //以下是玩法部分
  form_mainform.label_playing_tip.Caption := GetLanguage('label_playing_tip.caption');
  form_mainform.label_playing_search_name_tip.Caption := GetLanguage('label_playing_search_name_tip.caption');
  form_mainform.label_playing_search_version_tip.Caption := GetLanguage('label_playing_search_version_tip.caption');
  form_mainform.label_playing_search_category_modrinth_tip.Caption := GetLanguage('label_playing_search_category_modrinth_tip.caption');
  form_mainform.label_playing_search_category_curseforge_tip.Caption := GetLanguage('label_playing_search_category_curseforge_tip.caption');
  form_mainform.label_playing_search_mode_tip.Caption := GetLanguage('label_playing_search_mode_tip.caption');
  form_mainform.label_playing_search_source_tip.Caption := GetLanguage('label_playing_search_source_tip.caption');
  form_mainform.button_playing_name_previous_page.Caption := GetLanguage('button_playing_name_previous_page.caption');
  form_mainform.button_playing_version_previous_page.Caption := GetLanguage('button_playing_version_previous_page.caption');
  form_mainform.button_playing_name_next_page.Caption := GetLanguage('button_playing_name_next_page.caption');
  form_mainform.button_playing_version_next_page.Caption := GetLanguage('button_playing_version_next_page.caption');
  form_mainform.button_open_download_website.Caption := GetLanguage('button_open_download_website.caption');
  form_mainform.button_playing_start_download.Caption := GetLanguage('button_playing_start_download.caption');
  form_mainform.button_playing_start_search.Caption := GetLanguage('button_playing_start_search.caption');
  form_mainform.edit_playing_search_name.TextHint := GetLanguage('edit_playing_search_name.texthint');
  //以下是玩法管理界面
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
  form_mainform.button_disable_choose_playing.Caption := GetLanguage('button_disable_choose_playing.caption');
  form_mainform.button_enable_choose_playing.Caption := GetLanguage('button_enable_choose_playing.caption');
  form_mainform.button_delete_choose_playing.Caption := GetLanguage('button_delete_choose_playing.caption');
  form_mainform.button_rename_choose_playing.Caption := GetLanguage('button_rename_choose_playing.caption');
  form_mainform.button_open_choose_playing.Caption := GetLanguage('button_open_choose_playing.caption');
  form_mainform.button_disable_choose_playing.Hint := GetLanguage('button_disable_choose_playing.hint');
  form_mainform.button_enable_choose_playing.Hint := GetLanguage('button_enable_choose_playing.hint');
  form_mainform.button_delete_choose_playing.Hint := GetLanguage('button_delete_choose_playing.hint');
  form_mainform.button_rename_choose_playing.Hint := GetLanguage('button_rename_choose_playing.hint');
  form_mainform.button_open_choose_playing.Hint := GetLanguage('button_open_choose_playing.hint');
end;

procedure InitLanguage();
begin
  if not FileExists(Concat(ExtractFilePath(Application.ExeName), 'LLLauncher\lang\zh_cn.json')) then begin
    var zhcnjson := TJSONObject.Create
      .AddPair('file_language_title', '中文（简体）')
      //以下为页
      .AddPair('__pagecontrol_comment', '（注解）以下是页面控件语言')
      .AddPair('tabsheet_mainpage_part.caption', '主界面')
      .AddPair('tabsheet_account_part.caption', '账号部分')
      .AddPair('tabsheet_playing_part.caption', '玩法部分')
      .AddPair('tabsheet_download_part.caption', '下载部分')
      .AddPair('tabsheet_online_part.caption', '联机部分')
      .AddPair('tabsheet_background_part.caption', '背景设置')
      .AddPair('tabsheet_launch_part.caption', '启动设置')
      .AddPair('tabsheet_version_part.caption', '版本部分')
      .AddPair('tabsheet_account_offline_part.caption', '离线登录')
      .AddPair('tabsheet_account_microsoft_part.caption', '微软登录')
      .AddPair('tabsheet_account_thirdparty_part.caption', '外置登录')
      .AddPair('tabsheet_playing_download_part.caption', '下载玩法')
      .AddPair('tabsheet_playing_manage_part.caption', '玩法管理界面')
      .AddPair('tabsheet_download_minecraft_part.caption', '下载Minecraft')
      .AddPair('tabsheet_download_custom_part.caption', '下载自定义文件')
      .AddPair('tabsheet_download_modloader_part.caption', '下载模组加载器手动安装包')
      .AddPair('tabsheet_online_ipv6_part.caption', 'IPv6联机')
      .AddPair('tabsheet_version_control_part.caption', '版本控制')
      .AddPair('tabsheet_version_isolation_part.caption', '独立设置')
      .AddPair('tabsheet_version_export_part.caption', '导出整合包') 
      //以下为菜单栏
      .AddPair('__mainmenu_comment', '（注解）以下是菜单栏语言')
      .AddPair('menu_misc.caption', '杂项')
      .AddPair('menu_misc_answer.caption', '答案之书')
      .AddPair('menu_misc_intro.caption', '自我介绍')
      .AddPair('menu_misc_lucky.caption', '今日人品')
      .AddPair('menu_misc_puzzle.caption', '解谜游戏')      
      .AddPair('menu_official.caption', '官网')
      .AddPair('menu_official_entry.caption', '进入官网')
      .AddPair('menu_official_support.caption', '赞助作者')
      .AddPair('menu_official_bmclapi.caption', '赞助BMCLAPI')
      .AddPair('menu_manual.caption', '手动')
      .AddPair('menu_manual_reset.caption', '重置启动器')
      .AddPair('menu_manual_export.caption', '手动导出启动参数')
      .AddPair('menu_manual_version.caption', '当前版本')
      .AddPair('menu_manual_update.caption', '检查更新')
      .AddPair('menu_manual_test.caption', '测试按钮')
      .AddPair('menu_manual_language.caption', '语言')
      .AddPair('menu_manual_plugin.caption', '插件')
      //以下为信息框
      .AddPair('__messagebox_comment', '（注解）以下是所有信息框语言')
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
      .AddPair('messagebox_mainform.launch_afdian.text', Concat('LLL启动器已经帮你启动过${launch_number}次游戏了，真的不打算为作者发电么？【呜呜的请求……】', #13#10, '点是进入作者的爱发电。'))
      .AddPair('messagebox_mainform.open_afdian.text', Concat('LLL启动器已经被你打开过${open_number}次了，真的不打算为作者发电么？【呜呜的请求……】', #13#10, '点是进入作者的爱发电。'))
      .AddPair('messagebox_mainform.afdian.caption', '快点来给我发电吧')
      .AddPair('messagebox_mainform.change_language.text', '当你切换了任意一次语言后，虽然这是实时更改的，但仍然不排除有部分标签没有修改，因此这里建议你重新打开一次启动器。')
      .AddPair('messagebox_mainform.change_language.caption', '建议重启启动器')
      .AddPair('messagebox_playing.get_curseforge_search_error.caption', '获取失败……')
      .AddPair('messagebox_playing.get_curseforge_search_error.text', '获取Curseforge返回结果错误，请重试！')
      .AddPair('messagebox_playing.get_curseforge_name_or_version_error.caption', '获取失败……')
      .AddPair('messagebox_playing.get_curseforge_name_or_version_error.text', '在获取Curseforge时，返回了0个元素，搜素失败！')
      .AddPair('messagebox_playing.get_modrinth_search_error.caption', '获取失败……')
      .AddPair('messagebox_playing.get_modrinth_search_error.text', '获取Modrinth返回结果错误，请重试！')
      .AddPair('messagebox_playing.get_modrinth_name_or_version_error.caption', '获取失败……')
      .AddPair('messagebox_playing.get_modrinth_name_or_version_error.text', '在获取Modrinth时，返回了0个元素，搜素失败！')
      .AddPair('messagebox_playing.get_curseforge_page_error.caption', '返回结果为空，解析失败。')
      .AddPair('messagebox_playing.get_curseforge_page_error.text', '在对Curseforge版本进行翻页或者点击列表框时，返回结果为空，解析失败。')
      .AddPair('messagebox_playing.get_modrinth_page_error.caption', '返回结果为空，解析失败。')
      .AddPair('messagebox_playing.get_modrinth_page_error.text', '在对Modrinth版本进行翻页或者点击列表框时，返回结果为空，解析失败。')
      .AddPair('messagebox_playing.version_pageup_error.caption', '版本上一页失败')
      .AddPair('messagebox_playing.version_pageup_error.text', '已经是第一页啦！不要再上一页啦！')
      .AddPair('messagebox_playing.version_pagedown_error.caption', '版本下一页失败')
      .AddPair('messagebox_playing.version_pagedown_error.text', '已经是最后一页啦！不要再下一页啦！')
      .AddPair('messagebox_playing.name_pageup_error.caption', '名称上一页失败')
      .AddPair('messagebox_playing.name_pageup_error.text', '已经是第一页啦！不要再上一页啦！')
      .AddPair('messagebox_playing.name_pagedown_error.caption', '名称下一页失败')
      .AddPair('messagebox_playing.name_pagedown_error.text', '已经是最后一页啦！不要再下一页啦！')
      .AddPair('messagebox_playing.not_choose_mod_error.caption', '暂未选择模组。')
      .AddPair('messagebox_playing.name_pagedown_error.text', '暂未选择任意模组，无法打开官网，请重试。')
      .AddPair('messagebox_playing.open_intro_error.caption', '打开简介失败')
      .AddPair('messagebox_playing.open_intro_error.text', '打开简介失败，请尝试选择任意一个玩法版本后，再尝试打开简介。')
      .AddPair('mypicturebox_playing.open_curseforge_intro_success.text', Concat(
              '项目ID：${p_id}', #13#10,
              '项目类型：${classId}', #13#10,
              '项目slug：${slug}', #13#10,
              '项目标题：${name}', #13#10,
              '项目作者：${authors}', #13#10,
              '项目简介：${summary}', #13#10,
              '项目类型：${categories}', #13#10,
              '项目下载量：${p_downloadCount}', #13#10,
//              '项目关注量：${follows}', #13#10,
              '项目创建日期：${dateCreated}', #13#10,
              '项目最新版本：${dateModified}', #13#10,
              '项目最新版本：${gameVersion}', #13#10,
//              '项目许可证：${license}', #13#10,
              '-----------------------------------------------------------------------------------------------------------------------', #13#10,
              '所选ID：${id}', #13#10,
              '所选名称：${fileName}', #13#10,
              '所选版本名：${displayName}', #13#10,
              '所选下载量：${downloadCount}', #13#10,
              '所选发布状态：${releaseType}', #13#10,
              '所选发布日期：${fileDate}', #13#10,
              '所选MC版本/加载器：${gameVersions}'
//              '所选加载器：${loaders}', #13#10,
//              '所选更新日志：${changelog}', #13#10
              ))
      .AddPair('mypicturebox_playing.open_modrinth_intro_success.text', Concat(
              '项目ID：${project_id}', #13#10,
              '项目类型：${project_type}', #13#10,
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
      .AddPair('messagebox_playing.no_version_download_error.caption', '暂未选择任意版本')
      .AddPair('messagebox_playing.no_version_download_error.text', '您还暂未选择任意玩法的版本，无法下载，请选择一个之后重试。')
      .AddPair('opendialog_playing.download_dialog.title', '请选择你要保存的路径：')
      .AddPair('messagebox_playing.file_exists_download_error.caption', '文件已存在')
      .AddPair('messagebox_playing.file_exists_download_error.text', '你要下载的路径已存在一个同名文件，请删除这个文件后再重新尝试下载。')
      .AddPair('messagebox_playing.download_playing_success.caption', '下载完成')
      .AddPair('messagebox_playing.download_playing_success.text', '玩法下载已完成！')
      .AddPair('messagebox_playing.open_manage_error.caption', '打开玩法管理界面失败')
      .AddPair('messagebox_playing.open_manage_error.text', '打开玩法管理界面失败，你似乎并未选中任一游戏文件夹，请去选中一次再来！')
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
      .AddPair('messagebox_manage.disable_playing_not_choose.caption', '无法禁用')
      .AddPair('messagebox_manage.disable_playing_not_choose.text', '你选中的玩法不是模组或者插件，又或者你暂未选中任一玩法，无法禁用，请重试。')
      .AddPair('messagebox_manage.playing_already_disable.caption', '已被禁用')
      .AddPair('messagebox_manage.playing_already_disable.text', '你选中的玩法已被禁用，无法重复禁用，请重试。')
      .AddPair('messagebox_manage.enable_playing_not_choose.caption', '无法启用')
      .AddPair('messagebox_manage.enable_playing_not_choose.text', '你选中的玩法不是模组或者插件，又或者你暂未选中任一玩法，无法启用，请重试。')
      .AddPair('messagebox_manage.playing_already_enable.caption', '已被启用')
      .AddPair('messagebox_manage.playing_already_enable.text', '你选中的玩法已被启用，无法重复启用，请重试')
      .AddPair('messagebox_manage.delete_playing_not_choose.caption', '无法删除！')
      .AddPair('messagebox_manage.delete_playing_not_choose.text', '你还暂未选中任一玩法，无法删除，请重试。')
      .AddPair('messagebox_manage.playing_is_delete.caption', '请问是否删除')
      .AddPair('messagebox_manage.playing_is_delete.text', '是否删除掉此玩法？会将其放入回收站。')
      .AddPair('messagebox_manage.rename_playing_not_choose.caption', '无法重命名')
      .AddPair('messagebox_manage.rename_playing_not_choose.text', '你还暂未选中任一玩法，无法重命名，请重试。')
      .AddPair('inputbox_manage.rename_new_name.caption', '请输入命名的新名称')
      .AddPair('inputbox_manage.rename_new_name.text', '在下方输入命名的新名称，如果留空或者按取消则保持原名。')
      .AddPair('messagebox_manage.open_no_choose_playing.caption', '无法打开文件夹')
      .AddPair('messagebox_manage.open_no_choose_playing.text', '你还暂未选择任一玩法，无法通过资源管理器打开')
      //以下为下载进度列表框
      .AddPair('__downloadlist_comment', '（注解）以下是下载进度列表框语言')
      .AddPair('label_progress_download_progress.caption', '下载进度：${download_progress}% | ${download_current_count}/${download_all_count}')
      .AddPair('downloadlist.custom.judge_can_multi_thread_download', '正在判断是否可以多线程下载。')
      .AddPair('downloadlist.custom.url_donot_support_download_in_launcher', '该网址不支持启动器下载，请使用浏览器下载吧！')
      .AddPair('downloadlist.custom.input_url_error_and_this_url_doesnot_has_file', '网址输入错误，该网址下无任何文件。')
      .AddPair('downloadlist.custom.url_statucode_is_not_206_and_try_to_cut', '该网站请求代码不为206，正在对其进行分段……')
      .AddPair('downloadlist.custom.not_allow_cut_use_single_thread_download', '该网站不允许分段下载，已用单线程将该文件下载下来。')
      .AddPair('downloadlist.custom.url_allow_multi_thread_download', '该网站支持多线程下载！')
      .AddPair('downloadlist.custom.url_file_size', '文件长度：${download_progress}')
      .AddPair('downloadlist.custom.thread_one_to_single_thread_download', '由于你选择的线程是单线程，现在将直接采取单线程的下载方式。')
      .AddPair('downloadlist.custom.single_thread_download_error', '单线程下载失败，请重试。')
      .AddPair('downloadlist.custom.cut_download_error', '分段下载已下载失败，请重试！')
      .AddPair('downloadlist.custom.cut_download_success', '分段下载已下载完成：${cut_download_count}')
      .AddPair('downloadlist.custom.cut_download_join_error', '已检测出文件下载并不完整，下载失败！')
      .AddPair('downloadlist.custom.download_finish', '下载已完成！耗时：${download_finish_time}秒。')
      .AddPair('downloadlist.judge.judge_source_official', '已检测出你的下载源为：官方')
      .AddPair('downloadlist.judge.judge_source_bmclapi', '已检测出你的下载源为：BMCLAPI')
      .AddPair('downloadlist.judge.judge_source_mcbbs', '已检测出你的下载源为：MCBBS')
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
      .AddPair('downloadlist.mc.download_mc_success', '下载MC已完成，耗时${download_finish_time}秒。')
      .AddPair('downloadlist.window.file_is_exists', '已存在：${file_exists_name}')
      .AddPair('downloadlist.window.download_error_retry', '下载失败，正在重试：${file_error_name}')
      .AddPair('downloadlist.window.switch_download_source_official', '正在切换下载源：OFFICIAL')
      .AddPair('downloadlist.window.switch_download_source_bmclapi', '正在切换下载源：BMCLAPI')
      .AddPair('downloadlist.window.switch_download_source_mcbbs', '正在切换下载源：MCBBS')
      .AddPair('downloadlist.window.switch_download_source_forge', '正在切换下载源：FORGE')
      .AddPair('downloadlist.window.switch_download_source_fabric', '正在切换下载源：FABRIC')
      .AddPair('downloadlist.window.retry_threetime_error', '重试3次后依旧失败，下载失败！')
      .AddPair('downloadlist.window.download_success', '下载成功：${file_success_name}')
      .AddPair('downloadlist.backup.backup_success', '已备份：${backup_file_name}')
      .AddPair('downloadlist.backup.backup_error', '备份失败：${backup_file_name}')
      .AddPair('downloadlist.java.download_java_success', '下载Java已完成，耗时${download_finish_time}秒。')
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
      .AddPair('downloadlist.forge.start_run_processors', '现在正在开始用单线程跑Forge处理器中……')
      .AddPair('downloadlist.forge.not_choose_any_java', '你暂未选中任何一个Java，无法跑Forge处理器，请重试！')
      .AddPair('downloadlist.forge.skip_processors', '已跳过：${processors_count}')
      .AddPair('downloadlist.forge.run_processors_success', '已完成：${processors_count}')
      .AddPair('downloadlist.authlib.check_authlib_update', '正在检查Authlib-Injector是否有更新')
      .AddPair('downloadlist.authlib.check_authlib_error', '检测Authlib失败，请重试。')
      .AddPair('downloadlist.authlib.authlib_has_update', '已检测出Authlib更新，正在下载')
      .AddPair('downloadlist.authlib.download_authlib_error', 'Authlib-Injector下载失败，请重试！')
      .AddPair('downloadlist.authlib.downlaod_authlib_success', 'Authlib-Injector下载成功！')
      .AddPair('downloadlist_playing.start_download', '正在下载该玩法……')
      .AddPair('downloadlist_playing.download_success', '玩法下载已完成')
      //以下为下载进度窗口
      .AddPair('__progress_comment', '（注解）以下是下载进度窗口语言')
      .AddPair('button_progress_hide_show_details.caption.show', '显示详情')
      .AddPair('button_progress_hide_show_details.caption.hide', '隐藏详情')
      .AddPair('button_progress_clean_download_list.caption', '清空下载信息列表框')
      .AddPair('label_progress_tips.caption', '一旦开始下载就停止不了了！')
      //以下为主窗口
      .AddPair('__mainform_comment', '（注解）以下是主窗口语言')
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
      .AddPair('__background_comment', '（注解）以下是背景设置语言')
      .AddPair('label_background_tip.caption', '这里是背景部分，你可以选择自己喜欢的背景颜色【说实话只是边框而已啦……】')
      .AddPair('label_standard_color.caption', '这里是标准配色，按一下直接应用')
      .AddPair('button_grass_color.caption', '小草绿')
      .AddPair('button_sun_color.caption', '日落黄')
      .AddPair('button_sultan_color.caption', '苏丹红')
      .AddPair('button_sky_color.caption', '天空蓝')
      .AddPair('button_cute_color.caption', '可爱粉')
      .AddPair('button_normal_color.caption', '默认白')
      .AddPair('buttoncolor_custom_color.caption', '自定义配色')
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
      .AddPair('__account_comment', '（注解）以下是账号部分语言')
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
      //以下是玩法部分
      .AddPair('__playing_comment', '（注解）以下是玩法部分语言')
      .AddPair('label_playing_tip.caption', '此部分用于下载MC的附加玩法，建议每次搜新玩法时，都右击一次搜索版本框查看简介噢！')
      .AddPair('label_playing_search_name_tip.caption', '搜索名称')
      .AddPair('edit_playing_search_name.texthint', '输入搜索名称【只能输入英文】')
      .AddPair('label_playing_search_source_tip.caption', '搜索源')
      .AddPair('label_playing_search_mode_tip.caption', '搜索方式')
      .AddPair('label_playing_search_category_curseforge_tip.caption', '搜索类型（Curseforge）')
      .AddPair('label_playing_search_version_tip.caption', '搜索版本')
      .AddPair('label_playing_search_category_modrinth_tip.caption', '搜索类型（Modrinth）')
      .AddPair('label_playing_return_value.caption.get_curseforge_start', '正在获取Curseforge玩法')
      .AddPair('label_playing_return_value.caption.get_modrinth_start', '正在获取Modrinth玩法')
      .AddPair('button_playing_name_previous_page.caption', '名称（上一页）')
      .AddPair('button_playing_name_next_page.caption', '名称（下一页）')
      .AddPair('button_playing_version_previous_page.caption', '版本（上一页）')
      .AddPair('button_playing_version_next_page.caption', '版本（下一页）')
      .AddPair('button_open_download_website.caption', '打开下载源官网')
      .AddPair('button_playing_start_search.caption', '开始搜索')
      .AddPair('button_playing_start_download.caption', '开始下载')
      .AddPair('combobox_playing_search_version.item.all', '全部')
      .AddPair('combobox_playing_search_mode.item.curseforge.all', '全部')
      .AddPair('combobox_playing_search_mode.item.curseforge_bukkitplugins', 'Bukkit插件')
      .AddPair('combobox_playing_search_mode.item.curseforge_bukkitplugins.admin_tools', 'Admin Tools')
      .AddPair('combobox_playing_search_mode.item.curseforge_bukkitplugins.anti-griefing_tools', 'Anti-Griefing Tools')
      .AddPair('combobox_playing_search_mode.item.curseforge_bukkitplugins.chat_related', 'Chat Related')
      .AddPair('combobox_playing_search_mode.item.curseforge_bukkitplugins.developed_tools', 'Developer Tools')
      .AddPair('combobox_playing_search_mode.item.curseforge_bukkitplugins.economy', 'Economy')
      .AddPair('combobox_playing_search_mode.item.curseforge_bukkitplugins.world_editing_and_management', 'World Editing and Management')
      .AddPair('combobox_playing_search_mode.item.curseforge_bukkitplugins.fixes', 'Fixes')
      .AddPair('combobox_playing_search_mode.item.curseforge_bukkitplugins.fun', 'Fun')
      .AddPair('combobox_playing_search_mode.item.curseforge_bukkitplugins.general', 'General')
      .AddPair('combobox_playing_search_mode.item.curseforge_bukkitplugins.informational', 'Informational')
      .AddPair('combobox_playing_search_mode.item.curseforge_bukkitplugins.mechanics', 'Mechanics')
      .AddPair('combobox_playing_search_mode.item.curseforge_bukkitplugins.website_administration', 'Website Administration')
      .AddPair('combobox_playing_search_mode.item.curseforge_bukkitplugins.world_generators', 'World Generators')
      .AddPair('combobox_playing_search_mode.item.curseforge_bukkitplugins.role_playing', 'Role Playing')
      .AddPair('combobox_playing_search_mode.item.curseforge_bukkitplugins.miscellaneous', 'Miscellaneous')
      .AddPair('combobox_playing_search_mode.item.curseforge_bukkitplugins.teleportation', 'Teleportation')
      .AddPair('combobox_playing_search_mode.item.curseforge_bukkitplugins.twitch_integration', 'Twitch Integration')
      .AddPair('combobox_playing_search_mode.item.curseforge_modpacks', '整合包')
      .AddPair('combobox_playing_search_mode.item.curseforge_modpacks.tech', 'Tech')
      .AddPair('combobox_playing_search_mode.item.curseforge_modpacks.magic', 'Magic')
      .AddPair('combobox_playing_search_mode.item.curseforge_modpacks.sci-fi', 'Sci-fi')
      .AddPair('combobox_playing_search_mode.item.curseforge_modpacks.adventure_and_rpg', 'Adventure and RPG')
      .AddPair('combobox_playing_search_mode.item.curseforge_modpacks.exploration', 'Exploration')
      .AddPair('combobox_playing_search_mode.item.curseforge_modpacks.mini_game', 'Mini Game')
      .AddPair('combobox_playing_search_mode.item.curseforge_modpacks.quests', 'Quests')
      .AddPair('combobox_playing_search_mode.item.curseforge_modpacks.hardcore', 'Hardcore')
      .AddPair('combobox_playing_search_mode.item.curseforge_modpacks.map_based', 'Map Based')
      .AddPair('combobox_playing_search_mode.item.curseforge_modpacks.small_/_light', 'Small / Light')
      .AddPair('combobox_playing_search_mode.item.curseforge_modpacks.extra_large', 'Extra Large')
      .AddPair('combobox_playing_search_mode.item.curseforge_modpacks.combat_/_pvp', 'Combat / PVP')
      .AddPair('combobox_playing_search_mode.item.curseforge_modpacks.multiplayer', 'Multiplayer')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods', '模组')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.biomes', 'Biomes')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.ores_and_resources', 'Ores and Resources')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.structures', 'Structures')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.dimensions', 'Dimensions')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.mobs', 'Mobs')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.processing', 'Processing')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.player_transport', 'Player Transport')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.energy,_fluid,_and_item_transport', 'Energy Fluid, and Item Transport')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.farming', 'Farming')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.energy', 'Energy')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.genetics', 'Genetics')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.automation', 'Automation')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.magic', 'Magic')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.storage', 'Storage')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.api_and_library', 'API and Library')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.adventure_and_rpg', 'Adventure and RPG')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.map_and_information', 'Map and Information')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.cosmetic', 'Cosmetic')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.miscellaneous', 'Miscellaneous')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.thermal_expansion', 'Thermal Expansion')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.tinker''_s_construct', 'Tkinter''s Construct')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.industrial_craft', 'Industrial Craft')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.thaumcraft', 'Thaumcraft')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.buildcraft', 'Buildcraft')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.forestry', 'Forestry')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.blood_magic', 'Blood Magic')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.applied_energistics_2', 'Applied Energistics 2')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.craftTweaker', 'CraftTweater')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.galacticraft', 'Galacticraft')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.kubeJS', 'KubeJS')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.skyblock', 'Skyblock')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.armor,_tools,_and_weapons', 'Armor, Tools and Weapons')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.server_utility', 'Server Utility')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.food', 'Food')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.redstone', 'Redstone')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.twitch_integration', 'Twitch Integration')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.mCreator', 'MCreator')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.utility_&_qoL', 'Utility & QoL')
      .AddPair('combobox_playing_search_mode.item.curseforge_mods.education', 'Education')
      .AddPair('combobox_playing_search_mode.item.curseforge_resourcepacks', '纹理')
      .AddPair('combobox_playing_search_mode.item.curseforge_resourcepacks.16x', '16x')
      .AddPair('combobox_playing_search_mode.item.curseforge_resourcepacks.32x', '32x')
      .AddPair('combobox_playing_search_mode.item.curseforge_resourcepacks.64x', '64x')
      .AddPair('combobox_playing_search_mode.item.curseforge_resourcepacks.128x', '128x')
      .AddPair('combobox_playing_search_mode.item.curseforge_resourcepacks.256x', '256x')
      .AddPair('combobox_playing_search_mode.item.curseforge_resourcepacks.512x', '512x')
      .AddPair('combobox_playing_search_mode.item.curseforge_resourcepacks.steampunk', 'Steampunk')
      .AddPair('combobox_playing_search_mode.item.curseforge_resourcepacks.photo_realistic', 'Photo Realistic')
      .AddPair('combobox_playing_search_mode.item.curseforge_resourcepacks.modern', 'Modern')
      .AddPair('combobox_playing_search_mode.item.curseforge_resourcepacks.medieval', 'Medieval')
      .AddPair('combobox_playing_search_mode.item.curseforge_resourcepacks.traditional', 'Traditional')
      .AddPair('combobox_playing_search_mode.item.curseforge_resourcepacks.animated', 'Animated')
      .AddPair('combobox_playing_search_mode.item.curseforge_resourcepacks.miscellaneous', 'Miscellaneous')
      .AddPair('combobox_playing_search_mode.item.curseforge_resourcepacks.mod_support', 'Mod Support')
      .AddPair('combobox_playing_search_mode.item.curseforge_resourcepacks.data_packs', 'Data Packs')
      .AddPair('combobox_playing_search_mode.item.curseforge_resourcepacks.font_packs', 'Font Packs')
      .AddPair('combobox_playing_search_mode.item.curseforge_worlds', '地图')
      .AddPair('combobox_playing_search_mode.item.curseforge_worlds.adventure', 'Adventure')
      .AddPair('combobox_playing_search_mode.item.curseforge_worlds.creation', 'Creation')
      .AddPair('combobox_playing_search_mode.item.curseforge_worlds.game_map', 'Game Map')
      .AddPair('combobox_playing_search_mode.item.curseforge_worlds.parkour', 'Parkour')
      .AddPair('combobox_playing_search_mode.item.curseforge_worlds.puzzle', 'Puzzle')
      .AddPair('combobox_playing_search_mode.item.curseforge_worlds.survival', 'Survival')
      .AddPair('combobox_playing_search_mode.item.curseforge_worlds.modded_world', 'Modded World')
      .AddPair('combobox_playing_search_mode.item.curseforge_addons', '附加包')
      .AddPair('combobox_playing_search_mode.item.curseforge_addons.resource_packs', 'Resource Packs')
      .AddPair('combobox_playing_search_mode.item.curseforge_addons.scenarios', 'Scenarios')
      .AddPair('combobox_playing_search_mode.item.curseforge_addons.worlds', 'Worlds')
      .AddPair('combobox_playing_search_mode.item.curseforge_customization', '自定义')
      .AddPair('combobox_playing_search_mode.item.curseforge_customization.configuration', 'Configuration')
      .AddPair('combobox_playing_search_mode.item.curseforge_customization.fancyMenu', 'FancyMenu')
      .AddPair('combobox_playing_search_mode.item.curseforge_customization.guidebook', 'Guidebook')
      .AddPair('combobox_playing_search_mode.item.curseforge_customization.quests', 'Quests')
      .AddPair('combobox_playing_search_mode.item.curseforge_customization.scripts', 'Scripts')
      .AddPair('combobox_playing_search_mode.item.curseforge_shader', '光影')
      .AddPair('combobox_playing_search_mode.item.curseforge_shaders.fantasy', 'Fantasy')
      .AddPair('combobox_playing_search_mode.item.curseforge_shaders.realistic', 'Realistic')
      .AddPair('combobox_playing_search_mode.item.curseforge_shaders.vanilla', 'Vanilla')
      .AddPair('combobox_playing_search_mode.item.modrinth.all', '全部')
      .AddPair('combobox_playing_search_mode.item.modrinth_mods', '模组')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_mods.adventure', 'Adventure')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_mods.cursed', 'Cursed')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_mods.decoration', 'Decoration')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_mods.economy', 'Economy')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_mods.equipment', 'Equipment')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_mods.food', 'Food')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_mods.game_mechanics', 'Game Mechanics')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_mods.library', 'Library')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_mods.magic', 'Magic')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_mods.management', 'Management')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_mods.minigame', 'Minigame')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_mods.mobs', 'Mobs')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_mods.optimization', 'Optimization')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_mods.social', 'Social')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_mods.storage', 'Storage')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_mods.technology', 'Technology')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_mods.transportation', 'Transportation')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_mods.utility', 'Utility')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_mods.world_generation', 'World Generation')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_mods.fabric', 'Fabric')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_mods.forge', 'Forge')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_mods.liteLoader', 'Liteloader')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_mods.risugami''s_modLoader', 'Risugami''s ModLoader')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_mods.neoForge', 'NeoForge')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_mods.quilt', 'Quilt')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_mods.rift', 'Rift')
      .AddPair('combobox_playing_search_mode.item.modrinth_plugins', '插件')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_plugins.adventure', 'Adventure')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_plugins.cursed', 'Cursed')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_plugins.decoration', 'Decoration')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_plugins.economy', 'Economy')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_plugins.equipment', 'Equipment')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_plugins.food', 'Food')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_plugins.game_mechanics', 'Game Mechanics')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_plugins.library', 'Library')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_plugins.magic', 'Magic')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_plugins.management', 'Management')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_plugins.minigame', 'Minigame')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_plugins.mobs', 'Mobs')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_plugins.optimization', 'Optimization')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_plugins.social', 'Social')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_plugins.storage', 'Storage')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_plugins.technology', 'Technology')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_plugins.transportation', 'Transportation')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_plugins.utility', 'Utility')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_plugins.world_generation', 'World Generation')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_plugins.bukkit', 'Bukkit')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_plugins.folia', 'Folia')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_plugins.paper', 'Paper')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_plugins.purpur', 'Purpur')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_plugins.spigot', 'Spigot')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_plugins.sponge', 'Sponge')
      .AddPair('combobox_playing_search_mode.item.modrinth_data_packs', '数据包')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_datapacks.adventure', 'Adventure')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_datapacks.cursed', 'Cursed')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_datapacks.decoration', 'Decoration')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_datapacks.economy', 'Economy')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_datapacks.equipment', 'Equipment')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_datapacks.food', 'Food')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_datapacks.game_mechanics', 'Game Mechanics')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_datapacks.library', 'Library')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_datapacks.magic', 'Magic')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_datapacks.management', 'Management')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_datapacks.minigame', 'Minigame')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_datapacks.mobs', 'Mobs')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_datapacks.optimization', 'Optimization')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_datapacks.social', 'Social')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_datapacks.storage', 'Storage')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_datapacks.technology', 'Technology')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_datapacks.transportation', 'Transportation')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_datapacks.utility', 'Utility')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_datapacks.world_generation', 'World Generation')
      .AddPair('combobox_playing_search_mode.item.modrinth_shaders', '光影')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_shaders.cartoon', 'Cartoon')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_shaders.cursed', 'Cursed')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_shaders.fantasy', 'Fantasy')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_shaders.realistic', 'Realistic')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_shaders.semi-realistic', 'Semi-Realistic')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_shaders.vanilla-like', 'Vanilla-Like')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_shaders.atomsphere', 'Atomsphere')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_shaders.bloom', 'Bloom')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_shaders.colored_light', 'Colored Light')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_shaders.foliage', 'Foliage')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_shaders.path_tracing', 'Path Tracing')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_shaders.PBR', 'PBR')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_shaders.reflections', 'Reflections')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_shaders.shadows', 'Shadows')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_shaders.potato', 'Potato')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_shaders.low', 'Low')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_shaders.medium', 'Medium')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_shaders.high', 'High')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_shaders.screenshot', 'Screenshot')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_shaders.canvas', 'Canvas')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_shaders.iris', 'Iris')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_shaders.optiFine', 'Optifine')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_shaders.vanilla', 'Vanilla')
      .AddPair('combobox_playing_search_mode.item.modrinth_resource_packs', '纹理')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_resourcepacks.combat', 'Combat')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_resourcepacks.cursed', 'Cursed')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_resourcepacks.decoration', 'Decoration')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_resourcepacks.modded', 'Modded')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_resourcepacks.realistic', 'Realistic')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_resourcepacks.simplistic', 'Simplistic')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_resourcepacks.themed', 'Themed')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_resourcepacks.tweaks', 'Tweaks')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_resourcepacks.utility', 'Utility')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_resourcepacks.vanilla-like', 'Vanilla-Like')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_resourcepacks.audio', 'Audio')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_resourcepacks.blocks', 'Blocks')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_resourcepacks.core_shaders', 'Core Shaders')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_resourcepacks.entities', 'Entities')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_resourcepacks.environment', 'Environment')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_resourcepacks.equipment', 'Equipment')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_resourcepacks.fonts', 'Fonts')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_resourcepacks.GUI', 'GUI')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_resourcepacks.items', 'Items')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_resourcepacks.locale', 'Locale')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_resourcepacks.models', 'Models')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_resourcepacks.8x_or_lower', '8x or Lower')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_resourcepacks.16x', '16x')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_resourcepacks.32x', '32x')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_resourcepacks.48x', '48x')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_resourcepacks.64x', '64x')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_resourcepacks.128x', '128x')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_resourcepacks.256x', '256x')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_resourcepacks.512x_or_higher', '512x or Higher')
      .AddPair('combobox_playing_search_mode.item.modrinth_modpacks', '整合包')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_modpacks.adventure', 'Adventure')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_modpacks.challenging', 'Challenging')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_modpacks.combat', 'Combat')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_modpacks.kitchen_sink', 'Kitchen Sink')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_modpacks.lightweight', 'Lightweight')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_modpacks.magic', 'Magic')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_modpacks.multiplayer', 'Multiplayer')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_modpacks.optimization', 'Optimization')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_modpacks.quests', 'Quests')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_modpacks.technology', 'Technology')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_modpacks.fabric', 'Fabric')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_modpacks.forge', 'Forge')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_modpacks.neoForge', 'NeoForge')
      .AddPair('checklistbox_playing_search_mode.item.modrinth_modpacks.quilt', 'Quilt')
      .AddPair('label_playing_return_value.caption.is_searching', '正在搜素玩法……')
      .AddPair('label_playing_return_value.caption.curseforge_search_finish', '搜索Curseforge成功！')
      .AddPair('label_playing_return_value.caption.get_curseforge_search_error', '获取Curseforge返回结果错误，请重试！')
      .AddPair('label_playing_return_value.caption.get_curseforge_name_or_version_error', '获取Curseforge时，返回了0个元素，获取失败！')
      .AddPair('label_playing_return_value.caption.modrinth_search_finish', '搜索Modrinth成功！')
      .AddPair('label_playing_return_value.caption.get_modrinth_search_error', '获取Modrinth返回结果错误，请重试！')
      .AddPair('label_playing_return_value.caption.get_modrinth_name_or_version_error', '获取Modrinth时，返回了0个元素，获取失败！')
      .AddPair('label_playing_search_name.caption.page', '搜索（名称）【第${page}页】')
      .AddPair('label_playing_search_version.caption.page', '搜索（版本）【第${page}页】')
      //玩法管理界面
      .AddPair('__manage_comment', '（注解）以下是玩法管理部分语言')
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
      .AddPair('button_disable_choose_playing.caption', '禁用选中')
      .AddPair('button_enable_choose_playing.caption', '启用选中')
      .AddPair('button_delete_choose_playing.caption', '删除选中')
      .AddPair('button_rename_choose_playing.caption', '重命名选中')
      .AddPair('button_open_choose_playing.caption', '打开选中的文件夹')
      .AddPair('button_disable_choose_playing.hint', '仅能禁用模组和插件，已被禁用的玩法将无法被再次禁用')
      .AddPair('button_enable_choose_playing.hint', '仅能启用模组和插件，已被启用的玩法将无法被再次启用')
      .AddPair('button_delete_choose_playing.hint', '删除选中的玩法，当同时选中数据包和地图时将会优先删除数据包。【将会放入回收站】')
      .AddPair('button_rename_choose_playing.hint', '重命名选中的玩法，当地图与数据包同时选中时将会优先重命名数据包。')
      .AddPair('button_open_choose_playing.hint', '用资源管理器打开你所选择的玩法。当地图与数据包同时选中时将会优先打开地图文件夹中的datapacks文件夹。')
      ;
    SetFile(Concat(ExtractFilePath(Application.ExeName), 'LLLauncher\lang\zh_cn.json'), zhcnjson.Format);
  end;
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
