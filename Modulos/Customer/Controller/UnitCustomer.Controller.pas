unit UnitCustomer.Controller;

interface
uses
  Horse,
  Horse.Commons,
  Classes,
  SysUtils,
  System.Json,
  System.Generics.Collections,
  DB,
  UnitConnection.Model.Interfaces;


type
  TCustomerController = class
    class procedure Registry;
    class procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure GetOne(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure Create(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure Update(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;

implementation

{ TCustomerController }

uses UnitCustomer.Model;

class procedure TCustomerController.Create(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  oJson: TJSONObject;
  customer: TCustomerModel;
begin
  if Req.Body.IsEmpty then
    raise Exception.Create('Client not found!');
  oJson := Req.Body<TJSONObject>;
  customer := TCustomerModel.Create;
  customer.codigo := oJson.GetValue<integer>('codigo');
  customer.nome   := oJson.GetValue<string>('nome');
  customer.cpf_cnpj := oJson.GetValue<string>('cpf_cnpj');
  customer.Insert;
  Res.Send<TJSONObject>(oJson).Status(THTTPStatus.Created);
end;

class procedure TCustomerController.Delete(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
var
  id: Integer;
  customer: TCustomerModel;
begin
  if Req.Params.Count = 0 then
    raise Exception.Create('id not found');
  id := Req.Params.Items['id'].ToInteger;
  customer := TCustomerModel.find(id);
  customer.Delete;
  Res.Send<TJSONObject>(TJSONObject.Create.AddPair('message', 'Customer successfully deleted')).Status(THTTPStatus.NoContent);
end;

class procedure TCustomerController.Get(Req: THorseRequest; Res: THorseResponse;
  Next: TProc);
var
  aJson: TJSONArray;
  customers: TList<TCustomerModel>;
  customer: TCustomerModel;
  oJson: TJSONObject;
begin
  aJson := TJSONArray.Create;
  customers := TCustomerModel.findAll;
  for customer in customers do
  begin
    oJson := TJSONObject.Create;
    oJson.AddPair('codigo', TJSONNumber.Create(customer.codigo));
    oJson.AddPair('nome', customer.nome);
    oJson.AddPair('cpf_cnpj', customer.cpf_cnpj);
    aJson.AddElement(oJson);
  end;
  Res.Send<TJSONArray>(aJson)
end;

class procedure TCustomerController.GetOne(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
var
  id: Integer;
  customer: TCustomerModel;
  oJson: TJSONObject;
begin
  if Req.Params.Count > 0 then
    id := Req.Params.Items['id'].ToInteger;
  if id = 0 then
    raise Exception.Create('id not found!');
  customer := TCustomerModel.find(id);
  if Assigned(customer) then
  begin
    oJson := TJSONObject.Create;
    oJson.AddPair('codigo', TJSONNumber.Create(customer.codigo));
    oJson.AddPair('nome', customer.nome);
    oJson.AddPair('cpf_cnpj', customer.cpf_cnpj);
    Res.Send<TJSONObject>(oJson);
  end;
end;

class procedure TCustomerController.Registry;
begin
  THorse.Get('/customer', Get)
        .Get('/customer/:id', GetOne)
        .Post('/customer', Create)
        .Put('/customer/:id', Update)
        .Delete('/customer/:id', Delete)
end;

class procedure TCustomerController.Update(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
var
  oJson: TJSONObject;
  customer: TCustomerModel;
  id: Integer;
begin
  if Req.Body.IsEmpty then
    raise Exception.Create('Customer data not found!');
  if Req.Params.Count = 0 then
    raise Exception.Create('Id not found');
  id := Req.Params.Items['id'].ToInteger;
  oJson := Req.Body<TJSONObject>;
  customer := TCustomerModel.find(id);
  customer.codigo := oJson.GetValue<integer>('codigo');
  customer.nome   := oJson.GetValue<string>('nome');
  customer.cpf_cnpj := oJson.GetValue<string>('cpf_cnpj');
  customer.Update;
  Res.Send<TJSONObject>(oJson);
end;

end.
