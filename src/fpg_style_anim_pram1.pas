{Annimated Chrome Style
by Fred van Stappen
fiens@hotmail.com
}

unit fpg_style_anim_pram1 ;

{$mode objfpc}{$H+}

/// for custom compil, like using fpgui-dvelop =>  edit define.inc
{$I define.inc}

interface

uses
  Classes, fpg_main, fpg_base;

type

  TExtStyle = class(TfpgStyle)
  private
    fadein: boolean;
    FTimer, FPressTimer: TfpgTimer;
    i: integer;
    {$ifdef fpgui-develop}
    fbutton: TfpgwidgetBase;
    {$else}
    fbutton: TfpgwindowBase;
    {$endif}
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

  var
   param1 : real = 2 ;

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
  if waspressed = False then
  begin
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
   {$ifdef fpgui-develop}
    if ACanvas.widget.ClassName = 'TfpgValueBar' then
    {$else}
    if ACanvas.window.ClassName = 'TfpgValueBar' then
    {$endif}
   begin
    ACanvas.SetColor(clblack);
   ACanvas.DrawRectangle(r);

   r.SetRect(x+1, y+1, w-round(param1), h-round(param1));
    ACanvas.SetColor(cllime);
      ACanvas.DrawRectangle(r);

     r.SetRect(x+round(param1), y+round(param1), w-4, h-4);
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

  r21.SetRect(x, y, w, h div round(param1));

  r22.SetRect(x, y + (h div round(param1)), w, h div round(param1));

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

    // so we don't paint over the border
  InflateRect(r, -1, -1);
  // now paint the face of the button
  if (btfIsPressed in AFlags) or (btfHover in AFlags) then
  begin
    {$ifdef fpgui-develop}
 if ACanvas.widget.ClassName = 'TfpgButton' then
 {$else}
 if ACanvas.window.ClassName = 'TfpgButton' then
 {$endif}
      if waspressed = False then
         {$ifdef fpgui-develop}
 fbutton := ACanvas.widget;
 {$else}
 fbutton := ACanvas.window;
 {$endif}

    if i = 0 then
      r21.SetRect(x, y, w, 1)
    else
      r21.SetRect(x, y, w, round(h * ((i) / 5)));

    if i = 5 then
      r22.SetRect(x, y + h, w, 1)
    else

      r22.SetRect(x, y + (i * (h div 5)), w, h - (i * (h div 5)));

    if (btfIsPressed in AFlags) then
    begin
      waspressed := True;
      FTimer.Enabled := False;
      FPressTimer.Enabled := False;
      ACanvas.GradientFill(r21, clWindowBackground, clLightgreen, gdVertical);
      ACanvas.GradientFill(r22, clLightgreen, clWindowBackground, gdVertical);
      fbutton := nil;
      FPressTimer.Enabled := True;
    end
    else
    begin
      ACanvas.GradientFill(r21, clWindowBackground, clLightYellow, gdVertical);
      ACanvas.GradientFill(r22, clLightYellow, clWindowBackground, gdVertical);
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
    ACanvas.GradientFill(r21, clsilver, $E6E6E6, gdVertical);
    ACanvas.GradientFill(r22, $E6E6E6, clsilver, gdVertical);
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
  r21.Height := r.Height div round(param1);
  r21.Width := r.Width;
  r21.Top := r.top;
  r21.Left := r.Left;

  r22.Height := r.Height div round(param1);
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
  fpgStyleManager.RegisterClass('Anim param1', TExtStyle);

end.
