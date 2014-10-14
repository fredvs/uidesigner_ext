{ fpGUI style which load native system palette on Windows and unix

  Copyright (C) 2013 Krzysztof Dibowski dibowski_at_interia.pl

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version with the following modification:

  As a special exception, the copyright holders of this library give you
  permission to link this library with independent modules to produce an
  executable, regardless of the license terms of these independent modules,and
  to copy and distribute the resulting executable under terms of your choice,
  provided that you also meet, for each linked independent module, the terms
  and conditions of the license of that module. An independent module is a
  module which is not derived from or based on this library. If you modify
  this library, you may extend this exception to your version of the library,
  but you are not obligated to do so. If you do not wish to do so, delete this
  exception statement from your version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
}

{
Ellipse Style by Fred van Stappen
fiens@hotmail.com
}
unit fpg_style_ellipse_system;

{$mode objfpc}{$H+}

interface

uses
  Classes, fpg_main, fpg_base;

type

  { TSystemColorsMyStyle }

  TExtStyle = class(TfpgStyle)
  private
    {$IFDEF unix}
    procedure LoadGtkPalette;
    {$ENDIF}
    {$IFDEF WINDOWS}
    procedure LoadWindowsPalette;
    {$ENDIF}
  public
     procedure DrawControlFrame(ACanvas: TfpgCanvas; x, y, w, h: TfpgCoord); override;
    { Buttons }
    procedure DrawButtonFace(ACanvas: TfpgCanvas; x, y, w, h: TfpgCoord;
      AFlags: TfpgButtonFlags); override;
    { Menus }
       function   HasButtonHoverEffect: boolean; override;

    constructor Create; override;

  end;


implementation

uses
  fpg_stylemanager, {$IFDEF unix}fpg_gtk{$ELSE}{$IFDEF WINDOWS}fpg_WinAPI{$ENDIF}{$ENDIF};

{ TExtStyle }

function TExtStyle.HasButtonHoverEffect: boolean;
begin
  Result := True;
end;

procedure TExtStyle.DrawControlFrame(ACanvas: TfpgCanvas; x, y, w, h: TfpgCoord);
var
  r: TfpgRect;
begin
  r.SetRect(x, y, w, h);
  ACanvas.SetColor(clShadow1);
  ACanvas.Clear(clWindowBackground);
  ACanvas.DrawRectangle(r);
end;

procedure TExtStyle.DrawButtonFace(ACanvas: TfpgCanvas; x, y, w, h: TfpgCoord;
  AFlags: TfpgButtonFlags);
var
  r, r21, r22: TfpgRect;
begin
  r.SetRect(x, y, w, h);

  r21.SetRect(x, y, w, h div 2);

  r22.SetRect(x, y + (h div 2), w, h div 2);

  if btfIsDefault in AFlags then
  begin
    ACanvas.SetColor(TfpgColor($7b7b7b));
    ACanvas.SetLineStyle(1, lsSolid);
    ACanvas.DrawRectangle(r);
    InflateRect(r, -1, -1);
    Exclude(AFlags, btfIsDefault);
    fpgStyle.DrawButtonFace(ACanvas, r.Left, r.Top, r.Width, r.Height, AFlags);
    Exit; //==>
  end;

  // Clear the canvas
  ACanvas.SetColor(clWindowBackground);
  ACanvas.FillRectangle(r);

  if (btfFlat in AFlags) and not (btfIsPressed in AFlags) then
    Exit; // no need to go further

  // outer rectangle
  ACanvas.SetLineStyle(1, lsSolid);
 // ACanvas.SetColor(TfpgColor($a6a6a6));
   ACanvas.SetColor(clblack);
  //  ACanvas.SetColor(clred);
  ACanvas.DrawRectangle(r);

    // so we don't paint over the border
  InflateRect(r, -1, -1);
  // now paint the face of the button
  if (btfIsPressed in AFlags) or (btfHover in AFlags) then
  begin
    ACanvas.GradientFill(r21, clHilite1, clwhite, gdVertical);
    ACanvas.GradientFill(r22, clwhite, clHilite1, gdVertical);
  //    ACanvas.SetColor(clblack);
       ACanvas.SetColor(cldarkgray);
    ACanvas.DrawRectangle(r);
     InflateRect(r, -1, -1);
       if (btfHover in AFlags)  then   ACanvas.SetColor(clyellow) else   ACanvas.SetColor(cllime);
      ACanvas.DrawRectangle(r);
  end
  else
  begin

    ACanvas.GradientFill(r21, clWindowBackground, clwhite, gdVertical);
    ACanvas.GradientFill(r22, clwhite, clWindowBackground, gdVertical);
  //    ACanvas.SetColor(clblack);
       ACanvas.SetColor(cldarkgray);
    ACanvas.DrawRectangle(r);


  end;
    ACanvas.SetColor(clWindowBackground);
