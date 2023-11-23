unit PluginMethod;

interface

//uses
//  Winapi.Windows, Winapi.Messages, System.Variants, System.Classes, Vcl.Graphics,
//  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.MPlayer,
//  System.JSON, System.DateUtils, Vcl.ExtCtrls, Winapi.ShellAPI,
//  System.StrUtils, SysUtils, System.RegularExpressions,
//  Vcl.Buttons, JPEG, pngimage, GIFImg, Data.Bind.ObjectScope;
//
//type
//  TPluginForm = class
//  private
//    procedure PluginButtonClick(Sender: TObject);
//  public
//    class procedure CreatePluginForm(nam: String; json: TJsonObject);
//  end;


implementation

//uses
//  Log4Delphi, MainForm, MainMethod, MyCustomWindow, Generics.Collections;
//
//var //插件部分需要的参数
//  FormJson: TList<TJsonObject>;  //整个插件的Json对象。
//  pljarr: TList<TJsonArray>;     //插件窗口的content属性
//  FormPlugin: TList<TForm>;      //插件的总窗口
//  LArr: TList<TList<TLabel>>;  //标签数组
//  MArr: TList<TList<TMemo>>;   //多行标签数组
//  bArr: TList<TList<TBitbtn>>; //按钮数组【我用bitbtn不行咩】
//  iArr: TList<TList<TImage>>;  //图片数组
//  bClick: TList<TList<TJsonArray>>;//按钮点击后，将bArr的on_click属性全部改成此数组里的on_click里button的change属性里的on_click
//  count: Integer = -1;
//
//var
//  songext: String = '';
//  temp: String;
//
////创建一个插件窗口
//class procedure TPluginForm.CreatePluginForm(nam: String; json: TJsonObject);
//var
//  TempDir: array[0..255] of char;
//begin //哎呀，里面的内容都好简单的，我就不必要写注释了吧。。。大致功能是判断json文件的内容是否有误，如果没有误，则判断是否有form_create方法。如果有，则遍历执行。
////然后ShowModal阻塞主窗口。然后给所有控件附上名字与属性。最终当大家叉掉窗口的时候，遍历执行form_close代码块中的方法。
//  if count < 0 then begin
////    SetLength(FormJson, 100);
////    SetLength(FormPlugin, 100);
////    SetLength(pljarr, 100);
////    SetLength(LArr, 100, 1000);
////    SetLength(MArr, 100, 1000);
////    SetLength(bArr, 100, 1000);
////    SetLength(iArr, 100, 1000);
////    SetLength(bClick, 100, 1000);
//    FormJson := TList<TJsonObject>.Create;
//    pljarr := TList<TJsonArray>.Create;
//    FormPlugin := TList<TForm>.Create;
//    LArr := TList<TList<TLabel>>.Create;
//    MArr := TList<TList<TMemo>>.Create;
//    bArr := TList<TList<TBitbtn>>.Create;
//    iArr := TList<TList<TImage>>.Create;
//    bClick := TList<TList<TJsonArray>>.Create;
//    if not DirectoryExists(Concat(temp, 'LLLauncher\song')) then ForceDirectories(Concat(temp, 'LLLauncher\song'));
//    GetTempPath(255, @TempDir);
//    temp := strpas(TempDir);
//  end;
//  inc(count);
//  FormJson.Add(json);
//  FormPlugin.Add(TForm.Create(nil));
//  try
//    Log.Write('开始判断插件的某些必须属性。', LOG_INFO, LOG_PLUGIN);
//    FormPlugin[count].Name := json.GetValue('name').Value;
//    FormPlugin[count].Caption := nam;
//    var wwt := 43;
//    var hht := 40;
//    try
//      wwt := json.GetValue<Integer>('form_width');
//      hht := json.GetValue<Integer>('form_height');
//      if (wwt > Screen.Width) or (wwt < 43) then raise Exception.Create('Plugin Error');
//      if (hht > Screen.Height) or (hht < 40) then raise Exception.Create('Plugin Error');
//    except
//      messagebox(0, '无法正确识别长宽属性，请不要超过你的电脑屏幕分辨率高度。', '无法正确识别长宽', MB_ICONERROR);
//      exit;
//    end;
//    FormPlugin[count].Width := wwt;
//    FormPlugin[count].Height := hht;
//    FormPlugin[count].BorderStyle := TFormBorderStyle.bsSingle;
//    FormPlugin[count].BorderIcons := [TBorderIcon.biSystemMenu, TBorderIcon.biMinimize];
//    Log.Write('插件必须属性已被判断完毕，现在开始判断可选属性。', LOG_INFO, LOG_PLUGIN);
//    FormPlugin[count].AlphaBlend := true;
//    FormPlugin[count].Icon := form_mainform.Icon;
//    var colour: TColor := rgb(240, 240, 240);
//    try
//      var colorStr := json.GetValue('form_color').Value;
//      if TRegex.IsMatch(colorStr.Replace('#', '').ToLower, '^[0-9a-f]{6}') then
//        colour := StringToColor(Concat('$00', colorstr.Replace('#', '')))
//      else raise Exception.Create('Plugin Error');
//    except
//      colour := rgb(240, 240, 240);
//    end;
//    FormPlugin[count].Color := colour;
//    var alpha := 255;
//    try
//      alpha := json.GetValue<Integer>('form_alpha');
//      if (alpha < 127) or (alpha > 255) then raise Exception.Create('Plugin Error');
//    except
//      alpha := 255;
//    end;
//    var bcount := 0;
//    var lcount := 0;
//    var mcount := 0;
//    var icount := 0;
//    var bcct := 0;
//    FormPlugin[count].AlphaBlendValue := alpha;
//    var center := true;
//    try center := json.GetValue<Boolean>('form_center'); except center := true; end;
//    if center then FormPlugin[count].Position := Vcl.Forms.poDesktopCenter
//    else FormPlugin[count].Position := poDefault;
//    Log.Write('可选属性已判断完毕，现在开始判断插件的组件。从现在起后面的插件部分将不再附上Log日志，使用什么插件完全是你们自己的事情了。', LOG_INFO, LOG_PLUGIN);
//    iArr.Add(TList<TImage>.Create);
//    bArr.Add(TList<TBitbtn>.Create);
//    bclick.Add(TList<TJsonArray>.Create);
//    LArr.Add(TList<TLabel>.Create);
//    mArr.Add(TList<TMemo>.Create);
//    try
//      pljarr.Add(json.GetValue('content') as TJsonArray);
//      for var I in pljarr[count] do begin
//        var kj := I as TJsonObject;
//        var te := kj.GetValue('type').Value;
//        if te = 'button' then begin
//          inc(bcount);
////          SetLength(bArr, count + 1, bcount);
//          bArr[count].Add(TBitbtn.Create(FormPlugin[count]));
//          bArr[count][bcount - 1].Parent := FormPlugin[count];
//          try
//            bArr[count][bcount - 1].Name := kj.GetValue('name').Value;
//            bArr[count][bcount - 1].Top := kj.GetValue<Integer>('top');
//            bArr[count][bcount - 1].Left := kj.GetValue<Integer>('left');
//            bArr[count][bcount - 1].Width := kj.GetValue<Integer>('width');
//            bArr[count][bcount - 1].Height := kj.GetValue<Integer>('height');
//          except
//            messagebox(0, '无法读取某一个Button的必须属性值，请认真对待你的插件。', '无法读取Button', MB_ICONERROR);
//            exit;
//          end;
//          try bArr[count][bcount - 1].Caption := kj.GetValue('caption').Value; except bArr[count][bcount - 1].Caption := ''; end;
//          try bArr[count][bcount - 1].Font.Name := kj.GetValue('font').Value; except bArr[count][bcount - 1].Font.Name := '宋体'; end;
//          try bArr[count][bcount - 1].Font.Size := kj.GetValue<Integer>('font_size'); except bArr[count][bcount - 1].Font.Size := 9; end;
//          try bArr[count][bcount - 1].Font.Color := StringToColor(Concat('$00', kj.GetValue('font_color').Value.Replace('#', '').ToLower)); except bArr[count][bcount - 1].Font.Color := rgb(0, 0, 0); end;
//          try
//            var tmp := kj.GetValue('on_click') as TJsonArray;
//            inc(bcct);
////            SetLength(BClick, count + 1, bcct);
//            BClick[count].Add(tmp);
//            bArr[count][bcount - 1].OnClick := TPluginForm.Create.PluginButtonClick;
//          except bArr[count][bcount - 1].OnClick := nil; end;
//        end else if te = 'label' then begin
//          inc(lcount);
////          SetLength(lArr, count + 1, lcount);
//          lArr[count].Add(TLabel.Create(FormPlugin[count]));
//          lArr[count][lcount - 1].Parent := FormPlugin[count];
//          lArr[count][lcount - 1].AutoSize := true;
//          try
//            lArr[count][lcount - 1].Name := kj.GetValue('name').Value;
//            lArr[count][lcount - 1].Top := kj.GetValue<Integer>('top');
//            lArr[count][lcount - 1].Left := kj.GetValue<Integer>('left');
//          except
//            messagebox(0, '无法读取某一个Label的必须属性值，请认真对待你的插件。', '无法读取Label', MB_ICONERROR);
//            exit;
//          end;
//          lArr[count][lcount - 1].Font.Charset := GB2312_CHARSET;
//          try lArr[count][lcount - 1].Caption := kj.GetValue('caption').Value; except lArr[count][lcount - 1].Caption := ''; end;
//          try lArr[count][lcount - 1].Font.Name := kj.GetValue('font').Value; except lArr[count][lcount - 1].Font.Name := '宋体'; end;
//          try lArr[count][lcount - 1].Font.Size := kj.GetValue<Integer>('font_size'); except lArr[count][lcount - 1].Font.Size := 9; end;
//          try lArr[count][lcount - 1].Font.Color := StringToColor(Concat('$00', kj.GetValue('font_color').Value.Replace('#', '').ToLower)); except lArr[count][lcount - 1].Font.Color := rgb(0, 0, 0); end;
//        end else if te = 'memo' then begin
//          inc(mcount);
////          SetLength(mArr, count + 1, mcount);
//          mArr[count].Add(TMemo.Create(FormPlugin[count]));
//          mArr[count][mcount - 1].Parent := FormPlugin[count];
//          mArr[count][mcount - 1].ReadOnly := true;
//          mArr[count][mcount - 1].ScrollBars := TScrollStyle.ssBoth;
//          try
//            mArr[count][mcount - 1].Name := kj.GetValue('name').Value;
//            mArr[count][mcount - 1].Top := kj.GetValue<Integer>('top');
//            mArr[count][mcount - 1].Left := kj.GetValue<Integer>('left');
//            mArr[count][mcount - 1].Width := kj.GetValue<Integer>('width');
//            mArr[count][mcount - 1].Height := kj.GetValue<Integer>('height');
//          except
//            messagebox(0, '无法读取某一个Memo的必须属性值，请认真对待你的插件。', '无法读取Memo', MB_ICONERROR);
//            exit;
//          end;
//          mArr[count][mcount - 1].Font.Charset := GB2312_CHARSET;
//          mArr[count][mcount - 1].Lines.Clear;
//          try
//            var ln := kj.GetValue('lines') as TJsonArray;
//            for var J in ln do mArr[count][mcount - 1].Lines.Add(J.GetValue<String>);
//          except mArr[count][mcount - 1].Lines.Clear; end;
//          try mArr[count][mcount - 1].Font.Name := kj.GetValue('font').Value; except mArr[count][mcount - 1].Font.Name := '宋体'; end;
//          try mArr[count][mcount - 1].Font.Size := kj.GetValue<Integer>('font_size'); except mArr[count][mcount - 1].Font.Size := 9; end;
//          try mArr[count][mcount - 1].Font.Color := StringToColor(Concat('$00', kj.GetValue('font_color').Value.Replace('#', '').ToLower)); except mArr[count][mcount - 1].Font.Color := rgb(0, 0, 0); end;
//        end else if te = 'image' then begin
//          inc(icount);
////          SetLength(iArr, count + 1, icount);
//          iArr[count].Add(TImage.Create(FormPlugin[count]));
//          iArr[count][icount - 1].Parent := FormPlugin[count];
//          try
//            iArr[count][icount - 1].AutoSize := false;
//            iArr[count][icount - 1].Name := kj.GetValue('name').Value;
//            iArr[count][icount - 1].Stretch := True;
//            iArr[count][icount - 1].Top := kj.GetValue<Integer>('top');
//            iArr[count][icount - 1].Left := kj.GetValue<Integer>('left');
//            try iArr[count][icount - 1].Width := kj.GetValue<Integer>('width'); except iArr[count][icount - 1].AutoSize := true; end;
//            try iArr[count][icount - 1].Height := kj.GetValue<Integer>('height'); except iArr[count][icount - 1].AutoSize := true; end;
//            var ph := kj.GetValue('path').Value;
//            if ph <> '' then begin
//              if LeftStr(ph, 4) = 'http' then begin
//                var c := GetWebStream(ph);
//                if c = nil then raise Exception.Create('Read Plugin Json Error');
//                var suffix := ph.Substring(ph.LastIndexOf('.'), ph.Length - ph.LastIndexOf('.'));
//                if (suffix = '.jpg') or (suffix = '.jpeg') then begin
//                  var jpg := TJpegImage.Create;
//                  jpg.LoadFromStream(c);
//                  iArr[count][icount - 1].Picture.Bitmap.Assign(jpg);
//                end else if suffix = '.bmp' then begin
//                  iArr[count][icount - 1].Picture.Bitmap.LoadFromStream(c);
//                end else if suffix = '.png' then begin
//                  var png := TPngImage.Create;
//                  png.LoadFromStream(c);
//                  iArr[count][icount - 1].Picture.Bitmap.Assign(png);
//                end else if suffix = '.gif' then begin
//                  var gif := TGifImage.Create;
//                  gif.LoadFromStream(c);
//                  iArr[count][icount - 1].Picture.Bitmap.Assign(gif);
//                end;
//              end else begin
//                if not FileExists(ph) then raise Exception.Create('Read Plugin Json Error');
//                if ph.IndexOf('.') = 0 then ph := Concat(ExtractFileDir(Application.ExeName), ph.Substring(1, ph.Length - 1));
//                var suffix := ph.Substring(ph.LastIndexOf('.'), ph.Length - ph.LastIndexOf('.'));
//                if (suffix = '.jpg') or (suffix = '.jpeg') then begin
//                  var jpg := TJpegImage.Create;
//                  jpg.LoadFromFile(ph);
//                  iArr[count][icount - 1].Picture.Bitmap.Assign(jpg);
//                end else if suffix = '.bmp' then begin
//                  iArr[count][icount - 1].Picture.Bitmap.LoadFromFile(ph)
//                end else if suffix = '.png' then begin
//                  var png := TPngImage.Create;
//                  png.LoadFromFile(ph);
//                  iArr[count][icount - 1].Picture.Bitmap.Assign(png);
//                end else if suffix = '.gif' then begin
//                  var gif := TGifImage.Create;
//                  gif.LoadFromFile(ph);
//                  iArr[count][icount - 1].Picture.Bitmap.Assign(gif);
//                end;
//              end;
//            end;
//          except
//            messagebox(FormPlugin[count].Handle, '无法读取某一个Image的必须属性值，请认真对待你的插件。', '无法读取Memo', MB_ICONERROR);
//            exit;
//          end;
//        end else begin
//          messagebox(FormPlugin[count].Handle, '插件读取错误，在content里面有一个不属于label、memo、button、image等的控件类型。', '插件读取错误', MB_ICONERROR);
//          exit;
//        end;
//      end;
//    except
//      messagebox(FormPlugin[count].Handle, '插件读取失败，你的插件content中的某一个键有问题，请调整。', '路径不存在或者路径已损坏', MB_ICONERROR);
//      exit;
//    end;
//    try
//      var mph := json.GetValue('song').Value;
//      if mph = '' then raise Exception.Create('Normal');
//      songext := RightStr(mph, 4);
////      try
//        if LeftStr(mph, 4) = 'http' then begin
//          var path := Concat(temp, 'LLLauncher\song\tempsong', songext);
//          var ss := GetWebStream(mph);
//          if ss = nil then begin
//            messagebox(FormPlugin[count].Handle, '在读取json中的song时，判断其为网址，但是该网址不存在或网络不好！请重试或者重新输入你的网址', '网址不存在或网络不好', MB_ICONERROR);
//            exit;
//          end;
//          ss.SaveToFile(path);
//          v.FileName := path;
//          v.Open;
//          v.Play;
//        end else begin
//          if not FileExists(mph) then begin
//            messagebox(FormPlugin[count].Handle, '在读取json中的song时，判断其为本地文件，但是该路径不存在或已损坏，请重新输入你的路径。', '路径不存在或者路径已损坏', MB_ICONERROR);
//            exit;
//          end;
//          v.FileName := mph;
//          v.Open;
//          v.Play;
//        end;
////      except
////        messagebox(FormPlugin.Handle, '无法读取某一个song的必须属性值，请认真对待你的插件。', '无法读取Memo', MB_ICONERROR);
////        exit;
////      end;
//    except
//    end;
//    try
//      var pja := json.GetValue('form_create') as TJsonArray;
//      for var I in pja do begin
//        var lt := I.Value;
//        RunDOSOnlyWait(lt);
//      end;
//      pja.Free;
//    except
//    end;
//    FormPlugin[count].ShowModal;
//    try
//      var pja := json.GetValue('form_close') as TJsonArray;
//      for var I in pja do begin
//        var lt := I.GetValue<String>;
//        RunDOSOnlyWait(lt);
//      end;
//      pja.Free;
//    except
//    end;
//    if FileExists(Concat(temp, 'LLLauncher\song\tempsong', songext)) then begin
//      deleteFile(Concat(temp, 'LLLauncher\song\tempsong', songext));
//    end;
//  finally
//    FormPlugin.Delete(count);
//    pljarr.Delete(count);
//    FormJson.Delete(count);
//    bArr.Delete(count);
//    larr.Delete(count);
//    marr.Delete(count);
//    iarr.Delete(count);
//    bclick.Delete(count);
//    dec(count);
//  end;
//end;
//
////插件的按钮点击的事件。这里面总共概述一下功能，首先获取按钮在json文件中的位置，然后判断json中的name是否与按钮的name一致，如果一致则开始遍历on_click中的内容并执行。大致就是这样了。
//procedure TPluginForm.PluginButtonClick(Sender: TObject);
//var
//  tmplb, tmpmo, tmpbt, tmpig, tpbtc: Integer;
//  tmpfo: Boolean;
//begin
//  tpbtc := 0;
//  var bname: String := (Sender as TBitbtn).Name;
//  for var I in pljarr[count] do begin
//    var rr := I as TJsonObject;
//    if rr.GetValue('type').Value = 'button' then begin
//      inc(tpbtc);
//      var jname := rr.GetValue('name').Value;
//      if jname = bname then begin
//        var jrun := bClick[count][tpbtc - 1];
//        for var J in jrun do begin
//          var Jrt := J as TJsonObject;
//          var jtp := Jrt.GetValue('type').Value;
//          if jtp = 'messagebox' then begin
//            var tle := '';
//            var ctx := '';
//            var ico := '';
//            try
//              tle := Jrt.GetValue('title').Value;
//              ctx := Jrt.GetValue('context').Value;
//            except messagebox(FormPlugin[count].Handle, '插件读取错误！在按钮on_click中的messagebox中缺少title、context中的任何一个，请修改！', '插件读取错误', MB_ICONERROR); end;
//            try ico := Jrt.GetValue('icon').Value; except ico := 'none'; end;
//            var tmpio := 0;
//            if ico = 'information' then tmpio := MY_INFORMATION
//            else if ico = 'error' then tmpio := MY_ERROR
//            else if ico = 'warning' then tmpio := MY_WARNING
//            else if ico = 'pass' then tmpio := MY_PASS;
//            MyMessageBox(tle, ctx, tmpio, [mybutton.myYes]);
//          end else if jtp = 'change' then begin
//            tmplb := 0;
//            tmpmo := 0;
//            tmpbt := 0;
//            tmpig := 0;
//            tmpfo := false;
//            var ne := Jrt.GetValue('name').Value;
//            if Jrt.GetValue('name').Value = bname then begin
//              messagebox(FormPlugin[count].Handle, '插件读取错误，在按钮on_click中的change中的name与此按钮的name一致，请修改！', '插件读取错误', MB_ICONERROR);
//              exit;
//            end;
//            if jrt.GetValue('name').Value = FormJson[count].GetValue('name').Value then tmpfo := true;
//            for var O in pljarr[count] do begin
//              var rs := O as TJsonObject;
//              var jr := rs.GetValue('type').Value;
//              if jr = 'label' then begin
//                if ne = larr[count][tmplb].Name then break;
//                inc(tmplb);
//              end else if jr = 'memo' then begin
//                if ne = marr[count][tmpmo].Name then break;
//                inc(tmpmo);
//              end else if jr = 'button' then begin
//                if ne = barr[count][tmpbt].Name then break;
//                inc(tmpbt);
//              end else if jr = 'image' then begin
//                if ne = iarr[count][tmpig].Name then break;
//                inc(tmpig);
//              end else begin
//                messagebox(FormPlugin[count].Handle, '插件读取错误，在content里面有一个不属于label、memo、button、image等的控件类型。', '插件读取错误', MB_ICONERROR);
//                exit;
//              end;
//            end;
//            if tmpfo then begin
//              try FormPlugin[count].AlphaBlendValue := jrt.GetValue<Byte>('form_alpha'); except end;
//              try FormPlugin[count].Width := jrt.GetValue<Integer>('form_width'); except end;
//              try FormPlugin[count].Height := jrt.GetValue<Integer>('form_height'); except end;
//              try
//                var colour := jrt.GetValue('form_color').Value;
//                var coloor := rgb(240, 240, 240);
//                if TRegex.IsMatch(colour.Replace('#', '').ToLower, '^[0-9a-f]{6}') then begin
//                  coloor := StringToColor(Concat('$00', colour.Replace('#', '')));
//                end;
//                FormPlugin[count].Color := coloor;
//              except end;
//            end;
//            for var D in plJarr[count] do begin
//              var K := D as TJsonObject;
//              if ne = K.GetValue('name').Value then begin
//                if K.GetValue('type').Value = 'label' then begin
//                  try larr[count][tmplb].Caption := jrt.GetValue('caption').Value;
//                  except messagebox(FormPlugin[count].Handle, '插件读取错误！在按钮on_click中的change中type为label代码块中缺少必要属性caption，请修改！', '插件读取错误', MB_ICONERROR); exit; end;
//                  try larr[count][tmplb].Top := jrt.GetValue<Integer>('top') except end;
//                  try larr[count][tmplb].Left := jrt.GetValue<Integer>('left') except end;
//                  try larr[count][tmplb].Font.Name := jrt.GetValue('font').Value except end;
//                  try larr[count][tmplb].Font.Size := jrt.GetValue<Integer>('font_size') except end;
//                  try larr[count][tmplb].Font.Color := StringToColor(Concat('$00', jrt.GetValue('font_color').Value.Replace('#', '').ToLower)); except larr[count][tmplb].Font.Color := rgb(0, 0, 0); end;
//                end else if K.GetValue('type').Value = 'memo' then begin
//                  try
//                    var Jo := jrt.GetValue('lines') as TJsonArray;
//                    marr[count][tmpmo].Lines.Clear;
//                    for var P in Jo do begin marr[count][tmpmo].Lines.Add(P.GetValue<String>); end;
//                  except messagebox(FormPlugin[count].Handle, '插件读取错误！在按钮on_click中的change中type为memo代码块中缺少必要属性lines，请修改！', '插件读取错误', MB_ICONERROR); exit; end;
//                  try marr[count][tmpmo].Top := jrt.GetValue<Integer>('top') except end;
//                  try marr[count][tmpmo].Left := jrt.GetValue<Integer>('left') except end;
//                  try marr[count][tmpmo].Height := jrt.GetValue<Integer>('height') except end;
//                  try marr[count][tmpmo].Width := jrt.GetValue<Integer>('width') except end;
//                  try marr[count][tmpmo].Font.Name := jrt.GetValue('font').Value except end;
//                  try marr[count][tmpmo].Font.Size := jrt.GetValue<Integer>('font_size') except end;
//                  try marr[count][tmpmo].Font.Color := StringToColor(Concat('$00', jrt.GetValue('font_color').Value.Replace('#', '').ToLower)); except marr[count][tmpmo].Font.Color := rgb(0, 0, 0); end;
//                end else if K.GetValue('type').Value = 'button' then begin
//                  try
//                    barr[count][tmpbt].Caption := jrt.GetValue('caption').Value;
//                  except messagebox(FormPlugin[count].Handle, '插件读取错误！在按钮on_click中的change中type为button代码块中缺少必要属性caption，请修改！', '插件读取错误', MB_ICONERROR); exit; end;
//                  try barr[count][tmpbt].Top := jrt.GetValue<Integer>('top') except end;
//                  try barr[count][tmpbt].Left := jrt.GetValue<Integer>('left') except end;
//                  try barr[count][tmpbt].Height := jrt.GetValue<Integer>('height') except end;
//                  try barr[count][tmpbt].Width := jrt.GetValue<Integer>('width') except end;
//                  try barr[count][tmpbt].Font.Name := jrt.GetValue('font').Value except end;
//                  try barr[count][tmpbt].Font.Size := jrt.GetValue<Integer>('font_size') except end;
//                  try barr[count][tmpbt].Font.Color := StringToColor(Concat('$00', jrt.GetValue('font_color').Value.Replace('#', '').ToLower)); except barr[count][tmpbt].Font.Color := rgb(0, 0, 0); end;
//                  try BClick[count][tmpbt] := jrt.GetValue('on_click') as TJsonArray; except end;
//                end else if K.GetValue('type').Value = 'image' then begin
//                  try
//                    try iarr[count][tmpig].Top := jrt.GetValue<Integer>('top') except end;
//                    try iarr[count][tmpig].Left := jrt.GetValue<Integer>('left') except end;
//                    try
//                      var hh := jrt.GetValue<Integer>('height');
//                      iarr[count][tmpig].AutoSize := false;
//                      iarr[count][tmpig].Height := hh;
//                    except iarr[count][tmpig].AutoSize := true; end;
//                    try
//                      var ww := jrt.GetValue<Integer>('width');
//                      iarr[count][tmpig].AutoSize := false;
//                      iarr[count][tmpig].Width := ww;
//                    except iarr[count][tmpig].AutoSize := true; end;
//                    var ph := jrt.GetValue('path').Value;
//                    if ph = '' then begin
//                      iarr[count][tmpig].Picture := nil;
//                    end else if LeftStr(ph, 4) = 'http' then begin
//                      var c := GetWebStream(ph);
//                      if c = nil then raise Exception.Create('Read Plugin Json Error');
//                      var suffix := ph.Substring(ph.LastIndexOf('.'), ph.Length - ph.LastIndexOf('.'));
//                      if (suffix = '.jpg') or (suffix = '.jpeg') then begin
//                        var jpg := TJpegImage.Create;
//                        jpg.LoadFromStream(c);
//                        iarr[count][tmpig].Picture.Bitmap.Assign(jpg);
//                      end else if suffix = '.bmp' then begin
//                        iarr[count][tmpig].Picture.Bitmap.LoadFromStream(c);
//                      end else if suffix = '.png' then begin
//                        var png := TPngImage.Create;
//                        png.LoadFromStream(c);
//                        iarr[count][tmpig].Picture.Bitmap.Assign(png);
//                      end else if suffix = '.gif' then begin
//                        var gif := TGifImage.Create;
//                        gif.LoadFromStream(c);
//                        iarr[count][tmpig].Picture.Bitmap.Assign(gif);
//                      end;
//                    end else begin
//                      if not FileExists(ph) then raise Exception.Create('Read Plugin Json Error');
//                      if ph.IndexOf('.') = 0 then ph := ph.Replace('.', ExtractFileDir(Application.ExeName));
//                      var suffix := ph.Substring(ph.LastIndexOf('.'), ph.Length - ph.LastIndexOf('.'));
//                      if (suffix = '.jpg') or (suffix = '.jpeg') then begin
//                        var jpg := TJpegImage.Create;
//                        jpg.LoadFromFile(ph);
//                        iarr[count][tmpig].Picture.Bitmap.Assign(jpg);
//                      end else if suffix = '.bmp' then begin
//                        iarr[count][tmpig].Picture.Bitmap.LoadFromFile(ph)
//                      end else if suffix = '.png' then begin
//                        var png := TPngImage.Create;
//                        png.LoadFromFile(ph);
//                        iarr[count][tmpig].Picture.Bitmap.Assign(png);
//                      end else if suffix = '.gif' then begin
//                        var gif := TGifImage.Create;
//                        gif.LoadFromFile(ph);
//                        iarr[count][tmpig].Picture.Bitmap.Assign(gif);
//                      end;
//                    end;
//                  except messagebox(FormPlugin[count].Handle, '插件读取错误！在按钮on_click中的change中type为image代码块中缺少必要属性path，请修改！', '插件读取错误', MB_ICONERROR); exit; end;
//                  try iarr[count][tmpig].Top := jrt.GetValue<Integer>('top'); except end;
//                  try iarr[count][tmpig].Left := jrt.GetValue<Integer>('left'); except end;
//                end;
//              end;
//            end;
//          end else if jtp = 'shell' then begin
//            try
//              var jy := jrt.GetValue('implement') as TJsonArray;
//              for var Q in jy do begin
//                var lt := Q.GetValue<String>;
//                RunDOSOnlyWait(lt);
//              end;
//            except messagebox(FormPlugin[count].Handle, '插件读取错误！在按钮on_click中type为shell代码块中缺少必要属性implement，请修改！', '插件读取错误', MB_ICONERROR) end;
//          end else if jtp = 'song' then begin
//            try
//              var mph := jrt.GetValue('path').Value;
//              if mph = '' then raise Exception.Create('Normal');
//              songext := RightStr(mph, 4);
//              try
//                if LeftStr(mph, 4) = 'http' then begin
//                  var path := Concat(temp, 'LLLauncher\song\tempsong', songext);
//                  var ss := GetWebStream(mph);
//                  if ss = nil then begin
//                    messagebox(FormPlugin[count].Handle, '在读取json中的song时，判断其为网址，但是该网址不存在或网络不好！请重试或者重新输入你的网址', '网址不存在或网络不好', MB_ICONERROR);
//                    exit;
//                  end;
//                  ss.SaveToFile(path);
//                  v.FileName := path;
//                  v.Open;
//                  v.Play;
//                end else begin
//                  if not FileExists(mph) then begin
//                    messagebox(FormPlugin[count].Handle, '在读取json中的song时，判断其为本地文件，但是该路径不存在或已损坏，请重新输入你的路径。', '路径不存在或者路径已损坏', MB_ICONERROR);
//                    exit;
//                  end;
//                  v.FileName := mph;
//                  v.Open;
//                  v.Play;
//                end;
//              except
//                messagebox(FormPlugin[count].Handle, '无法读取某一个song的必须属性值，请认真对待你的插件。', '无法读取Memo', MB_ICONERROR);
//                exit;
//              end;
//            except
//            end;
//          end else if jtp = 'open' then begin
//            var jrrt := jrt.GetValue('path').Value;
//            if RightStr(jrrt, 5) = '.json' then begin
//              try
//                var content := '';
//                if LeftStr(jrrt, 4) = 'http' then
//                  content := GetWebText(jrrt)
//                else
//                  content := GetFile(jrrt);
//                if content = '' then raise Exception.Create('Plugin Read Error');
//                var ise := TJsonObject.ParseJSONValue(content) as TJsonObject;
//                try
//                  var ul := GetWebText(ise.GetValue('url').Value);
//                  if ul = '' then begin
//                    Log.Write('插件加载失败', LOG_ERROR, LOG_PLUGIN);
//                    messagebox(FormPlugin[count].Handle, '获取的URL内容为空，请重新输入一个网址！', '获取的URL内容为空', MB_ICONERROR);
//                    exit;
//                  end;
//                  ise := TJsonObject.ParseJSONValue(ul) as TJsonObject;
//                except end;
//                try
//                  if ise.GetValue('name').Value = '' then raise Exception.Create('Plugin Format Exception');
//                  if ise.GetValue<Integer>('form_height') = 0 then raise Exception.Create('Plugin Format Exception');
//                  if ise.GetValue<Integer>('form_width') = 0 then raise Exception.Create('Plugin Format Exception');
//                except
//                  Log.Write(Concat('插件加载失败'), LOG_ERROR, LOG_PLUGIN);
//                  messagebox(FormPlugin[count].Handle, pchar(Concat('此插件语法格式错误！')), '插件发生报错', MB_ICONERROR);
//                  exit;
//                end;
//                var nee := '';
//                if jrrt.IndexOf('/') = -1 then nee := jrrt.Substring(jrrt.IndexOf('\')).Replace('.json', '')
//                else nee := jrrt.Substring(jrrt.IndexOf('/')).Replace('.json', '');
//                TPluginForm.CreatePluginForm(nee, ise); //调用方法
//              except
//                messagebox(FormPlugin[count].Handle, '插件读取错误！在按钮on_click代码块中的open属性中的path属性，未能正确找到其窗口必须属性，请修改！', '插件读取错误', MB_ICONERROR);
//                exit;
//              end;
//            end else begin
//              messagebox(FormPlugin[count].Handle, '插件读取错误！在按钮on_click代码块中的open属性中的path末尾并不是json后缀，请修改！', '插件读取错误', MB_ICONERROR);
//              exit;
//            end;
//          end else begin
//            messagebox(FormPlugin[count].Handle, '插件读取错误！在按钮on_click代码块中缺少必要属性type，请修改！', '插件读取错误', MB_ICONERROR);
//            exit;
//          end;
//        end;
//        break;
//      end;
//    end;
//  end;
//end;

end.

