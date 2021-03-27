unit Qam.PhotoViewer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.IOUtils,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TfrPhotoViewer = class(TFrame)
    imPhoto: TImage;
  private
  public
    procedure LoadFromFile(const AFilename: String);
  end;

implementation

{$R *.dfm}

uses
  jpegdec;

{ TfrPhotoViewer }

procedure TfrPhotoViewer.LoadFromFile(const AFilename: String);
var
  Bmp: TBitmap;
  Stream: TMemoryStream;
begin
  if TFile.Exists(AFilename) then
    begin
      Stream := TMemoryStream.Create;
      try
        Stream.LoadFromFile(AFilename);
        Bmp := JpegDecode(Stream.Memory, Stream.Size);
        if Bmp <> nil then
          try
            imPhoto.Picture.Bitmap := Bmp;
          finally
            Bmp.Free;
          end;
      finally
        Stream.Free;
      end;
    end;
end;

end.
