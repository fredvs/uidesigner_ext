unit sak_fpg;

{*******************************************************************************
*                         Speech Assistive Kit ( sak )                         *
*                  --------------------------------------                      *
*                                                                              *
*          Assistive Procedures using eSpeak and Portaudio libraries           *
*                                                                              *
*                                                                              *
*                 Fred van Stappen /  fiens@hotmail.com                        *
*                                                                              *
*                                                                              *
********************************************************************************
*  4 th release: 2015-03-13  (sak_dll synchronized with sak)                   *
*  3 th release: 2015-03-04  (fpGUI focus)                                     *
*  2 th release: 2013-08-01  (use espeak executable)                           *
*  1 th release: 2013-06-15  (multi objects, multi forms)                      *
*******************************************************************************}
    {
    Copyright (C) 2013 - 2015  Fred van Stappen

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor,
    Boston, MA  02110-1301  USA
    }

interface

uses
  Classes,
  fpg_base,
  fpg_main,
  fpg_grid,
  fpg_label,
  fpg_button,
  fpg_CheckBox,
  fpg_RadioButton,
  fpg_Menu,
  fpg_ComboBox,
  fpg_ListBox,
  fpg_TrackBar,
  fpg_memo,
  fpg_widget,
  fpg_panel,
  fpg_edit,
  fpg_form,
  fpg_dialogs,
  Math, SysUtils, Process
  {$IF DEFINED(unix)}
  , baseunix
       {$endif}  ;

(*
{$define darwin}
{$define freebsd}
{$define windows}
{$define cpu64}
{$define cpu86}
*)

const
  male = 1;
  female = 2;

type
  TProc = procedure of object;
  TOnEnter = procedure(Sender: TObject) of object;
  TOnClick = procedure(Sender: TObject) of object;
  TOnChange = procedure(Sender: TObject) of object;
  TOnDestroy = procedure(Sender: TObject) of object;
  TOnMouseMove = procedure(Sender: TObject; Shift: TShiftState; const thePoint: TPoint) of object;
  TOnKeyChar = procedure(Sender: TObject; Key: TfpgChar; var ifok: boolean) of object;
  TOnKeyPress = procedure(Sender: TObject; var Key: word; var Shift: TShiftState; var ifok: boolean) of object;
  TOnMouseDown = procedure(Sender: TObject; Button: TMouseButton; Shift: TShiftState; const Pointm: TPoint) of object;
  TOnMouseUp = procedure(Sender: TObject; Button: TMouseButton; Shift: TShiftState; const Pointm: TPoint) of object;
  TOnFocusChange = procedure(Sender: TObject; col: longint; row: longint) of object;
  TOnTrackbarChange = procedure(Sender: TObject; position: longint) of object;

type
  TSAK_IAssistive = class(TObject)
  private
    TheObject: TComponent;
    OriOnKeyPress: TOnKeyPress;
    OriOnClick: TOnClick;
    OriOnEnter: TOnEnter;
    OriOnMouseDown: TOnMouseDown;
    OriOnMouseUp: TOnMouseUp;
    OriOnChange: TOnChange;
    OriOnDestroy: TOnDestroy;
    OriOnKeyChar: TOnKeyChar;
    OriOnFocusChange: TOnFocusChange;
    OriOnTrackbarChange: TOnTrackbarChange;
    oriOnMouseMove: TOnMouseMove;
    Description: ansistring;
   end;

type
  TSAK = class(TObject)
 protected
  old8087cw: word;
  f: integer;
  mouseclicked: boolean;
  lastfocused: string ;
  AProcess: TProcess;

    TheWord: string;  //// use F10 key in edit
    TheSentence: string;   //// use F11 key in edit

    ES_ExeFileName: ansistring;
    ES_DataDirectory: ansistring;
    ES_LibFileName: ansistring;

    PA_LibFileName: ansistring;

    voice_language: ansistring; //-v
    voice_gender: ansistring;  //-g
    voice_speed: integer;  //-s
    voice_pitch: integer;  //-p
    voice_volume: integer;  //-a
   
    CompCount: integer;
    CheckObject: TObject;
    CheckKey: word;
    CheckPoint: Tpoint;
    CheckShift: TShiftState;
    AssistiveData: array of TSAK_IAssistive;
    CheckKeyChar: TfpgChar;
    CheckCol, CheckRow, CheckPos: longint;
    TimerCount: TfpgTimer;
    TimerRepeat: TfpgTimer;

    ///// Start speaking the text with default voice
    procedure espeak_key(Text: string);

    //// cancel current speaker
    procedure espeak_cancel;

    procedure SAKEnter(Sender: TObject);
    procedure SAKChange(Sender: TObject);
    procedure SAKClick(Sender: TObject);
    procedure SAKDestroy(Sender: TObject);
    procedure CheckCount(Sender: TObject);
    procedure CheckRepeatEnter(Sender: TObject);
    procedure CheckRepeatClick(Sender: TObject);
    procedure CheckRepeatChange(Sender: TObject);
    procedure CheckRepeatKeyPress(Sender: TObject);
    procedure CheckRepeatKeyChar(Sender: TObject);
    procedure CheckFocusChange(Sender: TObject);
    procedure CheckRepeatMouseMove(Sender: TObject);
    procedure SAKKeyChar(Sender: TObject; Key: TfpgChar; var ifok: boolean);
    procedure SAKKeyPress(Sender: TObject; var Key: word; var Shift: TShiftState; var ifok: boolean);
    procedure SAKMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; const pointm: Tpoint);
    procedure SAKMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; const pointm: Tpoint);
    procedure SAKMouseMove(Sender: TObject; Shift: TShiftState; const thePoint: TPoint);
    procedure SAKFocusChange(Sender: TObject; col: longint; row: longint);
    procedure CheckTrackbarChange(Sender: TObject);
    procedure SAKTrackbarChange(Sender: TObject; pos: longint);
    procedure UpdateChild(AComp : TComponent) ;
    function WhatName(Sender: TObject): string;
    procedure ChildComponentCount(AComponent: TComponent);
    function WhatPos(sender : Tobject; kind : integer) : string ;  // kind 0 = all, , 1 = part
    function WhatDeleted(sender : Tobject) : string;
    function WhatWord(sender : Tobject) : string;
    function WhatLine(sender : Tobject) : string;
    function LoadLib: integer;
    procedure unLoadLib;
    procedure InitObject;
  end;

   TWarning = class(TfpgForm)
  private
    Label1: TfpgLabel;
    Label2: TfpgLabel;
    Label3: TfpgLabel;
    Label4: TfpgLabel;
    Button1: TfpgButton;
    Button2: TfpgButton;
  public
    modresult : integer;
    procedure AfterCreate; override;
    procedure buttonclicked(Sender: TObject);
  end;

 ///// to find the file in sak.ini (what => 0 = espeak bin, 1 = portaudio lib, 2 = espeak lib, 3 = epeak-data dir)
function WhatFile(sakini : string; what : integer) : string;

  {$IF DEFINED(unix)}
function ChangePermission(thefile : string; raisemessage : boolean = true) : integer ;
{$endif}

/// Load with custom sakit dir
function SAKLoadLib(const SakitDir: string = ''): integer;
                            //'' = default

/// Load with custom espeak dir
function SAKLoadLib(const eSpeakBin: string; const eSpeaklib: string; const PortaudioLib: string;
                                      const eSpeakDataDir: string): integer;

function SAKUnloadLib: integer;

///// usefull if events are changed at run time
procedure SAKSuspend();

///// usefull if events are changed at run time
procedure SAKUpdate();

////  is sak enabled or no ?
function SakIsEnabled: boolean;

////////////////////// Voice Config Procedures ///////////////
function SAKSetVoice(gender: shortint; language: string ; speed: integer ; pitch: integer ; volume : integer ): integer;
// -gender : 1 = man, 2 = woman => defaut -1 (man)
//-language : is the language code => default '' (en) 
////  for example :'en' for english, 'fr' for french, 'pt' for Portugues, etc...
////           (check in /espeak-data if your language is there...)
//  -speed sets the speed in words-per-minute , Range 80 to 450. The default value is 175. => -1
// -pitch  range of 0 to 99. The default is 50.   => -1
// -volume range of 0 to 200. The default is 100. => -1

///// Start speaking the text
function SAKSay(Text: string): integer;

//// cancel current speaker
function SakCancel : integer;

{$IFDEF FREEBSD}
// These are missing for FreeBSD in FPC's RTL
const
  S_IRWXU = S_IRUSR or S_IWUSR or S_IXUSR;
  S_IRWXG = S_IRGRP or S_IWGRP or S_IXGRP;
  S_IRWXO = S_IROTH or S_IWOTH or S_IXOTH;
{$ENDIF}

var
  sak: TSAK;
  isenabled: boolean = False;
 
implementation

function Tsak.WhatDeleted(sender : Tobject) : string;
var
 strline, posword1, posword2 : string;
 pos1 : integer;
begin
   with sender as Tfpgmemo do
      begin
           espeak_cancel;
          strline :=  Lines[cursorline];
        posword1 := '';
             pos1 := cursorpos ;
        while (copy(strline,pos1,1) <> ' ') and (pos1 > 0) do
          begin
        posword1 := copy(strline,pos1,1)   + posword1;
        dec(pos1);
          end;

    //    writeln('chars before pos = ' + posword1);  // the letters before cursor

    posword2 := '';
             pos1 := cursorpos +1 ;
        while (copy(strline,pos1,1) <> ' ') and (pos1 < length(strline) +1) do
          begin
        posword2 := posword2 + copy(strline,pos1,1)  ;
        inc(pos1);
          end;

      if trim(posword1 + posword2) = '' then posword1 := 'empty, ';


       if  copy(strline,cursorpos+1,1) = ' '   // the letter after cursor is space
              then
              begin
       result := 'deleted, space, after, '  +  posword1 + posword2 + ' in line ' + inttostr(cursorline+1)
  end else
   begin
     result := 'deleted, position, ' + inttostr(length(posword1)+1) +  ', line, ' + inttostr(cursorline+1) +  ', in, ' +  posword1 + posword2;
        end;

//     writeln(result);

        end;


end;

function Tsak.WhatPos(sender : Tobject; kind : integer) : string ;  // kind 0 = all, , 1 = part
var
 strline, posword1, posword2 : string;
 pos1 : integer;
begin

            with sender as Tfpgmemo do
           begin
                  espeak_cancel;

         strline :=  Lines[cursorline];
        posword1 := '';
             pos1 := cursorpos ;
        while (copy(strline,pos1,1) <> ' ') and (pos1 > 0) do
          begin
        posword1 := copy(strline,pos1,1)   + posword1;
        dec(pos1);
          end;

    //    writeln('chars before pos = ' + posword1);  // the letters before cursor

    posword2 := '';
             pos1 := cursorpos +1 ;
        while (copy(strline,pos1,1) <> ' ') and (pos1 < length(strline) +1) do
          begin
        posword2 := posword2 + copy(strline,pos1,1)  ;
        inc(pos1);
          end;

      if trim(posword1 + posword2) = '' then posword1 := 'empty, ';


       if  copy(strline,cursorpos+1,1) = ' '   // the letter after cursor is space
              then
   //      writeln('space, after, '  +  posword1 + posword2 + ' in line ' + inttostr(cursorline) )
        if kind = 0 then
         result := 'space, after, '  +  posword1 + posword2 + ', in line, ' + inttostr(cursorline+1)
         else   result := 'space, after, '  +  posword1 + posword2

   else
   begin
   //   writeln(copy(strline,cursorpos+1,1) + ', line, ' + inttostr(cursorline) + ' , position, ' + inttostr(length(posword1)+1) + ', in, ' +
  // posword1 + posword2);
     if kind = 0 then
     result := copy(strline,cursorpos+1,1) +  ' , position, ' + inttostr(length(posword1)+1) + ', line, ' + inttostr(cursorline+1)+ ', in, ' +
   posword1 + posword2 else
      result := copy(strline,cursorpos+1,1) +  ' , position, ' + inttostr(length(posword1)+1) + ', in, ' +
   posword1 + posword2

   end;

  //   writeln(result);

