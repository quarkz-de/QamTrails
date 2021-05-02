unit Qam.SettingsForm;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.StdCtrls,
  Qam.Forms;

type
  TwSettingsForm = class(TApplicationForm)
    txTheme: TLabel;
    cbTheme: TComboBox;
    txMainCollectionFolderLabel: TLabel;
    dSelectFolder: TFileOpenDialog;
    txMainCollectionFolder: TLabel;
    btSelectFolder: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cbThemeChange(Sender: TObject);
    procedure btSelectFolderClick(Sender: TObject);
  private
    procedure LoadValues;
    procedure InitControls;
  public
  end;

implementation

{$R *.dfm}

uses
  Qodelib.Themes,
  Qam.Settings;

{ TwSettingsForm }

procedure TwSettingsForm.btSelectFolderClick(Sender: TObject);
begin
  dSelectFolder.Filename := ApplicationSettings.MainCollectionFolder;
  if dSelectFolder.Execute then
    ApplicationSettings.MainCollectionFolder := dSelectFolder.Filename;
end;

procedure TwSettingsForm.cbThemeChange(Sender: TObject);
begin
  ApplicationSettings.Theme := cbTheme.Items[cbTheme.ItemIndex];
end;

procedure TwSettingsForm.FormCreate(Sender: TObject);
begin
  InitControls;
  LoadValues;
end;

procedure TwSettingsForm.InitControls;
begin

end;

procedure TwSettingsForm.LoadValues;
begin
  QuarkzThemeManager.AssignThemeNames(cbTheme.Items);
  cbTheme.ItemIndex := cbTheme.Items.IndexOf(ApplicationSettings.Theme);
  txMainCollectionFolder.Caption := ApplicationSettings.MainCollectionFolder;
end;

end.
