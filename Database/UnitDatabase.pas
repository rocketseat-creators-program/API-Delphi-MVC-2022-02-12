unit UnitDatabase;

interface
uses
  UnitConnection.Model.Interfaces,
  UnitFactory.Connection.IBExpress;

type
  TDatabase = class
    class function Query: iQuery;
  end;

implementation

{ TDatabase }

class function TDatabase.Query: iQuery;
begin
  Result := TFactoryConnectionIBExpress.New('../../Database/PRINCIPAL.fdb').Query;
end;

end.
