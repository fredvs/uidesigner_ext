{ This is the dynamic loader header of xrender library.
  Use xren_load() to dynamically load libXrender.so.1
  Fredvs ---> fiens@hotmail.com
}  

unit xrender;

interface
{$mode objfpc}{$H+}

uses
 dynlibs, ctypes, x, xlib ;
{$define MACROS}

 const
     libXren='libXrender.so.1';
 
type

   PGlyph = ^TGlyph;
   TGlyph = dword;

   PGlyphSet = ^TGlyphSet;
   TGlyphSet = dword;

   PPicture = ^TPicture;
   TPicture = dword;

   PPictFormat = ^TPictFormat;
   TPictFormat = dword;

const
   RENDER_NAME = 'RENDER';
   RENDER_MAJOR = 0;
   RENDER_MINOR = 0;
   X_RenderQueryVersion = 0;
   X_RenderQueryPictFormats = 1;
   X_RenderQueryPictIndexValues = 2;
   X_RenderQueryDithers = 3;
   X_RenderCreatePicture = 4;
   X_RenderChangePicture = 5;
   X_RenderSetPictureClipRectangles = 6;
   X_RenderFreePicture = 7;
   X_RenderComposite = 8;
   X_RenderScale = 9;
   X_RenderTrapezoids = 10;
   X_RenderTriangles = 11;
   X_RenderTriStrip = 12;
   X_RenderTriFan = 13;
   X_RenderColorTrapezoids = 14;
   X_RenderColorTriangles = 15;
   X_RenderTransform = 16;
   X_RenderCreateGlyphSet = 17;
   X_RenderReferenceGlyphSet = 18;
   X_RenderFreeGlyphSet = 19;
   X_RenderAddGlyphs = 20;
   X_RenderAddGlyphsFromPicture = 21;
   X_RenderFreeGlyphs = 22;
   X_RenderCompositeGlyphs8 = 23;
   X_RenderCompositeGlyphs16 = 24;
   X_RenderCompositeGlyphs32 = 25;
   BadPictFormat = 0;
   BadPicture = 1;
   BadPictOp = 2;
   BadGlyphSet = 3;
   BadGlyph = 4;
   RenderNumberErrors = BadGlyph + 1;
   PictTypeIndexed = 0;
   PictTypeDirect = 1;
   PictOpClear = 0;
   PictOpSrc = 1;
   PictOpDst = 2;
   PictOpOver = 3;
   PictOpOverReverse = 4;
   PictOpIn = 5;
   PictOpInReverse = 6;
   PictOpOut = 7;
   PictOpOutReverse = 8;
   PictOpAtop = 9;
   PictOpAtopReverse = 10;
   PictOpXor = 11;
   PictOpAdd = 12;
   PictOpSaturate = 13;
   PictOpMaximum = 13;
   PolyEdgeSharp = 0;
   PolyEdgeSmooth = 1;
   PolyModePrecise = 0;
   PolyModeImprecise = 1;
   CPRepeat = 1 shl 0;
   CPAlphaMap = 1 shl 1;
   CPAlphaXOrigin = 1 shl 2;
   CPAlphaYOrigin = 1 shl 3;
   CPClipXOrigin = 1 shl 4;
   CPClipYOrigin = 1 shl 5;
   CPClipMask = 1 shl 6;
   CPGraphicsExposure = 1 shl 7;
   CPSubwindowMode = 1 shl 8;
   CPPolyEdge = 1 shl 9;
   CPPolyMode = 1 shl 10;
   CPDither = 1 shl 11;
   CPLastBit = 11;
type

   PXRenderDirectFormat = ^TXRenderDirectFormat;
   TXRenderDirectFormat = record
        red : smallint;
        redMask : smallint;
        green : smallint;
        greenMask : smallint;
        blue : smallint;
        blueMask : smallint;
        alpha : smallint;
        alphaMask : smallint;
     end;

   PXRenderPictFormat = ^TXRenderPictFormat;
   TXRenderPictFormat = record
        id : TPictFormat;
        _type : longint;
        depth : longint;
        direct : TXRenderDirectFormat;
        colormap : TColormap;
     end;

   TXRenderColor = record
     red   : cushort;
     green : cushort;
     blue  : cushort;
     alpha : cushort;
   end;

