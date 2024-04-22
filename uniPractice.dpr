program uniPractice;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Windows,
  ownFunctions in 'ownFunctions.pas',
  orderModule in 'orderModule.pas',
  postmanModule in 'postmanModule.pas',
  rawData in 'rawData.pas',
  compareModule in 'compareModule.pas',
  specialFunction in 'specialFunction.pas',
  fileModule in 'fileModule.pas';

var
  Head, Tail: POrder;
  HeadP, TailP: PPostman;
  HeadD, TailD: PDelivery;
  flag: boolean = true;
  isMenu: boolean = true;
  menuVal, menuVal2: integer;
  exitOpenFile: string;

procedure startOrder(var Head, Tail:POrder);
var
NewNode: POrder;
begin
    New(NewNode);
    NewNode^.data.id := 0;
    NewNode^.prev := nil;
    NewNode^.next := Tail;
    Head := NewNode;
    Tail := NewNode;
end;
procedure startPostman(var Head, Tail:PPostman);
var
NewNode: PPostman;
begin
    New(NewNode);
    NewNode^.data.id := 0;
    NewNode^.prev := nil;
    NewNode^.next := Tail;
    Head := NewNode;
    Tail := NewNode;
end;
procedure startDelivery(var Head, Tail:PDelivery);
var
NewNode: PDelivery;
begin
    New(NewNode);
    NewNode^.data.id := 0;
    NewNode^.prev := nil;
    NewNode^.next := Tail;
    Head := NewNode;
    Tail := NewNode;
end;


begin
  Head := nil;
  Tail := nil;
  HeadP := nil;
  TailP := nil;
  HeadD := nil;
  TailD := nil;
  startOrder(Head, Tail);
  startPostman(HeadP, TailP);
  startDelivery(HeadD, TailD);
//  generateOrders(Head, Tail);
//  generatePostmans(HeadP, TailP);

  while isMenu do
  begin
    clrscr();
    writeln('1) ������ ������ �� �����');
    writeln('2) �������� ����� ������');
    writeln('3) ����������');
    writeln('4) ����� ������ � �������������� ��������');
    writeln('5) ���������� ������ � ������');
    writeln('6) �������� ������ �� ������');
    writeln('7) �������������� ������');
    writeln('8) �������� ����������� ������������� ������� ����� ���������');
    writeln('9) ����� �� ��������� ��� ���������� ���������');
    writeln('10) ����� � ����������� ���������');
    write('�������� ����������� �����: ');
    try
      readln(menuVal);
      case menuVal of
        1:
          begin
            if (Head.data.id<>0) or (HeadP.data.id<>0) or (HeadD.data.id<>0) then
            begin
              Write('���� ������ �� ������, ���������� ��������� ����� ������');
              readln;
            end
            else
              OpenFiles(Head, Tail, HeadP, TailP, HeadD, TailD);
            readln;
          end;
        2:
          begin
            LookMenu(Head, HeadP);
            writeln('������� Enter, ����� ����������.');
            readln;
          end;
        3:
          begin
            SortPrintMenu(Head, HeadP);
            writeln('������� Enter, ����� ����������.');
            readln;
          end;
        4:
          begin
            SearhMenu(Head, Tail, HeadP, TailP);
            writeln('������� Enter, ����� ����������.');
            readln;
          end;
        5:
          begin
            AddMenu(Head, Tail, HeadP, TailP);
            writeln('������� Enter, ����� ����������.');
            readln;
          end;
        6:
          begin
            DeleteMenu(Head, Tail, HeadP, TailP, HeadD);
            writeln('������� Enter, ����� ����������.');
            readln;
          end;
        7:
          begin
            EditMenu(Head, Tail, HeadP, TailP);
            writeln('������� Enter, ����� ����������.');
            readln;
          end;
        8:
          begin
            SpecialFunctionMenu(Head, Tail, HeadP, TailP, HeadD, TailD);
            writeln('������� Enter, ����� ����������.');
            readln;
          end;
        9:
          begin
            isMenu := false;
          end;
        10:
          begin
            saveToFile(Head, HeadP, HeadD);
            writeln('������� Enter, ����� ����������.');
            readln;
            isMenu := false;
          end;
      end;
    except
      Writeln('������������ ������, ���������� ��� ���');
      Readln;
    end;
  end;

end.