//  ACanvas.SetColor(cldarkgray);
    acanvas.DrawLine(0,1,1,0);
    acanvas.DrawLine(0,2,2,0);
  // ACanvas.SetColor(clgray);
    acanvas.DrawLine(0,3,3,0);
    acanvas.DrawLine(0,4,4,0);
  //  ACanvas.SetColor(clgray);
    acanvas.DrawLine(0,5,5,0);
     ACanvas.SetColor(cldarkgray);
   acanvas.DrawLine(0,6,6,0);

   ACanvas.SetColor(clWindowBackground);
  //  ACanvas.SetColor(cldarkgray);
    acanvas.DrawLine(w,1,w-1,0);
    acanvas.DrawLine(w,2,w-2,0);
  // ACanvas.SetColor(clgray);
    acanvas.DrawLine(w,3,w-3,0);
    acanvas.DrawLine(w,4,w-4,0);
  // ACanvas.SetColor(clgray);
    acanvas.DrawLine(w,5,w-5,0);
     ACanvas.SetColor(cldarkgray);
    acanvas.DrawLine(w,6,w-6,0);

    ACanvas.SetColor(clWindowBackground);
     acanvas.DrawLine(0,h-1,1,h);
    acanvas.DrawLine(0,h-2,2,h);
  // ACanvas.SetColor(clgray);
    acanvas.DrawLine(0,h-3,3,h);
    acanvas.DrawLine(0,h-4,4,h);
    //ACanvas.SetColor(clgray);
    acanvas.DrawLine(0,h-5,5,h);
    ACanvas.SetColor(cldarkgray);
   acanvas.DrawLine(0,h-6,6,h);



     ACanvas.SetColor(clgray);
    acanvas.DrawLine(w,h-6,w-6,h);
  ACanvas.SetColor(clWindowBackground);
   acanvas.DrawLine(w,h-5,w-5,h);
       acanvas.DrawLine(w-4,h,w,h-4);
     acanvas.DrawLine(w-3,h,w,h-3);
        ACanvas.SetColor(clgray);
      acanvas.DrawLine(w-2,h,w,h-2);
       acanvas.DrawLine(w-1,h,w,h-1);


    InflateRect(r, 1, 1);
       ACanvas.SetColor(clWindowBackground);
    ACanvas.DrawRectangle(r);
end;


{$IFDEF unix}
procedure TExtStyle.LoadGtkPalette;
var
  w: fpg_gtk.PGtkWidget=nil;
  st: fpg_gtk.PGtkStyle=nil;
