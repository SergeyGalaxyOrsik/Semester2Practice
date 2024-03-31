unit ownFunctions;

interface

uses
  System.SysUtils,
  Windows,
  orderModule,
  postmanModule;

Type
  time = array [0 .. 1] of Integer;

  // Structure of order
  order = ^orderT;

  orderT = record
    data: record
      id: Integer;
      addr: string[100];
      time_in: time;
      time_out: time;
      volume: double;
      weight: double;
    end;

    next: order;
    prev: order;
  end;

  // Structure of postmans
  postman = ^postmanT;

  postmanT = record
    data: record
      id: Integer;
      name: string[100];
      time_from: time;
      time_to: time;
      weight_lim: double;
      car_volume: double;
    end;

    next: postman;
    prev: postman;
  end;



procedure LookMenu(HeadOrder: POrder; HeadPostman: PPostman);
procedure SearhMenu(HeadOrder, TailOrder: POrder;
  HeadPostman, TailPostman: PPostman);
procedure clrscr;
procedure AddMenu(HeadOrder, TailOrder: POrder;
  HeadPostman, TailPostman: PPostman);
procedure DeleteMenu(HeadOrder, TailOrder: POrder;
  HeadPostman, TailPostman: PPostman);
procedure EditMenu(HeadOrder, TailOrder: POrder;
  HeadPostman, TailPostman: PPostman);


implementation
uses
  compareModule;


procedure clrscr;
var
  cursor: COORD;
  r: cardinal;
begin
  r := 300;
  cursor.X := 0;
  cursor.Y := 0;
  FillConsoleOutputCharacter(GetStdHandle(STD_OUTPUT_HANDLE), ' ', 80 * r,
    cursor, r);
  SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), cursor);
end;

procedure LookMenu(HeadOrder: POrder; HeadPostman: PPostman);
var
  menuVal: Integer;
begin
  clrscr();
  writeln('1) ������ ������ �� �����');
  writeln('2) �������� ����� ������');
  writeln('   1) ������ �������');
  writeln('   2) ������ ��������');
  writeln('   3) ������ ������� ��������������� �� ������ ��������');
  writeln('   4) ������ �������� ��������������� �� ���');
  writeln('3) ������ ������ ���� ������� ������� � ������������������ �� ����������');
  writeln('4) ����� ������ � �������������� ��������');
  writeln('5) ���������� ������ � ������');
  writeln('6) �������� ������ �� ������');
  writeln('7) �������������� ������');
  writeln('8) �������� ����������� ������������� ������� ����� ���������');
  writeln('9) ����� �� ��������� ��� ���������� ���������');
  writeln('10) ����� � ����������� ���������');
  write('�������� ����������� ��������: ');
  readln(menuVal);
  case menuVal of
    1:
      begin
        PrintOrders(HeadOrder, CompareID);
      end;
    2:
      begin
        PrintPostmans(HeadPostman, CompareID);
      end;
    3:
      begin
        PrintOrders(HeadOrder, CompareStr);
      end;
    4:
      begin
        PrintPostmans(HeadPostman, CompareStr);
      end;
  end;
end;

procedure SearhMenu(HeadOrder, TailOrder: POrder;
  HeadPostman, TailPostman: PPostman);
var
  menuVal: Integer;
  searchStr: string;
  searchID: Integer;
