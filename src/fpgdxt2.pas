{ 
This library is the extended version of fpGUI uidesigner.
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

library fpguidesignerext ;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX}
  cthreads, {$ENDIF}
  fpg_iniutils,
  sysutils,
  RunOnce_PostIt,
  fpg_cmdlineparams,
  fpg_style_anim_round_silver_horz,
  fpg_style_round_silver_flat_horz,
  fpg_style_anim_round_silver_flat_horz,
  fpg_style_anim_chrome_silver_vert,
  fpg_style_anim_chrome_silver_vert_flatmenu,
  fpg_style_anim_chrome_silver_horz,
  fpg_style_anim_chrome_silver_horz_flatmenu,
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
  fpg_style_chrome_silver_flatmenu,
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
  fpg_main,
  vfd_main,
  frm_main_designer,
  vfd_widgets;
 
//procedure hidefpguidesigner(PEnv: pointer; Obj: pointer); cdecl; // Java 
 procedure hidefpguidesigner(); cdecl; // native
 begin
   frmMainDesigner.hide;
   frmProperties.hide;
 end;
 
//procedure closefpguidesigner(PEnv: pointer; Obj: pointer); cdecl; // Java 
 procedure closefpguidesigner(); cdecl; // native
 begin
   frmMainDesigner.hide;
   frmProperties.hide;
 end;
 
//function loadfilefpguidesigner(PEnv: pointer; Obj: pointer; afilename : PChar); cdecl; // Java 
 function loadfilefpguidesigner(afilename : PChar) : integer ; cdecl; // native
 begin
  if FileExists(afilename) then
  begin
    maindsgn.EditedFileName := afilename;
    maindsgn.OnLoadFile(maindsgn);
  end;
  end;
 
//procedure MainProc(PEnv: pointer; Obj: pointer); cdecl; // Java
  procedure MainProc(); cdecl; // native
  begin
    ifonlyone := false;
 
    fpgApplication.Initialize;
    try
      RegisterWidgets;
      if fpgStyleManager.SetStyle('Chrome silver flat menu') then
          fpgStyle := fpgStyleManager.Style;

      PropList := TPropertyList.Create;
      maindsgn := TMainDesigner.Create;

      maindsgn.CreateWindows;

      fpgApplication.MainForm := frmMainDesigner;
       
       frmMainDesigner.hide;
        frmProperties.hide;
      fpgApplication.Run;

      PropList.Free;

    finally
      maindsgn.Free;
    end;
  end;
  
  
exports
  //{  // native
  MainProc name 'mainprocfpguidesigner',
  closefpguidesigner name 'closefpguidesigner',
  loadfilefpguidesigner name 'loadfilefpguidesigner',
  hidefpguidesigner name 'hidefpguidesigner';
  //}
 
 { // Java
 MainProc name 'Java_fpguidesignerext_mainprocfpguidesigner',
 closefpguidesigner name 'Java_fpguidesignerext_closefpguidesigner',
 hidefpguidesigner name 'Java_fpguidesignerext_hidefpguidesigner',
 loadfilefpguidesigner name  'Java_fpguidesignerext_loadfilefpguidesigner' ;
}

end.
