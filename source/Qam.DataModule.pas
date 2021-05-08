unit Qam.DataModule;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils,
  Vcl.BaseImageCollection, Vcl.ImageCollection,
  EventBus,
  Qodelib.Themes,
  Qam.Database, Qam.Events;

type
  TdmCommon = class(TDataModule)
    icLightIcons: TImageCollection;
    icDarkIcons: TImageCollection;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FDatabase: IQamTrailsDatabase;
    procedure ThemeChangeEvent(Sender: TObject);
    procedure ThemeChanged;
    procedure LoadDatabase;
  public
    property Database: IQamTrailsDatabase read FDatabase;
    procedure MainFormCreated;
    function GetImageCollection: TImageCollection;
    [Subscribe]
    procedure OnSettingChange(AEvent: ISettingChangeEvent);
  end;

var
  dmCommon: TdmCommon;

implementation

uses
  Spring.Container,
  Qam.Settings, Qam.Storage;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdmCommon.DataModuleCreate(Sender: TObject);
begin
  GlobalEventBus.RegisterSubscriberForEvents(Self);
  QuarkzThemeManager.OnChange := ThemeChangeEvent;
  ApplicationSettings.LoadSettings;
  ThemeChanged;
end;

procedure TdmCommon.DataModuleDestroy(Sender: TObject);
begin
  Database.Close;
  ApplicationSettings.SaveSettings;
end;

function TdmCommon.GetImageCollection: TImageCollection;
begin
  if QuarkzThemeManager.IsDark then
    Result := icLightIcons
  else
    Result := icDarkIcons;
end;

procedure TdmCommon.LoadDatabase;
var
  DatabaseFilename: String;
begin
  DatabaseFilename := TPath.Combine(ApplicationSettings.DataFoldername, 'QamTrails.db');
  FDatabase := GlobalContainer.Resolve<IQamTrailsDatabase>;
  TDataStorage.Initialize;
  Database.Load(DatabaseFilename);
  GlobalEventBus.Post(TEventFactory.NewDatabaseLoadEvent(Database));
end;

procedure TdmCommon.MainFormCreated;
begin
  ThemeChanged;
end;

procedure TdmCommon.OnSettingChange(AEvent: ISettingChangeEvent);
begin
  case AEvent.Value of
    svMainCollectionFolder:
      LoadDatabase;
  end;
end;

procedure TdmCommon.ThemeChanged;
begin
  GlobalEventBus.Post(TEventFactory.NewThemeChangeEvent(
    QuarkzThemeManager.ThemeName, QuarkzThemeManager.IsDark));
end;

procedure TdmCommon.ThemeChangeEvent(Sender: TObject);
begin
  ThemeChanged;
end;

end.
