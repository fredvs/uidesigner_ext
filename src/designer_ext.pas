{ 
This is the extended version of fpGUI uidesigner.
With run-only-once, window list, undo feature, integration into IDE, editor launcher,...
It uses dynamically loading of libX11 and libXft in Unix OS.

Fred van Stappen
fiens@hotmail.com
2013 - 2017
}

program designer_ext;

{$mode objfpc}{$H+}

/// for custom compil, like using fpgui-develop =>  edit define.inc
{$I define.inc}

uses
 {$IFDEF UNIX}
   cthreads,
  fpg_dynload, 
   {$ENDIF}
  fpg_main,
  fpg_iniutils,
  SysUtils,
  RunOnce_PostIt,
  sak_fpg,
  fpg_cmdlineparams,

// {
 // fpg_style_anim_pram1,
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
  // }
  fpg_stylemanager,
  vfd_main,
  frm_main_designer,
  vfd_widgets;

  procedure MainProc;
  var
    filedir, ordir : string;

    {$ifdef fpgui-develop}
  //   cmd: ICmdLineParams;
    {$endif}

  begin
 // param1 := 2;

    ifonlyone := True;
    filedir := '';
     ordir := IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));

 {$ifdef ideu}
  idetemp := gINI.ReadInteger('Options', 'IDE', 3)  ;
 {$else}
  idetemp := gINI.ReadInteger('Options', 'IDE', 0) ;
 {$endif}

     if ((trim(ParamStr(1)) = 'showit') and (gINI.ReadBool('Options', 'RunOnlyOnce', True) = True)) then
    begin
      ifonlyone := True;
      RunOnce('showit');
    end
    else

    if ((trim(ParamStr(1)) = 'hideit') and (gINI.ReadBool('Options', 'RunOnlyOnce', True) = True)) then
    begin
      ifonlyone := True;
      RunOnce('hideit');
    end
    else
     begin
        if (idetemp = 0) or ((idetemp > 0) and
        (isrunningIDE('typhon') = False) and (isrunningIDE('ideu') = False) and (isrunningIDE('ideU') = False) and (isrunningIDE('lazarus') = False)) then
      begin
        if gINI.ReadBool('Options', 'RunOnlyOnce', True) = True then
        begin
          ifonlyone := True;
          filedir := 'clear';
          RunOnce(filedir);
        end
        else
          ifonlyone := False;
      end
      else
      begin
        { If file passed in as clasical first param, load it! }
        if (FileExists(ParamStr(1))) or (ParamStr(1) = 'closeall') or (trim(ParamStr(1)) = '') or (trim(ParamStr(1)) = 'showit') or
          (trim(ParamStr(1)) = 'hideit') or (ParamStr(1) = 'quit') then
          begin
          if gINI.ReadBool('Options', 'RunOnlyOnce', True) = True then
        begin
          ifonlyone := True;
          RunOnce( ParamStr(1));
        end
        else
        begin
        //  ifonlyone := False;
          if (FileExists(ParamStr(1)))  or (trim(ParamStr(1)) = '')  then  ifonlyone := False else fpgApplication.Terminate;
        end;
      end

         end;
     end;
     
     {$IFDEF UNIX}
     fpg_loaddynlib();
     {$ENDIF}
  
     fpgApplication.Initialize;
    try
      RegisterWidgets;

    {$ifdef fpgui-develop}

  if not gCommandLineParams.IsParam('style') then
// cmd := fpgApplication as ICmdLineParams;
// if not cmd.HasOption('style') then
      {$else}
     if not gCommandLineParams.IsParam('style') then
    {$endif}

      begin
        if fpgStyleManager.SetStyle('Chrome silver flat menu') then
          fpgStyle := fpgStyleManager.Style;
      end;

     PropList := TPropertyList.Create;
     maindsgn := TMainDesigner.Create;

      maindsgn.CreateWindows;

      if SakIsEnabled = true then SAKUnLoadLib;   
      fpgApplication.MainForm := frmMainDesigner;

      frmProperties.hide;

      if (FileExists(ParamStr(1))) and (ifonlyone = False) then
      begin
        maindsgn.EditedFileName := ParamStr(1);
        maindsgn.OnLoadFile(maindsgn);
      end;

   dirsakit := gINI.ReadString('Options', 'SakitDir', ordir);

    if (directoryexists(dirsakit + directoryseparator +'sakit'))and (gINI.ReadBool('Options', 'EnableAssistive', false) = True)
     then SAKLoadlib(dirsakit);

    fpgApplication.ShowHint:=true;
      fpgApplication.Run;

      PropList.Free;

   finally
          maindsgn.Free;
          fpg_unloaddynlib();
    end;


  end;

begin
  MainProc;
end.
