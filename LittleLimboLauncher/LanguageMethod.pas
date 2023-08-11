unit LanguageMethod;

interface

uses
  SysUtils, Classes, Forms, JSON, Dialogs, Generics.Collections;

procedure InitLanguage();
procedure SetLanguage(lang: String);
function GetLanguageText(key: String): String;

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
  form_mainform.tabsheet_mainpage_part.Caption := GetLanguageText('tabsheet_mainpage_part.caption');   
  form_mainform.tabsheet_account_part.Caption := GetLanguageText('tabsheet_account_part.caption');
  form_mainform.tabsheet_playing_part.Caption := GetLanguageText('tabsheet_playing_part.caption');
  form_mainform.tabsheet_download_part.Caption := GetLanguageText('tabsheet_download_part.caption');
  form_mainform.tabsheet_online_part.Caption := GetLanguageText('tabsheet_online_part.caption');
  form_mainform.tabsheet_background_part.Caption := GetLanguageText('tabsheet_background_part.caption');
  form_mainform.tabsheet_launch_part.Caption := GetLanguageText('tabsheet_launch_part.caption');
  form_mainform.tabsheet_version_part.Caption := GetLanguageText('tabsheet_version_part.caption');
  form_mainform.tabsheet_account_offline_part.Caption := GetLanguageText('tabsheet_account_offline_part.caption');
  form_mainform.tabsheet_account_microsoft_part.Caption := GetLanguageText('tabsheet_account_microsoft_part.caption');
  form_mainform.tabsheet_account_thirdparty_part.Caption := GetLanguageText('tabsheet_account_thirdparty_part.caption');
  form_mainform.tabsheet_playing_download_part.Caption := GetLanguageText('tabsheet_playing_download_part.caption');
  form_mainform.tabsheet_playing_manage_part.Caption := GetLanguageText('tabsheet_playing_manage_part.caption');
  form_mainform.tabsheet_download_custom_part.Caption := GetLanguageText('tabsheet_download_custom_part.caption');
  form_mainform.tabsheet_download_modloader_part.Caption := GetLanguageText('tabsheet_download_modloader_part.caption');
  form_mainform.tabsheet_online_ipv6_part.Caption := GetLanguageText('tabsheet_online_ipv6_part.caption');
  form_mainform.tabsheet_version_control_part.Caption := GetLanguageText('tabsheet_version_control_part.caption');
  form_mainform.tabsheet_version_isolation_part.Caption := GetLanguageText('tabsheet_version_isolation_part.caption');            
  form_mainform.tabsheet_version_export_part.Caption := GetLanguageText('tabsheet_version_export_part.caption');   
  //以下为菜单栏              
  form_mainform.n_misc.Caption := GetLanguageText('menu_misc.caption');                
  form_mainform.n_message_board.Caption := GetLanguageText('menu_misc_board.caption');                
  form_mainform.n_answer_book.Caption := GetLanguageText('menu_misc_answer.caption');                
  form_mainform.n_intro_self.Caption := GetLanguageText('menu_misc_intro.caption');                
  form_mainform.n_lucky_today.Caption := GetLanguageText('menu_misc_lucky.caption');                
  form_mainform.n_puzzle_game.Caption := GetLanguageText('menu_misc_puzzle.caption');                
  form_mainform.n_official.Caption := GetLanguageText('menu_official.caption');                
  form_mainform.n_entry_official_website.Caption := GetLanguageText('menu_official_entry.caption');                
  form_mainform.n_support_author.Caption := GetLanguageText('menu_official_support.caption');                
  form_mainform.n_support_bmclapi.Caption := GetLanguageText('menu_official_bmclapi.caption');                
  form_mainform.n_manual.Caption := GetLanguageText('menu_manual.caption');                
  form_mainform.n_reset_launcher.Caption := GetLanguageText('menu_manual_reset.caption');                
  form_mainform.n_export_argument.Caption := GetLanguageText('menu_manual_export.caption');                
  form_mainform.n_current_version.Caption := GetLanguageText('menu_manual_version.caption');                
  form_mainform.n_check_update.Caption := GetLanguageText('menu_manual_update.caption');                
  form_mainform.n_test_button.Caption := GetLanguageText('menu_manual_test.caption');
  //以下为主界面
  form_mainform.button_launch_game.hint := GetLanguageText('button_launch_game.hint');                             
  form_mainform.image_refresh_background_image.hint := GetLanguageText('image_refresh_background_image.hint');     
  form_mainform.image_refresh_background_music.hint := GetLanguageText('image_refresh_background_music.hint');
  form_mainform.image_open_download_prograss.hint := GetLanguageText('image_open_download_prograss.hint');
  form_mainform.image_exit_running_mc.hint := GetLanguageText('image_exit_running_mc.hint');     
  //以下为背景设置         
  form_mainform.label_background_tip.caption := GetLanguageText('label_background_tip.caption');   
  form_mainform.label_standard_color.caption := GetLanguageText('label_standard_color.caption');   
  form_mainform.button_grass_color.caption := GetLanguageText('button_grass_color.caption');   
  form_mainform.button_sun_color.caption := GetLanguageText('button_sun_color.caption');   
  form_mainform.button_sultan_color.caption := GetLanguageText('button_sultan_color.caption');   
  form_mainform.button_sky_color.caption := GetLanguageText('button_sky_color.caption');   
  form_mainform.button_cute_color.caption := GetLanguageText('button_cute_color.caption');   
  form_mainform.button_normal_color.caption := GetLanguageText('button_normal_color.caption');   
  form_mainform.buttoncolor_custom_color.caption := GetLanguageText('buttoncolor_custom_color.caption');    
  form_mainform.label_background_window_alpha.caption := GetLanguageText('label_background_window_alpha.caption');  
  form_mainform.label_background_control_alpha.caption := GetLanguageText('label_background_control_alpha.caption');  
  form_mainform.groupbox_background_music_setting.caption := GetLanguageText('groupbox_background_music_setting.caption');  
  form_mainform.button_background_play_music.caption := GetLanguageText('button_background_play_music.caption');  
  form_mainform.button_background_play_music.hint := GetLanguageText('button_background_play_music.hint');  
  form_mainform.button_background_pause_music.caption := GetLanguageText('button_background_pause_music.caption');  
  form_mainform.button_background_pause_music.hint := GetLanguageText('button_background_pause_music.hint');  
  form_mainform.button_background_stop_music.caption := GetLanguageText('button_background_stop_music.caption');    
  form_mainform.button_background_stop_music.hint := GetLanguageText('button_background_stop_music.hint');       
  form_mainform.radiobutton_background_music_open.caption := GetLanguageText('radiobutton_background_music_open.caption');
  form_mainform.radiobutton_background_music_launch.caption := GetLanguageText('radiobutton_background_music_launch.caption'); 
  form_mainform.radiobutton_background_music_not.caption := GetLanguageText('radiobutton_background_music_not.caption'); 
  form_mainform.groupbox_background_launch_setting.caption := GetLanguageText('groupbox_background_launch_setting.caption'); 
  form_mainform.radiobutton_background_launch_hide.caption := GetLanguageText('radiobutton_background_launch_hide.caption'); 
  form_mainform.radiobutton_background_launch_show.caption := GetLanguageText('radiobutton_background_launch_show.caption'); 
  form_mainform.radiobutton_background_launch_exit.caption := GetLanguageText('radiobutton_background_launch_exit.caption'); 
  form_mainform.label_background_mainform_title.caption := GetLanguageText('label_background_mainform_title.caption'); 
  form_mainform.groupbox_background_gradient.caption := GetLanguageText('groupbox_background_gradient.caption'); 
  form_mainform.toggleswitch_background_gradient.StateCaptions.CaptionOn := GetLanguageText('toggleswitch_background_gradient.on.caption'); 
  form_mainform.toggleswitch_background_gradient.StateCaptions.CaptionOff := GetLanguageText('toggleswitch_background_gradient.off.caption'); 
  form_mainform.label_background_gradient_value.caption := GetLanguageText('label_background_gradient_value.caption'); 
  form_mainform.label_background_gradient_step.caption := GetLanguageText('label_background_gradient_step.caption'); 