end;

end;

function  Tsak.WhatLine(sender : Tobject) : string;
begin
               with sender as Tfpgmemo do
           begin
                  espeak_cancel;
          result := 'line, ' + inttostr(cursorline +1) + ', ' +  Lines[cursorline];

           end;

end;

function Tsak.WhatWord(sender : Tobject) : string ;
var
 strline, posword1, posword2 : string;
 pos1 : integer;
begin

            with sender as Tfpgmemo do
           begin
                  espeak_cancel;
          strline :=  Lines[cursorline];
        posword1 := '';
             pos1 := cursorpos -1;
        while (copy(strline,pos1,1) <> ' ') and (pos1 > 0) do
          begin
        posword1 := copy(strline,pos1,1)   + posword1;
        dec(pos1);
          end;

    //    writeln('chars before pos = ' + posword1);  // the letters before cursor

    posword2 := '';
             pos1 := cursorpos  ;
        while (copy(strline,pos1,1) <> ' ') and (pos1 < length(strline) +1) do
          begin
        posword2 := posword2 + copy(strline,pos1,1)  ;
        inc(pos1);
          end;

      if trim(posword1 + posword2) = '' then posword1 := 'empty, ';

            result := posword1 + posword2  ;

end;

end;

procedure Tsak.UpdateChild(AComp : TComponent) ;
var
  j : integer ;
begin

   with AComp as TComponent do

              for j := 0 to ComponentCount - 1 do
              begin
                if (Components[j] is TfpgButton) then
                begin
                  SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

                  sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
                    TSAK_IAssistive.Create();

                  sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
                    'Button,';
                  sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
                    TfpgButton(Components[j]);
                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnClick :=
                    TfpgButton(Components[j]).OnClick;
                  TfpgButton(Components[j]).OnClick := @sak.SAKClick;
                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
                    TfpgButton(Components[j]).OnEnter;
                  TfpgButton(Components[j]).OnEnter := @sak.SAKEnter;

                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
                    TfpgButton(Components[j]).OnMouseMove;
                  TfpgButton(Components[j]).OnMouseMove := @sak.SAKMouseMove;

                   sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
                    TfpgButton(Components[j]).OnMouseDown;
                    TfpgButton(Components[j]).OnMouseDown := @sak.SAKMouseDown;

                end
                else

                if (Components[j] is TfpgLabel) then
                begin
                  SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

                  sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
                    TSAK_IAssistive.Create();

                  sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
                    'Label,';
                  sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
                    TfpgLabel(Components[j]);
                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnClick :=
                    TfpgLabel(Components[j]).OnClick;
                  TfpgLabel(Components[j]).OnClick := @sak.SAKClick;
                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
                    TfpgLabel(Components[j]).OnMouseMove;
                  TfpgLabel(Components[j]).OnMouseMove := @sak.SAKMouseMove;
                   sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
                    TfpgLabel(Components[j]).OnMouseDown;
                    TfpgLabel(Components[j]).OnMouseDown := @sak.SAKMouseDown;
                end
                else
                if (Components[j] is TfpgStringGrid) then
                begin
                  SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

                  sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
                    TSAK_IAssistive.Create();

                  sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
                    'Grid,';
                  sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
                    TfpgStringGrid(Components[j]);
                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnFocusChange :=
                    TfpgStringGrid(Components[j]).OnFocusChange;

                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
                    TfpgStringGrid(Components[j]).OnMouseDown;
                    TfpgStringGrid(Components[j]).OnMouseDown := @sak.SAKMouseDown;

                      sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnKeyPress :=
                    TfpgStringGrid(Components[j]).OnKeyPress;
                       TfpgStringGrid(Components[j]).OnKeyPress := @sak.SAKKeyPress;

                  TfpgStringGrid(Components[j]).OnFocusChange := @sak.SAKFocusChange;

                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
                    TfpgStringGrid(Components[j]).OnEnter;
                  TfpgStringGrid(Components[j]).OnEnter := @sak.SAKEnter;

                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
                    TfpgStringGrid(Components[j]).OnMouseMove;
                  TfpgStringGrid(Components[j]).OnMouseMove := @sak.SAKMouseMove;
                end
                else
                if (Components[j] is TfpgTrackBar) then
                begin
                  SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

                  sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
                    TSAK_IAssistive.Create();

                  sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
                    'Track bar,';
                  sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
                    TfpgTrackBar(Components[j]);

                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnTrackbarChange :=
                    TfpgTrackBar(Components[j]).OnChange;

                  TfpgTrackBar(Components[j]).OnChange := @sak.SAKTrackBarChange;

                 sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
                    TfpgTrackBar(Components[j]).OnEnter;

                  TfpgTrackBar(Components[j]).OnEnter := @sak.SAKEnter;

                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
                    TfpgTrackBar(Components[j]).OnMouseMove;
                  TfpgTrackBar(Components[j]).OnMouseMove := @sak.SAKMouseMove;

                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
                               TfpgTrackBar(Components[j]).OnMouseDown;
                    TfpgTrackBar(Components[j]).OnMouseDown := @sak.SAKMouseDown;
                end
                else
                if (Components[j] is TfpgRadiobutton) then
                begin
                  SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

                  sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
                    TSAK_IAssistive.Create();

                  sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
                    'Radio Button,';
                  sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
                    TfpgRadiobutton(Components[j]);

                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnChange :=
                    TfpgRadiobutton(Components[j]).OnChange;

                  TfpgRadiobutton(Components[j]).OnChange := @sak.SAKChange;


                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
                    TfpgRadiobutton(Components[j]).OnEnter;

                  TfpgRadiobutton(Components[j]).OnEnter := @sak.SAKEnter;

                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
                    TfpgRadiobutton(Components[j]).OnMouseMove;
                  TfpgRadiobutton(Components[j]).OnMouseMove := @sak.SAKMouseMove;

                   sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
                               TfpgRadiobutton(Components[j]).OnMouseDown;
                    TfpgRadiobutton(Components[j]).OnMouseDown := @sak.SAKMouseDown;
                end
                else

                if (Components[j] is TfpgCheckBox) then
                begin
                  SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

                  sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
                    TSAK_IAssistive.Create();

                  sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
                    'Check Box,';
                  sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
                    TfpgCheckBox(Components[j]);
                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnChange :=
                    TfpgCheckBox(Components[j]).OnChange;
                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
                    TfpgCheckBox(Components[j]).OnEnter;

                  TfpgCheckBox(Components[j]).OnChange := @sak.SAKChange;
                  TfpgCheckBox(Components[j]).OnEnter := @sak.SAKEnter;
                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
                    TfpgCheckBox(Components[j]).OnMouseMove;
                  TfpgCheckBox(Components[j]).OnMouseMove := @sak.SAKMouseMove;

                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
                               TfpgCheckBox(Components[j]).OnMouseDown;
                    TfpgCheckBox(Components[j]).OnMouseDown := @sak.SAKMouseDown;
                end
                else
                if (Components[j] is TfpgListBox) then
                begin
                  SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

                  sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
                    TSAK_IAssistive.Create();

                  sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
                    'List Box,';
                  sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
                    TfpgListBox(Components[j]);
                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnChange :=
                    TfpgListBox(Components[j]).OnChange;

                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
                    TfpgListBox(Components[j]).OnEnter;

                  TfpgListBox(Components[j]).OnChange := @sak.SAKChange;
                  TfpgListBox(Components[j]).OnEnter := @sak.SAKEnter;

                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
                    TfpgListBox(Components[j]).OnMouseMove;
                  TfpgListBox(Components[j]).OnMouseMove := @sak.SAKMouseMove;

                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
                               TfpgListBox(Components[j]).OnMouseDown;
                    TfpgListBox(Components[j]).OnMouseDown := @sak.SAKMouseDown;

                end
                else
                if (Components[j] is TfpgComboBox) then
                begin
                  SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

                  sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
                    TSAK_IAssistive.Create();

                  sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
                    'Combo Box,';
                  sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
                    TfpgComboBox(Components[j]);
                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnChange :=
                    TfpgComboBox(Components[j]).OnChange;
                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
                    TfpgComboBox(Components[j]).OnEnter;
                  TfpgComboBox(Components[j]).OnChange := @sak.SAKChange;
                  TfpgComboBox(Components[j]).OnEnter := @sak.SAKEnter;

                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
                    TfpgComboBox(Components[j]).OnMouseMove;
                  TfpgComboBox(Components[j]).OnMouseMove := @sak.SAKMouseMove;

                    sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
                               TfpgComboBox(Components[j]).OnMouseDown;
                    TfpgComboBox(Components[j]).OnMouseDown := @sak.SAKMouseDown;
                end
                else
                if (Components[j] is TfpgMemo) then
                begin
                  SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

                  sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
                    TSAK_IAssistive.Create();

                  sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
                    'Memo,';
                  sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
                    TfpgMemo(Components[j]);
                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
                    TfpgMemo(Components[j]).OnEnter;
                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnKeyChar :=
                    TfpgMemo(Components[j]).OnKeyChar;

                     sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnKeyPress :=
                    TfpgMemo(Components[j]).OnKeyPress;
                       TfpgMemo(Components[j]).OnKeyPress := @sak.SAKKeyPress;

                                TfpgMemo(Components[j]).OnEnter := @sak.SAKEnter;
                  TfpgMemo(Components[j]).OnKeyChar := @sak.SAKKeyChar;

                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
                    TfpgMemo(Components[j]).OnMouseMove;
                  TfpgMemo(Components[j]).OnMouseMove := @sak.SAKMouseMove;

                   sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
                               TfpgMemo(Components[j]).OnMouseDown;
                    TfpgMemo(Components[j]).OnMouseDown := @sak.SAKMouseDown;
                end
                else
                if (Components[j] is TfpgEdit) then
                begin
                  SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

                  sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
                    TSAK_IAssistive.Create();

                  sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
                    'Edit,';
                  sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
                    TfpgEdit(Components[j]);
                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
                    TfpgEdit(Components[j]).OnEnter;
                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnKeyChar :=
                    TfpgEdit(Components[j]).OnKeyChar;
                  TfpgEdit(Components[j]).OnEnter := @sak.SAKEnter;
                  TfpgEdit(Components[j]).OnKeyChar := @sak.SAKKeyChar;

                      sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnKeyPress :=
                    TfpgEdit(Components[j]).OnKeyPress;
                       TfpgEdit(Components[j]).OnKeyPress := @sak.SAKKeyPress;


                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
                    TfpgEdit(Components[j]).OnMouseMove;
                  TfpgEdit(Components[j]).OnMouseMove := @sak.SAKMouseMove;

                  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
                               TfpgEdit(Components[j]).OnMouseDown;
                    TfpgEdit(Components[j]).OnMouseDown := @sak.SAKMouseDown;
                end

          else
          if (Components[j] is TComponent) then
          begin
          UpdateChild(Components[j])
              end;

              end;

