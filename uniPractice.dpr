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
  specialFunction in 'specialFunction.pas';

var
  Head, Tail: POrder;
  HeadP, TailP: PPostman;
  flag: boolean = true;
  isMenu: boolean = true;
  menuVal, menuVal2:integer;

begin
  Head := nil;
  Tail := nil;
  HeadP := nil;
  TailP:= nil;
  generateOrders(Head, Tail);
  generatePostmans(HeadP, TailP);

  while isMenu do
  begin
    clrscr();
    writeln('1) ������ ������ �� �����');
    writeln('2) �������� ����� ������');
    writeln('3) ������ ������ ���� ������� ������� � ������������������ �� ����������');
    writeln('4) ����� ������ � �������������� ��������');
    writeln('5) ���������� ������ � ������');
    writeln('6) �������� ������ �� ������');
    writeln('7) �������������� ������');
    writeln('8) �������� ����������� ������������� ������� ����� ���������');
    writeln('9) ����� �� ��������� ��� ���������� ���������');
    writeln('10) ����� � ����������� ���������');
    write('�������� ����������� �����: ');
    readln(menuVal);
    case menuVal of
      1:
        begin
          Writeln('������� Enter, ����� ����������.');
          Readln;
        end;
      2:
        begin
          LookMenu(Head, HeadP);
          Writeln('������� Enter, ����� ����������.');
          Readln;
        end;
      3:
        begin
          Writeln('������� Enter, ����� ����������.');
          Readln;
        end;
      4:
        begin
          SearhMenu(Head, Tail, HeadP, TailP);
          Writeln('������� Enter, ����� ����������.');
          Readln;
        end;
      5:
        begin
          AddMenu(Head, Tail, HeadP, TailP);
          Writeln('������� Enter, ����� ����������.');
          Readln;
        end;
      6:
        begin
          DeleteMenu(Head, Tail, HeadP, TailP);
          Writeln('������� Enter, ����� ����������.');
          Readln;
        end;
      7:
        begin
          EditMenu(Head, Tail, HeadP, TailP);
          Writeln('������� Enter, ����� ����������.');
          Readln;
        end;
      8:
        begin
          Writeln('������� Enter, ����� ����������.');
          Readln;
        end;
      9:
        begin
          isMenu:=false;
        end;
      10:
        begin
          Writeln('������� Enter, ����� ����������.');
          Readln;
        end;
    end;
  end;

end.
