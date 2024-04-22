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
    writeln('1) Чтение данных из файла');
    writeln('2) Просмотр всего списка');
    writeln('3) Сортировка');
    writeln('4) Поиск данных с использованием фильтров');
    writeln('5) Добавление данных в список');
    writeln('6) Удаление данных из списка');
    writeln('7) Редактирование данных');
    writeln('8) Наиболее эффективное распределение заказов между курьерами');
    writeln('9) Выход из программы без сохранения изменений');
    writeln('10) Выход с сохранением изменений');
    write('Выберите необходимое пункт: ');
    try
      readln(menuVal);
      case menuVal of
        1:
          begin
            if (Head.data.id<>0) or (HeadP.data.id<>0) or (HeadD.data.id<>0) then
            begin
              Write('Ваши списки не пустые, невозможно прочитать новые данные');
              readln;
            end
            else
              OpenFiles(Head, Tail, HeadP, TailP, HeadD, TailD);
            readln;
          end;
        2:
          begin
            LookMenu(Head, HeadP);
            writeln('Нажмите Enter, чтобы продолжить.');
            readln;
          end;
        3:
          begin
            SortPrintMenu(Head, HeadP);
            writeln('Нажмите Enter, чтобы продолжить.');
            readln;
          end;
        4:
          begin
            SearhMenu(Head, Tail, HeadP, TailP);
            writeln('Нажмите Enter, чтобы продолжить.');
            readln;
          end;
        5:
          begin
            AddMenu(Head, Tail, HeadP, TailP);
            writeln('Нажмите Enter, чтобы продолжить.');
            readln;
          end;
        6:
          begin
            DeleteMenu(Head, Tail, HeadP, TailP, HeadD);
            writeln('Нажмите Enter, чтобы продолжить.');
            readln;
          end;
        7:
          begin
            EditMenu(Head, Tail, HeadP, TailP);
            writeln('Нажмите Enter, чтобы продолжить.');
            readln;
          end;
        8:
          begin
            SpecialFunctionMenu(Head, Tail, HeadP, TailP, HeadD, TailD);
            writeln('Нажмите Enter, чтобы продолжить.');
            readln;
          end;
        9:
          begin
            isMenu := false;
          end;
        10:
          begin
            saveToFile(Head, HeadP, HeadD);
            writeln('Нажмите Enter, чтобы продолжить.');
            readln;
            isMenu := false;
          end;
      end;
    except
      Writeln('Некорректные данные, попробуйте еще раз');
      Readln;
    end;
  end;

end.