begin
  clrscr();
  searchID:=0;
  searchStr:='';
  writeln('1) ������ ������ �� �����');
  writeln('2) �������� ����� ������');
  writeln('3) ������ ������ ���� ������� ������� � ������������������ �� ����������');
  writeln('4) ����� ������ � �������������� ��������');
  writeln('   1) ����� ������ �� ID');
  writeln('   2) ����� ������ �� ������');
  writeln('   3) ����� ������� �� ID');
  writeln('   4) ����� ������ �� ���');
  writeln('5) ���������� ������ � ������');
  writeln('6) �������� ������ �� ������');
  writeln('7) �������������� ������');
  writeln('8) �������� ����������� ������������� ������� ����� ���������');
  writeln('9) ����� �� ��������� ��� ���������� ���������');
  writeln('10) ����� � ����������� ���������');
  write('�������� ����������� ��������: ');
  readln(menuVal);
  case menuVal of
    1:
      begin
        Write('������� ����������� ID: ');
        readln(searchID);
        OrderByID(HeadOrder, searchID, searchStr, CompareOrderID);
      end;
    2:
      begin
        Write('������� ����������� �����: ');
        readln(searchStr);
        OrdersByAddr(HeadOrder, TailOrder, searchID,searchStr, CompareOrderAddr);
      end;
    3:
      begin
        Write('������� ����������� ID: ');
        readln(searchID);
        PostmanByID(HeadPostman, searchID, searchStr, ComparePostmanID);
      end;
    4:
      begin
        Write('������� ������� ���: ');
        readln(searchStr);
        PostmanByFio(HeadPostman, TailPostman, searchID, searchStr, ComparePostmanFio);
      end;
  end;
end;

procedure AddMenu(HeadOrder, TailOrder: POrder;
  HeadPostman, TailPostman: PPostman);
var
  menuVal: Integer;
  str:string;
  isWriting,isCorrect:boolean;
  srtParam:string;
  exitStr: String[5];
  doubleParam:double;
  integerParam:integer;
  OrderData:TOrderData;
  PostmanData:TPostmanData;
begin
  isWriting:=True;
  clrscr();
  writeln('1) ������ ������ �� �����');
  writeln('2) �������� ����� ������');
  writeln('3) ������ ������ ���� ������� ������� � ������������������ �� ����������');
  writeln('4) ����� ������ � �������������� ��������');
  writeln('5) ���������� ������ � ������');
  writeln('   1) � ������ �������');
  writeln('   2) � ������ ��������');
  writeln('6) �������� ������ �� ������');
  writeln('7) �������������� ������');
  writeln('8) �������� ����������� ������������� ������� ����� ���������');
  writeln('9) ����� �� ��������� ��� ���������� ���������');
  writeln('10) ����� � ����������� ���������');
  write('�������� ����������� ��������: ');
  readln(menuVal);
  case menuVal of
    1:
      begin
        while isWriting do
        begin

          Write('������� ����� ��������: ');
          Readln(srtParam);
          OrderData.addr := srtParam;


          isCorrect:=true;
          while isCorrect do
          begin
            Write('������� ����� (� 1 �� 24) � �������� ����� ��������� : ');
            Readln(integerParam);
            if (integerParam>0) and (integerParam<=24) then
            begin
              isCorrect:=false;
              OrderData.time_in := integerParam;
            end
            else
              Writeln('������������ ������, ���������� ��� ���');
          end;
          isCorrect:=true;


          while isCorrect do
          begin
            Write('������� ����� (� 1 �� 24) �� �������� ����� ��������� : ');
            Readln(integerParam);
            if (integerParam>0) and (integerParam<=24) then
            begin
              isCorrect:=false;
              OrderData.time_out := integerParam;
            end
            else
              Writeln('������������ ������, ���������� ��� ���');
          end;
          Write('������� �����(�^3) ������: ');
          Readln(doubleParam);
          OrderData.volume := doubleParam;
          Write('������� ���(��) ������: ');
          Readln(doubleParam);
          OrderData.weight := doubleParam;
          AppendOrder(HeadOrder, TailOrder, OrderData);

          Write('�������� ��� ���� �����(��/���): ');
          Readln(exitStr);
          while not ((exitStr='���') or (exitStr='���') or (exitStr='��') or (exitStr='��')) do
          begin
            Write('�������� ����, ��������� �������: ');
            Readln(exitStr);
          end;
          if (exitStr='���') or (exitStr='���')  then
            isWriting:=False;
        end;
      end;
    2:
      begin
        while isWriting do
        begin
          Write('������� ���: ');
          Readln(srtParam);
          PostmanData.fio := srtParam;

          Write('������� ����� (� 1 �� 24) � �������� �������� : ');
          isCorrect:=true;
          while isCorrect do
          begin
            Readln(integerParam);
            if (integerParam>0) and (integerParam<=24) then
            begin
              isCorrect:=false;
              PostmanData.time_in := integerParam;
            end
            else
              Writeln('������������ ������, ���������� ��� ���');
          end;
          isCorrect:=true;

          Write('������� ����� (� 1 �� 24) �� �������� �������� : ');
          while isCorrect do
          begin
            Readln(integerParam);
            if (integerParam>0) and (integerParam<=24) then
            begin
              isCorrect:=false;
              PostmanData.time_out := integerParam;
            end
            else
              Writeln('������������ ������, ���������� ��� ���');
          end;
          Write('������� �����(�^3) ������: ');
          Readln(doubleParam);
          PostmanData.volume := doubleParam;
          Write('������� ���(��) ������: ');
          Readln(doubleParam);
          PostmanData.weight := doubleParam;
          AppendPostman(HeadPostman, TailPostman, PostmanData);

          Write('�������� ��� ������� �������(��/���): ');
          Readln(exitStr);
          while not ((exitStr='���') or (exitStr='���') or (exitStr='��') or (exitStr='��')) do
          begin
            Write('�������� ����, ��������� �������: ');
            Readln(exitStr);
          end;
          if (exitStr='���') or (exitStr='���')  then
            isWriting:=False;
        end;
      end;
  end;
