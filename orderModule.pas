unit orderModule;

interface


type

  POrder = ^TOrder;

  TOrderData = record
    id: Integer;
    addr: string[100];
    time_in: integer;
    time_out: integer;
    volume: Double;
    weight: Double;
  end;

  TOrder = record
    data: TOrderData;
    next: POrder;
    prev: POrder;
  end;
  TCompare=function(const zap: POrder; argID: Integer; argAddr:string):integer;
  TCompareSort=function(argID1, argID2: Integer; argSrt1, argStr2:string):boolean;


procedure PrintOrders(Head: POrder; cmp:TCompareSort);
procedure AppendOrder(var Head, Tail: POrder; Item: TOrderData);
procedure OrderByID(var Head: POrder; argID: Integer;argAddr:String; cmp:TCompare);
procedure OrdersByAddr(Head, Tail: POrder; argID: Integer; argAddr:string; cmp:TCompare);
procedure DeleteOrder(Head: POrder; const id: Integer);
procedure EditOrder(Head, Tail: POrder; const id: Integer);
function CompareOrderID(const zap: POrder; argID: Integer; argAddr:string):integer;
function CompareOrderAddr(const zap: POrder; argID: Integer; argAddr:string):integer;

implementation

uses
  System.SysUtils,
  ownFunctions,
  compareModule;


// �������� � ������
procedure AppendOrder(var Head, Tail: POrder; Item: TOrderData);
var
  NewNode: POrder;
  LastID: Integer;
begin
  // ���������, ���� �������� ���� ������, �� ������������� ��������� �������� ID ��� 0
  if Head = nil then
  begin
    LastID := 0;
    New(NewNode);
    NewNode^.data := Item;
    NewNode^.prev := nil;
    NewNode^.next := Tail;
    Head := NewNode;
    Tail := NewNode;
  end
  else
    // ����� ����� ID ���������� ����
  LastID := Head^.data.id;

  Inc(LastID); // ������������� ��� ������ ID
  Item.id := LastID; // ��������� ������ ID ��� ����������� ������
  Head^.data.id := LastID;
  New(NewNode);
  NewNode^.data := Item;
  NewNode^.next := nil;

  if Tail = nil then
  begin
    NewNode^.prev := Head;
    Tail := NewNode;
  end
  else
  begin
    NewNode^.prev := Tail;
    Tail^.next := NewNode;
  end;

  Tail := NewNode;
end;

// ����������
procedure Sort(var h: POrder; cmp: TCompareSort);
var
  t, b: POrder;
  x: TOrderData;
begin
  t := h^.next;
  while (t <> nil) do
  begin
    x := t^.data;
    b := t^.prev;
    while (b <> nil) and (cmp(x.id, b^.data.id, x.addr, b^.data.addr)) and ((b.prev <> nil)) do
    begin
      b^.next^.data := b^.data;
      b := b^.prev;
    end;
    if (b = nil) then
      h^.data := x
    else
      b^.next^.data := x;
    t := t^.next;
  end;
end;



// ����� ������


procedure PrintOrders(Head: POrder; cmp:TCompareSort);
var
  Current: POrder;
  Index: Integer;
begin
  Sort(Head,cmp);
  Writeln('������ ���� �������:');
  Writeln('|------------------------------------------------------------------------------|');
  Writeln('|  ID |       �����     |   ����� �   |   ����� ��  |   �����     |     ���    |');
  Writeln('|-----+-----------------+-------------+-------------+-------------+------------|');
  Current := Head^.next;
  while Current <> nil do
  begin
    Write(Format('| %-3d | ', [Current^.data.id]));
    Write(Format('%-15s | ', [Current^.data.addr]));
    Write(Format('     %-3d    | ', [Current^.data.time_in]));
    Write(Format('     %-3d    | ', [Current^.data.time_out]));
    Write(Format(' %-10.2f | ', [Current^.data.volume]));
    Writeln(Format('%-10.2f | ', [Current^.data.weight]));
    Writeln('|-----+-----------------+-------------+-------------+-------------+------------|');
    Current := Current^.next;
  end;
