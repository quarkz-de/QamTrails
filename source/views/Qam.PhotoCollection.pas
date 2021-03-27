unit Qam.PhotoCollection;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.IOUtils,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.ToolWin, Vcl.StdCtrls,
  Eventbus,
  VirtualTrees, VirtualExplorerEasyListview, VirtualExplorerTree,
  MPCommonObjects, MPShellUtilities, EasyListview,
  Qam.Forms, Qam.Events, Qam.PhotoViewer, Qam.Types;

type
  TwPhotoCollection = class(TApplicationForm)
    vetFolders: TVirtualExplorerTreeview;
    Splitter1: TSplitter;
    velFotos: TVirtualExplorerEasyListview;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    pnContent: TPanel;
    pnPreview: TPanel;
    cbView: TComboBox;
    procedure cbViewChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure velFotosEnumFolder(Sender: TCustomVirtualExplorerEasyListview;
      Namespace: TNamespace; var AllowAsChild: Boolean);
    procedure velFotosItemSelectionChanged(Sender: TCustomEasyListview; Item:
        TEasyItem);
    procedure vetFoldersChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
  private
    FViewer: TfrPhotoViewer;
    FFolderStyle: TPhotoCollectionFolderStyle;
    procedure SetFolderStyle(Value: TPhotoCollectionFolderStyle);
    procedure SetRootFolder;
    procedure UpdatePreview;
  public
    [Subscribe]
    procedure OnThemeChange(AEvent: IThemeChangeEvent);
    [Subscribe]
    procedure OnSettingChange(AEvent: ISettingChangeEvent);
    property FolderStyle: TPhotoCollectionFolderStyle read FFolderStyle
      write SetFolderStyle;
  end;

var
  wPhotoCollection: TwPhotoCollection;

implementation

uses
  Qam.Settings;

{$R *.dfm}

{ TwPhotoCollection }

procedure TwPhotoCollection.cbViewChange(Sender: TObject);
begin
  FolderStyle := TPhotoCollectionFolderStyle.Create(cbView.ItemIndex);
end;

procedure TwPhotoCollection.FormCreate(Sender: TObject);
begin
  FViewer := TfrPhotoViewer.Create(self);
  FViewer.Parent := pnPreview;
  FViewer.Align := alClient;

  velFotos.ThumbsManager.StorageFilename := 'QamTrails.album';
  velFotos.ThumbsManager.StorageRepositoryFolder := ApplicationSettings.ThumbnailsFoldername;
  velFotos.ThumbsManager.AutoLoad := true;
  velFotos.ThumbsManager.AutoSave := true;

  TPhotoCollectionFolderStyle.AssignStrings(cbView.Items);
  FolderStyle := cfsGrid;

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

procedure TwPhotoCollection.SetFolderStyle(Value: TPhotoCollectionFolderStyle);
begin
  FFolderStyle := Value;

  case FFolderStyle of
    cfsGrid:
      begin
        pnPreview.Visible := false;
        velFotos.Header.Visible := false;
        velFotos.View := elsThumbnail;
        velFotos.Align := alClient;
        pnPreview.Align := alNone;
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
      end;
    cfsDetails:
      begin
        velFotos.View := elsReportThumb;
        velFotos.Header.Visible := true;
        pnPreview.Visible := false;
        velFotos.Align := alClient;
        pnPreview.Align := alNone;
      end;
  end;

  cbView.ItemIndex := FFolderStyle.ToInteger;
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

  vetFolders.Active := true;
  velFotos.Active := true;

  if TDirectory.Exists(ActiveFolder) then
    vetFolders.BrowseTo(ActiveFolder);
end;

procedure TwPhotoCollection.UpdatePreview;
begin
  if FFolderStyle = cfsPreview then
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

end.
