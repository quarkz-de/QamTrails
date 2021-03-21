unit Qam.Events;

interface

uses
  EventBus,
  Qam.Settings;

type
  IThemeChangeEvent = interface
    ['{CBB7DC12-0268-4D9A-BEC4-1C6855C2F4F3}']
    function GetThemeName: String;
    function GetIsDark: Boolean;
    property ThemeName: String read GetThemeName;
    property IsDark: Boolean read GetIsDark;
  end;

  ISettingChangeEvent = interface
    ['{E6B7B890-DEFA-4F6B-8A93-91FD1FFE9822}']
    function GetValue: TApplicationSettingValue;
    property Value: TApplicationSettingValue read GetValue;
  end;

  TEventFactory = class
  public
    class function NewThemeChangeEvent(
      const AThemeName: String; const AIsDark: Boolean): IThemeChangeEvent;
    class function NewSettingChangeEvent(
      const AValue: TApplicationSettingValue): ISettingChangeEvent;
  end;

implementation

type
  TThemeChangeEvent = class(TInterfacedObject, IThemeChangeEvent)
  private
    FThemeName: String;
    FIsDark: Boolean;
  protected
    function GetThemeName: String;
    function GetIsDark: Boolean;
  public
    constructor Create(const AThemeName: String; const AIsDark: Boolean);
    property ThemeName: String read GetThemeName;
    property IsDark: Boolean read GetIsDark;
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
