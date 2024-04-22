unit fileModule;

interface

uses
  orderModule, postmanModule, specialFunction;

type
  TOrderFile = file of TOrderData;
  TPostmanFile = file of TPostmanData;
  TDeliveryFile = file of TDeliveryData;

procedure saveToFile(var OrderHead: POrder; var PostmanHead: PPostman;
  var DeliveryHead: PDelivery);
procedure OpenFiles(var OrderHead, OrderTail: POrder;
  var PostmanHead, PostmanTail: PPostman;
  var DeliveryHead, DeliveryTail: PDelivery);

implementation

uses
  System.SysUtils, Windows, ownFunctions;

var
  OrderFile: TOrderFile;
  PostmanFile: TPostmanFile;
  DeliveryFile: TDeliveryFile;

  { *

    This part of code wotk with files for save they
    1) We need concrete we need sava files or not.
    2) We need write directory where we want to store out files
    3) We need to write name for directory where we want store our data
    4) If directory alrady exist we ask to the customer: reset directory or not?
    5) If customer choose reset, we are reset files
    6) If not, customer should write new directory name
    7) if directory does not exist we are create it and save files to this directory

    * }
procedure addToDataToFile(var listOrder: POrder; var listPostman: PPostman;
  var listDelivery: PDelivery; const folderName, directoryPath: string);
var
  pathOrder, pathPostman, pathDelivery: string;
  tempOrder: POrder;
  tempPostman: PPostman;
  tempDelivery: PDelivery;
begin
  pathOrder := directoryPath + '\' + folderName + '_OrderList.data';
  pathPostman := directoryPath + '\' + folderName + '_PostmanList.data';
  pathDelivery := directoryPath + '\' + folderName + '_DeliveryList.data';

  // Write order data to file
  assign(OrderFile, pathOrder);
  rewrite(OrderFile);
  tempOrder := listOrder;
  while tempOrder <> nil do
  begin
    write(OrderFile, tempOrder^.data);
    tempOrder := tempOrder^.next;
  end;
  close(OrderFile);

  // Write postman data to file
  assign(PostmanFile, pathPostman);
  rewrite(PostmanFile);
  tempPostman := listPostman;
  while tempPostman <> nil do
  begin
    write(PostmanFile, tempPostman^.data);
    tempPostman := tempPostman^.next;
  end;
  close(PostmanFile);

  // Write delivery data to file
  assign(DeliveryFile, pathDelivery);
  rewrite(DeliveryFile);
  tempDelivery := listDelivery;
  while tempDelivery <> nil do
  begin
    write(DeliveryFile, tempDelivery^.data);
    tempDelivery := tempDelivery^.next;
  end;
  close(DeliveryFile);
end;

procedure checkExist(const errorOrder, errorPostman, errorDelivery: Integer;
  folderName, directoryPath: string; var listOrder: POrder;
  var listPostman: PPostman; var listDelivery: PDelivery);
var
  checkInput: string;
  checkInt: Integer;
begin
  if (errorOrder <> 0) or (errorPostman <> 0) or (errorDelivery <> 0) then
  begin
    repeat
      writeln('The folder with the entered name already exists.');
      write('Enter 1 to overwrite data, otherwise 0: ');
      Readln(checkInput);
    until TryStrToInt(checkInput, checkInt) and
      ((checkInt = 0) or (checkInt = 1));

    if checkInt = 0 then
      writeln('You declined to overwrite.')
    else
    begin
      addToDataToFile(listOrder, listPostman, listDelivery, folderName,
        directoryPath);
      writeln('Data has been overwritten.');
    end;
  end
  else
  begin
    addToDataToFile(listOrder, listPostman, listDelivery, folderName,
      directoryPath);
    writeln('Data has been written to the directory.');
  end;
end;

procedure createFiles(var listOrder: POrder; var listPostman: PPostman;
  var listDelivery: PDelivery; var folderName, directoryPath: String;
  var errorOrder, errorPostman, errorDelivery: Integer);
var
  checkPath: string;
begin
  writeln('Enter the name of the folder you want to create:');
  Readln(folderName);

  directoryPath := directoryPath + '\' + folderName;
  if not DirectoryExists(directoryPath) then
  begin
    ForceDirectories(directoryPath);
    addToDataToFile(listOrder, listPostman, listDelivery, folderName,
      directoryPath);
    writeln('A new folder has been created. Data has been written.');
  end
  else
  begin
    checkPath := directoryPath + '\' + folderName + '_OrderList.data';
    if FileExists(checkPath) then
      errorOrder := 1;

    checkPath := directoryPath + '\' + folderName + '_PostmanList.data';
    if FileExists(checkPath) then
      errorPostman := 1;

    checkPath := directoryPath + '\' + folderName + '_DeliveryList.data';
    if FileExists(checkPath) then
      errorDelivery := 1;

    checkExist(errorOrder, errorPostman, errorDelivery, folderName,
      directoryPath, listOrder, listPostman, listDelivery);
  end;
