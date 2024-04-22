unit orderModule;

interface

type

  POrder = ^TOrder;

  TOrderData = record
    id: Integer;
    addr: string[100];
    time_in: Integer;
    time_out: Integer;
    volume: Double;
    weight: Double;
  end;

  TOrder = record
    data: TOrderData;
    next: POrder;
    prev: POrder;
  end;

  TCompare = function(const zap: POrder; argID: Integer;
    argAddr: string): Integer;
  TCompareSort = function(argID1, argID2: Integer; argSrt1, argStr2: string;
    argTime1, argTime2: Integer; argTime1O, argTime2O: Integer): boolean;

procedure PrintOrders(Head: POrder);
procedure AppendOrder(var Head, Tail: POrder; Item: TOrderData);
procedure AppendOrderFromFile(var Head, Tail: POrder; Item: TOrderData);
procedure OrderByID(var Head: POrder; argID: Integer; argAddr: String;
  cmp: TCompare);
procedure OrdersByAddr(Head, Tail: POrder; argID: Integer; argAddr: string;
  cmp: TCompare);
// procedure DeleteOrder(var Head, Tail: POrder; var DeliveryHead: PDelivery;
// const id: Integer);
procedure EditOrder(Head, Tail: POrder; const id: Integer;
  const inDelivery: POrder);
function CompareOrderID(const zap: POrder; argID: Integer;
  argAddr: string): Integer;
function CompareOrderAddr(const zap: POrder; argID: Integer;
  argAddr: string): Integer;
procedure SortOrders(var h: POrder; cmp: TCompareSort);
function FindOrder(var Head: POrder; argID: Integer; argAddr: string;
  cmp: TCompare): POrder;

implementation

uses
  System.SysUtils,
  ownFunctions,
  compareModule;

// Добавить в список
procedure AppendOrder(var Head, Tail: POrder; Item: TOrderData);
var
  NewNode: POrder;
  LastID: Integer;
begin
  // Проверяем, если головной узел пустой, то устанавливаем начальное значение ID как 0
  LastID := Head^.data.id;

  Inc(LastID); // Автоинкремент для нового ID
  Item.id := LastID; // Установка нового ID для добавляемой записи
  Head^.data.id := LastID;
  New(NewNode);
  NewNode^.data := Item;
  NewNode^.next := nil;

  if Tail = nil then
  begin
    NewNode^.prev := Head;
    Tail := NewNode;
    Tail := NewNode;
  end
  else
  begin
    NewNode^.prev := Tail;
    Tail^.next := NewNode;
    Tail := NewNode;
  end;
end;

procedure AppendOrderFromFile(var Head, Tail: POrder; Item: TOrderData);
var
  NewNode: POrder;
  LastID: Integer;
begin
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
  // Иначе берем ID последнего узла
  begin
    LastID := Head^.data.id;

    New(NewNode);
    NewNode^.data := Item;
    NewNode^.next := nil;

    if Tail = nil then
    begin
      NewNode^.prev := Head;
      Tail := NewNode;
      Tail := NewNode;
    end
    else
    begin
      NewNode^.prev := Tail;
      Tail^.next := NewNode;
      Tail := NewNode;
    end;
  end;

end;

// СОРТИРОВКА
procedure SortOrders(var h: POrder; cmp: TCompareSort);
var
  t, b, temp: POrder;
begin
  t := h^.next;
  while (t <> nil) do
  begin
    temp := t^.next;
    b := t^.prev;
    while (b <> nil) and (cmp(t^.data.id, b^.data.id, t^.data.addr,
      b^.data.addr, t^.data.time_in, b^.data.time_in, t^.data.time_out,
      b^.data.time_out)) and ((b^.prev <> nil)) do
    begin
      b := b^.prev;
    end;
    if (b = nil) then
    begin
      t^.prev^.next := t^.next;
      if t^.next <> nil then
        t^.next^.prev := t^.prev;
      t^.next := h;
      t^.prev := nil;
      h^.prev := t;
      h := t;
    end
    else
    begin
      if b^.next <> t then
      begin
        t^.prev^.next := t^.next;
        if t^.next <> nil then
          t^.next^.prev := t^.prev;
        t^.next := b^.next;
        b^.next^.prev := t;
        b^.next := t;
        t^.prev := b;
      end;
    end;
    t := temp;
  end;
