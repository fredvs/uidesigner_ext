{Animated Round Style
by Fred van Stappen
fiens@hotmail.com
}

unit fpg_style_anim_round_silver_flat_horz;

{$mode objfpc}{$H+}

interface

uses
  fpg_combobox,
  Classes, fpg_main, fpg_base;

type

  TExtStyle = class(TfpgStyle)
  private
    fadein: boolean;
    FTimer, FPressTimer: TfpgTimer;
    i: integer;
    fbutton: TfpgWindowBase;
    procedure TimerFired(Sender: TObject);
    procedure TimerPressed(Sender: TObject);

  public
    constructor Create; override;
    destructor  Destroy; override;
    { General }
    procedure DrawControlFrame(ACanvas: TfpgCanvas; x, y, w, h: TfpgCoord); override;
    { Buttons }
    procedure DrawFocusRect(ACanvas: TfpgCanvas; r: TfpgRect); override;
    procedure DrawButtonFace(ACanvas: TfpgCanvas; x, y, w, h: TfpgCoord;
      AFlags: TfpgButtonFlags); override;
    { Menus }
    procedure DrawMenuRow(ACanvas: TfpgCanvas; r: TfpgRect;
      AFlags: TfpgMenuItemFlags); override;
    procedure DrawMenuBar(ACanvas: TfpgCanvas; r: TfpgRect;
      ABackgroundColor: TfpgColor); override;

    procedure   DrawStaticComboBox(ACanvas: TfpgCanvas; r: TfpgRect; const IsEnabled: Boolean; const IsFocused: Boolean; const IsReadOnly: Boolean; const ABackgroundColor: TfpgColor; const AInternalBtnRect: TfpgRect; const ABtnPressed: Boolean); override;

    function HasButtonHoverEffect: boolean; override;
  end;


implementation

uses
  fpg_stylemanager,
  fpg_button,
  fpg_widget;

{ TExtStyle }

var
  waspressed: boolean;

constructor TExtStyle.Create;
begin
  inherited Create;
  fpgSetNamedColor(clWindowBackground, TfpgColor($eeeeec));
  FTimer := TfpgTimer.Create(200);
  FTimer.OnTimer := @TimerFired;
  FTimer.Enabled := False;

  FPressTimer := TfpgTimer.Create(1500);
  FPressTimer.OnTimer := @TimerPressed;
  FPressTimer.Enabled := False;
  i := 2;
  waspressed := False;
end;

destructor TExtStyle.Destroy;
begin
  FTimer.Enabled := False;
  FPressTimer.Enabled := False;
  FTimer.Free;
  FPressTimer.Free;
  inherited Destroy;
end;

procedure TExtStyle.TimerPressed(Sender: TObject);
begin
  FPressTimer.Enabled := False;
  waspressed := False;
end;

procedure TExtStyle.TimerFired(Sender: TObject);
begin
  FTimer.Enabled := False;
  if fadein = True then
  begin
    Inc(i);
    if i > 4 then
    begin
      fadein := False;
    end;
  end
  else
  begin
    Dec(i);
    if i < 1 then
    begin
      fadein := True;
    end;
  end;

  if Assigned(fbutton) then
    TfpgWidget(fbutton).Invalidate;
end;

function TExtStyle.HasButtonHoverEffect: boolean;
begin
  Result := True;
end;

procedure TExtStyle.DrawStaticComboBox(ACanvas: TfpgCanvas; r: TfpgRect; const IsEnabled: Boolean; const IsFocused: Boolean; const IsReadOnly: Boolean; const ABackgroundColor: TfpgColor; const AInternalBtnRect: TfpgRect; const ABtnPressed: Boolean);
var
oricol :  TfpgColor;
begin
   oricol := clSelectionText ;

       fpgSetNamedColor(clSelectionText, clblack);

  ACanvas.Clear(ABackgroundColor);
  ACanvas.GradientFill(AInternalBtnRect, clwhite, clsilver, gdVertical);

 // ACanvas.SetColor(cllightgray);
 // ACanvas.fillRectangle(AInternalBtnRect);

   ACanvas.SetColor(cldarkgray);
 if ABtnPressed = false then begin
  acanvas.FillTriangle(AInternalBtnRect.Left+5,7,AInternalBtnRect.Left+15,7,AInternalBtnRect.Left+10,AInternalBtnRect.Height-3);
   ACanvas.SetColor(clblack);
  acanvas.drawline(AInternalBtnRect.Left+5,7,AInternalBtnRect.Left+15,7);
  acanvas.drawline(AInternalBtnRect.Left+15,7,AInternalBtnRect.Left+10,AInternalBtnRect.Height-3);
  acanvas.drawline(AInternalBtnRect.Left+5,7,AInternalBtnRect.Left+10,AInternalBtnRect.Height-3);

 end else
 begin
  acanvas.FillTriangle(AInternalBtnRect.Left+6,8,AInternalBtnRect.Left+16,8,AInternalBtnRect.Left+11,AInternalBtnRect.Height-2);
 ACanvas.SetColor(clblack);

 end;

  fpgSetNamedColor(clSelectionText, oricol);
    end;


procedure TExtStyle.DrawControlFrame(ACanvas: TfpgCanvas; x, y, w, h: TfpgCoord);
var
  r: TfpgRect;
 begin
 r.SetRect(x, y, w, h);
   if ACanvas.Window.ClassName = 'TfpgValueBar' then
   begin
    ACanvas.SetColor(clblack);
   ACanvas.DrawRectangle(r);

   r.SetRect(x+1, y+1, w-2, h-2);
    ACanvas.SetColor(cllime);
      ACanvas.DrawRectangle(r);

     r.SetRect(x+2, y+2, w-4, h-4);
    ACanvas.SetColor(clwhite);
      ACanvas.DrawRectangle(r);

   end else
     begin

  ACanvas.SetColor(clShadow1);
  ACanvas.Clear(clWindowBackground);
  ACanvas.DrawRectangle(r);
