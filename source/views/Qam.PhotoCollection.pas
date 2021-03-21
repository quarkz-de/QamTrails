unit Qam.PhotoCollection;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Eventbus,
  VirtualTrees, VirtualExplorerEasyListview, VirtualExplorerTree,
  MPCommonObjects, MPShellUtilities, EasyListview,
  Qam.Forms, Qam.Events;

type
  TwPhotoCollection = class(TApplicationForm)
    vetFolders: TVirtualExplorerTreeview;
    Splitter1: TSplitter;
    velFotos: TVirtualExplorerEasyListview;
    procedure FormCreate(Sender: TObject);
    procedure velFotosEnumFolder(Sender: TCustomVirtualExplorerEasyListview;
      Namespace: TNamespace; var AllowAsChild: Boolean);
  private
    procedure SetRootFolder;
  public
    [Subscribe]
    procedure OnThemeChange(AEvent: IThemeChangeEvent);
    [Subscribe]
    procedure OnSettingChange(AEvent: ISettingChangeEvent);
  end;

var
  wPhotoCollection: TwPhotoCollection;

implementation

uses
  Qam.Settings;

{$R *.dfm}

{ TwPhotoCollection }

procedure TwPhotoCollection.FormCreate(Sender: TObject);
begin
  velFotos.ThumbsManager.StorageFilename := 'QamTrails.album';
  velFotos.ThumbsManager.StorageRepositoryFolder := ApplicationSettings.ThumbnailsFoldername;
  velFotos.ThumbsManager.AutoLoad := true;
  velFotos.ThumbsManager.AutoSave := true;
  SetRootFolder;
end;

procedure TwPhotoCollection.OnSettingChange(AEvent: ISettingChangeEvent);
begin
  case AEvent.Value of
    svMainCollectionFolder:
      begin
        SetRootFolder;
      end;
  end;
end;

procedure TwPhotoCollection.OnThemeChange(AEvent: IThemeChangeEvent);
begin

end;

procedure TwPhotoCollection.SetRootFolder;
begin
  vetFolders.RootFolder := rfCustom;
  vetFolders.RootFolderCustomPath := ApplicationSettings.MainCollectionFolder;

  velFotos.RootFolder := rfCustom;
  velFotos.RootFolderCustomPath := ApplicationSettings.MainCollectionFolder;

  vetFolders.Active := true;
  velFotos.Active := true;
end;

procedure TwPhotoCollection.velFotosEnumFolder(
  Sender: TCustomVirtualExplorerEasyListview; Namespace: TNamespace;
  var AllowAsChild: Boolean);
const
  FileExtensions: array[0..1] of String = ('.jpg', '.jpeg');
var
  Extension: String;
  I: Integer;
begin
  if Namespace.Folder then
    AllowAsChild := false
  else
    begin
      Extension := AnsiLowerCase(Namespace.Extension);
      AllowAsChild := false;
      for I := Low(FileExtensions) to High(FileExtensions) do
        if FileExtensions[I] = Extension then
          begin
            AllowAsChild := true;
            Break;
          end;
    end;
end;

end.
