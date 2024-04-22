unit ownFunctions;

interface

uses
  System.SysUtils,
  Windows,
  orderModule,
  postmanModule,
  specialFunction,
  fileModule;

procedure LookMenu(const HeadOrder: POrder; const HeadPostman: PPostman);
procedure SearhMenu(var HeadOrder, TailOrder: POrder;
  var HeadPostman, TailPostman: PPostman);
procedure clrscr;
procedure AddMenu(var HeadOrder, TailOrder: POrder;
  var HeadPostman, TailPostman: PPostman);
procedure DeleteMenu(var HeadOrder, TailOrder: POrder;
  var HeadPostman, TailPostman: PPostman; var DeliveryHead: PDelivery);
procedure EditMenu(var HeadOrder, TailOrder: POrder;
  var HeadPostman, TailPostman: PPostman);
procedure SortPrintMenu(var OrderHead: POrder; var PostmanHead: PPostman);
procedure SpecialFunctionMenu(var Head, Tail: POrder;
  var HeadP, TailP: PPostman; var HeadD, TailD: PDelivery);
function FindOrderInDelivery(DeliveryHead: PDelivery;
  OrderNode: POrder): boolean;

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

function FindOrderInDelivery(DeliveryHead: PDelivery;
  OrderNode: POrder): boolean;

var
  flag: boolean;
  DeliveryNode: PDelivery;
begin
  flag := false;
  Result := false;
  DeliveryNode := DeliveryHead.next;
  while (DeliveryNode <> nil) and (not flag) do
  begin
    if DeliveryNode.data.orderId = OrderNode.data.id then
    begin
      Result := true;
      flag := false;
    end;
    DeliveryNode := DeliveryNode.next;
  end;

end;

function FindPostmanInDelivery(DeliveryHead: PDelivery;
  PostmanNode: PPostman): boolean;

var
  flag: boolean;
  DeliveryNode: PDelivery;
begin
  flag := false;
  Result := false;
  DeliveryNode := DeliveryHead.next;
  while (DeliveryNode <> nil) and (not flag) do
  begin
    if DeliveryNode.data.postmanId = PostmanNode.data.id then
    begin
      Result := true;
      flag := false;
    end;
    DeliveryNode := DeliveryNode.next;
  end;

end;

procedure LookMenu(const HeadOrder: POrder; const HeadPostman: PPostman);
var
  menuVal: Integer;
