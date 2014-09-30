{ 
This is the extended version of fpGUI uidesigner.
With run-only-once, window list, undo feature, integration into IDE, editor launcher,...
Fred van Stappen
fiens@hotmail.com
}
{
    fpGUI  -  Free Pascal GUI Library

    Copyright (C) 2006 - 2013 See the file AUTHORS.txt, included in this
    distribution, for details of the copyright.

    See the file COPYING.modifiedLGPL, included in this distribution,
    for details about redistributing fpGUI.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    Description:
      The starting unit for the UI Designer project.
}

program uidesigner_ext;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX}
  cthreads, {$ENDIF}
  RunOnce_PostIt,
  fpg_cmdlineparams,
  mystyle,
  mystyle1,
  mystyle2,
  mystyle3,
  fpg_style_win8,
  style_elipse_silver,
  style_elipse_gray,
  style_elipse_purple,
  style_elipse_red,
  style_elipse_green,
  style_elipse_blue,
  style_chrome_gray,
  style_chrome_blue,
  style_chrome_silver,
  style_chrome_green,
  style_chrome_red,
  style_chrome_purple,
  style_mint1,
  style_mint2,
  style_mint3,
  SystemColorsStyle,
  SystemColorsMyStyle1,
  SystemColorsMyStyle2,
  fpg_stylemanager,
  SysUtils,
  fpg_main,
  vfdmain,
  newformdesigner,
  vfdwidgets;

  procedure MainProc;
  var
    filedir: string;
  begin
    ifonlyone := True;
    filedir := '';

    if (isrunningIDE('typhon') = False) and (isrunningIDE('lazarus') = False) then
    begin
      filedir := 'clear';
      RunOnce(filedir);
    end
    else
    begin
      { If file passed in as clasical first param, load it! }
      if (FileExists(ParamStr(1))) or (ParamStr(1) = 'closeall') or
        (ParamStr(1) = 'quit') then
        filedir := ParamStr(1);

      if gCommandLineParams.IsParam('onlyone') then
      begin
        if StrToInt(copy(gCommandLineParams.GetParam('onlyone'), 1, 1)) > 0 then
          RunOnce(filedir)
        else
          ifonlyone := False;
             end
      else
        RunOnce(filedir);
    end;

    fpgApplication.Initialize;
    try
      RegisterWidgets;
      if not gCommandLineParams.IsParam('style') then
      begin
            if fpgStyleManager.SetStyle('Demo Style1') then
          fpgStyle := fpgStyleManager.Style;
      end;

      PropList := TPropertyList.Create;
      maindsgn := TMainDesigner.Create;

      maindsgn.CreateWindows;

     // Making sure the correct form is set as the MainForm

      fpgApplication.MainForm := frmMain;

      fpgApplication;
      fpgApplication.Run;

      PropList.Free;

    finally
      maindsgn.Free;
    end;
  end;

{$R *.res}

begin
  MainProc;
end.