end;
end;

procedure TExtStyle.DrawFocusRect(ACanvas: TfpgCanvas; r: TfpgRect);
var
  oldColor: TfpgColor;
  oldLineWidth: integer;
  oldLineStyle: TfpgLineStyle;
  w, h : integer;
begin
 w := r.Width;
 h := r.Height;

  oldColor      := ACanvas.Color;
  oldLineWidth  := ACanvas.GetLineWidth;
  oldLineStyle  := ACanvas.LineStyle;

  ACanvas.SetColor(clblack);
  ACanvas.SetLineStyle(1, lsDot);

    ACanvas.DrawArc(3, 3, w div 2, h,90, 180);  /// arc left
    ACanvas.DrawArc((w div 2)+3, 3, w div 2, h,270, 180);  /// arc right
   ACanvas.Drawline((h div 2)+11, 3,((h div 2)+ w-h)-3, 3);  /// line up
   ACanvas.Drawline((h div 2)+6, h+2,((h div 2)+ w-h), h+2); /// line down

  // restore previous settings
  ACanvas.SetColor(oldColor);
  ACanvas.SetLineStyle(oldLineWidth, oldLineStyle);
end;

procedure TExtStyle.DrawButtonFace(ACanvas: TfpgCanvas; x, y, w, h: TfpgCoord;
  AFlags: TfpgButtonFlags);
var
  r, r21, r22: TfpgRect;
  ib : integer;
begin
  FTimer.Enabled := False;
  r.SetRect(x, y, w, h);

  r21.SetRect(x, y, (w) div 2, h);

  r22.SetRect(x + ((w) div 2), y, (w) div 2, h);

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

  r.SetRect(x, y, w, h);
  ACanvas.SetColor(clWindowBackground);
    ACanvas.FillRectangle(r);

   if (btfFlat in AFlags) and not (btfIsPressed in AFlags) then
    Exit; // no need to go further

   // so we don't paint over the border
  InflateRect(r, -1, -1);
  // now paint the face of the button
  if (btfIsPressed in AFlags) or (btfHover in AFlags) then
  begin
    FTimer.Enabled := False;

    if ACanvas.Window.ClassName = 'TfpgButton' then
      if waspressed = False then
        fbutton := ACanvas.Window;

    if i = 0 then
      r21.SetRect(x, y, 1, h)
    else
      r21.SetRect(x, y, round(w * ((i) / 5)), h);

    if i = 5 then
      r22.SetRect(x + w, y, 1, h)
    else

      r22.SetRect(x + (i * (w div 5)), y, w - (i * (w div 5)), h);

    if (btfIsPressed in AFlags) then
    begin
      waspressed := True;
      FTimer.Enabled := False;
      FPressTimer.Enabled := False;
      ACanvas.GradientFill(r21, clsilver, clLightgreen, gdHorizontal);
      ACanvas.GradientFill(r22, clLightgreen, clsilver, gdHorizontal);
      fbutton := nil;
      FPressTimer.Enabled := True;
    end
    else
    begin
      ACanvas.GradientFill(r21, clsilver, clLightYellow, gdHorizontal);
      ACanvas.GradientFill(r22, clLightYellow, clsilver, gdHorizontal);
    end;
    ////////////
    ACanvas.Color := clWindowBackground;

   for ib := 1 to h div 2 do
    begin
    ACanvas.DrawArc(-1*ib, 0, w div 2, h,90, 180);  /// arc left
    ACanvas.DrawArc((w div 2)+ (ib*1), 0, w div 2, h,270, 180);
     end;

            ACanvas.SetColor(cldarkgray);

   // if (btfHover in AFlags) then
   //   ACanvas.SetColor(clyellow) ;
   //  if (btfIsPressed in AFlags) then
   //   ACanvas.SetColor(clred);

    ACanvas.DrawArc(0, 0, w div 2, h,90, 180);  /// arc left
    ACanvas.DrawArc(w div 2, 0, w div 2, h,270, 180);  /// arc right
    ACanvas.Drawline(h div 2, 0,(h div 2)+ w-h, 0);  /// line up
    ACanvas.Drawline(h div 2, h-1,(h div 2)+ w-h, h-1); /// line down

  ///////////
  end
  else
  begin
    FTimer.Enabled := False;
    i := 2;
    fadein := True;
 //  ACanvas.GradientFill(r21, clsilver, clwhite, gdHorizontal);
 //   ACanvas.GradientFill(r22, clwhite, clsilver, gdHorizontal);

  end;

  if (waspressed = False) and (btfHover in AFlags) then
    FTimer.Enabled := True;

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
  FLightColor: TfpgColor;
  FDarkColor: TfpgColor;
begin

  FLightColor := TfpgColor($f0ece3);  // color at top of menu bar
  FDarkColor := TfpgColor($beb8a4);  // color at bottom of menu bar
  ACanvas.GradientFill(r, cllightgray, clwindowbackground, gdVertical);
 // ACanvas.SetColor(cllightgray);
 // ACanvas.FillRectangle(r);
  // inner bottom line
  ACanvas.SetColor(clShadow1);
  ACanvas.DrawLine(r.Left, r.Bottom - 1, r.Right + 1, r.Bottom - 1);   // bottom
  // outer bottom line
  ACanvas.SetColor(clWhite);
  ACanvas.DrawLine(r.Left, r.Bottom, r.Right + 1, r.Bottom);   // bottom
end;

initialization
  fpgStyleManager.RegisterClass('Anim Round Silver Flat horz', TExtStyle);

end.