end;


procedure Tsak.ChildComponentCount(AComponent: TComponent);
var
  i: integer;
begin
  sak.f := sak.f + AComponent.ComponentCount;
  for i := 0 to AComponent.ComponentCount - 1 do
    if AComponent.Components[i].ComponentCount > 0 then
      ChildComponentCount(AComponent.Components[i]);
end;

/////////////////////////// Capture Assistive Procedures


function Tsak.WhatName(Sender: TObject): string;
begin
  if (Sender is TfpgLabel) then
    Result := TfpgLabel(Sender).Text
  else
  if (Sender is TfpgButton) then
  begin
    if (trim(Tfpgbutton(Sender).Text) <> '') then
      Result := Tfpgbutton(Sender).Text
    else
    if (trim(Tfpgbutton(Sender).Name) <> '') then
      Result := Tfpgbutton(Sender).Name
    else
    if (trim(Tfpgbutton(Sender).hint) <> '') then
      Result := Tfpgbutton(Sender).hint
    else
      Result := Tfpgbutton(Sender).ImageName;
  end
  else
  if (Sender is TfpgForm) then
  begin
    if (trim(TfpgForm(Sender).WindowTitle) <> '') then
      Result := TfpgForm(Sender).WindowTitle
    else
    if (trim(TfpgForm(Sender).Name) <> '') then
      Result := TfpgForm(Sender).Name
    else
      Result := TfpgForm(Sender).hint;
  end
  else
  if (Sender is TfpgPanel) then
    Result := TfpgPanel(Sender).Name
  else
  if (Sender is TfpgEdit) then
    Result := TfpgEdit(Sender).Name
  else
  if (Sender is TfpgMemo) then
    Result := TfpgMemo(Sender).Name
  else
  if (Sender is TfpgStringgrid) then
    Result := TfpgStringgrid(Sender).Name
  else
  if (Sender is TfpgRadiobutton) then
    Result := TfpgRadiobutton(Sender).Text
  else
  if (Sender is TfpgCheckBox) then
    Result := TfpgCheckBox(Sender).Text
  else
  if (Sender is TfpgListBox) then
    Result := TfpgListBox(Sender).Text
  else
  if (Sender is TfpgFileDialog) then
    Result := TfpgFileDialog(Sender).WindowTitle
  else
  if (Sender is TfpgMenuBar) then
    Result := TfpgMenuBar(Sender).Name
  else
  if (Sender is TfpgPopupMenu) then
    Result := TfpgPopupMenu(Sender).Name
  else
  if (Sender is TfpgMenuItem) then
    Result := TfpgMenuItem(Sender).Text
  else
  if (Sender is TfpgTrackBar) then
    Result := TfpgTrackBar(Sender).Name
  else
  if (Sender is TfpgComboBox) then
    Result := TfpgComboBox(Sender).Name
  else
  if (Sender is TfpgWidget) then
    Result := TfpgWidget(Sender).Name;

end;

procedure TSAK.SAKDestroy(Sender: TObject);
var
  i: integer;
begin
  isenabled := False;
  timercount.Enabled := False;
  unLoadLib;
  for i := 0 to (Length(sak.AssistiveData) - 1) do
  begin
    if (Sender = sak.AssistiveData[i].TheObject) and (sak.AssistiveData[i].OriOnDestroy <> nil) then
    begin
      sak.AssistiveData[i].OriOnDestroy(Sender);
      exit;
    end;
  end;
  isenabled := True;
  timercount.Enabled := True;
end;

procedure TSAK.SAKClick(Sender: TObject);
var
  i: integer = 0;
  finded: boolean = False;
begin
  TimerRepeat.Enabled := False;
   TimerRepeat.OnTimer := @CheckRepeatClick;
  TimerRepeat.Interval := 500;
   CheckObject := Sender;
   TimerRepeat.Enabled := True;

  while (finded = False) and (i < (Length(sak.AssistiveData))) do
  begin
    if (Sender = sak.AssistiveData[i].TheObject) and (sak.AssistiveData[i].OriOnClick <> nil) then
    begin
      sak.AssistiveData[i].OriOnClick(Sender);
      finded := True;
    end;
    Inc(i);
  end;
 end;

procedure TSAK.CheckRepeatClick(Sender: TObject);
var
  texttmp, nameobj: string;
  i: integer;
begin
  TimerRepeat.Enabled := False;
  for i := 0 to (Length(sak.AssistiveData) - 1) do
  begin
    if (CheckObject = sak.AssistiveData[i].TheObject) then
    begin
      espeak_cancel;

      mouseclicked := True;

      nameobj := whatname(CheckObject);

      texttmp := sak.AssistiveData[i].Description + ' ' + nameobj + ' executed';

      espeak_Key(texttmp);
      exit;
    end;
  end;
end;

procedure TSAK.SAKChange(Sender: TObject);
var
  i: integer = 0;
  finded: boolean = False;
begin
  TimerRepeat.Enabled := False;
  espeak_cancel;
  TimerRepeat.OnTimer := @CheckRepeatChange;
  TimerRepeat.Interval := 500;
  CheckObject := Sender;
  TimerRepeat.Enabled := True;

  while (finded = False) and (i < (Length(sak.AssistiveData))) do
  begin
    if (Sender = sak.AssistiveData[i].TheObject) and (sak.AssistiveData[i].OriOnChange <> nil) then
    begin
      sak.AssistiveData[i].OriOnChange(Sender);
      finded := True;
    end;
    Inc(i);
  end;


end;

procedure TSAK.CheckRepeatChange(Sender: TObject);
var
  i: integer;
  texttmp: string;
begin
  TimerRepeat.Enabled := False;
  espeak_cancel;
  for i := 0 to (Length(sak.AssistiveData) - 1) do
  begin
    if (CheckObject = sak.AssistiveData[i].TheObject) then
    begin
        if (CheckObject is TfpgTrackBar) then
        with CheckObject as TfpgTrackBar do
          texttmp := Name + ' position is, ' + IntToStr(position);

      if (CheckObject is TfpgComboBox) then
        with CheckObject as TfpgComboBox do
          texttmp := Text + ' selected';

      if (CheckObject is TfpgListBox) then
        with CheckObject as TfpgListBox do
          texttmp := Text + ' selected';

      if (CheckObject is TfpgCheckBox) then
        with CheckObject as TfpgCheckBox do

          if Checked = False then
            texttmp := 'Change  ' + Text + ', in false'
          else
            texttmp :=
              'Change  ' + Text + ', in true';

      if (CheckObject is TfpgRadioButton) then
        with CheckObject as TfpgRadioButton do
          if Checked = False then
            texttmp := 'Change  ' + Text + ', in false'
          else
            texttmp :=
              'Change  ' + Text + ', in true';

      espeak_Key(texttmp);

      exit;
    end;
  end;
end;

procedure TSAK.SAKTrackbarChange(Sender: TObject; pos: longint);
var
  i: integer = 0;
  finded: boolean = False;
begin
  TimerRepeat.Enabled := False;
  espeak_cancel;
   TimerRepeat.Interval := 800;
  TimerRepeat.OnTimer := @CheckTrackbarChange;
  CheckObject := Sender;
  CheckPos := pos;
  TimerRepeat.Enabled := True;

 while (finded = False) and (i < (Length(sak.AssistiveData))) do
  begin
    if (Sender = sak.AssistiveData[i].TheObject) and (sak.AssistiveData[i].OriOnTrackBarChange <> nil) then
    begin
      sak.AssistiveData[i].OriOnTrackBarChange(Sender, pos);
      finded := True;
    end;
    Inc(i);
  end;

end;

procedure TSAK.CheckTrackbarChange(Sender: TObject);
var
  i: integer;
  texttmp: string;
begin
  TimerRepeat.Enabled := False;
    espeak_cancel;
  for i := 0 to (Length(sak.AssistiveData) - 1) do
  begin
    if (CheckObject = sak.AssistiveData[i].TheObject) and (CheckObject is TfpgTrackBar) then
    begin
      //  espeak_cancel ;
      with CheckObject as TfpgTrackBar do
      begin
        texttmp := Name + ' position is, ' + IntToStr(position);
        espeak_Key(texttmp);

        exit;
      end;
    end;
  end;
end;

procedure TSAK.SAKFocusChange(Sender: TObject; col: longint; row: longint);
var
  i: integer = 0;
  finded: boolean = False;
begin
  TimerRepeat.Enabled := False;
  TimerRepeat.OnTimer := @CheckFocusChange;
  CheckObject := Sender;
  CheckCol := col;
  CheckRow := row;
  TimerRepeat.Enabled := True;

  while (finded = False) and (i < (Length(sak.AssistiveData))) do
  begin
    if (Sender = sak.AssistiveData[i].TheObject) and (sak.AssistiveData[i].OriOnFocusChange <> nil) then
    begin
      sak.AssistiveData[i].OriOnFocusChange(Sender, col, row);
      finded := True;
    end;
    Inc(i);
  end;

end;

procedure TSAK.CheckFocusChange(Sender: TObject);
var
  i: integer;
  texttmp: string;
begin
  TimerRepeat.Enabled := False;
  for i := 0 to high(sak.AssistiveData) do

    if (CheckObject = sak.AssistiveData[i].TheObject) and (CheckObject is tfpgstringgrid) then
    begin
      espeak_cancel;
      with CheckObject as tfpgstringgrid do
      begin
        texttmp := ColumnTitle[focuscol] + ', row ' + IntToStr(focusrow + 1) + '. ' + Cells[focuscol, focusrow];
        espeak_Key(texttmp);
      end;
      exit;
    end;
end;

procedure TSAK.SAKMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; const pointm: Tpoint);
begin
end;

procedure TSAK.SAKMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; const pointm: Tpoint);
begin
end;

procedure TSAK.SAKMouseMove(Sender: TObject; Shift: TShiftState; const thePoint: TPoint);
var
  i: integer = 0;
  finded: boolean = False;
begin
  TimerRepeat.Enabled := False;
   TimerRepeat.OnTimer := @CheckRepeatMouseMove;
  TimerRepeat.Interval := 600;
  CheckObject := Sender;
  CheckPoint := thePoint;
  CheckShift := Shift;
  TimerRepeat.Enabled := True;

  while (finded = False) and (i < (Length(sak.AssistiveData))) do
  begin
    if (Sender = sak.AssistiveData[i].TheObject) and (sak.AssistiveData[i].OriOnMouseMove <> nil) then
    begin
      sak.AssistiveData[i].OriOnMouseMove(Sender, Shift, thePoint);
      finded := True;
    end;
    Inc(i);
  end;

end;

procedure TSAK.CheckRepeatMouseMove(Sender: TObject);
var
  texttmp, stringtemp, nameobj: string;
  i: integer;
