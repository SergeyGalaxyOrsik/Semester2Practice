unit specialFunction;

interface

uses
  System.SysUtils, postmanModule, orderModule;

type
  PDelivery = ^TDelivery;

  TDeliveryData = record
    id: Integer;
    orderId: Integer;
    orderTime_in: Integer;
    orderTime_out: Integer;
    orderVolume: double;
    orderWeight: double;
    orderAddr: string[100];
    postmanId: Integer;
    postmanTime_in: Integer;
    postmanTime_out: Integer;
    postmanVolume: double;
    postmanWeight: double;
    postmanFio: string[100];
  end;

  TDelivery = record
    data: TDeliveryData;
    next: PDelivery;
    prev: PDelivery;
  end;

  TCompare = function(const zap: PDelivery; argID: Integer;
    argAddr: string): Integer;
  TCompareSortDelivery = function(arg1, arg2: PDelivery): boolean;

procedure AssignOrders(var OrdersHead, OrdersTail: POrder;
  var PostmansHead, PostmansTail: PPostman;
  var DeliveryHead, DeliveryTail: PDelivery);
procedure Print(Head: PDelivery);
procedure PrintByID(Head: PDelivery; const argID: Integer; cmp: TCompare);
function CompareIDDel(const zap: PDelivery; argID: Integer;
  argAddr: string): Integer;
procedure AppendDelivery(var Head, Tail: PDelivery; Item: TDeliveryData);
procedure AppendDeliveryFromFile(var Head, Tail: PDelivery;
  Item: TDeliveryData);

// procedure PrintByFio(Head: PDelivery; const argStr:string; cmp:TCompare);

implementation

uses
  compareModule;

function CompareIDDel(const zap: PDelivery; argID: Integer;
  argAddr: string): Integer;
begin
  if zap^.data.postmanId = argID then
    Result := 1
  else if zap^.data.postmanId < argID then
    Result := 0
  else
    Result := 2;
end;

function CompareDeliveryID(const zap: PDelivery; argID: Integer;
  argAddr: string): Integer;
begin
  if zap^.data.orderId = argID then
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

procedure AppendDelivery(var Head, Tail: PDelivery; Item: TDeliveryData);
var
  NewNode: PDelivery;
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

procedure AppendDeliveryFromFile(var Head, Tail: PDelivery;
  Item: TDeliveryData);
var
  NewNode: PDelivery;
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
    // LastID := Head^.data.id;

    // Inc(LastID); // Автоинкремент для нового ID
    // Item.id := LastID; // Установка нового ID для добавляемой записи
    // Head^.data.id := LastID;
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
procedure SortDelivery(var h: PDelivery; cmp: TCompareSortDelivery);
var
  t, b, temp: PDelivery;
  x: PDelivery;
begin
  t := h^.next;
  while (t <> nil) do
  begin
    x := t;
    b := t^.prev;
    while (b <> nil) and (cmp(x, b)) and ((b.prev <> nil)) do
    begin
      b^.next^.data := b^.data;
      b := b^.prev;
    end;
    if (b = nil) then
      h^.data := x.data
    else
    begin
      b^.next^.data := x.data;
    end;
    t := t^.next;
  end;
end;

function DeliveryOrder(var Head: PDelivery; argID: Integer; argAddr: string;
  cmp: TCompare): PDelivery;
var
  l: PDelivery;
  found: boolean;
begin
  if Head = nil then
    Result := nil
  else
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
end;

procedure PrintByID(Head: PDelivery; const argID: Integer; cmp: TCompare);
var
  order: PDelivery;
  found: boolean;
