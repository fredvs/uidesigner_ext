{ Chrome Style
by Fred van Stappen
fiens@hotmail.com
}

unit style_chrome_gray;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpg_main, fpg_base;

type

  TMyStyle = class(TfpgStyle)
  public
    constructor Create; override;
    { General }
    procedure DrawControlFrame(ACanvas: TfpgCanvas; x, y, w, h: TfpgCoord); override;
    { Buttons }
    procedure DrawButtonFace(ACanvas: TfpgCanvas; x, y, w, h: TfpgCoord;
      AFlags: TfpgButtonFlags); override;
    { Menus }
    procedure DrawMenuRow(ACanvas: TfpgCanvas; r: TfpgRect;
      AFlags: TfpgMenuItemFlags); override;
    procedure DrawMenuBar(ACanvas: TfpgCanvas; r: TfpgRect;
      ABackgroundColor: TfpgColor); override;
  end;


implementation

uses
  fpg_stylemanager;

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

procedure TMyStyle.DrawButtonFace(ACanvas: TfpgCanvas; x, y, w, h: TfpgCoord;
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
   ACanvas.SetColor(clblack);
//       ACanvas.SetColor(cldarkgray);
  ACanvas.DrawRectangle(r);

  // so we don't paint over the border
  InflateRect(r, -1, -1);
  // now paint the face of the button
  if (btfIsPressed in AFlags) then
  begin
    ACanvas.GradientFill(r21, clsilver, clwhite, gdVertical);
    ACanvas.GradientFill(r22, clwhite, clsilver, gdVertical);
  //    ACanvas.SetColor(clblack);
       ACanvas.SetColor(cldarkgray);
    ACanvas.DrawRectangle(r);
     InflateRect(r, -1, -1);
    ACanvas.SetColor(cllime);
    ACanvas.DrawRectangle(r);
  end
  else
  begin
    ACanvas.GradientFill(r21, clgray, clwhite, gdVertical);
    ACanvas.GradientFill(r22, clwhite, clgray, gdVertical);
  //    ACanvas.SetColor(clblack);
       ACanvas.SetColor(cldarkgray);
    ACanvas.DrawRectangle(r);
  end;
end;

procedure TMyStyle.DrawMenuRow(ACanvas: TfpgCanvas; r: TfpgRect;
  AFlags: TfpgMenuItemFlags);
var
  r21, r22: TfpgRect;
begin
  r21.Height := r.Height div 2;
  r21.Width := r.Width;
  r21.Top := r.top;
  r21.Left := r.Left;

  r22.Height := r.Height div 2;
  r22.Width := r.Width;
  r22.Top := r.top + r22.Height;
  r22.Left := r.Left;

  inherited DrawMenuRow(ACanvas, r, AFlags);
  if (mifSelected in AFlags) and not (mifSeparator in AFlags) then
  begin
    ACanvas.GradientFill(r21, clgray, clwhite, gdVertical);
    ACanvas.GradientFill(r22, clwhite, clgray, gdVertical);
  //    ACanvas.SetColor(clblack);
       ACanvas.SetColor(cldarkgray);
    ACanvas.DrawRectangle(r);
    ACanvas.SetTextColor(clblack);
     InflateRect(r, -1, -1);
    ACanvas.SetColor(cllime);
    ACanvas.DrawRectangle(r);
  end;
end;

procedure TMyStyle.DrawMenuBar(ACanvas: TfpgCanvas; r: TfpgRect;
  ABackgroundColor: TfpgColor);
var
  FLightColor: TfpgColor;
  FDarkColor: TfpgColor;
begin
  // a possible future theme option
  FLightColor := TfpgColor($f0ece3);  // color at top of menu bar
  FDarkColor := TfpgColor($beb8a4);  // color at bottom of menu bar
  //  ACanvas.GradientFill(r, FLightColor, FDarkColor, gdVertical);

  ACanvas.GradientFill(r, clgridheader, clhilite1, gdVertical);

  // inner bottom line
  ACanvas.SetColor(clShadow1);
  ACanvas.DrawLine(r.Left, r.Bottom - 1, r.Right + 1, r.Bottom - 1);   // bottom
  // outer bottom line
  ACanvas.SetColor(clWhite);
  ACanvas.DrawLine(r.Left, r.Bottom, r.Right + 1, r.Bottom);   // bottom
end;


initialization
  fpgStyleManager.RegisterClass('Chrome gray', TMyStyle);

end.