begin
  if (mouseclicked = False) and (whatname(CheckObject) <> lastfocused) then
  begin
    TimerRepeat.Enabled := False;
    for i := 0 to (Length(sak.AssistiveData) - 1) do
    begin
      if (CheckObject = sak.AssistiveData[i].TheObject) then
      begin
        espeak_cancel;
        if CheckObject is TfpgForm then
         begin
        lastfocused := ' ';

        //  texttmp := 'Left,  ' + IntToStr(CheckPoint.X) + ' , of,  ' + IntToStr(TfpgForm(CheckObject).Width) +
        //    '.   Top,  ' + IntToStr(CheckPoint.y) + ' , of, ' + IntToStr(TfpgForm(CheckObject).Height);
        // espeak_Key(texttmp);
        end
         else
         begin
        nameobj := whatname(CheckObject);
        lastfocused := nameobj;

        stringtemp := '' ;

        if  (CheckObject is tfpgcheckbox) then
        begin
          if tfpgcheckbox(CheckObject).Checked = false then stringtemp := ' , false, ' else stringtemp := ' , true, ';
        end;

         if  (CheckObject is tfpgradiobutton) then
        begin
          if tfpgradiobutton(CheckObject).Checked = false then stringtemp := ' , false, ' else stringtemp := ' , true, ';
        end;

         if  (CheckObject is tfpgtrackbar) then
        begin
        stringtemp := ' , ' + inttostr(tfpgtrackbar(CheckObject).Position) + ' , ' ;
        end;

        texttmp := sak.AssistiveData[i].Description + ' ' + nameobj + stringtemp + ' ,focused';
        espeak_Key(texttmp);
        //end;
        exit;
      end;
    end;
  end;
end;

end;

procedure TSAK.SAKEnter(Sender: TObject);
var
  i: integer = 0;
  finded: boolean = False;
begin
  TimerRepeat.Enabled := False;
   TimerRepeat.OnTimer := @CheckRepeatEnter;
  TimerRepeat.Interval := 600;
   CheckObject := Sender;
  TimerRepeat.Enabled := True;

  while (finded = False) and (i < (Length(sak.AssistiveData))) do
  begin
    if (Sender = sak.AssistiveData[i].TheObject) and (sak.AssistiveData[i].OriOnEnter <> nil) then
    begin
      sak.AssistiveData[i].OriOnEnter(Sender);
      finded := True;
    end;
    Inc(i);
  end;

end;

procedure TSAK.CheckRepeatEnter(Sender: TObject);
var
  texttmp, nameobj: string;
  i: integer;
begin
  if mouseclicked = False then
  begin
    TimerRepeat.Enabled := False;
    for i := 0 to (Length(sak.AssistiveData) - 1) do
    begin
      if (CheckObject = sak.AssistiveData[i].TheObject) then
      begin
        espeak_cancel;
        nameobj := whatname(CheckObject);
        texttmp := sak.AssistiveData[i].Description + ' ' + nameobj + ' selected';
        espeak_Key(texttmp);
        exit;
      end;
    end;
  end;
  mouseclicked := False;
end;

procedure TSAK.SAKKeyPress(Sender: TObject; var Key: word; var Shift: TShiftState; var ifok: boolean);
var
  i: integer = 0;
  finded: boolean = False;
   oldlang : string;
  oldgender, oldspeed, oldpitch, oldvolume : integer;
begin

  TimerRepeat.Enabled := False;
  TimerRepeat.OnTimer := @CheckRepeatKeyPress;
 // TimerRepeat.Interval := 600;
  CheckObject := Sender;
  CheckKey := key;
  CheckShift := Shift;
    if (CheckObject is TfpgMemo) or (CheckObject is Tfpgedit)  or (CheckObject is Tfpgstringgrid) then
   begin
     espeak_cancel;
  oldlang := voice_language;
    if voice_gender = '' then
    oldgender := -1 else
     if voice_gender = 'm3' then
    oldgender := 1 else
     oldgender := 2 ;
  oldspeed := voice_speed;
  oldpitch := voice_pitch;
  oldvolume := voice_volume;
     if CheckKey = 32 then
   begin
   //espeak_Key('space') ;

   SAKSetVoice(2,'',150,-1,-1);
    if (CheckObject is TfpgMemo) then espeak_Key(WhatWord(CheckObject))
   else espeak_Key(Theword) ;
   TheSentence := TheSentence + ' ' + TheWord;
   Theword := '';
   SAKSetVoice(oldgender,oldlang,oldspeed,oldpitch,oldvolume);
   end else
   if (CheckKey = 46) or (CheckKey = 63)
   or (CheckKey = 33) then
   begin
   //espeak_Key('dot') ;
   SAKSetVoice(2,'',150,-1,-1);
     if (CheckObject is TfpgMemo) then espeak_Key(Whatword(CheckObject)+ ', ' + WhatLine(CheckObject))
   else  espeak_Key( Theword + ', ' + TheSentence + ' ' + Theword) ;
   SAKSetVoice(oldgender,oldlang,oldspeed,oldpitch,oldvolume);
   TheSentence := '';
   Theword := '';
   end

  else
  begin
     if ((CheckObject is Tfpgstringgrid) or (CheckObject is TfpgMemo) or (CheckObject is Tfpgtrackbar)) and ( (CheckKey =keyUp) or (CheckKey = keydown) or
     (CheckKey =57398) or (CheckKey = 57399) or
  (CheckKey = keyleft) or (CheckKey = keyright)) then
  begin
   if CheckKey =keyUp then
     espeak_Key('up') else
   if CheckKey =keydown then  espeak_Key('down') else
   if CheckKey =keyleft then  espeak_Key('left') else
   if CheckKey =keyright then  espeak_Key('right') else
    if CheckKey =57398 then  espeak_Key('page up') else
   if CheckKey =57399 then  espeak_Key('page down') ;

   TimerRepeat.Interval := 600 ;
  end
  else  TimerRepeat.Interval := 1 ;
    TimerRepeat.Enabled := True;
   end;


   end
   else
   begin
   TimerRepeat.Interval := 700;
   TimerRepeat.Enabled := True;
   end;

  while (finded = False) and (i < (Length(sak.AssistiveData))) do
  begin
    if (Sender = sak.AssistiveData[i].TheObject) and (sak.AssistiveData[i].OriOnKeyPress <> nil) then
    begin
      sak.AssistiveData[i].OriOnKeyPress(Sender, key, shift, ifok);
      finded := True;
    end;
    Inc(i);
  end;

end;

procedure TSAK.CheckRepeatKeyPress(Sender: TObject);
var
  i: integer;
  ifok: boolean = True;
oldlang: string;
 oldgender, oldspeed, oldpitch, oldvolume : integer;
begin
  TimerRepeat.Enabled := False;
  for i := 0 to high(sak.AssistiveData) do
  begin
    if (CheckObject = sak.AssistiveData[i].TheObject) then
    begin

  oldlang := voice_language;
      if voice_gender = '' then
    oldgender := -1 else
     if voice_gender = 'm3' then
    oldgender := 1 else
     oldgender := 2 ;
  oldspeed := voice_speed;
  oldpitch := voice_pitch;
  oldvolume := voice_volume;

  if (CheckKey = 13) or  (CheckKey = 8) or (CheckKey = 32) or (CheckKey =keyUp) or (CheckKey = keydown) or
  (CheckKey = keyleft) or (CheckKey = keyright) or (CheckKey = 57601) or (CheckKey = 57602) or (CheckKey = 57603) or   (CheckKey = 57604) or
(CheckKey = 57605) or (CheckKey = 57606) or (CheckKey = 57607) or   (CheckKey = 57608) or (CheckKey = 57609) or (CheckKey = 57610) or
(CheckKey = 57611) or   (CheckKey = 57612) or (CheckKey = 9) or (CheckKey = 58112) or (CheckKey = 58176) or   (CheckKey = 58113) or
(CheckKey = 58177) or (CheckKey = 18) or (CheckKey = 58247) or   (CheckKey = 65535) or
(CheckKey = 57398) or (CheckKey = 57399) or (CheckKey = 127) or   (CheckKey = 57378) or (CheckKey = 27) or (CheckKey = 57401) or   (CheckKey = 57400)
then
 begin
      espeak_cancel;   //

      case CheckKey of

          13: espeak_Key('enter');
          8: begin  /// backspace
           if (CheckObject is Tfpgedit) and (length(theword) > 1) then
    begin
    theword := copy(theword,1,length(theword)-1);
     SAKSetVoice(2,'',165,-1,-1);
      espeak_Key('back space, ' + theword) ;
     SAKSetVoice(oldgender,oldlang,oldspeed,oldpitch,oldvolume);
     end  else
      if (CheckObject is Tfpgmemo) then
       espeak_Key('back space, ' + WhatDeleted(CheckObject))
      else
                    espeak_Key('back space');
  end;
          32: begin
          if (CheckObject is TfpgCheckBox) or (CheckObject is TfpgRadioButton) or (CheckObject is TfpgComboBox) or
              (CheckObject is TfpgListBox) then
            else
              espeak_Key('space');
             end;

          keyUp:
          begin
             if (CheckObject is Tfpgmemo) then   espeak_Key(' in ' + whatline(CheckObject) + ', ' + whatpos(CheckObject,1)) else
             begin

            if (CheckObject is TfpgTrackBar) then
              with CheckObject as TfpgTrackBar do
              begin
            if Position + ScrollStep <= max then
               Position := Position + ScrollStep;

            espeak_Key(Name + ' position is, ' + IntToStr(position));
                end;

           if (CheckObject is Tfpgstringgrid) then
              with CheckObject as Tfpgstringgrid do
               CheckFocusChange(CheckObject) else
                espeak_Key('up');
           end;

          end;

          keydown:
          begin

          if (CheckObject is Tfpgmemo) then  espeak_Key(' in ' + whatline(CheckObject) +', ' + whatpos(CheckObject,1))
          else
             begin

            if (CheckObject is TfpgTrackBar) then
              with CheckObject as TfpgTrackBar do
              begin
                 if Position - ScrollStep >= min then
           position := Position - ScrollStep;

                  espeak_Key(Name + ' position is, ' + IntToStr(position));
                end;

             if (CheckObject is Tfpgstringgrid) then
               with CheckObject as Tfpgstringgrid do
               CheckFocusChange(CheckObject) else
             espeak_Key('down');
          end;

            end;

          keyleft:
          begin

            if (CheckObject is Tfpgmemo) then  espeak_Key(whatpos(CheckObject,0))
            else begin

            if (CheckObject is TfpgTrackBar) then
              with CheckObject as TfpgTrackBar do
              begin
                 if Position - ScrollStep >= min then
                 Position := Position - ScrollStep;

                    espeak_Key(Name + ' position is, ' + IntToStr(position));
                  end;

            if (CheckObject is Tfpgstringgrid) then
              with CheckObject as Tfpgstringgrid do
               CheckFocusChange(CheckObject) else
                 espeak_Key('left');

          end;

          end;

          keyright:
          begin

            if (CheckObject is Tfpgmemo) then espeak_Key(whatpos(CheckObject,0)) else
             begin

            if (CheckObject is TfpgTrackBar) then
              with CheckObject as TfpgTrackBar do
             begin
               if Position + ScrollStep <= max then
                  Position := Position + ScrollStep;
                  espeak_Key(Name + ' position is, ' + IntToStr(position));
                end;

            if (CheckObject is Tfpgstringgrid) then
              with CheckObject as Tfpgstringgrid do
               CheckFocusChange(CheckObject) else
                espeak_Key('right');

          end;

          end;
          57601: espeak_Key('f, 1');
          57602: espeak_Key('f, 2');
          57603: espeak_Key('f, 3');
          57604: espeak_Key('f, 4');
          57605: espeak_Key('f, 5');
          57606: espeak_Key('f, 6');
          57607: espeak_Key('f, 7');

          57608: espeak_Key('f, 8');
          9: espeak_Key('tab');
          58112: espeak_Key('shift, left');
          58176: espeak_Key('shift, right');
          58113: espeak_Key('control, right');
          58177: espeak_Key('control, left');
          18: espeak_Key('alt');
          58247: espeak_Key('caps, lock');
          65535: espeak_Key('alt, gr');

          57398:   if (CheckObject is Tfpgstringgrid) then
               with CheckObject as Tfpgstringgrid do
               CheckFocusChange(CheckObject) else
             espeak_Key('page, up');
          57399:   if (CheckObject is Tfpgstringgrid) then
               with CheckObject as Tfpgstringgrid do
               CheckFocusChange(CheckObject) else
             espeak_Key('page, down');

          127:   if (CheckObject is Tfpgmemo) then
           espeak_Key('delete, ' + WhatDeleted(CheckObject))
          else
                      espeak_Key('delete');
          57378: espeak_Key('insert');
          27: espeak_Key('escape');
          57401: espeak_Key('end');
          57400: espeak_Key('home');


         57609:  espeak_Key('f, 9');

          57610: if (CheckObject is TfpgMemo) then
                    begin
                SAKSetVoice(2,'',165,-1,-1);
               espeak_Key( whatword(CheckObject)) ;
                SAKSetVoice(oldgender,oldlang,oldspeed,oldpitch,oldvolume);
              end
                  else espeak_Key('f, 10');

          57611: if (CheckObject is TfpgMemo) then
                    begin
                SAKSetVoice(2,'',165,-1,-1);
                espeak_Key(whatline(CheckObject)) ;
                SAKSetVoice(oldgender,oldlang,oldspeed,oldpitch,oldvolume);
              end
                  else espeak_Key('f, 11');

          57612: if (CheckObject is TfpgMemo) then
              with CheckObject as TfpgMemo do
              begin
                SAKSetVoice(2,'',165,-1,-1);
                espeak_Key(Text) ;
                SAKSetVoice(oldgender,oldlang,oldspeed,oldpitch,oldvolume);
              end
            else
            if (CheckObject is Tfpgedit) then
             with CheckObject as Tfpgedit do
              begin
                SAKSetVoice(2,'',165,-1,-1);
                espeak_Key(Text) ;
                SAKSetVoice(oldgender,oldlang,oldspeed,oldpitch,oldvolume);
              end
            else
              espeak_Key('f, 12');
        end;
        exit;
        end else    espeak_Key(KeycodeToText(CheckKey, [])) ;
    end;
  end;
