unit MultiPluginMethod;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Forms, Vcl.StdCtrls, Vcl.MPlayer, Generics.Collections,
  System.JSON, Vcl.ExtCtrls, Winapi.ShellAPI, ComCtrls, Types,
  System.StrUtils, SysUtils, Vcl.Buttons, JPEG, pngimage, GIFImg, Vcl.Controls, Vcl.Menus, Clipbrd;

type
  TPluginForm = class
  private
    PluginJSON: TJSONObject;
    PluginTabSheet: TTabSheet;
    PluginScrollBox: TScrollBox;
    PluginButton: TList<TBitBtn>;
    PluginLabel: TList<TLabel>;
    PluginMemo: TList<TMemo>;
    PluginEdit: TList<TEdit>;
    PluginScrollBar: TList<TScrollBar>;
    PluginSpeedButton: TList<TSpeedButton>;
    PluginImage: TList<TImage>;
    PluginCombobox: TList<TCombobox>;
    PluginVariableDic: TDictionary<string, string>;
  public
    constructor ConstructorPluginForm(name, json: String);
    procedure PluginControlClick(Sender: TObject);
    procedure PluginControlChange(Sender: TObject);
    procedure PluginControlMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure PluginControlMouseLeave(Sender: TObject);
    procedure PluginControlScroll(Sender: TObject;
      ScrollCode: TScrollCode; var ScrollPos: Integer);
    procedure PluginScrollBoxMouseWheel(Sender: TObject;
      Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
      var Handled: Boolean);
    function VariableToValue(text: String): String;
    function JudgeEvent(json: TJSONObject): Boolean;
  end;

var
  PluginFormList: TList<TPluginForm>;

implementation

uses
  Log4Delphi, MainForm, MainMethod, MyCustomWindow, LanguageMethod;
//插件变量换成值（在文本的任意位置，将所有变量转换成值）
function TPluginForm.VariableToValue(text: String): String;
begin
  for var I in PluginVariableDic do begin
    text := text.Replace(Concat('${', I.Key, '}'), I.Value);
  end;
  result := text;
