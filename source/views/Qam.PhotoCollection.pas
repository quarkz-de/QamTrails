unit Qam.PhotoCollection;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.IOUtils,
  System.ImageList, System.Actions,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.ToolWin, Vcl.Buttons, Vcl.ImgList,
  Vcl.VirtualImageList, Vcl.ActnList,
  Eventbus,
  VirtualTrees, VirtualExplorerEasyListview, VirtualExplorerTree,
  MPCommonObjects, MPShellUtilities, EasyListview,
  Qam.Forms, Qam.Events, Qam.PhotoViewer, Qam.Types, Qam.PhotoAlbum;

type
  TwPhotoCollection = class(TApplicationForm)
    vetFolders: TVirtualExplorerTreeview;
    Splitter1: TSplitter;
    velFotos: TVirtualExplorerEasyListview;
    pnContent: TPanel;
    pnPreview: TPanel;
    vilIcons: TVirtualImageList;
    alActions: TActionList;
    acViewThumbnails: TAction;
    acViewPreview: TAction;
    acViewDetails: TAction;
    tbToolbar: TToolBar;
    tbViewThumbnails: TToolButton;
    tbViewPreview: TToolButton;
    tbViewDetails: TToolButton;
    tbDivider1: TToolButton;
    tbActiveAlbum: TToolButton;
    acActiveAlbum: TAction;
    acAddToActiveAlbum: TAction;
    ToolButton1: TToolButton;
    sbStatus: TStatusBar;
    procedure acActiveAlbumExecute(Sender: TObject);
    procedure acAddToActiveAlbumExecute(Sender: TObject);
    procedure acViewDetailsExecute(Sender: TObject);
    procedure acViewPreviewExecute(Sender: TObject);
    procedure acViewThumbnailsExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure velFotosEnumFolder(Sender: TCustomVirtualExplorerEasyListview;
      Namespace: TNamespace; var AllowAsChild: Boolean);
    procedure velFotosItemSelectionChanged(Sender: TCustomEasyListview; Item:
        TEasyItem);
    procedure vetFoldersChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vetFoldersEnumFolder(Sender: TCustomVirtualExplorerTree; Namespace:
        TNamespace; var AllowAsChild: Boolean);
  private
    FViewer: TfrPhotoViewer;
    FActiveAlbum: TPhotoAlbum;
    procedure SetFolderStyle;
    procedure SetRootFolder;
    procedure SetActiveAlbum(const Value: TPhotoAlbum);
    procedure UpdatePreview;
  protected
    property ActiveAlbum: TPhotoAlbum read FActiveAlbum write SetActiveAlbum;
  public
    [Subscribe]
    procedure OnThemeChange(AEvent: IThemeChangeEvent);
    [Subscribe]
    procedure OnSettingChange(AEvent: ISettingChangeEvent);
    [Subscribe]
    procedure OnActiveAlbumChange(AEvent: IActiveAlbumChangeEvent);
  end;

var
  wPhotoCollection: TwPhotoCollection;

implementation

uses
  Qodelib.DropdownForm,
  Qam.Settings, Qam.Storage, Qam.DataModule, Qam.AlbumSelector;

{$R *.dfm}

{ TwPhotoCollection }

procedure TwPhotoCollection.acActiveAlbumExecute(Sender: TObject);
begin
  TDropDownFormController.DropDown(TwAlbumSelector, tbActiveAlbum);
end;

procedure TwPhotoCollection.acAddToActiveAlbumExecute(Sender: TObject);
begin
  if Assigned(ActiveAlbum) then
    TPhotoAlbumItemHelper.AddItem(ActiveAlbum, velFotos.SelectedPath)
  else
    ShowMessage('Kein Album ausgewählt.');
end;

procedure TwPhotoCollection.acViewDetailsExecute(Sender: TObject);
begin
  ApplicationSettings.PhotoCollectionFolderStyle := cfsDetails;
end;

procedure TwPhotoCollection.acViewPreviewExecute(Sender: TObject);
begin
  ApplicationSettings.PhotoCollectionFolderStyle := cfsPreview;
end;

procedure TwPhotoCollection.acViewThumbnailsExecute(Sender: TObject);
begin
  ApplicationSettings.PhotoCollectionFolderStyle := cfsGrid;
