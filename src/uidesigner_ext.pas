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
  fpgstyle_mystyle,
  fpgstyle_mystyle1,
  fpgstyle_mystyle2,
  fpgstyle_mystyle3,
  fpgstyle_hoover_system,
  fpgstyle_hoover_silver,
  fpgstyle_elipse_silver,
  fpgstyle_elipse_system,
  fpgstyle_elipse_gray,
  fpgstyle_elipse_purple,
  fpgstyle_elipse_red,
  fpgstyle_elipse_green,
  fpgstyle_elipse_blue,
  fpgstyle_elipse_yellow,
  fpgstyle_chrome_gray,
  fpgstyle_chrome_blue,
  fpgstyle_chrome_silver,
  fpgstyle_chrome_system,
  fpgstyle_chrome_green,
  fpgstyle_chrome_red,
  fpgstyle_chrome_purple,
  fpgstyle_chrome_yellow,
  fpgstyle_mint1,
  fpgstyle_mint2,
  fpgstyle_mint3,
  fpgstyle_SystemColorsStyle,
  fpgstyle_SystemColorsMyStyle1,
  fpgstyle_SystemColorsMyStyle2,
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


begin
  MainProc;
end.
