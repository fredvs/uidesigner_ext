{
This is part of the extended version of fpGUI uidesigner => Designer_ext.
With window list, undo feature, integration into IDE, editor launcher, extra-properties editor,...

Fred van Stappen
fiens@hotmail.com
2013 - 2015
}
unit frm_multiselect;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, fpg_base, fpg_Grid, fpg_button, fpg_editbtn,
  fpg_main, fpg_hyperlink, fpg_tab,
  fpg_panel, fpg_label, fpg_edit, vfd_widgetclass, vfd_widgets,
  fpg_scrollbar, fpg_radiobutton, sak_fpg,
  fpg_checkbox, fpg_widget, fpg_spinedit, fpg_form;

type

  Tfrm_multiselect = class(TfpgForm)
  private
    {@VFD_HEAD_BEGIN: frm_multiselect}
    lbleft: Tfpglabel;
    lbtop: Tfpglabel;
    lbheight: Tfpglabel;
    lbwidth: Tfpglabel;
    cbleft: TfpgCheckBox;
    edleft: TfpgSpinEdit;
    cbwidth: TfpgCheckBox;
    edwidth: TfpgSpinEdit;
    cbtop: TfpgCheckBox;
    edtop: TfpgSpinEdit;
    cbHeight: TfpgCheckBox;
    edheight: TfpgSpinEdit;
    Panel2: TfpgPanel;
    cbleft2: TfpgCheckBox;
    edleft2: TfpgSpinEdit;
    cbwidth2: TfpgCheckBox;
    edwidth2: TfpgSpinEdit;
    cbtop2: TfpgCheckBox;
    edtop2: TfpgSpinEdit;
    cbHeight2: TfpgCheckBox;
    edheight2: TfpgSpinEdit;
    Panel3: TfpgPanel;
    cbleft3: TfpgCheckBox;
    edleft3: TfpgSpinEdit;
    cbwidth3: TfpgCheckBox;
    edwidth3: TfpgSpinEdit;
    cbtop3: TfpgCheckBox;
    edtop3: TfpgSpinEdit;
    cbHeight3: TfpgCheckBox;
    edheight3: TfpgSpinEdit;
    {@VFD_HEAD_END: frm_multiselect}
  public
    Grid1: TfpgStringGrid;
    Panel1: TfpgPanel;
    PanelMain: TfpgPanel;
    PanelScroll: TfpgPanel;
    PanelCopyPaste: TfpgPanel;
    scroll1: Tfpgscrollbar;
    btApply: TfpgButton;
    btApply2: TfpgButton;
    btApply3: TfpgButton;
    btSelectAll: TfpgButton;
    btUnSelectAll: TfpgButton;
    btApplyCopyPaste: TfpgButton;
    btApplyDelete: TfpgButton;
    cbSelected: array of Tfpgcheckbox;
    procedure AfterCreate; override;
    procedure onDestroyFrm(Sender: TObject);
    procedure ClearAll;
    procedure btnApply1Clicked(Sender: TObject);
    procedure btnApply2Clicked(Sender: TObject);
    procedure btnApply3Clicked(Sender: TObject);
    procedure btnunselectall(Sender: TObject);
    procedure btnselectall(Sender: TObject);
    procedure btnCopyPasteClicked(Sender: TObject);
    procedure btnDeleteClicked(Sender: TObject);
    procedure Getwidgetlist(Theobj: TfpgWidget);
    procedure ProcGetwidgetlist(Theobj: TfpgWidget);
    procedure ProcUpdateGrid(Theobj: TfpgWidget);
    procedure SelectedFromDesigner(TheSelected: TfpgWidget);
    procedure onScrollChange(Sender: TObject; position: integer);
  end;

{@VFD_NEWFORM_DECL}

var
  TheSelectedForm: Tfpgwidget;
  oricount: integer;
  calculwidget: boolean = False;
  frmMultiSelect: Tfrm_multiselect;

implementation

uses
  vfd_main, vfd_designer, frm_main_designer;

{@VFD_NEWFORM_IMPL}

