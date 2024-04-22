unit postmanModule;

interface

type
  PPostman = ^TPostman;

  TPostmanData = record
    id: Integer;
    fio: string[100];
    time_in: Integer;
    time_out: Integer;
    editTime_in: Integer;
    editTime_out: Integer;
    workDay: array [0 .. 24] of boolean;
    volume: Double;
    weight: Double;
  end;

  TPostman = record
    data: TPostmanData;
    next: PPostman;
    prev: PPostman;
  end;

  TCompare = function(const zap: PPostman; argID: Integer;
    argFio: string): Integer;
  TCompareSort = function(argID1, argID2: Integer; argSrt1, argStr2: string;
    argTime1, argTime2: Integer; argTime1O, argTime2O: Integer): boolean;

procedure PrintPostmans(const Head: PPostman);
procedure AppendPostman(var Head, Tail: PPostman; Item: TPostmanData);
procedure AppendPostmanFromFile(var Head, Tail: PPostman; Item: TPostmanData);
procedure PostmanByID(var Head: PPostman; argID: Integer; argAddr: string;
  cmp: TCompare);
procedure PostmanByFio(Head, Tail: PPostman; argID: Integer; argFio: string;
  cmp: TCompare);
procedure DeletePostman(var Head, Tail: PPostman; const id: Integer);
procedure EditPostman(Head, Tail: PPostman; const id: Integer;
  const inDelivery: PPostman);
procedure SortPorstman(var h: PPostman; cmp: TCompareSort);
function FindPostman(var Head: PPostman; argID: Integer; argFio: string;
  cmp: TCompare): PPostman;

implementation

uses
  System.SysUtils,
  compareModule;

procedure AppendPostman(var Head, Tail: PPostman; Item: TPostmanData);
var
  NewNode: PPostman;
  LastID: Integer;
begin
  // Проверяем, если головной узел пустой, то устанавливаем начальное значение ID как 0
  // if Head = nil then
  // begin
  // LastID := 0;
  // New(NewNode);
  // NewNode^.data := Item;
  // NewNode^.prev := nil;
  // NewNode^.next := Tail;
  // Head := NewNode;
  // Tail := NewNode;
  // end
  // else
  // Иначе берем ID последнего узла
  LastID := Head^.data.id;

  Inc(LastID); // Автоинкремент для нового ID
  Item.id := LastID; // Установка нового ID для добавляемой записи
  Head^.data.id := LastID;
  New(NewNode);
  for var i := 0 to Item.time_in - 1 do
    Item.workDay[i] := false;
  for var i := Item.time_out to 24 do
    Item.workDay[i] := false;
  for var i := Item.time_in to Item.time_out do
  begin
    Item.workDay[i] := True;
  end;
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

procedure AppendPostmanFromFile(var Head, Tail: PPostman; Item: TPostmanData);
var
  NewNode: PPostman;
  LastID: Integer;
begin

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


// procedure SortPorstman(var h: PPostman; cmp: TCompareSort);
// var
// t, b: PPostman;
// x: TPostmanData;
// begin
// t := h^.next;
// while (t <> nil) do
// begin
// x := t^.data;
// b := t^.prev;
// while (b <> nil) and (cmp(x.id, b^.data.id, x.fio, b^.data.fio, x.time_in,
// b^.data.time_in, x.time_out, b^.data.time_out)) and ((b.prev <> nil)) do
// begin
// b^.next^.data := b^.data;
// b := b^.prev;
// end;
// if (b = nil) then
// h^.data := x
// else
// b^.next^.data := x;
// t := t^.next;
// end;
// end;

procedure SortPorstman(var h: PPostman; cmp: TCompareSort);
var
  t, b, temp: PPostman;
begin
  t := h^.next;
  while (t <> nil) do
  begin
    temp := t^.next;
    b := t^.prev;
    while (b <> nil) and (cmp(t^.data.id, b^.data.id, t^.data.fio, b^.data.fio,
      t^.data.time_in, b^.data.time_in, t^.data.time_out, b^.data.time_out)) and
      ((b^.prev <> nil)) do
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

procedure PrintPostmans(const Head: PPostman);
var
  Current: PPostman;
  Index: Integer;
begin
  Writeln('Список всех курьеров:');
  Writeln('|------------------------------------------------------------------------------|');
  Writeln('|  ID |       ФИО       |   Время с   |   Время до  |   Объем     |     Вес    |');
  Writeln('|-----+-----------------+-------------+-------------+-------------+------------|');
  Current := Head^.next;
  while Current <> nil do
  begin
    Write(Format('| %-3d | ', [Current^.data.id]));
    Write(Format('%-15s | ', [Current^.data.fio]));
    Write(Format('     %-3d    | ', [Current^.data.time_in]));
    Write(Format('     %-3d    | ', [Current^.data.time_out]));
    Write(Format(' %-10.2f | ', [Current^.data.volume]));
    Writeln(Format('%-10.2f | ', [Current^.data.weight]));
    Writeln('|-----+-----------------+-------------+-------------+-------------+------------|');
    Current := Current^.next;
  end;
