
unit plugmanager ;
{This for loading/managing plugin

 Fred van Stappen / fiens@hotmail.com
}

////////////////////////////////////////////////////////////////////////////////

/// for custom compil, like using fpgui-dvelop =>  edit define.inc
// {$I define.inc}

interface

uses
{$IFDEF UNIX}
  cthreads, {$ENDIF}
 // msethreads,
  Classes,  SysUtils,
  h_fpgdxt ;
  
type
   TPlugin = class(TThread)
  protected
 //  evPause: PRTLEvent;  // for pausing
    procedure Execute; override;
     public
  constructor Create(CreateSuspended: boolean;
      const StackSize: SizeUInt = DefaultStackSize);
end;

//// fpGui designer_ext
procedure fpgd_mainproc(); 
function fpgd_loadlib(const libfilename: string): boolean; 
procedure fpgd_unloadlib;
procedure fpgd_hide();
procedure fpgd_close();
function fpgd_loadfile(afilename : PChar) : integer ;

var
fpgdlib_isloaded : boolean = false;
fpgdlib_enabled : boolean = true;
fpgdprog_enabled : boolean = false;
fpgplug : TPlugin ;


implementation

 constructor TPlugin.Create(CreateSuspended: boolean;
  const StackSize: SizeUInt);
  begin
  //evPause := RTLEventCreate;
   inherited Create(CreateSuspended, StackSize);
  FreeOnTerminate := true;
  Priority :=  tpTimeCritical;
   
    end;
 
 
 //// fpgui designer_ext

 procedure TPlugin.execute;
  begin
   fpgdxtloadlib('/home/fred/designer_ext/src/libfpgdxt.so')  ;
   fpgdxtmainproc() ;
    end;

function fpgd_loadlib(const libfilename: string): boolean;
begin
// fpgdlib_isloaded := h_fpgdxt.fpgdxtloadlib(libfilename);
// result := fpgdlib_isloaded ;
fpgplug  := TPlugin.Create(true) ;
end;

procedure fpgd_unloadlib();
begin
h_fpgdxt.fpgdxtunloadlib() ;
fpgdlib_enabled := false;
end;

 procedure fpgd_hide(); 
 begin
   h_fpgdxt.fpgdxthide();
 end;
 
 procedure fpgd_close(); 
 begin
   h_fpgdxt.fpgdxtclose();
 end;
 
function fpgd_loadfile(afilename : PChar) : integer ;
 begin
  result := -1;
  if FileExists(afilename) then
  begin
  result := h_fpgdxt.fpgdxtloadfile(afilename);
  end;
  end;
 
  procedure fpgd_mainproc(); 
  begin
     fpgplug.execute;
    end;
    
end.