end;

function CompareOrderID(const zap: POrder; argID: Integer; argAddr:string):integer;
begin
  if zap^.data.id = argID then
    Result:=1
  else if zap^.data.id < argID then
    Result:=0
  else
    Result:=2;
end;

function CompareOrderAddr(const zap: POrder; argID: Integer; argAddr:string):integer;
begin
  if zap^.data.addr = argAddr then
    Result:=1
  else if zap^.data.addr < argAddr then
    Result:=0
  else
    Result:=2;
end;

// ����������




// ����� �� ID
function FindOrder(var Head: POrder; argID: Integer; argAddr: string; cmp: TCompare): POrder;
var
  l: POrder;
  found: Boolean;
begin
  l := Head^.next; // ���������� ������ ������
  found := False;

  while (l <> nil) and (cmp(l,argID,argAddr) <> 1) do
    l := l^.next;

  if l <> nil then
  begin
    Result := l;
    found := True;
  end;

  if not found then
    Result := nil;
end;

procedure OrderByID(var Head: POrder; argID: Integer; argAddr:string; cmp:TCompare);
var
  order: POrder;
  found: Boolean;
begin
  Sort(Head,CompareID);
  found:= false;
  order := FindOrder(Head, argID, argAddr, cmp);
  if order<>nil then
  begin
    found:=true;
    Writeln('ID: ', order^.data.id);
    Writeln('�����: ', order^.data.addr);
    Writeln('����� ��������: ', order^.data.time_in);
    Writeln('����� ������: ', order^.data.time_out);
    Writeln('�����: ', order^.data.volume:4:2);
    Writeln('���: ', order^.data.weight:4:2);
    // ����� ��������� ������
    Writeln;
  end;
  if not Found then
    Writeln('������ � ����� ID �� �������');
end;

// ����� �� ����� "�����"




procedure OrdersByAddr(Head, Tail: POrder; argID: Integer; argAddr:string; cmp:TCompare);
var
  CurrentL, CurrentR: POrder;
  found: Boolean;
begin
  // ������� ��������� ������ � ���������� �������
  Sort(Head,CompareStr);
  found := False;

  // ���� ������ ������ � ����������� �������
  currentL:=FindOrder(Head, argID, argAddr, cmp);
  currentR:=currentL;
  // ���� ������ �� �������, ������� �� ���������
  if (currentL <> nil) and (currentR<>nil) then
  begin
    // ������� ��������� ������
    Writeln('������(�) �����(�):');
   Writeln('ID: ', currentR^.data.id);
      Writeln('�����: ', currentR^.data.addr);
      Writeln('����� ��������: ', currentR^.data.time_in);
      Writeln('����� ������: ',currentR^.data.time_out);
      Writeln('�����: ', currentR^.data.volume:4:2);
      Writeln('���: ', currentR^.data.weight:4:2);
    // ����� ��������� ������
    Writeln;
    found := True;

    // ������������ � ���������� ������� � ����������� �������
    while (currentL^.prev <> nil) and (currentL^.prev^.data.addr = argAddr) and (currentL^.prev.prev <> nil) do
    begin
      currentL := currentL^.prev;
      // ������� ��������� ������

      Writeln('ID: ', currentR^.data.id);
      Writeln('�����: ', currentR^.data.addr);
      Writeln('����� ��������: ', currentR^.data.time_in);
      Writeln('����� ������: ',currentR^.data.time_out);
      Writeln('�����: ', currentR^.data.volume:4:2);
      Writeln('���: ', currentR^.data.weight:4:2);
      // ����� ��������� ������
      Writeln;
      found := True;
    end;

    // ������������ � ��������� ������� � ����������� �������

    // ������������ � ��������� ������� � ����������� �������
    while (currentR^.next <> nil) and (currentR^.next^.data.addr = argAddr) do
    begin
      currentR := currentR^.next;
      // ������� ��������� ������
      Writeln('ID: ', currentR^.data.id);
      Writeln('�����: ', currentR^.data.addr);
      Writeln('����� ��������: ', currentR^.data.time_in);
      Writeln('����� ������: ',currentR^.data.time_out);
      Writeln('�����: ', currentR^.data.volume:4:2);
      Writeln('���: ', currentR^.data.weight:4:2);
      // ����� ��������� ������
      Writeln;
      found := True;
    end;
  end;

  // ���� �� ���� ������� �� ����� ������ � ����������� �������, ������� ��������� �� ����
  if not found then
    Writeln('������ � ������� "', argAddr, '" �� �������.');