end;

procedure TSAK.SAKKeyChar(Sender: TObject; Key: TfpgChar; var ifok: boolean);
var
  i: integer = 0;
  finded: boolean = False;
begin
   CheckObject := Sender;
   CheckKeyChar := key;

     if (Sender is TfpgMemo) or (Sender is Tfpgedit) then
  Theword := Theword + key;

  while (finded = False) and (i < (Length(sak.AssistiveData))) do
  begin
    if (Sender = sak.AssistiveData[i].TheObject) and (sak.AssistiveData[i].OriOnKeyChar <> nil) then
    begin
      sak.AssistiveData[i].OriOnKeyChar(Sender, key, ifok);
      finded := True;
    end;
    Inc(i);
  end;
 end;

procedure TSAK.CheckRepeatKeyChar(Sender: TObject);
var
  tempstr: string;
  i: integer;
  ifok: boolean;
begin
  ifok := True;
  TimerRepeat.Enabled := False;
    for i := 0 to (Length(sak.AssistiveData) - 1) do
  begin
    if (CheckObject = sak.AssistiveData[i].TheObject) then
    begin
      espeak_cancel;
     tempstr := CheckKeyChar;
      tempstr := trim(tempstr);
      if tempstr <> '' then
        espeak_Key(tempstr);
      exit;
    end;
  end;
end;

////////////////////// Loading Procedure

 ///// to find the file in sak.ini (what => 0 = espeak bin, 1 = portaudio lib, 2 = espeak lib, 3 = epeak-data dir)
function WhatFile(sakini : string; what : integer) : string;
var
tf: textfile;
ffinded : boolean ;
dataf, whatfil : string;
len : integer;
begin
ffinded := false;
result := '';

//writeln( 'sakini is ' + sakini);

if fileexists(sakini) then
begin
  AssignFile(tf,pchar(sakini));
   Reset(tF);

   case what of
    0: whatfil := 'BINESPEAK=';
    1: whatfil := 'LIBPORTAUDIO=';
    2: whatfil := 'LIBESPEAK=';
    3: whatfil := 'DIRESPEAKDATA=';
     end;

   len := length(whatfil);

   while (eof(tf) = false) and (ffinded = false) do
     begin
       Readln(tF, dataf);
    dataf := trim(dataf);

    if  Pos(whatfil,dataf) > 0 then
   begin
    if  Pos('#',dataf) > 0 then  dataf := trim(copy(dataf,1, Pos('#',dataf)-1));
     result := copy(dataf,Pos(whatfil,dataf)+ len , length(dataf)-len);

     ffinded := true;
   end;
     end;
  CloseFile(tf);
end;

end;

{$ifdef unix}

function ChangePermission(thefile : string; raisemessage : boolean = true) : integer ;
var
info : stat;
adialog: TWarning;
begin
  result := 0;
 if (FpStat(thefile,info{%H-})<>-1) and FPS_ISREG(info.st_mode) and
             (BaseUnix.FpAccess(thefile,BaseUnix.X_OK)=0) then else
 begin
  if raisemessage = true then
  begin
   fpgApplication.CreateForm(TWarning, adialog);

  adialog.Label1.Text:=  'Permission mode of file:';
  adialog.Label3.Text:= 'is not set as executable...' ;
  adialog.Label4.Text:='Do you want to reset it?';

   adialog.Label2.Text:=  thefile;

   if adialog.Label2.width + 16 > (2*adialog.Button1.width) + 100 then
   adialog.width :=  adialog.Label2.width + 16 else adialog.width := (2*adialog.Button1.width) + 100 ;
   adialog.Label1.width := adialog.Label2.width ;
   adialog.Label3.width := adialog.Label2.width ;
   adialog.Label4.width := adialog.Label2.width ;

   adialog.Button1.Left:= (adialog.width div 2) - adialog.Button1.width - 30 ;
   adialog.Button2.Left:= (adialog.width div 2) + 30 ;

   adialog.UpdateWindowPosition;
   adialog.ShowModal;

     if  adialog.modresult = 1 then
   begin
     fpchmod(thefile, S_IRWXU);
   end else result := -1;
   freeandnil(adialog);
  end else result := -1;

  end;
end;
{$endif}


function TSAK.LoadLib: integer;
begin
 Result := -1;
if  isenabled = false then
begin
 old8087cw := Get8087CW;
  isenabled := False;
  SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide, exOverflow, exUnderflow, exPrecision]);
  Set8087CW($133f);

  result:= 0;
  TimerRepeat := Tfpgtimer.Create(50000);
  TimerRepeat.Enabled := False;
  TimerCount := Tfpgtimer.Create(50000);
  TimerCount.Enabled := False;

  AProcess := TProcess.Create(nil);
  AProcess.Options := AProcess.Options + [poNoConsole, poUsePipes];
  AProcess.FreeOnRelease;

//  writeln('ES_LibFileName => ' + ES_LibFileName);

{$ifdef unix}
  if trim(ES_LibFileName) <> '' then
begin
 AProcess.Environment.Text := 'LD_LIBRARY_PATH=' + ExtractFilePath(ES_LibFileName) ;
if trim(PA_LibFileName) <> '' then
   AProcess.Environment.Text := AProcess.Environment.Text + ':' + ExtractFilePath(PA_LibFileName)

end  else
  if trim(PA_LibFileName) <> '' then
   AProcess.Environment.Text := 'LD_PRELOAD=' + PA_LibFileName ;
{$endif}

  AProcess.Executable :=  ES_ExeFileName;

  TheWord := '' ;
  TheSentence := '' ;

  voice_gender := '' ;
  voice_language := '' ;
  voice_speed := -1 ;
  voice_pitch := -1 ;
  voice_volume := -1 ;

  espeak_Key('sak is working...');

    f := 0;
    ChildComponentCount(fpgApplication);
    CompCount := f;
    //  CompCount := fpgapplication.ComponentCount;
    InitObject;
    TimerRepeat.Enabled := False;
    TimerRepeat.Interval := 600;
    TimerCount.Enabled := False;
    TimerCount.Interval := 700;
    timerCount.OnTimer := @CheckCount;
    TimerCount.Enabled := True;
    isenabled := True;
   result:= 0;
 end;

end;

function SAKUnLoadLib: integer;
var
 i : integer;
begin
  result := -1 ;
   isenabled := False;
  if assigned(sak) then
  begin
    result := 0 ;

sak.UnLoadLib;
   sleep(100);

  if assigned(sak.AProcess) then freeandnil(sak.AProcess);
    freeandnil(sak.TimerRepeat);
     freeandnil(sak.TimerCount);

     for i := 0 to high(sak.AssistiveData) do
      sak.AssistiveData[i].Free;
     Set8087CW(sak.old8087cw);
      freeandnil(sak);
        result := 0 ;
  end;

end;

procedure TSAK.UnLoadLib;
var
  i: integer;
