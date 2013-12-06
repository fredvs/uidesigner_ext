{ This is the extended bersion of fpGUI Designer.
Fred van Stappen     fiens@hotmail.com }
{
    fpGUI  -  Free Pascal GUI Library

    Copyright (C) 2006 - 2010 See the file AUTHORS.txt, included in this
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

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
   fpg_cmdlineparams
  ,fpg_stylemanager, mystyle_systemcolors  ,
  Classes, SysUtils, fpg_base, fpg_main, vfdmain, vfdresizer, vfdforms,
  vfdfile, newformdesigner, vfdwidgets, vfdformparser, vfdeditors,   fpg_iniutils,
  vfdwidgetclass, vfdutils, vfdprops, vfddesigner, vfdpropeditgrid;


procedure MainProc;
begin
  fpgApplication.Initialize;
  try
             RegisterWidgets;
       if not gCommandLineParams.IsParam('style') then
    if fpgStyleManager.SetStyle('my style system colors') then
      fpgStyle := fpgStyleManager.Style;



    PropList := TPropertyList.Create;
     maindsgn := TMainDesigner.Create;

     maindsgn.CreateWindows;

    // Note:  This needs improving!!
    fpgApplication.MainForm := frmMain;

    { If file passed in as param, load it! }
    maindsgn.EditedFileName := ParamStr(1);
    if FileExists(maindsgn.EditedFileName) then
      maindsgn.OnLoadFile(maindsgn);

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