end;
function TPluginForm.JudgeEvent(json: TJSONObject): Boolean;
begin
  result := false;
  try
    var jif := json.GetValue('if') as TJSONObject;
    var jva := jif.GetValue('ifvariable').Value;
    var jvl := VariableToValue(jif.GetValue('ifvalue').Value);
    jif.RemovePair('ifvariable');
    jif.RemovePair('ifvalue');
    var jeq := '';
    try
      var jjd := VariableToValue(jif.GetValue('ifjudge').Value);
      jif.RemovePair('ifjudge');
      if jjd.Equals('less') then jeq := 'less'
      else if jjd.Equals('more') then jeq := 'more'
      else if jjd.Equals('equal') then jeq := 'equal'
      else if jjd.Equals('more_equal') then jeq := 'more_equal'
      else if jjd.Equals('less_equal') then jeq := 'less_equal'
      else raise Exception.Create('cannot solve judge!');
    except jeq := 'equal'; end;
    var jyb := VariableToValue(Concat('${', jva, '}'));
    if jeq.Equals('equal') then begin
      if jyb.Equals(jvl) then begin 
        if JudgeEvent(jif) then begin 
          result := true; 
          exit; 
        end; 
      end else begin
        try
          var jel := json.GetValue('else') as TJSONObject;
          jel.ToString;
          if JudgeEvent(jel) then begin
            result := true;
            exit;
          end;
        except end;
      end;    
    end else if jeq.Equals('less') then begin
      if strtoint(jyb) < strtoint(jvl) then begin 
        if JudgeEvent(jif) then begin 
          result := true; 
          exit; 
        end; 
      end else begin
        try
          var jel := json.GetValue('else') as TJSONObject;
          jel.ToString;
          if JudgeEvent(jel) then begin
            result := true;
            exit;
          end;
        except end;
      end;
    end else if jeq.Equals('more') then begin
      if strtoint(jyb) > strtoint(jvl) then begin 
        if JudgeEvent(jif) then begin 
          result := true; 
          exit; 
        end; 
      end else begin
        try
          var jel := json.GetValue('else') as TJSONObject;
          jel.ToString;
          if JudgeEvent(jel) then begin
            result := true;
            exit;
          end;
        except end;
      end;
    end else if jeq.Equals('more_equal') then begin
      if strtoint(jyb) >= strtoint(jvl) then begin 
        if JudgeEvent(jif) then begin  
          result := true; 
          exit; 
        end; 
      end else begin
        try
          var jel := json.GetValue('else') as TJSONObject;
          jel.ToString;
          if JudgeEvent(jel) then begin
            result := true;
            exit;
          end;
        except end;
      end;
    end else if jeq.Equals('less_equal') then begin
      if strtoint(jyb) <= strtoint(jvl) then begin 
        if JudgeEvent(jif) then begin 
          result := true; 
          exit; 
        end; 
      end else begin
        try
          var jel := json.GetValue('else') as TJSONObject;
          jel.ToString;
          if JudgeEvent(jel) then begin
            result := true;
            exit;
          end;
        except end;
      end;
    end;
  except
    var jtype := json.GetValue('type').Value;
    if jtype.Equals('messagebox') then begin
      var title := '';
      var context := '';
      var color := 16714250;
      var button: TArray<mybutton> := [];
      var cbutton: TArray<String> := [];
      try title := VariableToValue(json.GetValue('title').Value); except end;
      try context := VariableToValue(json.GetValue('context').Value); except end;
      try 
        var ycolor := json.GetValue('color').Value;
        if ycolor.Equals('warning') then begin
          color := 710655;
        end else if ycolor.Equals('error') then begin
          color := 658175;
        end else if ycolor.Equals('information') then begin
          color := 16714250;
        end else if ycolor.Equals('pass') then begin
          color := 704522;
        end else begin
          color := ConvertHexToColor(ycolor);
        end;
      except end;
      try
        var btn := json.GetValue('button') as TJSONArray;
        var bl := 0;
        var bc := 0;
        for var I in btn do begin
          var J := I.Value;
          inc(bl);
          if J.Equals('yes') then begin
            SetLength(button, bl);
            button[bl - 1] := mybutton.myYes;
          end else if J.Equals('no') then begin
            SetLength(button, bl);
            button[bl - 1] := mybutton.myNo;
          end else if J.Equals('ok') then begin
            SetLength(button, bl);
            button[bl - 1] := mybutton.myOK;
          end else if J.Equals('abort') then begin
            SetLength(button, bl);
            button[bl - 1] := mybutton.myAbort;
          end else if J.Equals('ignore') then begin
            SetLength(button, bl);
            button[bl - 1] := mybutton.myIgnore;
          end else if J.Equals('cancel') then begin
            SetLength(button, bl);
            button[bl - 1] := mybutton.myCancel;
          end else if J.Equals('retry') then begin
            SetLength(button, bl);
            button[bl - 1] := mybutton.myRetry;
          end else begin
            inc(bc);
            SetLength(button, bl);
            button[bl - 1] := mybutton.myCustom;
            SetLength(cbutton, bc);
            cbutton[bc - 1] := VariableToValue(J);
          end;
          if bl >= 4 then break;
        end;
      except
        SetLength(button, 1);
        button[0] := mybutton.myOK;
        SetLength(cbutton, 0);
      end;
      var mb := MyMessageBox(title, context, color, button, cbutton);
      try
        var res := json.GetValue('result').Value;
        try
          PluginVariableDic[res] := inttostr(mb);
        except
          PluginVariableDic.Add(res, inttostr(mb));
        end;
      except end;
    end else if jtype.Equals('inputbox') then begin
      var title := '';
      var context := '';
      var color := 16714250;
      var button: TArray<mybutton> := [];
      var cbutton: TArray<String> := [];
      try title := VariableToValue(json.GetValue('title').Value); except end;
      try context := VariableToValue(json.GetValue('context').Value); except end;
      try 
        var ycolor := json.GetValue('color').Value;
        if ycolor.Equals('warning') then begin
          color := 710655;
        end else if ycolor.Equals('error') then begin
          color := 658175;
        end else if ycolor.Equals('information') then begin
          color := 16714250;
        end else if ycolor.Equals('pass') then begin
          color := 704522;
        end else begin
          color := ConvertHexToColor(ycolor);
        end;
      except end;
      var ib := MyInputBox(title, context, color);
      try
        var res := json.GetValue('result').Value;
        try
          PluginVariableDic[res] := ib;
        except
          PluginVariableDic.Add(res, ib);
        end;
      except end;
    end else if jtype.Equals('multibuttonbox') then begin
      var title := '';
      var color := 16714250;
      var button: TArray<String> := [];
      try title := VariableToValue(json.GetValue('title').Value); except end;
      var jarr := json.GetValue('button') as TJSONArray;
      SetLength(button, jarr.Count);
      try 
        var ycolor := json.GetValue('color').Value;
        if ycolor.Equals('warning') then begin
          color := 710655;
        end else if ycolor.Equals('error') then begin
          color := 658175;
        end else if ycolor.Equals('information') then begin
          color := 16714250;
        end else if ycolor.Equals('pass') then begin
          color := 704522;
        end else begin
          color := ConvertHexToColor(ycolor);
        end;
      except end;
      for var I := 0 to jarr.Count - 1 do begin
        button[I] := jarr[I].Value;
      end;
      var ib := MyMultiButtonBox(title, color, button);
      try
        var res := json.GetValue('result').Value;
        try
          PluginVariableDic[res] := inttostr(ib);
        except
          PluginVariableDic.Add(res, inttostr(ib));
        end;
      except end;
    end else if jtype.Equals('shell') then begin
      var lpexecute := '';
      var lpcommand := '';
      try
        var impl := json.GetValue('implement') as TJSONArray;
        lpexecute := impl[0].Value;
        if impl.Count > 1 then begin
          for var I := 1 to impl.Count - 1 do begin
            lpcommand := Concat(impl[I].Value, ' ');
          end;
        end;
        ShellExecute(Application.Handle, 'open', pchar(lpexecute), pchar(lpcommand), pchar(ExtractFileDir(Application.ExeName)), SW_SHOWNORMAL);
      except end;
    end else if jtype.Equals('copy') then begin
      var value := VariableToValue(json.GetValue('value').Value);
      Clipboard.SetTextBuf(pchar(value));
    end else if jtype.Equals('song') then begin
      var sg := json.GetValue('song') as TJSONObject;
      try
        var suffix := sg.GetValue('suffix').Value;
        try
          var base64 := VariableToValue(sg.GetValue('base64').Value);
          var stm := Base64ToStream(base64);
          if suffix.Equals('mp3') or suffix.Equals('wav') or suffix.Equals('m4a') then begin
            stm.SaveToFile(Concat(LocalTemp, 'LLLauncher\song\tmp.', suffix));
          end else raise Exception.Create('cannot solve music suffix');
          v.FileName := Concat(LocalTemp, 'LLLauncher\song\tmp.', suffix);
          PlayMusic;
        except
          try
            var path := VariableToValue(sg.GetValue('path').Value);
            if suffix.Equals('mp3') or suffix.Equals('wav') or suffix.Equals('m4a') then begin
              if path.IndexOf('.') = 0 then begin
                path := Concat(ExtractFileDir(Application.ExeName), path.Substring(1));
              end;
              v.FileName := path;
              PlayMusic;
            end else raise Exception.Create('cannot solve music suffix');
          except
            var url := VariableToValue(sg.GetValue('url').Value);
            var stm := GetWebStream(url);
            if suffix.Equals('mp3') or suffix.Equals('wav') or suffix.Equals('m4a') then begin
              stm.SaveToFile(Concat(LocalTemp, 'LLLauncher\song\tmp.', suffix));
            end else raise Exception.Create('cannot solve music suffix');
            v.FileName := Concat(LocalTemp, 'LLLauncher\song\tmp.', suffix);
            PlayMusic;
          end;
        end;
      except end;
    end else if jtype.Equals('memory_free') then begin
      MemoryReduct(false);
    end else if jtype.Equals('random') then begin
      randomize;
      var min := strtoint(VariableToValue(json.GetValue('min').Value));
      var max := strtoint(VariableToValue(json.GetValue('max').Value));
      var rd := Random(max - min + 1) + min;
      var res := json.GetValue('result').Value;
      try
        PluginVariableDic[res] := inttostr(rd);
      except
        PluginVariableDic.Add(res, inttostr(rd));
      end;
    end else if jtype.Equals('variable') then begin
      var value := VariableToValue(json.GetValue('value').Value);
      var res := json.GetValue('result').Value;
      var resu := json.GetValue('result').Value;
      var kind := '';
      var vvalue := VariableToValue(value);
      var vres := VariableToValue(res);
      try
        kind := json.GetValue('kind').Value;
      except
        kind := 'set';
      end;
      if kind.Equals('add') then begin
        try
          resu := inttostr(strtoint(vres) + strtoint(vvalue));
        except
          resu := Concat(vres, vvalue);
        end;
      end else if kind.Equals('minus') then begin
        resu := inttostr(strtoint(vres) - strtoint(vvalue));
      end else if kind.Equals('multiply') then begin
        try
          resu := inttostr(strtoint(vres) * strtoint(vvalue));
        except
          for var I := 0 to strtoint(vvalue) - 1 do begin
            resu := Concat(vres, vres);
          end;
        end;
      end else if kind.Equals('divide') then begin
        resu := inttostr(strtoint(vres) div strtoint(vvalue));
      end else if kind.Equals('mod') then begin
        resu := inttostr(strtoint(vres) mod strtoint(vvalue));
      end else if kind.Equals('and') then begin
        resu := inttostr(strtoint(vres) and strtoint(vvalue));
      end else if kind.Equals('or') then begin
        resu := inttostr(strtoint(vres) or strtoint(vvalue));
      end else if kind.Equals('xor') then begin
        resu := inttostr(strtoint(vres) xor strtoint(vvalue));
      end else if kind.Equals('not') then begin
        resu := inttostr(not strtoint(vres));
      end else if kind.Equals('shl') then begin
        resu := inttostr(strtoint(vres) shl strtoint(vvalue));
      end else if kind.Equals('shr') then begin
        resu := inttostr(strtoint(vres) shr strtoint(vvalue));
      end else if kind.Equals('set') then begin
        resu := vvalue;
      end else raise Exception.Create('cannot solve variable kind!');
      try
        PluginVariableDic[res] := resu;
      except
        PluginVariableDic.Add(res, resu);
      end;
    end else if jtype.Equals('open') then begin
      json.RemovePair('type');
      try
        var nme := json.GetValue('plugin_name').Value;
        if nme.IsEmpty then raise Exception.Create('cannot solve plugin name!');
        PluginFormList.Add(TPluginForm.ConstructorPluginForm(nme, json.ToString));
        form_mainform.pagecontrol_all_plugin_part.ActivePage := PluginFormList[PluginFormList.Count].PluginTabSheet;
      except
        var f := '';
        try
          var suf := json.GetValue('suffix').Value;
          if suf.Equals('json') then begin
            try
              f := Base64ToStream(json.GetValue('base64').Value).DataString;
              if f.IsEmpty then begin
                Log.Write('插件加载失败', LOG_ERROR, LOG_PLUGIN);
                exit;
              end;
            except
              try
                f := GetFile(json.GetValue('path').Value);
                if f.IsEmpty then begin
                  Log.Write('插件加载失败', LOG_ERROR, LOG_PLUGIN);
                  exit;
                end;
              except
                f := GetWebText(json.GetValue('url').Value);
                if f.IsEmpty then begin
                  Log.Write('插件加载失败', LOG_ERROR, LOG_PLUGIN);
                  exit;
                end;
              end;
            end;
          end else begin
            Log.Write('插件部分suffix填的不是json，加载失败！', LOG_ERROR, LOG_PLUGIN);
            MyMessagebox(GetLanguage('messagebox_plugin.plugin_suffix_error.caption'), GetLanguage('messagebox_plugin.plugin_suffix_error.text'), MY_ERROR, [mybutton.myOK]);
          end;
        except end;
        try
          var ise := TJSONObject.ParseJSONValue(f) as TJSONObject;
          var nme := ise.GetValue('plugin_name').Value;
          if nme.IsEmpty then raise Exception.Create('Plugin Format Exception');
          PluginFormList.Add(TPluginForm.ConstructorPluginForm(nme, json.ToString));
          form_mainform.pagecontrol_all_plugin_part.ActivePage := PluginFormList[PluginFormList.Count].PluginTabSheet;
        except end;
      end;
      result := true;
      exit;
    end else if jtype.Equals('change') then begin
      try
        var nme := json.GetValue('name').Value;
        var bc := 0;
        var lc := 0;
        var ic := 0;
        var ec := 0;
        var cc := 0;
        var slc := 0;
        var mc := 0;
        var sbc := 0;
        var ao := 0; //控件整体序号
        var lo := 0; //1：button，2：label，3：image，4：edit，5：combobox，6：scrollbar，7：memo，8：speedbutton
        for var I in PluginJSON.GetValue('content') as TJSONArray do begin
          var J := (I as TJSONObject).GetValue('type').Value;
          if J.Equals('button') then begin
            if nme.Equals(PluginButton[bc].Name) then begin lo := 1; break; end;
            inc(bc);
          end else if J.Equals('label') then begin
            if nme.Equals(PluginLabel[lc].Name) then begin lo := 2; break; end;
            inc(lc);
          end else if J.Equals('image') then begin
            if nme.Equals(PluginImage[ic].Name) then begin lo := 3; break; end;
            inc(ic);
          end else if J.Equals('edit') then begin
            if nme.Equals(PluginEdit[ec].Name) then begin lo := 4; break; end;
            inc(ec);
          end else if J.Equals('combobox') then begin
            if nme.Equals(PluginCombobox[cc].Name) then begin lo := 5; break; end;
            inc(cc);
          end else if J.Equals('scrollbar') then begin
            if nme.Equals(PluginScrollBar[slc].Name) then begin lo := 6; break; end;
            inc(slc);
          end else if J.Equals('memo') then begin
            if nme.Equals(PluginMemo[mc].Name) then begin lo := 7; break; end;
            inc(mc);
          end else if J.Equals('speedbutton') then begin
            if nme.Equals(PluginSpeedButton[sbc].Name) then begin lo := 8; break; end;
            inc(sbc);
          end else continue;
          inc(ao);
        end;
        case lo of
          1: begin
            with PluginButton[bc] do begin
              var pos := json.GetValue('position') as TJSONObject;
              try
                Left := strtoint(VariableToValue(pos.GetValue('left').Value));
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).RemovePair('left');
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).AddPair('left', pos.GetValue('left').Value);
              except end;
              try
                Top := strtoint(VariableToValue(pos.GetValue('top').Value));
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).RemovePair('top');
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).AddPair('top', pos.GetValue('top').Value);
              except end;
              try
                Width := strtoint(VariableToValue(pos.GetValue('width').Value));
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).RemovePair('width');
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).AddPair('width', pos.GetValue('width').Value);
              except end;
              try
                Height := strtoint(VariableToValue(pos.GetValue('height').Value));
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).RemovePair('height');
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).AddPair('height', pos.GetValue('height').Value);
              except end;
              try
                Enabled := strtobool(VariableToValue(json.GetValue('enabled').Value));
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('enabled');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('enabled', json.GetValue('enabled').Value);
              except end;
              try
                Visible := strtobool(VariableToValue(json.GetValue('visible').Value));
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('visible');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('visible', json.GetValue('visible').Value);
              except end;
              try
                Caption := VariableToValue(json.GetValue('caption').Value); 
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('caption');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('caption', json.GetValue('caption').Value);
              except end;
              try
                var fc := VariableToValue(json.GetValue('font_color').Value);
                if fc.Equals('blue') then Font.Color := rgb(10, 10, 255)
                else if fc.Equals('red') then Font.Color := rgb(255, 10, 10)
                else if fc.Equals('green') then Font.Color := rgb(10, 255, 10)
                else if fc.Equals('green') then Font.Color := rgb(10, 255, 10)
                else if fc.Equals('purple') then Font.Color := rgb(255, 10, 255)
                else if fc.Equals('yellow') then Font.Color := rgb(255, 255, 10)
                else if fc.Equals('cyan') then Font.Color := rgb(10, 255, 255)
                else if fc.Equals('black') then Font.Color := rgb(10, 10, 10)
                else if fc.Equals('write') then Font.Color := rgb(255, 255, 255)
                else Font.Color := ConvertHexToColor(fc);
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('font_color');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('font_color', json.GetValue('font_color').Value);
              except end;
              try
                Font.Size := strtoint(VariableToValue(json.GetValue('font_size').Value));
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('font_size');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('font_size', json.GetValue('font_size').Value);
              except end;
              try
                Font.Name := VariableToValue(json.GetValue('font_style').Value);
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('font_style');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('font_style', json.GetValue('font_style').Value);
              except end;
              try
                Hint := VariableToValue(json.GetValue('hint').Value); 
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('hint');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('hint', json.GetValue('hint').Value);
              except end;
              try
                json.GetValue('on_click').ToString;
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('on_click');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('on_click', json.GetValue('on_click') as TJSONArray);
              except end;
              try
                json.GetValue('on_mousemove').ToString;
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('on_mousemove');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('on_mousemove', json.GetValue('on_mousemove') as TJSONArray);
              except end;
              try
                json.GetValue('on_mouseleave').ToString;
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('on_mouseleave');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('on_mouseleave', json.GetValue('on_mouseleave') as TJSONArray);
              except end;
            end;
          end;
          2: begin
            with PluginLabel[lc] do begin
              var pos := json.GetValue('position') as TJSONObject;
              try
                Left := strtoint(VariableToValue(pos.GetValue('left').Value));
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).RemovePair('left');
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).AddPair('left', pos.GetValue('left').Value);
              except end;
              try
                Top := strtoint(VariableToValue(pos.GetValue('top').Value));
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).RemovePair('top');
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).AddPair('top', pos.GetValue('top').Value);
              except end;
              try
                Width := strtoint(VariableToValue(pos.GetValue('width').Value));
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).RemovePair('width');
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).AddPair('width', pos.GetValue('width').Value);
              except end;
              try
                Height := strtoint(VariableToValue(pos.GetValue('height').Value));
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).RemovePair('height');
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).AddPair('height', pos.GetValue('height').Value);
              except end;
              try
                Enabled := strtobool(VariableToValue(json.GetValue('enabled').Value));
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('enabled');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('enabled', json.GetValue('enabled').Value);
              except end;
              try
                Visible := strtobool(VariableToValue(json.GetValue('visible').Value));
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('visible');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('visible', json.GetValue('visible').Value);
              except end;
              try
                Caption := VariableToValue(json.GetValue('caption').Value); 
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('caption');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('caption', json.GetValue('caption').Value);
              except end;
              try
                var fc := VariableToValue(json.GetValue('font_color').Value);
                if fc.Equals('blue') then Font.Color := rgb(10, 10, 255)
                else if fc.Equals('red') then Font.Color := rgb(255, 10, 10)
                else if fc.Equals('green') then Font.Color := rgb(10, 255, 10)
                else if fc.Equals('green') then Font.Color := rgb(10, 255, 10)
                else if fc.Equals('purple') then Font.Color := rgb(255, 10, 255)
                else if fc.Equals('yellow') then Font.Color := rgb(255, 255, 10)
                else if fc.Equals('cyan') then Font.Color := rgb(10, 255, 255)
                else if fc.Equals('black') then Font.Color := rgb(10, 10, 10)
                else if fc.Equals('write') then Font.Color := rgb(255, 255, 255)
                else Font.Color := ConvertHexToColor(fc);
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('font_color');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('font_color', json.GetValue('font_color').Value);
              except end;
              try
                var fc := VariableToValue(json.GetValue('back_color').Value);
                if fc.Equals('blue') then Color := rgb(10, 10, 255)
                else if fc.Equals('red') then Color := rgb(255, 10, 10)
                else if fc.Equals('green') then Color := rgb(10, 255, 10)
                else if fc.Equals('green') then Color := rgb(10, 255, 10)
                else if fc.Equals('purple') then Color := rgb(255, 10, 255)
                else if fc.Equals('yellow') then Color := rgb(255, 255, 10)
                else if fc.Equals('cyan') then Color := rgb(10, 255, 255)
                else if fc.Equals('black') then Color := rgb(10, 10, 10)
                else if fc.Equals('write') then Color := rgb(255, 255, 255)
                else Color := ConvertHexToColor(fc);
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('back_color');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('back_color', json.GetValue('back_color').Value);
              except end;
              try
                Font.Size := strtoint(VariableToValue(json.GetValue('font_size').Value));
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('font_size');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('font_size', json.GetValue('font_size').Value);
              except end;
              try
                Font.Name := VariableToValue(json.GetValue('font_style').Value);
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('font_style');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('font_style', json.GetValue('font_style').Value);
              except end;
              try
                Hint := VariableToValue(json.GetValue('hint').Value); 
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('hint');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('hint', json.GetValue('hint').Value);
              except end;
              try
                json.GetValue('on_click').ToString;
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('on_click');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('on_click', json.GetValue('on_click') as TJSONArray);
              except end;
              try
                json.GetValue('on_mousemove').ToString;
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('on_mousemove');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('on_mousemove', json.GetValue('on_mousemove') as TJSONArray);
              except end;
              try
                json.GetValue('on_mouseleave').ToString;
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('on_mouseleave');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('on_mouseleave', json.GetValue('on_mouseleave') as TJSONArray);
              except end;
            end;
          end;
          3: begin
            with PluginImage[ic] do begin
              var pos := json.GetValue('position') as TJSONObject;
              try
                Left := strtoint(VariableToValue(pos.GetValue('left').Value));
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).RemovePair('left');
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).AddPair('left', pos.GetValue('left').Value);
              except end;
              try
                Top := strtoint(VariableToValue(pos.GetValue('top').Value));
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).RemovePair('top');
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).AddPair('top', pos.GetValue('top').Value);
              except end;
              try
                Width := strtoint(VariableToValue(pos.GetValue('width').Value));
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).RemovePair('width');
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).AddPair('width', pos.GetValue('width').Value);
              except end;
              try
                Height := strtoint(VariableToValue(pos.GetValue('height').Value));
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).RemovePair('height');
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).AddPair('height', pos.GetValue('height').Value);
              except end;
              try
                Enabled := strtobool(VariableToValue(json.GetValue('enabled').Value));
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('enabled');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('enabled', json.GetValue('enabled').Value);
              except end;
              try
                Visible := strtobool(VariableToValue(json.GetValue('visible').Value));
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('visible');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('visible', json.GetValue('visible').Value);
              except end;
              try
                Hint := VariableToValue(json.GetValue('hint').Value); 
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('hint');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('hint', json.GetValue('hint').Value);
              except end;
              try
                var imgc := json.GetValue('image') as TJSONObject;
                var s := imgc.GetValue('suffix').Value;
                try
                  var f := imgc.GetValue('base64').Value;
                  if s.Equals('png') then begin
                    var png := TPngImage.Create;
                    try
                      png.LoadFromStream(Base64ToStream(f));
                      Picture.Assign(png);
                    except end;
                    png.Free;
                  end else if s.Equals('jpg') or s.Equals('jpeg') then begin
                    var jpg := TJpegImage.Create;
                    try
                      jpg.LoadFromStream(Base64ToStream(f));
                      Picture.Assign(jpg);
                    except end;
                    jpg.Free;
                  end else if s.Equals('bmp') then begin
                    try
                      Picture.Bitmap.LoadFromStream(Base64ToStream(f));
                    except end;
                  end;
                except
                  try
                    var f := imgc.GetValue('path').Value;
                    if f.IndexOf('.') = 0 then begin
                      f := Concat(ExtractFileDir(Application.ExeName), f.Substring(1));
                    end;
                    if FileExists(f) then begin
                      if s.Equals('png') then begin
                        var png := TPngImage.Create;
                        try
                          png.LoadFromFile(f);
                          Picture.Assign(png);
                        except end;
                        png.Free;
                      end else if s.Equals('jpg') or s.Equals('jpeg') then begin
                        var jpg := TJpegImage.Create;
                        try
                          jpg.LoadFromFile(f);
                          Picture.Assign(jpg);
                        except end;
                        jpg.Free;
                      end else if s.Equals('bmp') then begin
                        try
                          Picture.Bitmap.LoadFromFile(f);
                        except end;
                      end;
                    end;
                  except
                    var f := imgc.GetValue('url').Value;
                    var g := GetWebStream(f);
                    if s.Equals('png') then begin
                      var png := TPngImage.Create;
                      try
                        png.LoadFromStream(g);
                        Picture.Assign(png);
                      except end;
                      png.Free;
                    end else if s.Equals('jpg') or s.Equals('jpeg') then begin
                      var jpg := TJpegImage.Create;
                      try
                        jpg.LoadFromStream(g);
                        Picture.Assign(jpg);
                      except end;
                      jpg.Free;
                    end else if s.Equals('bmp') then begin
                      try
                        Picture.Bitmap.LoadFromStream(g);
                      except end;
                    end;
                  end;
                end;
              except end;
              try
                json.GetValue('on_click').ToString;
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('on_click');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('on_click', json.GetValue('on_click') as TJSONArray);
              except end;
              try
                json.GetValue('on_mousemove').ToString;
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('on_mousemove');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('on_mousemove', json.GetValue('on_mousemove') as TJSONArray);
              except end;
              try
                json.GetValue('on_mouseleave').ToString;
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('on_mouseleave');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('on_mouseleave', json.GetValue('on_mouseleave') as TJSONArray);
              except end;
            end;
          end;
          4: begin
            with PluginEdit[ec] do begin
              var pos := json.GetValue('position') as TJSONObject;
              try
                Left := strtoint(VariableToValue(pos.GetValue('left').Value));
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).RemovePair('left');
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).AddPair('left', pos.GetValue('left').Value);
              except end;
              try
                Top := strtoint(VariableToValue(pos.GetValue('top').Value));
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).RemovePair('top');
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).AddPair('top', pos.GetValue('top').Value);
              except end;
              try
                Width := strtoint(VariableToValue(pos.GetValue('width').Value));
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).RemovePair('width');
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).AddPair('width', pos.GetValue('width').Value);
              except end;
              try
                Height := strtoint(VariableToValue(pos.GetValue('height').Value));
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).RemovePair('height');
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).AddPair('height', pos.GetValue('height').Value);
              except end;
              try
                Enabled := strtobool(VariableToValue(json.GetValue('enabled').Value));
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('enabled');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('enabled', json.GetValue('enabled').Value);
              except end;
              try
                Visible := strtobool(VariableToValue(json.GetValue('visible').Value));
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('visible');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('visible', json.GetValue('visible').Value);
              except end;
              try
                Hint := VariableToValue(json.GetValue('hint').Value); 
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('hint');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('hint', json.GetValue('hint').Value);
              except end;
              try
                var fc := VariableToValue(json.GetValue('font_color').Value);
                if fc.Equals('blue') then Font.Color := rgb(10, 10, 255)
                else if fc.Equals('red') then Font.Color := rgb(255, 10, 10)
                else if fc.Equals('green') then Font.Color := rgb(10, 255, 10)
                else if fc.Equals('green') then Font.Color := rgb(10, 255, 10)
                else if fc.Equals('purple') then Font.Color := rgb(255, 10, 255)
                else if fc.Equals('yellow') then Font.Color := rgb(255, 255, 10)
                else if fc.Equals('cyan') then Font.Color := rgb(10, 255, 255)
                else if fc.Equals('black') then Font.Color := rgb(10, 10, 10)
                else if fc.Equals('write') then Font.Color := rgb(255, 255, 255)
                else Font.Color := ConvertHexToColor(fc);
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('font_color');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('font_color', json.GetValue('font_color').Value);
              except end;
              try
                Font.Size := strtoint(VariableToValue(json.GetValue('font_size').Value));
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('font_size');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('font_size', json.GetValue('font_size').Value);
              except end;
              try
                Font.Name := VariableToValue(json.GetValue('font_style').Value);
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('font_style');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('font_style', json.GetValue('font_style').Value);
              except end;
              try
                TextHint := VariableToValue(json.GetValue('texthint').Value); 
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('texthint');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('texthint', json.GetValue('texthint').Value);
              except end;
              try
                Text := VariableToValue(json.GetValue('text').Value); 
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('text');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('text', json.GetValue('text').Value);
              except end;
              try
                ReadOnly := strtobool(VariableToValue(json.GetValue('readonly').Value));
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('readonly');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('readonly', json.GetValue('readonly').Value);
              except end;
              try
                json.GetValue('on_click').ToString;
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('on_click');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('on_click', json.GetValue('on_click') as TJSONArray);
              except end;
              try
                json.GetValue('on_mousemove').ToString;
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('on_mousemove');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('on_mousemove', json.GetValue('on_mousemove') as TJSONArray);
              except end;
              try
                json.GetValue('on_mouseleave').ToString;
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('on_mouseleave');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('on_mouseleave', json.GetValue('on_mouseleave') as TJSONArray);
              except end;
              try
                json.GetValue('on_change').ToString;
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('on_change');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('on_change', json.GetValue('on_change') as TJSONArray);
              except end;
            end;
          end;
          5: begin
            with PluginCombobox[cc] do begin
              var pos := json.GetValue('position') as TJSONObject;
              try
                Left := strtoint(VariableToValue(pos.GetValue('left').Value));
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).RemovePair('left');
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).AddPair('left', pos.GetValue('left').Value);
              except end;
              try
                Top := strtoint(VariableToValue(pos.GetValue('top').Value));
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).RemovePair('top');
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).AddPair('top', pos.GetValue('top').Value);
              except end;
              try
                Width := strtoint(VariableToValue(pos.GetValue('width').Value));
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).RemovePair('width');
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).AddPair('width', pos.GetValue('width').Value);
              except end;
              try
                Height := strtoint(VariableToValue(pos.GetValue('height').Value));
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).RemovePair('height');
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).AddPair('height', pos.GetValue('height').Value);
              except end;
              try
                Enabled := strtobool(VariableToValue(json.GetValue('enabled').Value));
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('enabled');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('enabled', json.GetValue('enabled').Value);
              except end;
              try
                Visible := strtobool(VariableToValue(json.GetValue('visible').Value));
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('visible');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('visible', json.GetValue('visible').Value);
              except end;
              try
                Hint := VariableToValue(json.GetValue('hint').Value); 
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('hint');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('hint', json.GetValue('hint').Value);
              except end;
              try
                var fc := VariableToValue(json.GetValue('font_color').Value);
                if fc.Equals('blue') then Font.Color := rgb(10, 10, 255)
                else if fc.Equals('red') then Font.Color := rgb(255, 10, 10)
                else if fc.Equals('green') then Font.Color := rgb(10, 255, 10)
                else if fc.Equals('green') then Font.Color := rgb(10, 255, 10)
                else if fc.Equals('purple') then Font.Color := rgb(255, 10, 255)
                else if fc.Equals('yellow') then Font.Color := rgb(255, 255, 10)
                else if fc.Equals('cyan') then Font.Color := rgb(10, 255, 255)
                else if fc.Equals('black') then Font.Color := rgb(10, 10, 10)
                else if fc.Equals('write') then Font.Color := rgb(255, 255, 255)
                else Font.Color := ConvertHexToColor(fc);
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('font_color');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('font_color', json.GetValue('font_color').Value);
              except end;
              try
                Font.Size := strtoint(VariableToValue(json.GetValue('font_size').Value));
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('font_size');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('font_size', json.GetValue('font_size').Value);
              except end;
              try
                Font.Name := VariableToValue(json.GetValue('font_style').Value);
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('font_style');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('font_style', json.GetValue('font_style').Value);
              except end;
              try
                var lne := json.GetValue('items') as TJSONArray;
                for var l in lne do begin
                  Items.Add(VariableToValue(l.Value));
                end;
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('items');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('items', json.GetValue('items') as TJSONArray);
              except end;
              try
                ItemIndex := strtoint(VariableToValue(json.GetValue('itemindex').Value));
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('itemindex');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('itemindex', json.GetValue('itemindex').Value);
              except end;
              try
                json.GetValue('on_dropdown').ToString;
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('on_dropdown');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('on_dropdown', json.GetValue('on_dropdown') as TJSONArray);
              except end;
              try
                json.GetValue('on_select').ToString;
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('on_select');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('on_select', json.GetValue('on_select') as TJSONArray);
              except end;
            end;
          end;
          6: begin
            with PluginScrollBar[slc] do begin
              var pos := json.GetValue('position') as TJSONObject;
              try
                Left := strtoint(VariableToValue(pos.GetValue('left').Value));
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).RemovePair('left');
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).AddPair('left', pos.GetValue('left').Value);
              except end;
              try
                Top := strtoint(VariableToValue(pos.GetValue('top').Value));
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).RemovePair('top');
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).AddPair('top', pos.GetValue('top').Value);
              except end;
              try
                Width := strtoint(VariableToValue(pos.GetValue('width').Value));
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).RemovePair('width');
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).AddPair('width', pos.GetValue('width').Value);
              except end;
              try
                Height := strtoint(VariableToValue(pos.GetValue('height').Value));
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).RemovePair('height');
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).AddPair('height', pos.GetValue('height').Value);
              except end;
              try
                Enabled := strtobool(VariableToValue(json.GetValue('enabled').Value));
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('enabled');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('enabled', json.GetValue('enabled').Value);
              except end;
              try
                Visible := strtobool(VariableToValue(json.GetValue('visible').Value));
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('visible');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('visible', json.GetValue('visible').Value);
              except end;
              try
                Hint := VariableToValue(json.GetValue('hint').Value); 
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('hint');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('hint', json.GetValue('hint').Value);
              except end;
              try
                Max := strtoint(VariableToValue(json.GetValue('max').Value));
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('max');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('max', json.GetValue('max').Value);
              except end;
              try
                Min := strtoint(VariableToValue(json.GetValue('min').Value));
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('min');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('min', json.GetValue('min').Value);
              except end;
              try
                Position := strtoint(VariableToValue(json.GetValue('current').Value));
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('current');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('current', json.GetValue('current').Value);
              except end;
              try
                var kd := VariableToValue(json.GetValue('kind').Value);
                if kd.Equals('vert') then Kind := sbVertical
                else if kd.Equals('horz') then Kind := sbHorizontal
                else raise Exception.Create('cannot solve Kind value!');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('kind');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('kind', json.GetValue('kind').Value);
              except end;
              try
                json.GetValue('on_scroll').ToString;
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('on_scroll');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('on_scroll', json.GetValue('on_scroll') as TJSONArray);
              except end;
            end;
          end;
          7: begin
            with PluginMemo[mc] do begin
              var pos := json.GetValue('position') as TJSONObject;
              try
                Left := strtoint(VariableToValue(pos.GetValue('left').Value));
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).RemovePair('left');
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).AddPair('left', pos.GetValue('left').Value);
              except end;
              try
                Top := strtoint(VariableToValue(pos.GetValue('top').Value));
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).RemovePair('top');
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).AddPair('top', pos.GetValue('top').Value);
              except end;
              try
                Width := strtoint(VariableToValue(pos.GetValue('width').Value));
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).RemovePair('width');
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).AddPair('width', pos.GetValue('width').Value);
              except end;
              try
                Height := strtoint(VariableToValue(pos.GetValue('height').Value));
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).RemovePair('height');
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).AddPair('height', pos.GetValue('height').Value);
              except end;
              try
                Enabled := strtobool(VariableToValue(json.GetValue('enabled').Value));
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('enabled');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('enabled', json.GetValue('enabled').Value);
              except end;
              try
                Visible := strtobool(VariableToValue(json.GetValue('visible').Value));
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('visible');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('visible', json.GetValue('visible').Value);
              except end;
              try
                Hint := VariableToValue(json.GetValue('hint').Value); 
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('hint');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('hint', json.GetValue('hint').Value);
              except end;
              try
                var fc := VariableToValue(json.GetValue('font_color').Value);
                if fc.Equals('blue') then Font.Color := rgb(10, 10, 255)
                else if fc.Equals('red') then Font.Color := rgb(255, 10, 10)
                else if fc.Equals('green') then Font.Color := rgb(10, 255, 10)
                else if fc.Equals('green') then Font.Color := rgb(10, 255, 10)
                else if fc.Equals('purple') then Font.Color := rgb(255, 10, 255)
                else if fc.Equals('yellow') then Font.Color := rgb(255, 255, 10)
                else if fc.Equals('cyan') then Font.Color := rgb(10, 255, 255)
                else if fc.Equals('black') then Font.Color := rgb(10, 10, 10)
                else if fc.Equals('write') then Font.Color := rgb(255, 255, 255)
                else Font.Color := ConvertHexToColor(fc);
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('font_color');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('font_color', json.GetValue('font_color').Value);
              except end;
              try
                Font.Size := strtoint(VariableToValue(json.GetValue('font_size').Value));
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('font_size');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('font_size', json.GetValue('font_size').Value);
              except end;
              try
                Font.Name := VariableToValue(json.GetValue('font_style').Value);
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('font_style');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('font_style', json.GetValue('font_style').Value);
              except end;
              try
                var lne := json.GetValue('lines') as TJSONArray;
                for var l in lne do begin
                  Lines.Add(VariableToValue(l.Value));
                end;
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('lines');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('lines', json.GetValue('lines') as TJSONArray);
              except end;
              try
                ReadOnly := strtobool(VariableToValue(json.GetValue('readonly').Value));
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('readonly');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('readonly', json.GetValue('readonly').Value);
              except end;
              try
                json.GetValue('on_click').ToString;
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('on_click');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('on_click', json.GetValue('on_click') as TJSONArray);
              except end;
              try
                json.GetValue('on_mousemove').ToString;
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('on_mousemove');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('on_mousemove', json.GetValue('on_mousemove') as TJSONArray);
              except end;
              try
                json.GetValue('on_mouseleave').ToString;
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('on_mouseleave');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('on_mouseleave', json.GetValue('on_mouseleave') as TJSONArray);
              except end;
              try
                json.GetValue('on_change').ToString;
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('on_change');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('on_change', json.GetValue('on_change') as TJSONArray);
              except end;
            end;
          end;
          8: begin
            with PluginSpeedButton[sbc] do begin
              var pos := json.GetValue('position') as TJSONObject;
              try
                Left := strtoint(VariableToValue(pos.GetValue('left').Value));
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).RemovePair('left');
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).AddPair('left', pos.GetValue('left').Value);
              except end;
              try
                Top := strtoint(VariableToValue(pos.GetValue('top').Value));
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).RemovePair('top');
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).AddPair('top', pos.GetValue('top').Value);
              except end;
              try
                Width := strtoint(VariableToValue(pos.GetValue('width').Value));
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).RemovePair('width');
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).AddPair('width', pos.GetValue('width').Value);
              except end;
              try
                Height := strtoint(VariableToValue(pos.GetValue('height').Value));
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).RemovePair('height');
                (((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).GetValue('position') as TJSONObject).AddPair('height', pos.GetValue('height').Value);
              except end;
              try
                Enabled := strtobool(VariableToValue(json.GetValue('enabled').Value));
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('enabled');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('enabled', json.GetValue('enabled').Value);
              except end;
              try
                Visible := strtobool(VariableToValue(json.GetValue('visible').Value));
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('visible');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('visible', json.GetValue('visible').Value);
              except end;
              try
                Caption := VariableToValue(json.GetValue('caption').Value); 
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('caption');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('caption', json.GetValue('caption').Value);
              except end;
              try
                var imgc := json.GetValue('image') as TJSONObject;
                var s := imgc.GetValue('suffix').Value;
                try
                  var f := imgc.GetValue('base64').Value;
                  if s.Equals('bmp') then begin
                    try
                      Glyph.LoadFromStream(Base64ToStream(f));
                    except end;
                  end;
                except
                  try
                    var f := imgc.GetValue('path').Value;
                    if f.IndexOf('.') = 0 then begin
                      f := Concat(ExtractFileDir(Application.ExeName), f.Substring(1));
                    end;
                    if FileExists(f) then begin
                      if s.Equals('bmp') then begin
                        try
                          Glyph.LoadFromFile(f);
                        except end;
                      end;
                    end;
                  except
                    var f := imgc.GetValue('url').Value;
                    var g := GetWebStream(f);
                    if s.Equals('bmp') then begin
                      try
                        Glyph.LoadFromStream(g);
                      except end;
                    end;
                  end;
                end;
              except end;
              try
                var lor := json.GetValue('layout').Value;
                if lor.Equals('left') then Layout := blGlyphLeft
                else if lor.Equals('right') then Layout := blGlyphRight
                else if lor.Equals('top') then Layout := blGlyphTop
                else if lor.Equals('bottom') then Layout := blGlyphBottom
                else raise Exception.Create('cannot solve layout value!');
              except end;
              try
                var fc := VariableToValue(json.GetValue('font_color').Value);
                if fc.Equals('blue') then Font.Color := rgb(10, 10, 255)
                else if fc.Equals('red') then Font.Color := rgb(255, 10, 10)
                else if fc.Equals('green') then Font.Color := rgb(10, 255, 10)
                else if fc.Equals('green') then Font.Color := rgb(10, 255, 10)
                else if fc.Equals('purple') then Font.Color := rgb(255, 10, 255)
                else if fc.Equals('yellow') then Font.Color := rgb(255, 255, 10)
                else if fc.Equals('cyan') then Font.Color := rgb(10, 255, 255)
                else if fc.Equals('black') then Font.Color := rgb(10, 10, 10)
                else if fc.Equals('write') then Font.Color := rgb(255, 255, 255)
                else Font.Color := ConvertHexToColor(fc);
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('font_color');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('font_color', json.GetValue('font_color').Value);
              except end;
              try
                Font.Size := strtoint(VariableToValue(json.GetValue('font_size').Value));
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('font_size');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('font_size', json.GetValue('font_size').Value);
              except end;
              try
                Font.Name := VariableToValue(json.GetValue('font_style').Value);
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('font_style');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('font_style', json.GetValue('font_style').Value);
              except end;
              try
                Hint := VariableToValue(json.GetValue('hint').Value); 
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('hint');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('hint', json.GetValue('hint').Value);
              except end;
              try
                json.GetValue('on_click').ToString;
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('on_click');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('on_click', json.GetValue('on_click') as TJSONArray);
              except end;
              try
                json.GetValue('on_mousemove').ToString;
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('on_mousemove');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('on_mousemove', json.GetValue('on_mousemove') as TJSONArray);
              except end;
              try
                json.GetValue('on_mouseleave').ToString;
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).RemovePair('on_mouseleave');
                ((PluginJSON.GetValue('content') as TJSONArray)[ao] as TJSONObject).AddPair('on_mouseleave', json.GetValue('on_mouseleave') as TJSONArray);
              except end;
            end;
          end;
          else raise Exception.Create('cannot find any control!');
        end;
      except end;
    end;
  end;
