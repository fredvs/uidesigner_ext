{ 
This library is the extended version of fpGUI uidesigner.
With  window list, undo feature, integration into IDE, editor launcher,...
Fred van Stappen
fiens@hotmail.com
2013 - 2015
}
{
    fpGUI  -  Free Pascal GUI Library

    Copyright (C) 2006 - 2015 See the file AUTHORS.txt, included in this
    distribution, for details of the copyright.

    See the file COPYING.modifiedLGPL, included in this distribution,
    for details about redistributing fpGUI.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    Description:
      The starting unit for the UI Designer project.
}

library fpgdxt ;

/// for custom compil, like using fpgui-dvelop, Java library =>  edit define.inc
{$I define.inc}

{$mode objfpc}{$H+}

uses{$IFDEF UNIX}
  cthreads, {$ENDIF}
  fpg_main,
  fpg_iniutils,
  SysUtils,
  RunOnce_PostIt,
  sak_fpg,
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
  vfd_main,
  frm_main_designer,
  vfd_widgets;

{$IFDEF java}
procedure fpgdxthide(PEnv: pointer; Obj: pointer); cdecl; // Java
 {$ELSE}
procedure fpgdxthide(); cdecl; // native
 {$ENDIF}
 begin
   frmMainDesigner.hide;
   frmProperties.hide;
 end;

{$IFDEF java}
procedure fpgdxtclose(PEnv: pointer; Obj: pointer); cdecl; // Java
 {$ELSE}
procedure fpgdxtclose(); cdecl; // native
 {$ENDIF}
 begin
   frmMainDesigner.hide;
   frmProperties.hide;
 end;

{$IFDEF java}
function fpgdxtloadfile(PEnv: pointer; Obj: pointer; afilename : PChar); cdecl; // Java
 {$ELSE}
 function fpgdxtloadfile(afilename : PChar) : integer ; cdecl; // native
 {$ENDIF}
begin
  if FileExists(afilename) then
  begin
    maindsgn.EditedFileName := afilename;
    maindsgn.OnLoadFile(maindsgn);
  end;
  end;

 {$IFDEF java}
procedure fpgdxtmainproc(PEnv: pointer; Obj: pointer); cdecl; // Java
 {$ELSE}
procedure fpgdxtmainproc(); cdecl; // native
 {$ENDIF}
   var
    filedir, ordir: string;
  begin
    ifonlyone := false;
    filedir := '';
      ordir := IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));
    if (isrunningIDE('typhon') = False) and (isrunningIDE('lazarus') = False) and
      (isrunningIDE('ideu') = False) and (isrunningIDE('ideU') = False) then
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
      if (FileExists(ParamStr(1))) or (ParamStr(1) = 'closeall')
        or (trim(ParamStr(1)) = 'showit') or (ParamStr(1) = 'quit') or (ParamStr(1) = 'hideit')  then
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
            if fpgStyleManager.SetStyle('Chrome silver flat menu') then
          fpgStyle := fpgStyleManager.Style;
      end;

      PropList := TPropertyList.Create;
      maindsgn := TMainDesigner.Create;

      maindsgn.CreateWindows;

      fpgApplication.MainForm := frmMainDesigner;

     frmProperties.hide;
       dirsakit := gINI.ReadString('Options', 'SakitDir', ordir);

    if (directoryexists(dirsakit + directoryseparator +'sakit'))and (gINI.ReadBool('Options', 'EnableAssistive', false) = True)
     then SAKLoadlib(dirsakit);

    fpgApplication.ShowHint:=true;

      fpgApplication.Run;

      PropList.Free;

    finally
         if SakIsEnabled = true then SAKUnLoadLib;
      maindsgn.Free;
    end;
  end;
  
  
exports

{$IFDEF java}
// Java
fpgdxtmainproc name 'Java_fpgdxt_mainproc',
fpgdxtclose name 'Java_fpgdxt_close',
fpgdxthide name 'Java_fpgdxt_loadfile',
fpgdxtloadfile name  'Java_fpgdxt_loadfile' ;
 {$ELSE}
// native
 fpgdxtmainproc name 'fpgdxtmainproc',
  fpgdxtclose name 'fpgdxtclose',
  fpgdxtloadfile name 'fpgdxtloadfile',
  fpgdxthide name 'fpgdxthide';
 {$ENDIF}

end.
