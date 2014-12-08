program testlib;

{$mode objfpc}{$H+}

uses
 plugmanager, 
   sysutils;
  
 
  procedure MainProc;
  begin
  fpgd_loadlib('/home/fred/designer_ext/src/libfpgdxt.so') ;
  fpgd_mainproc();
  end;
  
begin
  MainProc;
end.