end;

procedure DeleteMenu(HeadOrder, TailOrder: POrder;
  HeadPostman, TailPostman: PPostman);
var
  menuVal: Integer;
  str:string;
  isWriting:boolean;
  ID:integer;
  OrderData:TOrderData;
  PostmanData:TPostmanData;
begin
  isWriting:=True;
  clrscr();
  writeln('1) ������ ������ �� �����');
  writeln('2) �������� ����� ������');
  writeln('3) ������ ������ ���� ������� ������� � ������������������ �� ����������');
  writeln('4) ����� ������ � �������������� ��������');
  writeln('5) ���������� ������ � ������');
  writeln('6) �������� ������ �� ������');
  writeln('   1) �� ������ �������');
  writeln('   2) �� ������ ��������');
  writeln('7) �������������� ������');
  writeln('8) �������� ����������� ������������� ������� ����� ���������');
  writeln('9) ����� �� ��������� ��� ���������� ���������');
  writeln('10) ����� � ����������� ���������');
  write('�������� ����������� ��������: ');
  readln(menuVal);
  case menuVal of
    1:
      begin
        PrintOrders(HeadOrder, CompareID);
        Write('������� ID ������, ������� ���������� �������: ');
        Readln(ID);
        DeleteOrder(HeadOrder, ID);

      end;
    2:
      begin
        PrintPostmans(HeadPostman, CompareID);
        Write('������� ID �������, �������� ���������� �������: ');
        Readln(ID);
        DeletePostman(HeadPostman, ID);
      end;
  end;
end;

procedure EditMenu(HeadOrder, TailOrder: POrder;
  HeadPostman, TailPostman: PPostman);
var
  menuVal: Integer;
  str:string;
  isWriting:boolean;
  ID:integer;
  OrderData:TOrderData;
  PostmanData:TPostmanData;
begin
  isWriting:=True;
  clrscr();
  writeln('1) ������ ������ �� �����');
  writeln('2) �������� ����� ������');
  writeln('3) ������ ������ ���� ������� ������� � ������������������ �� ����������');
  writeln('4) ����� ������ � �������������� ��������');
  writeln('5) ���������� ������ � ������');
  writeln('6) �������� ������ �� ������');
  writeln('7) �������������� ������');
  writeln('   1) �� ������ �������');
  writeln('   2) �� ������ ��������');
  writeln('8) �������� ����������� ������������� ������� ����� ���������');
  writeln('9) ����� �� ��������� ��� ���������� ���������');
  writeln('10) ����� � ����������� ���������');
  write('�������� ����������� ��������: ');
  readln(menuVal);
  case menuVal of
    1:
      begin
        Write('������� ID ������, ������� ���������� ���������������: ');
        Readln(ID);
        EditOrder(HeadOrder, TailOrder, ID);
      end;
    2:
      begin
        Write('������� ID �������, �������� ���������� ���������������: ');
        Readln(ID);
        EditPostman(HeadPostman, TailPostman, ID);
      end;
  end;
end;

end.
