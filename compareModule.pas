unit compareModule;

interface

uses
  System.SysUtils,
  Windows,
  orderModule,
  postmanModule,
  specialFunction;

function CompareID(argID1, argID2: Integer; argSrt1, argStr2: string;
  argTime1, argTime2: Integer; argTime1O, argTime2O: Integer): boolean;
function CompareStr(argID1, argID2: Integer; argSrt1, argStr2: string;
  argTime1, argTime2: Integer; argTime1O, argTime2O: Integer): boolean;
function CompareTime(argID1, argID2: Integer; argSrt1, argStr2: string;
  argTime1, argTime2: Integer; argTime1O, argTime2O: Integer): boolean;
function CompareTimeK(argID1, argID2: Integer; argSrt1, argStr2: string;
  argTime1, argTime2: Integer; argTime1O, argTime2O: Integer): boolean;
function ComparePostmanID(const zap: PPostman; argID: Integer;
  argFio: string): Integer;
function ComparePostmanFio(const zap: PPostman; argID: Integer;
  argFio: string): Integer;
function ComparePostmanIDDel(arg1, arg2: PDelivery): boolean;
function CompareStrDel(arg1, arg2: PDelivery): boolean;

implementation

function CompareID(argID1, argID2: Integer; argSrt1, argStr2: string;
  argTime1, argTime2: Integer; argTime1O, argTime2O: Integer): boolean;
begin
  if argID1 < argID2 then
    Result := true
  else
    Result := false;
end;

function CompareStr(argID1, argID2: Integer; argSrt1, argStr2: string;
  argTime1, argTime2: Integer; argTime1O, argTime2O: Integer): boolean;
begin
  if argSrt1 < argStr2 then
    Result := true
  else
    Result := false;
end;

function CompareTime(argID1, argID2: Integer; argSrt1, argStr2: string;
  argTime1, argTime2: Integer; argTime1O, argTime2O: Integer): boolean;
begin
  if argTime1 < argTime2 then
    Result := true
  else
    Result := false;
end;

function CompareTimeK(argID1, argID2: Integer; argSrt1, argStr2: string;
  argTime1, argTime2: Integer; argTime1O, argTime2O: Integer): boolean;
begin
  if argTime1O - argTime1 > argTime2O - argTime2 then
    Result := true
  else
    Result := false;
end;

function ComparePostmanID(const zap: PPostman; argID: Integer;
  argFio: string): Integer;
begin
  if zap^.data.id = argID then
    Result := 1
  else if zap^.data.id < argID then
    Result := 0
  else
    Result := 2;
end;

function ComparePostmanFio(const zap: PPostman; argID: Integer;
  argFio: string): Integer;
begin
  if zap^.data.fio = argFio then
    Result := 1
  else if zap^.data.fio < argFio then
    Result := 0
  else
    Result := 2;
end;

function ComparePostmanIDDel(arg1, arg2: PDelivery): boolean;
begin
  if arg1.data.postmanid	< arg2.data.postmanid then
    Result := true
  else
    Result := false;
end;

function CompareStrDel(arg1, arg2: PDelivery): boolean;
begin
  if arg1.data.orderAddr < arg2.data.orderAddr then
    Result := true
  else
    Result := false;
end;



end.
