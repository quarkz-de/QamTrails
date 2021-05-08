unit Qam.DatabaseMigrations;

interface

uses
  Generics.Collections,
  Spring.Collections,
  Qam.Migrations;

const
  MigrationCreateMigrationTable = 1;

type
  IDatabaseMigration = interface
    ['{16BA6965-40B0-4346-A24F-7FF7CC47177B}']
    function GetID: Integer;
    function Execute(const AMigration: TMigration): Boolean;
    property ID: Integer read GetID;
  end;

  TMigrationFactory = class
  public
    class function Build: IList<IDatabaseMigration>;
  end;

implementation

uses
  Spring.Container,
  Spring.Persistence.Core.Interfaces,
  Qam.Database;

type
  TAbstractDatabaseMigration = class(TInterfacedObject, IDatabaseMigration)
  private
    FID: Integer;
  protected
    function GetID: Integer;
    function AlterTableCommand(const ASql: String): Boolean;
    procedure SaveMigration(const AMigration: TMigration; const AID: Integer);
  public
    constructor Create(const AID: Integer); virtual;
    function Execute(const AMigration: TMigration): Boolean; virtual; abstract;
    property ID: Integer read GetID;
  end;

{ TMigrationFactory }

class function TMigrationFactory.Build: IList<IDatabaseMigration>;
begin
  Result := TCollections.CreateList<IDatabaseMigration>;
end;

{ TAbstractDatabaseMigration }

function TAbstractDatabaseMigration.AlterTableCommand(
  const ASql: String): Boolean;
var
  Database: IQamTrailsDatabase;
  Statement: IDBStatement;
begin
  Database := GlobalContainer.Resolve<IQamTrailsDatabase>;
  Statement := Database.Connection.CreateStatement;
  Statement.SetSQLCommand(ASql);
  Result := Statement.Execute = 0;
end;

constructor TAbstractDatabaseMigration.Create(const AID: Integer);
begin
  inherited Create;
  FID := AID;
end;

function TAbstractDatabaseMigration.GetID: Integer;
begin
  Result := FID;
end;

procedure TAbstractDatabaseMigration.SaveMigration(const AMigration: TMigration;
  const AID: Integer);
var
  Migration: TMigration;
  Database: IQamTrailsDatabase;
begin
  if AMigration = nil then
    begin
      Migration := TMigration.Create;
      Migration.Migration := AID;
    end
  else
    Migration := AMigration;

  Migration.Status := migSuccessful;

  Database := GlobalContainer.Resolve<IQamTrailsDatabase>;
  Database.GetSession.Save(Migration);

  if AMigration = nil then
    Migration.Free;
end;

end.
