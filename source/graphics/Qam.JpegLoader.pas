unit Qam.JpegLoader;

interface

uses
  System.SysUtils, System.Classes,
  Winapi.Windows,
  Vcl.Graphics,
  GR32;

type
  TJpegLoader = class
  private
    class function LoadJpeg(const AFilename: String): TBitmap;
  public
    class function Load(const AFilename: String; const ABitmap: TBitmap): Boolean; overload;
    class function Load(const AFilename: String; const ABitmap: TBitmap32): Boolean; overload;
    class function LoadThumbnail(const AFilename: String; const AWidth, AHeight: Integer;
      const ABitmap: TBitmap): Boolean; overload;
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

class function TJpegLoader.LoadThumbnail(const AFilename: String; const AWidth,
  AHeight: Integer; const ABitmap: TBitmap): Boolean;
var
  Source, Destination: TBitmap32;
  Ratio: Single;
begin
  Source := TBitmap32.Create;
  Destination := TBitmap32.Create;
  try
    if Load(AFilename, Source) then
      begin
        if Source.Height > Source.Width then
          begin
            Ratio := Source.Width / Source.Height;
            Destination.SetSize(Round(AHeight * Ratio), Round(AWidth * Ratio))
          end
        else
          begin
            Ratio := Source.Height / Source.Width;
            Destination.SetSize(Round(AWidth * Ratio), Round(AHeight * Ratio));
          end;
        Source.DrawTo(Destination, Destination.BoundsRect);
        ABitmap.Assign(Destination);
        Result := true;
      end
    else
      Result := false;
  finally
    Source.Free;
    Destination.Free;
  end;
end;


end.
