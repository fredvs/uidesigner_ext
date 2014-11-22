{
This is the extended version of fpGUI uidesigner => Designer_ext.
With window list, undo feature, integration into IDE, editor launcher, extra-properties editor,...

Fred van Stappen
fiens@hotmail.com
2013 - 2014
}
{
    fpGUI  -  Free Pascal GUI Toolkit

    Copyright (C) 2006 - 2013 See the file AUTHORS.txt, included in this
    distribution, for details of the copyright.

    See the file COPYING.modifiedLGPL, included in this distribution,
    for details about redistributing fpGUI.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    Description:
      Main window functionality and designer class.
}

unit vfd_main;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  Process,
  SysUtils,
  fpg_dialogs,
  fpg_base,
  fpg_main,
  fpg_label,
  fpg_button,
  fpg_editbtn,
  fpg_radiobutton,
  fpg_edit,
  fpg_listbox,
  fpg_panel,
  fpg_grid,
  fpg_progressbar,
  fpg_trackbar,
  fpg_tab,
  fpg_listview,
  fpg_tree,
  fpg_splitter,
  fpg_hyperlink,
  fpg_toggle,
  fpg_memo,
  fpg_gauge,
  fpg_combobox,
  fpg_checkbox,
  fpg_colorwheel,
  fpg_nicegrid,
  u_editgrid,
  fpg_menu,
  fpg_popupcalendar,
  fpg_constants,
  vfd_props,
  frm_vfdforms,
  fpg_widget,
  vfd_designer,
  vfd_file,
  frm_multiselect,
  frm_main_designer;

const
  program_version = FPGUI_VERSION;

var
  s, p: string;
  isfileloaded: boolean = False;

type
  TProc = procedure(Sender: TObject) of object;

type
  TUndo = record
    FileName: string;
    ActiveForm: string;
    Comment: string;
  end;

type

  TMainDesigner = class(TObject)
  private
    FShowGrid: boolean;
    procedure SetEditedFileName(const Value: string);
    procedure LoadDefaults;
    procedure SetShowGrid(AValue: boolean);
  protected
    FDesigners: TList;
    FFile: TVFDFile;
    FEditedFileName: string;
  public
    ifundo: boolean;
    GridResolution: integer;
    SaveComponentNames: boolean;
    selectedform: TFormDesigner;
    constructor Create;
    destructor Destroy; override;
    procedure CreateWindows;
    procedure SelectForm(aform: TFormDesigner);
    function Designer(index: integer): TFormDesigner;
    function DesignerCount: integer;
    function NewFormName: string;
    function CreateParseForm(const FormName, FormHead, FormBody: string): TFormDesigner;
    procedure SaveUndo(Sender: TObject; typeundo: integer);
    procedure LoadUndo(undoindex: integer);
    function AddUnits(filedata: string): string;
    procedure OnNewForm(Sender: TObject);
    procedure OnNewFile(Sender: TObject);
    procedure OnSaveFile(Sender: TObject);
    procedure OnLoadFile(Sender: TObject);
    procedure OnPropTextChange(Sender: TObject);
    procedure OnPropNameChange(Sender: TObject);
    procedure OnPropPosEdit(Sender: TObject);
    procedure OnOtherChange(Sender: TObject);
    procedure OnAnchorChange(Sender: TObject);
    procedure OnEditWidget(Sender: TObject);
    procedure OnEditWidgetOrder(Sender: TObject);
    procedure OnEditTabOrder(Sender: TObject);
    procedure OnExit(Sender: TObject);
    procedure OnOptionsClick(Sender: TObject);
    property EditedFileName: string read FEditedFileName write SetEditedFileName;
    property ShowGrid: boolean read FShowGrid write SetShowGrid;
  end;

var
  maindsgn: TMainDesigner;
  ArrayFormDesign: array of TFormDesigner;
  ArrayUndo: array of TUndo;
  dob: string;
  isfpguifile: boolean = False;

implementation

uses
  fpg_iniutils,
  fpg_utils,
  vfd_constants,
  vfd_formparser;

var
  DefaultPasExt: string = '.pas';
  OneClickMove: boolean;

{ TMainDesigner }

procedure TMainDesigner.OnNewFile(Sender: TObject);
var
  n: integer;
begin
  ifundo := False;
  EditedFileName := '';
  isfileloaded := False;
  fpgapplication.ProcessMessages;

  isfpguifile := False;
  frmProperties.Hide;
  frmmultiselect.Hide;
  frmmultiselect.ClearAll;
  // sleep(200);
  // fpgapplication.ProcessMessages;

  for n := 0 to FDesigners.Count - 1 do
  begin
    TFormDesigner(FDesigners[n]).DeSelectAll;
    TFormDesigner(FDesigners[n]).Free;
  end;
  FDesigners.Clear;

  frmproperties.edName.Text := '';

  frmMainDesigner.WindowTitle := 'fpGUI Designer_ext v' + ext_version;

  if frmMainDesigner.btnToFront.Tag = 1 then
    frmMainDesigner.MainMenu.MenuItem(6).Text :=
      'fpGUI Designer_ext v' + ext_version;

  frmMainDesigner.windowmenu.MenuItem(0).Visible := False;
  frmMainDesigner.windowmenu.MenuItem(1).Visible := False;
  for n := 0 to 9 do
  begin
    frmMainDesigner.windowmenu.MenuItem(n + 2).Visible := False;
    frmMainDesigner.windowmenu.MenuItem(n + 2).Text := '';
  end;

  for n := 0 to 99 do
  begin
    frmMainDesigner.listundomenu.MenuItem(n).Visible := False;
    frmMainDesigner.listundomenu.MenuItem(n).Text := '';
  end;

  if Length(ArrayUndo) > 0 then
  begin
    for n := 0 to length(ArrayUndo) - 1 do
      deletefile(ArrayUndo[n].FileName);
  end;

  indexundo := 0;
  SetLength(ArrayFormDesign, 0);
  SetLength(ArrayUndo, 0);

  ifundo := False;

  frmMainDesigner.undomenu.MenuItem(0).Enabled := False;
  frmMainDesigner.undomenu.MenuItem(1).Enabled := False;
  frmMainDesigner.undomenu.MenuItem(3).Enabled := False;

  isfpguifile := True;
  frmMainDesigner.windowmenu.MenuItem(0).Visible := True;
  frmMainDesigner.windowmenu.MenuItem(1).Visible := True;

  isfileloaded := True;

  OnNewForm(Sender);

  frmProperties.Show;