begin
     sak.TimerCount.Enabled := False;
      sak.TimerRepeat.Enabled := False;

    espeak_cancel;

    for i := 0 to high(sak.AssistiveData) do
    begin
      if (assigned(sak.AssistiveData[i].TheObject)) and (sak.AssistiveData[i].TheObject is Tfpgapplication) then
      begin
        Tfpgapplication(sak.AssistiveData[i].TheObject).OnKeyPress :=
          sak.AssistiveData[i].OriOnKeyPress;
      end
      else
      if (assigned(sak.AssistiveData[i].TheObject)) and (sak.AssistiveData[i].TheObject is TfpgForm) then
      begin
        TfpgForm(sak.AssistiveData[i].TheObject).OnMouseMove :=
          sak.AssistiveData[i].oriOnMouseMove;
        TfpgForm(sak.AssistiveData[i].TheObject).OnKeyPress :=
          sak.AssistiveData[i].OriOnKeyPress;
        TfpgForm(sak.AssistiveData[i].TheObject).OnMouseDown :=
          sak.AssistiveData[i].OriOnMouseDown;
        TfpgForm(sak.AssistiveData[i].TheObject).OnDestroy :=
          sak.AssistiveData[i].OriOnDestroy;
      end
      {
        else
      if (assigned(sak.AssistiveData[i].TheObject)) and (sak.AssistiveData[i].TheObject is TfpgPanel) then
      begin
        TfpgPanel(sak.AssistiveData[i].TheObject).OnClick :=
          sak.AssistiveData[i].OriOnClick;
        TfpgPanel(sak.AssistiveData[i].TheObject).OnMouseMove :=
          sak.AssistiveData[i].oriOnMouseMove;
      end
      }
      else
      if (assigned(sak.AssistiveData[i].TheObject)) and (sak.AssistiveData[i].TheObject is TfpgLabel) then
      begin
        TfpgLabel(sak.AssistiveData[i].TheObject).OnClick :=
          sak.AssistiveData[i].OriOnClick;
        TfpgLabel(sak.AssistiveData[i].TheObject).OnMouseMove :=
          sak.AssistiveData[i].oriOnMouseMove;
         TfpgLabel(sak.AssistiveData[i].TheObject).OnMouseDown :=
          sak.AssistiveData[i].OriOnMouseDown;
      end
      else
      if (assigned(sak.AssistiveData[i].TheObject)) and (sak.AssistiveData[i].TheObject is TfpgButton) then
      begin
        TfpgButton(sak.AssistiveData[i].TheObject).OnClick :=
          sak.AssistiveData[i].OriOnClick;
        TfpgButton(sak.AssistiveData[i].TheObject).OnEnter :=
          sak.AssistiveData[i].OriOnEnter;
        TfpgButton(sak.AssistiveData[i].TheObject).OnMouseMove :=
          sak.AssistiveData[i].oriOnMouseMove;

       TfpgButton(sak.AssistiveData[i].TheObject).OnMouseDown :=
          sak.AssistiveData[i].OriOnMouseDown;
      end
      else
      if (assigned(sak.AssistiveData[i].TheObject)) and (sak.AssistiveData[i].TheObject is TfpgPopupMenu) then
      begin
        TfpgPopupMenu(sak.AssistiveData[i].TheObject).OnShow :=
          sak.AssistiveData[i].OriOnClick;
      end
      else
      if (assigned(sak.AssistiveData[i].TheObject)) and (sak.AssistiveData[i].TheObject is TfpgMenuItem) then
      begin
        TfpgMenuItem(sak.AssistiveData[i].TheObject).OnClick :=
          sak.AssistiveData[i].OriOnClick;
        //   TfpgMenuItem(sak.AssistiveData[i].TheObject).OnEnter :=
        //  sak.AssistiveData[i].OriOnEnter;
      end
      else
      if (assigned(sak.AssistiveData[i].TheObject)) and (sak.AssistiveData[i].TheObject is TfpgEdit) then
      begin
        TfpgEdit(sak.AssistiveData[i].TheObject).OnKeyChar :=
          sak.AssistiveData[i].OriOnKeyChar;
        TfpgEdit(sak.AssistiveData[i].TheObject).OnEnter :=
          sak.AssistiveData[i].OriOnEnter;
        TfpgEdit(sak.AssistiveData[i].TheObject).OnMouseMove :=
          sak.AssistiveData[i].oriOnMouseMove;
         TfpgEdit(sak.AssistiveData[i].TheObject).OnMouseDown :=
          sak.AssistiveData[i].OriOnMouseDown;
          TfpgEdit(sak.AssistiveData[i].TheObject).OnKeyPress :=
          sak.AssistiveData[i].OriOnKeyPress;
      end
      else
      if (assigned(sak.AssistiveData[i].TheObject)) and (sak.AssistiveData[i].TheObject is TfpgMemo) then
      begin
        TfpgMemo(sak.AssistiveData[i].TheObject).OnKeyChar :=
          sak.AssistiveData[i].OriOnKeyChar;
          TfpgMemo(sak.AssistiveData[i].TheObject).OnKeyPress :=
          sak.AssistiveData[i].OriOnKeyPress;
        TfpgMemo(sak.AssistiveData[i].TheObject).OnEnter :=
          sak.AssistiveData[i].OriOnEnter;
        TfpgMemo(sak.AssistiveData[i].TheObject).OnMouseMove :=
          sak.AssistiveData[i].oriOnMouseMove;
         TfpgMemo(sak.AssistiveData[i].TheObject).OnMouseDown :=
          sak.AssistiveData[i].OriOnMouseDown;
      end
      else
      if (assigned(sak.AssistiveData[i].TheObject)) and (sak.AssistiveData[i].TheObject is TfpgStringgrid) then
      begin
        TfpgStringgrid(sak.AssistiveData[i].TheObject).OnFocusChange :=
          sak.AssistiveData[i].OriOnFocusChange;
        TfpgStringgrid(sak.AssistiveData[i].TheObject).OnMouseDown :=
          sak.AssistiveData[i].OriOnMouseDown;
        TfpgStringgrid(sak.AssistiveData[i].TheObject).OnEnter :=
          sak.AssistiveData[i].OriOnEnter;
        TfpgStringgrid(sak.AssistiveData[i].TheObject).OnMouseMove :=
                  sak.AssistiveData[i].oriOnMouseMove;
         TfpgStringgrid(sak.AssistiveData[i].TheObject).OnKeyPress :=
          sak.AssistiveData[i].OriOnKeyPress;
      end
      else
      if (assigned(sak.AssistiveData[i].TheObject)) and (sak.AssistiveData[i].TheObject is TfpgCheckBox) then
      begin
        TfpgCheckBox(sak.AssistiveData[i].TheObject).OnChange :=
          sak.AssistiveData[i].OriOnChange;
        TfpgCheckBox(sak.AssistiveData[i].TheObject).OnEnter :=
          sak.AssistiveData[i].OriOnEnter;
        TfpgCheckBox(sak.AssistiveData[i].TheObject).OnMouseMove :=
          sak.AssistiveData[i].oriOnMouseMove;
          TfpgCheckBox(sak.AssistiveData[i].TheObject).OnMouseDown :=
          sak.AssistiveData[i].OriOnMouseDown;
      end
      else
      if (assigned(sak.AssistiveData[i].TheObject)) and (sak.AssistiveData[i].TheObject is TfpgTrackBar) then
      begin
        TfpgTrackBar(sak.AssistiveData[i].TheObject).OnChange :=
          sak.AssistiveData[i].OriOnTrackbarChange;
        TfpgTrackBar(sak.AssistiveData[i].TheObject).OnEnter :=
          sak.AssistiveData[i].OriOnEnter;
        TfpgTrackBar(sak.AssistiveData[i].TheObject).OnMouseMove :=
          sak.AssistiveData[i].oriOnMouseMove;
           TfpgTrackBar(sak.AssistiveData[i].TheObject).OnMouseDown :=
          sak.AssistiveData[i].OriOnMouseDown;
      end
      else
      if (assigned(sak.AssistiveData[i].TheObject)) and (sak.AssistiveData[i].TheObject is TfpgComboBox) then
      begin
        TfpgComboBox(sak.AssistiveData[i].TheObject).OnChange :=
          sak.AssistiveData[i].OriOnChange;
        TfpgComboBox(sak.AssistiveData[i].TheObject).OnEnter :=
          sak.AssistiveData[i].OriOnEnter;
        TfpgComboBox(sak.AssistiveData[i].TheObject).OnMouseMove :=
          sak.AssistiveData[i].oriOnMouseMove;
          TfpgComboBox(sak.AssistiveData[i].TheObject).OnMouseDown :=
          sak.AssistiveData[i].OriOnMouseDown;
      end
      else
      if (assigned(sak.AssistiveData[i].TheObject)) and (sak.AssistiveData[i].TheObject is TfpgListBox) then
      begin
        TfpgListBox(sak.AssistiveData[i].TheObject).OnChange :=
          sak.AssistiveData[i].OriOnChange;
        TfpgListBox(sak.AssistiveData[i].TheObject).OnEnter :=
          sak.AssistiveData[i].OriOnEnter;
        TfpgListBox(sak.AssistiveData[i].TheObject).OnMouseMove :=
          sak.AssistiveData[i].oriOnMouseMove;
         TfpgListBox(sak.AssistiveData[i].TheObject).OnMouseDown :=
          sak.AssistiveData[i].OriOnMouseDown;
      end
      else
      if (assigned(sak.AssistiveData[i].TheObject)) and (sak.AssistiveData[i].TheObject is TfpgRadiobutton) then
      begin
        TfpgRadiobutton(sak.AssistiveData[i].TheObject).OnChange :=
          sak.AssistiveData[i].OriOnChange;
        TfpgRadiobutton(sak.AssistiveData[i].TheObject).OnEnter :=
          sak.AssistiveData[i].OriOnEnter;
        TfpgRadiobutton(sak.AssistiveData[i].TheObject).OnMouseMove :=
          sak.AssistiveData[i].oriOnMouseMove;
         TfpgRadiobutton(sak.AssistiveData[i].TheObject).OnMouseDown :=
          sak.AssistiveData[i].OriOnMouseDown;
      end;

     {
      else
      if (assigned(sak.AssistiveData[i].TheObject)) and (sak.AssistiveData[i].TheObject is TfpgWidget) then
      begin
        TfpgWidget(sak.AssistiveData[i].TheObject).OnClick :=
          sak.AssistiveData[i].OriOnClick;
        TfpgWidget(sak.AssistiveData[i].TheObject).OnEnter :=
          sak.AssistiveData[i].OriOnEnter;
        TfpgWidget(sak.AssistiveData[i].TheObject).OnMouseMove :=
          sak.AssistiveData[i].oriOnMouseMove;
      end;
    //  }
    end;
    SetLength(sak.AssistiveData, 0);

end;


function SAKLoadLib(const eSpeakBin: string; const eSpeaklib: string; const PortaudioLib: string;
                                      const eSpeakDataDir: string): integer;
begin
 Result := -1;
 if sak = nil then sak:= TSAK.Create;

 if (eSpeakDataDir = '') or directoryexists(eSpeakDataDir) 
then
 begin
  Result:= 0;
  sak.ES_DataDirectory:= eSpeakDataDir;
 end;
 sak.ES_ExeFileName:= eSpeakBin;
 sak.ES_LibFileName:= eSpeaklib;
 sak.PA_LibFileName:= PortaudioLib;
 
 //writeln('PA_LibFileName:= '+ PortaudioLib);
// writeln('PA_LibFiledir:= '+ExtractFilePath( PortaudioLib));

 Result:= sak.loadlib;
 if result <> 0 then freeandnil(sak);
end;

function SAKLoadLib(const sakitdir: string = ''): integer;
var
ordir, sakini, espeakbin, espeaklib, portaudiolib, espeakdatadir, tmp: string;
const
 sakininame = 'sak.ini';

{$ifdef mswindows}
 espeaklibdir = 'libwin32';
 espeakdefault = 'espeak.exe';
{$else}
 espeakdefault = 'espeak';
{$endif}

{$if defined(linux) and  defined(cpu64)}
 espeaklibdir = 'liblinux64';
{$endif}
{$if defined(linux) and defined(cpu86) }
 espeaklibdir = 'liblinux32';
{$endif}
{$if defined(freebsd) and  defined(cpu64)}
 espeaklibdir = 'libfreebsd64';
{$endif}
{$if defined(freebsd) and defined(cpu86) } 
 espeaklibdir = 'libfreebsd32';
 {$endif}
{$ifdef darwin}
 espeaklibdir = 'libmac32';
{$endif}

begin
 Result := -1;
 espeakdatadir:= '';
 if sakitdir = '' then begin
  ordir:= IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));
 end
 else begin
  ordir:= sakitdir;
 end;

 sakini:= ordir + sakininame;
 espeakbin:= ordir + WhatFile(sakini,0);

 tmp := WhatFile(sakini,1);
 if tmp <> '' then
 portaudiolib:= ordir + tmp else  portaudiolib:= '';

 espeaklib:= ordir + WhatFile(sakini,2);

 tmp := WhatFile(sakini,2);
 if tmp <> '' then
 espeaklib:= ordir + tmp else  espeaklib:= '';

 tmp := WhatFile(sakini,3);
 if (tmp = '/') or (tmp = './') then
 espeakdatadir:= ordir else 
