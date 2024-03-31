unit compareModule;

interface

uses
  System.SysUtils,
  Windows,
  orderModule,
  postmanModule;


function CompareID(argID1, argID2: Integer; argSrt1, argStr2:string):boolean;
function CompareStr(argID1, argID2: Integer; argSrt1, argStr2:string):boolean;
function ComparePostmanID(const zap: PPostman; argID: Integer; argFio:string):integer;
function ComparePostmanFio(const zap: PPostman; argID: Integer; argFio:string):integer;

implementation


function CompareID(argID1, argID2: Integer; argSrt1, argStr2:string):boolean;
begin
  if argID1<argID2 then
    Result:=true
  else
    Result:=false;
end;

function CompareStr(argID1, argID2: Integer; argSrt1, argStr2:string):boolean;
begin
  if argSrt1<argStr2 then
    Result:=true
  else
    Result:=false;
end;

function ComparePostmanID(const zap: PPostman; argID: Integer; argFio:string):integer;
begin
  if zap^.data.id = argID then
    Result:=1
  else if zap^.data.id < argID then
    Result:=0
  else
    Result:=2;
end;

function ComparePostmanFio(const zap: PPostman; argID: Integer; argFio:string):integer;
begin
  if zap^.data.fio = argFio then
    Result:=1
  else if zap^.data.fio < argFio then
    Result:=0
  else
    Result:=2;
end;
end.
