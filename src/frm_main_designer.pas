{
This is the extended version of fpGUI uidesigner => designer_ext.
With window list, undo feature, integration into IDE, editor launcher, extra-properties editor,...

Fred van Stappen
fiens@hotmail.com
2013 - 2016
}
{ fpGUI - Free Pascal GUI Toolkit

    Copyright (C) 2006 - 2016 See the file AUTHORS.txt, included in this
    distribution, for details of the copyright.

    See the file COPYING.modifiedLGPL, included in this distribution,
    for details about redistributing fpGUI.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    Description:
      Essential classes used by the fpGUI Designer
 }
 

unit frm_main_designer;

{$mode objfpc}{$H+}

/// for custom compil, like using fpgui-dvelop =>  edit define.inc
{$I define.inc}

interface

uses
  fpg_menu,
   RunOnce_PostIt,
  frm_colorpicker,
  frm_imageconvert,
  frm_multiselect,
  SysUtils,
  Classes,
  fpg_base,
  fpg_main,
  fpg_widget,
  fpg_edit,
  sak_fpg,
  fpg_combobox,
  fpg_listbox,
  fpg_memo,
  fpg_dialogs,
  fpg_tree,
  fpg_splitter,
  fpg_panel,
  fpg_mru,
  vfd_widgetclass,
  vfd_widgets,

  {%units 'Auto-generated GUI code'}
  fpg_form, fpg_label, fpg_button, fpg_hyperlink
  {%endunits}
  ;


  {$ifdef fpgui-develop}
const
  MIME_VFD_WIDGET_CLASS = 'x-object/fpgui-vfd-widgetclass';
  {$else}
  {$endif}

