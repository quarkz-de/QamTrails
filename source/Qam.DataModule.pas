unit Qam.DataModule;

interface

uses
  System.SysUtils, System.Classes,
  Vcl.BaseImageCollection, Vcl.ImageCollection,
  EventBus,
  Qodelib.Themes;

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
  end;

var
  dmCommon: TdmCommon;

implementation

uses
  Spring.Container,
  Qam.Events, Qam.Settings;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdmCommon.DataModuleCreate(Sender: TObject);
begin
  QuarkzThemeManager.OnChange := ThemeChangeEvent;
  ApplicationSettings.LoadSettings;
  ThemeChanged;
end;

procedure TdmCommon.DataModuleDestroy(Sender: TObject);
begin
  ApplicationSettings.SaveSettings;
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
