{Mint Style
by Fred van Stappen
fiens@hotmail.com
}

unit fpgstyle_mint1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpg_main, fpg_base;

type

  TMyStyle = class(TfpgStyle)
  public
    constructor Create; override;
    { General }
    procedure   DrawControlFrame(ACanvas: TfpgCanvas; x, y, w, h: TfpgCoord); override;
    { Buttons }
    procedure   DrawButtonFace(ACanvas: TfpgCanvas; x, y, w, h: TfpgCoord; AFlags: TfpgButtonFlags); override;
    { Menus }
    procedure   DrawMenuRow(ACanvas: TfpgCanvas; r: TfpgRect; AFlags: TfpgMenuItemFlags); override;
    procedure   DrawMenuBar(ACanvas: TfpgCanvas; r: TfpgRect; ABackgroundColor: TfpgColor); override;
  end;


implementation

uses
  fpg_stylemanager ;

{ TMyStyle }

constructor TMyStyle.Create;
begin
  inherited Create;
  fpgSetNamedColor(clWindowBackground, TfpgColor($eeeeec));
end;

procedure TMyStyle.DrawControlFrame(ACanvas: TfpgCanvas; x, y, w, h: TfpgCoord);
var
  r: TfpgRect;
begin
  r.SetRect(x, y, w, h);
  ACanvas.SetColor(clShadow1);
  ACanvas.Clear(clWindowBackground);
  ACanvas.DrawRectangle(r);
end;

procedure TMyStyle.DrawButtonFace(ACanvas: TfpgCanvas; x, y, w, h: TfpgCoord; AFlags: TfpgButtonFlags);
var
  r: TfpgRect;
begin
  r.SetRect(x, y, w, h);

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
  ACanvas.SetColor(TfpgColor($a6a6a6));
  ACanvas.DrawRectangle(r);

  // so we don't paint over the border
  InflateRect(r, -1, -1);
  // now paint the face of the button
  if (btfIsPressed in AFlags) then
  begin
    ACanvas.GradientFill(r, TfpgColor($cccccc), TfpgColor($e4e4e4), gdVertical);
  end
  else
  begin
    ACanvas.GradientFill(r, TfpgColor($fafafa), TfpgColor($e2e2e2), gdVertical);
    ACanvas.SetColor(TfpgColor($cccccc));
    ACanvas.DrawLine(r.Right, r.Top, r.Right, r.Bottom);   // right
    ACanvas.DrawLine(r.Right, r.Bottom, r.Left, r.Bottom);   // bottom
  end;
end;

procedure TMyStyle.DrawMenuRow(ACanvas: TfpgCanvas; r: TfpgRect; AFlags: TfpgMenuItemFlags);
begin
   ACanvas.SetColor(clwhite);
  ACanvas.FillRectangle(r);
  inherited DrawMenuRow(ACanvas, r, AFlags);
  if (mifSelected in AFlags) and not (mifSeparator in AFlags) then
  begin
 //   ACanvas.GradientFill(r, TfpgColor($fec475), TfpgColor($fb9d24), gdVertical);
   ACanvas.GradientFill(r, cldarkseagreen, clolivedrab,  gdVertical);
      ACanvas.SetTextColor(clwhite);
  //    ACanvas.SetColor(clblack);
       ACanvas.SetColor(cldarkgray);
    ACanvas.DrawRectangle(r);
     InflateRect(r, -1, -1);
    ACanvas.SetColor(cllime);
    ACanvas.DrawRectangle(r);
  end;
end;

procedure TMyStyle.DrawMenuBar(ACanvas: TfpgCanvas; r: TfpgRect; ABackgroundColor: TfpgColor);
var
  FLightColor: TfpgColor;
  FDarkColor: TfpgColor;
begin
  // a possible future theme option
  FLightColor := TfpgColor($f0ece3);  // color at top of menu bar
  FDarkColor  := TfpgColor($beb8a4);  // color at bottom of menu bar
//  ACanvas.GradientFill(r, FLightColor, FDarkColor, gdVertical);

  ACanvas.GradientFill(r, clgridheader, clhilite1, gdVertical);

  // inner bottom line
  ACanvas.SetColor(clShadow1);
  ACanvas.DrawLine(r.Left, r.Bottom-1, r.Right+1, r.Bottom-1);   // bottom
  // outer bottom line
  ACanvas.SetColor(clWhite);
  ACanvas.DrawLine(r.Left, r.Bottom, r.Right+1, r.Bottom);   // bottom
end;


initialization
  fpgStyleManager.RegisterClass('Mint 1', TMyStyle);

end.

