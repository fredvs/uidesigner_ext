{
This is part of the extended version of fpGUI uidesigner => Designer_ext.
With window list, undo feature, integration into IDE, editor launcher, extra-properties editor,...

Fred van Stappen
fiens@hotmail.com
2013 - 2014
}
unit frm_multiselect;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, fpg_base, fpg_Grid, fpg_button, fpg_Edit, fpg_main,
  fpg_label, fpg_panel,
  fpg_checkbox, fpg_widget, fpg_constants, fpg_ListView, fpg_spinedit, fpg_form;

type

  Tfrm_multiselect = class(TfpgForm)
  private
    {@VFD_HEAD_BEGIN: frm_multiselect}
    Grid1: TfpgStringGrid;
    Panel1: TfpgPanel;
    cbleft: TfpgCheckBox;
    edleft: TfpgSpinEdit;
    cbwidth: TfpgCheckBox;
    edwidth: TfpgSpinEdit;
    cbtop: TfpgCheckBox;
    edtop: TfpgSpinEdit;
    cbHeight: TfpgCheckBox;
    edheight: TfpgSpinEdit;
    btApply: TfpgButton;
    Panel2: TfpgPanel;
    cbleft2: TfpgCheckBox;
    edleft2: TfpgSpinEdit;
    cbwidth2: TfpgCheckBox;
    edwidth2: TfpgSpinEdit;
    cbtop2: TfpgCheckBox;
    edtop2: TfpgSpinEdit;
    cbHeight2: TfpgCheckBox;
    edheight2: TfpgSpinEdit;
    btApply2: TfpgButton;
    Panel3: TfpgPanel;
    cbleft3: TfpgCheckBox;
    edleft3: TfpgSpinEdit;
    cbwidth3: TfpgCheckBox;
    edwidth3: TfpgSpinEdit;
    cbtop3: TfpgCheckBox;
    edtop3: TfpgSpinEdit;
    cbHeight3: TfpgCheckBox;
    edheight3: TfpgSpinEdit;
    btApply3: TfpgButton;
    btSelectAll: TfpgButton;
    btUnSelectAll: TfpgButton;
    {@VFD_HEAD_END: frm_multiselect}
  public
    cbSelected: array of Tfpgcheckbox;
    procedure AfterCreate; override;
    procedure btnApply1Clicked(Sender: TObject);
    procedure btnApply2Clicked(Sender: TObject);
    procedure btnApply3Clicked(Sender: TObject);
    procedure btnQuitClicked(Sender: TObject);
    procedure btnunselectall(Sender: TObject);
    procedure btnselectall(Sender: TObject);
    procedure Getwidgetlist(Theobj: TfpgWidget);
    procedure ProcGetwidgetlist(Theobj: TfpgWidget);
    procedure Procupdategrid(Theobj: TfpgWidget);
  end;

{@VFD_NEWFORM_DECL}

var
  TheSelectedForm: Tfpgwidget;
  oricount: integer;
  frmMultiSelect: Tfrm_multiselect;

implementation

uses
  frm_main_designer, vfd_main;



{@VFD_NEWFORM_IMPL}

procedure Tfrm_multiselect.AfterCreate;
begin
  {%region 'Auto-generated GUI code' -fold}

  {@VFD_BODY_BEGIN: frm_multiselect}
  Name := 'frm_multiselect';
  SetPosition(95, 212, 464, 117);
  WindowTitle := 'Multi-Selector';
  Hint := '';
  BackGroundColor := $E8E8E8;
  Visible := False;
  WindowPosition := wpUser;

  Grid1 := TfpgStringGrid.Create(self);
  with Grid1 do
  begin
    Name := 'Grid1';
    SetPosition(172, 2, 284, 36);
    BackgroundColor := TfpgColor($80000002);
    AddColumn('Left', 70, taLeftJustify);
    AddColumn('Top', 70, taLeftJustify);
    AddColumn('Width', 70, taLeftJustify);
    AddColumn('Height', 70, taLeftJustify);
    FontDesc := '#Grid';
    HeaderFontDesc := '#GridHeader';
    Hint := '';
    RowCount := 0;
    RowSelect := False;
    TabOrder := 2;
    Visible := False;
    DefaultRowHeight := 19;
  end;

  Panel1 := TfpgPanel.Create(self);
  with Panel1 do
  begin
    Name := 'Panel1';
    SetPosition(9, 42, 447, 70);
    FontDesc := '#Label1';
    Hint := '';
    Text := '';
  end;

  cbleft := TfpgCheckBox.Create(Panel1);
  with cbleft do
  begin
    Name := 'cbleft';
    SetPosition(15, 6, 80, 18);
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
    SetPosition(80, 4, 50, 22);
    FontDesc := '#Edit1';
    Hint := '';
    TabOrder := 3;
    Value := 0;
  end;

  cbwidth := TfpgCheckBox.Create(Panel1);
  with cbwidth do
  begin
    Name := 'cbwidth';
    SetPosition(164, 6, 80, 18);
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
    SetPosition(244, 4, 50, 22);
    FontDesc := '#Edit1';
    Hint := '';
    TabOrder := 5;
    Value := 0;
  end;

  cbtop := TfpgCheckBox.Create(Panel1);
  with cbtop do
  begin
    Name := 'cbtop';
    SetPosition(15, 30, 78, 18);
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
    SetPosition(80, 28, 50, 22);
    FontDesc := '#Edit1';
    Hint := '';
    TabOrder := 8;
    Value := 0;
  end;

  cbHeight := TfpgCheckBox.Create(Panel1);
  with cbHeight do
  begin
    Name := 'cbHeight';
    SetPosition(164, 30, 80, 18);
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
    SetPosition(244, 28, 50, 22);
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
    SetPosition(9, 42, 447, 70);
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
    SetPosition(9, 42, 447, 70);
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

  btSelectAll := TfpgButton.Create(self);
  with btSelectAll do
  begin
    Name := 'btSelectAll';
    SetPosition(10, 1, 75, 18);
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
    SetPosition(86, 1, 85, 18);
    FontDesc := '#Label1';
    Hint := '';
    ImageName := '';
    TabOrder := 6;
    Text := 'Unselect all';
    OnClick := @btnunselectall;
  end;

  {@VFD_BODY_END: frm_multiselect}
  {%endregion}
  panel1.Height := 55;

  btApply.Width := 65;
  btApply.Height := 30;
  btApply.Left := panel1.Width - btApply.Width - 5;
  btApply.Top := panel1.Height - btApply.Height - 10;

  panel2.Height := panel1.Height;

  btApply2.Width := btApply.Width;
  btApply2.Height := btApply.Height;
  btApply2.Left := btApply.Left;
  btApply2.Top := btApply.top;

  panel3.Height := panel1.Height;
  btApply3.Width := btApply.Width;
  btApply3.Height := btApply.Height;
  btApply3.Left := btApply.Left;
  btApply3.Top := btApply.top;