end;


procedure TMainDesigner.OnLoadFile(Sender: TObject);
var
  n, m, x: integer;
  bl, bl2: TVFDFileBlock;
  fname: string;
  afiledialog: TfpgFileDialog;
begin
  isfileloaded := False;
  fpgapplication.ProcessMessages;

  isfpguifile := False;
  frmProperties.Hide;
  frmmultiselect.Hide;
  frmmultiselect.ClearAll;

  for n := 0 to FDesigners.Count - 1 do
  begin
    TFormDesigner(FDesigners[n]).DeSelectAll;
    TFormDesigner(FDesigners[n]).Free;
  end;
  FDesigners.Clear;

  frmproperties.edName.Text := '';

  frmMainDesigner.WindowTitle := 'fpGUI Designer_ext v' + ext_version + ' => no fpGUI form-file';

  if frmMainDesigner.btnToFront.Tag = 1 then
    frmMainDesigner.MainMenu.MenuItem(6).Text :=
      'fpGUI Designer_ext v' + ext_version + ' => no fpGUI form-file';

  frmMainDesigner.windowmenu.MenuItem(0).Visible := False;
  frmMainDesigner.windowmenu.MenuItem(1).Visible := False;
  for n := 0 to 9 do
  begin
    frmMainDesigner.windowmenu.MenuItem(n + 2).Visible := False;
    frmMainDesigner.windowmenu.MenuItem(n + 2).Text := '';
  end;

  for n := 0 to 99 do
  begin
    frmMainDesigner.listundomenu.MenuItem(n).Visible := False;
    frmMainDesigner.listundomenu.MenuItem(n).Text := '';
  end;

  if Length(ArrayUndo) > 0 then
  begin
    for n := 0 to length(ArrayUndo) - 1 do
      deletefile(ArrayUndo[n].FileName);
  end;

  indexundo := 0;
  SetLength(ArrayFormDesign, 0);
  SetLength(ArrayUndo, 0);
  x := 0;

  fname := EditedFileName;
  ifundo := False;

  if Sender <> maindsgn then
  begin
    afiledialog := TfpgFileDialog.Create(nil);
    afiledialog.Filename := EditedFilename;
    afiledialog.WindowTitle := 'Open form file';
    afiledialog.Filter :=
      'Pascal source files (*.pp;*.pas;*.inc;*.dpr;*.lpr)|*.pp;*.pas;*.inc;*.dpr;*.lpr|All Files (*)|*';
    if afiledialog.RunOpenFile then
    begin
      EditedFileName := aFileDialog.Filename;
      fname := EditedFilename;
    end
    else
      fname := '';
    FreeAndNil(aFileDialog);
  end;

  if fname = '' then
  begin
    if gINI.ReadInteger('Options', 'IDE', 0) > 0 then
    begin
      frmMainDesigner.Hide;
      frmProperties.Hide;
    end;
    Exit;
  end;

  if not fpgFileExists(fname) then
  begin
    //  ShowMessage('File does not exists.', 'Error loading form');
    if gINI.ReadInteger('Options', 'IDE', 0) > 0 then
    begin
      frmMainDesigner.Hide;
      frmProperties.Hide;
    end;
    Exit;
  end;

  if FFile.LoadFile(fname) = False then
  begin
    if gINI.ReadInteger('Options', 'IDE', 0) > 0 then
    begin
      frmMainDesigner.Hide;
      frmProperties.Hide;
    end;
    Exit;
  end;

  if FFile.GetBlocks = 0 then
  begin
    if gINI.ReadInteger('Options', 'IDE', 0) > 0 then
    begin
      frmMainDesigner.Hide;
      frmProperties.Hide;
    end;
    Exit;
  end
  else
  begin
    frmMainDesigner.WindowTitle := 'fpGUI Designer_ext v' + ext_version + ' - ' + fname;

    if frmMainDesigner.btnToFront.Tag = 1 then
      frmMainDesigner.MainMenu.MenuItem(6).Text :=
        'Current file : ' + fname + '     fpGUI Designer_ext v' + ext_version;

    if gINI.ReadInteger('Options', 'IDE', 0) > 0 then
    begin
      frmMainDesigner.Show;
    end;
  end;

  // sleep(200);
  // fpgapplication.ProcessMessages;

  for n := 0 to FFile.BlockCount - 1 do
  begin
    bl := FFile.Block(n);
    if bl.BlockID = 'VFD_HEAD_BEGIN' then
      for m := n + 1 to FFile.BlockCount - 1 do
      begin
        bl2 := FFile.Block(m);
        if (bl2.BlockID = 'VFD_BODY_BEGIN') and (bl2.FormName = bl.FormName) then
        begin
          if x < 10 then

          begin
            SetLength(ArrayFormDesign, x + 1);
            ArrayFormDesign[x] := CreateParseForm(bl.FormName, bl.Data, bl2.Data);
            // pair was found
          end
          else
            CreateParseForm(bl.FormName, bl.Data, bl2.Data);

          frmMainDesigner.windowmenu.MenuItem(1).Visible := True;
          if x < 10 then
          begin
            frmMainDesigner.windowmenu.MenuItem(x + 2).Visible := True;
            frmMainDesigner.windowmenu.MenuItem(x + 2).Text := bl.FormName;
          end;
          // fnametemp := bl.FormName ;
          Inc(x);
        end;
      end;
  end;

  // sleep(200);
  // fpgapplication.ProcessMessages;

  for n := 0 to FDesigners.Count - 1 do
  begin
    selectedform := nil;
    TFormDesigner(FDesigners[n]).Form.ShowGrid := FShowGrid;
  end;

  frmMainDesigner.mru.AddItem(fname);

  frmMainDesigner.undomenu.MenuItem(0).Enabled := False;
  frmMainDesigner.undomenu.MenuItem(1).Enabled := False;
  frmMainDesigner.undomenu.MenuItem(3).Enabled := False;

  isfpguifile := True;
  frmMainDesigner.windowmenu.MenuItem(0).Visible := True;
  frmMainDesigner.windowmenu.MenuItem(1).Visible := True;

  isfileloaded := True;

  frmProperties.Show;

