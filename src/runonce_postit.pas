(* 
RunOnce_PostIt allows your application to run only once.
If you try to run it again, you may post a message to the first running application.

It works for lcl, fpGUI, msei and console applications.

RunOnce procedure is (a lot of) inspired by LSRunOnce of LazSolutions, created 
by Silvio Clecio :  http://silvioprog.com.br 

Fred van Stappen
fiens@hotmail.com
*)

unit RunOnce_PostIt;

{$DEFINE fpgui}

interface

uses
  {$IFDEF MSWINDOWS}
  JwaTlHelp32,
{$ENDIF}
  fptimer,  
  SysUtils, Classes, Process;

type
  TProc = procedure of object;

type
  TOncePost = class(TObject)
  private
    TheProc: TProc;
    procedure InitMessage;
    function ExecProcess(const ACommandLine: string): string;
    procedure ListProcess(const AProcess: TStringList; const AShowPID: boolean = False;
      const ASorted: boolean = True; const AIgnoreCurrent: boolean = False);
    function PostIt: string;
  const
    CLSUtilsProcessNameValueSeparator: char = '=';

    procedure onTimerPost(Sender: TObject);
    function RunOnce(AMessage: string) : boolean;
    function IsRunningIDE(AProcess : string) :boolean;

  end;

function RunOnce(AMessage: string) : boolean; // if true the application is already loaded

procedure InitMessage;     
function IsRunningIDE(AProcess : string) :boolean;
procedure FreeRunOnce;
procedure StopMessage;
procedure StartMessage(AProc: Tproc; const AInterval: integer = 500);

var
   TheOncePost: TOncePost;
   TheMessage: string;
   ATimer: Tfptimer;

implementation

function RunOnce(AMessage: string): boolean; // if true the application is already loaded

begin
  TheOncePost := TOncePost.Create;
result :=  TheOncePost.RunOnce(AMessage);
end;

function IsRunningIDE(AProcess : string) :boolean;
begin
  if assigned(TheOncePost) then
 result := TheOncePost.IsRunningIDE(AProcess)
else
 result := true ;
end;

  procedure InitMessage ;     
begin
   if assigned(ATimer) = false then  TheOncePost.InitMessage;
end;
  
procedure StopMessage;
begin
  if assigned(ATimer) then
   begin
   ATimer.Enabled:=false;
   end;
end;

procedure StartMessage(AProc: Tproc; const AInterval: integer = 500);
begin
  ATimer.Enabled := false;
  TheOncePost.TheProc := AProc;
 ATimer.Interval := AInterval;
 ATimer.OnTimer := @TheOncePost.onTimerPost;
 ATimer.Enabled := True;
end;

procedure FreeRunOnce;
begin
   if assigned(ATimer) then
   begin
   ATimer.Enabled:=false;
   ATimer.free;
   end;
 if assigned(TheOncePost) then TheOncePost.Free;
end;


function TOncePost.PostIt: string;
var
  f: textfile;
begin
   Result := '';
  if fileexists(GetTempDir + '.postit.tmp') then
  begin
    AssignFile(f, PChar(GetTempDir + '.postit.tmp'));
    Reset(F);
    Readln(F, TheMessage);
    CloseFile(f);
    DeleteFile(GetTempDir + '.postit.tmp');
    Result := TheMessage;
  end;
end;

procedure TOncePost.onTimerPost(Sender: TObject);
begin
  ATimer.Enabled:=false;
  if PostIt <> '' then
    if TheProc <> nil then
      TheProc;
    ATimer.Enabled:=true;
 
end;

procedure TOncePost.InitMessage;
begin
   ATimer := TfpTimer.Create(nil);   
   ATimer.Enabled := false;
 end;
 
function TOncePost.ExecProcess(const ACommandLine: string): string;
const
  READ_BYTES = 2048;
var
  VStrTemp: TStringList;
  VMemoryStream: TMemoryStream;
  VProcess: TProcess;
  I64: longint;
  VBytesRead: longint;
begin
  VMemoryStream := TMemoryStream.Create;
  VProcess := TProcess.Create(nil);
  VStrTemp := TStringList.Create;
  try
    VBytesRead := 0;
{$WARN SYMBOL_DEPRECATED OFF}
    VProcess.CommandLine := ACommandLine;
{$WARN SYMBOL_DEPRECATED ON}
    VProcess.Options := [poUsePipes, poNoConsole];
    VProcess.Execute;
    while VProcess.Running do
    begin
      VMemoryStream.SetSize(VBytesRead + READ_BYTES);
      I64 := VProcess.Output.Read((VMemoryStream.Memory + VBytesRead)^, READ_BYTES);
      if I64 > 0 then
        Inc(VBytesRead, I64)
      else
        Sleep(100);
    end;
    repeat
      VMemoryStream.SetSize(VBytesRead + READ_BYTES);
      I64 := VProcess.Output.Read((VMemoryStream.Memory + VBytesRead)^, READ_BYTES);
      if I64 > 0 then
        Inc(VBytesRead, I64);
    until I64 <= 0;
    VMemoryStream.SetSize(VBytesRead);
    VStrTemp.LoadFromStream(VMemoryStream);
    Result := Trim(VStrTemp.Text);
  finally
    VStrTemp.Free;
    VProcess.Free;
    VMemoryStream.Free;
  end;
