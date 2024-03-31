unit postmanModule;



interface



type
  PPostman = ^TPostman;

  TPostmanData = record
    id: Integer;
    fio: string[100];
    time_in: integer;
    time_out: integer;
    volume: Double;
    weight: Double;
  end;

  TPostman = record
    data: TPostmanData;
    next: PPostman;
    prev: PPostman;
  end;
  TCompare=function(const zap: PPostman; argID: Integer; argFio:string):integer;
  TCompareSort=function(argID1, argID2: Integer; argSrt1, argStr2:string):boolean;

procedure PrintPostmans(Head: PPostman; cmp:TCompareSort);
procedure AppendPostman(var Head, Tail: PPostman; Item: TPostmanData);
procedure PostmanByID(var Head: PPostman; argID: Integer; argAddr:string; cmp:TCompare);
procedure PostmanByFio(Head, Tail: PPostman; argID: Integer; argFio:string; cmp:TCompare);
procedure DeletePostman(Head:PPostman; const ID: integer);
procedure EditPostman(Head, Tail: PPostman; const id: Integer);

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
    Head^.data.id:=LastID;
    New(NewNode);
    NewNode^.data := Item;
    NewNode^.next := nil;

    if Tail = nil then
    begin
      NewNode^.prev := Head;
      Tail:= NewNode;
    end
    else
    begin
      NewNode^.prev := Tail;
      Tail^.next := NewNode;
    end;

    Tail := NewNode;
end;



procedure Sort(var h: PPostman; cmp: TCompareSort);
var
  t, b: PPostman;
  x: TPostmanData;
begin
  t := h^.next;
  while (t <> nil) do
  begin
    x := t^.data;
    b := t^.prev;
    while (b <> nil) and (cmp(x.id, b^.data.id, x.fio, b^.data.fio)) and ((b.prev <> nil)) do
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



procedure PrintPostmans(Head: PPostman; cmp:TCompareSort);
var
  Current: PPostman;
  Index: Integer;
begin
  Sort(Head,cmp);
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
function FindPostman(var Head: PPostman; argID: Integer; argFio:string; cmp:TCompare): PPostman;
var
  l: PPostman;
  found: Boolean;
begin
  l := Head^.next; // Пропускаем голову списка
  found := False;

  while (l <> nil) and (cmp(l,argID,argFio) <> 1) do
    l := l^.next;

  if l <> nil then
  begin
    Result := l;
    found := True;
  end;

  if not found then
    Result := nil;
end;

procedure PostmanByID(var Head: PPostman; argID: Integer; argAddr:string; cmp:TCompare);
var
  order: PPostman;
  found: Boolean;
begin
  Sort(Head,CompareID);
  found:= false;
  order := FindPostman(Head, argID, argAddr, cmp);
  if order<>nil then
  begin
    found:=true;
    Writeln('ID: ', order^.data.id);
    Writeln('ФИО: ', order^.data.fio);
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

// Поиск по полую "ФИО"



procedure PostmanByFio(Head, Tail: PPostman; argID: Integer; argFio:string; cmp:TCompare);
var
  CurrentL, CurrentR: PPostman;
  found: Boolean;
