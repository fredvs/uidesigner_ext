program testlib_lcl;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, h_fpgdxt, form_libtest_lcl
  { you can add units after this };

{$R *.res}

begin
    Application.Initialize;
  Application.CreateForm(TForm1, Form1);
      Application.Run;
end.