end;

// procedure SortOrders(var h: POrder; cmp: TCompareSort);
// var
// t, b, temp, head: POrder;
// begin
// t := h^.next;
// head := h; // сохраняем ссылку на голову списка
//
// while (t <> nil) do
// begin
// b := t^.prev;
// while (b <> nil) and (cmp(t^.data.id, b^.data.id, t^.data.addr, b^.data.addr, t^.data.time_in, b^.data.time_in, t^.data.time_out, b^.data.time_out)) and ((b^.prev <> nil)) do
// begin
// // Swap pointers
// temp := t^.next;
// t^.next := b^.next;
// if t^.next <> nil then
// t^.next^.prev := t;
// b^.next := temp;
// if b^.next <> nil then
// b^.next^.prev := b;
//
// temp := t^.prev;
// t^.prev := b^.prev;
// if t^.prev <> nil then
// t^.prev^.next := t;
// b^.prev := temp;
// if b^.prev <> nil then
// b^.prev^.next := b;
//
// // Обновляем голову списка только если она не была перемещена
// if head = b then
// head := t
// else if head = t then
// head := b;
//
// temp := t;
// t := b;
// b := temp;
// end;
//
// t := t^.next;
// end;
//
// // Обновляем переменную h на новую голову списка
// h := head;
// end;






// Вывод списка

procedure PrintOrders(Head: POrder);
var
  Current: POrder;
  Index: Integer;
begin
  Writeln('Список всех заказов:');
  Writeln('|------------------------------------------------------------------------------|');
  Writeln('|  ID |       Адрес     |   Время с   |   Время до  |   Объем     |     Вес    |');
  Writeln('|-----+-----------------+-------------+-------------+-------------+------------|');
  Current := Head.next; // Изменено: начинаем с первого элемента списка
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

function CompareOrderID(const zap: POrder; argID: Integer;
  argAddr: string): Integer;
begin
  if zap^.data.id = argID then
    Result := 1
  else if zap^.data.id < argID then
    Result := 0
  else
    Result := 2;
end;

function CompareOrderAddr(const zap: POrder; argID: Integer;
  argAddr: string): Integer;
begin
  if zap^.data.addr = argAddr then
    Result := 1
  else if zap^.data.addr < argAddr then
    Result := 0
  else
    Result := 2;
end;

// Сортировка

// Поиск по ID
function FindOrder(var Head: POrder; argID: Integer; argAddr: string;
  cmp: TCompare): POrder;
var
  l: POrder;
  found: boolean;
begin
  l := Head^.next; // Пропускаем голову списка
  found := False;

  while (l <> nil) and (cmp(l, argID, argAddr) <> 1) do
    l := l^.next;

  if l <> nil then
  begin
    Result := l;
    found := True;
  end;

  if not found then
    Result := nil;
end;

procedure OrderByID(var Head: POrder; argID: Integer; argAddr: string;
  cmp: TCompare);
var
  order: POrder;
  found: boolean;
begin
  SortOrders(Head, CompareID);
  found := False;
  order := FindOrder(Head, argID, argAddr, cmp);
  if order <> nil then
  begin
    found := True;
    Writeln('ID: ', order^.data.id);
    Writeln('Адрес: ', order^.data.addr);
    Writeln('Время прибытия: ', order^.data.time_in);
    Writeln('Время убытия: ', order^.data.time_out);
    Writeln('Объем: ', order^.data.volume:4:2);
    Writeln('Вес: ', order^.data.weight:4:2);
    // Вывод остальных данных
    Writeln;
  end;
  if not found then
    Writeln('Запись с таким ID не найдена');