end;

// ��a����� �� ������
procedure DeleteOrder(Head: POrder; const id: Integer);
var
  order: POrder;
  str:string;
begin
  str:='';
  order := FindOrder(Head, id,str, CompareOrderID);
  if order=nil then
    Writeln('������ ������ �� �������, �������� �� ��������')
  else
  begin
    if order^.prev <> nil then
      order^.prev^.next := order^.next;
    if order^.next <> nil then
      order^.next^.prev := order^.prev;
    Writeln('����� ������');
  end;
end;

procedure EditOrder(Head, Tail: POrder; const id: Integer);
var
  order: POrder;
  isWriting, isCorrect: Boolean;
  strParam, exitStr,str: string;
  doubleParam: Double;
  integerParam: integer;
  menuVal:integer;
begin
  str:='';
  order := FindOrder(Head, id,str, CompareOrderID);
  if order=nil then
    Writeln('������ ������ �� �������, �������������� �� ��������')
  else
  begin
    Writeln('������, ������� ���������� ���������������');
    Writeln('ID: ', order^.data.id);
    Writeln('1) �����: ', order^.data.addr);
    Writeln('2) ����� ��������: ', FormatDateTime('HH:NN', order^.data.time_in));
    Writeln('3) ����� ������: ', FormatDateTime('HH:NN', order^.data.time_out));
    Writeln('4) �����: ', order^.data.volume:4:2);
    Writeln('5) ���: ', order^.data.weight:4:2);
    Writeln('6) ����� �� ������ ��������������');
    while isWriting do
    begin
      Write('�������� ����, ������� ���������� ��������������� (6 - �����): ');
      readln(menuVal);
      case menuVal of
        1:
        begin
          Write('������� ����� ��������: ');
          Readln(strParam);
          order^.data.addr := strParam;
        end;
        2:
        begin
          Write('������� ����� (� 1 �� 24) � �������� ����� ��������� : ');

          isCorrect:=true;
          while isCorrect do
          begin
            Readln(integerParam);
            if (integerParam>0) and (integerParam<=24) then
            begin
              isCorrect:=false;
              order^.data.time_in := integerParam;
            end
            else
              Writeln('������������ ������, ���������� ��� ���');
          end;
          isCorrect:=true;

        end;
        3:
        begin
          Write('������� ����� (� 1 �� 24) �� �������� ����� ���������: ');
          isCorrect:=true;
          while isCorrect do
          begin
            Readln(integerParam);
            if (integerParam>0) and (integerParam<=24) then
            begin
              isCorrect:=false;
              order^.data.time_out := integerParam;
            end
            else
              Writeln('������������ ������, ���������� ��� ���');
          end;
          isCorrect:=true;
        end;
        4:
        begin
          Write('������� �����(�^3) ������: ');
          Readln(doubleParam);
          order^.data.volume := doubleParam;
        end;
        5:
        begin
          Write('������� ���(��) ������: ');
          Readln(doubleParam);
          order^.data.weight := doubleParam;
        end;
        6:
        begin
          isWriting:=False;
        end;
      end;
    end;
    Writeln('����� �������');
  end;
end;

end.
