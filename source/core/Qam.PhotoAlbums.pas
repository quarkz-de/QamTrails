unit Qam.PhotoAlbums;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, System.StrUtils,
  Generics.Collections,
  Spring, Spring.Collections, Spring.Container;

type
  TPhotoAlbum = class(TObject)
  private
    FFilenames: TStringList;
    FModified: Boolean;
    FName: String;
    FFilename: String;
    function GetItems(Index: Integer): String;
    function GetCount: Integer;
    function GetFilename: String;
    procedure SetName(const AValue: String);
  public
    constructor Create;
    destructor Destroy; override;
    function Add(const AFilename: String): Integer;
    procedure Delete(const AFilename: String); overload;
    procedure Delete(const AIndex: Integer); overload;
    function IndexOf(const AFilename: String): Integer;
    procedure Clear;
    procedure BeginUpdate;
    procedure EndUpdate;
    property Items[Index: Integer]: String read GetItems; default;
    property Count: Integer read GetCount;
    property Name: String read FName write SetName;
    property Filename: String read GetFilename write FFilename;
    property Modified: Boolean read FModified write FModified;
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

const
  SAlbumFileVersion = '#version: ';
  SAlbumName = '#name: ';

type
  TPhotoAlbumSerializer = class
  public
    class procedure Deserialize(const AAlbum: TPhotoAlbum);
    class procedure Serialize(const AAlbum: TPhotoAlbum);
  end;

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

function TPhotoAlbum.Add(const AFilename: String): Integer;
begin
  Result := FFilenames.Add(AFilename);
  Modified := true;
end;

procedure TPhotoAlbum.BeginUpdate;
begin
  FFilenames.BeginUpdate;
end;

procedure TPhotoAlbum.Clear;
begin
  FFilenames.Clear;
  Modified := true;
end;

constructor TPhotoAlbum.Create;
begin
  inherited Create;
  FFilenames := TStringList.Create;
  FFilenames.Sorted := true;
  FFilenames.Duplicates := dupIgnore;
  Modified := true;
end;

procedure TPhotoAlbum.Delete(const AIndex: Integer);
begin
  FFilenames.Delete(AIndex);
  Modified := true;
end;

procedure TPhotoAlbum.Delete(const AFilename: String);
begin
  FFilenames.Delete(IndexOf(AFilename));
  Modified := true;
end;

destructor TPhotoAlbum.Destroy;
begin
  FFilenames.Free;
  inherited;
end;

procedure TPhotoAlbum.EndUpdate;
begin
  FFilenames.EndUpdate;
end;

function TPhotoAlbum.GetCount: Integer;
begin
  Result := FFilenames.Count;
end;

function TPhotoAlbum.GetFilename: String;
begin
  if FFilename = '' then
    FFilename := TPath.Combine(ApplicationSettings.DataFoldername, TPhotoAlbumHelper.CreateUniqueFilename);
  Result := FFilename;
end;

function TPhotoAlbum.GetItems(Index: Integer): String;
begin
  Result := FFilenames[Index];
end;

function TPhotoAlbum.IndexOf(const AFilename: String): Integer;
begin
  Result := FFilenames.IndexOf(AFilename);
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
begin
  FList.Clear;

  Files := TDirectoryHelper.GetFiles(ApplicationSettings.DataFoldername, '*.qta');
  for Filename in Files do
    begin
      Album := TPhotoAlbum.Create;
      Album.Filename := Filename;
      TPhotoAlbumSerializer.Deserialize(Album);
      Albums.Add(Album);
      Album.Modified := false;
    end;

  if Albums.Count = 0 then
    AddDefaultAlbum;
end;

procedure TPhotoAlbumCollection.SaveAlbumList;
var
  Album: TPhotoAlbum;
begin
  for Album in Albums do
    if Album.Modified then
      begin
        TPhotoAlbumSerializer.Serialize(Album);
        Album.Modified := false;
      end;
end;

{ TPhotoAlbumSerializer }

class procedure TPhotoAlbumSerializer.Deserialize(const AAlbum: TPhotoAlbum);
var
  Filelist: TStringList;
  Line, Filename: String;
begin
  AAlbum.BeginUpdate;
  AAlbum.Clear;

  if TFile.Exists(AAlbum.Filename) then
    begin
      Filelist := TStringList.Create;
      Filelist.LoadFromFile(AAlbum.Filename);

      for Line in Filelist do
        begin
          if StartsText(SAlbumName, Line) then
            begin
              AAlbum.Name := Copy(Line, Length(SAlbumname) + 1, Length(Line) - Length(SAlbumname));
            end
          else if not StartsText('#', Line) then
            begin
              Filename := TPhotoAlbumHelper.ExpandFotoFilename(Line);
              if TFile.Exists(Filename) then
                AAlbum.Add(Filename);
            end;
        end;

      Filelist.Free;
    end;

  AAlbum.EndUpdate;
end;

class procedure TPhotoAlbumSerializer.Serialize(const AAlbum: TPhotoAlbum);
var
  Filelist: TStringList;
  I: Integer;
begin
  Filelist := TStringList.Create;
  Filelist.BeginUpdate;

  Filelist.Add(SAlbumFileVersion + '1');
  Filelist.Add(SAlbumName + AAlbum.Name);

  for I := 0 to AAlbum.Count - 1 do
    Filelist.Add(TPhotoAlbumHelper.CompactFotoFilename(AAlbum[I]));

  Filelist.EndUpdate;
  Filelist.SaveToFile(AAlbum.Filename);
  Filelist.Free;
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