begin
  try
    if not LoadGtkLib then Exit;

    fpg_gtk.gtk_init(@argc, @argv);
    w := fpg_gtk.gtk_window_new(0);
    if w=nil then Exit;
    fpg_gtk.gtk_window_resize(w,1,1);
    fpg_gtk.gtk_widget_show(w);
    st := fpg_gtk.gtk_widget_get_style(w);
    fpg_gtk.gtk_widget_hide(w);

    if st<>nil then
    begin
      fpgSetNamedColor(clWindowBackground,
        fpgColor(st^.bg[GTK_STATE_NORMAL].red div 256, st^.bg[GTK_STATE_NORMAL].green div 256, st^.bg[GTK_STATE_NORMAL].blue div 256));
      fpgSetNamedColor(clButtonFace,
        fpgColor(st^.bg[GTK_STATE_INSENSITIVE].red div 256, st^.bg[GTK_STATE_INSENSITIVE].green div 256, st^.bg[GTK_STATE_INSENSITIVE].blue div 256));
      fpgSetNamedColor(clShadow1,
        fpgColor(st^.fg[GTK_STATE_INSENSITIVE].red div 256, st^.fg[GTK_STATE_INSENSITIVE].green div 256, st^.fg[GTK_STATE_INSENSITIVE].blue div 256));
      fpgSetNamedColor(clShadow2,
        fpgColor(st^.dark[GTK_STATE_INSENSITIVE].red div 256, st^.dark[GTK_STATE_INSENSITIVE].green div 256, st^.dark[GTK_STATE_INSENSITIVE].blue div 256));
      fpgSetNamedColor(clSelection,
        fpgColor(st^.base[GTK_STATE_SELECTED].red div 256, st^.base[GTK_STATE_SELECTED].green div 256, st^.base[GTK_STATE_SELECTED].blue div 256));
      fpgSetNamedColor(clSelectionText,
        fpgColor(st^.text[GTK_STATE_SELECTED].red div 256, st^.text[GTK_STATE_SELECTED].green div 256, st^.text[GTK_STATE_SELECTED].blue div 256));
      fpgSetNamedColor(clText1,
        fpgColor(st^.text[GTK_STATE_NORMAL].red div 256, st^.text[GTK_STATE_NORMAL].green div 256, st^.text[GTK_STATE_NORMAL].blue div 256));
      fpgSetNamedColor(clGridSelection,
        fpgColor(st^.base[GTK_STATE_SELECTED].red div 256, st^.base[GTK_STATE_SELECTED].green div 256, st^.base[GTK_STATE_SELECTED].blue div 256));
      fpgSetNamedColor(clGridSelectionText,
        fpgColor(st^.text[GTK_STATE_SELECTED].red div 256, st^.text[GTK_STATE_SELECTED].green div 256, st^.text[GTK_STATE_SELECTED].blue div 256));
      fpgSetNamedColor(clGridInactiveSel,
        fpgColor(st^.text_aa[GTK_STATE_SELECTED].red div 256, st^.text_aa[GTK_STATE_SELECTED].green div 256, st^.text_aa[GTK_STATE_SELECTED].blue div 256));
      fpgSetNamedColor(clGridInactiveSelText,
        fpgColor(st^.text[GTK_STATE_NORMAL].red div 256, st^.text[GTK_STATE_NORMAL].green div 256, st^.text[GTK_STATE_NORMAL].blue div 256));
      fpgSetNamedColor(clInactiveSel,
        fpgColor(st^.text_aa[GTK_STATE_SELECTED].red div 256, st^.text_aa[GTK_STATE_SELECTED].green div 256, st^.text_aa[GTK_STATE_SELECTED].blue div 256));
      fpgSetNamedColor(clInactiveSelText,
        fpgColor(st^.text[GTK_STATE_NORMAL].red div 256, st^.text[GTK_STATE_NORMAL].green div 256, st^.text[GTK_STATE_NORMAL].blue div 256));
      fpgSetNamedColor(clBoxColor,
        fpgColor(st^.base[GTK_STATE_NORMAL].red div 256, st^.base[GTK_STATE_NORMAL].green div 256, st^.base[GTK_STATE_NORMAL].blue div 256));
      fpgSetNamedColor(clListBox,
        fpgColor(st^.base[GTK_STATE_NORMAL].red div 256, st^.base[GTK_STATE_NORMAL].green div 256, st^.base[GTK_STATE_NORMAL].blue div 256));
      fpgSetNamedColor(clGridLines,
        fpgColor(st^.mid[GTK_STATE_NORMAL].red div 256, st^.mid[GTK_STATE_NORMAL].green div 256, st^.mid[GTK_STATE_NORMAL].blue div 256));
      fpgSetNamedColor(clSplitterGrabBar,
        fpgColor(st^.bg[GTK_STATE_ACTIVE].red div 256, st^.bg[GTK_STATE_ACTIVE].green div 256, st^.bg[GTK_STATE_ACTIVE].blue div 256));
      fpgSetNamedColor(clHilite2,
        fpgColor(st^.light[GTK_STATE_NORMAL].red div 256, st^.light[GTK_STATE_NORMAL].green div 256, st^.light[GTK_STATE_NORMAL].blue div 256));
      fpgSetNamedColor(clHilite1,
        fpgColor(st^.mid[GTK_STATE_NORMAL].red div 256, st^.mid[GTK_STATE_NORMAL].green div 256, st^.mid[GTK_STATE_NORMAL].blue div 256));
      fpgSetNamedColor(clScrollBar,
        fpgColor(st^.bg[GTK_STATE_ACTIVE].red div 256, st^.bg[GTK_STATE_ACTIVE].green div 256, st^.bg[GTK_STATE_ACTIVE].blue div 256));
      fpgSetNamedColor(clHintWindow,
        fpgColor(st^.dark[GTK_STATE_NORMAL].red div 256, st^.dark[GTK_STATE_NORMAL].green div 256, st^.dark[GTK_STATE_NORMAL].blue div 256));
      fpgSetNamedColor(clTextCursor,
        fpgColor(st^.text[GTK_STATE_NORMAL].red div 256, st^.text[GTK_STATE_NORMAL].green div 256, st^.text[GTK_STATE_NORMAL].blue div 256));
    end;
  finally
    if w<>nil then
      fpg_gtk.gtk_widget_destroy(w);
    UnloadGtkLib;
  end;
