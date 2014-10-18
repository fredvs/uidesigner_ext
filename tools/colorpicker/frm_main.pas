unit frm_main;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, fpg_base, fpg_main,
  fpg_edit, fpg_form, fpg_label, fpg_button,
  fpg_checkbox, fpg_combobox,
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
    ColorBox: TfpgComboBox;
    Button1: TfpgButton;
    ColorWheel1: TfpgColorWheel;
    ValueBar1: TfpgValueBar;
    bevel1: Tfpgbevel;
    panel1: Tfpgpanel;
    Label1: TfpgLabel;
    Label10: TfpgLabel;
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
    procedure ColorBoxChange(Sender: TObject);
    procedure E_HexaKeyChar(Sender: TObject; AChar: TfpgChar; var Consumed: boolean);
    procedure E_HexaKeyPress(Sender: TObject; var KeyCode: word; var ShiftState: TShiftState;
          var Consumed: boolean);
    public
    constructor Create(AOwner: TComponent); override;
    procedure AfterCreate; override;
  end;

{@VFD_NEWFORM_DECL}

implementation

type
  TColor = class
    Name: string;
    Value: string;
    end;

var
  oriMousePos, orimainform: TPoint;
  ired, igreen, iblue: integer;
  fbright : double;
  ColorList : TList;
   AColor : TColor;

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