const
   PictFormatID = 1 shl 0;
   PictFormatType = 1 shl 1;
   PictFormatDepth = 1 shl 2;
   PictFormatRed = 1 shl 3;
   PictFormatRedMask = 1 shl 4;
   PictFormatGreen = 1 shl 5;
   PictFormatGreenMask = 1 shl 6;
   PictFormatBlue = 1 shl 7;
   PictFormatBlueMask = 1 shl 8;
   PictFormatAlpha = 1 shl 9;
   PictFormatAlphaMask = 1 shl 10;
   PictFormatColormap = 1 shl 11;
type

   PXRenderVisual = ^TXRenderVisual;
   TXRenderVisual = record
        visual : PVisual;
        format : PXRenderPictFormat;
     end;

   PXRenderDepth = ^TXRenderDepth;
   TXRenderDepth = record
        depth : longint;
        nvisuals : longint;
        visuals : PXRenderVisual;
     end;

   PXRenderScreen = ^TXRenderScreen;
   TXRenderScreen = record
        depths : PXRenderDepth;
        ndepths : longint;
        fallback : PXRenderPictFormat;
     end;

   PXRenderInfo = ^TXRenderInfo;
   TXRenderInfo = record
        format : PXRenderPictFormat;
        nformat : longint;
        screen : PXRenderScreen;
        nscreen : longint;
        depth : PXRenderDepth;
        ndepth : longint;
        visual : PXRenderVisual;
        nvisual : longint;
     end;

   PXRenderPictureAttributes = ^TXRenderPictureAttributes;
   TXRenderPictureAttributes = record
        _repeat : TBool;
        alpha_map : TPicture;
        alpha_x_origin : longint;
        alpha_y_origin : longint;
        clip_x_origin : longint;
        clip_y_origin : longint;
        clip_mask : TPixmap;
        graphics_exposures : TBool;
        subwindow_mode : longint;
        poly_edge : longint;
        poly_mode : longint;
        dither : TAtom;
     end;

   PXGlyphInfo = ^TXGlyphInfo;
   TXGlyphInfo = record
        width : cushort;
        height : cushort;
        x : cshort;
        y : cshort;
        xOff : cshort;
        yOff : cshort;
     end;  

// render methods
var XRenderSetPictureClipRectangles: procedure(disp: PXDisplay; pic: TPicture; xorigin, yorigin: integer; rect: PXRectangle; num: integer); cdecl;
var XRenderQueryExtension: function(dpy:PDisplay; event_basep:Plongint; error_basep:Plongint):TBoolResult;cdecl;
var XRenderQueryVersion: function(dpy:PDisplay; major_versionp:Plongint; minor_versionp:Plongint):TStatus;cdecl;
var XRenderQueryFormats: function(dpy:PDisplay):TStatus;cdecl;
var XRenderFindVisualFormat: function(dpy:PDisplay; visual:PVisual):PXRenderPictFormat;cdecl;
var XRenderFindFormat: function(dpy:PDisplay; mask:dword; template:PXRenderPictFormat; count:longint):PXRenderPictFormat;cdecl;
var XRenderCreatePicture: function(dpy:PDisplay; drawable:TDrawable; format:PXRenderPictFormat; valuemask:dword; attributes:PXRenderPictureAttributes):TPicture;cdecl;
var XRenderChangePicture: procedure(dpy:PDisplay; picture:TPicture; valuemask:dword; attributes:PXRenderPictureAttributes);cdecl;
var XRenderFreePicture: procedure(dpy:PDisplay; picture:TPicture);cdecl;
var XRenderComposite: procedure(dpy:PDisplay; op:longint; src:TPicture; mask:TPicture; dst:TPicture;
            src_x:longint; src_y:longint; mask_x:longint; mask_y:longint; dst_x:longint;
            dst_y:longint; width:dword; height:dword);cdecl;
var XRenderCreateGlyphSet: function(dpy:PDisplay; format:PXRenderPictFormat):TGlyphSet;cdecl;
var XRenderReferenceGlyphSet: function(dpy:PDisplay; existing:TGlyphSet):TGlyphSet;cdecl;
var XRenderFreeGlyphSet: procedure(dpy:PDisplay; glyphset:TGlyphSet);cdecl;
var XRenderAddGlyphs: procedure(dpy:PDisplay; glyphset:TGlyphSet; gids:PGlyph; glyphs:PXGlyphInfo; nglyphs:longint;
            images:Pchar; nbyte_images:longint);cdecl;