if tmp = '../' then
 espeakdatadir:= ExtractFilePath(ordir)
else 
 espeakdatadir:= tmp ;


 if (directoryexists(espeakdatadir)) and (fileexists(espeakbin)) and (fileexists(sakini)) and ((fileexists(portaudiolib)) or (portaudiolib = ''))
 and ((fileexists(espeaklib)) or (espeaklib = ''))
 then
  begin
   Result:= 0;
   espeakdatadir:= ordir ;
   {$ifdef unix}
 result := ChangePermission(espeakbin,true);
   {$endif}
  end
 else begin
  sakini:= ordir +  directoryseparator +'sakit' + directoryseparator +
  espeaklibdir + directoryseparator + sakininame;

  espeakbin:= ordir + directoryseparator + 'sakit' + directoryseparator +
  espeaklibdir+ directoryseparator + WhatFile(sakini, 0);

  tmp := WhatFile(sakini,1);
 if tmp <> '' then
  portaudiolib:= ordir + directoryseparator + 'sakit' + directoryseparator +
  espeaklibdir+ directoryseparator + tmp else  portaudiolib:= '';

 tmp := WhatFile(sakini,2);
 if tmp <> '' then
 espeaklib:= ordir + directoryseparator + 'sakit' + directoryseparator +
  espeaklibdir+ directoryseparator + tmp else  espeaklib:= '';

 tmp := WhatFile(sakini,3);
 if (tmp = '/') or (tmp = './') then
 espeakdatadir:= ordir + directoryseparator + 'sakit' + directoryseparator +
  espeaklibdir+ directoryseparator else 
if tmp = '../' then
 espeakdatadir:= ordir + directoryseparator + 'sakit' + directoryseparator
else 
 espeakdatadir:= tmp ;

   if (directoryexists(espeakdatadir)) and (fileexists(espeakbin)) and (fileexists(sakini)) and ((fileexists(portaudiolib)) or (portaudiolib = ''))
   and ((fileexists(espeaklib)) or (espeaklib = ''))   then
 begin
    Result:= 0;
       {$ifdef unix}
  result := ChangePermission(espeakbin,true);
    {$endif}
   end
  else begin

{$ifdef unix}
  if (fileexists('/usr/bin/'+espeakdefault)) then begin
  espeakbin:= '/usr/bin/'+espeakdefault;
 result := 0;
end else
 if
 (fileexists('/usr/local/bin/'+espeakdefault)) then
begin
  espeakbin:= '/usr/local/bin/'+espeakdefault;
result := 0;
end;
 {$endif}

