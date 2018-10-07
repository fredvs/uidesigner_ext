{ This is the dynamic loader header of xrender library.
  Use xren_load() to dynamically load libXrender.so.1
  Fredvs ---> fiens@hotmail.com
}  

unit xext;

interface
{$mode objfpc}{$H+}

uses
 dynlibs, ctypes, x, xlib ;
{$define MACROS}

const
     libXext='libXext.so.6';
 
type
   // XSync extension types
  TXSyncCounter = TXID;
  TXSyncValue = record
    hi: cint;
    lo: cunsigned;
  end;
 
// XSync functions
var XSyncCreateCounter: function(dpy: PXDisplay; initial_value: TXSyncValue): TXSyncCounter; cdecl; 
var XSyncSetCounter: function(dpy: PXDisplay; counter: TXSyncCounter; value: TXSyncValue): TStatus; cdecl; 
var XSyncDestroyCounter: function(dpy: PXDisplay; counter: TXSyncCounter ): TStatus; cdecl; 

 var xext_Handle:TLibHandle=dynlibs.NilHandle; 

 var ReferenceCounter : cardinal = 0;  // Reference counter
         
 function xext_IsLoaded() : boolean; inline; 

 function xext_Load(const libfilename:string = libXext) :boolean; // load the lib

 procedure xext_Unload(); // unload and frees the lib from memory : do not forget to call it before close application.

implementation

function xext_IsLoaded(): boolean;
begin
 Result := (xext_Handle <> dynlibs.NilHandle);
end;

Function xext_Load (const libfilename:string = libXext) :boolean;
begin
  Result := False;
  if xext_Handle<>0 then 
begin
 Inc(ReferenceCounter);
 result:=true {is it already there ?}
end  else 
begin {go & load the library}
    if Length(libfilename) = 0 then exit;
    xext_Handle:=DynLibs.SafeLoadLibrary(libfilename); // obtain the handle we want
  	if xext_Handle <> DynLibs.NilHandle then
begin {now we tie the functions to the VARs from above}

 Pointer(XSyncCreateCounter):=DynLibs.GetProcedureAddress(xext_Handle,PChar('XSyncCreateCounter'));
 Pointer(XSyncSetCounter):=DynLibs.GetProcedureAddress(xext_Handle,PChar('XSyncSetCounter'));
 Pointer(XSyncDestroyCounter):=DynLibs.GetProcedureAddress(xext_Handle,PChar('XSyncDestroyCounter'));
 
end;
   Result := xext_IsLoaded();
   ReferenceCounter:=1;   
end;

end;

Procedure xext_Unload();
begin
// < Reference counting
  if ReferenceCounter > 0 then
    dec(ReferenceCounter);
  if ReferenceCounter > 0 then
    exit;
  // >
  if xext_IsLoaded() then
  begin
 if xext_Handle <> DynLibs.NilHandle then 
   DynLibs.UnloadLibrary(xext_Handle);
   xext_Handle:=DynLibs.NilHandle;
  end;
end;

end.   