end;

procedure Tfrm_multiselect.btnApply1Clicked(Sender: TObject);
var
  x, y: integer;

begin
  x := 0;
  maindsgn.SaveUndo(Sender, 8);
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
  fpgapplication.ProcessMessages;

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
                firstleft + (widcheck * edheight2.Value);

            Tfpgwidget(TheSelectedForm.Components[y]).UpdateWindowPosition;
          end;
        end;
        Inc(y);
      end;

    end;
    Inc(x);
  end;

  fpgapplication.ProcessMessages;
  Procupdategrid(TheSelectedForm);

end;

procedure Tfrm_multiselect.btnApply3Clicked(Sender: TObject);
var
  x, y: integer;

begin
  x := 0;

  maindsgn.SaveUndo(Sender, 8);

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
  fpgapplication.ProcessMessages;

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
  if (TheSelectedForm <> Theobj) or (Theobj.ComponentCount <> oricount) then
  begin
    oricount := Theobj.ComponentCount;
    TheSelectedForm := Theobj;
    fpgapplication.ProcessMessages;
    ProcGetwidgetlist(TheSelectedForm);
  end;
end;

procedure Tfrm_multiselect.Procupdategrid(Theobj: TfpgWidget);
var
  x, y: integer;
begin

  grid1.rowCount := 0;
  fpgapplication.ProcessMessages;

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
  fpgapplication.ProcessMessages;
end;

procedure Tfrm_multiselect.ProcGetwidgetlist(Theobj: TfpgWidget);
var
  x, y: integer;
begin
  x := 0;

  while x < length(cbSelected) do
  begin
    cbSelected[x].Visible := False;
    cbSelected[x] := nil;
    cbSelected[x].Free;
    Inc(x);
  end;

  setlength(cbSelected, 0);
  grid1.rowCount := 0;
  fpgapplication.ProcessMessages;

  x := 0;


  while x < Theobj.ComponentCount do
  begin
    if Tfpgwidget(Theobj.Components[x]).Name <> '' then
    begin
      setlength(cbSelected, length(cbSelected) + 1);
      cbSelected[x] := Tfpgcheckbox.Create(self);
      cbSelected[x].BackgroundColor := $7D7D7D;
      cbSelected[x].Text := Tfpgwidget(Theobj.Components[x]).Name;
      cbSelected[x].TextColor := clwhite;
      cbSelected[x].Left := 10;
      cbSelected[x].Width := 160;
      cbSelected[x].Top := (x * 19) + 19;
      cbSelected[x].Height := 18;
      cbSelected[x].Visible := True;
      cbSelected[x].Checked := False;
      cbSelected[x].UpdateWindowPosition;

      grid1.rowCount := x + 1;

      grid1.Cells[0, x] := IntToStr(Tfpgwidget(Theobj.Components[x]).left);
      grid1.Cells[1, x] := IntToStr(Tfpgwidget(Theobj.Components[x]).top);
      grid1.Cells[2, x] := IntToStr(Tfpgwidget(Theobj.Components[x]).Width);
      grid1.Cells[3, x] := IntToStr(Tfpgwidget(Theobj.Components[x]).Height);

    end;
    Inc(x);
  end;
  windowtitle := 'Selected components of form ' + Theobj.Name;
  grid1.Height := (length(cbSelected) * 19) + 21;
  Height := (length(cbSelected) * 19) + (3 * panel1.Height) + 26;
  panel1.top := Height - (3 * panel1.Height) - 6;
  panel2.top := Height - (2 * panel1.Height) - 6;
  panel3.top := Height - panel2.Height - 5;
  grid1.Visible := True;
  panel1.UpdateWindowPosition;
  panel2.UpdateWindowPosition;
  panel3.UpdateWindowPosition;
  grid1.UpdateWindowPosition;
  UpdateWindowPosition;
  fpgapplication.ProcessMessages;
end;

procedure Tfrm_multiselect.btnQuitClicked(Sender: TObject);
var
  x: integer;
begin
  while x < length(cbSelected) do
  begin
    cbSelected[x].Free;
    Inc(x);
  end;
  setlength(cbSelected, 0);
  hide;
end;

end.