begin
  // Сначала сортируем список в алфавитном порядке
  Sort(Head,CompareStr);
  found := False;

  // Ищем первую запись с совпадающим адресом
  currentL:=FindPostman(Head, argID, argFio, cmp);
  currentR:=currentL;
  // Если запись не найдена, выходим из процедуры
  if (currentL <> nil) and (currentR<>nil) then
  begin
    // Выводим найденную запись
    Writeln('ID: ', currentR^.data.id);
    Writeln('ФИО: ', currentR^.data.fio);
    Writeln('Время с которого работает: ', currentR^.data.time_in);
    Writeln('Время до которого работает: ',currentR^.data.time_out);
    Writeln('Объем: ', currentR^.data.volume:4:2);
    Writeln('Вес: ', currentR^.data.weight:4:2);
    // Вывод остальных данных
    Writeln;
    found := True;

    // Перемещаемся к предыдущим записям с совпадающим адресом
    while (currentL^.prev <> nil) and (currentL^.prev^.data.fio = argFio) and (currentL^.prev.prev <> nil) do
    begin
      currentL := currentL^.prev;
      // Выводим найденную запись

      Writeln('ID: ', currentR^.data.id);
      Writeln('ФИО: ', currentR^.data.fio);
      Writeln('Время с которого работает: ', currentR^.data.time_in);
      Writeln('Время до которого работает: ',currentR^.data.time_out);
      Writeln('Объем: ', currentR^.data.volume:4:2);
      Writeln('Вес: ', currentR^.data.weight:4:2);
      // Вывод остальных данных
      Writeln;
      found := True;
    end;

    // Перемещаемся к следующим записям с совпадающим адресом

    // Перемещаемся к следующим записям с совпадающим адресом
    while (currentR^.next <> nil) and (currentR^.next^.data.fio = argFio) do
    begin
      currentR := currentR^.next;
      // Выводим найденную запись
      Writeln('ID: ', currentR^.data.id);
      Writeln('ФИО: ', currentR^.data.fio);
      Writeln('Время с которого работает: ', currentR^.data.time_in);
      Writeln('Время до которого работает: ',currentR^.data.time_out);
      Writeln('Объем: ', currentR^.data.volume:4:2);
      Writeln('Вес: ', currentR^.data.weight:4:2);
      // Вывод остальных данных
      Writeln;
      found := True;
    end;
  end;

  // Если не было найдено ни одной записи с совпадающим адресом, выведем сообщение об этом
  if not found then
    Writeln('Записи с адресом "', argFio, '" не найдены.');
end;

procedure DeletePostman(Head:PPostman; const ID: integer);
var
  postman:PPostman;
  str:string;
begin
  str:='';
  postman := FindPostman(Head, ID,str, ComparePostmanID);
  if postman=nil then
    Writeln('Данной записи не найдено, удаление не возможно')
  else
  begin
    if postman^.prev<>nil then
      postman^.prev^.next:=postman^.next;
    if postman^.next<>nil then
      postman^.next^.prev:=postman^.prev;
    Writeln('Курьер удален');
  end;
end;

procedure EditPostman(Head, Tail: PPostman; const id: Integer);
var
  postman: PPostman;
  isWriting, isCorrect: Boolean;
  integerParam:integer;
  strParam, exitStr: string;
  doubleParam: Double;
  menuVal:integer;
begin
  strParam:='';
  postman := FindPostman(Head, id,strParam,ComparePostmanID);
  if postman=nil then
    Writeln('Данной записи не найдено, редактирование не возможно')
  else
  begin
    Writeln('Запись, которую необходимо отредактировать');
    Writeln('ID: ', postman^.data.id);
    Writeln('1) ФИО: ', postman^.data.fio);
    Writeln('2) Время c которого работает: ',postman^.data.time_in);
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
          Write('Введите ФИО: ');
          Readln(strParam);
          postman^.data.fio := strParam;
        end;
        2:
        begin

          isCorrect:=true;
          Write('Введите время (с 1 до 24) c которого работает : ');
          while isCorrect do
          begin
            Readln(integerParam);
            if (integerParam>0) and (integerParam<=24) then
            begin
              isCorrect:=false;
              postman^.data.time_in := integerParam;
            end
            else
              Writeln('Некорректные данные, попробуйте еще раз');
          end;
          isCorrect:=true;
        end;
        3:
        begin
          isCorrect:=true;
          Write('Введите время (с 1 до 24) до которого работает : ');
          while isCorrect do
          begin
            Readln(integerParam);
            if (integerParam>0) and (integerParam<=24) then
            begin
              isCorrect:=false;
              postman^.data.time_out := integerParam;
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
          postman^.data.volume := doubleParam;
        end;
        5:
        begin
          Write('Введите вес(кг) заказа: ');
          Readln(doubleParam);
          postman^.data.weight := doubleParam;
        end;
        6:
        begin
          isWriting:=False;
        end;
      end;
    end;
    Writeln('Курьер изменен');
  end;
end;


end.
