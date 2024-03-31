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
  writeln('1) Чтение данных из файла');
  writeln('2) Просмотр всего списка');
  writeln('   1) Список заказов');
  writeln('   2) Список курьеров');
  writeln('   3) Список заказов отсортированный по адресу доставки');
  writeln('   4) Список курьеров отсортированный по ФИО');
  writeln('3) Выдать список всех заказов курьера в последовательности их выполнения');
  writeln('4) Поиск данных с использованием фильтров');
  writeln('5) Добавление данных в список');
  writeln('6) Удаление данных из списка');
  writeln('7) Редактирование данных');
  writeln('8) Наиболее эффективное распределение заказов между курьерами');
  writeln('9) Выход из программы без сохранения изменений');
  writeln('10) Выход с сохранением изменений');
  write('Выберите необходимый подпункт: ');
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
  writeln('1) Чтение данных из файла');
  writeln('2) Просмотр всего списка');
  writeln('3) Выдать список всех заказов курьера в последовательности их выполнения');
  writeln('4) Поиск данных с использованием фильтров');
  writeln('   1) Поиск заказа по ID');
  writeln('   2) Поиск заказа по адресу');
  writeln('   3) Поиск курьера по ID');
  writeln('   4) Поиск заказа по ФИО');
  writeln('5) Добавление данных в список');
  writeln('6) Удаление данных из списка');
  writeln('7) Редактирование данных');
  writeln('8) Наиболее эффективное распределение заказов между курьерами');
  writeln('9) Выход из программы без сохранения изменений');
  writeln('10) Выход с сохранением изменений');
  write('Выберите необходимый подпункт: ');
  readln(menuVal);
  case menuVal of
    1:
      begin
        Write('Введите необходимый ID: ');
        readln(searchID);
        OrderByID(HeadOrder, searchID, searchStr, CompareOrderID);
      end;
    2:
      begin
        Write('Введите необходимый адрес: ');
        readln(searchStr);
        OrdersByAddr(HeadOrder, TailOrder, searchID,searchStr, CompareOrderAddr);
      end;
    3:
      begin
        Write('Введите необходимый ID: ');
        readln(searchID);
        PostmanByID(HeadPostman, searchID, searchStr, ComparePostmanID);
      end;
    4:
      begin
        Write('Введите искомое ФИО: ');
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
  writeln('1) Чтение данных из файла');
  writeln('2) Просмотр всего списка');
  writeln('3) Выдать список всех заказов курьера в последовательности их выполнения');
  writeln('4) Поиск данных с использованием фильтров');
  writeln('5) Добавление данных в список');
  writeln('   1) В список заказов');
  writeln('   2) В список курьеров');
  writeln('6) Удаление данных из списка');
  writeln('7) Редактирование данных');
  writeln('8) Наиболее эффективное распределение заказов между курьерами');
  writeln('9) Выход из программы без сохранения изменений');
  writeln('10) Выход с сохранением изменений');
  write('Выберите необходимый подпункт: ');
  readln(menuVal);
  case menuVal of
    1:
      begin
        while isWriting do
        begin

          Write('Введите адрес доставки: ');
          Readln(srtParam);
          OrderData.addr := srtParam;


          isCorrect:=true;
          while isCorrect do
          begin
            Write('Введите время (с 1 до 24) с которого можно доставить : ');
            Readln(integerParam);
            if (integerParam>0) and (integerParam<=24) then
            begin
              isCorrect:=false;
              OrderData.time_in := integerParam;
            end
            else
              Writeln('Некорректные данные, попробуйте еще раз');
          end;
          isCorrect:=true;


          while isCorrect do
          begin
            Write('Введите время (с 1 до 24) до которого можно доставить : ');
            Readln(integerParam);
            if (integerParam>0) and (integerParam<=24) then
            begin
              isCorrect:=false;
              OrderData.time_out := integerParam;
            end
            else
              Writeln('Некорректные данные, попробуйте еще раз');
          end;
          Write('Введите объем(м^3) заказа: ');
          Readln(doubleParam);
          OrderData.volume := doubleParam;
          Write('Введите вес(кг) заказа: ');
          Readln(doubleParam);
          OrderData.weight := doubleParam;
          AppendOrder(HeadOrder, TailOrder, OrderData);

          Write('Добавить еще один заказ(Да/нет): ');
          Readln(exitStr);
          while not ((exitStr='Нет') or (exitStr='нет') or (exitStr='Да') or (exitStr='да')) do
          begin
            Write('Неверный ввод, повторите попытку: ');
            Readln(exitStr);
          end;
          if (exitStr='Нет') or (exitStr='нет')  then
            isWriting:=False;
        end;
      end;
    2:
      begin
        while isWriting do
        begin
          Write('Введите ФИО: ');
          Readln(srtParam);
          PostmanData.fio := srtParam;

          Write('Введите время (с 1 до 24) с которого работает : ');
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
              Writeln('Некорректные данные, попробуйте еще раз');
          end;
          isCorrect:=true;

          Write('Введите время (с 1 до 24) до которого работает : ');
          while isCorrect do
          begin
            Readln(integerParam);
            if (integerParam>0) and (integerParam<=24) then
            begin
              isCorrect:=false;
              PostmanData.time_out := integerParam;
            end
            else
              Writeln('Некорректные данные, попробуйте еще раз');
          end;
          Write('Введите объем(м^3) заказа: ');
          Readln(doubleParam);
          PostmanData.volume := doubleParam;
          Write('Введите вес(кг) заказа: ');
          Readln(doubleParam);
          PostmanData.weight := doubleParam;
          AppendPostman(HeadPostman, TailPostman, PostmanData);

          Write('Добавить еще одиного курьера(Да/нет): ');
          Readln(exitStr);
          while not ((exitStr='Нет') or (exitStr='нет') or (exitStr='Да') or (exitStr='да')) do
          begin
            Write('Неверный ввод, повторите попытку: ');
            Readln(exitStr);
          end;
          if (exitStr='Нет') or (exitStr='нет')  then
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
  writeln('1) Чтение данных из файла');
  writeln('2) Просмотр всего списка');
  writeln('3) Выдать список всех заказов курьера в последовательности их выполнения');
  writeln('4) Поиск данных с использованием фильтров');
  writeln('5) Добавление данных в список');
  writeln('6) Удаление данных из списка');
  writeln('   1) Из списка заказов');
  writeln('   2) Из списка курьеров');
  writeln('7) Редактирование данных');
  writeln('8) Наиболее эффективное распределение заказов между курьерами');
  writeln('9) Выход из программы без сохранения изменений');
  writeln('10) Выход с сохранением изменений');
  write('Выберите необходимый подпункт: ');
  readln(menuVal);
  case menuVal of
    1:
      begin
        PrintOrders(HeadOrder, CompareID);
        Write('Введите ID заказа, который необходимо удалить: ');
        Readln(ID);
        DeleteOrder(HeadOrder, ID);

      end;
    2:
      begin
        PrintPostmans(HeadPostman, CompareID);
        Write('Введите ID курьера, которого необходимо удалить: ');
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
  writeln('1) Чтение данных из файла');
  writeln('2) Просмотр всего списка');
  writeln('3) Выдать список всех заказов курьера в последовательности их выполнения');
  writeln('4) Поиск данных с использованием фильтров');
  writeln('5) Добавление данных в список');
  writeln('6) Удаление данных из списка');
  writeln('7) Редактирование данных');
  writeln('   1) Из списка заказов');
  writeln('   2) Из списка курьеров');
  writeln('8) Наиболее эффективное распределение заказов между курьерами');
  writeln('9) Выход из программы без сохранения изменений');
  writeln('10) Выход с сохранением изменений');
  write('Выберите необходимый подпункт: ');
  readln(menuVal);
  case menuVal of
    1:
      begin
        Write('Введите ID заказа, который необходимо отредактировать: ');
        Readln(ID);
        EditOrder(HeadOrder, TailOrder, ID);
      end;
    2:
      begin
        Write('Введите ID курьера, которого необходимо отредактировать: ');
        Readln(ID);
        EditPostman(HeadPostman, TailPostman, ID);
      end;
  end;
end;

end.
