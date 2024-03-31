unit postmanModule;



interface



type
  PPostman = ^TPostman;

  TPostmanData = record
    id: Integer;
    fio: string[100];
    time_in: integer;
    time_out: integer;
    volume: Double;
    weight: Double;
  end;

  TPostman = record
    data: TPostmanData;
    next: PPostman;
    prev: PPostman;
  end;
  TCompare=function(const zap: PPostman; argID: Integer; argFio:string):integer;
  TCompareSort=function(argID1, argID2: Integer; argSrt1, argStr2:string):boolean;

procedure PrintPostmans(Head: PPostman; cmp:TCompareSort);
procedure AppendPostman(var Head, Tail: PPostman; Item: TPostmanData);
procedure PostmanByID(var Head: PPostman; argID: Integer; argAddr:string; cmp:TCompare);
procedure PostmanByFio(Head, Tail: PPostman; argID: Integer; argFio:string; cmp:TCompare);
procedure DeletePostman(Head:PPostman; const ID: integer);
procedure EditPostman(Head, Tail: PPostman; const id: Integer);

implementation

uses
  System.SysUtils,
  compareModule;

procedure AppendPostman(var Head, Tail: PPostman; Item: TPostmanData);
var
  NewNode: PPostman;
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
    Head^.data.id:=LastID;
    New(NewNode);
    NewNode^.data := Item;
    NewNode^.next := nil;

    if Tail = nil then
    begin
      NewNode^.prev := Head;
      Tail:= NewNode;
    end
    else
    begin
      NewNode^.prev := Tail;
      Tail^.next := NewNode;
    end;

    Tail := NewNode;
end;



procedure Sort(var h: PPostman; cmp: TCompareSort);
var
  t, b: PPostman;
  x: TPostmanData;
begin
  t := h^.next;
  while (t <> nil) do
  begin
    x := t^.data;
    b := t^.prev;
    while (b <> nil) and (cmp(x.id, b^.data.id, x.fio, b^.data.fio)) and ((b.prev <> nil)) do
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



procedure PrintPostmans(Head: PPostman; cmp:TCompareSort);
var
  Current: PPostman;
  Index: Integer;
begin
  Sort(Head,cmp);
  Writeln('������ ���� ��������:');
  Writeln('|------------------------------------------------------------------------------|');
  Writeln('|  ID |       ���       |   ����� �   |   ����� ��  |   �����     |     ���    |');
  Writeln('|-----+-----------------+-------------+-------------+-------------+------------|');
  Current := Head^.next;
  while Current <> nil do
  begin
    Write(Format('| %-3d | ', [Current^.data.id]));
    Write(Format('%-15s | ', [Current^.data.fio]));
    Write(Format('     %-3d    | ', [Current^.data.time_in]));
    Write(Format('     %-3d    | ', [Current^.data.time_out]));
    Write(Format(' %-10.2f | ', [Current^.data.volume]));
    Writeln(Format('%-10.2f | ', [Current^.data.weight]));
    Writeln('|-----+-----------------+-------------+-------------+-------------+------------|');
    Current := Current^.next;
  end;
end;



// ����� �� ID
function FindPostman(var Head: PPostman; argID: Integer; argFio:string; cmp:TCompare): PPostman;
var
  l: PPostman;
  found: Boolean;
begin
  l := Head^.next; // ���������� ������ ������
  found := False;

  while (l <> nil) and (cmp(l,argID,argFio) <> 1) do
    l := l^.next;

  if l <> nil then
  begin
    Result := l;
    found := True;
  end;

  if not found then
    Result := nil;
end;

procedure PostmanByID(var Head: PPostman; argID: Integer; argAddr:string; cmp:TCompare);
var
  order: PPostman;
  found: Boolean;
begin
  Sort(Head,CompareID);
  found:= false;
  order := FindPostman(Head, argID, argAddr, cmp);
  if order<>nil then
  begin
    found:=true;
    Writeln('ID: ', order^.data.id);
    Writeln('���: ', order^.data.fio);
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

// ����� �� ����� "���"



procedure PostmanByFio(Head, Tail: PPostman; argID: Integer; argFio:string; cmp:TCompare);
var
  CurrentL, CurrentR: PPostman;
  found: Boolean;