end;

function TMainDesigner.AddUnits(filedata: string): string;
var
  n, n2: integer;
  funit, fdata1, fdata2, fdata3, fdata31, fdata32, fdata4, datatmp: string;
  cns_label, cns_edit, cns_combobox, cns_checkbox, cns_gauge, cns_button, cns_radiobutton, cns_listbox, cns_panel,
  cns_memo, cns_menu, cns_calendar, cns_grid, cns_progressbar, cns_trackbar, cns_listview, cns_tree, cns_tab,
  cns_editbtn, cns_colorwheel, cns_splitter, cns_hyperlink, cns_toggle, cns_nicegrid, cns_editgrid: boolean;
begin

  /// search for uses section
  if (pos(LineEnding + 'USES' + LineEnding, uppercase(filedata)) > 0) then
    datatmp := LineEnding + 'USES' + LineEnding
  else
  if (pos(LineEnding + 'USES ', uppercase(filedata)) > 0) then
    datatmp := LineEnding + 'USES '
  else
  if (pos(' USES' + LineEnding, uppercase(filedata)) > 0) then
    datatmp := ' USES' + LineEnding
  else
  if (pos(' USES ', uppercase(filedata)) > 0) /// TODO => check if not inside comment {...}
  then
    datatmp := ' USES '
  else
    datatmp := '';

  if datatmp <> '' then
  begin
    fdata1 := copy(filedata, 1, pos(datatmp, uppercase(filedata)) + 4); /// all before "uses"
    fdata2 := copy(filedata, pos(datatmp, uppercase(filedata)) + 5, length(filedata) - pos(datatmp, uppercase(filedata))); /// all after "uses"
    fdata3 := copy(fdata2, 1, pos(';', fdata2));  /// only "uses" section
    fdata4 := copy(fdata2, pos(';', fdata2) + 1, length(fdata2) - pos(';', fdata2));  // all after "uses" section

    datatmp := '{%units ''Auto-generated GUI code''}';

    if pos(datatmp, fdata3) > 0 then
    begin
      fdata31 := copy(fdata3, 1, pos(datatmp, fdata3) - 1);   /// all units before auto-generated
    end;

    fdata2 := LineEnding + datatmp + LineEnding;

    datatmp := '{%endunits}';

    if pos(datatmp, fdata3) > 0 then /// all units after auto-generated
    begin
      fdata32 := copy(fdata3, pos(datatmp, fdata3) + length(datatmp) + 1, pos(';', fdata3) - pos(datatmp, fdata3) - length(datatmp) + 1);
      fdata3 := fdata31 + fdata32;
    end;

    datatmp := LineEnding + datatmp;

    /// looking for existing declared units
    if pos('FPG_LABEL', uppercase(fdata3)) > 0 then
      cns_label := True
    else
      cns_label := False;

    if pos('FPG_BUTTON', uppercase(fdata3)) > 0 then
      cns_button := True
    else
      cns_button := False;

    if pos('FPG_RADIOBUTTON', uppercase(fdata3)) > 0 then
      cns_radiobutton := True
    else
      cns_radiobutton := False;

    if pos('FPG_EDIT', uppercase(fdata3)) > 0 then
      cns_edit := True
    else
      cns_edit := False;

    if pos('FPG_CHECKBOX', uppercase(fdata3)) > 0 then
      cns_checkbox := True
    else
      cns_checkbox := False;

    if pos('FPG_COMBOBOX', uppercase(fdata3)) > 0 then
      cns_combobox := True
    else
      cns_combobox := False;

    if pos('FPG_GAUGE', uppercase(fdata3)) > 0 then
      cns_gauge := True
    else
      cns_gauge := False;

    if pos('FPG_LISTBOX', uppercase(fdata3)) > 0 then
      cns_listbox := True
    else
      cns_listbox := False;

    if pos('FPG_MEMO', uppercase(fdata3)) > 0 then
      cns_memo := True
    else
      cns_memo := False;

    if pos('FPG_MENU', uppercase(fdata3)) > 0 then
      cns_menu := True
    else
      cns_menu := False;

    if pos('FPG_PANEL', uppercase(fdata3)) > 0 then
      cns_panel := True
    else
      cns_panel := False;

    if pos('FPG_POPUPCALENDAR', uppercase(fdata3)) > 0 then
      cns_calendar := True
    else
      cns_calendar := False;

    if pos('FPG_GRID', uppercase(fdata3)) > 0 then
      cns_grid := True
    else
      cns_grid := False;

    if pos('FPG_PROGRESSBAR', uppercase(fdata3)) > 0 then
      cns_progressbar := True
    else
      cns_progressbar := False;

    if pos('FPG_TRACKBAR', uppercase(fdata3)) > 0 then
      cns_trackbar := True
    else
      cns_trackbar := False;

    if pos('FPG_LISTVIEW', uppercase(fdata3)) > 0 then
      cns_listview := True
    else
      cns_listview := False;

    if pos('FPG_TREE', uppercase(fdata3)) > 0 then
      cns_tree := True
    else
      cns_tree := False;

    if pos('FPG_TAB', uppercase(fdata3)) > 0 then
      cns_tab := True
    else
      cns_tab := False;

    if pos('FPG_EDITBTN', uppercase(fdata3)) > 0 then
      cns_editbtn := True
    else
      cns_editbtn := False;

    if pos('FPG_COLORWHEEL', uppercase(fdata3)) > 0 then
      cns_colorwheel := True
    else
      cns_colorwheel := False;

    if pos('FPG_SPLITTER', uppercase(fdata3)) > 0 then
      cns_splitter := True
    else
      cns_splitter := False;

    if pos('FPG_TOGGLE', uppercase(fdata3)) > 0 then
      cns_toggle := True
    else
      cns_toggle := False;

    if pos('FPG_HYPERLINK', uppercase(fdata3)) > 0 then
      cns_hyperlink := True
    else
      cns_hyperlink := False;

    if pos('FPG_NICEGRID', uppercase(fdata3)) > 0 then
      cns_nicegrid := True
    else
      cns_nicegrid := False;

    if pos('U_EDITGRID', uppercase(fdata3)) > 0 then
      cns_editgrid := True
    else
      cns_editgrid := False;

    funit := '';

    for n := 0 to FDesigners.Count - 1 do
    begin
      for n2 := 0 to TFormDesigner(FDesigners[n]).Form.ComponentCount - 1 do
      begin
        if (TFormDesigner(FDesigners[n]).Form.Components[n2] is Tfpglabel) and (cns_label = False) then
        begin
          funit := funit + ' fpg_label,';
          cns_label := True;
        end
        else
        if (TFormDesigner(FDesigners[n]).Form.Components[n2] is TfpgButton) and (cns_button = False) then
        begin
          funit := funit + ' fpg_button,';
          cns_button := True;
        end
        else
        if (TFormDesigner(FDesigners[n]).Form.Components[n2] is TfpgRadioButton) and (cns_radiobutton = False) then
        begin
          funit := funit + ' fpg_radiobutton,';
          cns_radiobutton := True;
        end
        else
        if (TFormDesigner(FDesigners[n]).Form.Components[n2] is TfpgComboBox) and (cns_combobox = False) then
        begin
          funit := funit + ' fpg_combobox,';
          cns_combobox := True;
        end
        else
        if ((TFormDesigner(FDesigners[n]).Form.Components[n2] is Tfpgedit) or (TFormDesigner(FDesigners[n]).Form.Components[n2] is
          TfpgEditInteger) or (TFormDesigner(FDesigners[n]).Form.Components[n2] is TfpgEditFloat) or
          (TFormDesigner(FDesigners[n]).Form.Components[n2] is TfpgEditCurrency)) and (cns_edit = False) then
        begin
          funit := funit + ' fpg_edit,';
          cns_edit := True;
        end
        else
        if ((TFormDesigner(FDesigners[n]).Form.Components[n2] is TfpgFileNameEdit) or
          (TFormDesigner(FDesigners[n]).Form.Components[n2] is TfpgDirectoryEdit) or
          (TFormDesigner(FDesigners[n]).Form.Components[n2] is TfpgFontEdit) or
          (TFormDesigner(FDesigners[n]).Form.Components[n2] is TfpgEditButton))
          and (cns_editbtn = False) then
        begin
          funit := funit + ' fpg_editbtn,';
          cns_editbtn := True;
        end
        else
        if (TFormDesigner(FDesigners[n]).Form.Components[n2] is Tfpgcheckbox) and (cns_checkbox = False) then
        begin
          funit := funit + ' fpg_checkbox,';
          cns_checkbox := True;
        end
        else
        if ((TFormDesigner(FDesigners[n]).Form.Components[n2] is TfpgColorWheel) or
          (TFormDesigner(FDesigners[n]).Form.Components[n2] is TfpgValueBar)) and (cns_colorwheel = False) then
        begin
          funit := funit + ' fpg_colorwheel,';
          cns_colorwheel := True;
        end
        else
        if (TFormDesigner(FDesigners[n]).Form.Components[n2] is Tfpggauge) and (cns_gauge = False) then
        begin
          funit := funit + ' fpg_gauge,';
          cns_gauge := True;
        end
        else
        if ((TFormDesigner(FDesigners[n]).Form.Components[n2] is Tfpglistbox) or
          (TFormDesigner(FDesigners[n]).Form.Components[n2] is TfpgColorListBox)) and (cns_listbox = False) then
        begin
          funit := funit + ' fpg_listbox,';
          cns_listbox := True;
        end
        else
        if ((TFormDesigner(FDesigners[n]).Form.Components[n2] is Tfpgpanel) or
          (TFormDesigner(FDesigners[n]).Form.Components[n2] is TfpgBevel) or (TFormDesigner(FDesigners[n]).Form.Components[n2] is
          TfpgGroupBox)) and (cns_panel = False) then
        begin
          funit := funit + ' fpg_panel,';
          cns_panel := True;
        end
        else
        if (TFormDesigner(FDesigners[n]).Form.Components[n2] is Tfpgmemo) and (cns_memo = False) then
        begin
          funit := funit + ' fpg_memo,';
          cns_memo := True;
        end
        else
        if (TFormDesigner(FDesigners[n]).Form.Components[n2] is TfpgStringGrid) and (cns_grid = False) then
        begin
          funit := funit + ' fpg_grid,';
          cns_grid := True;
        end
        else
        if (TFormDesigner(FDesigners[n]).Form.Components[n2] is TfpgListView) and (cns_listview = False) then
        begin
          funit := funit + ' fpg_listview,';
          cns_listview := True;
        end
        else
        if (TFormDesigner(FDesigners[n]).Form.Components[n2] is TfpgTreeView) and (cns_tree = False) then
        begin
          funit := funit + ' fpg_tree,';
          cns_tree := True;
        end
        else
        if (TFormDesigner(FDesigners[n]).Form.Components[n2] is TfpgProgressBar) and (cns_progressbar = False) then
        begin
          funit := funit + ' fpg_progressbar,';
          cns_progressbar := True;
        end
        else
        if (TFormDesigner(FDesigners[n]).Form.Components[n2] is TfpgTrackBar) and (cns_trackbar = False) then
        begin
          funit := funit + ' fpg_trackbar,';
          cns_trackbar := True;
        end
        else
        if (TFormDesigner(FDesigners[n]).Form.Components[n2] is TfpgPageControl) and (cns_tab = False) then
        begin
          funit := funit + ' fpg_tab,';
          cns_tab := True;
        end
        else
        if (TFormDesigner(FDesigners[n]).Form.Components[n2] is TfpgSplitter) and (cns_splitter = False) then
        begin
          funit := funit + ' fpg_splitter,';
          cns_splitter := True;
        end
        else
        if (TFormDesigner(FDesigners[n]).Form.Components[n2] is TfpgNiceGrid) and (cns_nicegrid = False) then
        begin
          funit := funit + ' fpg_nicegrid,';
          cns_nicegrid := True;
        end
        else
        if (TFormDesigner(FDesigners[n]).Form.Components[n2] is TfpgEditGrid) and (cns_editgrid = False) then
        begin
          funit := funit + ' u_editgrid,';
          cns_editgrid := True;
        end
        else
        if (TFormDesigner(FDesigners[n]).Form.Components[n2] is TfpgHyperlink) and (cns_hyperlink = False) then
        begin
          funit := funit + ' fpg_hyperlink,';
          cns_hyperlink := True;
        end
        else
        if (TFormDesigner(FDesigners[n]).Form.Components[n2] is TfpgToggle) and (cns_toggle = False) then
        begin
          funit := funit + ' fpg_toggle,';
          cns_toggle := True;
        end
        else
        if ((TFormDesigner(FDesigners[n]).Form.Components[n2] is TfpgMenuItem) or
          (TFormDesigner(FDesigners[n]).Form.Components[n2] is TfpgMenuBar) or (TFormDesigner(FDesigners[n]).Form.Components[n2] is
          TfpgPopupMenu)) and (cns_menu = False) then
        begin
          funit := funit + ' fpg_menu,';
          cns_menu := True;
        end
        else
        if ((TFormDesigner(FDesigners[n]).Form.Components[n2] is TfpgCalendarCombo) or
          (TFormDesigner(FDesigners[n]).Form.Components[n2] is TfpgCalendarCheckCombo)) and (cns_calendar = False) then
        begin
          funit := funit + ' fpg_popupcalendar,';
          cns_calendar := True;
        end;

      end;
    end;

    Result := fdata1 + fdata2 + funit + datatmp + fdata3 + fdata4;
  end
  else
    Result := filedata;