type

  TwgPaletteButton = class(TfpgButton)
  public
    VFDWidget: TVFDWidgetClass;
  end;

  TwgPalette = class(TfpgWidget)
  protected
    procedure HandlePaint; override;
  end;

  TfrmMainDesigner = class(TfpgForm)
  private
    FFileOpenRecent: TfpgMenuItem;
    FlistUndo: TfpgMenuItem;
    procedure FormShow(Sender: TObject);

    {$ifdef fpgui-develop}
    procedure   OnPaletteDragStart(Sender: TObject);
    procedure   PaintPaletteButtonForDrag(ASender: TfpgDrag; ACanvas: TfpgCanvas);
 {$else}
 {$endif}

    procedure PaletteBarResized(Sender: TObject);
    procedure miHelpAboutClick(Sender: TObject);
    procedure miHelpAboutGUI(Sender: TObject);
    procedure micolorwheel(Sender: TObject);
    procedure miimageconv(Sender: TObject);
    procedure miMRUClick(Sender: TObject; const FileName: string);
    procedure BuildThemePreviewMenu;
    procedure ToggleDesignerGrid(Sender: TObject);

  public
    {@VFD_HEAD_BEGIN: frmMainDesigner}
  panel1: TfpgPanel;
    PanelMove: TfpgPanel;
    xicon: TfpgLabel;
    micon: TfpgLabel;
    MainMenu: TfpgMenuBar;
    filemenu: TfpgPopupMenu;
    formmenu: TfpgPopupMenu;
    miOpenRecentMenu: TfpgPopupMenu;
    setmenu: TfpgPopupMenu;
    undomenu: TfpgPopupMenu;
    toolsmenu: TfpgPopupMenu;
    helpmenu: TfpgPopupMenu;
    listundomenu: TfpgPopupMenu;
    windowmenu: TfpgPopupMenu;
    previewmenu: TfpgPopupMenu;
    btnNewForm: TfpgButton;
    btnOpen: TfpgButton;
    btnSave: TfpgButton;
    btnGrid: TfpgButton;
    btnToFront: TfpgButton;
    btnSelected: TfpgButton;
    btnAssist: TfpgButton;
    wgpalette: TwgPalette;
    chlPalette: TfpgComboBox;
    {@VFD_HEAD_END: frmMainDesigner}
    mru: TfpgMRU;
    constructor Create(AOwner: TComponent); override;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    function GetSelectedWidget: TVFDWidgetClass;
    procedure SetSelectedWidget(wgc: TVFDWidgetClass);
    procedure AfterCreate; override;
    procedure BeforeDestruction; override;
    procedure OnPaletteClick(Sender: TObject);
    property SelectedWidget: TVFDWidgetClass read GetSelectedWidget write SetSelectedWidget;
    procedure onalwaystofront(Sender: TObject);
    procedure OnNevertoFront(Sender: TObject);
    procedure OnLoadUndo(Sender: TObject);
    procedure OnIndexUndo(Sender: TObject);
    procedure OnIndexRedo(Sender: TObject);
    procedure OnObjInspect(Sender: TObject);
    procedure ToFrontClick(Sender: TObject);
    procedure sakenable(Sender: TObject);

    procedure OnFormDesignShow(Sender: TObject);
    procedure onMultiSelect(Sender: TObject);
    procedure LoadIDEparameters(ide: integer);
    procedure onMessagePost;
    procedure OnStyleChange(Sender: TObject);
    procedure onClickDownPanel(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint);
    procedure onClickUpPanel(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint);
    procedure onMoveMovePanel(Sender: TObject; AShift: TShiftState; const AMousePos: TPoint);

    procedure OnSaveNewFile(Sender: TObject);
    procedure OnCloseAll(Sender: TObject);
    procedure OnSaveAs(Sender: TObject);
    procedure OnNewForm(Sender: TObject);
    procedure OnChangeWidget(Sender: TObject);
  end;

  //  TPropertyList =    class(TfpgForm)
  TPropertyList = class(TObject)
  private
    FList: TList;
    function GetCount: integer;
  public
    Widget: TfpgWidget;
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    property Count: integer read GetCount;
    procedure AddItem(aProp: TVFDWidgetProperty);
    function GetItem(index: integer): TVFDWidgetProperty;
  end;

  TwgPropertyList = class(TfpgListBox)
  protected
    procedure DrawItem(num: integer; rect: TfpgRect; flags: integer); override;
    procedure HandleMouseMove(x, y: integer; btnstate: word; shiftstate: TShiftState); override;
    procedure HandleLMouseDown(x, y: integer; shiftstate: TShiftState); override;
    procedure HandleLMouseUp(x, y: integer; shiftstate: TShiftState); override;
    procedure HandleMouseScroll(x, y: integer; shiftstate: TShiftState; delta: smallint); override;
    procedure HandleSetFocus; override;
    procedure HandleKillFocus; override;
    procedure OnRowChange(Sender: TObject);
    procedure OnScrolling(Sender: TObject);
    procedure OnUpdateProperty(Sender: TObject);
  public
    Props: TPropertyList;
    NameWidth: integer;
    editor: TVFDPropertyEditor;
    NameDrag: boolean;
    NameDragPos: integer;
    constructor Create(AOwner: TComponent); override;
    procedure ReleaseEditor;
    procedure AllocateEditor;
    function ItemCount: integer; override;
    function RowHeight: integer; override;
    procedure RealignEditor;
  end;

  TfrmProperties = class(TfpgForm)
   private
    procedure   FormShow(Sender: TObject);
    procedure   FormResized(Sender: TObject);
    procedure   SetHierarchyMaxHeight;
    procedure   TreeSelect(Sender: TObject);
  protected
    procedure HandleKeyPress(var keycode: word; var shiftstate: TShiftState; var consumed: boolean); override;
  public
  {@VFD_HEAD_BEGIN: frmProperties}
    Bevel1: TfpgBevel;
    TreeView1: TfpgTreeView;
    Splitter1: TfpgSplitter;
    bvlOI: TfpgBevel;  
    l1, l2, l3, l4, l5, l6, l7, l8: TfpgLabel;
    lbClass: TfpgLabel;
    edName: TfpgEdit;
    edOther: TfpgMemo;

    cbOwners: Tfpgcombobox;

    btnTop, btnLeft, btnWidth, btnHeight: TfpgButton;
    btnAnLeft, btnAnTop, btnAnRight, btnAnBottom: TfpgButton;
    lstProps: TwgPropertyList;
    virtualpanel: Tfpgpanel;
    cbsizeable, cbfullscreen, cbvisible, cbenabled, cbWindowPosition, cbFocusable, cbshowhint: TfpgCombobox;
    edmaxheight, edminheight, edmaxwidth, edminwidth, edTag, edhint: Tfpgedit;
     {@VFD_HEAD_END: frmProperties}
    constructor Create(AOwner: TComponent); override;
    procedure AfterCreate; override;
    procedure BeforeDestruction; override;
    procedure Vpanelpaint(Sender: TObject);
    procedure frmPropertiesPaint(Sender: TObject);
    procedure VirtualPropertiesUpdate(Sender: TObject);
    procedure   UpdateWidgetHierachyTreeview(AMainComp, ASelected: TComponent);
  end;

  TfrmAbout = class(TfpgForm)
  private
    {@VFD_HEAD_BEGIN: frmAbout}
    lblAppName: TfpgLabel;
    lblVersion: TfpgLabel;
    btnClose: TfpgButton;
    lblWrittenBy: TfpgLabel;
    lblURL: TfpgHyperlink;
    lblCompiled: TfpgLabel;
    lblExtBy: TfpgLabel;
    lblExtMail: TfpgLabel;
    {@VFD_HEAD_END: frmAbout}
    Fimage: Tfpgimage;
    procedure SetupCaptions;
    procedure FormShow(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  public
    procedure AfterCreate; override;
    class procedure Execute;
  end;

{@VFD_NEWFORM_DECL}

const
  ext_version: string = '1.9.4';

var

  frmProperties: TfrmProperties;
  frmMainDesigner: TfrmMainDesigner;
  ifonlyone: boolean;
  PropList: TPropertyList;
  oriMousePos: TPoint;
   idetempchanged : boolean = false;
  idetemp, maxundo, indexundo: integer;
  enableundo: boolean;
  enableautounits: boolean;
  numstyle: integer;
  bitcpu: integer;
  mayclose : boolean = false;
  dirsakit : string;

implementation

uses
  fpg_iniutils,
  fpg_constants,
  fpg_stylemanager,
  vfd_main,
  vfd_designer,

 {$ifdef fpgui-develop}
 fpg_window,
 {$else}
 {$endif}

  vfd_constants;

// Anchor images
{$I anchors.inc}

// ext images
{$I ext.inc}

// logo images
{$I fpgui_logo.inc}


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

procedure TfrmAbout.SetupCaptions;
begin
  lblVersion.Text := 'Version: ' + ext_version + ' ' + IntToStr(bitcpu) + ' bit';
  lblURL.URL := fpGUIWebsite;
  lblURL.Text := fpGUIWebsite;
 
  /// => This code gives problem to JEDI code-formater
  lblCompiled.Text := Format(rsCompiledOn, [{$I %date%} + ' ' + {$I %time%}]);
  //
  btnClose.Text := rsClose;
end;

procedure TfrmAbout.FormShow(Sender: TObject);
begin
  SetupCaptions;
  lblURL.HotTrackColor := clBlue;
  lblURL.TextColor := clRoyalBlue;
end;

procedure TfrmAbout.FormPaint(Sender: TObject);
begin
  Canvas.DrawImage(5, 5, FImage);
end;

procedure TfrmAbout.AfterCreate;
begin
  {%region 'Auto-generated GUI code' -fold}
  {@VFD_BODY_BEGIN: frmAbout}
  Name := 'frmAbout';
  SetPosition(464, 277, 278, 195);
  WindowTitle := 'About designer_ext';
  Hint := '';
  BackGroundColor := $FFFFFFFF;
  Sizeable := False;
  WindowPosition := wpScreenCenter;
  OnShow := @FormShow;
  OnPaint := @FormPaint;

  lblAppName := TfpgLabel.Create(self);
  with lblAppName do
  begin
    Name := 'lblAppName';
    SetPosition(108, 10, 167, 35);
    BackgroundColor := TfpgColor($FFFFFFFF);
    FontDesc := 'Arial-20';
    Hint := '';
    Text := 'designer_ext';
    TextColor := TfpgColor($4B8133);
  end;

  lblVersion := TfpgLabel.Create(self);
  with lblVersion do
  begin
    Name := 'lblVersion';
    SetPosition(114, 46, 153, 24);
    Alignment := taRightJustify;
    BackgroundColor := TfpgColor($FFFFFFFF);
    FontDesc := '#Label2';
    Hint := '';
    Text := 'Version:  %s';
    TextColor := TfpgColor($3A8230);
  end;

  btnClose := TfpgButton.Create(self);
  with btnClose do
  begin
    Name := 'btnClose';
    SetPosition(196, 163, 75, 24);
    Anchors := [anRight,anBottom];
    FontDesc := '#Label1';
    Hint := '';
    ImageName := 'stdimg.close';
    ModalResult := mrOK;
    TabOrder := 2;
    Text := 'Close';
    TextColor := TfpgColor($FF000000);
  end;

  lblWrittenBy := TfpgLabel.Create(self);
  with lblWrittenBy do
  begin
    Name := 'lblWrittenBy';
    SetPosition(12, 109, 245, 14);
    BackgroundColor := TfpgColor($FFFFFFFF);
    FontDesc := 'Arial-9';
    Hint := '';
    Text := 'UIdesigner written by Graeme Geldenhuys';
    TextColor := TfpgColor($FF000000);
  end;

  lblURL := TfpgHyperlink.Create(self);
  with lblURL do
  begin
    Name := 'lblURL';
    SetPosition(16, 125, 162, 14);
    BackgroundColor := TfpgColor($FFFFFFFF);
    FontDesc := 'Arial-9:underline';
    Hint := '';
    HotTrackColor := TfpgColor($80000001);
    HotTrackFont := 'Arial-9:underline';
    Text := 'http://fpgui.sourceforge.net';
    TextColor := TfpgColor($0032D2);
    URL := 'http://fpgui.sourceforge.net';
  end;

  lblCompiled := TfpgLabel.Create(self);
  with lblCompiled do
  begin
    Name := 'lblCompiled';
    SetPosition(12, 91, 290, 13);
    BackgroundColor := TfpgColor($FFFFFFFF);
    FontDesc := 'Arial-8';
    Hint := '';

    TextColor := TfpgColor($FF000000);
  end;

  lblExtBy := TfpgLabel.Create(self);
  with lblExtBy do
  begin
    Name := 'lblExtBy';
    SetPosition(14, 156, 150, 14);
    BackgroundColor := TfpgColor($FFFFFFFF);
    FontDesc := 'Arial-9';
    Hint := '';
    Text := '_ext => Fred van Stappen';
    TextColor := TfpgColor($4DC63D);
  end;

  lblExtMail := TfpgLabel.Create(self);
  with lblExtMail do
  begin
    Name := 'lblExtMail';
    SetPosition(38, 174, 114, 18);
    BackgroundColor := TfpgColor($FFFFFFFF);
    FontDesc := 'Arial-9';
    Hint := '';
    Text := 'fiens@hotmail.com';
    TextColor := TfpgColor($4DC63D);
  end;

  {@VFD_BODY_END: frmAbout}
  {%endregion}
  FImage := fpgImages.AddBMP('fpgui_logo1', @extimg_fpgui_logo1, sizeof(extimg_fpgui_logo1));

  WindowTitle := WindowTitle + ' ' + IntToStr(bitcpu) + ' bit';


  RePaint;
end;

class procedure TfrmAbout.Execute;
var
  frm: TfrmAbout;
begin
//  frm := TfrmAbout.Create(nil);
      fpgApplication.CreateForm(TfrmAbout, frm);
  try
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;

procedure TfrmMainDesigner.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  {
     frmmultiselect.Hide;
      frmmultiselect.ClearAll;
    if (gINI.ReadInteger('Options', 'IDE', 0) = 0) or (mayclose = true) or  ((gINI.ReadBool('Options', 'RunOnlyOnce', true) = true) and (IsRunningIDE('typhon') = False) and (IsRunningIDE('lazarus') = False) and
   (IsRunningIDE('ideu') = False) ) or
      (gINI.ReadBool('Options', 'RunOnlyOnce', true) = false) then
      begin
      if assigned(ATimer) then
      ATimer.Enabled:=false;
    CloseAction := caFree; end else CloseAction := canone ;
     }


    end;

procedure TfrmMainDesigner.FormCloseQuery(Sender: TObject; var CanClose: boolean);
var
  x: integer;

begin

//   {

   {$ifdef ideu}
  if  (gINI.ReadInteger('Options', 'IDE', 3) = 0) or
 {$else}
   if  (gINI.ReadInteger('Options', 'IDE', 0) = 0) or
 {$endif}

  (mayclose = true) or  ((gINI.ReadBool('Options', 'RunOnlyOnce', true) = true) and (IsRunningIDE('typhon') = False) and (IsRunningIDE('lazarus') = False) and
   (IsRunningIDE('ideu') = False)) or
      (gINI.ReadBool('Options', 'RunOnlyOnce', true) = false) then
    begin
    CanClose := True;
  end
  else
  begin
       CanClose := false;
      frmProperties.hide;
      frmMainDesigner.hide;
      frmmultiselect.hide;
     x := 0 ;
      while x < length(ArrayFormDesign) do
      begin
        ArrayFormDesign[x].Form.Close;
        Inc(x);
      end;

  end;
//    }

end;

procedure TfrmMainDesigner.LoadIDEparameters(ide: integer);
var
  f: textfile;
  dataf, dataf2: string;
  fmbegin, fmend: integer;
begin
  fpgapplication.ProcessMessages;
  ////////

  btnOpen.Visible := False;
  btnSave.Left := btnOpen.Left;


    {$ifdef fpgui-develop}
     btnSave.UpdatePosition;
    filemenu.MenuItem(0).enabled := True;
     filemenu.MenuItem(1).enabled := False;
     filemenu.MenuItem(2).enabled := False;
  {$else}

  filemenu.MenuItem(0).visible := True;
  filemenu.MenuItem(1).visible := False;
  filemenu.MenuItem(2).visible := False;
    btnSave.UpdateWindowPosition;
  {$endif}

  /// => This code gives problem to JEDI code-formater
 if ide = 3 then
 begin

 end else
 begin

 if ide = 2 then
  begin
{$if defined(cpu64)}
{$IFDEF Windows}
 dataf := copy(GetAppConfigDir(false),1,pos('Local\designer_ext',GetAppConfigDir(false))-1)
           +  'Roaming\typhon64\environmentoptions.xml';
  if fileexists(PChar(dataf)) then
      else
   dataf := copy(GetAppConfigDir(False), 1, pos('Local Settings\Application Data\',
     GetAppConfigDir(False)) - 1) + 'Application Data\typhon64\environmentoptions.xml';
  {$ENDIF}
{$IFDEF unix}
dataf := GetUserDir +'.typhon64/environmentoptions.xml' ;
{$ENDIF}

{$else}
{$IFDEF Windows}
dataf := copy(GetAppConfigDir(false),1,pos('Local\designer_ext',GetAppConfigDir(false))-1)
           +  'Roaming\typhon32\environmentoptions.xml';
  if fileexists(PChar(dataf)) then
      else
   dataf := copy(GetAppConfigDir(False), 1, pos('Local Settings\Application Data\',
     GetAppConfigDir(False)) - 1) + 'Application Data\typhon32\environmentoptions.xml';
  {$ENDIF}
{$IFDEF unix}
dataf := GetUserDir +'.typhon32/environmentoptions.xml' ;
{$ENDIF}
{$endif}

  end;

 if ide = 1 then
    begin
{$IFDEF Windows}
dataf := copy(GetAppConfigDir(false),1,pos('designer_ext',GetAppConfigDir(false))-1)
          +  'lazarus\environmentoptions.xml';
 {$ENDIF}
{$IFDEF unix}
dataf := GetUserDir +'.lazarus/environmentoptions.xml' ;
{$ENDIF}

end;
///////

if fileexists(pchar(dataf)) then
                begin
   AssignFile(f,pchar(dataf));
   Reset(F);
   dataf := '' ;
   dataf2 := '' ;
   fmbegin := 0 ;
   fmend := 0;

     while fmend = 0 do
     begin
       Readln(F, dataf);
       if   Pos('<MainIDE>',dataf) > 0 then fmbegin := 1;
       if   Pos('</MainIDE>',dataf) > 0 then fmend := 1;

       if fmbegin = 1 then dataf2 := dataf2 + dataf;
                ;
                end;

    if ide = 1 then begin

          if   Pos('WindowState Value="Maximized"',dataf2) > 0 then
         begin
        width := fpgApplication.ScreenWidth  - 190 ;
          left := 190 ;
             top := 43 ;
         {$IFDEF Windows}
            top := 41 ;
            width := fpgApplication.ScreenWidth  - 198 ;
            {$ENDIF}
      end else  if   Pos('WindowState Value="Normal"',dataf2) > 0 then
               begin
               if   Pos('Left="',dataf2) > 0 then
                    begin
                       dataf := copy(dataf2,Pos('Left="',dataf2)+6,6) ;
            left := strtoint(copy(dataf,1 ,Pos('"',dataf)-1)) + 190 ;
                        end else left := 190 ;
            {$IFDEF Windows}
            left := left + 8 ;
            {$ENDIF}

           if   Pos('Top="',dataf2) > 0 then
                   begin
                  dataf := copy(dataf2,Pos('Top="',dataf2)+5,6) ;
            top := strtoint(copy(dataf,1 ,Pos('"',dataf)-1)) ;
            end

             {$IFDEF windows}
             else top :=  0 ;
              top := top + 50;
            {$else}
             else top :=  0 ;
             top := top + 48;

            {$ENDIF}
            {$ifdef fpgui-develop}
            UpdatePosition;
            {$else}
            UpdateWindowPosition;
            {$endif}
            if   Pos('Width="',dataf2) > 0 then
              begin
                  dataf := copy(dataf2,Pos('Width="',dataf2)+7,6) ;
            width := strtoint(copy(dataf,1 ,Pos('"',dataf)-1)) - 190 ;
             {$IFDEF Windows}
            width := width - 8 ;
            {$ENDIF}
          end else
          begin
          width := fpgApplication.ScreenWidth - 190 ;
            {$IFDEF Windows}
            width := width - 8 ;
            {$ENDIF}
          end;
              end;

         ////
         {$ifdef fpgui-develop}
         UpdatePosition;
         {$else}
         UpdateWindowPosition;
         {$endif}

{$IFDEF Windows}
       if  gINI.ReadBool('Options', 'AlwaystoFront', false) = true then
         begin
      left := left - 5 ;
      width := width + 5 ;
        end;
{$else}

       if  gINI.ReadBool('Options', 'AlwaystoFront', false) = true then
                left := left + 1 ;
{$ENDIF}
     end;

    if ide = 2 then begin

    if Pos('WindowState Value="Maximized"',dataf2) > 0 then
         begin
        width := fpgApplication.ScreenWidth ;
          left := 0 ;
          top :=72 ;
           {$IFDEF Windows}
        top := 66
            {$ENDIF}
      end else  if   Pos('WindowState Value="Normal"',dataf2) > 0 then
               begin
               if   Pos('Left="',dataf2) > 0 then
                    begin
                       dataf := copy(dataf2,Pos('Left="',dataf2)+6,6) ;
         left := strtoint(copy(dataf,1 ,Pos('"',dataf)-1))  ;
                end else left :=0 ;

               if   Pos('Top="',dataf2) > 0 then
                   begin
                  dataf := copy(dataf2,Pos('Top="',dataf2)+5,6) ;
         top := strtoint(copy(dataf,1 ,Pos('"',dataf)-1)) + 69 ;
            end  else top :=69 ;

            if   Pos('Width="',dataf2) > 0 then
              begin
                  dataf := copy(dataf2,Pos('Width="',dataf2)+7,6) ;
            width := strtoint(copy(dataf,1 ,Pos('"',dataf)-1)) ;
          end else width := fpgApplication.ScreenWidth ; ;
             ////
   {$IFDEF Windows}

     if  gINI.ReadBool('Options', 'AlwaystoFront', false) = true then
                left := left + 8 ;
{$ENDIF}

{$IFDEF unix}

     if  gINI.ReadBool('Options', 'AlwaystoFront', false) = true then
                left := left + 2 ;
{$ENDIF}
 end;
   end;
      CloseFile(f);
      {$ifdef fpgui-develop}
      UpdatePosition;
      {$else}
      UpdateWindowPosition;
      {$endif}
         end;
end;

end;

procedure TfrmMainDesigner.onMessagePost;
begin

  if theMessage = 'quit' then
    begin
     mayclose := true;
       if assigned(ATimer) then
   ATimer.Enabled:=false;
       fpgapplication.Terminate;
    end
  else
  // or (theMessage = 'closeall')
  if  ( (FileExists(theMessage)) or (theMessage = 'closeall') or (theMessage = 'showit') or (theMessage = 'hideit') ) then
  begin
    maindsgn.EditedFileName := theMessage;
    maindsgn.OnLoadFile(maindsgn);
  end;
  BringToFront;
end;


procedure TfrmMainDesigner.OnLoadUndo(Sender: TObject);
begin
  if Sender is TfpgMenuItem then
  begin
    maindsgn.loadundo(TfpgMenuItem(Sender).Tag);
  end;
end;

procedure TfrmMainDesigner.OnIndexUndo(Sender: TObject);
begin
  frmMainDesigner.undomenu.MenuItem(1).Enabled := True;
  if indexundo < length(ArrayUndo) - 1 then
  begin
    Inc(indexundo);
    maindsgn.loadundo(indexundo);
  end
  else
    frmMainDesigner.undomenu.MenuItem(0).Enabled := False;
end;

procedure TfrmMainDesigner.OnIndexRedo(Sender: TObject);
begin
  frmMainDesigner.undomenu.MenuItem(0).Enabled := True;
  if indexundo > 0 then
  begin
    Dec(indexundo);
    maindsgn.loadundo(indexundo);
  end
  else
    frmMainDesigner.undomenu.MenuItem(1).Enabled := False;
end;

{@VFD_NEWFORM_DECL}

{@VFD_NEWFORM_IMPL}

procedure TfrmMainDesigner.AfterCreate;
var
  n, x, y: integer;
  islinux : boolean;
  wgc: TVFDWidgetClass;
  btn: TwgPaletteButton;
  mi, mi2, mi3, mi4, mi5, mi8: TfpgMenuItem;
begin 

  {%region 'Auto-generated GUI code' -fold}


  {@VFD_BODY_BEGIN: frmMainDesigner}
  Name := 'frmMainDesigner';
 // SetPosition(400, 10, 900, 92);
  WindowTitle := 'fpGUI designer ext';
  Hint := '';
  BackGroundColor := $80000001;
  MinWidth := 840;
  MinHeight := 90;
  WindowPosition := wpUser;
  left := 10;
  top := 10 ;
  width := 842 ;
  height := 92 ;

  //iconname := 'vfd.ideuicon' ;

  panel1 := TfpgPanel.Create(self);
  with panel1 do
  begin
    Name := 'panel1';
    SetPosition(0, 0, 800, 92);
    Anchors := [anLeft,anRight,anTop,anBottom];
    Align := alClient;
    FontDesc := '#Label1';
    //BackgroundColor := clblack;
    Hint := '';
    Text := '';
  end;

  PanelMove := TfpgPanel.Create(panel1);
  with PanelMove do
  begin
    Name := 'PanelMove';
    SetPosition(2, 2, 13, 88);
    Align := alLeft;
    BackgroundColor := TfpgColor($BED9BE);
    FontDesc := '#Label1';
    Hint := 'Hold left-click to move, right-click to resize...';
    Style := bsLowered;
    ShowHint := True;
    Text := '';
    OnMouseMove := @onMovemovepanel;
    OnMouseDown := @onClickDownPanel;
    OnMouseUp := @onClickUpPanel;
  end;

  xicon := TfpgLabel.Create(PanelMove);
  with xicon do
  begin
    Name := 'xicon';
    SetPosition(2, 1, 8, 14);
    BackgroundColor := TfpgColor($BED9BE);
    FontDesc := '#Label2';
    Hint := 'Quit';
    ShowHint := True;
    Textcolor := clgray;
    Text := 'X';
    OnClick := @maindsgn.OnHide;
  end;

  micon := TfpgLabel.Create(PanelMove);
  with micon do
  begin
    Name := 'micon';
    SetPosition(2, 71, 8, 14);
    BackgroundColor := TfpgColor($BED9BE);
    FontDesc := '#Label2';
    Hint := 'Minimize';
    ShowHint := True;
    Textcolor := clgray;
    Text := '¬';
    visible := false;
    OnClick := @maindsgn.OnMini;
  end;

  MainMenu := TfpgMenuBar.Create(panel1);
  with MainMenu do
  begin
    Name := 'MainMenu';
    SetPosition(0, 0, 753, 24);
    Align := alTop;

   OnMouseMove := @onMovemovepanel;
   OnMouseDown := @onClickDownPanel;
   OnMouseUp := @onClickUpPanel;
  end;

  filemenu := TfpgPopupMenu.Create(panel1);
  with filemenu do
  begin
    Name := 'filemenu';
    SetPosition(464, 64, 120, 20);
    AddMenuItem('Create New File...', 'Ctrl+N', @(maindsgn.OnNewFile));
    AddMenuItem('Open...', 'Ctrl+O', @(maindsgn.OnLoadFile));
    FFileOpenRecent := AddMenuItem('Open Recent...', '', nil);
    AddMenuItem('-', '', nil);
    AddMenuItem('Add New Form to Current Unit...', '', @OnNewForm);
    AddMenuItem('-', '', nil);
    mi := AddMenuItem('Save', 'Ctrl+S', @(maindsgn.OnSaveFile));
    mi.Tag := 10;
    AddMenuItem('Save As...', '', @OnSaveAs);
    AddMenuItem('Close', '', @OnCloseAll);
    AddMenuItem('-', '', nil);
    mi2 := AddMenuItem('Save As New Program...', 'Ctrl+Shift+P', @OnSaveNewFile);
    mi2.Tag := 11;
    mi3 := AddMenuItem('Save As New Unit...', 'Ctrl+Shift+U', @OnSaveNewFile);
    mi3.Tag := 12;
    mi4 := AddMenuItem('Save As New Library...', 'Ctrl+Shift+L', @OnSaveNewFile);
    mi4.Tag := 13;
    mi5 := AddMenuItem('Save As New Java Library...', 'Ctrl+Shift+J', @OnSaveNewFile);
    mi5.Tag := 14;
    AddMenuItem('-', '', nil);
    AddMenuItem('Exit', 'Ctrl+Q', @maindsgn.OnHide);
  end;

  formmenu := TfpgPopupMenu.Create(panel1);
  with formmenu do
  begin
    Name := 'formmenu';
    SetPosition(464, 48, 120, 20);
    AddMenuItem('Widget Order...', '', @(maindsgn.OnEditWidgetOrder));
    AddMenuItem('Tab Order...', '', @(maindsgn.OnEditTabOrder));
    AddMenuItem('-', '', nil);
    AddMenuItem('Edit special...', '', nil).Enabled := False; // TODO
  end;

  miOpenRecentMenu := TfpgPopupMenu.Create(panel1);
  with miOpenRecentMenu do
  begin
    Name := 'miOpenRecentMenu';
    SetPosition(336, 68, 128, 20);
  end;

  setmenu := TfpgPopupMenu.Create(panel1);
  with setmenu do
  begin
    Name := 'setmenu';
    SetPosition(464, 48, 120, 20);
    AddMenuItem('General Settings', '', @(maindsgn.OnOptionsClick));
  end;

  undomenu := TfpgPopupMenu.Create(panel1);
  with undomenu do
  begin
    Name := 'undomenu';
    SetPosition(464, 48, 120, 20);
    AddMenuItem('Undo', 'Ctrl+Z', @OnIndexUndo);
    AddMenuItem('ReDo', 'Ctrl+Maj+Z', @OnIndexRedo);
    AddMenuItem('-', '', nil);
    FlistUndo := AddMenuItem('Undo List...', '', nil);
    MenuItem(0).Enabled := False;
    MenuItem(1).Enabled := False;
    MenuItem(3).Enabled := False;
  end;

  toolsmenu := TfpgPopupMenu.Create(panel1);
  with toolsmenu do
  begin
    Name := 'toolsmenu';
    SetPosition(328, 52, 120, 20);
    AddMenuItem('Color Picker', '', @micolorwheel);
    AddMenuItem('Image Convertor', '', @miimageconv);
  end;

  helpmenu := TfpgPopupMenu.Create(panel1);
  with helpmenu do
  begin
    Name := 'helpmenu';
    SetPosition(448, 52, 120, 20);
    AddMenuItem('About fpGUI Toolkit...', '', @miHelpAboutGUI);
    AddMenuItem('About designer_ext...', '', @miHelpAboutClick);
  end;

  listundomenu := TfpgPopupMenu.Create(panel1);
  with listundomenu do
  begin
    Name := 'listundomenu';
    SetPosition(328, 52, 120, 20);
  end;

  windowmenu := TfpgPopupMenu.Create(panel1);
  with windowmenu do
  begin
    Name := 'windowmenu';
    SetPosition(328, 52, 120, 20);
    AddMenuItem('Object Inspector', '', @OnObjInspect);
    AddMenuItem('-', '', nil);
    AddMenuItem('', '', @frmMainDesigner.OnFormDesignShow);
    AddMenuItem('', '', @frmMainDesigner.OnFormDesignShow);
    AddMenuItem('', '', @frmMainDesigner.OnFormDesignShow);
    AddMenuItem('', '', @frmMainDesigner.OnFormDesignShow);
    AddMenuItem('', '', @frmMainDesigner.OnFormDesignShow);
    AddMenuItem('', '', @frmMainDesigner.OnFormDesignShow);
    AddMenuItem('', '', @frmMainDesigner.OnFormDesignShow);
    AddMenuItem('', '', @frmMainDesigner.OnFormDesignShow);
    AddMenuItem('', '', @frmMainDesigner.OnFormDesignShow);
    AddMenuItem('', '', @frmMainDesigner.OnFormDesignShow);
    MenuItem(2).Tag := 0;
    MenuItem(3).Tag := 1;
    MenuItem(4).Tag := 2;
    MenuItem(5).Tag := 3;
    MenuItem(6).Tag := 4;
    MenuItem(7).Tag := 5;
    MenuItem(8).Tag := 6;
    MenuItem(9).Tag := 7;
    MenuItem(10).Tag := 8;
    MenuItem(11).Tag := 9;
  end;

  previewmenu := TfpgPopupMenu.Create(panel1);
  with previewmenu do
  begin
    Name := 'previewmenu';
    SetPosition(324, 36, 120, 20);
  end;

  btnNewForm := TfpgButton.Create(panel1);
  with btnNewForm do
  begin
    Name := 'NewForm';
    SetPosition(16, 33, 25, 24);
    FontDesc := '#Label1';
    Hint := 'Add New Form to Unit';
    ImageMargin := -1;
    ImageName := 'vfd.newform';
    ImageSpacing := 0;
    TabOrder := 1;
    Text := '';
    Visible := False;
    ShowHint := True;
    Focusable := true;
    OnClick := @(OnNewForm);
  end;

  btnOpen := TfpgButton.Create(panel1);
  with btnOpen do
  begin
    Name := 'Open';
    SetPosition(42, 33, 25, 24);
    FontDesc := '#Label1';
    Hint := 'Open a file';
    ImageMargin := -1;
    ImageName := 'stdimg.open';
    ImageSpacing := 0;
    TabOrder := 2;
    Text := '';
    ShowHint := True;
    Visible := False;
    Focusable := true;
    OnClick := @(maindsgn.OnLoadFile);
  end;

  btnSave := TfpgButton.Create(panel1);
  with btnSave do
  begin
    Name := 'Save';
    SetPosition(68, 33, 25, 24);
    FontDesc := '#Label1';
    Hint := 'Save the loaded forms';
    ImageMargin := -1;
    ImageName := 'stdimg.save';
    ImageSpacing := 0;
    TabOrder := 3;
    Text := '';
    tag := 10;
    Visible := False;
    Focusable := true;
    ShowHint := True;
    OnClick := @(maindsgn.OnSaveFile);
  end;

  btnGrid := TfpgButton.Create(panel1);
  with btnGrid do
  begin
    Name := 'Grid';
    SetPosition(94, 33, 25, 24);
    FontDesc := '#Label1';
    Hint := 'Toggle designer grid';
    ImageMargin := -1;
    ImageName := 'vfd.grid';
    ImageSpacing := 0;
    TabOrder := 13;
    Text := '';
     tag := 0;
    Focusable := true;
    ShowHint := True;
    OnClick := @ToggleDesignerGrid;
  end;

  btnToFront := TfpgButton.Create(panel1);
  with btnToFront do
  begin
    Name := 'ToFront';
    SetPosition(120, 33, 25, 24);
    FontDesc := '#Label1';
    Hint := 'Switch Designer Always-To-Front <> Normal';
    ImageMargin := -1;
    ImageName := 'vfd.tofront';
    ImageSpacing := 0;
    TabOrder := 3;
    Text := '';
    Focusable := true;
    ShowHint := True;
    onClick := @ToFrontClick;
  end;

  btnSelected := TfpgButton.Create(panel1);
  with btnSelected do
  begin
    Name := 'Selected';
    SetPosition(146, 33, 25, 24);
    FontDesc := '#Label1';
    Hint := 'Multi-Selector => Select objects and apply changes';
    ImageMargin := -1;
    ImageName := 'vfd.select';
    ImageSpacing := 0;
    TabOrder := 20;
    Text := '';
    Focusable := true;
    ShowHint := True;
    OnClick := @onmultiselect;
  end;

  btnAssist := TfpgButton.Create(panel1);
  with btnAssist do
  begin
    Name := 'Assist';
    SetPosition(172, 33, 25, 24);
    FontDesc := '#Label1';
    Hint := 'Toggle voice assistive';
    ImageMargin := -1;
    ImageName := 'vfd.assit';
    ImageSpacing := 0;
    TabOrder := 13;
    Text := '';
    tag := 0;
    Focusable := true;
    AllowAllUp := True;
    AllowDown := True;
    ShowHint := True;
    OnClick := @sakenable;
  end;

  wgpalette := TwgPalette.Create(panel1);
  with wgpalette do
  begin
    Name := 'wgpalette';
    SetPosition(200, 28, 578, 62);
    Anchors := [anLeft,anRight,anTop,anBottom];
    Focusable := False;
    ShowHint := True;
    Width := self.Width - 204;
    OnResize := @PaletteBarResized;
  end;

  chlPalette := TfpgComboBox.Create(panel1);
  with chlPalette do
  begin
    Name := 'chlPalette';
    SetPosition(16, 62, 181, 22);
    ExtraHint := '';
    FontDesc := '#List';
    Hint := 'Widgets list';
    ShowHint := True;
    FocusItem := -1;
    TabOrder := 5;
    chlPalette.OnChange:=@OnChangeWidget;
  end;

  {@VFD_BODY_END: frmMainDesigner}
  {%endregion}

    {$if defined(cpu64)}
  bitcpu := 64;
{$else}
  bitcpu := 32;
   {$endif}

     for x := 0 to 99 do
  begin
    listundomenu.AddMenuItem('', '', @OnLoadUndo);
    listundomenu.MenuItem(x).Visible := False;
    listundomenu.MenuItem(x).Tag := x;
  end;

  { Build component palette }

  x := 0;
  y := 0;

   OnCloseQuery := @FormCloseQuery;
  OnClose := @FormClose;
  maxundo := gINI.ReadInteger('Options', 'MaxUndo', 10);
  enableundo := gINI.ReadBool('Options', 'EnableUndo', True);
  enableautounits := gINI.ReadBool('Options', 'EnableAutoUnits', True);

  for n := 0 to VFDWidgetCount - 1 do
  begin
    wgc := VFDWidget(n);
    btn := TwgPaletteButton.Create(wgpalette);
    btn.VFDWidget := wgc;
    btn.SetPosition(x, y, 30, 28);
    btn.ImageName := wgc.WidgetIconName;
    btn.ImageMargin := -1;
    btn.Text := '';
    btn.Hint := wgc.WidgetClass.ClassName;
    btn.Focusable := False;
    btn.ShowHint := True;
    btn.OnClick := @OnPaletteClick;

     {$ifdef fpgui-develop}
     btn.OnDragStartDetected:=@OnPaletteDragStart;
 {$else}
 {$endif}

    btn.AllowDown := True;
    btn.AllowAllUp := True;
    chlPalette.Tag:=1 ;
    chlPalette.Items.AddObject(wgc.WidgetClass.ClassName, wgc);

    Inc(x, 32);
    if (x + 30) >= wgpalette.Width then
    begin
      x := 0;
      Inc(y, 30);
    end;
  end;

  BuildThemePreviewMenu;

  chlPalette.Items.Sort;

  if gINI.ReadBool('Options', 'AlwaysToFront', False)  = False then
  begin
    windowType := wtwindow;
    btnToFront.tag := 0;
  end
  else
  begin
    windowType := wtpopup;
     btnToFront.tag := 1;
  end;


  MainMenu.AddMenuItem('&File', nil).SubMenu := filemenu;
  MainMenu.AddMenuItem('&Undo', nil).SubMenu := undomenu;
  MainMenu.AddMenuItem('Selected Fo&rm', nil).SubMenu := formmenu;
  MainMenu.AddMenuItem('&Settings', nil).SubMenu := setmenu;
  MainMenu.AddMenuItem('&Preview', nil).SubMenu := previewmenu;
  MainMenu.AddMenuItem('&Window', nil).SubMenu := windowmenu;
  MainMenu.AddMenuItem('&Tools', nil).SubMenu := toolsmenu;
  MainMenu.AddMenuItem('&Help', nil).SubMenu := helpmenu;
  MainMenu.AddMenuItem('', nil);
  MainMenu.MenuItem(8).Tag := 88;

  FFileOpenRecent.SubMenu := miOpenRecentMenu;
  FlistUndo.SubMenu := listundomenu;

  mru := TfpgMRU.Create(self);
  mru.ParentMenuItem := miOpenRecentMenu;
  mru.OnClick := @miMRUClick;
  mru.MaxItems := gINI.ReadInteger('Options', 'MRUFileCount', 4);
  mru.ShowFullPath := gINI.ReadBool('Options', 'ShowFullPath', True);
  mru.LoadMRU;

 MainMenu.MenuItem(1).Visible:=false;
 MainMenu.MenuItem(2).Visible:=false;
 MainMenu.MenuItem(5).Visible:=false;

 MainMenu.MenuItem(8).Visible := False;
 MainMenu.MenuItem(8).Text :=
      'fpGUI designer_ext v' + ext_version + ' ' + IntToStr(bitcpu) + ' bit';

windowtitle := MainMenu.MenuItem(8).Text;

{$ifdef fpgui-develop}
  filemenu.MenuItem(4).enabled := False;
  filemenu.MenuItem(5).enabled := False;
  filemenu.MenuItem(6).enabled := False;
  filemenu.MenuItem(7).enabled := False;
  filemenu.MenuItem(8).enabled := false;
  filemenu.MenuItem(9).enabled := False;
  filemenu.MenuItem(10).enabled := False;
  filemenu.MenuItem(11).enabled := False;
  filemenu.MenuItem(12).enabled := False;
  filemenu.MenuItem(13).enabled := False;
  filemenu.MenuItem(14).enabled := False;

  filemenu.MenuItem(1).enabled := False;
  filemenu.MenuItem(2).enabled := False;
  filemenu.MenuItem(15).enabled := False;
{$else}
  filemenu.MenuItem(4).visible := False;
  filemenu.MenuItem(5).visible := False;
  filemenu.MenuItem(6).visible := False;
  filemenu.MenuItem(7).visible := False;
  filemenu.MenuItem(8).visible := false;
  filemenu.MenuItem(9).visible := False;
  filemenu.MenuItem(10).visible := False;
  filemenu.MenuItem(11).visible := False;
  filemenu.MenuItem(12).visible := False;
  filemenu.MenuItem(13).visible := False;
  filemenu.MenuItem(14).visible := False;

  filemenu.MenuItem(1).visible := False;
  filemenu.MenuItem(2).visible := False;
  filemenu.MenuItem(15).visible := False;
{$endif}

      {$ifdef ideu}
  x := gINI.ReadInteger('Options', 'IDE', 3)  ;
  {$else}
  x := gINI.ReadInteger('Options', 'IDE', 0)  ;
 {$endif}
 
  idetemp := x ;
  
 {$ifdef fpgui-develop}
 UpdatePosition;
 {$else}
 UpdateWindowPosition;
 {$endif}

   if gINI.ReadBool('frmMainState', 'FirstLoad', True) = False then
      gINI.ReadFormState(self)
    else
      gINI.WriteBool('frmMainState', 'FirstLoad', False);
   hide;
    fpgapplication.ProcessMessages;

   islinux := false ;
  {$IFDEF linux}
   islinux := true ;
   {$ENDIF}

fpgapplication.ProcessMessages;

  if x = 0  then
  begin
   btnToFront.tag := 0;
  WindowType := wtwindow;  // with borders, not on front.
    btnOpen.Visible := True;
    btnSave.Left := 69;

     panel1.Style := bsflat;

     {$ifdef fpgui-develop}
      btnSave.UpdatePosition;
     panel1.UpdatePosition;
   filemenu.MenuItem(1).enabled := True;
    filemenu.MenuItem(2).enabled := True;
    filemenu.MenuItem(15).enabled := true;
 {$else}
  WindowAttributes:= [];
    btnSave.UpdateWindowPosition;
     panel1.UpdateWindowPosition;
  filemenu.MenuItem(1).Visible := True;
    filemenu.MenuItem(2).Visible := True;
    filemenu.MenuItem(15).Visible := true;
 {$endif}

    indexundo := 0;
     MainMenu.MenuItem(8).Visible := false;
           
   end
  else
  begin
  
{$ifdef ideu}
if  (gINI.ReadBool('Options', 'RunOnlyOnce', true) = false) then
{$else}
 if  (gINI.ReadBool('Options', 'RunOnlyOnce', true) = false) or 
 ((IsRunningIDE('typhon') = False) and (IsRunningIDE('lazarus') = False) and
   (IsRunningIDE('ideu') = False) and (IsRunningIDE('ideU') = False)) then
 {$endif}

    begin
  btnToFront.tag := 0;
  WindowType := wtwindow;  // with borders, not on front.
    btnOpen.Visible := True;
    btnSave.Left := 69;
  
      panel1.Style := bsflat;
        MainMenu.MenuItem(8).Visible := false;

          {$ifdef fpgui-develop}
    btnSave.UpdatePosition;
     panel1.UpdatePosition;
   {$else}
    WindowAttributes:= [];
    btnSave.UpdateWindowPosition;
     panel1.UpdateWindowPosition;
   {$endif}


          {$ifdef fpgui-develop}
   filemenu.MenuItem(1).enabled := True;
    filemenu.MenuItem(2).enabled := True;
    filemenu.MenuItem(15).enabled := true;
 {$else}
  filemenu.MenuItem(1).Visible := True;
    filemenu.MenuItem(2).Visible := True;
    filemenu.MenuItem(15).Visible := true;
 {$endif}
     indexundo := 0;
     MainMenu.MenuItem(8).Visible := false;
     end else begin
     if islinux = true then begin
       MainMenu.MenuItem(8).Visible := true;
      panel1.Style := bsLowered;
      panel1.BorderStyle := bsdouble;
        {$ifdef fpgui-develop}
 {$else}
     WindowAttributes:= [waSizeable, waBorderless];
 {$endif}
      end else
      begin
       MainMenu.MenuItem(8).Visible := false;
       panel1.Style := bsflat;
      {$ifdef fpgui-develop}
     {$else}
     WindowAttributes:= [];
      {$endif}
      end;
      
     if x < 3 then LoadIDEparameters(x);
      end;

      {$ifdef fpgui-develop}
   panel1.UpdatePosition;
 {$else}
     panel1.UpdateWindowPosition;
 {$endif}
  end;

  if ifonlyone = True then
  begin
    InitMessage;
    StartMessage(@onMessagePost, 500);
  end;

   PaletteBarResized(self);

   {$ifdef fpgui-develop}
   UpdatePosition;
   {$else}
   UpdateWindowPosition;
   {$endif}

  fpgApplication.CreateForm(Tfrm_multiselect, frmMultiSelect);
  chlPalette.Tag:=0;
  
 end;

procedure TfrmMainDesigner.ToggleDesignerGrid(Sender: TObject);
begin
 if btnGrid.Tag = 0 then
 begin
 btnGrid.Tag := 1 ;
  maindsgn.ShowGrid := true;
 end else
  begin
 btnGrid.Tag := 0 ;
  maindsgn.ShowGrid := false;
 end
end;

procedure TfrmMainDesigner.FormShow(Sender: TObject);
begin
  gINI.ReadFormState(self);
  {$ifdef fpgui-develop}
  UpdatePosition;
  {$else}
  UpdateWindowPosition;
  {$endif}
end;

constructor TfrmMainDesigner.Create(AOwner: TComponent);
begin                                                             
  inherited Create(AOwner);
  fpgImages.AddMaskedBMP('vfd.grid', @vfd_grid,
    sizeof(vfd_grid), 0, 0);
  fpgImages.AddMaskedBMP('vfd.tofront', @vfd_tofront,
    sizeof(vfd_tofront), 0, 0);
  fpgImages.AddMaskedBMP('vfd.select', @vfd_select,
    sizeof(vfd_select), 0, 0);
   fpgImages.AddMaskedBMP('vfd.assit', @vfd_assist,
    sizeof(vfd_assist), 0, 0);
//    fpgImages.AddMaskedBMP('vfd.ideuicon', @vfd_ideuicon, sizeof(vfd_ideuicon), 0, 0);
  OnShow := @FormShow;
end;

procedure TfrmMainDesigner.BeforeDestruction;
var
  undodir : string;
begin
  frmmultiselect.Hide;

  SAKUnLoadlib ;
   undodir := IncludeTrailingBackslash(ExtractFilePath(ParamStr(0))) + directoryseparator + 'temp'  ;

  if DirectoryExists(PChar(undodir)) then
  begin
  deletefile(PChar(undodir+DirectorySeparator+'*.*')) ;
  RemoveDir(undodir);
   end;

 // maindsgn.OnHide(self) ;

  gINI.WriteFormState(self);
  gINI.WriteInteger('Options', 'IDE', idetemp);
  inherited BeforeDestruction;
end;

procedure TfrmMainDesigner.OnPaletteClick(Sender: TObject);
var
  s: string;
  i: integer;
begin
  i := -1;
  chlPalette.Tag := 1;
  if TwgPaletteButton(Sender).Down then
  begin
    s := TwgPaletteButton(Sender).VFDWidget.WidgetClass.ClassName;
    i := chlPalette.Items.IndexOf(s);
  end;
  chlPalette.FocusItem := i;
  chlPalette.Tag := 0;

end;

procedure TfrmMainDesigner.OnSaveNewFile(Sender: TObject);
begin
  maindsgn.isFileNew := True;
  maindsgn.OnSaveFile(Sender);
end;

procedure TfrmMainDesigner.OnCloseAll(Sender: TObject);
begin
  maindsgn.EditedFileName := 'closeit';
  maindsgn.OnLoadFile(Sender);
end;

procedure TfrmMainDesigner.OnNewForm(Sender: TObject);
begin
  maindsgn.OnNewForm(Sender);
end;

procedure TfrmMainDesigner.OnChangeWidget(Sender: TObject);
var
 n : integer;
begin
  if chlPalette.Tag =0 then
  begin
   for n := 0 to wgpalette.ComponentCount - 1 do
      if TwgPaletteButton(wgpalette.Components[n]).VFDWidget.WidgetClass.ClassName =
       chlPalette.Text  then  TwgPaletteButton(wgpalette.Components[n]).Down := true else
      TwgPaletteButton(wgpalette.Components[n]).Down := false;
  end;
end;

procedure TfrmMainDesigner.OnSaveAs(Sender: TObject);
begin
  maindsgn.isFileNew := True;
  maindsgn.FFileLoaded := maindsgn.EditedFilename;
  maindsgn.OnSaveFile(Sender);
end;

procedure TfrmMainDesigner.onClickDownPanel(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint);
begin
PanelMove.Tag := 0;
  oriMousePos := AMousePos;
  if (Sender is TfpgMenuItem) then if TfpgMenuItem(Sender).Tag = 88 
  then PanelMove.Tag := 1;
 
 if(Sender is Tfpgpanel) then PanelMove.Tag := 1;

end;

procedure TfrmMainDesigner.onClickUpPanel(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint);
begin
  PanelMove.Tag := 0;
   gINI.WriteFormState(self) ;
end;

procedure TfrmMainDesigner.sakenable(Sender: TObject);
begin
  if directoryexists(dirsakit + directoryseparator +'sakit')
 then if btnAssist.Tag = 1 then
  begin
  btnAssist.Tag := 0 ;
  SAKUnLoadlib ;
  end
  else
   begin
  btnAssist.Tag := 1 ;
  SAKLoadlib(dirsakit) ;
  end
end;

procedure TfrmMainDesigner.onMoveMovePanel(Sender: TObject; AShift: TShiftState; const AMousePos: TPoint);
var
isok : boolean = false; 
begin
 
  if PanelMove.Tag = 1 then
  begin
    fpgapplication.ProcessMessages;
  if  (AShift =  [ssRight]) or  (AShift =   [ssCtrl]) then
  begin
   width := width  - (AMousePos.Y - oriMousePos.y);
  end else
  begin
   top := top + (AMousePos.Y - oriMousePos.y);
    left := left + (AMousePos.x - oriMousePos.X);
   end;
  {$ifdef fpgui-develop}
  UpdatePosition;
  {$else}
  UpdateWindowPosition;
  {$endif}
  end;

end;

procedure TfrmMainDesigner.ToFrontClick(Sender: TObject);
begin
  if btnToFront.Tag = 0 then
    Onalwaystofront(Sender)
  else
    OnNevertofront(Sender);
end;

procedure TfrmMainDesigner.onmultiselect(Sender: TObject);
var
  TheParent: Tfpgwidget;
begin

  if frmMultiSelect.Visible = false then
  begin
  if (frmProperties.edName.Text <> '') and (frmProperties.lstProps.Props.Widget <> nil) and (maindsgn.selectedform <> nil) then
  begin

     TheParent := WidgetParentForm(TfpgWidget(frmProperties.lstProps.Props.Widget));
    calculwidget := True;

    frmMultiSelect.Getwidgetlist(TheParent);

    calculwidget := False;

    frmMultiSelect.hide;    //// this to give focus
    fpgapplication.ProcessMessages;
    frmMultiSelect.Show;

  end
  else
    ShowMessage('Nothing loaded or no form selected...', 'Warning', True);
 end else frmMultiSelect.hide ;
end;

procedure TfrmMainDesigner.OnAlwaysToFront(Sender: TObject);
var
  frmisvisible: boolean;
begin
  hide;

    fpgapplication.ProcessMessages;
  if frmProperties.Visible = True then
    frmisvisible := True
  else
    frmisvisible := False;

  WindowType := wtpopup;

  btnToFront.tag := 1;
  if idetemp = 1 then
  begin
    {$IFDEF Windows}
    // left := left - 5 ;
    Width := Width + 8;
       {$ENDIF}
    {$IFDEF unix}
    left := left + 1;
    {$ENDIF}
  end;

  if idetemp = 2 then
  begin
    {$IFDEF unix}
    left := left + 2;
    {$ENDIF}
    {$IFDEF windows}
    left := left + 8;
     {$ENDIF}
  end;
  {$ifdef fpgui-develop}
  UpdatePosition;
  {$else}
  UpdateWindowPosition;
  {$endif}

 //    PanelMove.Visible := True;

      if idetemp = 0 then
  begin  
  //    panel1.Style := bsLowered;
  //    panel1.UpdatePosition;
     MainMenu.MenuItem(8).Visible := False;

  if trim(maindsgn.p + maindsgn.s) <> '' then
  begin 
    MainMenu.MenuItem(8).Text := '   ' + maindsgn.p + maindsgn.s;
    MainMenu.MenuItem(8).Visible := True;
  end; 
  end; 

   Show;
  if frmisvisible = True then
  begin
    frmProperties.hide;
    fpgapplication.ProcessMessages;
    frmProperties.Show;
  end;
  {$ifdef fpgui-develop}
  UpdatePosition;
  {$else}
  UpdateWindowPosition;
  {$endif}
end;

procedure TfrmMainDesigner.OnNeverToFront(Sender: TObject);
var
  frmisvisible: boolean;
begin
  hide;
    fpgapplication.ProcessMessages;
  if frmProperties.Visible = True then
    frmisvisible := True
  else
    frmisvisible := False;

   btnToFront.tag := 0;
  WindowType := wtwindow;  // with borders, not on front.

  if idetemp = 1 then
  begin
   {$IFDEF Windows}
    //  left := left + 5 ;
    Width := Width - 8;
      {$ENDIF}
 {$IFDEF unix}
    left := left - 1;
  {$ENDIF}
  end;

  if idetemp = 2 then
  begin
   {$IFDEF unix}
    left := left - 2;
    {$ENDIF}
   {$IFDEF windows}
    left := left - 8;
     {$ENDIF}
  end;
  {$ifdef fpgui-develop}
  UpdatePosition;
  {$else}
  UpdateWindowPosition;
  {$endif}

    if idetemp = 0 then
  begin
  //    panel1.Style := bsflat;
  //    panel1.UpdatePosition;
      MainMenu.MenuItem(8).Text := '';
      MainMenu.MenuItem(8).Visible := False;
  end else MainMenu.MenuItem(8).Visible := true;

   Show;

  if frmisvisible = True then
  begin
    frmProperties.hide;
    fpgapplication.ProcessMessages;
    frmProperties.Show;
  end;
  {$ifdef fpgui-develop}
  UpdatePosition;
  {$else}
  UpdateWindowPosition;
  {$endif}
end;

procedure TfrmMainDesigner.OnObjInspect(Sender: TObject);
begin
  frmProperties.hide;
  fpgapplication.ProcessMessages;
  frmProperties.Show;
end;

procedure TfrmMainDesigner.OnFormDesignShow(Sender: TObject);
begin
  if Sender is TfpgMenuItem then
  begin
    ArrayFormDesign[TfpgMenuItem(Sender).Tag].Form.Hide;
    ArrayFormDesign[TfpgMenuItem(Sender).Tag].Form.Show;
  end;
end;

{ TfrmProperties }

procedure TfrmProperties.FormShow(Sender: TObject);
begin
// gINI.ReadFormState(self);
end;

procedure TfrmProperties.FormResized(Sender: TObject);
begin
  SetHierarchyMaxHeight;
  frmPropertiesPaint(sender);
end;

procedure TfrmProperties.TreeSelect(Sender: TObject);
var
aObj: TfpgWidget;
aName: string;
begin
if (maindsgn.selectedform <> nil) then
aName :=  copy(TreeView1.selection.text,1, pos(':',TreeView1.selection.text)-1);
maindsgn.selectedform.deselectall; 
  begin
if (maindsgn.selectedform.form.name <> aName) then
begin
  aObj := maindsgn.selectedform.FindWidgetByName(aName);
  if aObj <> nil then
  maindsgn.selectedform.WidgetDesigner(aObj).selected := true;
 
end else edName.Text := aname; 
 maindsgn.selectedform.UpdatePropWin;
end;
end;

procedure TfrmProperties.SetHierarchyMaxHeight;
begin
  Bevel1.MaxHeight := Round(Height * 0.4); // no more than 40% of window height
end;

procedure TfrmProperties.AfterCreate;
var
  x, x2, w, y, nblist, gap: integer;
begin
// inherited;
  {%region 'Auto-generated GUI code' -fold}
   {@VFD_BODY_BEGIN: frmProperties}
  Name := 'frmProperties';
  WindowTitle := 'Properties';
  left := 10;
  top := 110;
  Width := 270;
  Height := 590;
  MinWidth := 268;
  MinHeight := 588;
  //OnResize := @frmPropertiesPaint;
  OnResize := @FormResized;
  Visible := False;
    
     Bevel1 := TfpgBevel.Create(self);
  with Bevel1 do
  begin
    Name := 'Bevel1';
    SetPosition(0, 0, 250, 100);
    Hint := '';
    Shape := bsSpacer;
  end;

  TreeView1 := TfpgTreeView.Create(Bevel1);
  with TreeView1 do
  begin
    Name := 'TreeView1';
    SetPosition(4, 4, 242, 92);
    Anchors := [anLeft,anRight,anTop,anBottom];
    FontDesc := '#Label1';
    Hint := '';
    TabOrder := 1;
    OnChange := @TreeSelect;
  end;

  Splitter1 := TfpgSplitter.Create(self);
  with Splitter1 do
  begin
    Name := 'Splitter1';
    SetPosition(0, 100, 250, 8);
  end;

  bvlOI := TfpgBevel.Create(self);
  with bvlOI do
  begin
    Name := 'bvlOI';
    SetPosition(0, 108, 250, 461);
    Hint := '';
    Shape := bsSpacer;
  end;
    
   x := 3;
  x2 := x + 50;
  gap := 20;
  w := Width - x2;
  y := 3;

  l1 := TfpgLabel.Create(bvlOI);
  l1.Text := 'Class:';
  l1.Top := y - 1;
  l1.left := 5;

  lbClass := TfpgLabel.Create(bvlOI);
  lbClass.Text := '';
  lbClass.Top := y - 1;
  lbClass.left := x2;
  lbClass.Width := w;
  lbClass.Height := 22;
  lbClass.FontDesc := '#Label2';
  lbClass.Anchors := [anLeft, anRight, anTop];
  Inc(y, gap);

  l2 := TfpgLabel.Create(bvlOI);
  l2.Text := 'Name:';
  l2.Top := y + 1;
  l2.left := 5;
  l2.width := 60;
  l2.Anchors := [anLeft, anRight, anTop];

  edName := TfpgEdit.Create(bvlOI);
  edName.Text := '';
  edName.name := 'name';
 // edName.Width := Width - l2.Right + 28;
  edName.Width := Width - l2.width - 20;
  edName.Top := y - 2;
  edName.left := x2;
  edName.Anchors := [anLeft, anRight, anTop];
  edName.OnChange := @(maindsgn.OnPropNameChange);

  Inc(y, gap + 5);

  
  lstProps := TwgPropertyList.Create(bvlOI);
  lstProps.SetPosition(0, y, Width-20, (bvlOI.Height - y - 150) div 2);
  lstProps.Anchors := AllAnchors;
  lstProps.Props := PropList;
  lstProps.Props.Widget := edName;

  nblist := 1 ;
  while nblist < 15 do
  begin
   lstProps.Items.Add('row, ' + inttostr(nblist));
   inc(nblist);
   end;

  y := lstProps.Bottom;

  virtualpanel := Tfpgpanel.Create(bvlOI);
  virtualpanel.SetPosition(0, y, Width-20, 110);
  virtualpanel.Anchors := [anLeft, anRight];
  virtualpanel.BackgroundColor := $CCCCCC;
  virtualpanel.Style := bsFlat;
  virtualpanel.Visible := False;
  virtualpanel.Text := '';
  virtualpanel.OnPaint := @vpanelpaint;

  cbfocusable := TfpgCombobox.Create(virtualpanel);
  cbfocusable.Items.Add('True');
  cbfocusable.Items.Add('False');
  cbfocusable.FocusItem := 0;
  cbfocusable.Text := 'True';
  cbfocusable.name := 'focusable';
  cbfocusable.BackgroundColor := $E0E0E0;
  cbfocusable.Height := 21;
  
  cbfocusable.OnExit := @VirtualPropertiesUpdate;

  cbsizeable := TfpgCombobox.Create(virtualpanel);
  cbsizeable.Items.Add('True');
  cbsizeable.Items.Add('False');
  cbsizeable.FocusItem := 0;
  cbsizeable.Text := 'True';
  cbsizeable.name := 'sizeable';
  cbsizeable.BackgroundColor := $E0E0E0;
  cbsizeable.Height := 21;
  cbsizeable.OnExit := @VirtualPropertiesUpdate;
  
  cbshowhint := TfpgCombobox.Create(virtualpanel);
  cbshowhint.Items.Add('True');
  cbshowhint.Items.Add('False');
  cbshowhint.FocusItem := 0;
  cbshowhint.Text := 'True';
  cbshowhint.name := 'showhint';
  cbshowhint.BackgroundColor := $E0E0E0;
  cbshowhint.Height := 21;
  cbshowhint.OnExit := @VirtualPropertiesUpdate;

  cbvisible := TfpgCombobox.Create(virtualpanel);
  cbvisible.Items.Add('True');
  cbvisible.Items.Add('False');
  cbvisible.FocusItem := 0;
  cbvisible.Text := 'True';
  cbvisible.BackgroundColor := $E0E0E0;
  cbvisible.name := 'visible';
  cbvisible.Height := 21;
  cbvisible.OnExit := @VirtualPropertiesUpdate;
  ;

  cbfullscreen := TfpgCombobox.Create(virtualpanel);
  cbfullscreen.Items.Add('False');
  cbfullscreen.Items.Add('True');
  cbfullscreen.FocusItem := 0;
  cbfullscreen.Text := 'False';
  cbfullscreen.name := 'fullscreen';

  cbfullscreen.BackgroundColor := $E0E0E0;
  cbfullscreen.Height := 21;
  cbfullscreen.OnExit := @VirtualPropertiesUpdate;


  cbenabled := TfpgCombobox.Create(virtualpanel);
  cbenabled.Items.Add('True');
  cbenabled.Items.Add('False');
  cbenabled.FocusItem := 0;
  cbenabled.Text := 'True';
  cbenabled.name := 'enabled';
  cbenabled.BackgroundColor := $E0E0E0;
  cbenabled.Height := 21;
  cbenabled.OnExit := @VirtualPropertiesUpdate;


  edminwidth := TfpgEdit.Create(virtualpanel);
  edminwidth.Text := '0';
  edminwidth.BackgroundColor := $E0E0E0;
  edminwidth.Height := 21;
  edminwidth.OnExit := @VirtualPropertiesUpdate;
  edminwidth.name := 'minwidth';


  edminheight := TfpgEdit.Create(virtualpanel);
  edminheight.Text := '0';
  edminheight.BackgroundColor := $E0E0E0;
  edminheight.Height := 21;
  edminheight.OnExit := @VirtualPropertiesUpdate;
  edminheight.name := 'minheight';

  edmaxwidth := TfpgEdit.Create(virtualpanel);
  edmaxwidth.Text := '0';
  edmaxwidth.BackgroundColor := $E0E0E0;
  edmaxwidth.Height := 21;
  edmaxwidth.OnExit := @VirtualPropertiesUpdate;
   edmaxwidth.name := 'maxwidth';

  edmaxheight := TfpgEdit.Create(virtualpanel);
  edmaxheight.Text := '0';
  edmaxheight.BackgroundColor := $E0E0E0;
  edmaxheight.Height := 21;
  edmaxheight.OnExit := @VirtualPropertiesUpdate;
   edmaxheight.name := 'maxheight';

  cbWindowPosition := TfpgCombobox.Create(virtualpanel);
  cbWindowPosition.Items.Add('wpUser');
  cbWindowPosition.Items.Add('wpAuto');
  cbWindowPosition.Items.Add('wpScreenCenter');
  cbWindowPosition.Items.Add('wpOneThirdDown');
  cbWindowPosition.FocusItem := 0;
  cbWindowPosition.Text := 'wpUser';
  cbWindowPosition.BackgroundColor := $E0E0E0;
  cbWindowPosition.Height := 21;
  cbWindowPosition.OnExit := @VirtualPropertiesUpdate;
  cbWindowPosition.name := 'WindowPosition';

  edTag := TfpgEdit.Create(virtualpanel);
  edTag.Text := '0';
  edTag.BackgroundColor := $E0E0E0;
  edTag.Height := 21;
  edTag.OnExit := @VirtualPropertiesUpdate;
   edTag.name := 'Tag';
   
   edhint := TfpgEdit.Create(virtualpanel);
  edhint.Text := '';
  edhint.BackgroundColor := $E0E0E0;
  edhint.Height := 21;
  edhint.OnExit := @VirtualPropertiesUpdate;
   edhint.name := 'Hint';
   
    cbsizeable.visible := false;
     cbfocusable.visible := false;
     cbvisible.visible := false;
     cbfullscreen.visible := false;
     cbenabled.visible := false;
     edminwidth.visible := false;
     edmaxwidth.visible := false;
     edminheight.visible := false;
     edmaxheight.visible := false;
     cbwindowposition.visible := false;
     edtag.visible := false;
      edhint.visible := false;
       cbshowhint.visible := false;

  y := virtualpanel.Bottom + 5;

  l3 := CreateLabel(bvlOI, 5, y + 1, 'Left:');
  l3.Anchors := [anLeft, anBottom];

  l6 := TfpgLabel.Create(bvlOI);
  l6.Text := 'Height:';
  l6.Top := y + gap + 5;
  // l6.left:=110;
  l6.Height := 22;
  l6.Anchors := [anright, anBottom];

  l6.Left := Width - (48 * 2) - 30;

  l4 := CreateLabel(bvlOI, 90, y, 'Top:');
  l4.Left := Width - (48 * 2) - 30;
  l4.Anchors := [anright, anBottom];


  btnLeft := CreateButton(bvlOI, 50, y - 2, 48, '0', @(maindsgn.OnPropPosEdit));
  with btnLeft do
  begin
    Height := 22;
    Anchors := [anLeft, anBottom];
    Focusable := False;
    end;

  btnTop := CreateButton(bvlOI, 50, y - 2, 48, '0', @(maindsgn.OnPropPosEdit));

  with btnTop do
  begin
    Height := 22;
    Anchors := [anright, anBottom];
    Focusable := False;
   end;

  btnTop.Left := Width - (btnTop.Width) - 25;

  Inc(y, gap + 5);
  l5 := CreateLabel(bvlOI, 5, y + 1, 'Width:');
  l5.Anchors := [anleft, anBottom];

  btnWidth := CreateButton(bvlOI, 50, y - 2, 48, '0', @(maindsgn.OnPropPosEdit));
  with btnWidth do
  begin
    Height := 22;
    Anchors := [anleft, anBottom];

    Focusable := False;
  end;

  btnHeight := CreateButton(bvlOI, 140, y - 2, 48, '0', @(maindsgn.OnPropPosEdit));
  with btnHeight do
  begin
    Height := 22;
    Anchors := [anright, anBottom];
    Focusable := False;
  end;
  Inc(y, gap + 5);

  l8 := CreateLabel(bvlOI, 5, y + 1, 'Anchors:');
  l8.Anchors := [anLeft, anBottom];

  btnHeight.Left := Width - (btnHeight.Width) - 25;

  x := 64;

  btnAnLeft := CreateButton(bvlOI, x, y - 2, 26, '', nil);
  with btnAnLeft do
  begin
    ImageName := 'vfd.anchorleft';
    ShowImage := True;
      name := 'anchor_left';
    AllowAllUp := True;
    GroupIndex := 1;
    Focusable := False;
    Anchors := [anright, anBottom];
    OnClick := @(maindsgn.OnAnchorChange);
  end;
  btnAnLeft.Left := Width - (btnAnLeft.Width * 4) - 100;

  Inc(x, 30);
  btnAnTop := CreateButton(bvlOI, x, y - 2, 26, '', nil);
  with btnAnTop do
  begin
    ImageName := 'vfd.anchortop';
    ShowImage := True;
    AllowAllUp := True;
      name := 'anchor_top';
    GroupIndex := 2;
    Focusable := False;
    Anchors := [anright, anBottom];
    OnClick := @(maindsgn.OnAnchorChange);
  end;
  btnAnTop.Left := Width - (btnAnTop.Width * 3) - 85;

  Inc(x, 30);
  btnAnBottom := CreateButton(bvlOI, x, y - 2, 26, '', nil);
  with btnAnBottom do
  begin
    ImageName := 'vfd.anchorbottom';
    ShowImage := True;
    AllowAllUp := True;
      name := 'anchor_bottom';
    GroupIndex := 3;
    Focusable := False;
    Anchors := [anBottom, anright];
    OnClick := @(maindsgn.OnAnchorChange);
  end;
  btnAnBottom.Left := Width - (btnAnBottom.Width * 2) - 70;

  Inc(x, 30);
  btnAnRight := CreateButton(bvlOI, x, y - 2, 26, '', nil);
  with btnAnRight do
  begin
    ImageName := 'vfd.anchorright';
    ShowImage := True;
    AllowAllUp := True;
      name := 'anchor_right';
    GroupIndex := 4;
    Focusable := False;
    Anchors := [anBottom, anright];
    OnClick := @(maindsgn.OnAnchorChange);
  end;

  btnAnRight.Left := Width - btnAnRight.Width - 55;

  y := btnAnRight.Bottom + 5;

  l7 := CreateLabel(bvlOI, 5, y, 'Unknown lines:');
  l7.Anchors := [anLeft, anBottom];
  Inc(y, 16);

  edOther := TfpgMemo.Create(bvlOI);
  edOther.BackgroundColor := $EEEEEE;
  edOther.SetPosition(0, y,bvlOI.Width, 78);
  edOther.Anchors := [anLeft, anRight, anBottom];
  edOther.FontDesc := '#Edit2';
  edOther.OnChange := @(maindsgn.OnOtherChange);

  {@VFD_BODY_END: frmProperties}
  {%endregion}

  Bevel1.Align := alTop;
  Splitter1.Align := alTop;
  bvlOI.Align := alClient;
  
   if gINI.ReadBool('frmPropertiesState', 'FirstLoad', True) = False then
  begin
    gINI.ReadFormState(self);
    {$ifdef fpgui-develop}
    UpdatePosition;
    {$else}
    UpdateWindowPosition;
    {$endif}
  end
  else
    gINI.WriteBool('frmPropertiesState', 'FirstLoad', False);
    
end;

procedure TfrmProperties.BeforeDestruction;
begin
  gINI.WriteFormState(self);
  inherited BeforeDestruction;
end;

constructor TfrmProperties.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fpgImages.AddMaskedBMP(
    'vfd.anchorleft', @vfd_anchorleft,
    sizeof(vfd_anchorleft), 0, 0);

  fpgImages.AddMaskedBMP(
    'vfd.anchorright', @vfd_anchorright,
    sizeof(vfd_anchorright), 0, 0);

  fpgImages.AddMaskedBMP(
    'vfd.anchortop', @vfd_anchortop,
    sizeof(vfd_anchortop), 0, 0);

  fpgImages.AddMaskedBMP(
    'vfd.anchorbottom', @vfd_anchorbottom,
    sizeof(vfd_anchorbottom), 0, 0);
end;

procedure TfrmProperties.frmPropertiesPaint(Sender: TObject);
begin
 // edName.Width := Width - l2.Right + 28;
// edName.Width :=  Width - l2.width - 20;

    {$ifdef fpgui-develop}
  edName.UpdatePosition;
 {$else}
  edName.UpdateWindowPosition;
 {$endif}

  if virtualpanel.tag = 1 then
  begin
      frmproperties.lstProps.Height := frmproperties.Height - 310 - TreeView1.height  ;
      frmproperties.virtualpanel.top :=
        frmproperties.lstProps.Height + frmproperties.lstProps.top +1 ;
    
     
  end
  else
  begin
    // frmproperties.lstProps.Height :=   97  - TreeView1.height ;
      frmproperties.lstProps.Height :=   97   ;
      frmproperties.virtualpanel.top :=
        frmproperties.lstProps.Height + frmproperties.lstProps.top - 2;
     end;

  {$ifdef fpgui-develop}
  virtualpanel.UpdatePosition;
  lstProps.UpdatePosition;
 {$else}
  virtualpanel.UpdateWindowPosition;
 lstProps.UpdateWindowPosition;
 {$endif}

end;

procedure TfrmProperties.Vpanelpaint(Sender: TObject);
var
  y, z: integer;
 begin  

  virtualpanel.Canvas.SetColor(clblack);
  virtualpanel.Canvas.DrawText(4, 2, 60, 20, 'Visible');
 // if virtualpanel.tag = 0 then
   // virtualpanel.Canvas.DrawText((virtualpanel.Width div 2) + 4, 2, 60, 20, 'Enabled') else
     virtualpanel.Canvas.DrawText((virtualpanel.Width div 2) + 4, 2, 60, 20, 'ShowHint') ;

 y := 22;
 z := 1 ;
 
  virtualpanel.Canvas.DrawText(4, 2 + y, 60, 20, 'Hint');
  
  inc(z);
  y := 22*z;
  
  virtualpanel.Canvas.DrawText(4, 2 + y, 60, 20, 'Focusable');
    if virtualpanel.tag = 0 then
    virtualpanel.Canvas.DrawText((virtualpanel.Width div 2) + 4, 2 + y, 60, 20, 'Tag')
  else
    virtualpanel.Canvas.DrawText((virtualpanel.Width div 2) + 35, 2 + y, 60, 20, 'Tag');

if virtualpanel.tag = 0 then 
begin
  inc(z);
  y := 22*z;
  virtualpanel.Canvas.DrawText(4, 2 + y, 60, 20, 'FullScreen');
  virtualpanel.Canvas.DrawText((virtualpanel.Width div 2) + 4, 2 + y, 60, 20, 'Sizable');

  inc(z);
  y := 22*z;
  virtualpanel.Canvas.DrawText(4, 2 + y, 60, 20, 'MinWidth');
  virtualpanel.Canvas.DrawText((virtualpanel.Width div 2) + 4, 2 + y, 60, 20, 'MaxWidth');

  inc(z);
  y := 22*z;
  virtualpanel.Canvas.DrawText(4, 2 + y, 60, 20, 'MinHeight');
  virtualpanel.Canvas.DrawText((virtualpanel.Width div 2) + 4, 2 + y, 60, 20, 'MaxHeight');

 inc(z);
  y := 22*z;
  virtualpanel.Canvas.DrawText(4, 2 + y, 60, 20, 'WindowPosition');
end;

  y := 22;
  virtualpanel.Canvas.SetColor(clgray);
  while y < virtualpanel.Height do
  begin
    virtualpanel.Canvas.DrawLine(0, y, virtualpanel.Width, y);
    y := y + 22;
  end;

  virtualpanel.Canvas.DrawLine(0, 0, virtualpanel.Width -1, 0);   //top
  virtualpanel.Canvas.DrawLine(0, virtualpanel.Height, virtualpanel.Width - 1, virtualpanel.Height);  //bottom
  virtualpanel.Canvas.DrawLine(virtualpanel.Width - 1, 0, virtualpanel.Width - 1, virtualpanel.Height);  //right
  virtualpanel.Canvas.DrawLine(0, 0, 0, virtualpanel.Height );   // left

  y := 22;
  z := 1;

  cbvisible.top := 1;
  cbshowhint.top := 1;

   // cbenabled.Visible := false;
    
    cbvisible.Left := (virtualpanel.Width div 4) + 1;
     
    cbvisible.Width := (virtualpanel.Width div 4) - 1;
    cbshowhint.Left := (3 * (virtualpanel.Width div 4)) + 1;
    cbshowhint.Width := (virtualpanel.Width div 4) - 1;
    
    cbshowhint.Visible := true;
    cbvisible.Visible := true;
       
   edhint.top := y +1;
   edhint.left := (virtualpanel.Width div 4) + 1;
   edhint.width := (3 * (virtualpanel.Width div 4)) -1 ;
   edhint.visible := true;
 
   inc(z);
  y := 22*z;
     cbfocusable.top := y + 1;
   cbfocusable.Left := (virtualpanel.Width div 4) + 1;
  cbfocusable.Width := (virtualpanel.Width div 4) - 1;
  cbfocusable.visible := true;
  
  edtag.top := y + 1;
  edtag.Left := (3 * (virtualpanel.Width div 4)) + 1;
  edtag.Width := (virtualpanel.Width div 4) - 1;
 edtag.visible := true;
 
if virtualpanel.tag = 0 then 
begin
    inc(z);
  y := 22*z;
  cbfullscreen.top := y +1;
  cbfullscreen.Left := (virtualpanel.Width div 4) + 1;
  cbfullscreen.Width := (virtualpanel.Width div 4) - 1;

  cbsizeable.top := y + 1;
  cbsizeable.Left := (3 * (virtualpanel.Width div 4)) + 1;
  cbsizeable.Width := (virtualpanel.Width div 4) - 1;

   inc(z);
  y := 22*z;
  edminwidth.top := y + 1;
  edminwidth.Left := (virtualpanel.Width div 4) + 1;
  edminwidth.Width := (virtualpanel.Width div 4) - 1;

  edmaxwidth.top := y + 1;
  edmaxwidth.Left := (3 * (virtualpanel.Width div 4)) + 1;
  edmaxwidth.Width := (virtualpanel.Width div 4) - 1;

   inc(z);
  y := 22*z;
  edminheight.top :=y+ 1;
  edminheight.Left := (virtualpanel.Width div 4) + 1;
  edminheight.Width := (virtualpanel.Width div 4) - 1;

  edmaxheight.top := y + 1;
  edmaxheight.Left := (3 * (virtualpanel.Width div 4)) + 1;
  edmaxheight.Width := (virtualpanel.Width div 4) - 1;

 inc(z);
  y := 22*z;
  cbwindowposition.top := y + 1;
  cbwindowposition.Left := 105;
  cbwindowposition.Width := (virtualpanel.Width) - cbwindowposition.Left - 1;
  cbWindowPosition.visible := true;    
  
     cbsizeable.visible := true;
     cbfullscreen.visible := true;
   //  cbenabled.visible := true;
     edminwidth.visible := true;
     edmaxwidth.visible := true;
     edminheight.visible := true;
     edmaxheight.visible := true;
     cbwindowposition.visible := true;

end;
   {$ifdef fpgui-develop}
   cbsizeable.UpdatePosition;
     cbfocusable.UpdatePosition;
     cbvisible.UpdatePosition;
     cbfullscreen.UpdatePosition;
     cbenabled.UpdatePosition;
     edminwidth.UpdatePosition;
     edmaxwidth.UpdatePosition;
     edminheight.UpdatePosition;
     edmaxheight.UpdatePosition;
     cbwindowposition.UpdatePosition;
     edtag.UpdatePosition;
      edhint.UpdatePosition;
       cbshowhint.UpdatePosition;
 {$else}
  cbsizeable.UpdateWindowPosition;
  cbfocusable.UpdateWindowPosition;
  cbvisible.UpdateWindowPosition;
  cbfullscreen.UpdateWindowPosition;
  cbenabled.UpdateWindowPosition;
  edminwidth.UpdateWindowPosition;
  edmaxwidth.UpdateWindowPosition;
  edminheight.UpdateWindowPosition;
  edmaxheight.UpdateWindowPosition;
  cbwindowposition.UpdateWindowPosition;
  edtag.UpdateWindowPosition;
   edhint.UpdateWindowPosition;
   cbshowhint.UpdateWindowPosition;
 {$endif}

end;

procedure TfrmProperties.UpdateWidgetHierachyTreeview(AMainComp: TComponent; ASelected: TComponent);

  procedure AddAllChildren(APar: TComponent; MainNode: TfpgTreeNode);
  var
    f: integer;
    fcd: TComponent;
    subNode: TfpgTreeNode;
  begin
    fcd := APar;
    for f := 0 to fcd.ComponentCount-1 do
    begin
      if (fcd.Components[f].Name = '') or (fcd.Components[f].ClassName = 'TwgResizer') then
        Continue;
      subNode := mainNode.AppendText(fcd.Components[f].Name + ': ' + fcd.Components[f].ClassName);
      if fcd.Components[f] = ASelected then
        TreeView1.Selection := subNode;
      if fcd.Components[f].ComponentCount > 0 then
        AddAllChildren(fcd.Components[f],subNode);
    end;
  end;

var
  s:string;
begin
  TreeView1.RootNode.Clear;
  if Assigned(AMainComp) then
  begin
    if AMainComp.ClassName = 'TDesignedForm' then
      s := AMainComp.Name + ': ' + 'TfpgForm'
    else
      s := AMainComp.Name + ': ' + AMainComp.ClassName;

    AddAllChildren(AMainComp, TreeView1.RootNode.AppendText(s));
    TreeView1.FullExpand;
  end
  else
    TreeView1.Invalidate;
end;

procedure TfrmProperties.HandleKeyPress(var keycode: word; var shiftstate: TShiftState; var consumed: boolean);
begin
  if keycode = keyF11 then
  begin
    if maindsgn.selectedform <> nil then
    begin
      maindsgn.selectedform.Form.SetFocus;
      maindsgn.selectedform.Form.ActivateWindow;
    end;
    consumed := True;
  end;
  inherited;
end;

procedure TfrmProperties.VirtualPropertiesUpdate(Sender: TObject);
var
  x: integer;
  TheWidget, TheParent: TfpgWidget;
  ok: boolean;
begin
  if lstProps.Props.Widget is TDesignedForm then
  begin

    TheWidget := lstProps.Props.Widget;

    if IsStrANumber(edminwidth.Text) then
      edminwidth.Text := IntToStr(StrToInt(edminwidth.Text))
    else
      edminwidth.Text := '0';
    if IsStrANumber(edmaxwidth.Text) then
      edmaxwidth.Text := IntToStr(StrToInt(edmaxwidth.Text))
    else
      edmaxwidth.Text := '0';
    if IsStrANumber(edminheight.Text) then
      edminheight.Text := IntToStr(StrToInt(edminheight.Text))
    else
      edminheight.Text := '0';
    if IsStrANumber(edmaxheight.Text) then
      edmaxheight.Text := IntToStr(StrToInt(edmaxheight.Text))
    else
      edmaxheight.Text := '0';
    if IsStrANumber(edtag.Text) then
      edtag.Text := IntToStr(StrToInt(edtag.Text))
    else
      edtag.Text := '0';

    ok := False;
    for x := 0 to TDesignedForm(TheWidget).Virtualprop.Count - 1 do
    begin
      if pos(TDesignedForm(TheWidget).Name + '.' + 'siz=', TDesignedForm(TheWidget).Virtualprop[x]) > 0 then
      begin
        TDesignedForm(TheWidget).Virtualprop[x] := TDesignedForm(TheWidget).Name + '.' + 'siz=' + cbsizeable.Text;
        ok := True;
      end;
    end;
    if ok = False then
      TDesignedForm(TheWidget).Virtualprop.Add(TDesignedForm(TheWidget).Name + '.' + 'siz=' + cbsizeable.Text);

    ok := False;
    for x := 0 to TDesignedForm(TheWidget).Virtualprop.Count - 1 do
    begin
      if pos(TDesignedForm(TheWidget).Name + '.' + 'foc=', TDesignedForm(TheWidget).Virtualprop[x]) > 0 then
      begin
        TDesignedForm(TheWidget).Virtualprop[x] := TDesignedForm(TheWidget).Name + '.' + 'foc=' + cbfocusable.Text;
        ok := True;
      end;
    end;
    if ok = False then
      TDesignedForm(TheWidget).Virtualprop.Add(TDesignedForm(TheWidget).Name + '.' + 'foc=' + cbfocusable.Text);

    ok := False;
    for x := 0 to TDesignedForm(TheWidget).Virtualprop.Count - 1 do
    begin
      if pos(TDesignedForm(TheWidget).Name + '.' + 'vis=', TDesignedForm(TheWidget).Virtualprop[x]) > 0 then
      begin
        TDesignedForm(TheWidget).Virtualprop[x] := TDesignedForm(TheWidget).Name + '.' + 'vis=' + cbvisible.Text;
        ok := True;
      end;
    end;
    if ok = False then
      TDesignedForm(TheWidget).Virtualprop.Add(TDesignedForm(TheWidget).Name + '.' + 'vis=' + cbvisible.Text);

    ok := False;
    for x := 0 to TDesignedForm(TheWidget).Virtualprop.Count - 1 do
    begin
      if pos(TDesignedForm(TheWidget).Name + '.' + 'ful=', TDesignedForm(TheWidget).Virtualprop[x]) > 0 then
      begin
        TDesignedForm(TheWidget).Virtualprop[x] := TDesignedForm(TheWidget).Name + '.' + 'ful=' + cbfullscreen.Text;
        ok := True;
      end;
    end;
    if ok = False then
      TDesignedForm(TheWidget).Virtualprop.Add(TDesignedForm(TheWidget).Name + '.' + 'ful=' + cbfullscreen.Text);

    ok := False;
    for x := 0 to TDesignedForm(TheWidget).Virtualprop.Count - 1 do
    begin
      if pos(TDesignedForm(TheWidget).Name + '.' + 'ena=', TDesignedForm(TheWidget).Virtualprop[x]) > 0 then
      begin
        TDesignedForm(TheWidget).Virtualprop[x] := TDesignedForm(TheWidget).Name + '.' + 'ena=' + cbenabled.Text;
        ok := True;
      end;
    end;
    if ok = False then
      TDesignedForm(TheWidget).Virtualprop.Add(TDesignedForm(TheWidget).Name + '.' + 'ena=' + cbenabled.Text);

   ok := False;
    for x := 0 to TDesignedForm(TheWidget).Virtualprop.Count - 1 do
    begin
      if pos(TDesignedForm(TheWidget).Name + '.' + 'shi=', TDesignedForm(TheWidget).Virtualprop[x]) > 0 then
      begin
        TDesignedForm(TheWidget).Virtualprop[x] := TDesignedForm(TheWidget).Name + '.' + 'shi=' + cbshowhint.Text;
        ok := True;
      end;
    end;
    if ok = False then
      TDesignedForm(TheWidget).Virtualprop.Add(TDesignedForm(TheWidget).Name + '.' + 'shi=' + cbshowhint.Text);

    ok := False;
    for x := 0 to TDesignedForm(TheWidget).Virtualprop.Count - 1 do
    begin
      if pos(TDesignedForm(TheWidget).Name + '.' + 'miw=', TDesignedForm(TheWidget).Virtualprop[x]) > 0 then
      begin
        TDesignedForm(TheWidget).Virtualprop[x] := TDesignedForm(TheWidget).Name + '.' + 'miw=' + edminwidth.Text;
        ok := True;
      end;
    end;
    if ok = False then
      TDesignedForm(TheWidget).Virtualprop.Add(TDesignedForm(TheWidget).Name + '.' + 'miw=' + edminwidth.Text);

    ok := False;
    for x := 0 to TDesignedForm(TheWidget).Virtualprop.Count - 1 do
    begin
      if pos(TDesignedForm(TheWidget).Name + '.' + 'maw=', TDesignedForm(TheWidget).Virtualprop[x]) > 0 then
      begin
        TDesignedForm(TheWidget).Virtualprop[x] := TDesignedForm(TheWidget).Name + '.' + 'maw=' + edmaxwidth.Text;
        ok := True;
      end;
    end;
    if ok = False then
      TDesignedForm(TheWidget).Virtualprop.Add(TDesignedForm(TheWidget).Name + '.' + edmaxwidth.Text);

    ok := False;
    for x := 0 to TDesignedForm(TheWidget).Virtualprop.Count - 1 do
    begin
      if pos(TDesignedForm(TheWidget).Name + '.' + 'mih=', TDesignedForm(TheWidget).Virtualprop[x]) > 0 then
      begin
        TDesignedForm(TheWidget).Virtualprop[x] := TDesignedForm(TheWidget).Name + '.' + 'mih=' + edminheight.Text;
        ok := True;
      end;
    end;
    if ok = False then
      TDesignedForm(TheWidget).Virtualprop.Add(TDesignedForm(TheWidget).Name + '.' + 'mih=' + edminheight.Text);

    ok := False;
    for x := 0 to TDesignedForm(TheWidget).Virtualprop.Count - 1 do
    begin
      if pos(TDesignedForm(TheWidget).Name + '.' + 'mah=', TDesignedForm(TheWidget).Virtualprop[x]) > 0 then
      begin
        TDesignedForm(TheWidget).Virtualprop[x] := TDesignedForm(TheWidget).Name + '.' + 'mah=' + edmaxheight.Text;
        ok := True;
      end;
    end;
    if ok = False then
      TDesignedForm(TheWidget).Virtualprop.Add(TDesignedForm(TheWidget).Name + '.' + 'mah=' + edmaxheight.Text);

    ok := False;
    for x := 0 to TDesignedForm(TheWidget).Virtualprop.Count - 1 do
    begin
      if pos(TDesignedForm(TheWidget).Name + '.' + 'wip=', TDesignedForm(TheWidget).Virtualprop[x]) > 0 then
      begin
        TDesignedForm(TheWidget).Virtualprop[x] := TDesignedForm(TheWidget).Name + '.' + 'wip=' + cbWindowPosition.Text;
        ok := True;
      end;
    end;
    if ok = False then
      TDesignedForm(TheWidget).Virtualprop.Add(TDesignedForm(TheWidget).Name + '.' + 'wip=' + cbWindowPosition.Text);

    ok := False;
    for x := 0 to TDesignedForm(TheWidget).Virtualprop.Count - 1 do
    begin
      if pos(TDesignedForm(TheWidget).Name + '.' + 'tag=', TDesignedForm(TheWidget).Virtualprop[x]) > 0 then
      begin
        TDesignedForm(TheWidget).Virtualprop[x] := TDesignedForm(TheWidget).Name + '.' + 'tag=' + edtag.Text;
        ok := True;
      end;
    end;
    if ok = False then
      TDesignedForm(TheWidget).Virtualprop.Add(TDesignedForm(TheWidget).Name + '.' + 'tag=' + edtag.Text);

    ok := False;
    for x := 0 to TDesignedForm(TheWidget).Virtualprop.Count - 1 do
    begin
      if pos(TDesignedForm(TheWidget).Name + '.' + 'hin=', TDesignedForm(TheWidget).Virtualprop[x]) > 0 then
      begin
        TDesignedForm(TheWidget).Virtualprop[x] := TDesignedForm(TheWidget).Name + '.' + 'hin=' + edhint.Text;
        ok := True;
      end;
    end;
    if ok = False then
      TDesignedForm(TheWidget).Virtualprop.Add(TDesignedForm(TheWidget).Name + '.' + 'hin=' + edhint.Text);
  end
  else

  begin
    //////////////// Other  widgets

    TheWidget := lstProps.Props.Widget;

    {
    TheParent := TheWidget;
    if TheParent.HasParent = True then
      TheParent := TheParent.Parent;
    }
    TheParent := WidgetParentForm(TfpgWidget(TheWidget));

    ok := False;
    for x := 0 to TDesignedForm(TheParent).Virtualprop.Count - 1 do
    begin
      if pos(TDesignedForm(TheParent).Name + '.' + TheWidget.Name + '.' + 'vis=', TDesignedForm(TheParent).Virtualprop[x]) > 0 then
      begin
        ok := True;
        TDesignedForm(TheParent).Virtualprop[x] := TDesignedForm(TheParent).Name + '.' + TheWidget.Name + '.' + 'vis=' + cbvisible.Text;
      end;
    end;
    if ok = False then
      TDesignedForm(TheParent).Virtualprop.Add(TDesignedForm(TheParent).Name + '.' + TheWidget.Name + '.' + 'vis=' + cbvisible.Text);

 ok := False;
    for x := 0 to TDesignedForm(TheParent).Virtualprop.Count - 1 do
    begin
      if pos(TDesignedForm(TheParent).Name + '.' + TheWidget.Name + '.' + 'shi=', TDesignedForm(TheParent).Virtualprop[x]) > 0 then
      begin
        ok := True;
        TDesignedForm(TheParent).Virtualprop[x] := TDesignedForm(TheParent).Name + '.' + TheWidget.Name + '.' + 'shi=' + cbshowhint.Text;
      end;
    end;
    if ok = False then
      TDesignedForm(TheParent).Virtualprop.Add(TDesignedForm(TheParent).Name + '.' +
       TheWidget.Name + '.' + 'shi=' + cbshowhint.Text);
 
 ok := False;
 
    for x := 0 to TDesignedForm(TheParent).Virtualprop.Count - 1 do
    begin
      if pos(TDesignedForm(TheParent).Name + '.' + TheWidget.Name + '.' + 'hin=', TDesignedForm(TheParent).Virtualprop[x]) > 0 then
      begin
        ok := True;
        TDesignedForm(TheParent).Virtualprop[x] := TDesignedForm(TheParent).Name + '.' + TheWidget.Name + '.' + 'hin=' + edhint.Text;
      end;
    end;
    if ok = False then
      TDesignedForm(TheParent).Virtualprop.Add(TDesignedForm(TheParent).Name + '.' + TheWidget.Name + '.' + 'hin=' + edhint.Text);

    ok := False;
    for x := 0 to TDesignedForm(TheParent).Virtualprop.Count - 1 do
    begin
      if pos(TDesignedForm(TheParent).Name + '.' + TheWidget.Name + '.' + 'tag=', TDesignedForm(TheParent).Virtualprop[x]) > 0 then
      begin
        ok := True;
        TDesignedForm(TheParent).Virtualprop[x] := TDesignedForm(TheParent).Name + '.' + TheWidget.Name + '.' + 'tag=' + edtag.Text;
      end;
    end;
    if ok = False then
      TDesignedForm(TheParent).Virtualprop.Add(TDesignedForm(TheParent).Name + '.' + TheWidget.Name + '.' + 'tag=' + edtag.Text);

    ok := False;
    for x := 0 to TDesignedForm(TheParent).Virtualprop.Count - 1 do
    begin 
      if pos(TDesignedForm(TheParent).Name + '.' + TheWidget.Name + '.' + 'foc=', TDesignedForm(TheParent).Virtualprop[x]) > 0 then
      begin
        ok := True;
        TDesignedForm(TheParent).Virtualprop[x] := TDesignedForm(TheParent).Name + '.' + TheWidget.Name + '.' + 'foc=' + cbfocusable.Text;
      end;
    end;
    if ok = False then
      TDesignedForm(TheParent).Virtualprop.Add(TDesignedForm(TheParent).Name + '.' + TheWidget.Name + '.' + 'foc=' + cbfocusable.Text);

  end;

end;


{ TPropertyList }

procedure TPropertyList.AddItem(aProp: TVFDWidgetProperty);
begin
  FList.Add(aProp);

end;

procedure TPropertyList.Clear;
begin
  FList.Clear;
  Widget := nil;
end;

constructor TPropertyList.Create;
begin
  FList := TList.Create;
  Widget := nil;
end;

destructor TPropertyList.Destroy;
begin
  Clear;
  FList.Free;
  inherited;
end;

function TPropertyList.GetCount: integer;
begin
  Result := FList.Count;
end;

function TPropertyList.GetItem(index: integer): TVFDWidgetProperty;
begin
  if (index < 0) or (index > Count - 1) then
    Result := nil
  else
    Result := TVFDWidgetProperty(FList[index]);
end;

{ TwgPropertyList }

constructor TwgPropertyList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  NameWidth := 80;
  editor := nil;
  OnChange := @OnRowChange;
  OnScroll := @OnScrolling;
  BackgroundColor := clWindowBackground;
  NameDrag := False;
  //FontName := 'arial-10:antialias=false';
end;

procedure TwgPropertyList.OnRowChange(Sender: TObject);
begin
  AllocateEditor;
end;

procedure TwgPropertyList.OnScrolling(Sender: TObject);
begin
  AllocateEditor;
end;

procedure TwgPropertyList.DrawItem(num: integer; rect: TfpgRect; flags: integer);
var
  x, y, fy: integer;
  s: string;
  prop: TVFDWidgetProperty;
  r: TfpgRect;
begin
  prop := Props.GetItem(num);
  if prop = nil then
    Exit; //==>

  x := rect.left;
  y := rect.top;
  fy := y + rect.Height div 2 - FFont.Height div 2;

  s := prop.Name;
  Canvas.DrawString(x + 1, fy, s);

  Inc(x, NameWidth);
  Canvas.SetColor(clShadow1);
  Canvas.DrawLine(x, rect.top, x, rect.bottom);
  Inc(x);
  // Drawing the contents
  r.SetRect(x, y, rect.right - x, rect.Height);
  Canvas.SetColor(BackgroundColor);
  Canvas.FillRectangle(r);
  Canvas.SetTextColor(clText1);
  Inc(r.left, 2);
  Dec(r.Width, 2);
  prop.DrawValue(props.Widget, Canvas, r, flags);

  Canvas.SetColor(clShadow1);
  Canvas.DrawLine(0, rect.bottom, rect.right, rect.bottom);
end;

function TwgPropertyList.ItemCount: integer;
begin
  Result := Props.Count;
end;

function TwgPropertyList.RowHeight: integer;
begin
  Result := 23;
end;

procedure TwgPropertyList.OnUpdateProperty(Sender: TObject);
begin
  editor.StoreValue(props.Widget);
end;

procedure TwgPropertyList.HandleMouseMove(x, y: integer; btnstate: word; shiftstate: TShiftState);
begin
  if not NameDrag then
  begin
    if (x >= FMargin + NameWidth - 2) and (x <= FMargin + NameWidth + 2) then
      MouseCursor := mcSizeEW
    else
      MouseCursor := mcDefault;
  end
  else
  begin
    NameWidth := x - FMargin;
    ReAlignEditor;
    RePaint;
  end;
  inherited;
end;

procedure TwgPropertyList.HandleLMouseDown(x, y: integer; shiftstate: TShiftState);
begin
  if MouseCursor = mcSizeEW then
    NameDrag := True
  //NameDragPos := x;
  else
    inherited;
end;

procedure TwgPropertyList.HandleLMouseUp(x, y: integer; shiftstate: TShiftState);
begin
  if NameDrag then
    NameDrag := False
  else
    inherited;
  if (Editor <> nil) and (Editor.Visible) then
    Editor.SetFocus;
end;

procedure TwgPropertyList.HandleMouseScroll(x, y: integer; shiftstate: TShiftState; delta: smallint);
begin
  inherited HandleMouseScroll(x, y, shiftstate, delta);
  AllocateEditor;
end;

procedure TwgPropertyList.HandleSetFocus;
begin
  inherited HandleSetFocus;
  if Editor <> nil then
    Editor.Visible := True
  else
    AllocateEditor;
end;

procedure TwgPropertyList.HandleKillFocus;
begin
  inherited HandleKillFocus;
  if Editor <> nil then
    Editor.Visible := True;
end;

procedure TwgPropertyList.RealignEditor;
var
  x: integer;
begin
  if editor = nil then
    Exit;
  x := 3 + NameWidth;
  editor.SetPosition(x, editor.Top, Width - ScrollBarWidth - x, editor.Height);
end;

{$ifdef fpgui-develop}
type
  TDragHack = class(TfpgDrag);
  TWidgetHack = class(TfpgWidget);


procedure TfrmMainDesigner.OnPaletteDragStart(Sender: TObject);
var
  Drag: TfpgDrag;
  Preview: TfpgWindow;
  Button: TwgPaletteButton absolute Sender;
  Widget: TfpgWidget;
begin
  Drag := TfpgDrag.Create(Sender as TfpgWidget);
  Preview := TDragHack(Drag).FPreviewWin as TfpgWindow;
  Widget := Button.VFDWidget.CreateWidget(Preview);
  // set the position of the preview window
  TWidgetHack(Button).FDragStartPos := fpgPoint(0,0);
  Drag.MimeData := TfpgMimeData.Create;
  Drag.MimeData.Obj[MIME_VFD_WIDGET_CLASS] := Button.VFDWidget;
  Drag.PreviewSize := fpgSize(Widget.Width,Widget.Height);
  Drag.OnPaintPreview:=@PaintPaletteButtonForDrag;

  Drag.Execute();

  SelectedWidget := nil;
end;

procedure TfrmMainDesigner.PaintPaletteButtonForDrag(ASender: TfpgDrag; ACanvas: TfpgCanvas);
begin
  // Do Nothing, the widget paints itself
end;
{$else}
{$endif}

procedure TfrmMainDesigner.PaletteBarResized(Sender: TObject);
var
  btn: TwgPaletteButton;
  x, y, n: integer;
begin
  x := 0;
  y := 0;
  wgpalette.Width := Width - 200;
  for n := 0 to wgPalette.ComponentCount - 1 do
  begin
    btn := wgPalette.Components[n] as TwgPaletteButton;
    btn.SetPosition(x, y, 30, 28);
    btn.ImageMargin := -1;
    btn.ImageSpacing := 0;
    Inc(x, 32);
    if (x + 30) >= wgpalette.Width then
    begin
      x := 0;
      Inc(y, 30);
    end;
  end;

end;

procedure TfrmMainDesigner.OnStyleChange(Sender: TObject);
var
  x: integer;
begin
  if Sender is TfpgMenuItem then
  begin
    if fpgstyleManager.setstyle(TfpgMenuItem(Sender).Text) then
    begin

      for x := 0 to numstyle - 1 do
        previewmenu.MenuItem(x).Checked := False;

      TfpgMenuItem(Sender).Checked := True;
      fpgstyle := fpgstyleManager.Style;

      hide;
     Show;

     if length(ArrayFormDesign) > 2 then
      for x := 2 to 11 do
        if windowmenu.MenuItem(x).Visible = True then
        begin
          ArrayFormDesign[x - 2].Form.hide;
          ArrayFormDesign[x - 2].Form.Show;
        end;
      if frmProperties.Visible = True then
      begin
        frmProperties.hide;
        fpgapplication.ProcessMessages;
        frmProperties.Show;
      end;

    end;
  end;
end;

procedure TfrmMainDesigner.BuildThemePreviewMenu;
var
  sl: TStringList;
  i: integer;
begin
  sl := TStringList.Create;
  fpgStyleManager.AssignStyleTypes(sl);
  sl.Sort;
  numstyle := sl.Count - 1;
  for i := 0 to sl.Count - 1 do
  begin
    if sl[i] = 'auto' then
      continue;
    previewmenu.AddMenuItem(sl[i], '', @OnStyleChange).Enabled := True;

  end;

  for i := 0 to numstyle - 1 do
    if previewmenu.MenuItem(i).Text = 'Chrome silver flat menu' then
      previewmenu.MenuItem(i).Checked := True;

  sl.Free;

end;

procedure TfrmMainDesigner.miHelpAboutClick(Sender: TObject);
begin
  TfrmAbout.Execute;
end;

procedure TfrmMainDesigner.miHelpAboutGUI(Sender: TObject);
begin
  TfpgMessageDialog.AboutFPGui;
end;

procedure TfrmMainDesigner.micolorwheel(Sender: TObject);
var
  frm: TColorPickerForm;
begin
//  frm := TColorPickerForm.Create(nil);
     fpgApplication.CreateForm(TColorPickerForm, frm);
  frm.Show;
end;

procedure TfrmMainDesigner.miimageconv(Sender: TObject);
var
  frm: TImageConvert;
begin
 // frm := TImageConvert.Create(nil);
   fpgApplication.CreateForm(TImageConvert, frm);
  frm.Show;
end;

procedure TfrmMainDesigner.miMRUClick(Sender: TObject; const FileName: string);
begin
  maindsgn.EditedFileName := FileName;
  maindsgn.OnLoadFile(maindsgn);
end;

function TfrmMainDesigner.GetSelectedWidget: TVFDWidgetClass;
begin
  if chlPalette.FocusItem > -1 then
    Result := TVFDWidgetClass(chlPalette.Items.Objects[chlPalette.FocusItem])
  else begin
    chlPalette.Text:='';
    Result := nil;
  end;
end;

procedure TfrmMainDesigner.SetSelectedWidget(wgc: TVFDWidgetClass);
var
  n: integer;
begin
  if wgc = nil then
  begin
    chlPalette.FocusItem := 0;
    for n := 0 to wgpalette.ComponentCount - 1 do
      if wgpalette.Components[n] is TwgPaletteButton then
        TwgPaletteButton(wgpalette.Components[n]).Down := False;
  end;
end;

procedure TwgPropertyList.ReleaseEditor;
begin
  self.ActiveWidget := nil;
  if editor <> nil then
    editor.Free;
  editor := nil;
end;

procedure TwgPropertyList.AllocateEditor;
var
  x, y: integer;
  prop: TVFDWidgetProperty;
begin
  prop := Props.GetItem(FFocusItem);
  if prop = nil then
    Exit;

  self.ActiveWidget := nil;
  if editor <> nil then
    editor.Free;

  editor := prop.CreateEditor(Self);
  x := 3 + NameWidth;
  y := FMargin + ((FFocusItem - FFirstItem) * RowHeight);
  editor.SetPosition(x, y, Width - FMargin - ScrollBarWidth - x, RowHeight - 1); // last -1 is so cell border lines are still visible
  editor.CreateLayout;
  editor.OnUpdate := @OnUpdateProperty;
  editor.LoadValue(Props.Widget);
  editor.Visible := True;

  self.ActiveWidget := editor;
end;

{ TwgPalette }

procedure TwgPalette.HandlePaint;
begin
  Canvas.Clear(clWindowBackground);
end;

end.