end;

procedure saveToFile(var OrderHead: POrder; var PostmanHead: PPostman;
  var DeliveryHead: PDelivery);
var
  directoryPath, folderName: string;
  menuInt: Integer;
  errorOrder, errorPostman, errorDelivery: Integer;
begin
  writeln('You have chosen the save function with modifications.');
  writeln;

  repeat
    writeln('Enter the path where you want to create the folder with files:');
    Readln(directoryPath);
    if not DirectoryExists(directoryPath) then
      writeln('The specified directory does not exist. Please try again.');
  until DirectoryExists(directoryPath);

  createFiles(OrderHead, PostmanHead, DeliveryHead, folderName, directoryPath,
    errorOrder, errorPostman, errorDelivery);
end;

// ---------------------------------------------------------------------------

{ *

  This part of code is responsible for open files and take data from this files

  * }

procedure ReadDataFromFiles(var listOrder, tailOrder: POrder;
  var listPostman, tailPostman: PPostman;
  var listDelivery, tailDelivery: PDelivery;
  var folderName, directoryPath: String; var errorOrder, errorPostman,
  errorDelivery: Integer);
var
  checkPath: string;
  OrderData: TOrderData;
  PostmanData: TPostmanData;
  DeliveryData: TDeliveryData;
begin
  writeln('Введите название папки, где храняться файлы:');
  Readln(folderName);
  folderName := Trim(folderName); // Trim leading and trailing spaces
  directoryPath := directoryPath + '\' + folderName;

  if DirectoryExists(directoryPath) then
  begin
    checkPath := directoryPath + '\' + folderName + '_OrderList.data';
    if FileExists(checkPath) then
    begin
      writeln('!');
      assign(OrderFile, checkPath);
      reset(OrderFile);
      Read(OrderFile, OrderData);
      listOrder.data.id:=OrderData.id;
      while not EOF(OrderFile) do
      begin
        Read(OrderFile, OrderData);
        writeln('!');
        AppendOrderFromFile(listOrder, tailOrder, OrderData);
      end;
      close(OrderFile);
    end
    else
      errorOrder := 1; // File not found error

    checkPath := directoryPath + '\' + folderName + '_PostmanList.data';
    if FileExists(checkPath) then
    begin
      assign(PostmanFile, checkPath);
      reset(PostmanFile);

      Read(PostmanFile, PostmanData);
      listPostman.data.id:=PostmanData.id;
      while not EOF(PostmanFile) do
      begin
        writeln('+');
        Read(PostmanFile, PostmanData);
        AppendPostmanFromFile(listPostman, tailPostman, PostmanData);
      end;
      close(PostmanFile);
    end
    else
      errorPostman := 1; // File not found error

    checkPath := directoryPath + '\' + folderName + '_DeliveryList.data';
    if FileExists(checkPath) then
    begin
      assign(DeliveryFile, checkPath);
      reset(DeliveryFile);
      Read(DeliveryFile, DeliveryData);
      listDelivery.data.id:=DeliveryData.id;
      while not EOF(DeliveryFile) do
      begin
        writeln('-');
        Read(DeliveryFile, DeliveryData);
        AppendDeliveryFromFile(listDelivery, tailDelivery, DeliveryData);
      end;
      close(DeliveryFile);
    end
    else
      errorPostman := 1; // File not found error



    // Similar operations for Postman and Delivery files

    writeln('Данные прочитаны успешно!');
  end
  else
  begin
    writeln('Такой папки не существует.');
    writeln('Пожалуйста, введите название существующей папки.');
    // Repeat the directory input process
  end;
end;

procedure OpenFiles(var OrderHead, OrderTail: POrder;
  var PostmanHead, PostmanTail: PPostman;
  var DeliveryHead, DeliveryTail: PDelivery);
var
  menuInt: Integer;
  errorOrder, errorPostman, errorDelivery: Integer;
  directoryPath, folderName: string;
begin

  writeln('Вы выбрали функцию чтения данных из файла.');
  writeln('Введите 1 чтобы продолжить, 0 - выйти:');

  repeat
    try
      Readln(menuInt);
      if (menuInt <> 0) and (menuInt <> 1) then
        Write('Неверный ввод, попробуйте еще раз: ')
      else
      begin
        case menuInt of
          0:
            begin
              writeln('Выход из функции...');
              // Add delay or exit statement
            end;
          1:
            begin
              writeln('Введите путь по которому находиться папка:');
              Readln(directoryPath);
              // Validate directory path and proceed
              ReadDataFromFiles(OrderHead, OrderTail, PostmanHead, PostmanTail,
                DeliveryHead, DeliveryTail, folderName, directoryPath,
                errorOrder, errorPostman, errorDelivery);
            end;
        end;
      end;
    except
      Write('Неверный ввод, попробуйте еще раз: ')
    end;
  until (menuInt = 0) or (menuInt = 1);
end;

end.