end;

procedure TMainDesigner.OnSaveFile(Sender: TObject);
var
  n, i: integer;
  fd: TFormDesigner;
  fdata: string;
  ff: file;
  fname, uname: string;
  aFileDialog: TfpgFileDialog;
begin
  fname := EditedFileName;

  if ((Sender as TComponent).Tag = 10) and (EditedFileName <> '') then
    fname := EditedFileName
  else
  begin
    afiledialog := TfpgFileDialog.Create(nil);
    afiledialog.Filename := EditedFilename;
    afiledialog.WindowTitle := 'Save form source';
    afiledialog.Filter :=
      'Pascal source files (*.pp;*.pas;*.inc;*.dpr;*.lpr)|*.pp;*.pas;*.inc;*.dpr;*.lpr|All Files (*)|*';
    if afiledialog.RunSaveFile then
    begin
      fname := aFileDialog.Filename;
      if (ExtractFileExt(fname) = '') then
        fname := fname + DefaultPasExt;
      EditedFileName := fname;
    end
    else
      fname := '';
    aFileDialog.Free;
  end;

  if fname = '' then
    Exit;

  EditedFileName := fname;

  if fpgFileExists(fname) then
  begin
    FFile.LoadFile(fname);
    FFile.GetBlocks;
  end
  else
  begin
    uname := fpgExtractFileName(fname);
    i := pos('.pas', LowerCase(uname));
    if i > 0 then
      uname := copy(uname, 1, i - 1);
    FFile.NewFileSkeleton(uname);
  end;

  for n := 0 to DesignerCount - 1 do
  begin
    fd := nil;
    fd := Designer(n);
    if fd = nil then
      raise Exception.Create('Failed to find Designer Form');
    FFile.SetFormData(fd.Form.Name, fd.GetFormSourceDecl, fd.GetFormSourceImpl);
  end;

  fdata := FFile.MergeBlocks;

  if enableautounits then
    fdata := AddUnits(fdata);


  AssignFile(ff, fpgToOSEncoding(fname));
  try
    Rewrite(ff, 1);
    try
      BlockWrite(ff, fdata[1], length(fdata));
    finally
      CloseFile(ff);
    end;
    frmMainDesigner.mru.AddItem(fname);
  except
    on E: Exception do
      raise Exception.Create('Form save I/O failure in TMainDesigner.OnSaveFile.' + #13 + E.Message);
  end;
  // if (enableundo = True) then SaveUndo(Sender, 6);
end;

procedure TMainDesigner.LoadUndo(undoindex: integer);
var
  n, m, x: integer;
  bl, bl2: TVFDFileBlock;
  FFileUndo: TVFDFile;
begin

  isfileloaded := False;
  fpgapplication.ProcessMessages;

  isfpguifile := False;
  frmProperties.Hide;
  frmmultiselect.Hide;
  frmmultiselect.ClearAll;


  for n := 0 to FDesigners.Count - 1 do
  begin
    TFormDesigner(FDesigners[n]).DeSelectAll;
    TFormDesigner(FDesigners[n]).Free;
  end;
  FDesigners.Clear;

  frmproperties.edName.Text := '';

  SetLength(ArrayFormDesign, 0);
  x := 0;

  if fileexists(ArrayUndo[undoindex].FileName) then
  begin
    ifundo := True;
    FFileUndo := TVFDFile.Create;

    if FFileUndo.LoadFile(ArrayUndo[undoindex].FileName) = False then
    begin
      FFileUndo.Free;
      ifundo := False;
      exit;
    end;

    if FFileUndo.GetBlocks = 0 then
    begin
      FFileUndo.Free;
      ifundo := False;
      exit;
    end;

    for n := 0 to 9 do
    begin
      frmMainDesigner.windowmenu.MenuItem(n + 2).Visible := False;
      frmMainDesigner.windowmenu.MenuItem(n + 2).Text := '';
    end;

    for n := 0 to FFileUndo.BlockCount - 1 do
    begin
      bl := FFileUndo.Block(n);
      if bl.BlockID = 'VFD_HEAD_BEGIN' then
        for m := n + 1 to FFileUndo.BlockCount - 1 do
        begin
          bl2 := FFileUndo.Block(m);
          if (bl2.BlockID = 'VFD_BODY_BEGIN') and (bl2.FormName = bl.FormName) then
          begin
            if x < 10 then

            begin
              SetLength(ArrayFormDesign, x + 1);
              ArrayFormDesign[x] := CreateParseForm(bl.FormName, bl.Data, bl2.Data);
              // pair was found
            end
            else
              CreateParseForm(bl.FormName, bl.Data, bl2.Data);

            frmMainDesigner.windowmenu.MenuItem(1).Visible := True;
            if x < 10 then
            begin
              frmMainDesigner.windowmenu.MenuItem(x + 2).Visible := True;
              frmMainDesigner.windowmenu.MenuItem(x + 2).Text := bl.FormName;
            end;
            Inc(x);
          end;
        end;
    end;

    ifundo := False;
    frmMainDesigner.undomenu.MenuItem(1).Enabled := True;

    for n := 0 to FDesigners.Count - 1 do
    begin
      selectedform := nil;
      TFormDesigner(FDesigners[n]).Form.ShowGrid := FShowGrid;
    end;

    isfpguifile := True;
    isfileloaded := True;

    frmProperties.Show;

  end;

end;

procedure TMainDesigner.SaveUndo(Sender: TObject; typeundo: integer);
var
  n, dd: integer;
  fd: TFormDesigner;
  fdataundo, undodir, tempcomment, undofile, undotime, undofile2: string;
  ffundo: file;
  FFileUndo: TVFDFile;
  TempForm: string;
begin
  if dob = FormatDateTime('tt', now) then
    dd := 1
  else
    dd := 0;

  fpgapplication.ProcessMessages;
  ifundo := True;
  undodir := IncludeTrailingBackslash(ExtractFilePath(ParamStr(0))) + directoryseparator + 'temp';
  if DirectoryExists(PChar(undodir)) then
  else
    ForceDirectories(PChar(undodir));
  undodir := undodir + directoryseparator;

  FFileUndo := TVFDFile.Create;

  FFileUndo.LoadFile(EditedFileName);
  FFileUndo.GetBlocks;

  for n := 0 to DesignerCount - 1 do
  begin
    fd := nil;
    fd := Designer(n);
    if fd = nil then
      raise Exception.Create('Failed to find Designer Form');
    FFileundo.SetFormData(fd.Form.Name, fd.GetFormSourceDecl, fd.GetFormSourceImpl);
  end;

  fdataundo := FFileUndo.MergeBlocks;
  undotime := FormatDateTime('tt', now);
  dob := undotime;
  undofile := IntToStr(typeundo) + '_' + FormatDateTime('yy', now) + FormatDateTime('mm', now) + FormatDateTime('dd', now) +
    FormatDateTime('hh', now) + FormatDateTime('nn', now) + FormatDateTime('ss', now);

  AssignFile(ffundo, fpgToOSEncoding(undodir + undofile + '.tmp'));
  try
    Rewrite(ffundo, 1);
    try
      BlockWrite(ffundo, fdataundo[1], length(fdataundo));
    finally
      CloseFile(ffundo);
    end;
  except
    on E: Exception do
      raise Exception.Create('Form save I/O failure in TMainDesigner.SaveUndo.' + #13 + E.Message);
  end;

  FFileUndo.Free;

  if dd = 0 then
  begin

    if length(ArrayUndo) < maxundo then
      SetLength(ArrayUndo, length(ArrayUndo) + 1)
    else
      deletefile(ArrayUndo[length(ArrayUndo) - 1].FileName);

    undofile2 := ArrayUndo[0].FileName;
    TempForm := ArrayUndo[0].ActiveForm;
    Tempcomment := ArrayUndo[0].Comment;

    n := length(ArrayUndo) - 1;
    while (n > 0) do
    begin
      ArrayUndo[n].FileName := ArrayUndo[n - 1].FileName;
      ArrayUndo[n].ActiveForm := ArrayUndo[n - 1].ActiveForm;
      ArrayUndo[n].Comment := ArrayUndo[n - 1].Comment;
      Dec(n);
    end;

    if length(ArrayUndo) > 1 then
    begin
      ArrayUndo[1].FileName := undofile2;
      ArrayUndo[1].ActiveForm := TempForm;
      ArrayUndo[1].Comment := Tempcomment;
    end;
  end;

  if dd = 1 then
    deletefile(ArrayUndo[0].FileName);

  ArrayUndo[0].FileName := undodir + undofile + '.tmp';

  if typeundo <> 5 then
    ArrayUndo[0].ActiveForm := selectedform.Form.Name
  else
    ArrayUndo[0].ActiveForm := '';

  ArrayUndo[0].comment := frmProperties.edName.Text;
  /// to do better with more details

  if typeundo < 5 then
  begin
    if frmProperties.edName.Text = selectedform.Form.Name then
      tempform := selectedform.Form.Name + ' => has moved.'
    else
      tempform := selectedform.Form.Name + ' => ' + frmProperties.edName.Text + ' => has changed.';
  end
  else
    case typeundo of
      5: tempform := 'Init Root.';
      6: tempform := selectedform.Form.Name + ' => was saved.';
      7: tempform := selectedform.Form.Name + ' => new form.';
      8: tempform := selectedform.Form.Name + ' => properties changed by Multi-Selector.';
      9: tempform := selectedform.Form.Name + ' => Copy/Paste widgets by Multi-Selector.';
      10: tempform := selectedform.Form.Name + ' => Delete widgets by Multi-Selector.';
      11: tempform := selectedform.Form.Name + ' => Other Change.';
      12: tempform := selectedform.Form.Name + ' => Properies Changed.';
      13: tempform := selectedform.Form.Name + ' => Anchor Changed.'
    end;

  if dd = 0 then
  begin
    undofile2 := frmMainDesigner.listundomenu.MenuItem(0).Text;
    n := length(ArrayUndo) - 1;
    while (n > 0) do
    begin
      frmMainDesigner.listundomenu.MenuItem(n).Text := frmMainDesigner.listundomenu.MenuItem(n - 1).Text;
      Dec(n);
    end;
    if length(ArrayUndo) > 1 then
      frmMainDesigner.listundomenu.MenuItem(1).Text := undofile2;
  end;

  frmMainDesigner.listundomenu.MenuItem(0).Text := undotime + ' => ' + TempForm;

  frmMainDesigner.undomenu.MenuItem(0).Enabled := True;
  frmMainDesigner.undomenu.MenuItem(3).Enabled := True;

  for n := 0 to length(ArrayUndo) - 1 do
    frmMainDesigner.listundomenu.MenuItem(n).Visible := True;

  ifundo := False;
end;

procedure TMainDesigner.OnPropNameChange(Sender: TObject);
var
  TheParent: Tfpgwidget;
begin
  if (SelectedForm <> nil) and (isfpguifile = True) and (isfileloaded = True) then
  begin
    SelectedForm.OnPropNameChange(Sender);
    if (ifundo = False) and (enableundo = True) then
      SaveUndo(Sender, 0);

    fpgapplication.ProcessMessages;

    if frmMultiSelect.Visible = True then
    begin
      TheParent := (frmProperties.lstProps.Props.Widget);
      if TheParent.HasParent then
        TheParent := (frmProperties.lstProps.Props.Widget.Parent);
      frmMultiSelect.Getwidgetlist(TheParent);
    end;

  end;
end;

procedure TMainDesigner.OnPropPosEdit(Sender: TObject);
var
  TheParent: Tfpgwidget;
begin
  if (SelectedForm <> nil) and (isfileloaded = True) then
  begin
    SelectedForm.OnPropPosEdit(Sender);
    fpgapplication.ProcessMessages;
    if (ifundo = False) and (enableundo = True) then
      SaveUndo(Sender, 1);
    if frmMultiSelect.Visible = True then
    begin
      TheParent := (frmProperties.lstProps.Props.Widget);
      if TheParent.HasParent then
        TheParent := (frmProperties.lstProps.Props.Widget.Parent);
      frmMultiSelect.Getwidgetlist(TheParent);
    end;
    fpgapplication.ProcessMessages;
  end;
end;

procedure TMainDesigner.OnPropTextChange(Sender: TObject);
begin
  if (SelectedForm <> nil) and (isfileloaded = True) then
  begin
    SelectedForm.OnPropTextChange(Sender);
    if (ifundo = False) and (enableundo = True) then
      SaveUndo(Sender, 12);
  end;
end;

procedure TMainDesigner.OnAnchorChange(Sender: TObject);
begin
  if (SelectedForm <> nil) and (isfileloaded = True) then
  begin
    SelectedForm.OnAnchorChange(Sender);
    fpgapplication.ProcessMessages;
    if (ifundo = False) and (enableundo = True) then
      SaveUndo(Sender, 13);
  end;
end;

procedure TMainDesigner.OnOtherChange(Sender: TObject);
var
  TheParent: Tfpgwidget;
begin
  if (SelectedForm <> nil) and (isfileloaded = True) then
  begin
    SelectedForm.OnOtherChange(Sender);
    fpgapplication.ProcessMessages;
    if (ifundo = False) and (enableundo = True) then
      SaveUndo(Sender, 4);
    if frmMultiSelect.Visible = True then
    begin
      TheParent := (frmProperties.lstProps.Props.Widget);
      if TheParent.HasParent then
        TheParent := (frmProperties.lstProps.Props.Widget.Parent);

      frmMultiSelect.Getwidgetlist(TheParent);

    end;
    fpgapplication.ProcessMessages;
    if (ifundo = False) and (enableundo = True) then
      SaveUndo(Sender, 11);
  end;

end;

procedure TMainDesigner.OnNewForm(Sender: TObject);
var
  fd: TFormDesigner;
  nfrm: TNewFormForm;
  x: integer;

  function DoesNameAlreadyExist(const AName: string): boolean;
  var
    i: integer;
  begin
    Result := False;
    for i := 0 to FDesigners.Count - 1 do
    begin
      if TFormDesigner(FDesigners[i]).Form.Name = AName then
      begin
        Result := True;
        break;
      end;
    end;
  end;

begin
  nfrm := TNewFormForm.Create(nil);
  try
    if nfrm.ShowModal = mrOk then
    begin
      if DoesNameAlreadyExist(nfrm.edName.Text) then
      begin
        TfpgMessageDialog.Critical('Name Conflict',
          'The form name already exists in the current unit, please try again');
        exit;
      end;
      fd := TFormDesigner.Create;
      if nfrm.edName.Text <> '' then
        fd.Form.Name := nfrm.edName.Text;
      fd.Form.WindowTitle := fd.Form.Name;
      fd.Form.ShowGrid := FShowGrid;
      fd.OneClickMove := OneClickMove;
      FDesigners.Add(fd);
      SelectedForm := fd;
      fd.Show;

      x := length(ArrayFormDesign);

      if x < 10 then
      begin
        SetLength(ArrayFormDesign, length(ArrayFormDesign) + 1);
        x := length(ArrayFormDesign);
        ArrayFormDesign[x - 1] := fd;
        frmMainDesigner.windowmenu.MenuItem(1).Visible := True;
        frmMainDesigner.windowmenu.MenuItem(x + 1).Visible := True;
        frmMainDesigner.windowmenu.MenuItem(x + 1).Text := fd.Form.Name;
      end;

    end;

  finally
    nfrm.Free;
  end;
end;

procedure TMainDesigner.CreateWindows;
begin
  frmMainDesigner := TfrmMainDesigner.Create(nil);
  frmMainDesigner.WindowTitle := 'fpGUI Designer_ext v' + ext_version;
  frmMainDesigner.Show;

  frmProperties := TfrmProperties.Create(nil);
  frmProperties.Show;
end;

constructor TMainDesigner.Create;
begin
  FDesigners := TList.Create;
  SelectedForm := nil;
  FFile := TVFDFile.Create;

  // options
  SaveComponentNames := True;
  LoadDefaults;

  FEditedFileName := '';
end;

destructor TMainDesigner.Destroy;
var
  n: integer;
begin
  if Length(ArrayUndo) > 0 then
  begin
    for n := 0 to length(ArrayUndo) - 1 do
      deletefile(ArrayUndo[n].FileName);
  end;

  for n := 0 to FDesigners.Count - 1 do
    TFormDesigner(FDesigners[n]).Free;
  FDesigners.Free;
  FFile.Free;

  frmProperties.Free;
  frmMainDesigner.Free;
  inherited;
end;

procedure TMainDesigner.SelectForm(aform: TFormDesigner);
begin
  if (SelectedForm <> nil) and (SelectedForm <> aform) and (isfileloaded = True) then
    SelectedForm.DeSelectAll;
  SelectedForm := aform;
end;

function TMainDesigner.Designer(index: integer): TFormDesigner;
begin
  Result := nil;
  if (index < 0) or (index > FDesigners.Count - 1) then
    Exit;
  Result := TFormDesigner(FDesigners[index]);
end;

function TMainDesigner.DesignerCount: integer;
begin
  Result := FDesigners.Count;
end;

function TMainDesigner.NewFormName: string;
var
  n, i: integer;
  s: string;
begin
  i := 0;
  repeat
    Inc(i);
    s := 'Form' + IntToStr(i);
    n := 0;
    while (n < DesignerCount) do
    begin
      if Designer(n).Form.Name = s then
        Break;
      Inc(n);
    end;
  until n > DesignerCount - 1;
  Result := s;
end;

function TMainDesigner.CreateParseForm(const FormName, FormHead, FormBody: string): TFormDesigner;
var
  fd: TFormDesigner;
  fp: TVFDFormParser;
begin
  fp := TVFDFormParser.Create(FormName, FormHead, FormBody);
  fd := fp.ParseForm;
  fd.OneClickMove := OneClickMove;
  fp.Free;

  FDesigners.Add(fd);
  Result := fd;
  fpgapplication.ProcessMessages;
  fd.Show;
end;

procedure TMainDesigner.OnEditWidget(Sender: TObject);
begin
  if (SelectedForm <> nil) and (isfileloaded = True) then
    SelectedForm.OnEditWidget(Sender);
end;

procedure TMainDesigner.OnEditWidgetOrder(Sender: TObject);
begin
  if (SelectedForm <> nil) and (isfileloaded = True) then
    SelectedForm.EditWidgetOrTabOrder(emWidgetOrder);
end;

procedure TMainDesigner.OnEditTabOrder(Sender: TObject);
begin
  if (SelectedForm <> nil) and (isfileloaded = True) then
    SelectedForm.EditWidgetOrTabOrder(emTabOrder);
end;

procedure TMainDesigner.OnExit(Sender: TObject);
begin
  frmProperties.Close;
  frmMainDesigner.Close;
end;

procedure TMainDesigner.OnOptionsClick(Sender: TObject);
var
  frm: TfrmVFDSetup;
begin
  // gINI.WriteFormState(frmMainDesigner);
  frm := TfrmVFDSetup.Create(nil);
  try
    if frm.ShowModal = mrOk then
    begin
      //  frmMainDesigner.WindowType:=wtpopup;
      LoadDefaults;
      frmMainDesigner.mru.MaxItems := gINI.ReadInteger('Options', 'MRUFileCount', 4);
      frmMainDesigner.mru.ShowFullPath := gINI.ReadBool('Options', 'ShowFullPath', True);
    end;
  finally
    frm.Free;

  end;
end;

procedure TMainDesigner.SetEditedFileName(const Value: string);
var
  aprocess: tprocess;
  e: string;
begin
  AProcess := TProcess.Create(nil);

  FEditedFileName := Value;

  if pos('.lpi', FEditedFileName) > 0 then
  begin
    Delete(FEditedFileName, pos('.lpi', FEditedFileName), 4);
    e := FEditedFileName;
    FEditedFileName := FEditedFileName + '.lpr';
    if fileexists(FEditedFileName) then
    else
      FEditedFileName := e + '.pas';
  end;

  s := ExtractFileName(FEditedFileName);

  p := ExtractFilePath(FEditedFileName);
  if s = '' then
    s := '[' + rsNewUnnamedForm + ']';

   {$IFDEF Linux}
  if (fileexists(PChar(p + s))) and (gINI.ReadInteger('Options', 'Editor', 0) > 1) then
  begin
    {$WARN SYMBOL_DEPRECATED OFF}
    case gINI.ReadInteger('Options', 'Editor', 0) of
      2: AProcess.CommandLine := 'gedit ' + p + s;
      3: AProcess.CommandLine := 'geany ' + p + s;
      4: AProcess.CommandLine :=
          gINI.ReadString('Options', 'CustomEditor', '') + ' ' + p + s;
    end;
     {$WARN SYMBOL_DEPRECATED ON}
    AProcess.Options := AProcess.Options + [poNoConsole];
    AProcess.Priority := ppNormal;
    AProcess.showwindow := swoShowNoActivate;
    AProcess.Execute;
    AProcess.Free;
  end;
   {$ENDIF}

     {$IFDEF windows}
  if (fileexists(PChar(p + s))) and (gINI.ReadInteger('Options', 'Editor', 0) > 1) then
  begin
     {$WARN SYMBOL_DEPRECATED OFF}
    case gINI.ReadInteger('Options', 'Editor', 0) of
      2: AProcess.CommandLine := 'notepad ' + p + s;
      3: AProcess.CommandLine := 'write ' + p + s;
      4: AProcess.CommandLine :=
          gINI.ReadString('Options', 'CustomEditor', '') + ' ' + p + s;
    end;
      {$WARN SYMBOL_DEPRECATED ON}
    AProcess.Options := AProcess.Options + [poNoConsole];
    AProcess.Priority := ppHigh;
    // AProcess.showwindow :=  swonone ;
    AProcess.Execute;
    AProcess.Free;
  end;
   {$ENDIF}

end;

procedure TMainDesigner.LoadDefaults;
begin
  GridResolution := gINI.ReadInteger('Options', 'GridResolution', 4);
  DefaultPasExt := gINI.ReadString('Options', 'DefaultFileExt', '.pas');
  UndoOnPropExit := gINI.ReadBool('Options', 'UndoOnExit', DefUndoOnPropExit);
  OneClickMove := gINI.ReadBool('Options', 'OneClickMove', True);
  DefaultPasExt := gINI.ReadString('Options', 'DefaultFileExt', '.pas');
  UndoOnPropExit := gINI.ReadBool('Options', 'UndoOnExit', DefUndoOnPropExit);
  OneClickMove := gINI.ReadBool('Options', 'OneClickMove', True);
  fpgApplication.HintPause := 1000;
end;

procedure TMainDesigner.SetShowGrid(AValue: boolean);
var
  i: integer;
begin
  if (isfileloaded = True) then
  begin
    if FShowGrid = AValue then
      Exit;
    FShowGrid := AValue;
    for i := 0 to FDesigners.Count - 1 do
      TFormDesigner(FDesigners[i]).Form.ShowGrid := AValue;
  end;
end;

end.
