program server;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  Horse.Jhonson,
  UnitCustomer.Model in 'Modulos\Customer\Model\UnitCustomer.Model.pas',
  UnitDatabase in 'Database\UnitDatabase.pas',
  UnitCustomer.Controller in 'Modulos\Customer\Controller\UnitCustomer.Controller.pas';

begin
  //middlewares
  THorse.Use(Jhonson);

  //controllers
  TCustomerController.Registry;

  THorse.Listen(3333, procedure(App: THorse)
  begin
    Writeln('Server is running on port '+App.Port.ToString);
  end);

end.
