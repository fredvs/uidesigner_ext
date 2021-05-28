unit xdynload;

{$mode objfpc}{$H+}

interface

uses
 sysutils, xlib, xftlib, xext;

  
 const
  fX11='libX11.so.6';
  fXft='libXft.so.2';  
  fXext='libXext.so.6';  
  
Function xdynloadlib(const libfilename1:string = '' ; const libfilename2:string = ''; const libfilename3:string = '') :boolean;
procedure xdynunloadlib();

implementation

Function xdynloadlib(const libfilename1:string = '' ; const libfilename2:string = ''; const libfilename3:string = '') :boolean;
var
libX11, libXft, libXext: string; 
begin
result := false;

if (libfilename1 = '') and (libfilename2 = '') and (libfilename3 = '') then
begin
libX11 := fX11;
libXft := fXft;
libXext := fXext;
end else
begin
libX11 := libfilename1;
libXft := libfilename2;
libXext := libfilename3;
end;

result := x_Load(libX11) ;
result := xft_Load(libXft);
result := xext_Load(libXext);
end;

procedure xdynunloadlib() ;
begin
 //  xext_unLoad();  // done by X_unload
  xft_unLoad();
  x_unLoad();
 end;

end.