end;
{$ENDIF}

{$IFDEF WINDOWS}
procedure TExtStyle.LoadWindowsPalette;
var
  c: DWord;

  function GetRValue(rgb : longint) : BYTE;
  begin
    Result := BYTE(rgb);
  end;
  function GetGValue(rgb : longint) : BYTE;
  begin
    Result := BYTE((WORD(rgb)) shr 8);
  end;
  function GetBValue(rgb : longint) : BYTE;
  begin
    Result := BYTE(rgb shr 16);
  end;

begin
  try
    if not LoadUser32Lib then Exit;

    c := fpg_WinAPI.GetSysColor(COLOR_BTNFACE);
    fpgSetNamedColor(clWindowBackground,
      fpgColor(GetRValue(c), GetGValue(c), GetBValue(c)));
    fpgSetNamedColor(clButtonFace,
      fpgColor(GetRValue(c), GetGValue(c), GetBValue(c)));
    c := fpg_WinAPI.GetSysColor(COLOR_GRAYTEXT);
    fpgSetNamedColor(clShadow1,
      fpgColor(GetRValue(c), GetGValue(c), GetBValue(c)));
    c := fpg_WinAPI.GetSysColor(COLOR_BTNSHADOW);
    fpgSetNamedColor(clShadow2,
      fpgColor(GetRValue(c), GetGValue(c), GetBValue(c)));
    c := fpg_WinAPI.GetSysColor(COLOR_HIGHLIGHT);
    fpgSetNamedColor(clSelection,
      fpgColor(GetRValue(c), GetGValue(c), GetBValue(c)));
    c := fpg_WinAPI.GetSysColor(COLOR_HIGHLIGHTTEXT);
    fpgSetNamedColor(clSelectionText,
      fpgColor(GetRValue(c), GetGValue(c), GetBValue(c)));
    c := fpg_WinAPI.GetSysColor(COLOR_CAPTIONTEXT);
    fpgSetNamedColor(clText1,
      fpgColor(GetRValue(c), GetGValue(c), GetBValue(c)));
    c := fpg_WinAPI.GetSysColor(COLOR_HIGHLIGHT);
    fpgSetNamedColor(clGridSelection,
      fpgColor(GetRValue(c), GetGValue(c), GetBValue(c)));
    c := fpg_WinAPI.GetSysColor(COLOR_HIGHLIGHTTEXT);
    fpgSetNamedColor(clGridSelectionText,
      fpgColor(GetRValue(c), GetGValue(c), GetBValue(c)));
    c := fpg_WinAPI.GetSysColor(COLOR_GRAYTEXT); // could not find correct color for this one
    fpgSetNamedColor(clGridInactiveSel,
      fpgColor(GetRValue(c), GetGValue(c), GetBValue(c)));
    c := fpg_WinAPI.GetSysColor(COLOR_HIGHLIGHTTEXT);
    fpgSetNamedColor(clGridInactiveSelText,
      fpgColor(GetRValue(c), GetGValue(c), GetBValue(c)));
    c := fpg_WinAPI.GetSysColor(COLOR_GRAYTEXT); // could not find correct color for this one
    fpgSetNamedColor(clInactiveSel,
      fpgColor(GetRValue(c), GetGValue(c), GetBValue(c)));
    c := fpg_WinAPI.GetSysColor(COLOR_HIGHLIGHTTEXT);
    fpgSetNamedColor(clInactiveSelText,
      fpgColor(GetRValue(c), GetGValue(c), GetBValue(c)));
    c := fpg_WinAPI.GetSysColor(COLOR_WINDOW);
    fpgSetNamedColor(clBoxColor,
      fpgColor(GetRValue(c), GetGValue(c), GetBValue(c)));
    c := fpg_WinAPI.GetSysColor(COLOR_WINDOW);
    fpgSetNamedColor(clListBox,
      fpgColor(GetRValue(c), GetGValue(c), GetBValue(c)));
    c := fpg_WinAPI.GetSysColor(COLOR_BTNHIGHLIGHT);
    fpgSetNamedColor(clGridLines,
      fpgColor(GetRValue(c), GetGValue(c), GetBValue(c)));
    c := fpg_WinAPI.GetSysColor(COLOR_BTNHIGHLIGHT);
    fpgSetNamedColor(clSplitterGrabBar,
      fpgColor(GetRValue(c), GetGValue(c), GetBValue(c)));
    c := fpg_WinAPI.GetSysColor(COLOR_BTNHIGHLIGHT);
    fpgSetNamedColor(clHilite2,
      fpgColor(GetRValue(c), GetGValue(c), GetBValue(c)));
    c := fpg_WinAPI.GetSysColor(COLOR_BTNFACE);
    fpgSetNamedColor(clHilite1,
      fpgColor(GetRValue(c), GetGValue(c), GetBValue(c)));
    c := fpg_WinAPI.GetSysColor(COLOR_SCROLLBAR);
    fpgSetNamedColor(clScrollBar,
      fpgColor(GetRValue(c), GetGValue(c), GetBValue(c)));
    c := fpg_WinAPI.GetSysColor(COLOR_INFOBK);
    fpgSetNamedColor(clHintWindow,
      fpgColor(GetRValue(c), GetGValue(c), GetBValue(c)));
    c := fpg_WinAPI.GetSysColor(COLOR_CAPTIONTEXT);
    fpgSetNamedColor(clTextCursor,
      fpgColor(GetRValue(c), GetGValue(c), GetBValue(c)));
  finally
    UnloadUser32Lib;

 end;
end;
{$ENDIF}

constructor TExtStyle.Create;
begin
  inherited Create;
  {$IFDEF unix}
  LoadGtkPalette;
  {$ENDIF}
  {$IFDEF WINDOWS}
  LoadWindowsPalette;
  {$ENDIF}
end;


initialization
  fpgStyleManager.RegisterClass('Ellipse system', TExtStyle);

end.