end;
//控件点击事件
procedure TPluginForm.PluginControlClick(Sender: TObject);
begin
  var nme: String := (Sender as TControl).Name;
  var cont := PluginJSON.GetValue('content') as TJSONArray;
  for var I in cont do begin
    var J := I as TJSONObject;
    if J.GetValue('name').Value.Equals(nme) then begin
      var oc := J.GetValue('on_click') as TJSONArray;
      try
        for var K in oc do begin
          var L := K.Clone as TJSONObject;
          if JudgeEvent(L) then exit;
        end;
      except end;
    end;
  end;
end;
//控件鼠标移动事件
procedure TPluginForm.PluginControlMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
begin
  //
end;
//控件鼠标离开事件
procedure TPluginForm.PluginControlMouseLeave(Sender: TObject);
begin
  //
end;
//控件改变事件
procedure TPluginForm.PluginControlChange(Sender: TObject);
begin
  //
end;
procedure TPluginForm.PluginControlScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  //
end;
//创建插件窗口
constructor TPluginForm.ConstructorPluginForm(name, json: String);
begin
  if not DirectoryExists(Concat(LocalTemp, 'LLLauncher\song')) then ForceDirectories(Concat(LocalTemp, 'LLLauncher\song'));
  PluginJSON := TJSONObject.ParseJSONValue(json) as TJSONObject;
  PluginVariableDic := TDictionary<string, string>.Create;
  PluginButton := TList<TBitBtn>.Create;
  PluginLabel := TList<TLabel>.Create;
  PluginEdit := TList<TEdit>.Create;
  PluginMemo := TList<TMemo>.Create;
  PluginCombobox := TList<TCombobox>.Create;
  PluginScrollBar := TList<TScrollBar>.Create;
  PluginSpeedButton := TList<TSpeedButton>.Create;
  PluginImage := TList<TImage>.Create;
  PluginTabSheet := TTabSheet.Create(form_mainform.pagecontrol_all_plugin_part);
  PluginTabSheet.Parent := form_mainform.pagecontrol_all_plugin_part;
  PluginTabSheet.PageControl := form_mainform.pagecontrol_all_plugin_part;
  try
    PluginTabSheet.Name := PluginJSON.GetValue('plugin_name').Value;
  except
    MyMessagebox(GetLanguage('messagebox_plugin.lose_form_name.caption'), GetLanguage('messagebox_plugin.lose_form_name.text'), MY_ERROR, [mybutton.myOK]);
    exit;
  end;
  var desc := '';
  var upt := '';
  var ver := '';
  var atr := '';
  var cpy := '';
  var cap := '';
  try desc := PluginJSON.GetValue('plugin_description').Value; except end;
  try upt := PluginJSON.GetValue('plugin_update_time').Value; except end;
  try ver := PluginJSON.GetValue('plugin_version').Value; except end;
  try atr := PluginJSON.GetValue('plugin_author').Value; except end;
  try cpy := PluginJSON.GetValue('plugin_copyright').Value; except end;
  try cap := PluginJSON.GetValue('form_caption').Value; except end;
  var all := GetLanguage('plugin_tabsheet.get_plugin_info.hint')
                        .Replace('${plugin_caption}', cap)
                        .Replace('${plugin_version}', ver)
                        .Replace('${plugin_author}', atr)
                        .Replace('${plugin_update_time}', upt)
                        .Replace('${plugin_copyright}', cpy)
                        .Replace('${plugin_description}', desc);
  PluginTabSheet.Caption := cap;
  PluginScrollBox := TScrollBox.Create(PluginTabSheet);
  with PluginScrollBox do begin
    Name := 'PluginScrollBox';
    Parent := PluginTabSheet;
    ParentColor := false;
    ParentCtl3D := false;
    Ctl3D := true;
    Color := clBtnFace;
    Align := alClient;
    ShowHint := true;
    Hint := all;
    HorzScrollBar.Tracking := true;
    VertScrollBar.Tracking := true;
    OnMouseWheel := PluginScrollBoxMouseWheel;
  end;
  var content := PluginJSON.GetValue('content') as TJSONArray;
  for var I in content do begin
    var obj := I as TJSONObject;
    if obj.GetValue('type').Value.Equals('button') then begin
      PluginButton.Add(TBitBtn.Create(PluginScrollBox));
      with PluginButton[PluginButton.Count - 1] do begin
        Parent := PluginScrollBox;
        Name := obj.GetValue('name').Value;
        ShowHint := true;
        WordWrap := true;
        var pos := obj.GetValue('position') as TJSONObject;
        Left := strtoint(pos.GetValue('left').Value);
        Top := strtoint(pos.GetValue('top').Value);
        Width := strtoint(pos.GetValue('width').Value);
        Height := strtoint(pos.GetValue('height').Value);
        try Enabled := strtobool(obj.GetValue('enabled').Value); except Enabled := true; end;
        try Visible := strtobool(obj.GetValue('visible').Value); except Visible := true; end;
        try Caption := obj.GetValue('caption').Value; except Caption := ''; end;
        try 
          var fc := obj.GetValue('font_color').Value;
          if fc.Equals('blue') then Font.Color := rgb(10, 10, 255)
          else if fc.Equals('red') then Font.Color := rgb(255, 10, 10)
          else if fc.Equals('green') then Font.Color := rgb(10, 255, 10)
          else if fc.Equals('green') then Font.Color := rgb(10, 255, 10)
          else if fc.Equals('purple') then Font.Color := rgb(255, 10, 255)
          else if fc.Equals('yellow') then Font.Color := rgb(255, 255, 10)
          else if fc.Equals('cyan') then Font.Color := rgb(10, 255, 255)
          else if fc.Equals('black') then Font.Color := rgb(10, 10, 10)
          else if fc.Equals('write') then Font.Color := rgb(255, 255, 255)
          else Font.Color := ConvertHexToColor(fc);
        except Font.Color := 0; end;
        try Font.Size := strtoint(obj.GetValue('font_size').Value); except Font.Size := 9 end;
        try Font.Name := obj.GetValue('font_style').Value; except Font.Name := '宋体' end;
        try Hint := obj.GetValue('hint').Value; except Hint := '' end;
        OnClick := PluginControlClick;
        OnMouseMove := PluginControlMouseMove;
        OnMouseLeave := PluginControlMouseLeave;
      end;
    end else if obj.GetValue('type').Value.Equals('label') then begin
      PluginLabel.Add(TLabel.Create(PluginScrollBox));
      with PluginLabel[PluginLabel.Count - 1] do begin
        Parent := PluginScrollBox;
        Name := obj.GetValue('name').Value;
        ShowHint := true;
        WordWrap := true;
        AutoSize := false;
        var pos := obj.GetValue('position') as TJSONObject;
        Left := strtoint(pos.GetValue('left').Value);
        Top := strtoint(pos.GetValue('top').Value);
        Width := strtoint(pos.GetValue('width').Value);
        Height := strtoint(pos.GetValue('height').Value);
        Transparent := false;
        try Enabled := strtobool(obj.GetValue('enabled').Value); except Enabled := true; end;
        try Visible := strtobool(obj.GetValue('visible').Value); except Visible := true; end;
        try Caption := obj.GetValue('caption').Value; except Caption := ''; end;
        try 
          var fc := obj.GetValue('font_color').Value;
          if fc.Equals('blue') then Font.Color := rgb(10, 10, 255)
          else if fc.Equals('red') then Font.Color := rgb(255, 10, 10)
          else if fc.Equals('green') then Font.Color := rgb(10, 255, 10)
          else if fc.Equals('green') then Font.Color := rgb(10, 255, 10)
          else if fc.Equals('purple') then Font.Color := rgb(255, 10, 255)
          else if fc.Equals('yellow') then Font.Color := rgb(255, 255, 10)
          else if fc.Equals('cyan') then Font.Color := rgb(10, 255, 255)
          else if fc.Equals('black') then Font.Color := rgb(10, 10, 10)
          else if fc.Equals('write') then Font.Color := rgb(255, 255, 255)
          else Font.Color := ConvertHexToColor(fc);
        except Font.Color := 0; end;
        try Font.Size := strtoint(obj.GetValue('font_size').Value); except Font.Size := 9 end;
        try Font.Name := obj.GetValue('font_style').Value; except Font.Name := '宋体' end;
        try Hint := obj.GetValue('hint').Value; except Hint := '' end;
        try 
          var fc := obj.GetValue('back_color').Value;
          if fc.Equals('blue') then Color := rgb(10, 10, 255)
          else if fc.Equals('red') then Color := rgb(255, 10, 10)
          else if fc.Equals('green') then Color := rgb(10, 255, 10)
          else if fc.Equals('green') then Color := rgb(10, 255, 10)
          else if fc.Equals('purple') then Color := rgb(255, 10, 255)
          else if fc.Equals('yellow') then Color := rgb(255, 255, 10)
          else if fc.Equals('cyan') then Color := rgb(10, 255, 255)
          else if fc.Equals('black') then Color := rgb(10, 10, 10)
          else if fc.Equals('write') then Color := rgb(255, 255, 255)
          else Color := ConvertHexToColor(fc);
        except Color := rgb(240, 240, 240); end;
        OnClick := PluginControlClick;
        OnMouseMove := PluginControlMouseMove;
        OnMouseLeave := PluginControlMouseLeave;
      end;
    end else if obj.GetValue('type').Value.Equals('image') then begin
      PluginImage.Add(TImage.Create(PluginScrollBox));
      with PluginImage[PluginImage.Count - 1] do begin
        Parent := PluginScrollBox;
        Name := obj.GetValue('name').Value;
        ShowHint := true;
        Stretch := true;
        var pos := obj.GetValue('position') as TJSONObject;
        Left := strtoint(pos.GetValue('left').Value);
        Top := strtoint(pos.GetValue('top').Value);
        Width := strtoint(pos.GetValue('width').Value);
        Height := strtoint(pos.GetValue('height').Value);
        try Hint := obj.GetValue('hint').Value; except Hint := '' end;
        try Enabled := strtobool(obj.GetValue('enabled').Value); except Enabled := true; end;
        try Visible := strtobool(obj.GetValue('visible').Value); except Visible := true; end;
        try
          var imgc := obj.GetValue('image') as TJSONObject;
          var s := imgc.GetValue('suffix').Value;
          try
            var f := imgc.GetValue('base64').Value;
            if s.Equals('png') then begin
              var png := TPngImage.Create;
              try
                png.LoadFromStream(Base64ToStream(f));
                Picture.Assign(png);
              except
                Picture := nil;
              end;
              png.Free;
            end else if s.Equals('jpg') or s.Equals('jpeg') then begin
              var jpg := TJpegImage.Create;
              try
                jpg.LoadFromStream(Base64ToStream(f));
                Picture.Assign(jpg);
              except
                Picture := nil;
              end;
              jpg.Free;
            end else if s.Equals('bmp') then begin
              try
                Picture.Bitmap.LoadFromStream(Base64ToStream(f));
              except
                Picture := nil;
              end;
            end else Picture := nil;
          except
            try
              var f := imgc.GetValue('path').Value;
              if f.IndexOf('.') = 0 then begin
                f := Concat(ExtractFileDir(Application.ExeName), f.Substring(1));
              end;
              if FileExists(f) then begin
                if s.Equals('png') then begin
                  var png := TPngImage.Create;
                  try
                    png.LoadFromFile(f);
                    Picture.Assign(png);
                  except
                    Picture := nil;
                  end;
                  png.Free;
                end else if s.Equals('jpg') or s.Equals('jpeg') then begin
                  var jpg := TJpegImage.Create;
                  try
                    jpg.LoadFromFile(f);
                    Picture.Assign(jpg);
                  except
                    Picture := nil;
                  end;
                  jpg.Free;
                end else if s.Equals('bmp') then begin
                  try
                    Picture.Bitmap.LoadFromFile(f);
                  except
                    Picture := nil;
                  end;
                end else Picture := nil;
              end else Picture := nil;
            except
              try
                var f := imgc.GetValue('url').Value;
                var g := GetWebStream(f);
                if s.Equals('png') then begin
                  var png := TPngImage.Create;
                  try
                    png.LoadFromStream(g);
                    Picture.Assign(png);
                  except
                    Picture := nil;
                  end;
                  png.Free;
                end else if s.Equals('jpg') or s.Equals('jpeg') then begin
                  var jpg := TJpegImage.Create;
                  try
                    jpg.LoadFromStream(g);
                    Picture.Assign(jpg);
                  except
                    Picture := nil;
                  end;
                  jpg.Free;
                end else if s.Equals('bmp') then begin
                  try
                    Picture.Bitmap.LoadFromStream(g);
                  except
                    Picture := nil;
                  end;
                end else Picture := nil;
              except
                Picture := nil;
              end;
            end;
          end;
        except
        end;
        OnClick := PluginControlClick;
        OnMouseMove := PluginControlMouseMove;
        OnMouseLeave := PluginControlMouseLeave;
      end;
    end else if obj.GetValue('type').Value.Equals('edit') then begin
      PluginEdit.Add(TEdit.Create(PluginScrollBox));
      with PluginEdit[PluginEdit.Count - 1] do begin
        Parent := PluginScrollBox;
        Name := obj.GetValue('name').Value;
        AutoSize := false;
        ShowHint := true;
        var pos := obj.GetValue('position') as TJSONObject;
        Left := strtoint(pos.GetValue('left').Value);
        Top := strtoint(pos.GetValue('top').Value);
        Width := strtoint(pos.GetValue('width').Value);
        Height := strtoint(pos.GetValue('height').Value);
        try Enabled := strtobool(obj.GetValue('enabled').Value); except Enabled := true; end;
        try Visible := strtobool(obj.GetValue('visible').Value); except Visible := true; end;
        try ReadOnly := strtobool(obj.GetValue('readonly').Value); except ReadOnly := false; end;
        try TextHint := obj.GetValue('texthint').Value; except TextHint := '' end;
        try Hint := obj.GetValue('hint').Value; except Hint := '' end;
        try Text := obj.GetValue('text').Value; except Text := '' end;
        try PluginVariableDic.Add(obj.GetValue('result').Value, Text) except end;
        try 
          var fc := obj.GetValue('font_color').Value;
          if fc.Equals('blue') then Font.Color := rgb(10, 10, 255)
          else if fc.Equals('red') then Font.Color := rgb(255, 10, 10)
          else if fc.Equals('green') then Font.Color := rgb(10, 255, 10)
          else if fc.Equals('green') then Font.Color := rgb(10, 255, 10)
          else if fc.Equals('purple') then Font.Color := rgb(255, 10, 255)
          else if fc.Equals('yellow') then Font.Color := rgb(255, 255, 10)
          else if fc.Equals('cyan') then Font.Color := rgb(10, 255, 255)
          else if fc.Equals('black') then Font.Color := rgb(10, 10, 10)
          else if fc.Equals('write') then Font.Color := rgb(255, 255, 255)
          else Font.Color := ConvertHexToColor(fc);
        except Font.Color := 0; end;
        try Font.Size := strtoint(obj.GetValue('font_size').Value); except Font.Size := 9 end;
        try Font.Name := obj.GetValue('font_style').Value; except Font.Name := '宋体' end;
        OnClick := PluginControlClick;
        OnChange := PluginControlChange;
        OnMouseMove := PluginControlMouseMove;
        OnMouseLeave := PluginControlMouseLeave;
      end;
    end else if obj.GetValue('type').Value.Equals('combobox') then begin
      PluginCombobox.Add(TComboBox.Create(PluginScrollBox));
      with PluginCombobox[PluginCombobox.Count - 1] do begin
        Parent := PluginScrollBox;
        Name := obj.GetValue('name').Value;
        ShowHint := true;
        Style := csDropDownList;
        var pos := obj.GetValue('position') as TJSONObject;
        Left := strtoint(pos.GetValue('left').Value);
        Top := strtoint(pos.GetValue('top').Value);
        Width := strtoint(pos.GetValue('width').Value);
        Height := strtoint(pos.GetValue('height').Value);
        try Enabled := strtobool(obj.GetValue('enabled').Value); except Enabled := true; end;
        try Visible := strtobool(obj.GetValue('visible').Value); except Visible := true; end;
        try 
          var fc := obj.GetValue('font_color').Value;
          if fc.Equals('blue') then Font.Color := rgb(10, 10, 255)
          else if fc.Equals('red') then Font.Color := rgb(255, 10, 10)
          else if fc.Equals('green') then Font.Color := rgb(10, 255, 10)
          else if fc.Equals('green') then Font.Color := rgb(10, 255, 10)
          else if fc.Equals('purple') then Font.Color := rgb(255, 10, 255)
          else if fc.Equals('yellow') then Font.Color := rgb(255, 255, 10)
          else if fc.Equals('cyan') then Font.Color := rgb(10, 255, 255)
          else if fc.Equals('black') then Font.Color := rgb(10, 10, 10)
          else if fc.Equals('write') then Font.Color := rgb(255, 255, 255)
          else Font.Color := ConvertHexToColor(fc);
        except Font.Color := 0; end;
        try Font.Size := strtoint(obj.GetValue('font_size').Value); except Font.Size := 9 end;
        try Font.Name := obj.GetValue('font_style').Value; except Font.Name := '宋体' end;
        try
          var item := obj.GetValue('items') as TJSONArray;
          for var O in item do
            Items.Add(O.Value);
        except end;
        try ItemIndex := strtoint(obj.GetValue('itemindex').Value); except ItemIndex := -1 end;
        try PluginVariableDic.Add(obj.GetValue('result').Value, inttostr(ItemIndex)) except end;
        OnDropDown := PluginControlClick;
        OnSelect := PluginControlChange;
      end;
    end else if obj.GetValue('type').Value.Equals('scrollbar') then begin
      PluginScrollBar.Add(TScrollBar.Create(PluginScrollBox));
      with PluginScrollBar[PluginScrollBar.Count - 1] do begin
        Parent := PluginScrollBox;
        Name := obj.GetValue('name').Value;
        ShowHint := true;
        var pos := obj.GetValue('position') as TJSONObject;
        Left := strtoint(pos.GetValue('left').Value);
        Top := strtoint(pos.GetValue('top').Value);
        Width := strtoint(pos.GetValue('width').Value);
        Height := strtoint(pos.GetValue('height').Value);
        try Enabled := strtobool(obj.GetValue('enabled').Value); except Enabled := true; end;
        try Visible := strtobool(obj.GetValue('visible').Value); except Visible := true; end;
        try Min := strtoint(obj.GetValue('min').Value); except Min := 0; end;
        try Max := strtoint(obj.GetValue('max').Value); except Max := 100; end;
        try Position := strtoint(obj.GetValue('current').Value); except Position := Min; end;
        try 
          var kd := obj.GetValue('kind').Value;
          if(kd.Equals('horz')) then Kind := sbHorizontal
          else if(kd.Equals('vert')) then Kind := sbVertical
          else raise Exception.Create(Concat(kd, ' is not a valid value in here!'));
        except Kind := sbHorizontal end;
        try PluginVariableDic.Add(obj.GetValue('result').Value, inttostr(Position)) except end;
        OnScroll := PluginControlScroll;
      end;
    end else if obj.GetValue('type').Value.Equals('memo') then begin
      PluginMemo.Add(TMemo.Create(PluginScrollBox));
      with PluginMemo[PluginMemo.Count - 1] do begin
        Parent := PluginScrollBox;
        Name := obj.GetValue('name').Value;
        ShowHint := true;
        WordWrap := true;
        var pos := obj.GetValue('position') as TJSONObject;
        Left := strtoint(pos.GetValue('left').Value);
        Top := strtoint(pos.GetValue('top').Value);
        Width := strtoint(pos.GetValue('width').Value);
        Height := strtoint(pos.GetValue('height').Value);
        try Enabled := strtobool(obj.GetValue('enabled').Value); except Enabled := true; end;
        try Visible := strtobool(obj.GetValue('visible').Value); except Visible := true; end;
        try ReadOnly := strtobool(obj.GetValue('readonly').Value); except ReadOnly := false; end;
        try 
          var fc := obj.GetValue('font_color').Value;
          if fc.Equals('blue') then Font.Color := rgb(10, 10, 255)
          else if fc.Equals('red') then Font.Color := rgb(255, 10, 10)
          else if fc.Equals('green') then Font.Color := rgb(10, 255, 10)
          else if fc.Equals('green') then Font.Color := rgb(10, 255, 10)
          else if fc.Equals('purple') then Font.Color := rgb(255, 10, 255)
          else if fc.Equals('yellow') then Font.Color := rgb(255, 255, 10)
          else if fc.Equals('cyan') then Font.Color := rgb(10, 255, 255)
          else if fc.Equals('black') then Font.Color := rgb(10, 10, 10)
          else if fc.Equals('write') then Font.Color := rgb(255, 255, 255)
          else Font.Color := ConvertHexToColor(fc);
        except Font.Color := 0; end;
        try Font.Size := strtoint(obj.GetValue('font_size').Value); except Font.Size := 9 end;
        try Font.Name := obj.GetValue('font_style').Value; except Font.Name := '宋体' end;
        var L := '';
        try
          var lne := obj.GetValue('lines') as TJSONArray;
          for var O in lne do begin
            Lines.Add(O.Value);
            L := Concat(L, O.Value, #13#10);
          end;
        except end;
        try PluginVariableDic.Add(obj.GetValue('result').Value, L) except end;
        OnMouseMove := PluginControlMouseMove;
        OnMouseLeave := PluginControlMouseLeave;
        OnClick := PluginControlClick;
        OnChange := PluginControlChange;
      end;
    end else if obj.GetValue('type').Value.Equals('speedbutton') then begin
      PluginSpeedButton.Add(TSpeedButton.Create(PluginScrollBox));
      with PluginSpeedButton[PluginSpeedButton.Count - 1] do begin
        Parent := PluginScrollBox;
        Name := obj.GetValue('name').Value;
        ShowHint := true;
        var pos := obj.GetValue('position') as TJSONObject;
        Left := strtoint(pos.GetValue('left').Value);
        Top := strtoint(pos.GetValue('top').Value);
        Width := strtoint(pos.GetValue('width').Value);
        Height := strtoint(pos.GetValue('height').Value);
        try Enabled := strtobool(obj.GetValue('enabled').Value); except Enabled := true; end;
        try Visible := strtobool(obj.GetValue('visible').Value); except Visible := true; end;
        try 
          var fc := obj.GetValue('font_color').Value;
          if fc.Equals('blue') then Font.Color := rgb(10, 10, 255)
          else if fc.Equals('red') then Font.Color := rgb(255, 10, 10)
          else if fc.Equals('green') then Font.Color := rgb(10, 255, 10)
          else if fc.Equals('green') then Font.Color := rgb(10, 255, 10)
          else if fc.Equals('purple') then Font.Color := rgb(255, 10, 255)
          else if fc.Equals('yellow') then Font.Color := rgb(255, 255, 10)
          else if fc.Equals('cyan') then Font.Color := rgb(10, 255, 255)
          else if fc.Equals('black') then Font.Color := rgb(10, 10, 10)
          else if fc.Equals('write') then Font.Color := rgb(255, 255, 255)
          else Font.Color := ConvertHexToColor(fc);
        except Font.Color := 0; end;
        try Font.Size := strtoint(obj.GetValue('font_size').Value); except Font.Size := 9 end;
        try Font.Name := obj.GetValue('font_style').Value; except Font.Name := '宋体' end;
        var imgc := obj.GetValue('image') as TJSONObject;
        try
          var f := imgc.GetValue('base64').Value;
          var s := imgc.GetValue('suffix').Value;
          if s.Equals('bmp') then begin
            try
              Glyph.LoadFromStream(Base64ToStream(f));
            except
              Glyph := nil;
            end;
          end else Glyph := nil;
        except
          try
            var f := imgc.GetValue('path').Value;
            var s := imgc.GetValue('suffix').Value;
            if f.IndexOf('.') = 0 then begin
              f := Concat(ExtractFileDir(Application.ExeName), f.Substring(1));
            end;
            if FileExists(f) then begin
              if s.Equals('bmp') then begin
                try
                  Glyph.LoadFromFile(f);
                except
                  Glyph := nil;
                end;
              end else Glyph := nil;
            end else Glyph := nil;
          except
            try
              var f := imgc.GetValue('url').Value;
              var s := imgc.GetValue('suffix').Value;
              var g := GetWebStream(f);
              if s.Equals('bmp') then begin
                try
                  Glyph.LoadFromStream(g);
                except
                  Glyph := nil;
                end;
              end else Glyph := nil;
            except
              Glyph := nil;
            end;
          end;
        end;
        try
          var lo := obj.GetValue('layout').Value;
          if lo.Equals('left') then Layout := blGlyphLeft
          else if lo.Equals('right') then Layout := blGlyphRight
          else if lo.Equals('top') then Layout := blGlyphTop
          else if lo.Equals('bottom') then Layout := blGlyphBottom
          else raise Exception.Create(Concat(lo, ' is not a valid value in here!'));
        except Layout := blGlyphLeft end;
        OnClick := PluginControlClick;
        OnMouseMove := PluginControlMouseMove;
        OnMouseLeave := PluginControlMouseLeave;
      end;
    end;
  end;
end;
//插件部分：滑动条框
procedure TPluginForm.PluginScrollBoxMouseWheel(Sender: TObject;
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
end.