end;

// Поиск по полую "Адрес"

procedure OrdersByAddr(Head, Tail: POrder; argID: Integer; argAddr: string;
  cmp: TCompare);
var
  CurrentL, CurrentR: POrder;
  found: boolean;
begin
  // Сначала сортируем список в алфавитном порядке
  SortOrders(Head, CompareStr);
  found := False;

  // Ищем первую запись с совпадающим адресом
  CurrentL := FindOrder(Head, argID, argAddr, cmp);
  CurrentR := CurrentL;
  // Если запись не найдена, выходим из процедуры
  if (CurrentL <> nil) and (CurrentR <> nil) then
  begin
    // Выводим найденную запись
    Writeln('Найден(ы) заказ(ы):');
    Writeln('ID: ', CurrentR^.data.id);
    Writeln('Адрес: ', CurrentR^.data.addr);
    Writeln('Время прибытия: ', CurrentR^.data.time_in);
    Writeln('Время убытия: ', CurrentR^.data.time_out);
    Writeln('Объем: ', CurrentR^.data.volume:4:2);
    Writeln('Вес: ', CurrentR^.data.weight:4:2);
    // Вывод остальных данных
    Writeln;
    found := True;

    // Перемещаемся к предыдущим записям с совпадающим адресом
    while (CurrentL^.prev <> nil) and (CurrentL^.prev^.data.addr = argAddr) and
      (CurrentL^.prev.prev <> nil) do
    begin
      CurrentL := CurrentL^.prev;
      // Выводим найденную запись

      Writeln('ID: ', CurrentR^.data.id);
      Writeln('Адрес: ', CurrentR^.data.addr);
      Writeln('Время прибытия: ', CurrentR^.data.time_in);
      Writeln('Время убытия: ', CurrentR^.data.time_out);
      Writeln('Объем: ', CurrentR^.data.volume:4:2);
      Writeln('Вес: ', CurrentR^.data.weight:4:2);
      // Вывод остальных данных
      Writeln;
      found := True;
    end;

    // Перемещаемся к следующим записям с совпадающим адресом

    // Перемещаемся к следующим записям с совпадающим адресом
    while (CurrentR^.next <> nil) and (CurrentR^.next^.data.addr = argAddr) do
    begin
      CurrentR := CurrentR^.next;
      // Выводим найденную запись
      Writeln('ID: ', CurrentR^.data.id);
      Writeln('Адрес: ', CurrentR^.data.addr);
      Writeln('Время прибытия: ', CurrentR^.data.time_in);
      Writeln('Время убытия: ', CurrentR^.data.time_out);
      Writeln('Объем: ', CurrentR^.data.volume:4:2);
      Writeln('Вес: ', CurrentR^.data.weight:4:2);
      // Вывод остальных данных
      Writeln;
      found := True;
    end;
  end;

  // Если не было найдено ни одной записи с совпадающим адресом, выведем сообщение об этом
  if not found then
    Writeln('Записи с адресом "', argAddr, '" не найдены.');
end;

// Удaление из списка
// procedure DeleteOrder(var Head, Tail: POrder; var DeliveryHead: PDelivery;
// const id: Integer);
// var
// order: POrder;
// str: string;
// begin
// str := '';
// SortOrders(Head, CompareID);
//
// order := FindOrder(Head, id, str, CompareOrderID);
//
// if order = nil then
// Writeln('Данной записи не найдено, удаление не возможно')
// else
// begin
// if findOrderinDelivery(DeliveryHead, order) then
// Writeln('Невозможно удалить данный заказ, курьер принял его в доставку')
// else
// begin
// if (order^.prev <> nil) then
// order^.prev^.next := order^.next;
// if order^.next <> nil then
// order^.next^.prev := order^.prev;
// if order^.next = nil then
// Tail := order^.prev;
// Dispose(order);
// Writeln('Заказ удален');
// end;
// end;
// end;