end;

// Поиск по ID
function FindPostman(var Head: PPostman; argID: Integer; argFio: string;
  cmp: TCompare): PPostman;
var
  l: PPostman;
  found: boolean;
begin
  l := Head^.next; // Пропускаем голову списка
  found := false;

  while (l <> nil) and (cmp(l, argID, argFio) <> 1) do
    l := l^.next;

  if l <> nil then
  begin
    Result := l;
    found := True;
  end;

  if not found then
    Result := nil;
end;

procedure PostmanByID(var Head: PPostman; argID: Integer; argAddr: string;
  cmp: TCompare);
var
  order: PPostman;
  found: boolean;
begin
  SortPorstman(Head, CompareID);
  found := false;
  order := FindPostman(Head, argID, argAddr, cmp);
  if order <> nil then
  begin
    found := True;
    Writeln('ID: ', order^.data.id);
    Writeln('ФИО: ', order^.data.fio);
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

// Поиск по полую "ФИО"

procedure PostmanByFio(Head, Tail: PPostman; argID: Integer; argFio: string;
  cmp: TCompare);
var
  CurrentL, CurrentR: PPostman;
  found: boolean;
begin
  // Сначала сортируем список в алфавитном порядке
  SortPorstman(Head, CompareStr);
  found := false;

  // Ищем первую запись с совпадающим адресом
  CurrentL := FindPostman(Head, argID, argFio, cmp);
  CurrentR := CurrentL;
  // Если запись не найдена, выходим из процедуры
  if (CurrentL <> nil) and (CurrentR <> nil) then
  begin
    // Выводим найденную запись
    Writeln('ID: ', CurrentR^.data.id);
    Writeln('ФИО: ', CurrentR^.data.fio);
    Writeln('Время с которого работает: ', CurrentR^.data.time_in);
    Writeln('Время до которого работает: ', CurrentR^.data.time_out);
    Writeln('Объем: ', CurrentR^.data.volume:4:2);
    Writeln('Вес: ', CurrentR^.data.weight:4:2);
    // Вывод остальных данных
    Writeln;
    found := True;

    // Перемещаемся к предыдущим записям с совпадающим адресом
    while (CurrentL^.prev <> nil) and (CurrentL^.prev^.data.fio = argFio) and
      (CurrentL^.prev.prev <> nil) do
    begin
      CurrentL := CurrentL^.prev;
      // Выводим найденную запись

      Writeln('ID: ', CurrentR^.data.id);
      Writeln('ФИО: ', CurrentR^.data.fio);
      Writeln('Время с которого работает: ', CurrentR^.data.time_in);
      Writeln('Время до которого работает: ', CurrentR^.data.time_out);
      Writeln('Объем: ', CurrentR^.data.volume:4:2);
      Writeln('Вес: ', CurrentR^.data.weight:4:2);
      // Вывод остальных данных
      Writeln;
      found := True;
    end;

    // Перемещаемся к следующим записям с совпадающим адресом

    // Перемещаемся к следующим записям с совпадающим адресом
    while (CurrentR^.next <> nil) and (CurrentR^.next^.data.fio = argFio) do
    begin
      CurrentR := CurrentR^.next;
      // Выводим найденную запись
      Writeln('ID: ', CurrentR^.data.id);
      Writeln('ФИО: ', CurrentR^.data.fio);
      Writeln('Время с которого работает: ', CurrentR^.data.time_in);
      Writeln('Время до которого работает: ', CurrentR^.data.time_out);
      Writeln('Объем: ', CurrentR^.data.volume:4:2);
      Writeln('Вес: ', CurrentR^.data.weight:4:2);
      // Вывод остальных данных
      Writeln;
      found := True;
    end;
  end;

  // Если не было найдено ни одной записи с совпадающим адресом, выведем сообщение об этом
  if not found then
    Writeln('Записи с адресом "', argFio, '" не найдены.');
end;

procedure DeletePostman(var Head, Tail: PPostman; const id: Integer);
var
  postman: PPostman;
  str: string;
begin
  str := '';
  SortPorstman(Head, CompareID);
  postman := FindPostman(Head, id, str, ComparePostmanID);
  if postman = nil then
    Writeln('Данной записи не найдено, удаление не возможно')
  else
  begin
    if postman^.prev <> nil then
      postman^.prev^.next := postman^.next;
    if postman^.next <> nil then
      postman^.next^.prev := postman^.prev;
    if postman^.next = nil then
      Tail := postman^.prev;
    Dispose(postman);
    Writeln('Курьер удален');
  end;
end;

procedure EditPostman(Head, Tail: PPostman; const id: Integer;
  const inDelivery: PPostman);
