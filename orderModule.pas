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


// Добавить в список
procedure AppendOrder(var Head, Tail: POrder; Item: TOrderData);
var
  NewNode: POrder;
  LastID: Integer;
begin
  // Проверяем, если головной узел пустой, то устанавливаем начальное значение ID как 0
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
  end
  else
  begin
    NewNode^.prev := Tail;
    Tail^.next := NewNode;
  end;

  Tail := NewNode;
end;

// СОРТИРОВКА
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



// Вывод списка


procedure PrintOrders(Head: POrder; cmp:TCompareSort);
var
  Current: POrder;
  Index: Integer;
begin
  Sort(Head,cmp);
  Writeln('Список всех заказов:');
  Writeln('|------------------------------------------------------------------------------|');
  Writeln('|  ID |       Адрес     |   Время с   |   Время до  |   Объем     |     Вес    |');
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

// Сортировка




// Поиск по ID
function FindOrder(var Head: POrder; argID: Integer; argAddr: string; cmp: TCompare): POrder;
var
  l: POrder;
  found: Boolean;
begin
  l := Head^.next; // Пропускаем голову списка
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
    Writeln('Адрес: ', order^.data.addr);
    Writeln('Время прибытия: ', order^.data.time_in);
    Writeln('Время убытия: ', order^.data.time_out);
    Writeln('Объем: ', order^.data.volume:4:2);
    Writeln('Вес: ', order^.data.weight:4:2);
    // Вывод остальных данных
    Writeln;
  end;
  if not Found then
    Writeln('Запись с таким ID не найдена');
end;

// Поиск по полую "Адрес"




procedure OrdersByAddr(Head, Tail: POrder; argID: Integer; argAddr:string; cmp:TCompare);
var
  CurrentL, CurrentR: POrder;
  found: Boolean;
begin
  // Сначала сортируем список в алфавитном порядке
  Sort(Head,CompareStr);
  found := False;

  // Ищем первую запись с совпадающим адресом
  currentL:=FindOrder(Head, argID, argAddr, cmp);
  currentR:=currentL;
  // Если запись не найдена, выходим из процедуры
  if (currentL <> nil) and (currentR<>nil) then
  begin
    // Выводим найденную запись
    Writeln('Найден(ы) заказ(ы):');
   Writeln('ID: ', currentR^.data.id);
      Writeln('Адрес: ', currentR^.data.addr);
      Writeln('Время прибытия: ', currentR^.data.time_in);
      Writeln('Время убытия: ',currentR^.data.time_out);
      Writeln('Объем: ', currentR^.data.volume:4:2);
      Writeln('Вес: ', currentR^.data.weight:4:2);
    // Вывод остальных данных
    Writeln;
    found := True;

    // Перемещаемся к предыдущим записям с совпадающим адресом
    while (currentL^.prev <> nil) and (currentL^.prev^.data.addr = argAddr) and (currentL^.prev.prev <> nil) do
    begin
      currentL := currentL^.prev;
      // Выводим найденную запись

      Writeln('ID: ', currentR^.data.id);
      Writeln('Адрес: ', currentR^.data.addr);
      Writeln('Время прибытия: ', currentR^.data.time_in);
      Writeln('Время убытия: ',currentR^.data.time_out);
      Writeln('Объем: ', currentR^.data.volume:4:2);
      Writeln('Вес: ', currentR^.data.weight:4:2);
      // Вывод остальных данных
      Writeln;
      found := True;
    end;

    // Перемещаемся к следующим записям с совпадающим адресом

    // Перемещаемся к следующим записям с совпадающим адресом
    while (currentR^.next <> nil) and (currentR^.next^.data.addr = argAddr) do
    begin
      currentR := currentR^.next;
      // Выводим найденную запись
      Writeln('ID: ', currentR^.data.id);
      Writeln('Адрес: ', currentR^.data.addr);
      Writeln('Время прибытия: ', currentR^.data.time_in);
      Writeln('Время убытия: ',currentR^.data.time_out);
      Writeln('Объем: ', currentR^.data.volume:4:2);
      Writeln('Вес: ', currentR^.data.weight:4:2);
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
procedure DeleteOrder(Head: POrder; const id: Integer);
var
  order: POrder;
  str:string;
begin
  str:='';
  order := FindOrder(Head, id,str, CompareOrderID);
  if order=nil then
    Writeln('Данной записи не найдено, удаление не возможно')
  else
  begin
    if order^.prev <> nil then
      order^.prev^.next := order^.next;
    if order^.next <> nil then
      order^.next^.prev := order^.prev;
    Writeln('Заказ удален');
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
    Writeln('Данной записи не найдено, редактирование не возможно')
  else
  begin
    Writeln('Запись, которую необходимо отредактировать');
    Writeln('ID: ', order^.data.id);
    Writeln('1) Адрес: ', order^.data.addr);
    Writeln('2) Время прибытия: ', FormatDateTime('HH:NN', order^.data.time_in));
    Writeln('3) Время убытия: ', FormatDateTime('HH:NN', order^.data.time_out));
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
          Readln(strParam);
          order^.data.addr := strParam;
        end;
        2:
        begin
          Write('Введите время (с 1 до 24) с которого можно доставить : ');

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
              Writeln('Некорректные данные, попробуйте еще раз');
          end;
          isCorrect:=true;

        end;
        3:
        begin
          Write('Введите время (с 1 до 24) до которого можно доставить: ');
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
              Writeln('Некорректные данные, попробуйте еще раз');
          end;
          isCorrect:=true;
        end;
        4:
        begin
          Write('Введите объем(м^3) заказа: ');
          Readln(doubleParam);
          order^.data.volume := doubleParam;
        end;
        5:
        begin
          Write('Введите вес(кг) заказа: ');
          Readln(doubleParam);
          order^.data.weight := doubleParam;
        end;
        6:
        begin
          isWriting:=False;
        end;
      end;
    end;
    Writeln('Заказ изменен');
  end;
end;

end.
