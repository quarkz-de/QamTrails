unit Qam.Events;

interface

uses
  EventBus,
  Qam.Settings;

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

  TEventFactory = class
  public
    class function NewSettingChangeEvent(
      const AValue: TApplicationSettingValue): ISettingChangeEvent;
    class function NewThemeChangeEvent(
      const AThemeName: String; const AIsDark: Boolean): IThemeChangeEvent;
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

{ TEventFactory }

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

end.