begin
  clrscr();
  writeln('1) Чтение данных из файла');
  writeln('2) Просмотр всего списка');
  writeln('   1) Список заказов');
  writeln('   2) Список курьеров');
  writeln('3) Сортировка');
  writeln('4) Поиск данных с использованием фильтров');
  writeln('5) Добавление данных в список');
  writeln('6) Удаление данных из списка');
  writeln('7) Редактирование данных');
  writeln('8) Наиболее эффективное распределение заказов между курьерами');
  writeln('9) Выход из программы без сохранения изменений');
  writeln('10) Выход с сохранением изменений');
  write('Выберите необходимый подпункт (0 - выход): ');
  readln(menuVal);
  case menuVal of
    1:
      begin
        PrintOrders(HeadOrder);
      end;
    2:
      begin
        PrintPostmans(HeadPostman);
      end;
    0:
    end;
  end;

  procedure SortPrintMenu(var OrderHead: POrder; var PostmanHead: PPostman);
  var
    menuVal, argID: Integer;
    isCorrect: boolean;
  begin
    clrscr();
    writeln('1) Чтение данных из файла');
    writeln('2) Просмотр всего списка');
    writeln('3) Сортировка');
    writeln('   1) Сортировка заказов по ID');
    writeln('   2) Сортировка заказов по адресу доставки');
    writeln('   3) Сортировка курьеров по ID');
    writeln('   4) Сортировка курьеров по ФИО');
    writeln('4) Поиск данных с использованием фильтров');
    writeln('5) Добавление данных в список');
    writeln('6) Удаление данных из списка');
    writeln('7) Редактирование данных');
    writeln('8) Наиболее эффективное распределение заказов между курьерами');
    writeln('9) Выход из программы без сохранения изменений');
    writeln('10) Выход с сохранением изменений');
    write('Выберите необходимый подпункт (0 - выход): ');
    readln(menuVal);
    case menuVal of
      1:
        begin
          SortOrders(OrderHead, CompareID);
          writeln('Список заказов отсортирован по ID, нажмите Enter чтобы продолжить.');
          readln;
        end;
      2:
        begin
          SortOrders(OrderHead, CompareStr);
          writeln('Список заказов отсортирован по адресу доставки, нажмите Enter чтобы продолжить.');
          readln;
        end;
      3:
        begin
          SortPorstman(PostmanHead, CompareID);
          writeln('Список курьеров отсортирован, нажмите Enter чтобы продолжить.');
          readln;
        end;
      4:
        begin
          SortPorstman(PostmanHead, CompareStr);
          writeln('Список курьеров отсортирован по ФИО, нажмите Enter чтобы продолжить.');
          readln;
        end;
      0:
      end;
    end;

    procedure SearhMenu(var HeadOrder, TailOrder: POrder;
      var HeadPostman, TailPostman: PPostman);
    var
      menuVal: Integer;
      searchStr: string;
      searchID: Integer;
      isCorrect: boolean;
    begin
      clrscr();
      searchID := 0;
      searchStr := '';
      writeln('1) Чтение данных из файла');
      writeln('2) Просмотр всего списка');
      writeln('3) Сортировка');
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
      write('Выберите необходимый подпункт (0 - выход): ');
      readln(menuVal);
      isCorrect := false;
      case menuVal of
        1:
          begin
            while not isCorrect do
            begin
              Write('Введите необходимый ID: ');
              try
                readln(searchID);
                OrderByID(HeadOrder, searchID, searchStr, CompareOrderID);
                isCorrect := true;
              except
                writeln('Некорректные данные, попробуйте еще раз ');
              end;
            end;
          end;
        2:
          begin
            Write('Введите необходимый адрес: ');
            readln(searchStr);
            OrdersByAddr(HeadOrder, TailOrder, searchID, searchStr,
              CompareOrderAddr);
          end;
        3:
          begin
            while not isCorrect do
            begin
              Write('Введите необходимый ID: ');
              try
                readln(searchID);
                PostmanByID(HeadPostman, searchID, searchStr, ComparePostmanID);
                isCorrect := true;
              except
                writeln('Некорректные данные, попробуйте еще раз ');
              end;
            end;
          end;
        4:
          begin
            Write('Введите искомое ФИО: ');
            readln(searchStr);
            PostmanByFio(HeadPostman, TailPostman, searchID, searchStr,
              ComparePostmanFio);
          end;
        0:
        end;
      end;

      procedure AddMenu(var HeadOrder, TailOrder: POrder;
        var HeadPostman, TailPostman: PPostman);
      var
        menuVal: Integer;
        str: string;
        isWriting, isCorrect: boolean;
        srtParam: string;
        exitStr: String[5];
        doubleParam: double;
        integerParam: Integer;
        OrderData: TOrderData;
        PostmanData: TPostmanData;
      begin
        isWriting := true;
        clrscr();
        writeln('1) Чтение данных из файла');
        writeln('2) Просмотр всего списка');
        writeln('3) Сортировка');
        writeln('4) Поиск данных с использованием фильтров');
        writeln('5) Добавление данных в список');
        writeln('   1) В список заказов');
        writeln('   2) В список курьеров');
        writeln('6) Удаление данных из списка');
        writeln('7) Редактирование данных');
        writeln('8) Наиболее эффективное распределение заказов между курьерами');
        writeln('9) Выход из программы без сохранения изменений');
        writeln('10) Выход с сохранением изменений');
        write('Выберите необходимый подпункт (0 - выход): ');
        readln(menuVal);
        case menuVal of
          1:
            begin
              SortOrders(HeadOrder, CompareID);
              while isWriting do
              begin

                Write('Введите адрес доставки: ');
                readln(srtParam);
                OrderData.addr := srtParam;

                isCorrect := false;
                while not isCorrect do
                begin
                  Write('Введите время (с 0 до 24) с которого можно доставить : ');
                  try
                    readln(integerParam);
                    if (integerParam >= 0) and (integerParam < 24) then
                    begin
                      isCorrect := true;
                      OrderData.time_in := integerParam;
                    end
                    else
                      writeln('Некорректные данные, попробуйте еще раз');
                  except
                    writeln('Введены некоректные данные');
                  end;
                end;
                isCorrect := false;

                while not isCorrect do
                begin
                  Write('Введите время (с ', OrderData.time_in,
                    ' до 24) до которого можно доставить : ');
                  try
                    readln(integerParam);
                    if (integerParam > OrderData.time_in) and
                      (integerParam <= 24) then
                    begin
                      isCorrect := true;
                      OrderData.time_out := integerParam;
                    end
                    else
                      writeln('Некорректные данные, попробуйте еще раз');
                  except
                    writeln('Некорректные данные, попробуйте еще раз');
                  end;
                end;
                isCorrect := false;

                while not isCorrect do
                begin
                  Write('Введите объем(м^3) заказа: ');
                  try
                    readln(doubleParam);
                    if doubleParam > 0 then
                    begin
                      OrderData.volume := doubleParam;
                      isCorrect := true;
                    end
                    else
                      writeln('Объем заказа должен быть больше нуля.');
                  except
                    writeln('Некорректные данные, попробуйте еще раз');
                  end;
                end;

                isCorrect := false;

                while not isCorrect do
                begin
                  Write('Введите вес(кг) заказа: ');
                  try
                    readln(doubleParam);
                    if doubleParam > 0 then
                    begin
                      OrderData.weight := doubleParam;
                      isCorrect := true;
                    end
                    else
                      writeln('Вес заказа должен быть больше нуля.');
                  except
                    writeln('Введены некоректные данные');
                  end;

                end;
                AppendOrder(HeadOrder, TailOrder, OrderData);
                Write('Добавить еще один заказ(Да/нет): ');
                readln(exitStr);
                while not((exitStr = 'Нет') or (exitStr = 'нет') or
                  (exitStr = 'Да') or (exitStr = 'да')) do
                begin
                  Write('Неверный ввод, повторите попытку: ');
                  readln(exitStr);
                end;
                if (exitStr = 'Нет') or (exitStr = 'нет') then
                  isWriting := false;
              end;
            end;
          2:
            begin
              SortPorstman(HeadPostman, CompareID);
              while isWriting do
              begin
                Write('Введите ФИО: ');
                readln(srtParam);
                PostmanData.fio := srtParam;

                isCorrect := false;
                while not isCorrect do
                begin
                  Write('Введите время (с 0 до 24) с которого работает : ');
                  try
                    readln(integerParam);
                    if (integerParam >= 0) and (integerParam < 24) then
                    begin
                      isCorrect := true;
                      PostmanData.time_in := integerParam;
                    end
                    else
                      writeln('Некорректные данные, попробуйте еще раз');
                  except
                    writeln('Некорректные данные, попробуйте еще раз');
                  end;
                end;
                isCorrect := false;

                while not isCorrect do
                begin
                  Write('Введите время (с ', PostmanData.time_in,
                    ' до 24) до которого работает : ');
                  try
                    readln(integerParam);
                    if (integerParam > PostmanData.time_in) and
                      (integerParam <= 24) then
                    begin
                      isCorrect := true;
                      PostmanData.time_out := integerParam;
                    end
                    else
                      writeln('Некорректные данные, попробуйте еще раз');
                  except
                    writeln('Некорректные данные, попробуйте еще раз');
                  end;
                end;
                isCorrect := false;

                while not isCorrect do
                begin
                  Write('Введите объем(м^3) заказа: ');
                  try
                    readln(doubleParam);
                    PostmanData.volume := doubleParam;
                    isCorrect := true;
                  except
                    writeln('Введены некоректные данные');
                  end;

                end;
                isCorrect := false;

                while not isCorrect do
                begin
                  Write('Введите вес(кг) заказа: ');
                  try
                    readln(doubleParam);
                    PostmanData.weight := doubleParam;
                    isCorrect := true;
                  except
                    writeln('Введены некоректные данные');
                  end;

                end;

                AppendPostman(HeadPostman, TailPostman, PostmanData);

                Write('Добавить еще одиного курьера(Да/нет): ');
                readln(exitStr);
                while not((exitStr = 'Нет') or (exitStr = 'нет') or
                  (exitStr = 'Да') or (exitStr = 'да')) do
                begin
                  Write('Неверный ввод, повторите попытку: ');
                  readln(exitStr);
                end;
                if (exitStr = 'Нет') or (exitStr = 'нет') then
                  isWriting := false;
              end;
            end;
          0:
          end;
        end;

        procedure DeleteMenu(var HeadOrder, TailOrder: POrder;
          var HeadPostman, TailPostman: PPostman; var DeliveryHead: PDelivery);
        var
          menuVal: Integer;
          str: string;
          isWriting, isCorrect: boolean;
          id: Integer;
          OrderData: TOrderData;
          PostmanData: TPostmanData;
          order: POrder;
          postman: PPostman;
        begin
          isWriting := true;
          clrscr();
          writeln('1) Чтение данных из файла');
          writeln('2) Просмотр всего списка');
          writeln('3) Сортировка');
          writeln('4) Поиск данных с использованием фильтров');
          writeln('5) Добавление данных в список');
          writeln('6) Удаление данных из списка');
          writeln('   1) Из списка заказов');
          writeln('   2) Из списка курьеров');
          writeln('7) Редактирование данных');
          writeln('8) Наиболее эффективное распределение заказов между курьерами');
          writeln('9) Выход из программы без сохранения изменений');
          writeln('10) Выход с сохранением изменений');
          write('Выберите необходимый подпункт (0 - выход): ');
          readln(menuVal);
          isCorrect := false;
          case menuVal of
            1:
              begin
                SortOrders(HeadOrder, CompareID);
                PrintOrders(HeadOrder);
                while not isCorrect do
                begin
                  Write('Введите ID заказа, который необходимо удалить: ');
                  try
                    readln(id);

                    str := '';

                    order := FindOrder(HeadOrder, id, str, CompareOrderID);

                    if order = nil then
                      writeln('Данной записи не найдено, удаление не возможно')
                    else if FindOrderInDelivery(DeliveryHead, order) then
                      writeln('Невозможно удалить данный заказ, курьер принял его в доставку')
                    else
                    begin

                      if (order^.prev <> nil) then
                        order^.prev^.next := order^.next;
                      if order^.next <> nil then
                        order^.next^.prev := order^.prev;
                      if order^.next = nil then
                        TailOrder := order^.prev;
                      Dispose(order);
                      writeln('Заказ удален');

                    end;

                    isCorrect := true;
                  except
                    writeln('Некорректные данные, попробуйте еще раз');
                  end;
                end;

              end;
            2:
              begin
                SortPorstman(HeadPostman, CompareID);
                PrintPostmans(HeadPostman);
                while not isCorrect do
                begin
                  Write('Введите ID курьера, которого необходимо удалить: ');
                  try
                    readln(id);
                    str := '';

                    postman := FindPostman(HeadPostman, id, str,
                      ComparePostmanID);

                    if postman = nil then
                      writeln('Данной записи не найдено, удаление не возможно')
                    else if FindPostmanInDelivery(DeliveryHead, postman) then
                      writeln('Невозможно удалить курьера, курьер принял заказы в доставку')
                    else
                    begin

                      if (postman^.prev <> nil) then
                        postman^.prev^.next := postman^.next;
                      if postman^.next <> nil then
                        postman^.next^.prev := postman^.prev;
                      if postman^.next = nil then
                        TailPostman := postman^.prev;
                      Dispose(postman);
                      writeln('Курьер удален');

                    end;
                    isCorrect := true;
                  except
                    writeln('Некорректные данные, попробуйте еще раз');
                  end;
                end;
              end;
            0:
            end;
          end;

          procedure EditMenu(var HeadOrder, TailOrder: POrder;
            var HeadPostman, TailPostman: PPostman);
          var
            menuVal: Integer;
            str: string;
            isWriting, isCorrect: boolean;
            id: Integer;
            OrderData: TOrderData;
            PostmanData: TPostmanData;
            order: POrder;
            postman: PPostman;
          begin
            isWriting := true;
            clrscr();
            writeln('1) Чтение данных из файла');
            writeln('2) Просмотр всего списка');
            writeln('3) Сортировка');
            writeln('4) Поиск данных с использованием фильтров');
            writeln('5) Добавление данных в список');
            writeln('6) Удаление данных из списка');
            writeln('7) Редактирование данных');
            writeln('   1) Из списка заказов');
            writeln('   2) Из списка курьеров');
            writeln('8) Наиболее эффективное распределение заказов между курьерами');
            writeln('9) Выход из программы без сохранения изменений');
            writeln('10) Выход с сохранением изменений');
            write('Выберите необходимый подпункт (0 - выход): ');
            readln(menuVal);
            isCorrect := false;
            case menuVal of
              1:
                begin
                  SortOrders(HeadOrder, CompareID);
                  PrintOrders(HeadOrder);
                  while not isCorrect do
                  begin
                    Write('Введите ID заказа, который необходимо отредактировать: ');
                    try
                      readln(id);
                      order := FindOrder(HeadOrder, id, str, CompareOrderID);
                      if order <> nil then
                      begin
                        EditOrder(HeadOrder, TailOrder, id, order);
                        isCorrect := true;
                      end
                      else
                        writeln('Невозможно изменить заказ, т.к. он распределен в доставку');
                    except
                      writeln('Некорректные данные, попробуйте еще раз');
                    end;
                  end;
                end;
              2:
                begin
                  SortPorstman(HeadPostman, CompareID);
                  PrintPostmans(HeadPostman);
                  while not isCorrect do
                  begin
                    Write('Введите ID курьера, которого необходимо отредактировать: ');
                    try
                      readln(id);
                      postman := FindPostman(HeadPostman, id, str,
                        ComparePostmanID);
                      EditPostman(HeadPostman, TailPostman, id, postman);
                      isCorrect := true;

                    except
                      writeln('Некорректные данные, попробуйте еще раз');
                    end;
                  end;
                end;
              0:
              end;
            end;

            procedure SpecialFunctionMenu(var Head, Tail: POrder;
              var HeadP, TailP: PPostman; var HeadD, TailD: PDelivery);
            var
              menuVal: Integer;
              str: string;
              isWriting, isCorrect: boolean;
              id: Integer;
              OrderData: TOrderData;
              PostmanData: TPostmanData;
            begin
              isWriting := true;
              clrscr();
              writeln('1) Чтение данных из файла');
              writeln('2) Просмотр всего списка');
              writeln('3) Сортировка');
              writeln('4) Поиск данных с использованием фильтров');
              writeln('5) Добавление данных в список');
              writeln('6) Удаление данных из списка');
              writeln('7) Редактирование данных');
              writeln('8) Наиболее эффективное распределение заказов между курьерами');
              writeln('   1) Распредилить заказы');
              writeln('   2) Просмотреть распределение');
              writeln('   3) Просмотреть распределение курьера');
              writeln('9) Выход из программы без сохранения изменений');
              writeln('10) Выход с сохранением изменений');
              write('Выберите необходимый подпункт (0 - выход): ');
              readln(menuVal);
              isCorrect := false;
              case menuVal of
                1:
                  begin
                    AssignOrders(Head, Tail, HeadP, TailP, HeadD, TailD);
                  end;
                2:
                  begin
                    Print(HeadD);
                  end;
                3:
                  begin
                    while not isCorrect do
                    begin
                      Write('Введите ID курьера, заказы которого вы хотите просмотреть: ');
                      try
                        readln(id);
                        PrintByID(HeadD, id, CompareIDDel);
                        isCorrect := true;
                      except
                        writeln('Некорректные данные, попробуйте еще раз');
                      end;
                    end;
                  end;
                0:
                end;
              end;

end.
