unit Qam.PhotoViewer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  GR32_Image;

type
  TfrPhotoViewer = class(TFrame)
    imPhoto: TImgView32;
    procedure imPhotoClick(Sender: TObject);
  private
  public
    procedure LoadFromFile(const AFilename: String);
  end;

implementation

{$R *.dfm}

uses
  Qam.JpegLoader, Qam.ImageRotate;

procedure TfrPhotoViewer.imPhotoClick(Sender: TObject);
var
  Bmp: TBitmap;
begin
  Bmp := TBitmap.Create;
  Bmp.Assign(imPhoto.Bitmap);
  TImageRotate.FlipLeft(Bmp);
  imPhoto.Bitmap.Assign(Bmp);
  Bmp.Free;
end;

{ TfrPhotoViewer }

procedure TfrPhotoViewer.LoadFromFile(const AFilename: String);
begin
  if not TJpegLoader.Load(AFilename, imPhoto.Bitmap) then
    imPhoto.Bitmap.Clear;
end;

end.
