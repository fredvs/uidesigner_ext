program testfpglib;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  SysUtils, Classes, fpg_base, fpg_main,
   plugmanager,
  {%units 'Auto-generated GUI code'}
  fpg_form, fpg_button
  {%endunits}
  ;

type
  Ttest = class(TfpgForm)
  private
    {@VFD_HEAD_BEGIN: test}
    Button1: TfpgButton;
    {@VFD_HEAD_END: test}
  public
    procedure AfterCreate; override;
  end;

{@VFD_NEWFORM_DECL}

{@VFD_NEWFORM_IMPL}

procedure Ttest.AfterCreate;
begin
  {%region 'Auto-generated GUI code' -fold}
  {@VFD_BODY_BEGIN: test}
  Name := 'test';
  SetPosition(459, 222, 300, 250);
  WindowTitle := 'test';
  Hint := '';
  BackGroundColor := $80000001;

  Button1 := TfpgButton.Create(self);
  with Button1 do
  begin
    Name := 'Button1';
    SetPosition(114, 92, 80, 23);
    FontDesc := '#Label1';
    Hint := '';
    ImageName := '';
    TabOrder := 1;
    Text := 'Button';
  end;

  {@VFD_BODY_END: test}
  {%endregion}
end;


procedure MainProc;
var
  frm: Ttest;
begin
  fpgApplication.Initialize;
  try
    fpgd_loadlib('/home/fred/designer_ext/src/libfpgdxt.so') ;
    frm := Ttest.Create(nil);
    fpgApplication.MainForm := frm;
    frm.Show;
    fpgApplication.Run;
    
  finally
   fpgd_mainproc();
    frm.Free;
  end;
end;

begin
  MainProc;
end.
