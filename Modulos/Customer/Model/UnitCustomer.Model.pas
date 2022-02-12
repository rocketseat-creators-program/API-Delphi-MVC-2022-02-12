unit UnitCustomer.Model;

interface
  uses
    System.SysUtils,
    System.Generics.Collections,
    UnitConnection.Model.Interfaces;

type
  TCustomerModel = class
  private
    Fcodigo: integer;
    Fnome: string;
    Fcpf_cnpj: string;
  public
    property codigo: integer read Fcodigo write Fcodigo;
    property nome: string read Fnome write Fnome;
    property cpf_cnpj: string read Fcpf_cnpj write Fcpf_cnpj;
    //metodos
    class function find(id: integer): TCustomerModel;
    class function findAll: TList<TCustomerModel>;
    procedure Insert;
    procedure Update;
    procedure Delete;
  end;

implementation

{ TCustomerModel }

uses UnitDatabase;

procedure TCustomerModel.Delete;
var
  Query: iQuery;
begin
  Query := TDatabase.Query;
  Query.Add('DELETE FROM CLIENTES WHERE CLI_CODIGO = :CODIGO');
  Query.AddParam('CODIGO', codigo);
  Query.ExecSQL;
end;

class function TCustomerModel.find(id: integer): TCustomerModel;
var
  Query: iQuery;
begin
  Query := TDatabase.Query;
  Query.Add('SELECT CLI_CODIGO, CLI_NOME, CLI_CPF_CNPJ FROM CLIENTES ');
  Query.Add('WHERE CLI_CODIGO = :CODIGO');
  Query.AddParam('CODIGO', id);
  Query.Open();
  if not Query.DataSet.IsEmpty then
  begin
    Result := TCustomerModel.Create;
    Result.codigo   := Query.DataSet.FieldByName('CLI_CODIGO').AsInteger;
    Result.nome     := Query.DataSet.FieldByName('CLI_NOME').AsString;
    Result.cpf_cnpj := Query.DataSet.FieldByName('CLI_CPF_CNPJ').AsString;
  end;
end;

class function TCustomerModel.findAll: TList<TCustomerModel>;
var
  Query: iQuery;
  Customer: TCustomerModel;
begin
  Result := TList<TCustomerModel>.Create;
  Query := TDatabase.Query;
  Query.Open('SELECT CLI_CODIGO, CLI_NOME, CLI_CPF_CNPJ FROM CLIENTES');
  Query.DataSet.First;
  while not Query.DataSet.Eof do
  begin
    Customer := TCustomerModel.Create;
    Customer.codigo   := Query.DataSet.FieldByName('CLI_CODIGO').AsInteger;
    Customer.nome     := Query.DataSet.FieldByName('CLI_NOME').AsString;
    Customer.cpf_cnpj := Query.DataSet.FieldByName('CLI_CPF_CNPJ').AsString;
    Result.Add(Customer);
    Query.DataSet.Next;
  end;
end;

procedure TCustomerModel.Insert;
var
  Query: iQuery;
begin
  Query := TDatabase.Query;
  Query.Add('INSERT INTO CLIENTES(CLI_CODIGO, CLI_NOME, CLI_CPF_CNPJ) VALUES(:CODIGO, :NOME, :CNPJ_CPF)');
  Query.AddParam('CODIGO', codigo);
  Query.AddParam('NOME', nome.ToUpper);
  Query.AddParam('CNPJ_CPF', cpf_cnpj);
  Query.ExecSQL;
end;

procedure TCustomerModel.Update;
var
  Query: iQuery;
begin
  Query := TDatabase.Query;
  Query.Add('UPDATE CLIENTES SET CLI_NOME = :NOME, CLI_CPF_CNPJ = :CNPJ_CPF WHERE CLI_CODIGO = :CODIGO');
  Query.AddParam('CODIGO', codigo);
  Query.AddParam('NOME', nome.ToUpper);
  Query.AddParam('CNPJ_CPF', cpf_cnpj);
  Query.ExecSQL;
end;

end.
