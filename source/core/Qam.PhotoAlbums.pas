unit Qam.PhotoAlbums;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, System.StrUtils, System.JSON,
  Generics.Collections,
  Neon.Core.Persistence, Neon.Core.Persistence.JSON, Neon.Core.Attributes,
  Spring, Spring.Collections, Spring.Container;

type
  TPhotoAlbum = class(TPersistent)
  private
    FFilenames: TStringList;
    FModified: Boolean;
    FName: String;
    FFilename: String;
    function GetFilename: String;
    procedure SetName(const AValue: String);
    procedure SetFilenames(const AValue: TStringList);
    procedure FilenamesChange(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    [NeonIgnore]
    property Filename: String read GetFilename write FFilename;
    [NeonIgnore]
    property Modified: Boolean read FModified write FModified;
  published
    property Name: String read FName write SetName;
    property Filenames: TStringList read FFilenames write SetFilenames;
  end;

  IPhotoAlbumCollection = interface
    ['{EE14A9A1-CFC1-4442-8921-39DE79818D52}']
    function GetAlbums: IList<TPhotoAlbum>;
    property Albums: IList<TPhotoAlbum> read GetAlbums;
    procedure LoadAlbumList;
    procedure SaveAlbumList;
  end;

  TPhotoAlbumCollection = class(TInterfacedObject, IPhotoAlbumCollection)
  private
    FList: IList<TPhotoAlbum>;
    function GetAlbums: IList<TPhotoAlbum>;
    procedure AddDefaultAlbum;
  public
    constructor Create;
    property Albums: IList<TPhotoAlbum> read GetAlbums;
    procedure LoadAlbumList;
    procedure SaveAlbumList;
  end;

implementation

uses
  Qodelib.IOUtils,
  Qam.Settings;

type
  TPhotoAlbumHelper = class
  private
    class function CompactFilename(const AFilename, ABasePath: String): String;
    class function ExpandFilename(const AFilename, ABasePath: String): String;
  public
    class function CompactFotoFilename(const AFilename: String): String;
    class function ExpandFotoFilename(const AFilename: String): String;
    class function CompactAlbumFilename(const AFilename: String): String;
    class function ExpandAlbumFilename(const AFilename: String): String;
    class function CreateUniqueFilename: String;
  end;

{ TPhotoAlbum }

constructor TPhotoAlbum.Create;
begin
  inherited Create;
  FFilenames := TStringList.Create;
  FFilenames.Sorted := true;
  FFilenames.Duplicates := dupIgnore;
  FFilenames.OnChange := FilenamesChange;
  Modified := true;
end;

destructor TPhotoAlbum.Destroy;
begin
  FFilenames.Free;
  inherited;
end;

procedure TPhotoAlbum.FilenamesChange(Sender: TObject);
begin
  Modified := true;
end;

function TPhotoAlbum.GetFilename: String;
begin
  if FFilename = '' then
    FFilename := TPath.Combine(ApplicationSettings.DataFoldername, TPhotoAlbumHelper.CreateUniqueFilename);
  Result := FFilename;
end;

procedure TPhotoAlbum.SetFilenames(const AValue: TStringList);
begin
  FFilenames := AValue;
  Modified := false;
end;

procedure TPhotoAlbum.SetName(const AValue: String);
begin
  FName := AValue;
  Modified := true;
end;

{ TPhotoAlbumCollection }

procedure TPhotoAlbumCollection.AddDefaultAlbum;
var
  Album: TPhotoAlbum;
begin
  Album := TPhotoAlbum.Create;
  Album.Name := 'Mein Album';
  Albums.Add(Album);
end;

constructor TPhotoAlbumCollection.Create;
begin
  inherited Create;
  FList := TCollections.CreateObjectList<TPhotoAlbum>;
end;

function TPhotoAlbumCollection.GetAlbums: IList<TPhotoAlbum>;
begin
  Result := FList;
end;

procedure TPhotoAlbumCollection.LoadAlbumList;
var
  Album: TPhotoAlbum;
  Files: TStringDynArray;
  Filename: String;
  JSON: TJSONValue;
  Strings: TStringList;
begin
  FList.Clear;

  Files := TDirectoryHelper.GetFiles(ApplicationSettings.DataFoldername, '*.qta');
  for Filename in Files do
    begin
      Album := TPhotoAlbum.Create;
      if FileExists(Filename) then
        begin
          Strings := TStringList.Create;
          Strings.LoadFromFile(Filename);
          JSON := TJSONObject.ParseJSONValue(Strings.Text);
          TNeon.JSONToObject(Album, JSON, TNeonConfiguration.Default);
          JSON.Free;
          Strings.Free;
        end;
      Album.Filename := Filename;
      Albums.Add(Album);
      Album.Modified := false;
    end;

  if Albums.Count = 0 then
    AddDefaultAlbum;
end;

procedure TPhotoAlbumCollection.SaveAlbumList;
var
  Album: TPhotoAlbum;
var
  JSON: TJSONValue;
  Stream: TFileStream;
begin
  for Album in Albums do
    if Album.Modified then
      begin
        JSON := TNeon.ObjectToJSON(Album);
        Stream := TFileStream.Create(Album.Filename, fmCreate);
        TNeon.PrintToStream(JSON, Stream, true);
        Stream.Free;
        JSON.Free;
        Album.Modified := false;
      end;
end;

{ TPhotoAlbumHelper }

class function TPhotoAlbumHelper.CompactAlbumFilename(
  const AFilename: String): String;
begin
  Result := CompactFilename(AFilename, ApplicationSettings.DataFoldername);
end;

class function TPhotoAlbumHelper.CompactFilename(
  const AFilename, ABasePath: String): String;
var
  BaseFolder: String;
begin
  BaseFolder := IncludeTrailingPathDelimiter(ABasePath);
  Result := AFilename;
  if AnsiCompareText(ABasePath, LeftStr(AFilename, Length(BaseFolder))) = 0 then
    Delete(Result, 1, Length(BaseFolder));
end;

class function TPhotoAlbumHelper.CompactFotoFilename(
  const AFilename: String): String;
begin
  Result := CompactFilename(AFilename, ApplicationSettings.MainCollectionFolder);
end;

class function TPhotoAlbumHelper.CreateUniqueFilename: String;
var
  Uid: TGuid;
begin
  if CreateGuid(Uid) = S_OK then
    Result := GuidToString(Uid) + '.qta'
  else
    Result := '';
end;

class function TPhotoAlbumHelper.ExpandAlbumFilename(
  const AFilename: String): String;
begin
  Result := ExpandFilename(AFilename, ApplicationSettings.DataFoldername);
end;

class function TPhotoAlbumHelper.ExpandFilename(
  const AFilename, ABasePath: String): String;
begin
  if IsRelativePath(AFilename) then
    Result := TPath.Combine(ABasePath, AFilename)
  else
    Result := AFilename;
end;

class function TPhotoAlbumHelper.ExpandFotoFilename(
  const AFilename: String): String;
begin
  Result := ExpandFilename(AFilename, ApplicationSettings.MainCollectionFolder);
end;

initialization
  GlobalContainer.RegisterType<TPhotoAlbumCollection>.Implements<IPhotoAlbumCollection>.AsSingleton;
end.
