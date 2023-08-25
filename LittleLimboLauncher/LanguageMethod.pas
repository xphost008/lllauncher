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
  form_mainform.n_message_board.Caption := GetLanguage('menu_misc_board.caption');                
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
  //以下为主界面
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
      .AddPair('menu_misc_board.caption', '留言板')
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
      .AddPair('messagebox_account.offline_cannot_refresh.text', '离线模式不需要重置账号哦！可以换成微软登录或者外置登录来重置呢！')
      .AddPair('messagebox_account.offline_cannot_refresh.caption', '离线模式不需要重置账号')
      //以下为下载列表框
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
      //以下为主窗口
      .AddPair('__mainform_comment', '（注解）以下是主窗口语言')
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
      .AddPair('label_background_control_alpha.caption', '设置控件透明度【只允许63~195，因为过高会导致背景图片不见，过低会导致控件不见】')
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
      //以下为账号设置
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
      .AddPair('button_microsoft_oauth_login.caption', 'OAuth验证流登录')
      .AddPair('label_thirdparty_server.caption', '服务器')
      .AddPair('label_thirdparty_account.caption', '账号')
      .AddPair('label_thirdparty_password.caption', '密码')
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
