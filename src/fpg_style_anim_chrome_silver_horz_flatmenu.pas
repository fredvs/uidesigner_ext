{Annimated Chrome Style flatmenu;
by Fred van Stappen
fiens@hotmail.com
}

unit fpg_style_anim_chrome_silver_horz_flatmenu;

{$mode objfpc}{$H+}

interface

uses
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
    procedure DrawButtonFace(ACanvas: TfpgCanvas; x, y, w, h: TfpgCoord;
      AFlags: TfpgButtonFlags); override;
    { Menus }
    procedure DrawMenuRow(ACanvas: TfpgCanvas; r: TfpgRect;
      AFlags: TfpgMenuItemFlags); override;
   function HasButtonHoverEffect: boolean; override;

  end;

implementation

uses
  fpg_stylemanager,
  fpg_widget;

var
  waspressed: boolean;

{ TExtStyle }

constructor TExtStyle.Create;
begin
  inherited Create;
  fpgSetNamedColor(clWindowBackground, clLightGray);
  FTimer := TfpgTimer.Create(200);
  FTimer.OnTimer := @TimerFired;

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

  if fbutton <> nil then
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

procedure TExtStyle.DrawButtonFace(ACanvas: TfpgCanvas; x, y, w, h: TfpgCoord;
  AFlags: TfpgButtonFlags);
var
  r, r21, r22: TfpgRect;
begin
  FTimer.Enabled := False;
  r.SetRect(x, y, w, h);

  r21.SetRect(x, y, w div 2, h);

  r22.SetRect(x + (w div 2), y, w div 2, h);

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
  ACanvas.DrawRectangle(r);

  // so we don't paint over the border
  InflateRect(r, -1, -1);
  // now paint the face of the button
  if (btfIsPressed in AFlags) or (btfHover in AFlags) then
  begin
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
      ACanvas.GradientFill(r21, clWindowBackground, clLightgreen, gdHorizontal);
      ACanvas.GradientFill(r22, clLightgreen, clWindowBackground, gdHorizontal);
      fbutton := nil;
      FPressTimer.Enabled := True;
    end
    else
    begin
      ACanvas.GradientFill(r21, clWindowBackground, clLightYellow, gdHorizontal);
      ACanvas.GradientFill(r22, clLightYellow, clWindowBackground, gdHorizontal);
    end;

    ACanvas.SetColor(cldarkgray);
    ACanvas.DrawRectangle(r);
    InflateRect(r, -1, -1);
    if (btfHover in AFlags) then
      ACanvas.SetColor(clyellow)
    else
      ACanvas.SetColor(cllime);
    ACanvas.DrawRectangle(r);
    if (waspressed = False) and (btfHover in AFlags) then
      FTimer.Enabled := True;
  end
  else
  begin
    FTimer.Enabled := False;
    i := 2;
    fadein := True;
    ACanvas.GradientFill(r21, clsilver, $E6E6E6, gdHorizontal);
    ACanvas.GradientFill(r22, $E6E6E6, clsilver, gdHorizontal);
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


initialization
  fpgStyleManager.RegisterClass('Anim Chrome Silver horz flat menu', TExtStyle);

end.
