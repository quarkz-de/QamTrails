unit Qam.Types;

interface

uses
  System.Classes;

type
  TPhotoCollectionFolderStyle = (cfsGrid, cfsPreview, cfsDetails);

  TPhotoCollectionFolderStyleHelper = record helper for TPhotoCollectionFolderStyle
  public
    class function Create(const Value: Integer): TPhotoCollectionFolderStyle; static; inline;
    class procedure AssignStrings(const AStrings: TStrings); static; inline;
    function ToInteger: Integer; inline;
    function ToString: String; inline;
  end;

implementation

const
  cfsiGrid = 0;
  cfsiPreview = 1;
  cfsiDetails = 2;

{ TPhotoCollectionFolderStyleHelper }

class procedure TPhotoCollectionFolderStyleHelper.AssignStrings(
  const AStrings: TStrings);
var
  Style: TPhotoCollectionFolderStyle;
begin
  AStrings.Clear;
  for Style := Low(TPhotoCollectionFolderStyle) to High(TPhotoCollectionFolderStyle) do
    AStrings.Add(Style.ToString);
end;

class function TPhotoCollectionFolderStyleHelper.Create(
  const Value: Integer): TPhotoCollectionFolderStyle;
begin
  case Value of
    cfsiGrid:
      Result := cfsGrid;
    cfsiPreview:
      Result := cfsPreview;
    cfsiDetails:
      Result := cfsDetails;
    else
      Result := cfsGrid;
  end;
end;

function TPhotoCollectionFolderStyleHelper.ToInteger: Integer;
begin
  case self of
    cfsGrid:
      Result := cfsiGrid;
    cfsPreview:
      Result := cfsiPreview;
    cfsDetails:
      Result := cfsiDetails;
    else
      Result := cfsiGrid;
  end;
end;

function TPhotoCollectionFolderStyleHelper.ToString: String;
const
  SFolderStyleUnknown = '';
  SFolderStyleGrid = 'Raster';
  SFolderStylePreview = 'Vorschau';
  SFolderStyleDetails = 'Details';
begin
  case self of
    cfsGrid:
      Result := SFolderStyleGrid;
    cfsPreview:
      Result := SFolderStylePreview;
    cfsDetails:
      Result := SFolderStyleDetails;
    else
      Result := SFolderStyleUnknown;
  end;
end;

end.
