unit Qam.Database;

interface

uses
  System.SysUtils, System.Classes,
  Spring.Persistence.Core.Session,
  Spring.Persistence.Core.Interfaces,
  Spring.Persistence.Adapters.SQLite;

type
  IQamTrailsDatabase = interface
    ['{8DEC4252-2E6E-4641-9246-10BC7A8D24B1}']
    { Property Accessors }
    function GetSession: TSession;
    function GetConnection: IDBConnection;
    function GetFilename: String;
    function Load(const AFilename: String): Boolean;
    procedure Close;
    property Session: TSession read GetSession;
    property Connection: IDBConnection read GetConnection;
    property Filename: String read GetFilename;
  end;

implementation

uses
  Spring.Container,
  SQLiteTable3,
  Qam.DatabaseMigrator;

type
  TQamTrailsDatabase = class(TInterfacedObject, IQamTrailsDatabase)
  private
    FFilename: String;
    FDatabase: TSQLiteDatabase;
    FConnection: IDBConnection;
    FSession: TSession;
    procedure BuildDatabase;
  protected
    function GetSession: TSession;
    function GetConnection: IDBConnection;
    function GetFilename: String;
  public
    constructor Create;
    destructor Destroy; override;
    function Load(const AFilename: String): Boolean;
    procedure Close;
    function IsLoaded: Boolean;
    property Session: TSession read GetSession;
    property Connection: IDBConnection read GetConnection;
    property Filename: String read GetFilename;
  end;

const
  SDatabaseFilename = 'QamTrails.db';

{ TQamTrailsDatabase }

procedure TQamTrailsDatabase.BuildDatabase;
var
  Migrator: IDatabaseMigrator;
begin
  Migrator :=  GlobalContainer.Resolve<IDatabaseMigrator>;
  Migrator.Execute(FConnection);
end;

procedure TQamTrailsDatabase.Close;
begin
  FreeAndNil(FSession);
  FreeAndNil(FDatabase);
end;

constructor TQamTrailsDatabase.Create;
begin
  inherited;
  FSession := nil;
  FDatabase := nil;
end;

destructor TQamTrailsDatabase.Destroy;
begin
  Close;
  inherited;
end;

function TQamTrailsDatabase.GetConnection: IDBConnection;
begin
  Result := FConnection;
end;

function TQamTrailsDatabase.GetFilename: String;
begin
  Result := FFilename;
end;

function TQamTrailsDatabase.GetSession: TSession;
begin
  Result := FSession;
end;

function TQamTrailsDatabase.IsLoaded: Boolean;
begin
  Result := FSession <> nil;
end;

function TQamTrailsDatabase.Load(const AFilename: String): Boolean;
begin
  Close;

  FFilename := ExpandFilename(AFilename);
  FDatabase := TSQLiteDatabase.Create(nil);
  FDatabase.Filename := Filename;
  FConnection := TSQLiteConnectionAdapter.Create(FDatabase);
  FConnection.AutoFreeConnection := false;
  FConnection.Connect;
  FSession := TSession.Create(FConnection);

  BuildDatabase;

  Result := FileExists(Filename);
end;

initialization
  GlobalContainer.RegisterType<TQamTrailsDatabase>.Implements<IQamTrailsDatabase>.AsSingleton;
end.
