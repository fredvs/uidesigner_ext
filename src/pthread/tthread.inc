{ This is the dynamic loader header of TThreads library.
    From original tthread.inc from fpc. 
    Copyright (c) 1999-2000 by Peter Vreman
       Fredvs ---> fiens@hotmail.com
} 

{$MACRO ON}

var
  ThreadsInited: boolean = false;
const
  Priorities: array [TThreadPriority] of Integer =
   (-20,-19,-10,0,9,18,19);

procedure DoneThreads;
begin
  ThreadsInited := false;
end;

function ThreadFunc(parameter: Pointer): ptrint;
var
  LThread: TThread;
  LFreeOnTerminate: boolean;

begin
   LThread := TThread(parameter);
  try
     if LThread.FInitialSuspended then
      begin
        RtlEventWaitFor(LThread.FSuspendEvent);
        if not(LThread.FTerminated) then
          begin
            if not LThread.FSuspended then
              begin
                LThread.FInitialSuspended := false;
                CurrentThreadVar := LThread;
                  LThread.Execute;
              end
             end
           end
     else
       begin
         LThread.FSuspendedInternal := true;
         RtlEventWaitFor(LThread.FSuspendEvent);
         CurrentThreadVar := LThread;
         LThread.Execute;
       end;
  except
    on e: exception do begin
      LThread.FFatalException := TObject(AcquireExceptionObject);
      if e is EThreadDestroyCalled then LThread.FFreeOnTerminate := true;
    end;
  end;
  Result := LThread.FReturnValue;
  LFreeOnTerminate := LThread.FreeOnTerminate;
  LThread.DoTerminate;
  LThread.FFinished := True;
  if LFreeOnTerminate then
    begin
       LThread.Free;
       EndThread(Result);
    end;
end;

{ TThread }
procedure TThread.SysCreate(CreateSuspended: Boolean;
                            const StackSize: SizeUInt);
begin
  FSuspendEvent := RtlEventCreate;
  FSuspended := CreateSuspended;
  FThreadReaped := false;
  FInitialSuspended := CreateSuspended;
  FFatalException := nil;
  FSuspendedInternal := not CreateSuspended;
  FHandle:= BeginThread(@ThreadFunc, Pointer(Self), FThreadID, StackSize);
  if FHandle = TThreadID(0) then
    raise EThread.create('Failed to create new thread');
end;


procedure TThread.SysDestroy;
begin
  if not assigned(FSuspendEvent) then
    { exception in constructor }
    exit;
  if (FHandle = TThreadID(0)) then
  { another exception in constructor }
    begin
      RtlEventDestroy(FSuspendEvent);
      exit;
    end;
  if (FThreadID = GetCurrentThreadID) then
    begin
      if not(FFreeOnTerminate) and not FFinished then
        raise EThreadDestroyCalled.Create('A thread cannot destroy itself except by setting FreeOnTerminate and leaving!');
      FFreeOnTerminate := false;
    end
  else
    begin
       FFreeOnTerminate := false;
       if not FThreadReaped then
        begin
          Terminate;
          if (FSuspendedInternal or FInitialSuspended) then
            Resume;
          WaitFor;
        end;
    end;
  RtlEventDestroy(FSuspendEvent);
  FFatalException.Free;
  FFatalException := nil;
end;

procedure TThread.SetSuspended(Value: Boolean);
begin
  if Value <> FSuspended then
    if Value then
      Suspend
    else
      Resume;
end;

procedure TThread.Suspend;
begin
  if FThreadID = GetCurrentThreadID then
    begin
      if not FSuspended and
         (InterLockedExchange(longint(FSuspended),longint(longbool(true))) = longint(longbool(false))) then
        RtlEventWaitFor(FSuspendEvent)
    end
  else
    begin
      Raise EThread.create('Suspending one thread from inside another one is unsupported (because it is unsafe and deadlock prone) by *nix and posix operating systems');
    end;
end;


procedure TThread.Resume;
begin
  if FSuspendedInternal and (InterLockedExchange(longint(FSuspendedInternal),ord(false)) = longint(longbool(true))) then
    begin
      WRITE_DEBUG('resuming thread after TThread construction',ptruint(self));
      RtlEventSetEvent(FSuspendEvent);
    end
  else
    begin
      if FSuspended and
         { don't compare with ord(true) or ord(longbool(true)), }
         { becaue a longbool's "true" value is anyting <> false }
         (InterLockedExchange(longint(FSuspended),longint(false)) <> longint(longbool(false))) then
        begin
          WRITE_DEBUG('resuming ',ptruint(self));
          RtlEventSetEvent(FSuspendEvent);
        end
    end
end;


procedure TThread.Terminate;
begin
  FTerminated := True;
end;

function TThread.WaitFor: Integer;
begin
   If (MainThreadID=GetCurrentThreadID) then 
    {
    While not FFinished do  
      CheckSynchronize(100);
  WaitFor := WaitForThreadTerminate(FHandle, 0);
  { should actually check for errors in WaitForThreadTerminate, but no }
  { error api is defined for that function                             }
  FThreadReaped:=true;
  WRITE_DEBUG('thread terminated');
end;

procedure TThread.CallOnTerminate;
begin
  // no need to check if FOnTerminate <> nil, because
  // thats already done in DoTerminate
  FOnTerminate(self);
end;

procedure TThread.DoTerminate;
begin
  if Assigned(FOnTerminate) then
    Synchronize(@CallOnTerminate);
end;

function TThread.GetPriority: TThreadPriority;
var
  P: Integer;
  I: TThreadPriority;
begin
  P := ThreadGetPriority(FHandle);
  Result := tpNormal;
  for I := Low(TThreadPriority) to High(TThreadPriority) do
    if Priorities[I] = P then
      Result := I;
end;


procedure TThread.SetPriority(Value: TThreadPriority);
begin
  ThreadSetPriority(FHandle, Priorities[Value]);
end;