procedure LoadColorList;
begin
  AColor:= TColor.Create; AColor.Name:= 'clAliceBlue '; AColor.Value:= '$f0f8ff'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clAntiqueWhite '; AColor.Value:= '$faebd7'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clAqua '; AColor.Value:= '$00ffff'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clAquamarine '; AColor.Value:= '$7fffd4'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clAzure '; AColor.Value:= '$f0ffff'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clBeige '; AColor.Value:= '$f5f5dc'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clBisque '; AColor.Value:= '$ffe4c4'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clBlack '; AColor.Value:= '$000000'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clBlanchedAlmond '; AColor.Value:= '$ffebcd'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clBlue '; AColor.Value:= '$0000ff'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clBlueViolet '; AColor.Value:= '$8a2be2'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clBrown '; AColor.Value:= '$a52a2a'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clBurlyWood '; AColor.Value:= '$deb887'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clCadetBlue '; AColor.Value:= '$5f9ea0'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clChartreuse '; AColor.Value:= '$7fff00'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clChocolate '; AColor.Value:= '$d2691e'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clCoral '; AColor.Value:= '$ff7f50'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clCornflowerBlue '; AColor.Value:= '$6495ed'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clCornsilk '; AColor.Value:= '$fff8dc'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clCrimson '; AColor.Value:= '$dc143c'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clCyan '; AColor.Value:= '$00ffff'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clDarkBlue '; AColor.Value:= '$00008b'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clDarkCyan '; AColor.Value:= '$008b8b'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clDarkGoldenrod '; AColor.Value:= '$b8860b'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clDarkGray '; AColor.Value:= '$a9a9a9'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clDarkGreen '; AColor.Value:= '$006400'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clDarkKhaki '; AColor.Value:= '$bdb76b'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clDarkMagenta '; AColor.Value:= '$8b008b'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clDarkOliveGreen '; AColor.Value:= '$556b2f'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clDarkOrange '; AColor.Value:= '$ff8c00'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clDarkOrchid '; AColor.Value:= '$9932cc'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clDarkRed '; AColor.Value:= '$8b0000'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clDarkSalmon '; AColor.Value:= '$e9967a'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clDarkSeaGreen '; AColor.Value:= '$8fbc8f'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clDarkSlateBlue '; AColor.Value:= '$483d8b'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clDarkSlateGray '; AColor.Value:= '$2f4f4f'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clDarkTurquoise '; AColor.Value:= '$00ced1'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clDarkViolet '; AColor.Value:= '$9400d3'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clDeepPink '; AColor.Value:= '$ff1493'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clDeepSkyBlue '; AColor.Value:= '$00bfff'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clDimGray '; AColor.Value:= '$696969'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clDodgerBlue '; AColor.Value:= '$1e90ff'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clFireBrick '; AColor.Value:= '$b22222'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clFloralWhite '; AColor.Value:= '$fffaf0'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clForestGreen '; AColor.Value:= '$228b22'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clFuchsia '; AColor.Value:= '$ff00ff'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clGainsboro '; AColor.Value:= '$dcdcdc'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clGhostWhite '; AColor.Value:= '$f8f8ff'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clGold '; AColor.Value:= '$ffd700'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clGoldenrod '; AColor.Value:= '$daa520'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clGray '; AColor.Value:= '$808080'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clGreen '; AColor.Value:= '$008000'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clGreenYellow '; AColor.Value:= '$adff2f'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clHoneydew '; AColor.Value:= '$f0fff0'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clHotPink '; AColor.Value:= '$ff69b4'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clIndianRed '; AColor.Value:= '$cd5c5c'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clIndigo '; AColor.Value:= '$4b0082'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clIvory '; AColor.Value:= '$fffff0'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clKhaki '; AColor.Value:= '$f0e68c'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clLavender '; AColor.Value:= '$e6e6fa'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clLavenderBlush '; AColor.Value:= '$fff0f5'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clLawnGreen '; AColor.Value:= '$7cfc00'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clLemonChiffon '; AColor.Value:= '$fffacd'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clLightBlue '; AColor.Value:= '$add8e6'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clLightCoral '; AColor.Value:= '$f08080'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clLightCyan '; AColor.Value:= '$e0ffff'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clLightGoldenrodYellow '; AColor.Value:= '$fafad2'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clLightGreen '; AColor.Value:= '$90ee90'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clLightGray '; AColor.Value:= '$d3d3d3'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clLightPink '; AColor.Value:= '$ffb6c1'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clLightSalmon '; AColor.Value:= '$ffa07a'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clLightSeaGreen '; AColor.Value:= '$20b2aa'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clLightSkyBlue '; AColor.Value:= '$87cefa'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clLightSlateGray '; AColor.Value:= '$778899'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clLightSteelBlue '; AColor.Value:= '$b0c4de'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clLightYellow '; AColor.Value:= '$ffffe0'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clLime '; AColor.Value:= '$00ff00'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clLimeGreen '; AColor.Value:= '$32cd32'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clLinen '; AColor.Value:= '$faf0e6'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clMagenta '; AColor.Value:= '$ff00ff'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clMaroon '; AColor.Value:= '$800000'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clMediumAquamarine '; AColor.Value:= '$66cdaa'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clMediumBlue '; AColor.Value:= '$0000cd'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clMediumOrchid '; AColor.Value:= '$ba55d3'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clMediumPurple '; AColor.Value:= '$9370db'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clMediumSeaGreen '; AColor.Value:= '$3cb371'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clMediumSlateBlue '; AColor.Value:= '$7b68ee'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clMediumSpringGreen '; AColor.Value:= '$00fa9a'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clMediumTurquoise '; AColor.Value:= '$48d1cc'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clMediumVioletRed '; AColor.Value:= '$c71585'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clMidnightBlue '; AColor.Value:= '$191970'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clMintCream '; AColor.Value:= '$f5fffa'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clMistyRose '; AColor.Value:= '$ffe4e1'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clMoccasin '; AColor.Value:= '$ffe4b5'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clNavajoWhite '; AColor.Value:= '$ffdead'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clNavy '; AColor.Value:= '$000080'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clOldLace '; AColor.Value:= '$fdf5e6'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clOlive '; AColor.Value:= '$808000'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clOliveDrab '; AColor.Value:= '$6b8e23'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clOrange '; AColor.Value:= '$ffa500'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clOrangeRed '; AColor.Value:= '$ff4500'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clOrchid '; AColor.Value:= '$da70d6'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clPaleGoldenrod '; AColor.Value:= '$eee8aa'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clPaleGreen '; AColor.Value:= '$98fb98'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clPaleTurquoise '; AColor.Value:= '$afeeee'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clPaleVioletRed '; AColor.Value:= '$db7093'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clPaleBlue '; AColor.Value:= '$e9f5fe'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clPapayaWhip '; AColor.Value:= '$ffefd5'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clPeachPuff '; AColor.Value:= '$ffdab9'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clPeru '; AColor.Value:= '$cd853f'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clPink '; AColor.Value:= '$ffc0cb'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clPlum '; AColor.Value:= '$dda0dd'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clPowderBlue '; AColor.Value:= '$b0e0e6'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clPurple '; AColor.Value:= '$800080'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clRed '; AColor.Value:= '$ff0000'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clRosyBrown '; AColor.Value:= '$bc8f8f'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clRoyalBlue '; AColor.Value:= '$4169e1'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clSaddleBrown '; AColor.Value:= '$8b4513'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clSalmon '; AColor.Value:= '$fa8072'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clSandyBrown '; AColor.Value:= '$f4a460'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clSeaGreen '; AColor.Value:= '$2e8b57'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clSeashell '; AColor.Value:= '$fff5ee'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clSienna '; AColor.Value:= '$a0522d'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clSilver '; AColor.Value:= '$c0c0c0'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clSkyBlue2 '; AColor.Value:= '$87ceeb'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clSlateBlue '; AColor.Value:= '$6a5acd'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clSlateGray '; AColor.Value:= '$708090'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clSnow '; AColor.Value:= '$fffafa'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clSpringGreen '; AColor.Value:= '$00ff7f'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clSteelBlue '; AColor.Value:= '$4682b4'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clTan '; AColor.Value:= '$d2b48c'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clTeal '; AColor.Value:= '$008080'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clThistle '; AColor.Value:= '$d8bfd8'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clTomato '; AColor.Value:= '$ff6347'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clTurquoise '; AColor.Value:= '$40e0d0'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clViolet '; AColor.Value:= '$ee82ee'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clWheat '; AColor.Value:= '$f5deb3'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clWhite '; AColor.Value:= '$ffffff'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clWhiteSmoke '; AColor.Value:= '$f5f5f5'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clYellow '; AColor.Value:= '$ffff00'; ColorList.Add(AColor);
  AColor:= TColor.Create; AColor.Name:= 'clYellowGreen '; AColor.Value:= '$9acd32'; ColorList.Add(AColor);
