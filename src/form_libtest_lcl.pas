unit form_libtest_lcl;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF UNIX}
  cthreads, {$ENDIF}
  h_fpgdxt, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label1: TLabel;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  if   fpgdxtloadlib('/home/fred/designer_ext/src/libfpgdxt.so') then
 label1.Caption:='libfpgdxt.so loaded. ;-)' else label1.Caption:='libfpgdxt.so not loaded. ;-('  ;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
//    timer1.Enabled:=true;
   fpgdxtmainproc();

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  fpgdxtshow();
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
    application.ProcessMessages;
  form1.Caption:='hello' + timetostr(now);
end;

procedure TForm1.FormClick(Sender: TObject);
begin
  application.ProcessMessages;
  form1.Caption:='hello' + timetostr(now);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 application.ProcessMessages;
  form1.Caption:='hello' + timetostr(now);
end;

procedure TForm1.FormResize(Sender: TObject);
begin

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 Timer1.Enabled:=false;
 //   fpgdxtprocessmessages();
 //Timer1.Enabled:=true;
end;

end.