begin
  // ������� ��������� ������ � ���������� �������
  Sort(Head,CompareStr);
  found := False;

  // ���� ������ ������ � ����������� �������
  currentL:=FindPostman(Head, argID, argFio, cmp);
  currentR:=currentL;
  // ���� ������ �� �������, ������� �� ���������
  if (currentL <> nil) and (currentR<>nil) then
  begin
    // ������� ��������� ������
    Writeln('ID: ', currentR^.data.id);
    Writeln('���: ', currentR^.data.fio);
    Writeln('����� � �������� ��������: ', currentR^.data.time_in);
    Writeln('����� �� �������� ��������: ',currentR^.data.time_out);
    Writeln('�����: ', currentR^.data.volume:4:2);
    Writeln('���: ', currentR^.data.weight:4:2);
    // ����� ��������� ������
    Writeln;
    found := True;

    // ������������ � ���������� ������� � ����������� �������
    while (currentL^.prev <> nil) and (currentL^.prev^.data.fio = argFio) and (currentL^.prev.prev <> nil) do
    begin
      currentL := currentL^.prev;
      // ������� ��������� ������

      Writeln('ID: ', currentR^.data.id);
      Writeln('���: ', currentR^.data.fio);
      Writeln('����� � �������� ��������: ', currentR^.data.time_in);
      Writeln('����� �� �������� ��������: ',currentR^.data.time_out);
      Writeln('�����: ', currentR^.data.volume:4:2);
      Writeln('���: ', currentR^.data.weight:4:2);
      // ����� ��������� ������
      Writeln;
      found := True;
    end;

    // ������������ � ��������� ������� � ����������� �������

    // ������������ � ��������� ������� � ����������� �������
    while (currentR^.next <> nil) and (currentR^.next^.data.fio = argFio) do
    begin
      currentR := currentR^.next;
      // ������� ��������� ������
      Writeln('ID: ', currentR^.data.id);
      Writeln('���: ', currentR^.data.fio);
      Writeln('����� � �������� ��������: ', currentR^.data.time_in);
      Writeln('����� �� �������� ��������: ',currentR^.data.time_out);
      Writeln('�����: ', currentR^.data.volume:4:2);
      Writeln('���: ', currentR^.data.weight:4:2);
      // ����� ��������� ������
      Writeln;
      found := True;
    end;
  end;

  // ���� �� ���� ������� �� ����� ������ � ����������� �������, ������� ��������� �� ����
  if not found then
    Writeln('������ � ������� "', argFio, '" �� �������.');
end;

procedure DeletePostman(Head:PPostman; const ID: integer);
var
  postman:PPostman;
  str:string;
begin
  str:='';
  postman := FindPostman(Head, ID,str, ComparePostmanID);
  if postman=nil then
    Writeln('������ ������ �� �������, �������� �� ��������')
  else
  begin
    if postman^.prev<>nil then
      postman^.prev^.next:=postman^.next;
    if postman^.next<>nil then
      postman^.next^.prev:=postman^.prev;
    Writeln('������ ������');
  end;
end;

procedure EditPostman(Head, Tail: PPostman; const id: Integer);
var
  postman: PPostman;
  isWriting, isCorrect: Boolean;
  integerParam:integer;
  strParam, exitStr: string;
  doubleParam: Double;
  menuVal:integer;
begin
  strParam:='';
  postman := FindPostman(Head, id,strParam,ComparePostmanID);
  if postman=nil then
    Writeln('������ ������ �� �������, �������������� �� ��������')
  else
  begin
    Writeln('������, ������� ���������� ���������������');
    Writeln('ID: ', postman^.data.id);
    Writeln('1) ���: ', postman^.data.fio);
    Writeln('2) ����� c �������� ��������: ',postman^.data.time_in);
    Writeln('3) ����� �� �������� ��������: ', postman^.data.time_out);
    Writeln('4) �����: ', postman^.data.volume:4:2);
    Writeln('5) ���: ', postman^.data.weight:4:2);
    Writeln('6) ����� �� ������ ��������������');
    while isWriting do
    begin
      Write('�������� ����, ������� ���������� ��������������� (6 - �����): ');
      readln(menuVal);
      case menuVal of
        1:
        begin
          Write('������� ���: ');
          Readln(strParam);
          postman^.data.fio := strParam;
        end;
        2:
        begin

          isCorrect:=true;
          Write('������� ����� (� 1 �� 24) c �������� �������� : ');
          while isCorrect do
          begin
            Readln(integerParam);
            if (integerParam>0) and (integerParam<=24) then
            begin
              isCorrect:=false;
              postman^.data.time_in := integerParam;
            end
            else
              Writeln('������������ ������, ���������� ��� ���');
          end;
          isCorrect:=true;
        end;
        3:
        begin
          isCorrect:=true;
          Write('������� ����� (� 1 �� 24) �� �������� �������� : ');
          while isCorrect do
          begin
            Readln(integerParam);
            if (integerParam>0) and (integerParam<=24) then
            begin
              isCorrect:=false;
              postman^.data.time_out := integerParam;
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
          postman^.data.volume := doubleParam;
        end;
        5:
        begin
          Write('������� ���(��) ������: ');
          Readln(doubleParam);
          postman^.data.weight := doubleParam;
        end;
        6:
        begin
          isWriting:=False;
        end;
      end;
    end;
    Writeln('������ �������');
  end;
end;


end.
