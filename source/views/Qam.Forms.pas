unit Qam.Forms;

interface

uses
  Vcl.Forms, Vcl.Controls;

type
  TApplicationForm = class(TForm)
  public
    procedure InitializeForm; virtual;
  end;

  TApplicationFormType = (aftWelcome, aftSettings, aftPhotoCollection,
    aftAlbums);

  TApplicationFormList = class(TObject)
  private
    FParent: TForm;
    FForms: array[TApplicationFormType] of TApplicationForm;
    function GetActiveForm: TApplicationForm;
    procedure CreateForms;
  public
    constructor Create(const AParent: TForm);
    procedure ShowForm(const AForm: TApplicationFormType);
    property ActiveForm: TApplicationForm read GetActiveForm;
  end;

implementation

uses
  Qam.WelcomeForm, Qam.SettingsForm, Qam.PhotoCollection,
  Qam.Albums;

{ TApplicationForm }

procedure TApplicationForm.InitializeForm;
begin

end;

{ TApplicationFormList }

constructor TApplicationFormList.Create(const AParent: TForm);
begin
  inherited Create;
  FParent := AParent;
  CreateForms;
end;

procedure TApplicationFormList.CreateForms;
var
  Form: TApplicationForm;
begin
  FForms[aftWelcome] := TwWelcomeForm.Create(FParent);
  FForms[aftSettings] := TwSettingsForm.Create(FParent);
  FForms[aftPhotoCollection] := TwPhotoCollection.Create(FParent);
  FForms[aftAlbums] := TwAlbums.Create(FParent);

  for Form in FForms do
    begin
      Form.Font := FParent.Font;
      Form.BorderStyle := bsNone;
      Form.InitializeForm;
    end;
end;

function TApplicationFormList.GetActiveForm: TApplicationForm;
var
  Form: TApplicationForm;
begin
  Result := nil;
  for Form in FForms do
    if (Form <> nil) and (Form.Visible) then
      begin
        Result := Form;
        Break;
      end;
end;

procedure TApplicationFormList.ShowForm(const AForm: TApplicationFormType);
var
  Form: TApplicationForm;
  FormType: TApplicationFormType;
begin
  for FormType := Low(TApplicationFormType) to High(TApplicationFormType) do
    begin
      Form := FForms[FormType];
      if (FormType = AForm) then
        begin
          Form.Parent := FParent;
          Form.Align := alClient;
          Form.Visible := true;
          Form.Activate;
        end
      else
        begin
          Form.Deactivate;
          Form.Visible := false;
          Form.Parent := nil;
        end;
    end;
end;

end.