var XRenderFreeGlyphs: procedure(dpy:PDisplay; glyphset:TGlyphSet; gids:PGlyph; nglyphs:longint);cdecl;
var XRenderCompositeString8: procedure(dpy:PDisplay; op:longint; src:TPicture; dst:TPicture; maskFormat:PXRenderPictFormat;
            glyphset:TGlyphSet; xSrc:longint; ySrc:longint; xDst:longint; yDst:longint;
            _string:Pchar; nchar:longint);cdecl;

 var xren_Handle:TLibHandle=dynlibs.NilHandle; // this will hold our handle for the lib; it functions nicely as a mutli-lib prevention unit as well...

    var ReferenceCounter : cardinal = 0;  // Reference counter
         
    function xren_IsLoaded() : boolean; inline; 

    Function xren_Load(const libfilename:string = libXren) :boolean; // load the lib

    Procedure xren_Unload(); // unload and frees the lib from memory : do not forget to call it before close application.

implementation

function xren_IsLoaded(): boolean;
begin
 Result := (xren_Handle <> dynlibs.NilHandle);
end;

Function xren_Load (const libfilename:string = libXren) :boolean;
begin
  Result := False;
  if xren_Handle<>0 then 
begin
 Inc(ReferenceCounter);
 result:=true {is it already there ?}
end  else 
begin {go & load the library}
    if Length(libfilename) = 0 then exit;
    xren_Handle:=DynLibs.SafeLoadLibrary(libfilename); // obtain the handle we want
  	if xren_Handle <> DynLibs.NilHandle then
begin {now we tie the functions to the VARs from above}

 Pointer(XRenderQueryExtension):=DynLibs.GetProcedureAddress(xren_Handle,PChar('XRenderQueryExtension'));
 Pointer(XRenderQueryVersion):=DynLibs.GetProcedureAddress(xren_Handle,PChar('XRenderQueryVersion'));
 Pointer(XRenderQueryFormats):=DynLibs.GetProcedureAddress(xren_Handle,PChar('XRenderQueryFormats'));
 Pointer(XRenderFindVisualFormat):=DynLibs.GetProcedureAddress(xren_Handle,PChar('XRenderFindVisualFormat'));
 Pointer(XRenderFindFormat):=DynLibs.GetProcedureAddress(xren_Handle,PChar('XRenderFindFormat'));
 Pointer(XRenderCreatePicture):=DynLibs.GetProcedureAddress(xren_Handle,PChar('XRenderCreatePicture'));
 Pointer(XRenderChangePicture):=DynLibs.GetProcedureAddress(xren_Handle,PChar('XRenderChangePicture'));
 Pointer(XRenderFreePicture):=DynLibs.GetProcedureAddress(xren_Handle,PChar('XRenderFreePicture'));
 Pointer(XRenderComposite):=DynLibs.GetProcedureAddress(xren_Handle,PChar('XRenderComposite'));
 Pointer(XRenderCreateGlyphSet):=DynLibs.GetProcedureAddress(xren_Handle,PChar('XRenderCreateGlyphSet'));
 Pointer(XRenderReferenceGlyphSet):=DynLibs.GetProcedureAddress(xren_Handle,PChar('XRenderReferenceGlyphSet'));
 Pointer(XRenderFreeGlyphSet):=DynLibs.GetProcedureAddress(xren_Handle,PChar('XRenderFreeGlyphSet'));
 Pointer(XRenderAddGlyphs):=DynLibs.GetProcedureAddress(xren_Handle,PChar('XRenderAddGlyphs'));
 Pointer(XRenderFreeGlyphs):=DynLibs.GetProcedureAddress(xren_Handle,PChar('XRenderFreeGlyphs'));
 Pointer(XRenderCompositeString8):=DynLibs.GetProcedureAddress(xren_Handle,PChar('XRenderCompositeString8'));
 Pointer(XRenderSetPictureClipRectangles):=DynLibs.GetProcedureAddress(x_Handle,PChar('XRenderSetPictureClipRectangles'));
 
end;
   Result := xren_IsLoaded();
   ReferenceCounter:=1;   
end;

end;

Procedure xren_Unload();
begin
// < Reference counting
  if ReferenceCounter > 0 then
    dec(ReferenceCounter);
  if ReferenceCounter > 0 then
    exit;
  // >
  if xren_IsLoaded() then
  begin
  if xren_Handle <> DynLibs.NilHandle then 
    DynLibs.UnloadLibrary(xren_Handle);
    xren_Handle:=DynLibs.NilHandle;
  end;
end;

end.   
