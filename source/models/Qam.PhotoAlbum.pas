unit Qam.PhotoAlbum;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils,
  Vcl.Graphics,
  Generics.Collections,
  Spring.Collections;

type
  TPhotoItem = class;

  TPhotoItemThumbnail = class
  private
    FBitmap: TBitmap;
    FIsLoaded: Boolean;
    FItem: TPhotoItem;
    function GetBitmap: TBitmap;
  public
    constructor Create(const AItem: TPhotoItem);
    destructor Destroy; override;
    procedure Load; overload;
    procedure Load(const AWidth, AHeight: Integer); overload;
    property IsLoaded: Boolean read FIsLoaded;
    property Bitmap: TBitmap read GetBitmap;
  end;

  TPhotoItem = class
  private
    FFilename: String;
    FTimestamp: TDateTime;
    FThumbnail: TPhotoItemThumbnail;
  public
    constructor Create(const AFilename: String);
    destructor Destroy; override;
    function ExtractFilename: String;
    property Filename: String read FFilename;
    property Timestamp: TDateTime read FTimestamp;
    property Thumbnail: TPhotoItemThumbnail read FThumbnail;
  end;

  TPhotoAlbum = class
  private
    FList: IList<TPhotoItem>;
    FName: String;
    function GetItems(Index: Integer): TPhotoItem;
  public
    constructor Create;
    function Add(const AFilename: String): Integer;
    property List: IList<TPhotoItem> read FList;
    property Name: String read FName write FName;
    property Items[Index: Integer]: TPhotoItem read GetItems; default;
  end;

  TThumbnailThread = class(TThread)
  private
    FThumbnail: TPhotoItemThumbnail;
    FWidth: Integer;
    FHeight: Integer;
    FItemIndex: Integer;
  protected
    procedure Execute; override;
  public
    constructor Create(const AThumbnail: TPhotoItemThumbnail;
      const AWidth, AHeight, AItemIndex: Integer; const AOnTerminate: TNotifyEvent);
    property ItemIndex: Integer read FItemIndex;
  end;

implementation

uses
  Qam.JpegLoader;

{ TPhotoItem }

constructor TPhotoItem.Create(const AFilename: String);
begin
  inherited Create;
  FThumbnail := TPhotoItemThumbnail.Create(self);
  FFilename := AFilename;
  FTimestamp := TFile.GetCreationTime(AFilename);
end;

destructor TPhotoItem.Destroy;
begin
  FThumbnail.Free;
  inherited Destroy;
end;

function TPhotoItem.ExtractFilename: String;
begin
  Result := TPath.GetFileNameWithoutExtension(FFilename);
end;

{ TPhotoAlbum }

function TPhotoAlbum.Add(const AFilename: String): Integer;
begin
  Result := FList.Add(TPhotoItem.Create(AFilename));
end;

constructor TPhotoAlbum.Create;
begin
  inherited Create;
  FList := TCollections.CreateList<TPhotoItem>(true);
  FName := 'unbenanntes Album';
end;

function TPhotoAlbum.GetItems(Index: Integer): TPhotoItem;
begin
  Result := List[Index];
end;

{ TPhotoItemThumbnail }

constructor TPhotoItemThumbnail.Create(const AItem: TPhotoItem);
begin
  inherited Create;
  FItem := AItem;
  FBitmap := TBitmap.Create;
  FIsLoaded := false;
end;

destructor TPhotoItemThumbnail.Destroy;
begin
  FBitmap.Free;
  inherited;
end;

function TPhotoItemThumbnail.GetBitmap: TBitmap;
begin
  if not IsLoaded then
    Load;
  Result := FBitmap;
end;

procedure TPhotoItemThumbnail.Load(const AWidth, AHeight: Integer);
begin
  TJpegLoader.LoadThumb(FItem.Filename, AWidth, AHeight, FBitmap);
  FIsLoaded := true;
end;

procedure TPhotoItemThumbnail.Load;
begin
  Load(80, 60);
end;

{ TThumbnailThread }

constructor TThumbnailThread.Create(const AThumbnail: TPhotoItemThumbnail;
  const AWidth, AHeight, AItemIndex: Integer; const AOnTerminate: TNotifyEvent);
begin
  inherited Create;
  FreeOnTerminate := true;
  FWidth := AWidth;
  FHeight := AHeight;
  FThumbnail := AThumbnail;
  FItemIndex := AItemIndex;
  OnTerminate := AOnTerminate;
end;

procedure TThumbnailThread.Execute;
begin
  FThumbnail.Load(FWidth, FHeight);
end;

end.
