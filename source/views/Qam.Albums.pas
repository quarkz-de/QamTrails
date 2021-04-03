unit Qam.Albums;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ControlList,
  Spring.Collections,
  Eventbus,
  Qam.Forms, Qam.Events, Qam.PhotoAlbum;

type
  TwAlbums = class(TApplicationForm)
    clFotos: TControlList;
    txFilename: TLabel;
    procedure clFotosBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas;
      ARect: TRect; AState: TOwnerDrawState);
    procedure FormCreate(Sender: TObject);
  private
    FPhotoAlbumList: IList<TPhotoAlbum>;
    function GetActiveAlbum: TPhotoAlbum;
    procedure ThumbnailThreadCompleteEvent(Sender: TObject);
  public
    property ActiveAlbum: TPhotoAlbum read GetActiveAlbum;
  end;

var
  wAlbums: TwAlbums;

implementation

{$R *.dfm}

procedure TwAlbums.clFotosBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas;
  ARect: TRect; AState: TOwnerDrawState);
begin
  txFilename.Caption := ActiveAlbum[AIndex].ExtractFilename;
  if ActiveAlbum.List[AIndex].Thumbnail.IsLoaded then
    ACanvas.Draw(ARect.Left, ARect.Top, ActiveAlbum[AIndex].Thumbnail.Bitmap)
  else
    TThumbnailThread.Create(ActiveAlbum[AIndex].Thumbnail, (clFotos.ItemHeight * 3) div 2, clFotos.ItemHeight, AIndex,
      ThumbnailThreadCompleteEvent);
end;

procedure TwAlbums.FormCreate(Sender: TObject);
begin
//  GlobalEventBus.RegisterSubscriberForEvents(Self);
  FPhotoAlbumList := TCollections.CreateList<TPhotoAlbum>(true);

  // Proof of concept:
  FPhotoAlbumList.Add(TPhotoAlbum.Create);

  ActiveAlbum.Add('D:\Entw\quarkz.dx\QamTrails\data\Fotos\IMG_20210303_070223975.jpg');
  ActiveAlbum.Add('D:\Entw\quarkz.dx\QamTrails\data\Fotos\IMG_20210327_130644202_HDR.jpg');
  ActiveAlbum.Add('D:\Entw\quarkz.dx\QamTrails\data\Fotos\IMG_20210402_080631073_HDR.jpg');

  clFotos.ItemCount := ActiveAlbum.List.Count;
end;

function TwAlbums.GetActiveAlbum: TPhotoAlbum;
begin
  Result := FPhotoAlbumList[0];
end;

procedure TwAlbums.ThumbnailThreadCompleteEvent(Sender: TObject);
begin
  clFotos.UpdateItem(TThumbnailThread(Sender).ItemIndex);
end;

end.
