unit Qam.ImageRotate;

interface

uses
  Vcl.Graphics, Vcl.Imaging.jpeg;

type
  TImageRotation = (irLeft, irRight, irUpsideDown);

  TImageRotate = class
  private
    class procedure RotateBitmap(const ABitmap: TBitmap; const ADegrees: Integer);
    class procedure RotateJpeg(const AJpeg: TJpegImage; const ADegrees: Integer);
  public
    class procedure FlipLeft(const ABitmap: TBitmap); overload;
    class procedure FlipLeft(const AJpeg: TJpegImage); overload;
    class procedure FlipRight(const ABitmap: TBitmap); overload;
    class procedure FlipRight(const AJpeg: TJpegImage); overload;
    class procedure FlipUpsideDown(const ABitmap: TBitmap); overload;
    class procedure FlipUpsideDown(const AJpeg: TJpegImage); overload;
    class procedure Flip(const ABitmap: TBitmap; const ARotation: TImageRotation); overload;
    class procedure Flip(const AJpeg: TJpegImage; const ARotation: TImageRotation); overload;
  end;

implementation

uses
  GR32, GR32_Transforms;

type
  TImageRotator = class
  private
    Source, Destination: TBitmap32;
    Transformation: TAffineTransformation;
    procedure RotageBitmap(const ADegrees: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Rotate(const ABitmap: TBitmap; const ADegrees: Integer); overload;
    procedure Rotate(const AJpeg: TJpegImage; const ADegrees: Integer); overload;
  end;

{ TImageRotate }

class procedure TImageRotate.Flip(const ABitmap: TBitmap;
  const ARotation: TImageRotation);
begin
  case ARotation of
    irLeft:
      RotateBitmap(ABitmap, 270);
    irRight:
      RotateBitmap(ABitmap, 900);
    irUpsideDown:
      RotateBitmap(ABitmap, 180);
  end;
end;

class procedure TImageRotate.FlipLeft(const ABitmap: TBitmap);
begin
  RotateBitmap(ABitmap, 270);
end;

class procedure TImageRotate.FlipRight(const ABitmap: TBitmap);
begin
  RotateBitmap(ABitmap, 90);
end;

class procedure TImageRotate.FlipUpsideDown(const ABitmap: TBitmap);
begin
  RotateBitmap(ABitmap, 180);
end;

class procedure TImageRotate.RotateBitmap(const ABitmap: TBitmap;
  const ADegrees: Integer);
var
  Rotator: TImageRotator;
begin
  Rotator := TImageRotator.Create;
  try
    Rotator.Rotate(ABitmap, ADegrees);
  finally
    Rotator.Free;
  end;
end;

class procedure TImageRotate.Flip(const AJpeg: TJpegImage;
  const ARotation: TImageRotation);
begin
  case ARotation of
    irLeft:
      RotateJpeg(AJpeg, 270);
    irRight:
      RotateJpeg(AJpeg, 900);
    irUpsideDown:
      RotateJpeg(AJpeg, 180);
  end;
end;

class procedure TImageRotate.FlipLeft(const AJpeg: TJpegImage);
begin
  RotateJpeg(AJpeg, 270);
end;

class procedure TImageRotate.FlipRight(const AJpeg: TJpegImage);
begin
  RotateJpeg(AJpeg, 9);
end;

class procedure TImageRotate.FlipUpsideDown(const AJpeg: TJpegImage);
begin
  RotateJpeg(AJpeg, 180);
end;

class procedure TImageRotate.RotateJpeg(const AJpeg: TJpegImage;
  const ADegrees: Integer);
var
  Rotator: TImageRotator;
begin
  Rotator := TImageRotator.Create;
  try
    Rotator.Rotate(AJpeg, ADegrees);
  finally
    Rotator.Free;
  end;
end;

{ TImageRotator }

constructor TImageRotator.Create;
begin
  Source := TBitmap32.Create;
  Destination := TBitmap32.Create;
  Transformation := TAffineTransformation.Create;
end;

destructor TImageRotator.Destroy;
begin
  Transformation.Free;
  Source.Free;
  Destination.Free;
  inherited;
end;

procedure TImageRotator.RotageBitmap(const ADegrees: Integer);
var
  TransformedBounds: TFloatRect;
begin
  Transformation.BeginUpdate;
  Transformation.SrcRect := FloatRect(0, 0, Source.Width, Source.Height);
  Transformation.Translate(-0.5 * Source.Width, -0.5 * Source.Height);
  Transformation.Rotate(0, 0, -ADegrees);
  TransformedBounds := Transformation.GetTransformedBounds;
  Destination.SetSize(Round(TransformedBounds.Right - TransformedBounds.Left),
    Round(TransformedBounds.Bottom - TransformedBounds.Top));
  Transformation.Translate(0.5 * Destination.Width, 0.5 * Destination.Height);
  Transformation.EndUpdate;
  Transform(Destination, Source, Transformation);
end;

procedure TImageRotator.Rotate(const ABitmap: TBitmap; const ADegrees: Integer);
begin
  Source.Assign(ABitmap);
  RotageBitmap(ADegrees);
  ABitmap.Assign(Destination);
end;

procedure TImageRotator.Rotate(const AJpeg: TJpegImage;
  const ADegrees: Integer);
var
  Bitmap: TBitmap;
begin
  Source.Assign(AJpeg);
  RotageBitmap(ADegrees);
  Bitmap := TBitmap.Create;
  Bitmap.Assign(Destination);
  AJpeg.Assign(Bitmap);
  Bitmap.Free;
end;

end.
