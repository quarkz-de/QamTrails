unit Qam.PhotoAlbums;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, System.StrUtils, System.JSON,
  Generics.Collections,
  Neon.Core.Persistence, Neon.Core.Persistence.JSON, Neon.Core.Attributes,
  Spring, Spring.Collections, Spring.Container;

type
  TPhotoAlbumFilelist = class(TStringList)
  protected
    function Get(Index: Integer): string; override;
    procedure Put(Index: Integer; const S: string); override;
  public
    function AddObject(const S: string; AObject: TObject): Integer; override;
    function IndexOf(const S: string): Integer; override;
  end;

  TPhotoAlbum = class(TPersistent)
  private
    FFilenames: TPhotoAlbumFilelist;
    FModified: Boolean;
    FName: String;
    FFilename: String;
    function GetFilename: String;
    procedure SetName(const AValue: String);
    procedure SetFilenames(const AValue: TPhotoAlbumFilelist);
    procedure FilenamesChange(Sender: TObject);
  public
    constructor Create; overload;
    constructor Create(const AFilename: String); overload;
    destructor Destroy; override;
    procedure LoadFromFile;
    procedure SaveToFile;
    [NeonIgnore]
    property Filename: String read GetFilename write FFilename;
    [NeonIgnore]
    property Modified: Boolean read FModified write FModified;
  published
    property Name: String read FName write SetName;
    property Filenames: TPhotoAlbumFilelist read FFilenames write SetFilenames;
  end;

  IPhotoAlbumCollection = interface
    ['{EE14A9A1-CFC1-4442-8921-39DE79818D52}']
    function GetAlbums: IList<TPhotoAlbum>;
    property Albums: IList<TPhotoAlbum> read GetAlbums;
    procedure LoadAlbumList;
    procedure SaveAlbumList;
    procedure SortAlbumList;
    procedure DeleteAlbum(const AAlbum: TPhotoAlbum);
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
    procedure SortAlbumList;
    procedure DeleteAlbum(const AAlbum: TPhotoAlbum);
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

function CompareAlbumByName(const Left, Right: TPhotoAlbum): Integer;
begin
  Result := AnsiCompareStr(Left.Name, Right.Name);
end;

{ TPhotoAlbum }

constructor TPhotoAlbum.Create;
begin
  inherited Create;
  FFilenames := TPhotoAlbumFilelist.Create;
  FFilenames.Sorted := true;
  FFilenames.Duplicates := dupIgnore;
  FFilenames.OnChange := FilenamesChange;
  Modified := true;
end;

constructor TPhotoAlbum.Create(const AFilename: String);
begin
  Create;
  FFilename := AFilename;
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
    Result := TPath.Combine(ApplicationSettings.DataFoldername, TPhotoAlbumHelper.CreateUniqueFilename)
  else
    Result := FFilename;
end;

procedure TPhotoAlbum.LoadFromFile;
var
  JSON: TJSONValue;
  Strings: TStringList;
begin
  if FileExists(Filename) then
    begin
      Strings := TStringList.Create;
      try
        Strings.LoadFromFile(Filename);
        try
          JSON := TJSONObject.ParseJSONValue(Strings.Text);
          try
            TNeon.JSONToObject(self, JSON, TNeonConfiguration.Default);
            Modified := false;
          finally
            JSON.Free;
          end;
        finally

        end;
      finally
        Strings.Free;
      end;
    end;
end;

procedure TPhotoAlbum.SaveToFile;
var
  JSON: TJSONValue;
  Stream: TFileStream;
begin
  JSON := TNeon.ObjectToJSON(self);
  try
    Stream := TFileStream.Create(Filename, fmCreate);
    try
      TNeon.PrintToStream(JSON, Stream, true);
      Modified := false;
    finally
      Stream.Free;
    end;
  finally
    JSON.Free;
  end;
end;

procedure TPhotoAlbum.SetFilenames(const AValue: TPhotoAlbumFilelist);
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

procedure TPhotoAlbumCollection.DeleteAlbum(const AAlbum: TPhotoAlbum);
var
  Index: Integer;
begin
  if TFile.Exists(AAlbum.Filename) then
    TFile.Delete(AAlbum.Filename);
  Index := FList.IndexOf(AAlbum);
  if Index > -1 then
    FList.Delete(Index);
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
begin
  FList.Clear;

  Files := TDirectoryHelper.GetFiles(ApplicationSettings.DataFoldername, '*.qta');
  for Filename in Files do
    begin
      Album := TPhotoAlbum.Create(Filename);
      Album.LoadFromFile;
      Albums.Add(Album);
    end;

  if Albums.Count = 0 then
    AddDefaultAlbum;

  SortAlbumList;
end;

procedure TPhotoAlbumCollection.SaveAlbumList;
var
  Album: TPhotoAlbum;
begin
  for Album in Albums do
    if Album.Modified then
      Album.SaveToFile;
end;

procedure TPhotoAlbumCollection.SortAlbumList;
begin
  Albums.Sort(CompareAlbumByName);
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
  if AnsiCompareText(BaseFolder, LeftStr(AFilename, Length(BaseFolder))) = 0 then
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

{ TPhotoAlbumFilelist }

function TPhotoAlbumFilelist.AddObject(const S: string;
  AObject: TObject): Integer;
begin
  Result := inherited AddObject(TPhotoAlbumHelper.CompactFotoFilename(S), AObject);
end;

function TPhotoAlbumFilelist.Get(Index: Integer): string;
begin
  Result := TPhotoAlbumHelper.ExpandFotoFilename(inherited Get(Index));
end;

function TPhotoAlbumFilelist.IndexOf(const S: string): Integer;
begin
  Result := inherited IndexOf(TPhotoAlbumHelper.CompactFotoFilename(S));
end;

procedure TPhotoAlbumFilelist.Put(Index: Integer; const S: string);
begin
  inherited Put(Index, TPhotoAlbumHelper.CompactFotoFilename(S));
end;

initialization
  GlobalContainer.RegisterType<TPhotoAlbumCollection>.Implements<IPhotoAlbumCollection>.AsSingleton;
end.