procedure Tfrm_multiselect.AfterCreate;
begin
  {%region 'Auto-generated GUI code' -fold}

  {@VFD_BODY_BEGIN: frm_multiselect}
  Name := 'frmmultiselect';
  SetPosition(95, 212, 466, 117);
  WindowTitle := 'Multi-Selector';
  Hint := '';
  BackGroundColor := $E8E8E8;
  Visible := False;
  WindowPosition := wpUser;

  OnDestroy := @onDestroyFrm;

  btSelectAll := TfpgButton.Create(self);
  with btSelectAll do
  begin
    Name := 'btSelectAll';
    SetPosition(7, 1, 72, 18);
    FontDesc := '#Label1';
    Hint := '';
    ImageName := '';
    TabOrder := 5;
    Text := 'Select all';
    OnClick := @btnselectall;
  end;

  btUnSelectAll := TfpgButton.Create(self);
  with btUnSelectAll do
  begin
    Name := 'btUnSelectAll';
    SetPosition(80, 1, 77, 18);
    FontDesc := '#Label1';
    Hint := '';
    ImageName := '';
    TabOrder := 6;
    Text := 'Select none';
    OnClick := @btnunselectall;
  end;

  lbleft := TfpgLabel.Create(self);
  with lbleft do
  begin
    Name := 'lbleft';
    SetPosition(161, 1, 72, 18);
    FontDesc := '#Label1';
    Hint := '';
    Text := 'Left';
    Alignment := taCenter;
    BackGroundColor := clgray;
    TextColor := clwhite;
  end;

  lbtop := TfpgLabel.Create(self);
  with lbtop do
  begin
    Name := 'lbtop';
    SetPosition(235, 1, 72, 18);
    FontDesc := '#Label1';
    Hint := '';
    Text := 'Top';
    Alignment := taCenter;
    BackGroundColor := clgray;
    TextColor := clwhite;
  end;

  lbwidth := TfpgLabel.Create(self);
  with lbwidth do
  begin
    Name := 'lbwidth';
    SetPosition(309, 1, 72, 18);
    FontDesc := '#Label1';
    Hint := '';
    Text := 'Width';
    BackGroundColor := clgray;
    TextColor := clwhite;
    Alignment := taCenter;
  end;

  lbheight := TfpgLabel.Create(self);
  with lbheight do
  begin
    Name := 'lbheight';
    SetPosition(383, 1, 74, 18);
    FontDesc := '#Label1';
    Hint := '';
    Text := 'Height';
    BackGroundColor := clgray;
    TextColor := clwhite;
    Alignment := taCenter;
  end;

  Panelmain := TfpgPanel.Create(self);
  with Panelmain do
  begin
    Name := 'Panelmain';
    SetPosition(0, 20, 466, 70);
    FontDesc := '#Label1';
    Hint := '';
    Text := '';
    BackGroundColor := $E8E8E8;
    Style := bsFlat;
  end;

  scroll1 := Tfpgscrollbar.Create(Panelmain);
  with scroll1 do
  begin
    Name := 'scroll1';
    SetPosition(448, 0, 16, 70);
    scroll1.OnScroll := @onScrollChange;
  end;

  Panelscroll := TfpgPanel.Create(Panelmain);
  with Panelscroll do
  begin
    Name := 'Panelscroll';
    SetPosition(0, 0, 445, 300);
    FontDesc := '#Label1';
    Hint := '';
    Text := '';
    BackGroundColor := $E8E8E8;
    Style := bsFlat;
  end;


  Grid1 := TfpgStringGrid.Create(Panelscroll);
  with Grid1 do
  begin
    Name := 'Grid1';
    SetPosition(160, 0, 244, 100);
    BackgroundColor := TfpgColor($80000002);
    AddColumn('Left', 74, taLeftJustify);
    AddColumn('Top', 74, taLeftJustify);
    AddColumn('Width', 74, taLeftJustify);
    AddColumn('Height', 74, taLeftJustify);
    Grid1.ShowHeader := False;
    FontDesc := '#Grid';
    HeaderFontDesc := '#GridHeader';
    Hint := '';
    RowCount := 0;
    RowSelect := False;
    TabOrder := 2;
    Visible := False;
    DefaultRowHeight := 19;

  end;

  PanelCopyPaste := TfpgPanel.Create(self);
  with PanelCopyPaste do
  begin
    Name := 'PanelCopyPaste';
    SetPosition(6, 44, 114, 55);
    FontDesc := '#Label1';
    BackgroundColor := clgray;
    Hint := '';
    Text := '';
  end;

  btApplyCopyPaste := TfpgButton.Create(PanelCopyPaste);
  with btApplyCopyPaste do
  begin
    Name := 'btApplyCopyPaste';
    SetPosition(6, 6, 104, 20);
    FontDesc := '#Label1';
    Hint := '';
    ImageName := 'stdimg.paste';
    TabOrder := 6;
    Text := 'Copy/Paste';
    OnClick := @btnCopyPasteClicked;
  end;

  btApplyDelete := TfpgButton.Create(PanelCopyPaste);
  with btApplyDelete do
  begin
    Name := 'btApplyDelete';
    SetPosition(6, 30, 104, 20);
    FontDesc := '#Label1';
    Hint := '';
    ImageName := 'stdimg.delete';
    TabOrder := 6;
    Text := 'Delete';
    OnClick := @btnDeleteClicked;
  end;

  Panel1 := TfpgPanel.Create(self);
  with Panel1 do
  begin
    Name := 'Panel1';
    SetPosition(122, 42, 337, 70);
    FontDesc := '#Label1';
    Hint := '';
    Text := '';
  end;

  cbleft := TfpgCheckBox.Create(Panel1);
  with cbleft do
  begin
    Name := 'cbleft';
    SetPosition(5, 6, 80, 18);
    BackgroundColor := TfpgColor($E8E8E8);
    FontDesc := '#Label1';
    Hint := '';
    TabOrder := 4;
    Text := 'Left :=';
  end;

  edleft := TfpgSpinEdit.Create(Panel1);
  with edleft do
  begin
    Name := 'edleft';
    SetPosition(70, 4, 50, 22);
    FontDesc := '#Edit1';
    Hint := '';
    TabOrder := 3;
    Value := 0;
  end;

  cbwidth := TfpgCheckBox.Create(Panel1);
  with cbwidth do
  begin
    Name := 'cbwidth';
    SetPosition(124, 6, 80, 18);
    BackgroundColor := TfpgColor($E8E8E8);
    FontDesc := '#Label1';
    Hint := '';
    TabOrder := 4;
    Text := 'Width :=';
  end;

  edwidth := TfpgSpinEdit.Create(Panel1);
  with edwidth do
  begin
    Name := 'edwidth';
    SetPosition(204, 4, 50, 22);
    FontDesc := '#Edit1';
    Hint := '';
    TabOrder := 5;
    Value := 0;
  end;

  cbtop := TfpgCheckBox.Create(Panel1);
  with cbtop do
  begin
    Name := 'cbtop';
    SetPosition(5, 30, 78, 18);
    BackgroundColor := TfpgColor($E8E8E8);
    FontDesc := '#Label1';
    Hint := '';
    TabOrder := 7;
    Text := 'Top :=';
  end;

  edtop := TfpgSpinEdit.Create(Panel1);
  with edtop do
  begin
    Name := 'edtop';
    SetPosition(70, 28, 50, 22);
    FontDesc := '#Edit1';
    Hint := '';
    TabOrder := 8;
    Value := 0;
  end;

  cbHeight := TfpgCheckBox.Create(Panel1);
  with cbHeight do
  begin
    Name := 'cbHeight';
    SetPosition(124, 30, 80, 18);
    BackgroundColor := TfpgColor($E8E8E8);
    FontDesc := '#Label1';
    Hint := '';
    TabOrder := 9;
    Text := 'Height :=';
  end;

  edheight := TfpgSpinEdit.Create(Panel1);
  with edheight do
  begin
    Name := 'edheight';
    SetPosition(204, 28, 50, 22);
    FontDesc := '#Edit1';
    Hint := '';
    TabOrder := 10;
    Value := 0;
  end;

  btApply := TfpgButton.Create(Panel1);
  with btApply do
  begin
    Name := 'btApply';
    SetPosition(316, 28, 64, 23);
    FontDesc := '#Label1';
    Hint := '';
    ImageName := 'stdimg.ok';
    TabOrder := 6;
    Text := 'Apply';
    OnClick := @btnApply1Clicked;
  end;

  Panel2 := TfpgPanel.Create(self);
  with Panel2 do
  begin
    Name := 'Panel2';
    SetPosition(6, 42, 453, 70);
    FontDesc := '#Label1';
    Hint := '';
    Text := '';
  end;

  cbleft2 := TfpgCheckBox.Create(Panel2);
  with cbleft2 do
  begin
    Name := 'cbleft2';
    SetPosition(5, 6, 150, 18);
    BackgroundColor := TfpgColor($E8E8E8);
    FontDesc := '#Label1';
    Hint := '';
    TabOrder := 4;
    Text := 'Left:=up.Left + ';
  end;

  edleft2 := TfpgSpinEdit.Create(Panel2);
  with edleft2 do
  begin
    Name := 'edleft2';
    SetPosition(115, 4, 50, 22);
    FontDesc := '#Edit1';
    Hint := '';
    TabOrder := 3;
    Value := 0;
  end;

  cbwidth2 := TfpgCheckBox.Create(Panel2);
  with cbwidth2 do
  begin
    Name := 'cbwidth2';
    SetPosition(180, 6, 150, 18);
    BackgroundColor := TfpgColor($E8E8E8);
    FontDesc := '#Label1';
    Hint := '';
    TabOrder := 4;
    Text := 'Width:=up.Width + ';
  end;

  edwidth2 := TfpgSpinEdit.Create(Panel2);
  with edwidth2 do
  begin
    Name := 'edwidth2';
    SetPosition(320, 4, 50, 22);
    FontDesc := '#Edit1';
    Hint := '';
    TabOrder := 5;
    Value := 0;
  end;

  cbtop2 := TfpgCheckBox.Create(Panel2);
  with cbtop2 do
  begin
    Name := 'cbtop2';
    SetPosition(5, 30, 150, 18);
    BackgroundColor := TfpgColor($E8E8E8);
    FontDesc := '#Label1';
    Hint := '';
    TabOrder := 7;
    Text := 'Top:=up.Top + ';
  end;

  edtop2 := TfpgSpinEdit.Create(Panel2);
  with edtop2 do
  begin
    Name := 'edtop2';
    SetPosition(115, 28, 50, 22);
    FontDesc := '#Edit1';
    Hint := '';
    TabOrder := 8;
    Value := 0;
  end;

  cbHeight2 := TfpgCheckBox.Create(Panel2);
  with cbHeight2 do
  begin
    Name := 'cbHeight2';
    SetPosition(180, 30, 150, 18);
    BackgroundColor := TfpgColor($E8E8E8);
    FontDesc := '#Label1';
    Hint := '';
    TabOrder := 9;
    Text := 'Height:=up.Height + ';
  end;

  edheight2 := TfpgSpinEdit.Create(Panel2);
  with edheight2 do
  begin
    Name := 'edheight2';
    SetPosition(320, 28, 50, 22);
    FontDesc := '#Edit1';
    Hint := '';
    TabOrder := 10;
    Value := 0;
  end;

  btApply2 := TfpgButton.Create(Panel2);
  with btApply2 do
  begin
    Name := 'btApply2';
    SetPosition(320, 28, 50, 23);
    FontDesc := '#Label1';
    Hint := '';
    ImageName := 'stdimg.ok';
    TabOrder := 6;
    Text := 'Apply';
    OnClick := @btnApply2Clicked;
  end;

  Panel3 := TfpgPanel.Create(self);
  with Panel3 do
  begin
    Name := 'Panel3';
    SetPosition(6, 42, 453, 70);
    FontDesc := '#Label1';
    Hint := '';
    Text := '';
  end;

  cbleft3 := TfpgCheckBox.Create(Panel3);
  with cbleft3 do
  begin
    Name := 'cbleft3';
    SetPosition(5, 6, 150, 18);
    BackgroundColor := TfpgColor($E8E8E8);
    FontDesc := '#Label1';
    Hint := '';
    TabOrder := 4;
    Text := 'Left:= Left + ';
  end;

  edleft3 := TfpgSpinEdit.Create(Panel3);
  with edleft3 do
  begin
    Name := 'edleft3';
    SetPosition(105, 4, 50, 22);
    FontDesc := '#Edit1';
    Hint := '';
    TabOrder := 3;
    Value := 0;
  end;

  cbwidth3 := TfpgCheckBox.Create(Panel3);
  with cbwidth3 do
  begin
    Name := 'cbwidth3';
    SetPosition(180, 6, 150, 18);
    BackgroundColor := TfpgColor($E8E8E8);
    FontDesc := '#Label1';
    Hint := '';
    TabOrder := 4;
    Text := 'Width:= Width + ';
  end;

  edwidth3 := TfpgSpinEdit.Create(Panel3);
  with edwidth3 do
  begin
    Name := 'edwidth3';
    SetPosition(310, 4, 50, 22);
    FontDesc := '#Edit1';
    Hint := '';
    TabOrder := 5;
    Value := 0;
  end;

  cbtop3 := TfpgCheckBox.Create(Panel3);
  with cbtop3 do
  begin
    Name := 'cbtop3';
    SetPosition(5, 30, 150, 18);
    BackgroundColor := TfpgColor($E8E8E8);
    FontDesc := '#Label1';
    Hint := '';
    TabOrder := 7;
    Text := 'Top:= Top + ';
  end;

  edtop3 := TfpgSpinEdit.Create(Panel3);
  with edtop3 do
  begin
    Name := 'edtop3';
    SetPosition(105, 28, 50, 22);
    FontDesc := '#Edit1';
    Hint := '';
    TabOrder := 8;
    Value := 0;
  end;

  cbHeight3 := TfpgCheckBox.Create(Panel3);
  with cbHeight3 do
  begin
    Name := 'cbHeight3';
    SetPosition(180, 30, 150, 18);
    BackgroundColor := TfpgColor($E8E8E8);
    FontDesc := '#Label1';
    Hint := '';
    TabOrder := 9;
    Text := 'Height:= Height + ';
  end;

  edheight3 := TfpgSpinEdit.Create(Panel3);
  with edheight3 do
  begin
    Name := 'edheight3';
    SetPosition(310, 28, 50, 22);
    FontDesc := '#Edit1';
    Hint := '';
    TabOrder := 10;
    Value := 0;
  end;

  btApply3 := TfpgButton.Create(Panel3);
  with btApply3 do
  begin
    Name := 'btApply3';
    SetPosition(330, 28, 50, 23);
    FontDesc := '#Label1';
    Hint := '';
    ImageName := 'stdimg.ok';
    TabOrder := 6;
    Text := 'Apply';
    OnClick := @btnApply3Clicked;
  end;


  {@VFD_BODY_END: frm_multiselect}
  {%endregion}
  panel1.Height := 55;
  btApply.Width := 65;
  btApply.Height := 30;
  btApply.Left := panel1.Width - btApply.Width - 5;
  btApply.Top := panel1.Height - btApply.Height - 10;

  panelcopypaste.Height := panel1.Height;

  panel2.Height := panel1.Height;
  btApply2.Width := btApply.Width;
  btApply2.Left := panel2.Width - btApply2.Width - 5;
  btApply2.Height := btApply.Height;
  btApply2.Top := btApply.top;

  panel3.Height := panel1.Height;
  btApply3.Width := btApply2.Width;
  btApply3.Height := btApply.Height;
  btApply3.Left := btApply2.Left;
  btApply3.Top := btApply.top;

