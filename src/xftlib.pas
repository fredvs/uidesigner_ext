{ This is the dynamic loader header of xft library.
  Use xft_load() to dynamically load libXft.so.2
  Fredvs ---> fiens@hotmail.com
}
unit xftlib;

interface
{$mode objfpc}{$H+}

uses
  Classes
  ,x
  ,xlib
  ,SysUtils
  ,dynlibs
  ;
    
const
  libXft='libXft.so.2';

 type
  TPicture = longword;

  TXftDraw = record
               dummy : Pointer;
             end;
  PXftDraw = ^TXftDraw;

  TXftFont = record
               ascent   : integer;
               descent  : integer;
               height   : integer;
               max_advance_width : integer;
               ptr1     : Pointer;  // charset
               ptr2     : Pointer;  // pattern
             end;
  PXftFont = ^TXftFont;

  TXRenderColor = record
                    red   : word;
                    green : word;
                    blue  : word;
                    alpha : word;
                  end;

  TXftColor = record
                pixel : ptrint;
                color : TXRenderColor;
              end;
              
  TXGlyphInfo = packed record
                  width   : word;
                  height  : word;
                  x       : smallint;
                  y       : smallint;
                  xOff    : smallint;
                  yOff    : smallint;
                end;

  TFcPattern = record
    dummy : integer;
  end;

  PFcPattern = ^TFcPattern;
  PPFcPattern = ^PFcPattern;

  TFcFontSet = packed record
    nfont : integer;
    sfont : integer;
    fonts : PPFcPattern;
  end;
  PFcFontSet = ^TFcFontSet;

const
//  FC_FAMILY  : PChar = 'family';
//  FC_SIZE    : PChar = 'size';
//  FC_SCALABLE : PChar = 'scalable';

  FC_FAMILY =          'family';	//* String */
  FC_STYLE =           'style';		//* String */
  FC_SLANT =           'slant';		//* Int */
  FC_WEIGHT =	       'weight';	//* Int */
  FC_SIZE =	           'size';      //* Double */
  FC_ASPECT =	       'aspect';	//* Double */
  FC_PIXEL_SIZE =      'pixelsize';     //* Double */
  FC_SPACING =	       'spacing';	//* Int */
  FC_FOUNDRY =	       'foundry';	//* String */
  FC_ANTIALIAS =       'antialias';	//* Bool (depends) */
  FC_HINTING =	       'hinting';	//* Bool (true) */
  FC_VERTICAL_LAYOUT = 'verticallayout';//* Bool (false) */
  FC_AUTOHINT =	       'autohint';	//* Bool (false) */
  FC_GLOBAL_ADVANCE =  'globaladvance';	//* Bool (true) */
  FC_FILE =	       'file';		//* String */
  FC_INDEX =	       'index';		//* Int */
  FC_FT_FACE =	       'ftface';	//* FT_Face */
  FC_RASTERIZER =      'rasterizer';	//* String */
  FC_OUTLINE =	       'outline';	//* Bool */
  FC_SCALABLE =	       'scalable';	//* Bool */
  FC_SCALE =	       'scale';		//* double */
  FC_DPI =             'dpi';		//* double */
  FC_RGBA =            'rgba';		//* Int */
  FC_MINSPACE =	       'minspace';	//* Bool use minimum line spacing */
  FC_SOURCE =	       'source';	//* String (X11, freetype) */
  FC_CHARSET =	       'charset';	//* CharSet */
  FC_LANG =            'lang';		//* String RFC 3066 langs */
  FC_FONTVERSION =     'fontversion';	//* Int from 'head' table */

  FC_MATRIX =          'matrix';
  FC_CHAR_WIDTH =      'charwidth';

  FC_WEIGHT_BOLD = 200;
  FC_SLANT_ITALIC = 100;
  FC_PROPORTIONAL = 0;
  FC_MONO = 100;


  FcTypeVoid         = 0;
  FcTypeInteger      = 1;
  FcTypeDouble       = 2;
  FcTypeString       = 3;
  FcTypeBool         = 4;
  FcTypeMatrix       = 5;
  FcTypeCharSet      = 6;
  FcTypeFTFace       = 7;
  FcTypeLangSet      = 8;

