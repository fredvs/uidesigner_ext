unit frm_main;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, fpg_base, fpg_main,
  fpg_edit, fpg_form, fpg_label, fpg_button,
  fpg_checkbox,
  fpg_panel, fpg_ColorWheel, fpg_spinedit;

type

  TCompareForm = class(TfpgForm)
  public
    procedure AfterCreate; override;
    procedure onPaintCompare(Sender: TObject);
    procedure onClickDownPanel(Sender: TObject; AButton: TMouseButton;
      AShift: TShiftState; const AMousePos: TPoint);
    procedure onClickUpPanel(Sender: TObject; AButton: TMouseButton;
      AShift: TShiftState; const AMousePos: TPoint);
    procedure onMoveMovePanel(Sender: TObject; AShift: TShiftState;
      const AMousePos: TPoint);
  end;

  TMainForm = class(TfpgForm)
  private
    {@VFD_HEAD_BEGIN: MainForm}
    frmcompare: TCompareForm;
    Button1: TfpgButton;
    ColorWheel1: TfpgColorWheel;
    ValueBar1: TfpgValueBar;
    bevel1: Tfpgbevel;
    panel1: Tfpgpanel;
    Label1: TfpgLabel;
    Label2: TfpgLabel;
    Label3: TfpgLabel;
    edH: TfpgEdit;
    edS: TfpgEdit;
    edV: TfpgEdit;
    Label4: TfpgLabel;
    Label5: TfpgLabel;
    Label6: TfpgLabel;
    edR: TfpgSpinEdit;
    edG: TfpgSpinEdit;
    edB: TfpgSpinEdit;
    Label7: TfpgLabel;
    Label8: TfpgLabel;
    l_Hexa: TfpgLabel;
    e_Hexa: TfpgEdit;
    chkCrossHair: TfpgCheckBox;

    {@VFD_HEAD_END: MainForm}
    FViaRGB: boolean; // to prevent recursive changes
    procedure btnQuitClicked(Sender: TObject);
    procedure chkCrossHairChange(Sender: TObject);
    procedure UpdateHSVComponents;
    procedure UpdateRGBComponents;
    procedure ColorChanged(Sender: TObject);
    procedure RGBChanged(Sender: TObject);
    procedure ConvertToRGB(Sender: TObject);
    procedure onPaintMain(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    procedure AfterCreate; override;
  end;

{@VFD_NEWFORM_DECL}

implementation

var
  oriMousePos, orimainform: TPoint;
  ired, igreen, iblue: integer;
  fbright : double;

{@VFD_NEWFORM_IMPL}

function IsStrANumber(const S: string): boolean;
begin
  Result := True;
  try
    StrToInt(S);
  except
    Result := False;
  end;
end;


function hex2int(const S: string): integer;
begin
  Result := -1;
  case uppercase(s) of
    'F': Result := 15;
    'E': Result := 14;
    'D': Result := 13;
    'C': Result := 12;
    'B': Result := 11;
    'A': Result := 14;
    else
      if IsStrANumber(s) then
        Result := StrToInt(s);
  end;
end;

procedure TCompareForm.AfterCreate;
begin

  Name := 'frmcompare';
  SetPosition(220, 180, 100, 100);
  WindowPosition := wpUser;
  WindowType := wtPopup;
  OnMouseMove := @onMovemovepanel;
  OnMouseDown := @onClickDownPanel;
  OnMouseUp := @onClickUpPanel;
  OnPaint := @onpaintcompare;
  left := orimainform.X + 167;
  top := orimainform.y + 260;
  UpdateWindowPosition;

end;

procedure TCompareForm.onPaintCompare(Sender: TObject);
begin
  if fbright > 0.5 then
  Canvas.TextColor := clblack else Canvas.TextColor := clwhite ;
  Canvas.DrawText(30, 20, 'Tester');
  Canvas.DrawText(23, 45, 'Hold-Click');
  Canvas.DrawText(15, 60, 'moves panel');

end;

procedure TCompareForm.onClickDownPanel(Sender: TObject; AButton: TMouseButton;
  AShift: TShiftState; const AMousePos: TPoint);
begin
  oriMousePos := AMousePos;
  Tag := 1;
end;

procedure TCompareForm.onClickUpPanel(Sender: TObject; AButton: TMouseButton;
  AShift: TShiftState; const AMousePos: TPoint);
begin
  Tag := 0;
end;

procedure TCompareForm.onMoveMovePanel(Sender: TObject; AShift: TShiftState;
  const AMousePos: TPoint);
begin
  if Tag = 1 then
  begin
    fpgapplication.ProcessMessages;
    top := top + (AMousePos.Y - oriMousePos.y);
    left := left + (AMousePos.x - oriMousePos.X);
    UpdateWindowPosition;
  end;
end;

function ConvertToInt(Value: string): boolean;
var
  colortmp: string;
  itemp1, itemp2: integer;
begin
  Result := False;
  itemp1 := -1;
  itemp2 := -1;

  colortmp := copy(Value, 2, 2);
  itemp1 := hex2int(copy(colortmp, 1, 1));

  if itemp1 > -1 then
    itemp2 := hex2int(copy(colortmp, 2, 1));

  if itemp2 > -1 then
  begin
    ired := (itemp1 * 16) + itemp2;
    colortmp := copy(Value, 4, 2);
    itemp1 := hex2int(copy(colortmp, 1, 1));
  end;

  if itemp1 > -1 then
    itemp2 := hex2int(copy(colortmp, 2, 1));

  if itemp2 > -1 then
  begin
    igreen := (itemp1 * 16) + itemp2;
    colortmp := copy(Value, 6, 2);
    itemp1 := hex2int(copy(colortmp, 1, 1));
  end;

  if itemp1 > -1 then
    itemp2 := hex2int(copy(colortmp, 2, 1));

  if itemp2 > -1 then
    iblue := (itemp1 * 16) + itemp2;

  if (itemp1 > -1) and (itemp2 > -1) then
    Result := True;
end;


function ConvertToHexa(Value: integer): string;
var
  ValH, ValL: integer;
begin
  ValH := Value div 16;
  ValL := Value mod 16;
  case ValH of
    15:
      Result := 'F';
    14:
      Result := 'E';
    13:
      Result := 'D';
    12:
      Result := 'C';
    11:
      Result := 'B';
    10:
      Result := 'A';
    else
      Result := IntToStr(ValH);
  end;
  case ValL of
    15:
      Result := Result + 'F';
    14:
      Result := Result + 'E';
    13:
      Result := Result + 'D';
    12:
      Result := Result + 'C';
    11:
      Result := Result + 'B';
    10:
      Result := Result + 'A';
    else
      Result := Result + IntToStr(ValL);
  end;
end;

function Hexa(Red, Green, Blue: integer): string;
begin
  Result := '$' + ConvertToHexa(Red) + ConvertToHexa(Green) + ConvertToHexa(Blue);
end;

procedure TMainForm.ColorChanged(Sender: TObject);
begin
  UpdateHSVComponents;
  if not FViaRGB then
    UpdateRGBComponents;
end;

procedure TMainForm.onPaintMain(Sender: TObject);
begin

end;

procedure TMainForm.RGBChanged(Sender: TObject);
var
  rgb: TRGBTriple;
  c: TfpgColor;
begin
  FViaRGB := True;  // revent recursive updates

  rgb.Red := edR.Value;
  rgb.Green := edG.Value;
  rgb.Blue := edB.Value;
  c := RGBTripleTofpgColor(rgb);
  ColorWheel1.SetSelectedColor(c);
  // This will trigger ColorWheel and ValueBar OnChange event
  FViaRGB := False;
  e_Hexa.Text := Hexa(rgb.Red, rgb.Green, rgb.Blue);

end;

procedure TMainForm.ConvertToRGB(Sender: TObject);
begin
  if ConvertToInt(e_Hexa.Text) = True then
  begin
    edR.Value := ired;
    edG.Value := igreen;
    edB.Value := iblue;
    RGBChanged(Sender);
  end;
end;

constructor TMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FViaRGB := False;
end;

procedure TMainForm.btnQuitClicked(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.chkCrossHairChange(Sender: TObject);
begin
  if chkCrossHair.Checked then
    ColorWheel1.CursorSize := 400
  else
    ColorWheel1.CursorSize := 5;
end;

procedure TMainForm.UpdateHSVComponents;
begin
  edH.Text := IntToStr(ColorWheel1.Hue);
  edS.Text := FormatFloat('0.000', ColorWheel1.Saturation);
  edV.Text := FormatFloat('0.000', ValueBar1.Value);
  fbright := ValueBar1.Value ;
  bevel1.BackgroundColor := ValueBar1.SelectedColor;
  frmcompare.BackgroundColor := ValueBar1.SelectedColor;
end;

procedure TMainForm.UpdateRGBComponents;
var
  rgb: TRGBTriple;
  c: TfpgColor;
begin
  c := ValueBar1.SelectedColor;
  rgb := fpgColorToRGBTriple(c);
  edR.Value := rgb.Red;
  edG.Value := rgb.Green;
  edB.Value := rgb.Blue;
  e_Hexa.Text := Hexa(rgb.Red, rgb.Green, rgb.Blue);
end;

procedure TMainForm.AfterCreate;
begin
  {@VFD_BODY_BEGIN: MainForm}
  Name := 'MainForm';
  SetPosition(349, 242, 380, 420);
  WindowTitle := 'Color Picker';
  WindowPosition := wpScreenCenter;

  Button1 := TfpgButton.Create(self);
  with Button1 do
  begin
    Name := 'Button1';
    SetPosition(290, 378, 70, 26);
    //   Anchors := [anRight,anBottom];
    Text := 'Quit';
    FontDesc := '#Label1';
    Hint := '';
    ImageName := '';
    TabOrder := 0;
    OnClick := @btnQuitClicked;
  end;

  ColorWheel1 := TfpgColorWheel.Create(self);
  with ColorWheel1 do
  begin
    Name := 'ColorWheel1';
    SetPosition(20, 20, 272, 244);
  end;

    panel1 := Tfpgpanel.Create(self);
  with panel1 do
  begin
    Name := 'panel1';
   SetPosition(303, 22, 54, 240);
  end;

  ValueBar1 := TfpgValueBar.Create(self);
  with ValueBar1 do
  begin
    Name := 'ValueBar1';
    SetPosition(304, 23, 52, 238);
    CursorHeight:=15;
    OnChange := @ColorChanged;
  end;

  Label1 := TfpgLabel.Create(self);
  with Label1 do
  begin
    Name := 'Label1';
    SetPosition(126, 284, 52, 18);
    Alignment := taRightJustify;
    FontDesc := '#Label1';
    Hint := '';
    Text := 'Hue';
  end;

  Label2 := TfpgLabel.Create(self);
  with Label2 do
  begin
    Name := 'Label2';
    SetPosition(126, 312, 52, 18);
    Alignment := taRightJustify;
    FontDesc := '#Label1';
    Hint := '';
    Text := 'Sat';
  end;

  Label3 := TfpgLabel.Create(self);
  with Label3 do
  begin
    Name := 'Label3';
    SetPosition(126, 340, 52, 18);
    Alignment := taRightJustify;
    FontDesc := '#Label1';
    Hint := '';
    Text := 'Bright';
  end;

  edH := TfpgEdit.Create(self);
  with edH do
  begin
    Name := 'edH';
    SetPosition(182, 280, 50, 26);
    TabOrder := 8;
    Text := '';
    ReadOnly := True;
    Focusable := False;
    FontDesc := '#Edit1';
    BackgroundColor := clWindowBackground;
  end;

  edS := TfpgEdit.Create(self);
  with edS do
  begin
    Name := 'edS';
    SetPosition(182, 308, 50, 26);
    TabOrder := 9;
    Text := '';
    FontDesc := '#Edit1';
    Focusable := False;
    ReadOnly := True;
    BackgroundColor := clWindowBackground;
  end;

  edV := TfpgEdit.Create(self);
  with edV do
  begin
    Name := 'edV';
    SetPosition(182, 336, 50, 26);
    TabOrder := 10;
    Text := '';
    FontDesc := '#Edit1';
    ReadOnly := True;
    Focusable := False;
    BackgroundColor := clWindowBackground;
  end;

  Label4 := TfpgLabel.Create(self);
  with Label4 do
  begin
    Name := 'Label4';
    SetPosition(236, 284, 56, 18);
    Alignment := taRightJustify;
    FontDesc := '#Label1';
    Hint := '';
    Text := 'Red';
  end;

  Label5 := TfpgLabel.Create(self);
  with Label5 do
  begin
    Name := 'Label5';
    SetPosition(236, 312, 56, 18);
    Alignment := taRightJustify;
    FontDesc := '#Label1';
    Hint := '';
    Text := 'Green';
  end;

  Label6 := TfpgLabel.Create(self);
  with Label6 do
  begin
    Name := 'Label6';
    SetPosition(236, 340, 56, 18);
    Alignment := taRightJustify;
    FontDesc := '#Label1';
    Hint := '';
    Text := 'Blue';
  end;

  edR := TfpgSpinEdit.Create(self);
  with edR do
  begin
    Name := 'edR';
    SetPosition(296, 280, 44, 26);
    TabOrder := 13;
    MinValue := 0;
    MaxValue := 255;
    Value := 255;
    FontDesc := '#Edit1';
    OnChange := @RGBChanged;
    OnExit := @RGBChanged;
  end;

  edG := TfpgSpinEdit.Create(self);
  with edG do
  begin
    Name := 'edG';
    SetPosition(296, 308, 44, 26);
    TabOrder := 14;
    MinValue := 0;
    MaxValue := 255;
    Value := 255;
    FontDesc := '#Edit1';
    OnChange := @RGBChanged;
    OnExit := @RGBChanged;
  end;

  edB := TfpgSpinEdit.Create(self);
  with edB do
  begin
    Name := 'edB';
    SetPosition(296, 336, 44, 26);
    TabOrder := 15;
    MinValue := 0;
    MaxValue := 255;
    Value := 255;
    FontDesc := '#Edit1';
    OnChange := @RGBChanged;
    OnExit := @RGBChanged;
  end;

  bevel1 := Tfpgbevel.Create(self);
  with bevel1 do
  begin
    Name := 'bevel1';
    SetPosition(20, 310, 100, 90);
  end;

  l_Hexa := Tfpglabel.Create(self);
  with l_Hexa do
  begin
    Name := 'l_Hexa';
    SetPosition(35, 257, 90, 16);
    FontDesc := '#Label1';
    Hint := '';
    Text := 'Hexadec';
  end;

  e_Hexa := Tfpgedit.Create(self);
  with e_Hexa do
  begin
    Name := 'e_Hexa';
    SetPosition(20, 275, 100, 26);
    FontDesc := '#Label1';
    Hint := 'Mouse out change edit...';
    showhint := True;
    Text := '';
    OnMouseExit := @ConvertToRGB;
  end;

  Label7 := TfpgLabel.Create(self);
  with Label7 do
  begin
    Name := 'Label7';
    SetPosition(130, 3, 80, 16);
    FontDesc := '#Label2';
    Hint := '';
    Text := 'Colors';
  end;

  Label8 := TfpgLabel.Create(self);
  with Label8 do
  begin
    Name := 'Label8';
    SetPosition(310, 3, 64, 16);
    FontDesc := '#Label2';
    Hint := '';
    Text := 'Bright';
  end;

  chkCrossHair := TfpgCheckBox.Create(self);
  with chkCrossHair do
  begin
    Name := 'chkCrossHair';
    SetPosition(145, 380, 120, 20);
    FontDesc := '#Label1';
    TabOrder := 20;
    Text := 'Large CrossHair';
    OnChange := @chkCrossHairChange;
  end;

  fbright := 1 ;
  updatewindowposition;
  orimainform.X := left;
  orimainform.Y := top;
  sleep(200);
  {@VFD_BODY_END: MainForm}


  frmcompare := TCompareForm.Create(nil);
  frmcompare.Show;
  sleep(200);
  // link the two components
  ColorWheel1.ValueBar := ValueBar1;
  UpdateHSVComponents;
  if not FViaRGB then
    UpdateRGBComponents;

end;


end.
