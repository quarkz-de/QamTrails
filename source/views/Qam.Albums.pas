unit Qam.Albums;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.ImageList,
  System.Actions,
  Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ControlList, Vcl.ToolWin, Vcl.ComCtrls, Vcl.ImgList,
  Vcl.VirtualImageList, Vcl.ActnList,
  Eventbus,
  VirtualTrees,
  Qam.Forms, Qam.Events, Qam.PhotoAlbum, Qam.AlbumsVisualizer;

type
  TwAlbums = class(TApplicationForm)
    clFotos: TControlList;
    txFilename: TLabel;
    btEdit: TControlListButton;
    btDelete: TControlListButton;
    stAlbums: TVirtualStringTree;
    spSplitter: TSplitter;
    tbToolbar: TToolBar;
    vilIcons: TVirtualImageList;
    alActions: TActionList;
    ToolButton1: TToolButton;
    acNewAlbum: TAction;
    procedure acNewAlbumExecute(Sender: TObject);
    procedure clFotosBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas;
      ARect: TRect; AState: TOwnerDrawState);
    procedure clFotosShowControl(const AIndex: Integer; AControl: TControl; var
        AVisible: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure stAlbumsFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode;
        Column: TColumnIndex);
  private
    FAlbumVisualizer: IPhotoAlbumTreeVisualizer;
    function GetActiveAlbum: TPhotoAlbum;
    procedure ThumbnailThreadCompleteEvent(Sender: TObject);
    procedure LoadAlbums;
    procedure AlbumChanged;
  public
    property ActiveAlbum: TPhotoAlbum read GetActiveAlbum;
    [Subscribe]
    procedure OnThemeChange(AEvent: IThemeChangeEvent);
    [Subscribe]
    procedure OnDatabaseLoad(AEvent: IDatabaseLoadEvent);
    [Subscribe]
    procedure OnNewAlbum(AEvent: INewAlbumEvent);
  end;

var
  wAlbums: TwAlbums;

implementation

{$R *.dfm}

uses
  Spring.Container, Spring.Collections,
  Qam.DataModule;

procedure TwAlbums.acNewAlbumExecute(Sender: TObject);
begin
  FAlbumVisualizer.NewAlbum;
end;

procedure TwAlbums.AlbumChanged;
var
  Fotos: IList<TPhotoItem>;
begin
  Fotos := ActiveAlbum.Photos;
  clFotos.ItemCount := Fotos.Count;
end;

procedure TwAlbums.clFotosBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas;
  ARect: TRect; AState: TOwnerDrawState);
var
  Fotos: IList<TPhotoItem>;
begin
  Fotos := ActiveAlbum.Photos;

  if AIndex >= Fotos.Count then
    Exit;

  txFilename.Caption := Fotos[AIndex].ExtractFilename;
  if Fotos[AIndex].Thumbnail.IsLoaded then
    ACanvas.Draw(ARect.Left, ARect.Top, Fotos[AIndex].Thumbnail.Bitmap)
  else
    TThumbnailThread.Create(Fotos[AIndex].Thumbnail,
      (clFotos.ItemHeight * 3) div 2, clFotos.ItemHeight, AIndex,
      ThumbnailThreadCompleteEvent);
end;

procedure TwAlbums.clFotosShowControl(const AIndex: Integer;
  AControl: TControl; var AVisible: Boolean);
begin
  if AControl is TControlListButton then
    AVisible := (AIndex = clFotos.HotItemIndex);
end;

procedure TwAlbums.FormCreate(Sender: TObject);
begin
  GlobalEventBus.RegisterSubscriberForEvents(Self);
  FAlbumVisualizer := GlobalContainer.Resolve<IPhotoAlbumTreeVisualizer>;
  FAlbumVisualizer.SetVirtualTree(stAlbums);
  LoadAlbums;
end;

function TwAlbums.GetActiveAlbum: TPhotoAlbum;
begin
  Result := FAlbumVisualizer.GetSelectedAlbum;
end;

procedure TwAlbums.LoadAlbums;
var
  Albums: IList<TPhotoAlbum>;
begin
  Albums := dmCommon.Database.GetSession.FindAll<TPhotoAlbum>();
  FAlbumVisualizer.SetPhotoAlbums(Albums);
  FAlbumVisualizer.UpdateContent;
end;

procedure TwAlbums.OnDatabaseLoad(AEvent: IDatabaseLoadEvent);
begin
  LoadAlbums;
end;

procedure TwAlbums.OnNewAlbum(AEvent: INewAlbumEvent);
begin
  FAlbumVisualizer.AddAlbum(AEvent.Album);
end;

procedure TwAlbums.OnThemeChange(AEvent: IThemeChangeEvent);
begin
  vilIcons.ImageCollection := dmCommon.GetImageCollection;
end;

procedure TwAlbums.stAlbumsFocusChanged(Sender: TBaseVirtualTree; Node:
    PVirtualNode; Column: TColumnIndex);
begin
  AlbumChanged;
end;

procedure TwAlbums.ThumbnailThreadCompleteEvent(Sender: TObject);
begin
  clFotos.UpdateItem(TThumbnailThread(Sender).ItemIndex);
end;

end.
