{
Hoover Style by Fred van Stappen
fiens@hotmail.com
}
unit fpg_style_hoover_silver;

{$mode objfpc}{$H+}

interface

uses
  Classes, fpg_main, fpg_base;

type

    TExtStyle = class(TfpgStyle)
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
      function    HasButtonHoverEffect: boolean; override;
  end;


implementation

uses
  fpg_stylemanager;

constructor TExtStyle.Create;
begin
  inherited Create;
//  fpgSetNamedColor(clWindowBackground, TfpgColor($eeeeec));
fpgSetNamedColor(clWindowBackground, clLightGray);
end;

function TExtStyle.HasButtonHoverEffect: boolean;
begin
  Result := true;
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


    ACanvas.SetColor(clWindowBackground);
  ACanvas.FillRectangle(r);

  if (btfFlat in AFlags) and not (btfIsPressed in AFlags) then
    Exit; 

  if (btfIsPressed in AFlags) or (btfHover in AFlags) then
  begin

    // outer rectangle
    ACanvas.SetLineStyle(1, lsSolid);
   // ACanvas.SetColor(TfpgColor($a6a6a6));
     ACanvas.SetColor(clblack);
    ACanvas.DrawRectangle(r);

    // so we don't paint over the border
    InflateRect(r, -1, -1);
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

   //    ACanvas.SetColor(cldarkgray);
   //  ACanvas.DrawRectangle(r);
  end;
end;
procedure TExtStyle.DrawMenuRow(ACanvas: TfpgCanvas; r: TfpgRect;
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
  ACanvas.SetColor(clwhite);
  ACanvas.FillRectangle(r);
  inherited DrawMenuRow(ACanvas, r, AFlags);
  if (mifSelected in AFlags) and not (mifSeparator in AFlags) then
  begin
    ACanvas.GradientFill(r21, clsilver, clwhite, gdVertical);
    ACanvas.GradientFill(r22, clwhite, clsilver, gdVertical);
     ACanvas.SetColor(cldarkgray);
       ACanvas.SetTextColor(clblack);
    ACanvas.DrawRectangle(r);
     InflateRect(r, -1, -1);
    ACanvas.SetColor(cllime);
    ACanvas.DrawRectangle(r);
  end;
end;


initialization
  fpgStyleManager.RegisterClass('Flat-Hoover silver', TExtStyle);

end.