procedure EditOrder(Head, Tail: POrder; const id: Integer;
  const inDelivery: POrder);
var
  order: POrder;
  isWriting, isCorrect: boolean;
  strParam, exitStr, str: string;
  doubleParam: Double;
  integerParam: Integer;
  menuVal: Integer;
begin
  str := '';
  order := FindOrder(Head, id, str, CompareOrderID);
  if order = nil then
    Writeln('Данной записи не найдено, редактирование не возможно')
  else
  begin
    Writeln('Запись, которую необходимо отредактировать');
    Writeln('ID: ', order^.data.id);
    Writeln('1) Адрес: ', order^.data.addr);
    Writeln('2) Время прибытия: ', order^.data.time_in);
    Writeln('3) Время убытия: ', order^.data.time_out);
    Writeln('4) Объем: ', order^.data.volume:4:2);
    Writeln('5) Вес: ', order^.data.weight:4:2);
    Writeln('6) Выйти из режима редактирования');
    while isWriting do
    begin
      Write('Выберите поле, которое необходимо отредактировать (6 - выйти): ');
      readln(menuVal);
      case menuVal of
        1:
          begin
            Write('Введите адрес доставки: ');
            readln(strParam);
            order^.data.addr := strParam;
          end;
        2:
          begin
            isCorrect := False;
            while not isCorrect do
            begin

              Write('Введите время (с 0 до ', order^.data.time_out,
                ') с которого можно доставить (чтобы выйти введите -1): ');
              try

                readln(integerParam);
                if (integerParam >= 0) and (integerParam < order^.data.time_out)
                then
                begin
                  isCorrect := True;
                  order^.data.time_in := integerParam;
                end
                else
                begin
                  if integerParam = -1 then
                    isCorrect := True
                  else
                    Writeln('Некорректные данные, попробуйте еще раз');
                end;

              except
                Writeln('Некорректные данные, попробуйте еще раз');
              end;

            end;
            isCorrect := True;

          end;
        3:
          begin
            isCorrect := False;
            while not isCorrect do
            begin
              Write('Введите время (с ', order^.data.time_in,
                ' до 24) до которого можно доставить (чтобы выйти введите -1): ');
              try
                readln(integerParam);
                if (integerParam > order^.data.time_in) and (integerParam <= 24)
                then
                begin
                  isCorrect := True;
                  order^.data.time_out := integerParam;
                end
                else
                begin
                  if integerParam = -1 then
                    isCorrect := True
                  else
                    Writeln('Некорректные данные, попробуйте еще раз');
                end;
              except
                Writeln('Некорректные данные, попробуйте еще раз');
              end;
            end;
            isCorrect := True;
          end;
        4:
          begin
            isCorrect := False;
            while not isCorrect do
            begin
              Write('Введите объем(м^3) заказа (чтобы выйти введите -1): ');
              try
                readln(doubleParam);
                if doubleParam > 0 then
                begin
                  order^.data.volume := doubleParam;
                  isCorrect := True;
                end
                else
                begin
                  if integerParam = -1 then
                    isCorrect := True
                  else
                    Writeln('Объем заказа должен быть больше нуля.');
                end;

              except
                Writeln('Некорректные данные, попробуйте еще раз');
              end;
            end;
          end;
        5:
          begin
            isCorrect := False;
            while not isCorrect do
            begin
              Write('Введите вес(кг) заказа (чтобы выйти введите -1): ');
              try
                readln(doubleParam);
                if doubleParam > 0 then
                begin
                  order^.data.weight := doubleParam;
                  isCorrect := True;
                end
                else
                begin
                  if integerParam = -1 then
                    isCorrect := True
                  else
                    Writeln('Вес заказа должен быть больше нуля.');
                end;
              except
                Writeln('Некорректные данные, попробуйте еще раз');
              end;
            end;
          end;
        6:
          begin
            isWriting := False;
          end;
      end;
    end;
    Writeln('Заказ изменен');
  end;
end;

end.
