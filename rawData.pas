unit rawData;

interface

uses
  orderModule, postmanModule;

procedure generateOrders(var Head, Tail: POrder);
procedure generatePostmans(var Head, Tail: PPostman);

implementation

uses
  System.SysUtils,
  Windows;

procedure generateOrders(var Head, Tail: POrder);
var
  OrderData, Order1Data, Order2Data: TOrderData;
  LastIDOrder: Integer;
  NewNode: POrder;
begin
  LastIDOrder := 0;

  OrderData.addr := 'Дзержинск';
  OrderData.time_in :=10;
  OrderData.time_out := 12;
  OrderData.volume := 2.5;
  OrderData.weight := 10;
  AppendOrder(Head, Tail, OrderData);

  Order1Data.addr := 'Минск';
  Order1Data.time_in := 11;
  Order1Data.time_out := 13;
  Order1Data.volume := 1.8;
  Order1Data.weight := 8;
  AppendOrder(Head, Tail, Order1Data);

  Order1Data.addr := 'Осиповичи';
  Order1Data.time_in := 10;
  Order1Data.time_out := 12;
  Order1Data.volume := 2.2;
  Order1Data.weight := 10;
  AppendOrder(Head, Tail, Order1Data);

  Order1Data.addr := 'Липень';
  Order1Data.time_in := 11;
  Order1Data.time_out := 13;
  Order1Data.volume := 1.3;
  Order1Data.weight := 8;
  AppendOrder(Head, Tail, Order1Data);

  Order1Data.addr := 'Осиповичи';
  Order1Data.time_in := 14;
  Order1Data.time_out := 24;
  Order1Data.volume := 0.5;
  Order1Data.weight := 10;
  AppendOrder(Head, Tail, Order1Data);

  Order1Data.addr := 'Минск';
  Order1Data.time_in := 0;
  Order1Data.time_out := 24;
  Order1Data.volume := 1;
  Order1Data.weight := 8.6;
  AppendOrder(Head, Tail, Order1Data);

  OrderData.addr := 'Дзержинск';
  OrderData.time_in :=10;
  OrderData.time_out := 12;
  OrderData.volume := 2.5;
  OrderData.weight := 10;
  AppendOrder(Head, Tail, OrderData);

  Order1Data.addr := 'Минск';
  Order1Data.time_in := 11;
  Order1Data.time_out := 13;
  Order1Data.volume := 1.8;
  Order1Data.weight := 8;
  AppendOrder(Head, Tail, Order1Data);

  Order1Data.addr := 'Осиповичи';
  Order1Data.time_in := 10;
  Order1Data.time_out := 12;
  Order1Data.volume := 2.2;
  Order1Data.weight := 10;
  AppendOrder(Head, Tail, Order1Data);

  Order1Data.addr := 'Липень';
  Order1Data.time_in := 11;
  Order1Data.time_out := 13;
  Order1Data.volume := 1.3;
  Order1Data.weight := 8;
  AppendOrder(Head, Tail, Order1Data);

  Order1Data.addr := 'Осиповичи';
  Order1Data.time_in := 14;
  Order1Data.time_out := 24;
  Order1Data.volume := 0.5;
  Order1Data.weight := 10;
  AppendOrder(Head, Tail, Order1Data);

  Order1Data.addr := 'Минск';
  Order1Data.time_in := 0;
  Order1Data.time_out := 24;
  Order1Data.volume := 1;
  Order1Data.weight := 8.6;
  AppendOrder(Head, Tail, Order1Data);
end;

procedure generatePostmans(var Head, Tail: PPostman);
var
  PostmanData, Postman1Data, Postman2Data: TPostmanData;
  LastIDPostman: Integer; // Переменная для хранения последнего ID курьера
begin
  LastIDPostman := 0;

  Postman1Data.fio := 'Орсик';
  Postman1Data.time_in := 10;
  Postman1Data.time_out := 20;
  Postman1Data.volume := 4.5;
  Postman1Data.weight := 10;
  AppendPostman(Head, Tail, Postman1Data);

  Postman2Data.fio := 'Кузьменко';
  Postman2Data.time_in := 9;
  Postman2Data.time_out := 23;
  Postman2Data.volume := 1.8;
  Postman2Data.weight := 8;
  AppendPostman(Head, Tail, Postman2Data);

  Postman1Data.fio := 'Иваненко';
  Postman1Data.time_in := 14;
  Postman1Data.time_out := 12;
  Postman1Data.volume := 2.5;
  Postman1Data.weight := 10;
  AppendPostman(Head, Tail, Postman1Data);

  Postman2Data.fio := 'Федорако';
  Postman2Data.time_in := 10;
  Postman2Data.time_out := 13;
  Postman2Data.volume := 1.8;
  Postman2Data.weight := 8;
  AppendPostman(Head, Tail, Postman2Data);

  Postman1Data.fio := 'Бурчук';
  Postman1Data.time_in := 19;
  Postman1Data.time_out := 20;
  Postman1Data.volume := 2.5;
  Postman1Data.weight := 10;
  AppendPostman(Head, Tail, Postman1Data);

  Postman2Data.fio := 'Бобченок';
  Postman2Data.time_in := 11;
  Postman2Data.time_out := 13;
  Postman2Data.volume := 1.8;
  Postman2Data.weight := 8;
  AppendPostman(Head, Tail, Postman2Data);

  Postman1Data.fio := 'Орсик';
  Postman1Data.time_in := 10;
  Postman1Data.time_out := 12;
  Postman1Data.volume := 2.87;
  Postman1Data.weight := 4;
  AppendPostman(Head, Tail, Postman1Data);

  Postman2Data.fio := 'Кузьменко';
  Postman2Data.time_in := 9;
  Postman2Data.time_out := 23;
  Postman2Data.volume := 1.8;
  Postman2Data.weight := 8;
  AppendPostman(Head, Tail, Postman2Data);

  Postman1Data.fio := 'Иваненко';
  Postman1Data.time_in := 14;
  Postman1Data.time_out := 12;
  Postman1Data.volume := 2.5;
  Postman1Data.weight := 10;
  AppendPostman(Head, Tail, Postman1Data);

  Postman2Data.fio := 'Федорако';
  Postman2Data.time_in := 10;
  Postman2Data.time_out := 13;
  Postman2Data.volume := 1.8;
  Postman2Data.weight := 8;
  AppendPostman(Head, Tail, Postman2Data);

  Postman1Data.fio := 'Бурчук';
  Postman1Data.time_in := 19;
  Postman1Data.time_out := 20;
  Postman1Data.volume := 2.5;
  Postman1Data.weight := 10;
  AppendPostman(Head, Tail, Postman1Data);

  Postman2Data.fio := 'Бобченок';
  Postman2Data.time_in := 11;
  Postman2Data.time_out := 13;
  Postman2Data.volume := 1.8;
  Postman2Data.weight := 8;
  AppendPostman(Head, Tail, Postman2Data);
end;

end.
