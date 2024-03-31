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
    writeln('1) Чтение данных из файла');
    writeln('2) Просмотр всего списка');
    writeln('3) Выдать список всех заказов курьера в последовательности их выполнения');
    writeln('4) Поиск данных с использованием фильтров');
    writeln('5) Добавление данных в список');
    writeln('6) Удаление данных из списка');
    writeln('7) Редактирование данных');
    writeln('8) Наиболее эффективное распределение заказов между курьерами');
    writeln('9) Выход из программы без сохранения изменений');
    writeln('10) Выход с сохранением изменений');
    write('Выберите необходимое пункт: ');
    readln(menuVal);
    case menuVal of
      1:
        begin
          Writeln('Нажмите Enter, чтобы продолжить.');
          Readln;
        end;
      2:
        begin
          LookMenu(Head, HeadP);
          Writeln('Нажмите Enter, чтобы продолжить.');
          Readln;
        end;
      3:
        begin
          Writeln('Нажмите Enter, чтобы продолжить.');
          Readln;
        end;
      4:
        begin
          SearhMenu(Head, Tail, HeadP, TailP);
          Writeln('Нажмите Enter, чтобы продолжить.');
          Readln;
        end;
      5:
        begin
          AddMenu(Head, Tail, HeadP, TailP);
          Writeln('Нажмите Enter, чтобы продолжить.');
          Readln;
        end;
      6:
        begin
          DeleteMenu(Head, Tail, HeadP, TailP);
          Writeln('Нажмите Enter, чтобы продолжить.');
          Readln;
        end;
      7:
        begin
          EditMenu(Head, Tail, HeadP, TailP);
          Writeln('Нажмите Enter, чтобы продолжить.');
          Readln;
        end;
      8:
        begin
          Writeln('Нажмите Enter, чтобы продолжить.');
          Readln;
        end;
      9:
        begin
          isMenu:=false;
        end;
      10:
        begin
          Writeln('Нажмите Enter, чтобы продолжить.');
          Readln;
        end;
    end;
  end;

end.
