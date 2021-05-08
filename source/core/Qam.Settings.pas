unit Qam.Settings;

interface

uses
  System.SysUtils, System.Classes,
  Vcl.Forms,
  Qam.Types;

type
  TApplicationFormPosition = class(TPersistent)
  private
    FWindowState: TWindowState;
    FTop: Integer;
    FLeft: Integer;
    FHeight: Integer;
    FWidth: Integer;
  public
    procedure Assign(Source: TPersistent); override;
    procedure LoadPosition(const AForm: TForm);
    procedure SavePosition(const AForm: TForm);
  published
    property WindowState: TWindowState read FWindowState write FWindowState;
    property Top: Integer read FTop write FTop;
    property Left: Integer read FLeft write FLeft;
    property Height: Integer read FHeight write FHeight;
    property Width: Integer read FWidth write FWidth;
  end;

  TApplicationSettingValue = (svMainCollectionFolder, svPhotoCollectionFolderStyle);

  TApplicationSettings = class(TPersistent)
  private
    FDrawerOpened: Boolean;
    FFormPosition: TApplicationFormPosition;
    FMainCollectionFolder: String;
    FActiveCollectionFolder: String;
    FPhotoCollectionFolderStyle: TPhotoCollectionFolderStyle;
    procedure SetTheme(const AValue: String);
    function GetTheme: String;
    function GetSettingsFilename: String;
    function GetSettingsFoldername: String;
    function GetDataFoldername: String;
    procedure SetFormPositon(const Value: TApplicationFormPosition);
    procedure SetMainCollectionFolder(const Value: String);
    procedure SetPhotoCollectionFolderStyle(const Value: TPhotoCollectionFolderStyle);
    procedure ChangeEvent(const AValue: TApplicationSettingValue);
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadSettings;
    procedure SaveSettings;
  published
    property Theme: String read GetTheme write SetTheme;
    property DrawerOpened: Boolean read FDrawerOpened write FDrawerOpened;
    property FormPosition: TApplicationFormPosition read FFormPosition
      write SetFormPositon;
    property MainCollectionFolder: String read FMainCollectionFolder
      write SetMainCollectionFolder;
    property ActiveCollectionFolder: String read FActiveCollectionFolder
      write FActiveCollectionFolder;
    property DataFoldername: String read GetDataFoldername;
    property PhotoCollectionFolderStyle: TPhotoCollectionFolderStyle
      read FPhotoCollectionFolderStyle write SetPhotoCollectionFolderStyle;
  end;

var
  ApplicationSettings: TApplicationSettings;

implementation

uses
  System.IOUtils, System.JSON,
  Neon.Core.Persistence, Neon.Core.Persistence.JSON,
  EventBus,
  Qam.Events,
  Qodelib.Themes, Qodelib.IOUtils;

{ TApplicationSettings }

procedure TApplicationSettings.ChangeEvent(const AValue: TApplicationSettingValue);
begin
  GlobalEventBus.Post(TEventFactory.NewSettingChangeEvent(AValue));
end;

constructor TApplicationSettings.Create;
begin
  inherited Create;
  FFormPosition := TApplicationFormPosition.Create;
  FDrawerOpened := true;
  FMainCollectionFolder := TPath.GetPicturesPath;
  FPhotoCollectionFolderStyle := cfsGrid;
end;

destructor TApplicationSettings.Destroy;
begin
  FormPosition.Free;
  inherited;
end;

function TApplicationSettings.GetDataFoldername: String;
begin
  if MainCollectionFolder <> '' then
    Result := TPath.Combine(MainCollectionFolder, '.QamTrails')
  else
    Result := TPath.Combine(TKnownFolders.GetCommonAppDataPath, 'quarkz.de\QamTrails\Thumbnails');
end;

function TApplicationSettings.GetSettingsFilename: String;
begin
  Result := TPath.Combine(GetSettingsFoldername, 'QamTrails.json');
end;

function TApplicationSettings.GetSettingsFoldername: String;
begin
  if ParamCount > 0 then
    Result := ParamStr(1)
  else
    Result := TPath.Combine(TKnownFolders.GetAppDataPath, 'quarkz.de');
end;

function TApplicationSettings.GetTheme: String;
begin
  Result := QuarkzThemeManager.ThemeName;
end;

procedure TApplicationSettings.LoadSettings;
var
  JSON: TJSONValue;
  Strings: TStringList;
begin
  if FileExists(GetSettingsFilename) then
    begin
      Strings := TStringList.Create;
      Strings.LoadFromFile(GetSettingsFilename);
      JSON := TJSONObject.ParseJSONValue(Strings.Text);
      TNeon.JSONToObject(self, JSON, TNeonConfiguration.Default);
      JSON.Free;
      Strings.Free;
    end;
end;

procedure TApplicationSettings.SaveSettings;
var
  JSON: TJSONValue;
  Stream: TFileStream;
begin
  ForceDirectories(GetSettingsFoldername);
  JSON := TNeon.ObjectToJSON(self);
  Stream := TFileStream.Create(GetSettingsFilename, fmCreate);
  TNeon.PrintToStream(JSON, Stream, true);
  Stream.Free;
  JSON.Free;
end;

procedure TApplicationSettings.SetFormPositon(
  const Value: TApplicationFormPosition);
begin
  FFormPosition.Assign(Value);
end;

procedure TApplicationSettings.SetMainCollectionFolder(const Value: String);
begin
  if FMainCollectionFolder <> Value then
    begin
      FMainCollectionFolder := Value;
      ChangeEvent(svMainCollectionFolder);
    end;
end;

procedure TApplicationSettings.SetPhotoCollectionFolderStyle(
  const Value: TPhotoCollectionFolderStyle);
begin
  if FPhotoCollectionFolderStyle <> Value then
    begin
      FPhotoCollectionFolderStyle := Value;
      ChangeEvent(svPhotoCollectionFolderStyle);
    end;
end;

procedure TApplicationSettings.SetTheme(const AValue: String);
begin
  QuarkzThemeManager.ThemeName := AValue;
end;

{ TApplicationFormPosition }

procedure TApplicationFormPosition.Assign(Source: TPersistent);
begin
  if Source is TApplicationFormPosition then
    begin
      WindowState := TApplicationFormPosition(Source).WindowState;
      Top := TApplicationFormPosition(Source).Top;
      Left := TApplicationFormPosition(Source).Left;
      Height := TApplicationFormPosition(Source).Height;
      Width := TApplicationFormPosition(Source).Width;
    end
  else
    inherited Assign(Source);
end;

procedure TApplicationFormPosition.SavePosition(const AForm: TForm);
begin
  WindowState := AForm.WindowState;
  Top := AForm.Top;
  Left := AForm.Left;
  Height := AForm.Height;
  Width := AForm.Width;
end;

procedure TApplicationFormPosition.LoadPosition(const AForm: TForm);
begin
  if (Width > 0) and (Height > 0) then
  begin
    AForm.WindowState := WindowState;
    AForm.Top := Top;
    AForm.Left := Left;
    AForm.Height := Height;
    AForm.Width := Width;
  end;
end;

initialization
  ApplicationSettings := TApplicationSettings.Create;

finalization
  FreeAndNil(ApplicationSettings);

end.