end;

procedure Tfrm_multiselect.btnCopyPasteClicked(Sender: TObject);
var
  x, y, z, n, n2: integer;
  compname: string;
  wd: TWidgetDesigner;
  wgc: TVFDWidgetClass;
  wg, theWidget: TfpgWidget;
  okname: boolean;
  oriformdesigner: Tformdesigner;
begin
  fpgapplication.ProcessMessages;

  oriformdesigner := TformDesigner(TheSelectedForm.FormDesigner);
  TformDesigner(TheSelectedForm.FormDesigner).DeSelectAll;

  maindsgn.SaveUndo(Sender, 9);

  x := 0;
  while x < length(cbSelected) do
  begin
    if cbSelected[x].Checked = True then
    begin
      y := 0;
      while y < TheSelectedForm.ComponentCount do
      begin
        if Tfpgwidget(TheSelectedForm.Components[y]).Name = cbSelected[x].Text then
        begin

          theWidget := Tfpgwidget(TheSelectedForm.Components[y]);

          wg := nil;
          wgc := nil;

          for n := 0 to VFDWidgetCount - 1 do
          begin
            wgc := VFDWidget(n);
            if UpperCase(TheSelectedForm.Components[y].ClassName) = UpperCase(wgc.WidgetClass.ClassName) then
            begin
              wg := wgc.CreateWidget(TheSelectedForm);
              break;
            end;
          end;

          compname := TheSelectedForm.Components[y].Name + '1';
          okname := False;
          n2 := 1;

          while okname = False do
          begin
            for n := 0 to TheSelectedForm.ComponentCount - 1 do
            begin
              if compname = TheSelectedForm.Components[n].Name then
              begin
                compname := TheSelectedForm.Components[n].Name + IntToStr(n2);
                // break;
              end
              else
                okname := True;
            end;
            Inc(n2);
          end;

          wg.Name := compname;
          wg.FormDesigner := TheSelectedForm;
          wd := TformDesigner(TheSelectedForm.FormDesigner).AddWidget(wg, nil, oriformdesigner);
          wd.FVFDClass := wgc;

          wg.Left := Tfpgwidget(theWidget).left + 10;
          wg.top := Tfpgwidget(theWidget).top + 10;
          wg.Width := Tfpgwidget(theWidget).Width;
          wg.Height := Tfpgwidget(theWidget).Height;
          wg.BackgroundColor := Tfpgwidget(theWidget).BackgroundColor;
          wg.Enabled := Tfpgwidget(theWidget).Enabled;
          wg.Align := Tfpgwidget(theWidget).Align;
          wg.Anchors := Tfpgwidget(theWidget).Anchors;
          wg.Hint := Tfpgwidget(theWidget).Hint;
          wg.ShowHint := Tfpgwidget(theWidget).ShowHint;
          wg.TextColor := Tfpgwidget(theWidget).TextColor;

          if wg is Tfpglabel then
            Tfpglabel(wg).Text := Tfpglabel(theWidget).Text
          else

          if wg is Tfpgedit then
            Tfpgedit(wg).Text := Tfpgedit(theWidget).Text
          else

          if wg is TfpgPanel then
            TfpgPanel(wg).Text := TfpgPanel(theWidget).Text
          else

          if wg is TfpgButton then
            TfpgButton(wg).Text := TfpgButton(theWidget).Text
          else

          if wg is TfpgCheckBox then
            TfpgCheckBox(wg).Text := TfpgCheckBox(theWidget).Text
          else

          if wg is TfpgRadioButton then
            TfpgRadioButton(wg).Text := TfpgRadioButton(theWidget).Text
          else

          if wg is TfpgEditButton then
            TfpgEditButton(wg).Text := TfpgEditButton(theWidget).Text
          else

          if wg is TfpgGroupBox then
            TfpgGroupBox(wg).Text := TfpgGroupBox(theWidget).Text
          else

          if wg is TfpgTabSheet then
            TfpgTabSheet(wg).Text := TfpgTabSheet(theWidget).Text
          else

          if wg is TfpgHyperlink then
            TfpgHyperlink(wg).Text := TfpgHyperlink(theWidget).Text
          else

          if wg is TfpgStringGrid then
          begin
            TfpgStringGrid(wg).ColumnCount := TfpgStringGrid(theWidget).ColumnCount;

            z := 0;
            if TfpgStringGrid(theWidget).ColumnCount > 0 then
              while z < TfpgStringGrid(theWidget).ColumnCount do
              begin
                TfpgStringGrid(wg).ColumnWidth[z] := TfpgStringGrid(theWidget).ColumnWidth[z];
                TfpgStringGrid(wg).ColumnTextColor[z] :=
                  TfpgStringGrid(theWidget).ColumnTextColor[z];
                TfpgStringGrid(wg).ColumnBackgroundColor[z] :=
                  TfpgStringGrid(theWidget).ColumnBackgroundColor[z];
                TfpgStringGrid(wg).ColumnAlignment[z] :=
                  TfpgStringGrid(theWidget).ColumnAlignment[z];
                TfpgStringGrid(wg).ColumnTitle[z] := TfpgStringGrid(theWidget).ColumnTitle[z];
                Inc(z);
              end;
            TfpgStringGrid(wg).RowCount := TfpgStringGrid(theWidget).RowCount;
            TfpgStringGrid(wg).DefaultColWidth :=
              TfpgStringGrid(theWidget).DefaultColWidth;
            TfpgStringGrid(wg).DefaultRowHeight :=
              TfpgStringGrid(theWidget).DefaultRowHeight;
            TfpgStringGrid(wg).HeaderStyle := TfpgStringGrid(theWidget).HeaderStyle;
            TfpgStringGrid(wg).AlternateBGColor :=
              TfpgStringGrid(theWidget).AlternateBGColor;
            TfpgStringGrid(wg).HeaderHeight := TfpgStringGrid(theWidget).HeaderHeight;
            TfpgStringGrid(wg).FontDesc := TfpgStringGrid(theWidget).FontDesc;
            TfpgStringGrid(wg).HeaderFontDesc := TfpgStringGrid(theWidget).HeaderFontDesc;
            TfpgStringGrid(wg).RowCount := TfpgStringGrid(theWidget).RowCount;
            TfpgStringGrid(wg).ScrollBarStyle := TfpgStringGrid(theWidget).ScrollBarStyle;
            TfpgStringGrid(wg).Options := TfpgStringGrid(theWidget).Options;
            TfpgStringGrid(wg).ShowGrid := TfpgStringGrid(theWidget).ShowGrid;
            TfpgStringGrid(wg).ShowHeader := TfpgStringGrid(theWidget).ShowHeader;
            TfpgStringGrid(wg).BorderStyle := TfpgStringGrid(theWidget).BorderStyle;
            TfpgStringGrid(wg).TextColor := TfpgStringGrid(theWidget).TextColor;
          end;

          wg.UpdateWindowPosition;

       {  TODO

          if (WidgetIsContainer = true) and (theWidget.ComponentCount > 0) then
          begin
          WidgetOwner := theWidget;

          newWidgetOwner := wg;


       //   newWidgetOwner.FormDesigner:= TformDesigner.Create;


      //  newWidgetOwner.FormDesigner:= theWidget.FormDesigner;

         // TFormDesigner(newWidgetOwner.FormDesigner).Form.Name := wg.name;

          z := 0 ;

          writeln('WidgetOwner.ComponentCount = ' + inttostr(WidgetOwner.ComponentCount));
            writeln('WidgetOwner.name = ' + (WidgetOwner.Name));
           while z < WidgetOwner.ComponentCount do
    begin

          theWidget := Tfpgwidget(WidgetOwner.Components[z]);

           writeln('Widget name = ' + theWidget.Name);

          wg := nil;
          wgc := nil;

          fpgapplication.ProcessMessages;

          for n := 0 to VFDWidgetCount - 1 do
          begin
            wgc := VFDWidget(n);
            if UpperCase(theWidget.ClassName) =
              UpperCase(wgc.WidgetClass.ClassName) then
            begin
              wg := wgc.CreateWidget(newWidgetOwner);
              writeln('Widget Class name = ' + theWidget.ClassName);
              break;
            end;
          end;

          compname := WidgetOwner.Components[z].Name + '2';
           writeln('new Widget name = ' + compname);
          okname := False;
          n2 := 2;

          while okname = False do
          begin
            for n := 0 to WidgetOwner.ComponentCount - 1 do
            begin
              if compname = WidgetOwner.Components[n].Name then
              begin
                compname := WidgetOwner.Components[n].Name + IntToStr(n2);
                // break;
              end
              else
                okname := True;
            end;
            Inc(n2);
          end;

          wg.Name := compname;
           writeln('brand new Widget name = ' +  wg.Name);

     wg.FormDesigner := TheSelectedForm.FormDesigner ;

     wd := TformDesigner(wg.FormDesigner).AddWidget(wg, wgc, tformdesigner(wg.FormDesigner));

     //   wd := TformDesigner(newWidgetOwner.FormDesigner).AddWidget(wg, wgc, tformdesigner(newWidgetOwner.FormDesigner));

        //     wd := TformDesigner(TheSelectedForm.FormDesigner).AddWidget(wg, nil, oriformdesigner);

         wd.FVFDClass := wgc;

            wg.Left := Tfpgwidget(theWidget).left;
          wg.top := Tfpgwidget(theWidget).top ;
          wg.Width := Tfpgwidget(theWidget).Width;
          wg.Height := Tfpgwidget(theWidget).Height;
          wg.BackgroundColor := Tfpgwidget(theWidget).BackgroundColor;
          wg.Enabled := Tfpgwidget(theWidget).Enabled;
          wg.Align := Tfpgwidget(theWidget).Align;
          wg.Anchors := Tfpgwidget(theWidget).Anchors;
          wg.Hint := Tfpgwidget(theWidget).Hint;
          wg.ShowHint := Tfpgwidget(theWidget).ShowHint;
          wg.TextColor := Tfpgwidget(theWidget).TextColor;

          if wg is Tfpglabel then
            Tfpglabel(wg).Text := Tfpglabel(theWidget).Text else

          if wg is Tfpgedit then
          Tfpgedit(wg).Text := Tfpgedit(theWidget).Text else

          if wg is TfpgPanel then
            TfpgPanel(wg).Text := TfpgPanel(theWidget).Text else

          if wg is TfpgButton then
            TfpgButton(wg).Text := TfpgButton(theWidget).Text else

          if wg is TfpgCheckBox then
            TfpgCheckBox(wg).Text := TfpgCheckBox(theWidget).Text else

          if wg is TfpgRadioButton then
            TfpgRadioButton(wg).Text := TfpgRadioButton(theWidget).Text else

           if wg is TfpgEditButton then
            TfpgEditButton(wg).Text := TfpgEditButton(theWidget).Text else

           if wg is TfpgGroupBox then
            TfpgGroupBox(wg).Text := TfpgGroupBox(theWidget).Text else

           if wg is TfpgTabSheet then
            TfpgTabSheet(wg).Text := TfpgTabSheet(theWidget).Text else

            if wg is TfpgHyperlink then
            TfpgHyperlink(wg).Text := TfpgHyperlink(theWidget).Text else

          if wg is TfpgStringGrid then
          begin
            TfpgStringGrid(wg).ColumnCount:= TfpgStringGrid(theWidget).ColumnCount;

            n := 0;
           if TfpgStringGrid(theWidget).ColumnCount > 0 then
           while n < TfpgStringGrid(theWidget).ColumnCount do
            begin
            TfpgStringGrid(wg).ColumnWidth[n]:= TfpgStringGrid(theWidget).ColumnWidth[n];
            TfpgStringGrid(wg).ColumnTextColor[n]:= TfpgStringGrid(theWidget).ColumnTextColor[n];
            TfpgStringGrid(wg).ColumnBackgroundColor[n]:= TfpgStringGrid(theWidget).ColumnBackgroundColor[n];
            TfpgStringGrid(wg).ColumnAlignment[n]:= TfpgStringGrid(theWidget).ColumnAlignment[n];
            TfpgStringGrid(wg).ColumnTitle[n]:= TfpgStringGrid(theWidget).ColumnTitle[n];
            inc(n);
            end;
            TfpgStringGrid(wg).RowCount:= TfpgStringGrid(theWidget).RowCount;
            TfpgStringGrid(wg).DefaultColWidth:= TfpgStringGrid(theWidget).DefaultColWidth;
            TfpgStringGrid(wg).DefaultRowHeight:= TfpgStringGrid(theWidget).DefaultRowHeight;
            TfpgStringGrid(wg).HeaderStyle:= TfpgStringGrid(theWidget).HeaderStyle;
            TfpgStringGrid(wg).AlternateBGColor:= TfpgStringGrid(theWidget).AlternateBGColor;
            TfpgStringGrid(wg).HeaderHeight:= TfpgStringGrid(theWidget).HeaderHeight;
            TfpgStringGrid(wg).FontDesc:= TfpgStringGrid(theWidget).FontDesc;
            TfpgStringGrid(wg).HeaderFontDesc:= TfpgStringGrid(theWidget).HeaderFontDesc;
            TfpgStringGrid(wg).RowCount:= TfpgStringGrid(theWidget).RowCount;
            TfpgStringGrid(wg).ScrollBarStyle:= TfpgStringGrid(theWidget).ScrollBarStyle;
            TfpgStringGrid(wg).Options:= TfpgStringGrid(theWidget).Options;
            TfpgStringGrid(wg).ShowGrid:= TfpgStringGrid(theWidget).ShowGrid;
            TfpgStringGrid(wg).ShowHeader:= TfpgStringGrid(theWidget).ShowHeader;
            TfpgStringGrid(wg).BorderStyle:= TfpgStringGrid(theWidget).BorderStyle;
            TfpgStringGrid(wg).TextColor:= TfpgStringGrid(theWidget).TextColor;
           end;

            wg.UpdateWindowPosition;


           inc(z);
       end;
         end;

     //   } /// end TODO

        end;
        Inc(y);
      end;
    end;
    Inc(x);
  end;
  Getwidgetlist(TheSelectedForm);
end;

procedure Tfrm_multiselect.btnDeleteClicked(Sender: TObject);
var
  x, y: integer;

begin
  x := 0;
  TformDesigner(TheSelectedForm.FormDesigner).DeSelectAll;
  maindsgn.SaveUndo(Sender, 10);

  fpgapplication.ProcessMessages;

  while x < length(cbSelected) do
  begin
    if cbSelected[x].Checked = True then
    begin
      y := 0;
      while y < TheSelectedForm.ComponentCount do
      begin
        if Tfpgwidget(TheSelectedForm.Components[y]).Name = cbSelected[x].Text then
        begin
          TFormDesigner(TheSelectedForm.FormDesigner).WidgetDesigner(Tfpgwidget(TheSelectedForm.Components[y])).FSelected := True;
        end;
        Inc(y);
      end;
    end;
    Inc(x);
  end;

  TFormDesigner(TheSelectedForm.FormDesigner).DeleteWidgets;

  TformDesigner(TheSelectedForm.FormDesigner).DeSelectAll;

  Getwidgetlist(TheSelectedForm);
end;

procedure Tfrm_multiselect.onScrollChange(Sender: TObject; position: integer);
begin
  PanelScroll.Top := -1 * scroll1.Position;
  PanelScroll.UpdateWindowPosition;
end;

procedure Tfrm_multiselect.btnApply1Clicked(Sender: TObject);
var
  x, y: integer;
begin
  x := 0;
  fpgapplication.ProcessMessages;
  TformDesigner(TheSelectedForm.FormDesigner).DeSelectAll;

  maindsgn.SaveUndo(Sender, 8);

  while x < length(cbSelected) do
  begin
    if cbSelected[x].Checked = True then
    begin
      y := 0;
      while y < TheSelectedForm.ComponentCount do
      begin
        if Tfpgwidget(TheSelectedForm.Components[y]).Name = cbSelected[x].Text then
        begin
          if cbleft.Checked then
            Tfpgwidget(TheSelectedForm.Components[y]).left := edleft.Value;
          if cbtop.Checked then
            Tfpgwidget(TheSelectedForm.Components[y]).top := edtop.Value;
          if cbwidth.Checked then
            Tfpgwidget(TheSelectedForm.Components[y]).Width := edwidth.Value;
          if cbheight.Checked then
            Tfpgwidget(TheSelectedForm.Components[y]).Height := edheight.Value;
          Tfpgwidget(TheSelectedForm.Components[y]).UpdateWindowPosition;
        end;
        Inc(y);
      end;
    end;
    Inc(x);
  end;
  // fpgapplication.ProcessMessages;
  Procupdategrid(TheSelectedForm);
end;

procedure Tfrm_multiselect.btnApply2Clicked(Sender: TObject);
var
  x, y, widcheck, firsttop, firstleft, firstwidth, firstheight: integer;
  firstupwidget: boolean;
begin
  x := 0;
  firstupwidget := True;
  widcheck := 0;
  fpgapplication.ProcessMessages;
  maindsgn.SaveUndo(Sender, 8);

  TformDesigner(TheSelectedForm.FormDesigner).DeSelectAll;

  while x < length(cbSelected) do
  begin
    if cbSelected[x].Checked = True then
    begin
      y := 0;
      while y < TheSelectedForm.ComponentCount do
      begin
        if (Tfpgwidget(TheSelectedForm.Components[y]).Name = cbSelected[x].Text) then
        begin
          if firstupwidget = True then
          begin
            firsttop := Tfpgwidget(TheSelectedForm.Components[y]).top;
            firstleft := Tfpgwidget(TheSelectedForm.Components[y]).left;
            firstwidth := Tfpgwidget(TheSelectedForm.Components[y]).Width;
            firstheight := Tfpgwidget(TheSelectedForm.Components[y]).Height;
            firstupwidget := False;
          end
          else
          begin
            Inc(widcheck);
            if cbleft2.Checked then
              Tfpgwidget(TheSelectedForm.Components[y]).left :=
                firstleft + (widcheck * edleft2.Value);
            if cbtop2.Checked then
              Tfpgwidget(TheSelectedForm.Components[y]).top :=
                firsttop + (widcheck * edtop2.Value);
            if cbwidth2.Checked then
              Tfpgwidget(TheSelectedForm.Components[y]).Width :=
                firstwidth + (widcheck * edwidth2.Value);
            if cbheight2.Checked then
              Tfpgwidget(TheSelectedForm.Components[y]).Height :=
                firstheight + (widcheck * edheight2.Value);
            Tfpgwidget(TheSelectedForm.Components[y]).UpdateWindowPosition;
          end;
        end;
        Inc(y);
      end;

    end;
    Inc(x);
  end;
  // fpgapplication.ProcessMessages;
  Procupdategrid(TheSelectedForm);
end;

procedure Tfrm_multiselect.btnApply3Clicked(Sender: TObject);
var
  x, y: integer;

begin
  fpgapplication.ProcessMessages;
  x := 0;
  maindsgn.SaveUndo(Sender, 8);
  TformDesigner(TheSelectedForm.FormDesigner).DeSelectAll;

  while x < length(cbSelected) do
  begin
    if cbSelected[x].Checked = True then
    begin
      y := 0;
      while y < TheSelectedForm.ComponentCount do
      begin
        if Tfpgwidget(TheSelectedForm.Components[y]).Name = cbSelected[x].Text then
        begin
          if cbleft3.Checked then
            Tfpgwidget(TheSelectedForm.Components[y]).left :=
              Tfpgwidget(TheSelectedForm.Components[y]).left + edleft3.Value;
          if cbtop3.Checked then
            Tfpgwidget(TheSelectedForm.Components[y]).top :=
              Tfpgwidget(TheSelectedForm.Components[y]).top + edtop3.Value;
          if cbwidth3.Checked then
            Tfpgwidget(TheSelectedForm.Components[y]).Width :=
              Tfpgwidget(TheSelectedForm.Components[y]).Width + edwidth3.Value;
          if cbheight3.Checked then
            Tfpgwidget(TheSelectedForm.Components[y]).Height :=
              Tfpgwidget(TheSelectedForm.Components[y]).Height + edheight3.Value;

          Tfpgwidget(TheSelectedForm.Components[y]).UpdateWindowPosition;
        end;
        Inc(y);
      end;
    end;
    Inc(x);
  end;
  Procupdategrid(TheSelectedForm);
end;

procedure Tfrm_multiselect.btnunselectall(Sender: TObject);
var
  x: integer;
begin
  x := 0;
  while x < length(cbSelected) do
  begin
    cbSelected[x].Checked := False;
    Inc(x);
  end;
end;

procedure Tfrm_multiselect.SelectedFromDesigner(TheSelected: TfpgWidget);
var
  x: integer;
begin

  if Visible = True then
  begin
    fpgapplication.ProcessMessages;
    x := 0;
    while x < length(cbSelected) do
    begin
      if TheSelected.Name = cbSelected[x].Text then
      begin
        cbSelected[x].Checked := True;
        Exit;
      end;
      Inc(x);
    end;
  end;

end;

procedure Tfrm_multiselect.btnselectall(Sender: TObject);
var
  x: integer;
begin

  x := 0;
  while x < length(cbSelected) do
  begin
    cbSelected[x].Checked := True;
    Inc(x);
  end;
end;

procedure Tfrm_multiselect.Getwidgetlist(Theobj: TfpgWidget);
begin
  if ((Visible = True) and (maindsgn.selectedform <> nil)) or (calculwidget = True) then
  begin
    fpgapplication.ProcessMessages;

    if (Tfpgwidget(TheSelectedForm) <> Tfpgwidget(Theobj)) or (Theobj.ComponentCount <> oricount) then
    begin
      oricount := Theobj.ComponentCount;
      TheSelectedForm := Theobj;

      if TheSelectedForm is tfpgpagecontrol then else   /// not working with tfpgpagecontrol
       ProcGetwidgetlist(TheSelectedForm);
    end;
  end;
end;

procedure Tfrm_multiselect.Procupdategrid(Theobj: TfpgWidget);
var
  x: integer;
begin
  grid1.rowCount := 0;
  x := 0;
  while x < Theobj.ComponentCount do
  begin
    if Tfpgwidget(Theobj.Components[x]).Name <> '' then
    begin
      grid1.rowCount := x + 1;
      grid1.Cells[0, x] := IntToStr(Tfpgwidget(Theobj.Components[x]).left);
      grid1.Cells[1, x] := IntToStr(Tfpgwidget(Theobj.Components[x]).top);
      grid1.Cells[2, x] := IntToStr(Tfpgwidget(Theobj.Components[x]).Width);
      grid1.Cells[3, x] := IntToStr(Tfpgwidget(Theobj.Components[x]).Height);
    end;
    Inc(x);
  end;
  grid1.UpdateWindowPosition;
end;

procedure Tfrm_multiselect.ClearAll;
var
  x: integer;
begin
  calculwidget := False;
  hide;
  if (maindsgn.selectedform <> nil) then
  begin

    x := 0;

    while x < length(cbSelected) do
    begin
      cbSelected[x].Visible := False;
      Inc(x);
    end;
    grid1.rowCount := 0;
    grid1.Height := 1;
    grid1.UpdateWindowPosition;
    panelscroll.Visible := False;
    windowtitle := 'Click on one widget to load Multi-Selector';
    Height := 2;
    UpdateWindowPosition;
  end;
  calculwidget := True;
end;


procedure Tfrm_multiselect.ProcGetwidgetlist(Theobj: TfpgWidget);
var
  x: integer;
  sakloaded : boolean = false;
begin
  calculwidget := False;
 if SakIsEnabled = true then
 begin
 sakloaded := true ;
  saksuspend ;
  end;

  if (maindsgn.selectedform <> nil) then
  begin
    fpgapplication.ProcessMessages;
    // hide;
    x := 0;
    Panelscroll.Visible := False;
    TformDesigner(TheSelectedForm.FormDesigner).DeSelectAll;

    while x < length(cbSelected) do
    begin
      cbSelected[x].Visible := False;
      cbSelected[x] := nil;
      cbSelected[x].Free;
      Inc(x);
    end;

    setlength(cbSelected, 0);
    grid1.rowCount := 0;
    x := 0;

    while x < Theobj.ComponentCount do
    begin
      if Tfpgwidget(Theobj.Components[x]).Name <> '' then
      begin
        setlength(cbSelected, length(cbSelected) + 1);
        cbSelected[x] := Tfpgcheckbox.Create(Panelscroll);
        cbSelected[x].BackgroundColor := $7D7D7D;
        cbSelected[x].Text := Tfpgwidget(Theobj.Components[x]).Name;
        cbSelected[x].TextColor := clwhite;
        cbSelected[x].Left := 8;
        cbSelected[x].Width := 150;
        cbSelected[x].Top := (x * 19) + 2;
        cbSelected[x].Height := 18;
        cbSelected[x].Checked := False;
        cbSelected[x].UpdateWindowPosition;
        cbSelected[x].Visible := True;

        grid1.rowCount := x + 1;

        grid1.Cells[0, x] := IntToStr(Tfpgwidget(Theobj.Components[x]).left);
        grid1.Cells[1, x] := IntToStr(Tfpgwidget(Theobj.Components[x]).top);
        grid1.Cells[2, x] := IntToStr(Tfpgwidget(Theobj.Components[x]).Width);
        grid1.Cells[3, x] := IntToStr(Tfpgwidget(Theobj.Components[x]).Height);

      end;
      Inc(x);
    end;

    if Theobj.ComponentCount = 0 then
      windowtitle := 'Form ' + Theobj.Name
    else
    if Theobj.ComponentCount > 1 then
      windowtitle := 'The ' + IntToStr(Theobj.ComponentCount) + ' Widgets of ' + Theobj.Name
    else
      windowtitle := 'The only Widget of ' + Theobj.Name;

    if (length(cbSelected) * 19) + (3 * panel1.Height) + 22 < frmProperties.Height then
    begin
      Height := (length(cbSelected) * 19) + (3 * panel1.Height) + 26;
      panelscroll.Width := Width;
      Grid1.ColumnWidth[0] := 74;
      Grid1.ColumnWidth[1] := Grid1.ColumnWidth[0];
      Grid1.ColumnWidth[2] := Grid1.ColumnWidth[0];
      Grid1.ColumnWidth[3] := Grid1.ColumnWidth[0];

      lbleft.SetPosition(161, 1, 72, 18);
      lbtop.SetPosition(235, 1, 72, 18);
      lbwidth.SetPosition(309, 1, 72, 18);
      lbheight.SetPosition(383, 1, 74, 18);
      grid1.Width := 300;
      scroll1.Visible := False;
    end
    else
    begin
      Height := frmProperties.Height;
      panelscroll.Width := Width - 26;
      Grid1.ColumnWidth[0] := 69;
      Grid1.ColumnWidth[1] := Grid1.ColumnWidth[0];
      Grid1.ColumnWidth[2] := Grid1.ColumnWidth[0];
      Grid1.ColumnWidth[3] := Grid1.ColumnWidth[0];

      lbleft.SetPosition(161, 1, 67, 18);
      lbtop.SetPosition(230, 1, 67, 18);
      lbwidth.SetPosition(299, 1, 67, 18);
      lbheight.SetPosition(368, 1, 69, 18);

      grid1.Width := 280;
      scroll1.Visible := True;
      scroll1.top := 0;
      scroll1.Height := panelmain.Height - 10;
      scroll1.Width := 16;
      scroll1.left := grid1.Right + 1;
      scroll1.Position := 0;
    end;

    panelscroll.Height := (length(cbSelected) * 19) + 10;
    panelmain.Height := Height - (3 * panel1.Height) - 20;

    if scroll1.Visible = True then
    begin
      scroll1.Height := panelmain.Height - 4;
      scroll1.PageSize := 19 * (panelmain.Height div 19);
      scroll1.ScrollStep := 19;
      scroll1.max := (panelscroll.Height - panelmain.Height - 2);
      scroll1.min := 0;
    end;

    grid1.Height := (length(cbSelected) * 19) + 4;

    grid1.top := 0;
    grid1.left := 159;

    panelscroll.Top := 0;

    panel1.top := Height - (3 * panel1.Height) - 3;
    panelcopypaste.Top := panel1.top;
    panel2.top := Height - (2 * panel1.Height) - 3;
    panel3.top := Height - panel2.Height - 2;

    panel1.UpdateWindowPosition;
    panel2.UpdateWindowPosition;
    panel3.UpdateWindowPosition;
    panelcopypaste.UpdateWindowPosition;
    grid1.UpdateWindowPosition;
    panelscroll.UpdateWindowPosition;
    scroll1.UpdateWindowPosition;
    panelmain.UpdateWindowPosition;

    lbleft.UpdateWindowPosition;
    lbtop.UpdateWindowPosition;
    lbwidth.UpdateWindowPosition;
    lbheight.UpdateWindowPosition;
    grid1.Visible := True;
    panelscroll.Visible := True;
    UpdateWindowPosition;
    Show;
  end;
  calculwidget := True;
  if sakloaded = true then sakupdate;

end;

procedure Tfrm_multiselect.onDestroyFrm(Sender: TObject);
var
  x: integer;
begin
  x := 0;
  while x < length(cbSelected) do
  begin
    cbSelected[x].Free;
    Inc(x);
  end;
  setlength(cbSelected, 0);
end;

end.