var XftDrawCreate: function(display : PXDisplay; win : TXID; vis : PVisual; colorm : longint) : PXftDraw; cdecl;
var XftDrawChange: procedure(xftd : PXftDraw; win : TXID); cdecl;
var XftDrawDestroy: procedure(draw : PXftDraw); cdecl;
var XftDrawPicture: function(draw : PXftDraw) : TPicture; cdecl;
var XftFontOpenName: function(display : PXDisplay; scr : integer; par3 : PChar) : PXftFont; cdecl;
var XftFontClose: procedure(display : PXDisplay; fnt : PXftFont); cdecl;
var XftDrawStringUtf8: procedure(draw : PXftDraw; var col : TXftColor; fnt : PXftFont; x,y : integer; txt : PChar; len : integer); cdecl;
var XftDrawString8: procedure(draw : PXftDraw; var col : TXftColor; fnt : PXftFont; x,y : integer; txt : PChar; len : integer); cdecl;
var XftDrawString16: procedure(draw : PXftDraw; var col : TXftColor; fnt : PXftFont; x,y : integer; txt : PChar; len : integer); cdecl;
var XftTextExtentsUtf8: procedure(display : PXDisplay; fnt : PXftFont; txt : PChar; len : integer; var extents : TXGlyphInfo); cdecl;
var XftTextExtents8: procedure(display : PXDisplay; fnt : PXftFont; txt : PChar; len : integer; var extents : TXGlyphInfo); cdecl;
var XftTextExtents16: procedure(display : PXDisplay; fnt : PXftFont; txt : PChar; len : integer; var extents : TXGlyphInfo); cdecl;
var XftDrawSetClip: procedure(draw : PXftDraw; rg : TRegion); cdecl;
var XftListFonts: function(display : PXDisplay; screen : integer; params : array of const) : PFcFontSet; cdecl;
var XftNameUnparse: function(pat : PFcPattern; dest : PChar; destlen : integer) : boolean; cdecl;

var xft_Handle:TLibHandle=dynlibs.NilHandle; // this will hold our handle for the lib; it functions nicely as a mutli-lib prevention unit as well...

 var ReferenceCounter : cardinal = 0;  // Reference counter
         
 function xft_IsLoaded() : boolean; inline; 

 Function xft_Load(const libfilename:string = libxft) :boolean; // load the lib

 Procedure xft_Unload(); // unload and frees the lib from memory : do not forget to call it before close application.

implementation

function xft_IsLoaded(): boolean;
begin
 Result := (xft_Handle <> dynlibs.NilHandle);
end;

Function xft_Load (const libfilename:string = libxft) :boolean;
begin
  Result := False;
  if xft_Handle<>0 then 
begin
 Inc(ReferenceCounter);
 result:=true {is it already there ?}
end  else 
begin {go & load the library}
    if Length(libfilename) = 0 then exit;
    xft_Handle:=DynLibs.SafeLoadLibrary(libfilename); // obtain the handle we want
  	if xft_Handle <> DynLibs.NilHandle then
begin {now we tie the functions to the VARs from above}

 Pointer(XftDrawCreate):=DynLibs.GetProcedureAddress(xft_Handle,PChar('XftDrawCreate'));
 Pointer(XftDrawChange):=DynLibs.GetProcedureAddress(xft_Handle,PChar('XftDrawChange'));
 Pointer(XftDrawDestroy):=DynLibs.GetProcedureAddress(xft_Handle,PChar('XftDrawDestroy'));
Pointer(XftDrawPicture):=DynLibs.GetProcedureAddress(xft_Handle,PChar('XftDrawPicture'));
Pointer(XftFontOpenName):=DynLibs.GetProcedureAddress(xft_Handle,PChar('XftFontOpenName'));
Pointer(XftFontClose):=DynLibs.GetProcedureAddress(xft_Handle,PChar('XftFontClose'));
 Pointer(XftDrawStringUtf8):=DynLibs.GetProcedureAddress(xft_Handle,PChar('XftDrawStringUtf8'));
 Pointer(XftDrawString8):=DynLibs.GetProcedureAddress(xft_Handle,PChar('XftDrawString8'));
 Pointer(XftDrawString16):=DynLibs.GetProcedureAddress(xft_Handle,PChar('XftDrawString16'));
 Pointer(XftTextExtentsUtf8):=DynLibs.GetProcedureAddress(xft_Handle,PChar('XftTextExtentsUtf8'));
 Pointer(XftTextExtents8):=DynLibs.GetProcedureAddress(xft_Handle,PChar('XftTextExtents8'));
 Pointer(XftTextExtents16):=DynLibs.GetProcedureAddress(xft_Handle,PChar('XftTextExtents16'));
 Pointer(XftDrawSetClip):=DynLibs.GetProcedureAddress(xft_Handle,PChar('XftDrawSetClip'));
 Pointer(XftListFonts):=DynLibs.GetProcedureAddress(xft_Handle,PChar('XftListFonts'));
Pointer(XftNameUnparse):=DynLibs.GetProcedureAddress(xft_Handle,PChar('XftNameUnparse'));

end;
   Result := xft_IsLoaded();
   ReferenceCounter:=1;   
end;

end;

Procedure xft_Unload();
begin
// < Reference counting
  if ReferenceCounter > 0 then
    dec(ReferenceCounter);
  if ReferenceCounter > 0 then
    exit;
  // >
  if xft_IsLoaded() then
  begin
   if xft_Handle <> DynLibs.NilHandle then 
  // DynLibs.UnloadLibrary(xft_Handle);  // crash ???
   xft_Handle:=DynLibs.NilHandle;
  end;
end;
initialization

xft_Load(libXft);

finalization

xft_unLoad();

end.