{$ifdef windows}
  if (fileexists('c:\Program Files (x86)\eSpeak\command_line\'+espeakdefault)) then
begin
  espeakbin:= 'c:\Program Files (x86)\eSpeak\command_line\'+espeakdefault;
 result := 0;
end else
 if
 (fileexists('c:\Program Files\eSpeak\command_line\'+espeakdefault)) then
begin
  espeakbin:= 'c:\Program Files\eSpeak\command_line\'+espeakdefault;
result := 0;
end;
 {$endif}

espeakdatadir:= '';
portaudiolib:= '' ;

end;

 end;

 if result = 0 then begin
  result:= sakloadlib(espeakbin,espeaklib,portaudiolib,espeakdatadir);
 end;
end;

procedure TSAK.InitObject;
var
 h, i,  g: integer;
begin
  fpgapplication.ProcessMessages;
  mouseclicked := False;
  SetLength(sak.AssistiveData, 1);

  sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
    TSAK_IAssistive.Create();

  sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
    'Application';

  sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
    Tfpgapplication(fpgapplication);

  sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnKeyPress :=
    Tfpgapplication(fpgapplication).OnKeyPress;

  Tfpgapplication(fpgapplication).OnKeyPress := @sak.SAKKeyPress;

  for h := 0 to fpgapplication.formCount - 1 do
  begin
    SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);
    sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
      TSAK_IAssistive.Create();

    sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
      'Form,';

    sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
      TfpgForm(fpgapplication.Forms[h]);

    sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnKeyPress :=
      TfpgForm(fpgapplication.Forms[h]).OnKeyPress;

    sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnDestroy :=
      TfpgForm(fpgapplication.Forms[h]).OnDestroy;

    sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
      TfpgForm(fpgapplication.Forms[h]).OnMouseDown;

    TfpgForm(fpgapplication.Forms[h]).OnMouseDown := @sak.SAKMouseDown;
    TfpgForm(fpgapplication.Forms[h]).OnKeyPress := @sak.SAKKeyPress;
    TfpgForm(fpgapplication.Forms[h]).OnDestroy := @sak.SAKDestroy;

    sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
      TfpgForm(fpgapplication.Forms[h]).OnMouseMove;
    TfpgForm(fpgapplication.Forms[h]).OnMouseMove := @sak.SAKMouseMove;

    with (fpgapplication.Forms[h]) as TfpgForm do

      for i := 0 to ComponentCount - 1 do
      begin
        if (Components[i] is TComponent)
        {
        or (Components[i] is TfpgButton) or (Components[i] is TfpgMemo) or
          (Components[i] is TfpgEdit) or (Components[i] is TfpgStringGrid) or (Components[i] is TfpgCheckBox) or
          (Components[i] is TfpgRadiobutton) or (Components[i] is TfpgListBox) or (Components[i] is TfpgComboBox) or
          (Components[i] is TfpgPopupMenu) or (Components[i] is TfpgMenuItem) or (Components[i] is TfpgTrackBar) or (Components[i] is TfpgLabel)

        // or (Components[i] is TfpgFileDialog) or (Components[i] is TfpgSaveDialog)
        }
        then
        begin

          if (Components[i] is TfpgPopupMenu) then
          begin
            SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

            sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
              TSAK_IAssistive.Create();

            sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
              'Menu,';
            sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
              TfpgPopupMenu(Components[i]);
            sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnClick :=
              TfpgPopupMenu(Components[i]).OnShow;
            TfpgPopupMenu(Components[i]).OnShow := @sak.SAKClick;

            //  TfpgPopupMenu(Components[i]).OnMouseMove;
            //  TfpgPopupMenu(Components[i]).OnMouseMove := @sak.SAKMouseMove;

            with (TfpgPopupMenu(Components[i]) as TfpgPopupMenu) do
              for g := 0 to ComponentCount - 1 do
              begin
                SetLength(sak.AssistiveData,
                  Length(sak.AssistiveData) + 1);
                sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
                  TSAK_IAssistive.Create();
                sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
                  TfpgMenuItem(Components[g]);
                sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnClick :=
                  TfpgMenuItem(Components[g]).OnClick;
                TfpgMenuItem(Components[g]).OnClick := @sak.SAKClick;

                //      sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
                //  TfpgMenuItem(Components[g]).OnEnter;
                //  TfpgMenuItem(Components[g]).OnEnter := @sak.SAKEnter;

                //     sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
                //  TfpgMenuItem(Components[i]).OnMouseMove;
                // TfpgMenuItem(Components[i]).OnMouseMove := @sak.SAKMouseMove;
              end;
          end

          else

         if (Components[i] is TfpgLabel) then
          begin
            SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

            sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
              TSAK_IAssistive.Create();

            sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
              'Label,';
            sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
              TfpgLabel(Components[i]);
            sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnClick :=
              TfpgLabel(Components[i]).OnClick;
            TfpgLabel(Components[i]).OnClick := @sak.SAKClick;
            sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
              TfpgLabel(Components[i]).OnMouseMove;
            TfpgLabel(Components[i]).OnMouseMove := @sak.SAKMouseMove;

              sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
                               TfpgLabel(Components[i]).OnMouseDown;
                    TfpgLabel(Components[i]).OnMouseDown := @sak.SAKMouseDown;
          end
          else
          if (Components[i] is TfpgButton) then
          begin
            SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

            sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
              TSAK_IAssistive.Create();

            sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
              'Button,';
            sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
              TfpgButton(Components[i]);
            sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnClick :=
              TfpgButton(Components[i]).OnClick;
            TfpgButton(Components[i]).OnClick := @sak.SAKClick;
            sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
              TfpgButton(Components[i]).OnEnter;
            TfpgButton(Components[i]).OnEnter := @sak.SAKEnter;

            sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
              TfpgButton(Components[i]).OnMouseMove;
            TfpgButton(Components[i]).OnMouseMove := @sak.SAKMouseMove;

              sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
                               TfpgButton(Components[i]).OnMouseDown;
                    TfpgButton(Components[i]).OnMouseDown := @sak.SAKMouseDown;
          end
          else
          if (Components[i] is TfpgStringGrid) then
          begin
            SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

            sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
              TSAK_IAssistive.Create();

            sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
              'Grid,';
            sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
              TfpgStringGrid(Components[i]);
            sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnFocusChange :=
              TfpgStringGrid(Components[i]).OnFocusChange;
            sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
              TfpgStringGrid(Components[i]).OnMouseDown;
            TfpgStringGrid(Components[i]).OnFocusChange := @sak.SAKFocusChange;
            TfpgStringGrid(Components[i]).OnMouseDown := @sak.SAKMouseDown;

            sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
              TfpgStringGrid(Components[i]).OnEnter;
            TfpgStringGrid(Components[i]).OnEnter := @sak.SAKEnter;

              sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnKeyPress :=
              TfpgStringGrid(Components[i]).OnKeyPress;
                 TfpgStringGrid(Components[i]).OnKeypress := @sak.SAKKeypress;

            sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
              TfpgStringGrid(Components[i]).OnMouseMove;
            TfpgStringGrid(Components[i]).OnMouseMove := @sak.SAKMouseMove;


          end
          else
          if (Components[i] is TfpgTrackBar) then
          begin
            SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

            sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
              TSAK_IAssistive.Create();

            sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
              'Track bar,';
            sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
              TfpgTrackBar(Components[i]);
            sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnTrackbarChange :=
              TfpgTrackBar(Components[i]).OnChange;

            TfpgTrackBar(Components[i]).OnChange := @sak.SAKTrackBarChange;

            sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
              TfpgTrackBar(Components[i]).OnEnter;

            TfpgTrackBar(Components[i]).OnEnter := @sak.SAKEnter;

            sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
              TfpgTrackBar(Components[i]).OnMouseMove;
            TfpgTrackBar(Components[i]).OnMouseMove := @sak.SAKMouseMove;

              sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
                               TfpgTrackBar(Components[i]).OnMouseDown;
                    TfpgTrackBar(Components[i]).OnMouseDown := @sak.SAKMouseDown;
          end
          else
          if (Components[i] is TfpgRadiobutton) then
          begin
            SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

            sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
              TSAK_IAssistive.Create();

            sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
              'Radio Button,';
            sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
              TfpgRadiobutton(Components[i]);

            sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnChange :=
              TfpgRadiobutton(Components[i]).OnChange;

            TfpgRadiobutton(Components[i]).OnChange := @sak.SAKChange;


            sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
              TfpgRadiobutton(Components[i]).OnEnter;

            TfpgRadiobutton(Components[i]).OnEnter := @sak.SAKEnter;

            sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
              TfpgRadiobutton(Components[i]).OnMouseMove;
            TfpgRadiobutton(Components[i]).OnMouseMove := @sak.SAKMouseMove;

             sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
                               TfpgRadiobutton(Components[i]).OnMouseDown;
                    TfpgRadiobutton(Components[i]).OnMouseDown := @sak.SAKMouseDown;
          end
          else

          if (Components[i] is TfpgCheckBox) then
          begin
            SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

            sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
              TSAK_IAssistive.Create();

            sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
              'Check Box,';
            sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
              TfpgCheckBox(Components[i]);
            sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnChange :=
              TfpgCheckBox(Components[i]).OnChange;
            sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
              TfpgCheckBox(Components[i]).OnEnter;

            TfpgCheckBox(Components[i]).OnChange := @sak.SAKChange;
            TfpgCheckBox(Components[i]).OnEnter := @sak.SAKEnter;
            sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
              TfpgCheckBox(Components[i]).OnMouseMove;
            TfpgCheckBox(Components[i]).OnMouseMove := @sak.SAKMouseMove;

            sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
                               TfpgCheckBox(Components[i]).OnMouseDown;
                    TfpgCheckBox(Components[i]).OnMouseDown := @sak.SAKMouseDown;
          end
          else
          if (Components[i] is TfpgListBox) then
          begin
            SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

            sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
              TSAK_IAssistive.Create();

            sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
              'List Box,';
            sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
              TfpgListBox(Components[i]);
            sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnChange :=
              TfpgListBox(Components[i]).OnChange;

            sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
              TfpgListBox(Components[i]).OnEnter;

            TfpgListBox(Components[i]).OnChange := @sak.SAKChange;
            TfpgListBox(Components[i]).OnEnter := @sak.SAKEnter;

            sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
              TfpgListBox(Components[i]).OnMouseMove;
            TfpgListBox(Components[i]).OnMouseMove := @sak.SAKMouseMove;

              sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
                               TfpgListBox(Components[i]).OnMouseDown;
                    TfpgListBox(Components[i]).OnMouseDown := @sak.SAKMouseDown;
          end
          else
          if (Components[i] is TfpgComboBox) then
          begin
            SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

            sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
              TSAK_IAssistive.Create();

            sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
              'Combo Box,';
            sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
              TfpgComboBox(Components[i]);
            sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnChange :=
              TfpgComboBox(Components[i]).OnChange;
            sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
              TfpgComboBox(Components[i]).OnEnter;
            TfpgComboBox(Components[i]).OnChange := @sak.SAKChange;
            TfpgComboBox(Components[i]).OnEnter := @sak.SAKEnter;

            sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
              TfpgComboBox(Components[i]).OnMouseMove;
            TfpgComboBox(Components[i]).OnMouseMove := @sak.SAKMouseMove;

             sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
                               TfpgComboBox(Components[i]).OnMouseDown;
                    TfpgComboBox(Components[i]).OnMouseDown := @sak.SAKMouseDown;
          end
          else
          if (Components[i] is TfpgMemo) then
          begin
            SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

            sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
              TSAK_IAssistive.Create();

            sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
              'Memo,';
            sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
              TfpgMemo(Components[i]);
            sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
              TfpgMemo(Components[i]).OnEnter;
            sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnKeyChar :=
              TfpgMemo(Components[i]).OnKeyChar;

              sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnKeyPress :=
              TfpgMemo(Components[i]).OnKeyPress;
                 TfpgMemo(Components[i]).OnKeypress := @sak.SAKKeypress;


            TfpgMemo(Components[i]).OnEnter := @sak.SAKEnter;
            TfpgMemo(Components[i]).OnKeyChar := @sak.SAKKeyChar;
             TfpgMemo(Components[i]).OnKeypress := @sak.SAKKeypress;

            sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
              TfpgMemo(Components[i]).OnMouseMove;
            TfpgMemo(Components[i]).OnMouseMove := @sak.SAKMouseMove;

             sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
                               TfpgMemo(Components[i]).OnMouseDown;
                    TfpgMemo(Components[i]).OnMouseDown := @sak.SAKMouseDown;
          end
          else
          if (Components[i] is TfpgEdit) then
          begin
            SetLength(sak.AssistiveData, Length(sak.AssistiveData) + 1);

            sak.AssistiveData[Length(sak.AssistiveData) - 1] :=
              TSAK_IAssistive.Create();

            sak.AssistiveData[Length(sak.AssistiveData) - 1].Description :=
              'Edit,';
            sak.AssistiveData[Length(sak.AssistiveData) - 1].TheObject :=
              TfpgEdit(Components[i]);
            sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnEnter :=
              TfpgEdit(Components[i]).OnEnter;
            sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnKeyChar :=
              TfpgEdit(Components[i]).OnKeyChar;
            TfpgEdit(Components[i]).OnEnter := @sak.SAKEnter;
            TfpgEdit(Components[i]).OnKeyChar := @sak.SAKKeyChar;

              sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnKeyPress :=
              TfpgEdit(Components[i]).OnKeyPress;
                 TfpgEdit(Components[i]).OnKeypress := @sak.SAKKeypress;

            sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseMove :=
              TfpgEdit(Components[i]).OnMouseMove;
            TfpgEdit(Components[i]).OnMouseMove := @sak.SAKMouseMove;

              sak.AssistiveData[Length(sak.AssistiveData) - 1].OriOnMouseDown :=
                               TfpgEdit(Components[i]).OnMouseDown;
                    TfpgEdit(Components[i]).OnMouseDown := @sak.SAKMouseDown;
          end
          else
          if (Components[i] is TComponent) then
          begin
              UpdateChild(Components[i])  ;
              end;

          end;
        end;
      end;
  end;

////////////////////// Speecher Procedures ////////////////
procedure TSAK.espeak_key(Text: string);
var
 params: string = '';
begin
    AProcess.Parameters.clear;

 if (voice_gender <> '') or (voice_language <> '') then begin
  params:= params + '-v';
  if voice_language <> '' then begin
   params:= params+voice_language;
   if voice_gender <> '' then begin
    params:= params+'+'+voice_gender;
   end;
  end
  else begin
   if voice_gender <> '' then begin
    params:= params+voice_gender;
   end;
  end;
 end;

if  params <> '' then AProcess.Parameters.Add(params) ;

if voice_speed <> -1 then AProcess.Parameters.Add('-s' + inttostr(voice_speed)) ;
if voice_pitch <> -1 then AProcess.Parameters.Add('-p' + inttostr(voice_pitch)) ;
if voice_volume <> -1 then AProcess.Parameters.Add('-a' + inttostr(voice_volume)) ;

  if sak.es_datadirectory <> '' then
      AProcess.Parameters.Add('--path=' + sak.ES_DataDirectory);

  AProcess.Parameters.Add('"' + Text + '"');
  {
  writeln('command line ' + AProcess.CommandLine)  ;
  writeln('parameter ' + AProcess.Parameters.Text)  ;
  writeln('executable ' + AProcess.Executable)  ;
  writeln('environ ' + AProcess.Environment.Text)  ;
  }

  AProcess.Execute;

end;

procedure TSAK.CheckCount(Sender: TObject);
begin
  timercount.Enabled := False;

  if (isenabled = True) then
  begin
 // fpgapplication.ProcessMessages;
  f := 0;
    ChildComponentCount(fpgApplication);
    if (f <> CompCount) then
    begin
      saksuspend;
      sakupdate;
      CompCount := f;
    end;
    timercount.Enabled := True;
  end;
end;

procedure TSAK.espeak_cancel;
begin
    if assigned(AProcess) then
  begin
   AProcess.Active:=false;
   AProcess.Terminate(0);
   // freeandnil(AProcess);
  end;
end;

////// suspend/update procedures
procedure SAKSuspend();
begin
  if assigned(sak) then
    sak.UnLoadLib;
end;

procedure SAKUpdate();
begin
   if assigned(sak) then
   begin
  sak.initobject;
  sak.f := 0;
  sak.ChildComponentCount(fpgApplication);
  sak.CompCount := sak.f;
  sak.timercount.Enabled := True;
    end;
end;

////////////////////// Voice Config Procedures ///////////////
function SAKSetVoice(gender: shortint; language: string ; speed: integer ; pitch: integer ; volume : integer ): integer;
// -gender : 1 = man, 2 = woman => defaut -1 (man)
//-language : is the language code => default '' (en) 
////  for example :'en' for english, 'fr' for french, 'pt' for Portugues, etc...
////           (check in /espeak-data if your language is there...)
//  -speed sets the speed in words-per-minute , Range 80 to 450. The default value is 175. => -1
// -pitch  range of 0 to 99. The default is 50.   => -1
// -volume range of 0 to 200. The default is 100. => -1
begin
   result := -1;
  if assigned(sak) then
  begin
   result := 0;
    if gender = -1 then
    sak.voice_gender := ''  else
   if gender = 1 then
    sak.voice_gender := 'm3'
  else
    sak.voice_gender := 'f2';
  sak.voice_language := language;
  sak.voice_speed := speed;
  sak.voice_volume := volume;
  sak.voice_pitch := pitch;
  end;
end;

////////////////////// Speecher Procedures ////////////////
function SAKSay(Text: string): integer;
begin
  result := -1;
  if assigned(sak) then
  begin
   sak.espeak_Key(Text);
   Result := 0;
   end;
end;

//// cancel current speaker
function SAKCancel : integer;
begin
  result := -1;
  if assigned(sak) then
  begin
  result := 0 ;
  sak.espeak_cancel;
  end;
end;

///////////// Enabled procedure
function SakIsEnabled(): boolean;
begin
  Result := isenabled;
end;

///// custom warning
procedure TWarning.buttonclicked(Sender: TObject);
begin
  if sender = Button1 then modresult := 1 else modresult := 0;
  hide;
end;

procedure TWarning.AfterCreate;
begin
   SetPosition(338, 262, 481, 111);
  WindowTitle := 'Warning...';
  IconName := '';
  Hint := '';
  WindowPosition := wpScreenCenter;

 Label1 := TfpgLabel.Create(self);
 with Label1 do
 begin
   Name := 'Label1';
    SetPosition(8, 4, 472, 19);
   Alignment := taCenter;
   FontDesc := '#Label1';
   Hint := '';
   end;

 Label2 := TfpgLabel.Create(self);
 with Label2 do
 begin
   Name := 'Label2';
   SetPosition(8, 20, 472, 15);
   Alignment := taCenter;
   FontDesc := '#Label2';
   AutoSize:=true;
   Hint := '';
  end;

 Label3 := TfpgLabel.Create(self);
 with Label3 do
 begin
   Name := 'Label3';
  SetPosition(8, 36, 472, 15);
   Alignment := taCenter;
   FontDesc := '#Label1';
   Hint := '';
   end;

 Label4 := TfpgLabel.Create(self);
 with Label4 do
 begin
   Name := 'Label4';
   SetPosition(8, 54,  472, 15);
   Alignment := taCenter;
   FontDesc := '#Label1';
   Hint := '';
   end;

 Button1 := TfpgButton.Create(self);
 with Button1 do
 begin
   Name := 'Button1';
   SetPosition(144, 80, 80, 23);
   FontDesc := '#Label1';
   Hint := '';
   ImageName := '';
   TabOrder := 4;
   Text := 'OK';
   onclick := @buttonclicked;
 end;

 Button2 := TfpgButton.Create(self);
 with Button2 do
 begin
   Name := 'Button2';
     SetPosition(260, 80, 80, 23);
   FontDesc := '#Label1';
   Hint := '';
   ImageName := '';
   TabOrder := 5;
   Text := 'Cancel';
    onclick := @buttonclicked;
 end;
end;

finalization
 sak.free();

end.
