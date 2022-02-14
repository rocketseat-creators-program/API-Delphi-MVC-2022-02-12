unit UnitCustomer.Controller;

interface

uses
  System.Generics.Collections,
  Horse,
  Horse.Commons,
  Classes,
  SysUtils,
  System.Json,
  UnitConnection.Model.Interfaces;

type
  TCustomerController = class
    class procedure Registry;
    class procedure GetAll(Req: THorseRequest; Res: THorseResponse;
      Next: TProc);
    class procedure GetOne(Req: THorseRequest; Res: THorseResponse;
      Next: TProc);
    class procedure Post(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure Put(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure Delete(Req: THorseRequest; Res: THorseResponse;
      Next: TProc);
  end;

implementation

{ TCustomerController }

uses UnitCustomer.Model;

class procedure TCustomerController.Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  id: Integer;
  Customer: TCustomerModel;
begin
  if Req.Params.Count = 0 then
    raise Exception.Create('id not found');
  id := Req.Params.Items['id'].ToInteger();
  Customer := TCustomerModel.find(id);
  if Assigned(Customer) then
  begin
    Customer.Delete;
    Res.Send<TJSONObject>(TJSONObject.Create.AddPair('message', 'Customer sucessfully deleted'));
  end
  else
  begin
    Res.Send<TJSONObject>(TJSONObject.Create.AddPair('message', 'Customer not found'))
       .Status(THTTPStatus.NotFound);
  end;
end;

class procedure TCustomerController.GetAll(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Customers: TList<TCustomerModel>;
  Customer: TCustomerModel;
  aJson: TJSONArray;
  ojson: TJSONObject;
begin
  aJson := TJSONArray.Create;
  Customers := TCustomerModel.findAll;
  for Customer in Customers do
  begin
    ojson := TJSONObject.Create;
    ojson.AddPair('codigo', TJSONNumber.Create(Customer.codigo));
    ojson.AddPair('nome', Customer.nome);
    ojson.AddPair('cpf_cnpj', Customer.cpf_cpnj);
    aJson.AddElement(ojson);
  end;
  Res.Send<TJSONArray>(aJson);
end;

class procedure TCustomerController.GetOne(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Customer: TCustomerModel;
  ojson: TJSONObject;
  id: Integer;
begin
  if Req.Params.Count = 0 then
    raise Exception.Create('id not found');
  id := Req.Params.Items['id'].ToInteger();
  Customer := TCustomerModel.find(id);
  if Assigned(Customer) then
  begin
    ojson := TJSONObject.Create;
    ojson.AddPair('codigo', TJSONNumber.Create(Customer.codigo));
    ojson.AddPair('nome', Customer.nome);
    ojson.AddPair('cpf_cnpj', Customer.cpf_cpnj);
    Res.Send<TJSONObject>(ojson).Status(THTTPStatus.OK);
  end
  else
    Res.Send<TJSONObject>(TJSONObject.Create.AddPair('message',
      'Customer not found')).Status(THTTPStatus.NotFound);
end;

class procedure TCustomerController.Post(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  ojson: TJSONObject;
  Customer: TCustomerModel;
begin
  if Req.Body.IsEmpty then
    raise Exception.Create('Customer data not found');
  ojson := Req.Body<TJSONObject>;
  Customer := TCustomerModel.Create;
  try
    Customer.codigo   := ojson.GetValue<Integer>('codigo');
    Customer.nome     := ojson.GetValue<string>('nome');
    Customer.cpf_cpnj := ojson.GetValue<string>('cpf_cnpj');
    Customer.Insert;
    Res.Send<TJSONObject>(ojson).Status(THTTPStatus.Created);
  finally
    Customer.Free;
  end;
end;

class procedure TCustomerController.Put(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Customer: TCustomerModel;
  ojson: TJSONObject;
  id: Integer;
begin
  if Req.Params.Count = 0 then
    raise Exception.Create('id not found');
  id := Req.Params.Items['id'].ToInteger();
  if Req.Body.IsEmpty then
    raise Exception.Create('Customer data not found');
  ojson := Req.Body<TJSONObject>;
  Customer := TCustomerModel.find(id);
  if Assigned(Customer) then
  begin
    Customer.codigo   := id;
    Customer.nome     := ojson.GetValue<string>('nome');
    Customer.cpf_cpnj := ojson.GetValue<string>('cpf_cnpj');
    Customer.Update;
    Res.Send<TJSONObject>(ojson).Status(THTTPStatus.OK);
  end
  else
    Res.Send<TJSONObject>(TJSONObject.Create.AddPair('message', 'Customer not found')).Status(THTTPStatus.NotFound);

end;

class procedure TCustomerController.Registry;
begin
  THorse.Get('/customer', GetAll)
        .Get('/customer/:id', GetOne)
        .Post('/customer', Post)
        .Put('/customer/:id', Put)
        .Delete('/customer/:id', Delete);
end;

end.
