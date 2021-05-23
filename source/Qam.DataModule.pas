unit Qam.DataModule;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils,
  Vcl.BaseImageCollection, Vcl.ImageCollection,
  EventBus,
  Qodelib.Themes,
  Qam.Events;

type
  TdmCommon = class(TDataModule)
    icLightIcons: TImageCollection;
    icDarkIcons: TImageCollection;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    procedure ThemeChangeEvent(Sender: TObject);
    procedure ThemeChanged;
  public
    procedure MainFormCreated;
    function GetImageCollection: TImageCollection;
    [Subscribe]
    procedure OnSettingChange(AEvent: ISettingChangeEvent);
  end;

var
  dmCommon: TdmCommon;

implementation

uses
  Spring, Spring.Collections, Spring.Container,
  Qam.Settings, Qam.Storage, Qam.PhotoAlbums;

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
var
  Albums: IPhotoAlbumCollection;
begin
  ApplicationSettings.SaveSettings;

  Albums := GlobalContainer.Resolve<IPhotoAlbumCollection>;
  Albums.SaveAlbumList;
end;

function TdmCommon.GetImageCollection: TImageCollection;
begin
  if QuarkzThemeManager.IsDark then
    Result := icLightIcons
  else
    Result := icDarkIcons;
end;

procedure TdmCommon.MainFormCreated;
begin
  ThemeChanged;
end;

procedure TdmCommon.OnSettingChange(AEvent: ISettingChangeEvent);
var
  Albums: IPhotoAlbumCollection;
begin
  case AEvent.Value of
    svMainCollectionFolder:
      begin
        TDataStorage.Initialize;
        Albums := GlobalContainer.Resolve<IPhotoAlbumCollection>;
        Albums.LoadAlbumList;
      end;
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