var
  postman: PPostman;
  isWriting, isCorrect: boolean;
  integerParam: Integer;
  val: Integer;
  strParam, exitStr: string;
  doubleParam: Double;
  menuVal: Integer;
  tempTime: Integer;
begin
  strParam := '';
  postman := FindPostman(Head, id, strParam, ComparePostmanID);
  if postman = nil then
    Writeln('Данной записи не найдено, редактирование не возможно')
  else
  begin
    Writeln('Запись, которую необходимо отредактировать');
    Writeln('ID: ', postman^.data.id);
    Writeln('1) ФИО: ', postman^.data.fio);
    Writeln('2) Время c которого работает: ', postman^.data.time_in);
    Writeln('3) Время до которого работает: ', postman^.data.time_out);
    Writeln('4) Объем: ', postman^.data.volume:4:2);
    Writeln('5) Вес: ', postman^.data.weight:4:2);
    Writeln('6) Выйти из режима редактирования');
    while isWriting do
    begin
      Write('Выберите поле, которое необходимо отредактировать (6 - выйти): ');
      readln(menuVal);
      case menuVal of
        1:
          begin
            isCorrect := false;

            while not isCorrect do
            begin
              Write('Введите ФИО (чтобы выйти введите -1): ');
              readln(strParam);
              if not TryStrToInt(strParam, val) then
              begin
                postman^.data.fio := strParam;
                isCorrect := True;
              end
              else
              begin
                if val <> -1 then
                  Writeln('Некорректные данные')
                else
                  isCorrect := True;
              end;
            end;

          end;
        2:
          begin

            isCorrect := false;

            while not isCorrect do
            begin
              if inDelivery <> nil then
              begin
                Write('Введите время (с 0 до ', postman^.data.time_in,
                  ') c которого работает (чтобы выйти введите -1): ');
                try
                  readln(integerParam);
                  if (integerParam >= 0) and
                    (integerParam < postman^.data.time_in) then
                  begin
                    isCorrect := True;
                    tempTime := postman^.data.time_in;
                    postman^.data.time_in := integerParam;
                    for var i := integerParam to tempTime - 1 do
                      postman^.data.workDay[i] := True;
                    
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
              end
              else
              begin
                Write('Введите время (с 0 до ', postman^.data.time_out,
                  ') c которого работает (чтобы выйти введите -1): ');
                try
                  readln(integerParam);
                  if (integerParam >= 0) and
                    (integerParam < postman^.data.time_out) then
                  begin
                    isCorrect := True;
                    postman^.data.time_in := integerParam;
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
            end;
          end;
        3:
          begin
            isCorrect := false;

            while not isCorrect do
            begin
              if inDelivery <> nil then
              begin
                Write('Введите время (с ', postman^.data.time_out,
                  ' до 24) до которого работает (чтобы выйти введите -1): ');
                try
                  readln(integerParam);
                  if (integerParam > postman^.data.time_out) and
                    (integerParam <= 24) then
                  begin

                    tempTime := postman^.data.time_out;
                    isCorrect := True;
                    postman^.data.time_out := integerParam;
                    for var i := tempTime + 1 to integerParam do
                      postman^.data.workDay[i] := True;
                    
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
              end
              else
              begin
                Write('Введите время (с ', postman^.data.time_in,
                  ' до 24) до которого работает (чтобы выйти введите -1): ');
                try
                  readln(integerParam);
                  if (integerParam > postman^.data.time_in) and
                    (integerParam <= 24) then
                  begin
                    isCorrect := True;
                    postman^.data.time_out := integerParam;
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
            end;
          end;
        4:
          begin
            isCorrect := false;

            while not isCorrect do
            begin
              Write('Введите вместимость(м^3) у курьера (чтобы выйти введите -1): ');
              try
                readln(doubleParam);
                if doubleParam > 0 then
                begin
                  postman^.data.volume := doubleParam;
                  isCorrect := True;
                end
                else
                begin
                  if integerParam = -1 then
                    isCorrect := True
                  else
                    Writeln('Вместимость у курьера должен быть больше нуля.');
                end;

              except
                Writeln('Некорректные данные, попробуйте еще раз');
              end;
            end;
          end;
        5:
          begin
            isCorrect := false;

            while not isCorrect do
            begin
              Write('Введите грузоподъемность(кг) курьера (чтобы выйти введите -1): ');
              try
                readln(doubleParam);
                if doubleParam > 0 then
                begin
                  postman^.data.weight := doubleParam;
                  isCorrect := True;
                end
                else
                begin
                  if integerParam = -1 then
                    isCorrect := True
                  else
                    Writeln('Грузоподъемность курьера должен быть больше нуля.');
                end;

              except
                Writeln('Некорректные данные, попробуйте еще раз');
              end;
            end;
          end;
        6:
          begin
            isWriting := false;
          end;
      end;
    end;
    Writeln('Курьер изменен');
  end;
end;

end.
