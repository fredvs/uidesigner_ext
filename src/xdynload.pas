unit xdynload;

{$mode objfpc}{$H+}

interface

uses
 sysutils, xlib, xftlib;

  
 const
  fX11='libX11.so.6';
  fXft='libXft.so.2';  
  
Function xdynloadlib(const libfilename1:string = '' ; const libfilename2:string = '') :boolean;
procedure xdynunloadlib();

implementation

Function xdynloadlib(const libfilename1:string = '' ; const libfilename2:string = '') :boolean;
var
libX11, libXft: string; 
begin
result := false;

if (libfilename1 = '') and (libfilename2 = '') then
begin
libX11 := fX11;
libXft := fXft;
end else
begin
libX11 := libfilename1;
libXft := libfilename2;
end;

result := x_Load(libX11) ;
result := xft_Load(libXft);
end;

procedure xdynunloadlib() ;
begin
  xft_unLoad();
  x_unLoad();
end;

end.
