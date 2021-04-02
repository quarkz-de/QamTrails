unit Qam.JpegLoader;

interface

uses
  Classes, Graphics,
  GR32;

type
  TJpegLoader = class
  private
    class function LoadJpeg(const AFilename: String): TBitmap;
  public
    class function Load(const AFilename: String; const ABitmap: TBitmap): Boolean; overload;
    class function Load(const AFilename: String; const ABitmap: TBitmap32): Boolean; overload;
  end;

implementation

uses
  System.IOUtils,
  jpegdec;

{ TJpegLoader }

class function TJpegLoader.Load(const AFilename: String;
  const ABitmap: TBitmap): Boolean;
var
  Bitmap: TBitmap;
begin
  Bitmap := LoadJpeg(AFilename);
  Result := Assigned(Bitmap);
  if Result then
    begin
      try
        ABitmap.Assign(Bitmap);
      finally
        Bitmap.Free;
      end;
    end;
end;

class function TJpegLoader.Load(const AFilename: String;
  const ABitmap: TBitmap32): Boolean;
var
  Bitmap: TBitmap;
begin
  Bitmap := LoadJpeg(AFilename);
  Result := Assigned(Bitmap);
  if Result then
    begin
      try
        ABitmap.Assign(Bitmap);
      finally
        Bitmap.Free;
      end;
    end;
end;

class function TJpegLoader.LoadJpeg(const AFilename: String): TBitmap;
var
  Stream: TMemoryStream;
begin
  Result := nil;
  if TFile.Exists(AFilename) then
    begin
      Stream := TMemoryStream.Create;
      try
        Stream.LoadFromFile(AFilename);
        Result := JpegDecode(Stream.Memory, Stream.Size);
      finally
        Stream.Free;
      end;
    end;
end;

end.
