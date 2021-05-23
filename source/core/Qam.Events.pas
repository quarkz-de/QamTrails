unit Qam.Events;

interface

uses
  Qam.Settings, Qam.PhotoAlbums;

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

  IAlbumEvent = interface
    ['{9E183A86-85E2-4B2D-8D3F-146FB110577A}']
    function GetAlbum: TPhotoAlbum;
    property Album: TPhotoAlbum read GetAlbum;
  end;

  IActiveAlbumChangeEvent = interface(IAlbumEvent)
    ['{667CAB13-E01D-4F33-BECE-01D6D6FB20DE}']
  end;

  INewAlbumEvent = interface(IAlbumEvent)
    ['{6314FC2E-8AB9-4703-9F3E-036337E1811B}']
  end;

  IDeleteAlbumEvent = interface(IAlbumEvent)
    ['{E5DD81B7-726D-4210-A217-A699F06F499F}']
  end;

  INewAlbumItemEvent = interface
    ['{84B76126-37EA-4E51-AF42-860813567E8C}']
    function GetAlbum: TPhotoAlbum;
    function GetFilename: String;
    property Album: TPhotoAlbum read GetAlbum;
    property Filename: String read GetFilename;
  end;

  TEventFactory = class
  public
    class function NewSettingChangeEvent(
      const AValue: TApplicationSettingValue): ISettingChangeEvent;
    class function NewThemeChangeEvent(
      const AThemeName: String; const AIsDark: Boolean): IThemeChangeEvent;
    class function NewActiveAlbumChangeEvent(
      const AAlbum: TPhotoAlbum): IActiveAlbumChangeEvent;
    class function NewNewAlbumEvent(
      const AAlbum: TPhotoAlbum): INewAlbumEvent;
    class function NewDeleteAlbumEvent(
      const AAlbum: TPhotoAlbum): IDeleteAlbumEvent;
    class function NewNewAlbumItemEvent(const AAlbum: TPhotoAlbum;
      const AFilename: String): INewAlbumItemEvent;
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

  TAbstractAlbumChangeEvent = class(TInterfacedObject)
  private
    FAlbum: TPhotoAlbum;
  protected
    function GetAlbum: TPhotoAlbum;
  public
    constructor Create(const AAlbum: TPhotoAlbum); virtual;
    property Album: TPhotoAlbum read GetAlbum;
  end;

  TActiveAlbumChangeEvent = class(TAbstractAlbumChangeEvent, IActiveAlbumChangeEvent);

  TNewAlbumEvent = class(TAbstractAlbumChangeEvent, INewAlbumEvent);

  TDeleteAlbumEvent = class(TAbstractAlbumChangeEvent, IDeleteAlbumEvent);

  TNewAlbumItemEvent = class(TInterfacedObject, INewAlbumItemEvent)
  private
    FAlbum: TPhotoAlbum;
    FFilename: String;
  protected
    function GetAlbum: TPhotoAlbum;
    function GetFilename: String;
  public
    constructor Create(const AAlbum: TPhotoAlbum; const AFilename: String);
    property Album: TPhotoAlbum read GetAlbum;
    property Filename: String read GetFilename;
  end;

{ TEventFactory }

class function TEventFactory.NewActiveAlbumChangeEvent(
  const AAlbum: TPhotoAlbum): IActiveAlbumChangeEvent;
begin
  Result := TActiveAlbumChangeEvent.Create(AAlbum);
end;

class function TEventFactory.NewDeleteAlbumEvent(
  const AAlbum: TPhotoAlbum): IDeleteAlbumEvent;
begin
  Result := TDeleteAlbumEvent.Create(AAlbum);
end;

class function TEventFactory.NewNewAlbumEvent(
  const AAlbum: TPhotoAlbum): INewAlbumEvent;
begin
  Result := TNewAlbumEvent.Create(AAlbum);
end;

class function TEventFactory.NewNewAlbumItemEvent(const AAlbum: TPhotoAlbum;
  const AFilename: String): INewAlbumItemEvent;
begin
  Result := TNewAlbumItemEvent.Create(AAlbum, AFilename);
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

{ TAbstractAlbumChangeEvent }

constructor TAbstractAlbumChangeEvent.Create(const AAlbum: TPhotoAlbum);
begin
  inherited Create;
  FAlbum := AAlbum;
end;

function TAbstractAlbumChangeEvent.GetAlbum: TPhotoAlbum;
begin
  Result := FAlbum;
end;

{ TNewAlbumItemEvent }

constructor TNewAlbumItemEvent.Create(const AAlbum: TPhotoAlbum;
  const AFilename: String);
begin
  inherited Create;
  FAlbum := AAlbum;
  FFilename := AFilename;
end;

function TNewAlbumItemEvent.GetAlbum: TPhotoAlbum;
begin
  Result := FAlbum;
end;

function TNewAlbumItemEvent.GetFilename: String;
begin
  Result := FFilename;
end;

end.
