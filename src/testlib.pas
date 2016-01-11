program testlib;

{$mode objfpc}{$H+}

uses
 plugmanager, 
   sysutils;
  
 
  procedure MainProc;
  var
    ordir : string;
    isloaded : boolean = false;
  begin
   ordir := IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));
     if fpgd_loadlib(ordir + 'libfpgdxt.so')  then
 begin
 writeln('Library loaded. ;-)');
 isloaded := true;
 fpgd_mainproc();
 end
 else
 begin
   writeln('Library NOT loaded... ;-(')  ;
   isloaded := false;
 end;
  end;
  
begin
  MainProc;
end.
