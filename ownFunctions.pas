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
  writeln('1) ������ ������ �� �����');
  writeln('2) �������� ����� ������');
  writeln('   1) ������ �������');
  writeln('   2) ������ ��������');
  writeln('3) ����������');
  writeln('4) ����� ������ � �������������� ��������');
  writeln('5) ���������� ������ � ������');
  writeln('6) �������� ������ �� ������');
  writeln('7) �������������� ������');
  writeln('8) �������� ����������� ������������� ������� ����� ���������');
  writeln('9) ����� �� ��������� ��� ���������� ���������');
  writeln('10) ����� � ����������� ���������');
  write('�������� ����������� �������� (0 - �����): ');
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
    writeln('1) ������ ������ �� �����');
    writeln('2) �������� ����� ������');
    writeln('3) ����������');
    writeln('   1) ���������� ������� �� ID');
    writeln('   2) ���������� ������� �� ������ ��������');
    writeln('   3) ���������� �������� �� ID');
    writeln('   4) ���������� �������� �� ���');
    writeln('4) ����� ������ � �������������� ��������');
    writeln('5) ���������� ������ � ������');
    writeln('6) �������� ������ �� ������');
    writeln('7) �������������� ������');
    writeln('8) �������� ����������� ������������� ������� ����� ���������');
    writeln('9) ����� �� ��������� ��� ���������� ���������');
    writeln('10) ����� � ����������� ���������');
    write('�������� ����������� �������� (0 - �����): ');
    readln(menuVal);
    case menuVal of
      1:
        begin
          SortOrders(OrderHead, CompareID);
          writeln('������ ������� ������������ �� ID, ������� Enter ����� ����������.');
          readln;
        end;
      2:
        begin
          SortOrders(OrderHead, CompareStr);
          writeln('������ ������� ������������ �� ������ ��������, ������� Enter ����� ����������.');
          readln;
        end;
      3:
        begin
          SortPorstman(PostmanHead, CompareID);
          writeln('������ �������� ������������, ������� Enter ����� ����������.');
          readln;
        end;
      4:
        begin
          SortPorstman(PostmanHead, CompareStr);
          writeln('������ �������� ������������ �� ���, ������� Enter ����� ����������.');
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
      writeln('1) ������ ������ �� �����');
      writeln('2) �������� ����� ������');
      writeln('3) ����������');
      writeln('4) ����� ������ � �������������� ��������');
      writeln('   1) ����� ������ �� ID');
      writeln('   2) ����� ������ �� ������');
      writeln('   3) ����� ������� �� ID');
      writeln('   4) ����� ������ �� ���');
      writeln('5) ���������� ������ � ������');
      writeln('6) �������� ������ �� ������');
      writeln('7) �������������� ������');
      writeln('8) �������� ����������� ������������� ������� ����� ���������');
      writeln('9) ����� �� ��������� ��� ���������� ���������');
      writeln('10) ����� � ����������� ���������');
      write('�������� ����������� �������� (0 - �����): ');
      readln(menuVal);
      isCorrect := false;
      case menuVal of
        1:
          begin
            while not isCorrect do
            begin
              Write('������� ����������� ID: ');
              try
                readln(searchID);
                OrderByID(HeadOrder, searchID, searchStr, CompareOrderID);
                isCorrect := true;
              except
                writeln('������������ ������, ���������� ��� ��� ');
              end;
            end;
          end;
        2:
          begin
            Write('������� ����������� �����: ');
            readln(searchStr);
            OrdersByAddr(HeadOrder, TailOrder, searchID, searchStr,
              CompareOrderAddr);
          end;
        3:
          begin
            while not isCorrect do
            begin
              Write('������� ����������� ID: ');
              try
                readln(searchID);
                PostmanByID(HeadPostman, searchID, searchStr, ComparePostmanID);
                isCorrect := true;
              except
                writeln('������������ ������, ���������� ��� ��� ');
              end;
            end;
          end;
        4:
          begin
            Write('������� ������� ���: ');
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
        writeln('1) ������ ������ �� �����');
        writeln('2) �������� ����� ������');
        writeln('3) ����������');
        writeln('4) ����� ������ � �������������� ��������');
        writeln('5) ���������� ������ � ������');
        writeln('   1) � ������ �������');
        writeln('   2) � ������ ��������');
        writeln('6) �������� ������ �� ������');
        writeln('7) �������������� ������');
        writeln('8) �������� ����������� ������������� ������� ����� ���������');
        writeln('9) ����� �� ��������� ��� ���������� ���������');
        writeln('10) ����� � ����������� ���������');
        write('�������� ����������� �������� (0 - �����): ');
        readln(menuVal);
        case menuVal of
          1:
            begin
              SortOrders(HeadOrder, CompareID);
              while isWriting do
              begin

                Write('������� ����� ��������: ');
                readln(srtParam);
                OrderData.addr := srtParam;

                isCorrect := false;
                while not isCorrect do
                begin
                  Write('������� ����� (� 0 �� 24) � �������� ����� ��������� : ');
                  try
                    readln(integerParam);
                    if (integerParam >= 0) and (integerParam < 24) then
                    begin
                      isCorrect := true;
                      OrderData.time_in := integerParam;
                    end
                    else
                      writeln('������������ ������, ���������� ��� ���');
                  except
                    writeln('������� ����������� ������');
                  end;
                end;
                isCorrect := false;

                while not isCorrect do
                begin
                  Write('������� ����� (� ', OrderData.time_in,
                    ' �� 24) �� �������� ����� ��������� : ');
                  try
                    readln(integerParam);
                    if (integerParam > OrderData.time_in) and
                      (integerParam <= 24) then
                    begin
                      isCorrect := true;
                      OrderData.time_out := integerParam;
                    end
                    else
                      writeln('������������ ������, ���������� ��� ���');
                  except
                    writeln('������������ ������, ���������� ��� ���');
                  end;
                end;
                isCorrect := false;

                while not isCorrect do
                begin
                  Write('������� �����(�^3) ������: ');
                  try
                    readln(doubleParam);
                    if doubleParam > 0 then
                    begin
                      OrderData.volume := doubleParam;
                      isCorrect := true;
                    end
                    else
                      writeln('����� ������ ������ ���� ������ ����.');
                  except
                    writeln('������������ ������, ���������� ��� ���');
                  end;
                end;

                isCorrect := false;

                while not isCorrect do
                begin
                  Write('������� ���(��) ������: ');
                  try
                    readln(doubleParam);
                    if doubleParam > 0 then
                    begin
                      OrderData.weight := doubleParam;
                      isCorrect := true;
                    end
                    else
                      writeln('��� ������ ������ ���� ������ ����.');
                  except
                    writeln('������� ����������� ������');
                  end;

                end;
                AppendOrder(HeadOrder, TailOrder, OrderData);
                Write('�������� ��� ���� �����(��/���): ');
                readln(exitStr);
                while not((exitStr = '���') or (exitStr = '���') or
                  (exitStr = '��') or (exitStr = '��')) do
                begin
                  Write('�������� ����, ��������� �������: ');
                  readln(exitStr);
                end;
                if (exitStr = '���') or (exitStr = '���') then
                  isWriting := false;
              end;
            end;
          2:
            begin
              SortPorstman(HeadPostman, CompareID);
              while isWriting do
              begin
                Write('������� ���: ');
                readln(srtParam);
                PostmanData.fio := srtParam;

                isCorrect := false;
                while not isCorrect do
                begin
                  Write('������� ����� (� 0 �� 24) � �������� �������� : ');
                  try
                    readln(integerParam);
                    if (integerParam >= 0) and (integerParam < 24) then
                    begin
                      isCorrect := true;
                      PostmanData.time_in := integerParam;
                    end
                    else
                      writeln('������������ ������, ���������� ��� ���');
                  except
                    writeln('������������ ������, ���������� ��� ���');
                  end;
                end;
                isCorrect := false;

                while not isCorrect do
                begin
                  Write('������� ����� (� ', PostmanData.time_in,
                    ' �� 24) �� �������� �������� : ');
                  try
                    readln(integerParam);
                    if (integerParam > PostmanData.time_in) and
                      (integerParam <= 24) then
                    begin
                      isCorrect := true;
                      PostmanData.time_out := integerParam;
                    end
                    else
                      writeln('������������ ������, ���������� ��� ���');
                  except
                    writeln('������������ ������, ���������� ��� ���');
                  end;
                end;
                isCorrect := false;

                while not isCorrect do
                begin
                  Write('������� �����(�^3) ������: ');
                  try
                    readln(doubleParam);
                    PostmanData.volume := doubleParam;
                    isCorrect := true;
                  except
                    writeln('������� ����������� ������');
                  end;

                end;
                isCorrect := false;

                while not isCorrect do
                begin
                  Write('������� ���(��) ������: ');
                  try
                    readln(doubleParam);
                    PostmanData.weight := doubleParam;
                    isCorrect := true;
                  except
                    writeln('������� ����������� ������');
                  end;

                end;

                AppendPostman(HeadPostman, TailPostman, PostmanData);

                Write('�������� ��� ������� �������(��/���): ');
                readln(exitStr);
                while not((exitStr = '���') or (exitStr = '���') or
                  (exitStr = '��') or (exitStr = '��')) do
                begin
                  Write('�������� ����, ��������� �������: ');
                  readln(exitStr);
                end;
                if (exitStr = '���') or (exitStr = '���') then
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
          writeln('1) ������ ������ �� �����');
          writeln('2) �������� ����� ������');
          writeln('3) ����������');
          writeln('4) ����� ������ � �������������� ��������');
          writeln('5) ���������� ������ � ������');
          writeln('6) �������� ������ �� ������');
          writeln('   1) �� ������ �������');
          writeln('   2) �� ������ ��������');
          writeln('7) �������������� ������');
          writeln('8) �������� ����������� ������������� ������� ����� ���������');
          writeln('9) ����� �� ��������� ��� ���������� ���������');
          writeln('10) ����� � ����������� ���������');
          write('�������� ����������� �������� (0 - �����): ');
          readln(menuVal);
          isCorrect := false;
          case menuVal of
            1:
              begin
                SortOrders(HeadOrder, CompareID);
                PrintOrders(HeadOrder);
                while not isCorrect do
                begin
                  Write('������� ID ������, ������� ���������� �������: ');
                  try
                    readln(id);

                    str := '';

                    order := FindOrder(HeadOrder, id, str, CompareOrderID);

                    if order = nil then
                      writeln('������ ������ �� �������, �������� �� ��������')
                    else if FindOrderInDelivery(DeliveryHead, order) then
                      writeln('���������� ������� ������ �����, ������ ������ ��� � ��������')
                    else
                    begin

                      if (order^.prev <> nil) then
                        order^.prev^.next := order^.next;
                      if order^.next <> nil then
                        order^.next^.prev := order^.prev;
                      if order^.next = nil then
                        TailOrder := order^.prev;
                      Dispose(order);
                      writeln('����� ������');

                    end;

                    isCorrect := true;
                  except
                    writeln('������������ ������, ���������� ��� ���');
                  end;
                end;

              end;
            2:
              begin
                SortPorstman(HeadPostman, CompareID);
                PrintPostmans(HeadPostman);
                while not isCorrect do
                begin
                  Write('������� ID �������, �������� ���������� �������: ');
                  try
                    readln(id);
                    str := '';

                    postman := FindPostman(HeadPostman, id, str,
                      ComparePostmanID);

                    if postman = nil then
                      writeln('������ ������ �� �������, �������� �� ��������')
                    else if FindPostmanInDelivery(DeliveryHead, postman) then
                      writeln('���������� ������� �������, ������ ������ ������ � ��������')
                    else
                    begin

                      if (postman^.prev <> nil) then
                        postman^.prev^.next := postman^.next;
                      if postman^.next <> nil then
                        postman^.next^.prev := postman^.prev;
                      if postman^.next = nil then
                        TailPostman := postman^.prev;
                      Dispose(postman);
                      writeln('������ ������');

                    end;
                    isCorrect := true;
                  except
                    writeln('������������ ������, ���������� ��� ���');
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
            writeln('1) ������ ������ �� �����');
            writeln('2) �������� ����� ������');
            writeln('3) ����������');
            writeln('4) ����� ������ � �������������� ��������');
            writeln('5) ���������� ������ � ������');
            writeln('6) �������� ������ �� ������');
            writeln('7) �������������� ������');
            writeln('   1) �� ������ �������');
            writeln('   2) �� ������ ��������');
            writeln('8) �������� ����������� ������������� ������� ����� ���������');
            writeln('9) ����� �� ��������� ��� ���������� ���������');
            writeln('10) ����� � ����������� ���������');
            write('�������� ����������� �������� (0 - �����): ');
            readln(menuVal);
            isCorrect := false;
            case menuVal of
              1:
                begin
                  SortOrders(HeadOrder, CompareID);
                  PrintOrders(HeadOrder);
                  while not isCorrect do
                  begin
                    Write('������� ID ������, ������� ���������� ���������������: ');
                    try
                      readln(id);
                      order := FindOrder(HeadOrder, id, str, CompareOrderID);
                      if order <> nil then
                      begin
                        EditOrder(HeadOrder, TailOrder, id, order);
                        isCorrect := true;
                      end
                      else
                        writeln('���������� �������� �����, �.�. �� ����������� � ��������');
                    except
                      writeln('������������ ������, ���������� ��� ���');
                    end;
                  end;
                end;
              2:
                begin
                  SortPorstman(HeadPostman, CompareID);
                  PrintPostmans(HeadPostman);
                  while not isCorrect do
                  begin
                    Write('������� ID �������, �������� ���������� ���������������: ');
                    try
                      readln(id);
                      postman := FindPostman(HeadPostman, id, str,
                        ComparePostmanID);
                      EditPostman(HeadPostman, TailPostman, id, postman);
                      isCorrect := true;

                    except
                      writeln('������������ ������, ���������� ��� ���');
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
              writeln('1) ������ ������ �� �����');
              writeln('2) �������� ����� ������');
              writeln('3) ����������');
              writeln('4) ����� ������ � �������������� ��������');
              writeln('5) ���������� ������ � ������');
              writeln('6) �������� ������ �� ������');
              writeln('7) �������������� ������');
              writeln('8) �������� ����������� ������������� ������� ����� ���������');
              writeln('   1) ������������ ������');
              writeln('   2) ����������� �������������');
              writeln('   3) ����������� ������������� �������');
              writeln('9) ����� �� ��������� ��� ���������� ���������');
              writeln('10) ����� � ����������� ���������');
              write('�������� ����������� �������� (0 - �����): ');
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
                      Write('������� ID �������, ������ �������� �� ������ �����������: ');
                      try
                        readln(id);
                        PrintByID(HeadD, id, CompareIDDel);
                        isCorrect := true;
                      except
                        writeln('������������ ������, ���������� ��� ���');
                      end;
                    end;
                  end;
                0:
                end;
              end;

end.