end;

procedure TwPhotoCollection.FormCreate(Sender: TObject);
begin
  GlobalEventBus.RegisterSubscriberForEvents(Self);

  FViewer := TfrPhotoViewer.Create(self);
  FViewer.Parent := pnPreview;
  FViewer.Align := alClient;

  velFotos.ThumbsManager.StorageFilename := 'QamTrails.album';
  velFotos.ThumbsManager.AutoLoad := true;
  velFotos.ThumbsManager.AutoSave := true;

  SetRootFolder;
  SetFolderStyle;
end;

procedure TwPhotoCollection.OnActiveAlbumChange(
  AEvent: IActiveAlbumChangeEvent);
begin
  ActiveAlbum := AEvent.Album;
end;

procedure TwPhotoCollection.OnSettingChange(AEvent: ISettingChangeEvent);
begin
  case AEvent.Value of
    svMainCollectionFolder:
      SetRootFolder;
    svPhotoCollectionFolderStyle:
      SetFolderStyle;
  end;
end;

procedure TwPhotoCollection.OnThemeChange(AEvent: IThemeChangeEvent);
begin
  vilIcons.ImageCollection := dmCommon.GetImageCollection;
end;

procedure TwPhotoCollection.SetActiveAlbum(const Value: TPhotoAlbum);
begin
  FActiveAlbum := Value;
  sbStatus.Panels[1].Text := FActiveAlbum.Name;
end;

procedure TwPhotoCollection.SetFolderStyle;
begin
  case ApplicationSettings.PhotoCollectionFolderStyle of
    cfsGrid:
      begin
        pnPreview.Visible := false;
        velFotos.Header.Visible := false;
        velFotos.View := elsThumbnail;
        velFotos.Align := alClient;
        pnPreview.Align := alNone;
        acViewThumbnails.Checked := true;
      end;
    cfsPreview:
      begin
        velFotos.View := elsFilmStrip;
        velFotos.Header.Visible := false;
        pnPreview.Visible := true;
        UpdatePreview;
        velFotos.Align := alTop;
        velFotos.Height := velFotos.CellSizes.FilmStrip.Height + 20;
        pnPreview.Align := alClient;
        acViewPreview.Checked := true;
      end;
    cfsDetails:
      begin
        velFotos.View := elsReportThumb;
        velFotos.Header.Visible := true;
        pnPreview.Visible := false;
        velFotos.Align := alClient;
        pnPreview.Align := alNone;
        acViewDetails.Checked := true;
      end;
  end;
end;

procedure TwPhotoCollection.SetRootFolder;
var
  ActiveFolder: String;
begin
  ActiveFolder := ApplicationSettings.ActiveCollectionFolder;

  vetFolders.RootFolder := rfCustom;
  vetFolders.RootFolderCustomPath := ApplicationSettings.MainCollectionFolder;

  velFotos.RootFolder := rfCustom;
  velFotos.RootFolderCustomPath := ApplicationSettings.MainCollectionFolder;
  velFotos.ThumbsManager.StorageRepositoryFolder := ApplicationSettings.DataFoldername;
  TDataStorage.Initialize;

  vetFolders.Active := true;
  velFotos.Active := true;

  if TDirectory.Exists(ActiveFolder) then
    vetFolders.BrowseTo(ActiveFolder);
end;

procedure TwPhotoCollection.UpdatePreview;
begin
  if ApplicationSettings.PhotoCollectionFolderStyle = cfsPreview then
    FViewer.LoadFromFile(velFotos.SelectedPath);
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

procedure TwPhotoCollection.velFotosItemSelectionChanged(Sender:
  TCustomEasyListview; Item: TEasyItem);
begin
  UpdatePreview;
end;

procedure TwPhotoCollection.vetFoldersChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  ApplicationSettings.ActiveCollectionFolder := vetFolders.SelectedPath;
end;

procedure TwPhotoCollection.vetFoldersEnumFolder(
  Sender: TCustomVirtualExplorerTree; Namespace: TNamespace;
  var AllowAsChild: Boolean);
begin
  if Namespace.Folder then
    AllowAsChild := Namespace.NameInFolder <> '.QamTrails'
  else
    AllowAsChild := false;
end;

end.