end;

///////////////////
procedure TCompareForm.AfterCreate;
begin

  Name := 'frmcompare';
  SetPosition(220, 180, 100, 100);
 // WindowPosition := wpUser;
  WindowType := wtPopup;
  OnMouseMove := @onMovemovepanel;
  OnMouseDown := @onClickDownPanel;
  OnMouseUp := @onClickUpPanel;
  OnPaint := @onpaintcompare;
  left := orimainform.X + 167;
  top := orimainform.y + 285;
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

////////////////

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

procedure TMainForm.E_HexaKeyChar(Sender: TObject; AChar: TfpgChar; var Consumed: boolean);
begin
if Length(E_Hexa.Text)= 0 then
begin
  if AChar<> '$' then
    Consumed:= True;
end
else
  if ((AChar< '0') or (AChar> '9')) and ((AChar< 'A') or (AChar> 'F')) and ((AChar< 'a') or (AChar> 'f')) then
    Consumed:= True;
end;

procedure TMainForm.E_HexaKeyPress(Sender: TObject; var KeyCode: word; var ShiftState: TShiftState;
          var Consumed: boolean);
begin
  if ((KeyCode= KeyReturn) or (KeyCode= KeyPEnter)) and (Length(E_Hexa.Text)= 7) then
  begin
    ConvertToRGB(self);
  end;
end;

constructor TMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FViaRGB := False;
  ColorList:= TList.Create;
  LoadColorList;
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

procedure TMainForm.ColorBoxChange(Sender: TObject);
begin
  e_Hexa.Text := TColor(ColorList[ColorBox.FocusItem]).Value ;
 ConvertToRGB(self);
end;

procedure TMainForm.AfterCreate;
var
  i : integer;
