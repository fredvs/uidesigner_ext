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

program designer_ext;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX}
  cthreads, {$ENDIF}
  fpg_iniutils,
  RunOnce_PostIt,
  fpg_cmdlineparams,
  fpg_style_anim_round_silver_horz,
  fpg_style_round_silver_flat_horz,
  fpg_style_anim_round_silver_flat_horz,
  fpg_style_anim_chrome_silver_vert,
  fpg_style_anim_chrome_silver_horz,
  fpg_style_anim_ellipse_silver_vert,
  fpg_style_anim_ellipse_silver_horz,
  fpg_style_hoover_system_flat,
  fpg_style_hoover_silver_flat,
  fpg_style_ellipse_silver,
  fpg_style_ellipse_system,
  fpg_style_ellipse_gray,
  fpg_style_ellipse_purple,
  fpg_style_ellipse_red,
  fpg_style_ellipse_green,
  fpg_style_ellipse_blue,
  fpg_style_ellipse_yellow,
  fpg_style_chrome_gray,
  fpg_style_chrome_blue,
  fpg_style_chrome_silver,
  fpg_style_chrome_system,
  fpg_style_chrome_green,
  fpg_style_chrome_red,
  fpg_style_chrome_purple,
  fpg_style_chrome_yellow,
  fpg_style_mint1,
  fpg_style_mint2,
  fpg_style_mint3,
  fpg_style_SystemColors,
  fpg_style_SystemColorsMyStyle1,
  fpg_style_SystemColorsMyStyle2,
  fpg_stylemanager,
  SysUtils,
  fpg_main,
  vfd_main,
  frm_main_designer,
  vfd_widgets;

  procedure MainProc;
  var
    filedir: string;
  begin
    ifonlyone := True;
    filedir := '';

    if (isrunningIDE('typhon') = False) and (isrunningIDE('lazarus') = False) then
    begin
        if  gINI.ReadBool('Options', 'RunOnlyOnce', true) = true then
      begin
       ifonlyone := true;
       filedir := 'clear';
      RunOnce(filedir);
       end
      else ifonlyone := false;
    end
    else
    begin
      { If file passed in as clasical first param, load it! }
      if (FileExists(ParamStr(1))) or (ParamStr(1) = 'closeall') or
        (ParamStr(1) = 'quit') then
        filedir := ParamStr(1);

       if  gINI.ReadBool('Options', 'RunOnlyOnce', true) = true then
      begin
          ifonlyone := true;
          RunOnce(filedir) ;
      end
      else ifonlyone := false;
      end;

    fpgApplication.Initialize;
    try
      RegisterWidgets;
      if not gCommandLineParams.IsParam('style') then
      begin
            if fpgStyleManager.SetStyle('Hoover Silver Flat') then
          fpgStyle := fpgStyleManager.Style;
      end;

      PropList := TPropertyList.Create;
      maindsgn := TMainDesigner.Create;

      maindsgn.CreateWindows;

      fpgApplication.MainForm := frmMainDesigner;

      fpgApplication;
       frmProperties.hide;
      fpgApplication.Run;

      PropList.Free;

    finally
      maindsgn.Free;
    end;
  end;


begin
  MainProc;
end.
