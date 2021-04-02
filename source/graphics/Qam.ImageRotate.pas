unit Qam.ImageRotate;

interface

uses
  Vcl.Graphics;

type
  TImageRotate = class
  private
    class procedure RotateBitmap(const ABitmap: TBitmap; const ADegrees: Integer);
  public
    class procedure FlipLeft(const ABitmap: TBitmap);
    class procedure FlipRight(const ABitmap: TBitmap);
    class procedure FlipUpsideDown(const ABitmap: TBitmap);
  end;

implementation

uses
  GR32, GR32_Transforms;

{ TImageRotate }

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
  Source, Destination: TBitmap32;
  Transformation: TAffineTransformation;
  TransformedBounds: TFloatRect;
begin
  Source := TBitmap32.Create;
  Destination := TBitmap32.Create;
  Transformation := TAffineTransformation.Create;
  try
    Source.Assign(ABitmap);
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
    ABitmap.Assign(Destination);
  finally
    Transformation.Free;
    Source.Free;
    Destination.Free;
  end;
end;

end.