begin
  {@VFD_BODY_BEGIN: MainForm}
  Name := 'MainForm';
  SetPosition(349, 242, 380, 450);
  WindowTitle := 'Color Picker';
  WindowPosition := wpScreenCenter;
  //OnPaint := @onpaintmain;

  Button1 := TfpgButton.Create(self);
  with Button1 do
  begin
    Name := 'Button1';
    SetPosition(290, 418, 70, 26);
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
    //Border:=true;
    SetPosition(20, 20, 272, 244);
  end;

   panel1 := Tfpgpanel.Create(self);
  with panel1 do
  begin
    panel1.BackgroundColor:=clgray;
    Name := 'panel1';
   SetPosition(301, 22, 56, 242);
  end;

  ValueBar1 := TfpgValueBar.Create(self);
  with ValueBar1 do
  begin
    Name := 'ValueBar1';
    SetPosition(304, 24, 52, 238);
    CursorHeight:=15;
    ValueBar1.MarginWidth:=1;
       OnChange := @ColorChanged;
  end;

  Label10 := TfpgLabel.Create(self);
  with Label10 do
  begin
    Name := 'Label10';
    SetPosition(170,270,164,16);
    Alignment := taCenter;
    FontDesc := '#Label1';
    Hint := '';
    Text := 'Predefined Colors';
  end;

   ColorBox := TfpgComboBox.Create(self);
  with ColorBox do
  begin
    Name := 'ColorBox';
    SetPosition(170, 288,164,20);
    FontDesc := '#List';
    OnChange := @ColorBoxChange;
  end;

  Label1 := TfpgLabel.Create(self);
  with Label1 do
  begin
    Name := 'Label1';
    SetPosition(126, 324, 52, 18);
    Alignment := taRightJustify;
    FontDesc := '#Label1';
    Hint := '';
    Text := 'Hue';
  end;

  Label2 := TfpgLabel.Create(self);
  with Label2 do
  begin
    Name := 'Label2';
    SetPosition(126, 352, 52, 18);
    Alignment := taRightJustify;
    FontDesc := '#Label1';
    Hint := '';
    Text := 'Sat';
  end;

  Label3 := TfpgLabel.Create(self);
  with Label3 do
  begin
    Name := 'Label3';
    SetPosition(126, 380, 52, 18);
    Alignment := taRightJustify;
    FontDesc := '#Label1';
    Hint := '';
    Text := 'Bright';
  end;

  edH := TfpgEdit.Create(self);
  with edH do
  begin
    Name := 'edH';
    SetPosition(182, 320, 50, 26);
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
    SetPosition(182, 348, 50, 26);
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
    SetPosition(182, 376, 50, 26);
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
    SetPosition(236, 324, 56, 18);
    Alignment := taRightJustify;
    FontDesc := '#Label1';
    Hint := '';
    Text := 'Red';
  end;

  Label5 := TfpgLabel.Create(self);
  with Label5 do
  begin
    Name := 'Label5';
    SetPosition(236, 352, 56, 18);
    Alignment := taRightJustify;
    FontDesc := '#Label1';
    Hint := '';
    Text := 'Green';
  end;

  Label6 := TfpgLabel.Create(self);
  with Label6 do
  begin
    Name := 'Label6';
    SetPosition(236, 380, 56, 18);
    Alignment := taRightJustify;
    FontDesc := '#Label1';
    Hint := '';
    Text := 'Blue';
  end;

  edR := TfpgSpinEdit.Create(self);
  with edR do
  begin
    Name := 'edR';
    SetPosition(296, 320, 44, 26);
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
    SetPosition(296, 348, 44, 26);
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
    SetPosition(296, 376, 44, 26);
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
    SetPosition(20, 350, 100, 90);
  end;

  l_Hexa := Tfpglabel.Create(self);
  with l_Hexa do
  begin
    Name := 'l_Hexa';
    SetPosition(35, 297, 90, 16);
    FontDesc := '#Label1';
    Hint := '';
    Text := 'Hexadec';
  end;

  e_Hexa := Tfpgedit.Create(self);
  with e_Hexa do
  begin
    Name := 'e_Hexa';
    SetPosition(20, 315, 100, 26);
    FontDesc := '#Label1';
    Hint := 'Mouse out change edit...';
    showhint := True;
    Text := '';
    MaxLength:= 7;
    OnMouseExit := @ConvertToRGB;
    OnKeyChar:= @E_HexaKeyChar;
    OnKeyPress:= @E_HexaKeyPress;
  end;

  Label7 := TfpgLabel.Create(self);
  with Label7 do
  begin
    Name := 'Label7';
    SetPosition(135, 4, 80, 16);
    FontDesc := '#Label1';
    Hint := '';
    Text := 'Colors';
  end;

  Label8 := TfpgLabel.Create(self);
  with Label8 do
  begin
    Name := 'Label8';
    SetPosition(310, 3, 64, 16);
    FontDesc := '#Label1';
    Hint := '';
    Text := 'Bright';
  end;

  chkCrossHair := TfpgCheckBox.Create(self);
  with chkCrossHair do
  begin
    Name := 'chkCrossHair';
    SetPosition(145, 420, 120, 20);
    FontDesc := '#Label1';
    TabOrder := 20;
    Text := 'Large CrossHair';
    OnChange := @chkCrossHairChange;
  end;

   for i := 0 to Pred(ColorList.Count) do
    ColorBox.Items.Add(TColor(ColorList[i]).Name);
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
