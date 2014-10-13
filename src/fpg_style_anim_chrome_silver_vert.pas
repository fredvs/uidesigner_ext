{Annimated Chrome Style
by Fred van Stappen
fiens@hotmail.com
}

unit fpg_style_anim_chrome_silver_vert;

{$mode objfpc}{$H+}

interface

uses
  Classes, fpg_main, fpg_base;

type

  TExtStyle = class(TfpgStyle)
  private
    fadein : boolean;
     FTimer: TfpgTimer;
      i: integer;
    fbutton: TfpgWindowBase;
    procedure   TimerFired(Sender: TObject);

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
    function   HasButtonHoverEffect: boolean; override;

  end;


implementation

uses
  fpg_stylemanager,
   fpg_widget;

{ TExtStyle }

constructor TExtStyle.Create;
begin
  inherited Create;
//  fpgSetNamedColor(clWindowBackground, TfpgColor($eeeeec));
  fpgSetNamedColor(clWindowBackground, clLightGray);
  FTimer := TfpgTimer.Create(200);
  FTimer.OnTimer := @TimerFired;
  i := 2;
end;

procedure TExtStyle.TimerFired(Sender: TObject);
begin
    FTimer.Enabled := False;
  if fadein = true then
  begin
  inc(i);
  if i > 4 then
  begin
    fadein := false ;
    end;
  end else
    begin
  dec(i);
  if i < 1 then begin
   fadein := true ;
    end;
    end;

  if Assigned(fbutton) then

    TfpgWidget(fbutton).Invalidate;
end;

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
    FTimer.Enabled := False;
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
  ACanvas.DrawRectangle(r);

  // so we don't paint over the border
  InflateRect(r, -1, -1);
  // now paint the face of the button
  if (btfIsPressed in AFlags) or (btfHover in AFlags) then
  begin
      if ACanvas.Window.ClassName = 'TfpgButton' then
        fbutton := ACanvas.Window;

      if i = 0 then  r21.SetRect(x, y, w,1) else
  r21.SetRect(x, y, w, round(h * ((i) / 5)));

  if i = 5 then  r22.SetRect(x, y+h, w,1) else

  r22.SetRect(x, y + (i *(h div 5)), w, h - (i*(h div 5)));

    if (btfIsPressed in AFlags) then begin
    ACanvas.GradientFill(r21, clWindowBackground, clLightgreen, gdVertical);
  ACanvas.GradientFill(r22,  clLightgreen, clWindowBackground, gdVertical);
     end else
  begin
    ACanvas.GradientFill(r21, clWindowBackground, clLightYellow, gdVertical);
  ACanvas.GradientFill(r22,  clLightYellow, clWindowBackground, gdVertical);
  end;

   ACanvas.SetColor(cldarkgray);
    ACanvas.DrawRectangle(r);
     InflateRect(r, -1, -1);
      if (btfHover in AFlags)  then   ACanvas.SetColor(clyellow) else   ACanvas.SetColor(cllime);
      ACanvas.DrawRectangle(r);
        if (btfIsPressed in AFlags) then  FTimer.Enabled := False else  FTimer.Enabled := True;
  end
  else
  begin
    FTimer.Enabled := False;
            i := 2;
            fadein := true;
    ACanvas.GradientFill(r21, clsilver, clwhite, gdVertical);
    ACanvas.GradientFill(r22, clwhite, clsilver, gdVertical);
  //    ACanvas.SetColor(clblack);
       ACanvas.SetColor(cldarkgray);
    ACanvas.DrawRectangle(r);

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

procedure TExtStyle.DrawMenuBar(ACanvas: TfpgCanvas; r: TfpgRect;
  ABackgroundColor: TfpgColor);
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
  // a possible future theme option
  ACanvas.GradientFill(r21, clsilver, clwhite, gdVertical);
    ACanvas.GradientFill(r22, clwhite, clsilver, gdVertical);

  // inner bottom line
  ACanvas.SetColor(clShadow1);
  ACanvas.DrawLine(r.Left, r.Bottom - 1, r.Right + 1, r.Bottom - 1);   // bottom
  // outer bottom line
  ACanvas.SetColor(clWhite);
  ACanvas.DrawLine(r.Left, r.Bottom, r.Right + 1, r.Bottom);   // bottom
end;


initialization
  fpgStyleManager.RegisterClass('Anim Chrome Silver vert', TExtStyle);

end.