begin
  SortDelivery(Head, ComparePostmanIDDel);
  found := False;
  order := DeliveryOrder(Head, argID, '', cmp);
  if order <> nil then
  begin
    Writeln('Список найденных заказов:');
    Writeln('|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|');
    Writeln('|  ID |  ID Зак. |       Адрес     |   Время с   |   Время до  |   Объем     |     Вес    |  ID Кур. |      ФИО        |   Время с   |   Время до  |   Объем     |     Вес    |');
    Writeln('|-----+----------+-----------------+-------------+-------------+-------------+------------+----------+-----------------+-------------+-------------+-------------+------------|');
    found := True;
    Write(Format('| %-3d | ', [order^.data.id]));
    Write(Format('   %-5d | ', [order^.data.orderId]));
    Write(Format('%-15s | ', [order^.data.orderAddr]));
    Write(Format('     %-3d    | ', [order^.data.orderTime_in]));
    Write(Format('     %-3d    | ', [order^.data.orderTime_out]));
    Write(Format(' %-10.2f | ', [order^.data.orderVolume]));
    Write(Format('%-10.2f | ', [order^.data.orderWeight]));
    Write(Format('  %-5d  | ', [order^.data.postmanId]));
    Write(Format('%-15s | ', [order^.data.postmanFio]));
    Write(Format('     %-3d    | ', [order^.data.postmanTime_in]));
    Write(Format('     %-3d    | ', [order^.data.postmanTime_out]));
    Write(Format(' %-10.2f | ', [order^.data.postmanVolume]));
    Writeln(Format('%-10.2f | ', [order^.data.postmanWeight]));
    Writeln('|-----+----------+-----------------+-------------+-------------+-------------+------------+----------+-----------------+-------------+-------------+-------------+------------|');
    // Вывод остальных данных
    Writeln;
  end;
  if not found then
    Writeln('Запись с таким ID не найдена');
end;

procedure Print(Head: PDelivery);
var
  Current: PDelivery;
  Index: Integer;
begin
  Writeln('Список всех заказов:');
  Writeln('|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|');
  Writeln('|  ID |  ID Зак. |       Адрес     |   Время с   |   Время до  |   Объем     |     Вес    |  ID Кур. |      ФИО        |   Время с   |   Время до  |   Объем     |     Вес    |');
  Writeln('|-----+----------+-----------------+-------------+-------------+-------------+------------+----------+-----------------+-------------+-------------+-------------+------------|');
  Current := Head^.next;
  while Current <> nil do
  begin
    Write(Format('| %-3d | ', [Current^.data.id]));
    Write(Format('   %-5d | ', [Current^.data.orderId]));
    Write(Format('%-15s | ', [Current^.data.orderAddr]));
    Write(Format('     %-3d    | ', [Current^.data.orderTime_in]));
    Write(Format('     %-3d    | ', [Current^.data.orderTime_out]));
    Write(Format(' %-10.2f | ', [Current^.data.orderVolume]));
    Write(Format('%-10.2f | ', [Current^.data.orderWeight]));
    Write(Format('  %-5d  | ', [Current^.data.postmanId]));
    Write(Format('%-15s | ', [Current^.data.postmanFio]));
    Write(Format('     %-3d    | ', [Current^.data.postmanTime_in]));
    Write(Format('     %-3d    | ', [Current^.data.postmanTime_out]));
    Write(Format(' %-10.2f | ', [Current^.data.postmanVolume]));
    Writeln(Format('%-10.2f | ', [Current^.data.postmanWeight]));
    Writeln('|-----+----------+-----------------+-------------+-------------+-------------+------------+----------+-----------------+-------------+-------------+-------------+------------|');
    Current := Current^.next;
  end;
end;


// Наиболее эффективное распределение заказов между курьерами

function checkTime(const Postman: PPostman; const order: POrder): boolean;
var
  i: Integer;
  flag: boolean;
begin
  i := order.data.time_in;
  flag := True;
  Result := False;
  while (i <= order.data.time_out) and (flag) do
  begin
    if Postman.data.workDay[i] then
    begin
      Result := True;
      flag := False;
    end;
    Inc(i);
  end;

end;

procedure AssignOrders(var OrdersHead, OrdersTail: POrder;
  var PostmansHead, PostmansTail: PPostman;
  var DeliveryHead, DeliveryTail: PDelivery);
