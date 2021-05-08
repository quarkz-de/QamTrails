unit Qam.Events;

interface

uses
  Qam.Settings, Qam.Database, Qam.PhotoAlbum;

type
  IThemeChangeEvent = interface
    ['{CBB7DC12-0268-4D9A-BEC4-1C6855C2F4F3}']
    function GetIsDark: Boolean;
    function GetIsWindows: Boolean;
    function GetThemeName: String;
    property IsDark: Boolean read GetIsDark;
    property IsWindows: Boolean read GetIsWindows;
    property ThemeName: String read GetThemeName;
  end;

  ISettingChangeEvent = interface
    ['{E6B7B890-DEFA-4F6B-8A93-91FD1FFE9822}']
    function GetValue: TApplicationSettingValue;
    property Value: TApplicationSettingValue read GetValue;
  end;

  IDatabaseLoadEvent = interface
    ['{809E5E24-788C-45E4-A094-F6DA49455487}']
    function GetDatabase: IQamTrailsDatabase;
    property Database: IQamTrailsDatabase read GetDatabase;
  end;

  IActiveAlbumChangeEvent = interface
    ['{893EB4AD-D972-4E91-B480-A6E44965F1A8}']
    function GetAlbum: TPhotoAlbum;
    property Album: TPhotoAlbum read GetAlbum;
  end;

  INewAlbumEvent = interface
    ['{B27A31A7-C403-4557-88DA-1F2E207140A3}']
    function GetAlbum: TPhotoAlbum;
    property Album: TPhotoAlbum read GetAlbum;
  end;

  TEventFactory = class
  public
    class function NewSettingChangeEvent(
      const AValue: TApplicationSettingValue): ISettingChangeEvent;
    class function NewThemeChangeEvent(
      const AThemeName: String; const AIsDark: Boolean): IThemeChangeEvent;
    class function NewDatabaseLoadEvent(
      const ADatabase: IQamTrailsDatabase): IDatabaseLoadEvent;
    class function NewActiveAlbumChangeEvent(
      const AAlbum: TPhotoAlbum): IActiveAlbumChangeEvent;
    class function NewNewAlbumEvent(
      const AAlbum: TPhotoAlbum): INewAlbumEvent;
  end;

implementation

type
  TThemeChangeEvent = class(TInterfacedObject, IThemeChangeEvent)
  private
    FIsDark: Boolean;
    FThemeName: String;
  protected
    function GetIsDark: Boolean;
    function GetIsWindows: Boolean;
    function GetThemeName: String;
  public
    constructor Create(const AThemeName: String; const AIsDark: Boolean);
    property IsDark: Boolean read GetIsDark;
    property IsWindows: Boolean read GetIsWindows;
    property ThemeName: String read GetThemeName;
  end;

  TSettingChangeEvent = class(TInterfacedObject, ISettingChangeEvent)
  private
    FValue: TApplicationSettingValue;
  protected
    function GetValue: TApplicationSettingValue;
  public
    constructor Create(const AValue: TApplicationSettingValue);
    property Value: TApplicationSettingValue read GetValue;
  end;

  TDatabaseLoadEvent = class(TInterfacedObject, IDatabaseLoadEvent)
  private
    FDatabase: IQamTrailsDatabase;
  protected
    function GetDatabase: IQamTrailsDatabase;
  public
    constructor Create(const ADatabase: IQamTrailsDatabase);
    property Database: IQamTrailsDatabase read GetDatabase;
  end;

  TActiveAlbumChangeEvent = class(TInterfacedObject, IActiveAlbumChangeEvent)
  private
    FAlbum: TPhotoAlbum;
  protected
    function GetAlbum: TPhotoAlbum;
  public
    constructor Create(const AAlbum: TPhotoAlbum);
    property Album: TPhotoAlbum read GetAlbum;
  end;

  TNewAlbumEvent = class(TInterfacedObject, INewAlbumEvent)
  private
    FAlbum: TPhotoAlbum;
  protected
    function GetAlbum: TPhotoAlbum;
  public
    constructor Create(const AAlbum: TPhotoAlbum);
    property Album: TPhotoAlbum read GetAlbum;
  end;

{ TEventFactory }

class function TEventFactory.NewActiveAlbumChangeEvent(
  const AAlbum: TPhotoAlbum): IActiveAlbumChangeEvent;
begin
  Result := TActiveAlbumChangeEvent.Create(AAlbum);
end;

class function TEventFactory.NewDatabaseLoadEvent(
  const ADatabase: IQamTrailsDatabase): IDatabaseLoadEvent;
begin
  Result := TDatabaseLoadEvent.Create(ADatabase);
end;

class function TEventFactory.NewNewAlbumEvent(
  const AAlbum: TPhotoAlbum): INewAlbumEvent;
begin
  Result := TNewAlbumEvent.Create(AAlbum);
end;

class function TEventFactory.NewSettingChangeEvent(
  const AValue: TApplicationSettingValue): ISettingChangeEvent;
begin
  Result := TSettingChangeEvent.Create(AValue);
end;

class function TEventFactory.NewThemeChangeEvent(const AThemeName: String;
  const AIsDark: Boolean): IThemeChangeEvent;
begin
  Result := TThemeChangeEvent.Create(AThemeName, AIsDark);
end;

{ TThemeChangeEvent }

constructor TThemeChangeEvent.Create(const AThemeName: String;
  const AIsDark: Boolean);
begin
  inherited Create;
  FThemeName := AThemeName;
  FIsDark := AIsDark;
end;

function TThemeChangeEvent.GetIsDark: Boolean;
begin
  Result := FIsDark;
end;

function TThemeChangeEvent.GetIsWindows: Boolean;
begin
  Result := ThemeName = 'Windows';
end;

function TThemeChangeEvent.GetThemeName: String;
begin
  Result := FThemeName;
end;

{ TSettingChangeEvent }

constructor TSettingChangeEvent.Create(const AValue: TApplicationSettingValue);
begin
  inherited Create;
  FValue := AValue;
end;

function TSettingChangeEvent.GetValue: TApplicationSettingValue;
begin
  Result := FValue;
end;

{ TDatabaseLoadEvent }

constructor TDatabaseLoadEvent.Create(const ADatabase: IQamTrailsDatabase);
begin
  inherited Create;
  FDatabase := ADatabase;
end;

function TDatabaseLoadEvent.GetDatabase: IQamTrailsDatabase;
begin
  Result := FDatabase;
end;

{ TActiveAlbumChangeEvent }

constructor TActiveAlbumChangeEvent.Create(const AAlbum: TPhotoAlbum);
begin
  inherited Create;
  FAlbum := AAlbum;
end;

function TActiveAlbumChangeEvent.GetAlbum: TPhotoAlbum;
begin
  Result := FAlbum;
end;

{ TNewAlbumEvent }

constructor TNewAlbumEvent.Create(const AAlbum: TPhotoAlbum);
begin
  inherited Create;
  FAlbum := AAlbum;
end;

function TNewAlbumEvent.GetAlbum: TPhotoAlbum;
begin
  Result := FAlbum;
end;

end.