end;

procedure TOncePost.ListProcess(const AProcess: TStringList;
  const AShowPID: boolean; const ASorted: boolean; const AIgnoreCurrent: boolean);
var
{$IFDEF UNIX}
  I, J: integer;
  VOldNameValueSeparator: char;
{$ENDIF}
{$IFDEF MSWINDOWS}
  VSnapshotHandle: THandle;
  VProcessEntry32: TProcessEntry32;
{$ENDIF}
begin
{$IFDEF UNIX}
  VOldNameValueSeparator := AProcess.NameValueSeparator;
  AProcess.NameValueSeparator := CLSUtilsProcessNameValueSeparator;
 
  {$IFDEF FREEBSD}
     AProcess.Text := ExecProcess('sh -c "ps -A | awk ''{ print $5 "=" $1 }''"');
  {$ELSE}
     AProcess.Text := ExecProcess('sh -c "ps -A | awk ''{ print $4 "=" $1 }''"');
  {$ENDIF}
  
  // debug
  // writeln('Application list ');
  // writeln('---------------------------------');
  // writeln(AProcess.Text);
  // writeln('---------------------------------');
    
  J := AProcess.Count;
  for I := AProcess.Count downto 1 do
  begin
    if (I > J - 3) or (AIgnoreCurrent and
      (StrToIntDef(AProcess.ValueFromIndex[I - 1], -1) = integer(GetProcessID))) then
    begin
      AProcess.Delete(I - 1);
      Continue;
    end;
    if not AShowPID then
      AProcess.Strings[I - 1] := AProcess.Names[I - 1];
  end;
  AProcess.NameValueSeparator := VOldNameValueSeparator;
{$ENDIF}
{$IFDEF MSWINDOWS}
  try
    VSnapshotHandle := CreateToolHelp32SnapShot(TH32CS_SNAPALL, 0);
    VProcessEntry32.dwSize := SizeOf(TProcessEntry32);
    Process32First(VSnapshotHandle, VProcessEntry32);
    repeat
      if AIgnoreCurrent and (GetProcessID = VProcessEntry32.th32ProcessID) then
        Continue;
      if AShowPID then
        AProcess.Add(VProcessEntry32.szExeFile + CLSUtilsProcessNameValueSeparator +
          IntToStr(VProcessEntry32.th32ProcessID))
      else
        AProcess.Add(VProcessEntry32.szExeFile);
    until (not Process32Next(VSnapshotHandle, VProcessEntry32));
  except

  end;
{$ENDIF}
  if AProcess.Count > 0 then
    AProcess.Delete(0);
  AProcess.Sorted := ASorted;
end;

function TOncePost.RunOnce(AMessage: string): boolean; // if true the application is already loaded

var
  VProcess: TStringList;
  x, y: integer;
  f: textfile;
begin
  x := 0;
  y := 0;
  result := false;
  VProcess := TStringList.Create;
  
  if fileexists(GetTempDir + '.postit.tmp') then
     DeleteFile(GetTempDir + '.postit.tmp');
    
  ListProcess(VProcess, False, False, False);
  while (x < VProcess.Count) and (result = false) do
  begin
    if pos(ApplicationName, VProcess.Strings[x]) > 0 then
      Inc(y);
    if y > 1 then
    begin
    result := true;
    
  // debug
  // writeln('Application name');
  // writeln('---------------------------------');
  // writeln(VProcess.Strings[x]);
  // writeln('-----------------------------------');
  // writeln('A other instance is running');
   
   end;
    Inc(x);
  end;
 
      if (ParamStr(1) <> '') or  (Amessage <> '') then
     begin
        AssignFile(f, PChar(GetTempDir + '.postit.tmp'));
        rewrite(f);
        append(f);
        if Amessage = 'clear' then
        writeln(f, 'close') else  writeln(f, AMessage) ;
        Flush(f);
        CloseFile(f);
      end;
       
  VProcess.Free;
//  if result then else
// writeln('A unique instance is running and it it this one') ;
end;

function TOncePost.IsRunningIDE(AProcess : string) :boolean;
var
  VProcess: TStringList;
  x : integer;
  
  begin
  x := 0;
  result := false;
  VProcess := TStringList.Create;
  ListProcess(VProcess, False, False, False);
  while (x < VProcess.Count) and (result = false) do
  begin
    if pos(AProcess, VProcess.Strings[x]) > 0 then
     begin
     result := true;
     end;
   inc(x);
 end;
  VProcess.Free;
end;

end.
                                                                   