end;

procedure InitLanguage();
begin
  if not FileExists(Concat(ExtractFilePath(Application.ExeName), 'LLLauncher\lang\zh_cn.json')) then begin
    var zhcnjson := TJSONObject.Create
      .AddPair('file_language_title', '中文（简体）')
      //以下为页
      .AddPair('__pagecontrol_comment', '以下是页面控件语言')
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
      .AddPair('__mainmenu_comment', '以下是菜单栏语言')  
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
      .AddPair('__messagebox_comment', '以下是信息框语言')
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
//      .AddPair('messagebox_account_offline_error.cannot_name.text', '你的离线登录名称并不理想，输入错误！请不要输入中文，也不要超过16个字符！不要为空。')
//      .AddPair('messagebox_account_offline_error.cannot_name.caption', '错误警告')
      //以下为下载列表框
      .AddPair('downloadlist.custom.judge_can_multi_thread_download', '正在判断是否可以多线程下载。')
      .AddPair('downloadlist.custom.url_donot_support_download_in_launcher', '该网址不支持启动器下载，请使用浏览器下载吧！')
      .AddPair('downloadlist.custom.input_url_error_and_this_url_doesnot_has_file', '网址输入错误，该网址下无任何文件。')
      .AddPair('downloadlist.custom.url_statucode_is_not_206_and_try_to_cut', '该网站请求代码不为206，正在对其进行分段……')
      .AddPair('downloadlist.custom.not_allow_cut_use_single_thread_download', '该网站不允许分段下载，已用单线程将该文件下载下来。')
      .AddPair('downloadlist.custom.url_allow_multi_thread_download', '该网站支持多线程下载！')
//      .AddPair('label_progress_download_progress.caption', '下载进度：${download_progress}')
      .AddPair('downloadlist.custom.url_file_size', '文件长度：${download_progress}')
      .AddPair('downloadlist.custom.thread_one_to_single_thread_download', '由于你选择的线程是单线程，现在将直接采取单线程的下载方式。')
      .AddPair('downloadlist.custom.single_thread_download_error', '单线程下载失败，请重试。')
      .AddPair('downloadlist.custom.cut_download_error', '分段下载已下载失败：${cut_download_count}')
      .AddPair('downloadlist.custom.cut_download_retry', '下载失败，正在重试${cut_download_retry}次')
      .AddPair('downloadlist.custom.retry_threetime_error', '重试3次后依旧失败，下载失败！')
      .AddPair('downloadlist.custom.cut_download_success', '分段下载已下载完成：${cut_download_count}')
      .AddPair('label_progress_download_progress.caption', '下载进度：${download_progress}% | ${download_current_count}/${download_all_count}')
      //以下为主窗口
      .AddPair('__mainform_comment', '以下是主窗口语言')
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
      .AddPair('__background_comment', '以下是背景设置语言')
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
      .AddPair('label_background_gradient_current_step.caption', '当前选中：${gradient_step}'); 
    SetFile(Concat(ExtractFilePath(Application.ExeName), 'LLLauncher\lang\zh_cn.json'), zhcnjson.Format);
  end;
end;

//根据多国化语言，获取对应文本
function GetLanguageText(key: String): String;
begin
  try
    result := langjson.GetValue(key).Value;
  except
    result := '';
  end;
end;

end.