var
  OrderNode: POrder;
  PostmanNode: PPostman;
  DeliveryData: TDeliveryData;
  flag: boolean;
  i: Integer;
  endw: Integer;
begin
  flag := False;

  SortOrders(OrdersHead, CompareTime);
  OrderNode := OrdersHead.next;
  PostmanNode := PostmansHead.next;
  while (PostmanNode <> nil) do
  begin
    PostmanNode.data.editTime_in := PostmanNode.data.time_in;
    PostmanNode.data.editTime_out := PostmanNode.data.time_out;
    PostmanNode := PostmanNode^.next;
  end;

  while OrderNode <> nil do
  begin
    // if PostmanNode=nil then
    SortPorstman(PostmansHead, CompareTime);
    PostmanNode := PostmansHead.next;

    i := 0;
    if DeliveryOrder(DeliveryHead, OrderNode.data.id, '', CompareDeliveryID) = nil
    then
    begin
      while (PostmanNode <> nil) and (flag = False) do
      begin
        endw := OrderNode^.data.time_out - 1;
        // if PostmanNode^.data.id=8 then
        // begin
        // Writeln('------------',i,'------------');
        // Writeln('Start Order:', OrderNode^.data.time_in, ' Start Postman:  ', PostmanNode^.data.time_in);
        // Writeln('End Order:', OrderNode^.data.time_out, ' End Postman:  ', PostmanNode^.data.time_out);
        // Writeln('Volume Order:', OrderNode^.data.volume:4:2, ' Volume Postman:  ', PostmanNode^.data.volume:4:2);
        // Writeln('Weight Order:', OrderNode^.data.weight:4:2, ' Weight Postman:  ', PostmanNode^.data.weight:4:2);
        // Writeln;
        //
        // Writeln('End Order-1: ', endw, '---- Start Postman ', PostmanNode^.data.time_in);
        // Writeln('------------',i,'------------');
        // end;
        if checkTime(PostmanNode, OrderNode) then
        begin
          if (OrderNode^.data.time_out <= PostmanNode^.data.editTime_out) and
            (endw >= PostmanNode^.data.editTime_in) and
            (OrderNode^.data.volume <= PostmanNode^.data.volume) and
            (OrderNode^.data.weight <= PostmanNode^.data.weight) then
          begin
            // Writeln('!!!!!!!!!!!!!!!!Order ', OrderNode^.data.id,
            // ' is assigned to Postman ', PostmanNode^.data.id);
            DeliveryData.orderId := OrderNode.data.id;
            DeliveryData.orderTime_in := OrderNode.data.time_in;
            DeliveryData.orderTime_out := OrderNode.data.time_out;
            DeliveryData.orderVolume := OrderNode.data.volume;
            DeliveryData.orderWeight := OrderNode.data.weight;
            DeliveryData.orderAddr := OrderNode.data.addr;

            DeliveryData.postmanId := PostmanNode.data.id;
            DeliveryData.postmanTime_in := PostmanNode.data.time_in;
            DeliveryData.postmanTime_out := PostmanNode.data.time_out;
            DeliveryData.postmanVolume := PostmanNode.data.volume;
            DeliveryData.postmanWeight := PostmanNode.data.weight;
            DeliveryData.postmanFio := PostmanNode.data.fio;

            // PostmanNode^.data.volume := PostmanNode^.data.volume - OrderNode^.data.volume;
            // PostmanNode^.data.weight := PostmanNode^.data.volume - OrderNode^.data.weight;
            // Увеличение в8ремени работы курьера
            AppendDelivery(DeliveryHead, DeliveryTail, DeliveryData);
            flag := True;
            PostmanNode^.data.workDay[PostmanNode^.data.editTime_in] := False;
            Inc(PostmanNode^.data.editTime_in);
          end;
        end;
          // if flag<>true then
          PostmanNode := PostmanNode^.next;
          i := i + 1;

      end;
    end;
    flag := False;
    OrderNode := OrderNode^.next;
  end;
  Writeln('Заказы распределены');
  SortPorstman(PostmansHead, CompareID);
end;

end.
