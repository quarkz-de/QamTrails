unit Qam.PhotoCollection;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ActiveX,
  System.SysUtils, System.Variants, System.Classes, System.IOUtils,
  System.ImageList, System.Actions,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.ToolWin, Vcl.Buttons, Vcl.ImgList,
  Vcl.VirtualImageList, Vcl.ActnList,
  Eventbus,
  VirtualTrees, VirtualExplorerEasyListview, VirtualExplorerTree,
  MPCommonObjects, MPShellUtilities, EasyListview, MPCommonUtilities,
  Qam.Forms, Qam.Events, Qam.PhotoViewer, Qam.Types, Qam.PhotoAlbums;

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
    acAddToActiveAlbum: TAction;
    tbAddToActiveAlbum: TToolButton;
    cbAlbums: TComboBox;
    acNewFolder: TAction;
    tbNewFolder: TToolButton;
    ToolButton1: TToolButton;
    procedure acAddToActiveAlbumExecute(Sender: TObject);
    procedure acNewFolderExecute(Sender: TObject);
    procedure acViewDetailsExecute(Sender: TObject);
    procedure acViewPreviewExecute(Sender: TObject);
    procedure acViewThumbnailsExecute(Sender: TObject);
    procedure cbAlbumsChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure velFotosCustomGroup(Sender: TCustomVirtualExplorerEasyListview;
        Groups: TEasyGroups; NS: TNamespace; var Group: TExplorerGroup);
    procedure velFotosEnumFolder(Sender: TCustomVirtualExplorerEasyListview;
      Namespace: TNamespace; var AllowAsChild: Boolean);
    procedure velFotosItemCheckChange(Sender: TCustomEasyListview; Item: TEasyItem);
    procedure velFotosItemInitialize(Sender: TCustomEasyListview; Item: TEasyItem);
    procedure velFotosItemSelectionChanged(Sender: TCustomEasyListview;
      Item: TEasyItem);
    procedure velFotosOLEDragStart(Sender: TCustomEasyListview;
      ADataObject: IDataObject; var AvailableEffects: TCommonDropEffects;
      var AllowDrag: Boolean);
    procedure velFotosRebuiltShellHeader(Sender: TCustomVirtualExplorerEasyListview);
    procedure vetFoldersChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vetFoldersEnumFolder(Sender: TCustomVirtualExplorerTree;
      Namespace: TNamespace; var AllowAsChild: Boolean);
  private
    FViewer: TfrPhotoViewer;
    procedure SetFolderStyle;
    procedure SetRootFolder;
    procedure SetActiveAlbum(const Value: TPhotoAlbum);
    function GetActiveAlbum: TPhotoAlbum;
    procedure UpdatePreview;
    procedure UpdateAlbumList;
    procedure ChangeActiveAlbum;
    procedure SelectAlbum(const AIndex: Integer); overload;
    procedure SelectAlbum(const AAlbum: TPhotoAlbum); overload;
  protected
    property ActiveAlbum: TPhotoAlbum read GetActiveAlbum write SetActiveAlbum;
  public
    procedure InitializeForm; override;
    [Subscribe]
    procedure OnThemeChange(AEvent: IThemeChangeEvent);
    [Subscribe]
    procedure OnSettingChange(AEvent: ISettingChangeEvent);
    [Subscribe]
    procedure OnActiveAlbumChange(AEvent: IActiveAlbumChangeEvent);
    [Subscribe]
    procedure OnNewAlbum(AEvent: INewAlbumEvent);
    [Subscribe]
    procedure OnDeleteAlbum(AEvent: IDeleteAlbumEvent);
  end;

var
  wPhotoCollection: TwPhotoCollection;

implementation

uses
  Spring.Container,
  Qodelib.DropdownForm,
  Qam.Settings, Qam.Storage, Qam.DataModule;

{$R *.dfm}

{ TwPhotoCollection }

procedure TwPhotoCollection.acAddToActiveAlbumExecute(Sender: TObject);
var
  Filename: String;
begin
  if Assigned(ActiveAlbum) then
    begin
      for Filename in velFotos.SelectedPaths do
        begin
          if ActiveAlbum.Filenames.IndexOf(Filename) < 0 then
            begin
              ActiveAlbum.Filenames.Add(Filename);
              GlobalEventBus.Post(TEventFactory.NewNewAlbumItemEvent(ActiveAlbum, Filename));
            end;
        end;
    end
  else
    ShowMessage('Kein Album ausgewählt.');
end;

procedure TwPhotoCollection.acNewFolderExecute(Sender: TObject);
begin
  vetFolders.CreateNewFolder(vetFolders.RootFolderNamespace.NameForParsing);
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

procedure TwPhotoCollection.cbAlbumsChange(Sender: TObject);
begin
  ChangeActiveAlbum;
end;

procedure TwPhotoCollection.ChangeActiveAlbum;
var
  Albums: IPhotoAlbumCollection;
begin
  Albums := GlobalContainer.Resolve<IPhotoAlbumCollection>;
  if cbAlbums.ItemIndex > -1 then
    SetActiveAlbum(TPhotoAlbum(cbAlbums.Items.Objects[cbAlbums.ItemIndex]));
  velFotos.Rebuild;
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

function TwPhotoCollection.GetActiveAlbum: TPhotoAlbum;
begin
  if cbAlbums.ItemIndex < 0 then
    Result := nil
  else
    Result := TPhotoAlbum(cbAlbums.Items.Objects[cbAlbums.ItemIndex]);
end;

procedure TwPhotoCollection.InitializeForm;
begin
  inherited;
  velFotos.Font.Size := velFotos.Font.Size - 2;
end;

procedure TwPhotoCollection.OnActiveAlbumChange(
  AEvent: IActiveAlbumChangeEvent);
begin
  ActiveAlbum := AEvent.Album;
end;

procedure TwPhotoCollection.OnDeleteAlbum(AEvent: IDeleteAlbumEvent);
var
  Albums: IPhotoAlbumCollection;
  OldIndex, Index: Integer;
begin
  Albums := GlobalContainer.Resolve<IPhotoAlbumCollection>;
  if cbAlbums.ItemIndex > -1 then
    begin
      Index := cbAlbums.Items.IndexofObject(AEvent.Album);
      OldIndex := cbAlbums.ItemIndex;
      if Index >-1 then
        begin
          cbAlbums.Items.Delete(Index);
          if (cbAlbums.ItemIndex < 0) and (OldIndex > -1) then
            begin
              if OldIndex >= cbAlbums.Items.Count then
                cbAlbums.ItemIndex := cbAlbums.Items.Count - 1
              else
                cbAlbums.ItemIndex := OldIndex;
              ChangeActiveAlbum;
            end;
        end;
    end;
end;

procedure TwPhotoCollection.OnNewAlbum(AEvent: INewAlbumEvent);
var
  Album: TPhotoAlbum;
begin
  Album := ActiveAlbum;
  UpdateAlbumList;
  if Album <> nil then
    SelectAlbum(Album);
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

procedure TwPhotoCollection.SelectAlbum(const AAlbum: TPhotoAlbum);
begin
  SelectAlbum(cbAlbums.Items.IndexOfObject(AAlbum));
end;

procedure TwPhotoCollection.SelectAlbum(const AIndex: Integer);
begin
  if cbAlbums.Items.Count > AIndex then
    cbAlbums.ItemIndex := AIndex;
  ChangeActiveAlbum;
end;

procedure TwPhotoCollection.SetActiveAlbum(const Value: TPhotoAlbum);
var
  Index: Integer;
begin
  Index := cbAlbums.Items.IndexOfObject(Value);
  if Index > -1 then
    cbAlbums.ItemIndex := Index;
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
        velFotos.Grouped := true;
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
        velFotos.Grouped := false;
      end;
    cfsDetails:
      begin
        velFotos.View := elsReportThumb;
        velFotos.Header.Visible := true;
        pnPreview.Visible := false;
        velFotos.Align := alClient;
        pnPreview.Align := alNone;
        acViewDetails.Checked := true;
        velFotos.Grouped := false;
      end;
  end;

  velFotos.Header.ShowInAllViews := velFotos.View = elsReportThumb;

//  velFotos.Rebuild;

  if velFotos.Selection.FocusedItem <> nil then
    velFotos.Selection.FocusedItem.MakeVisible(emvAuto);
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

  UpdateAlbumList;
  SelectAlbum(0);
end;

procedure TwPhotoCollection.UpdateAlbumList;
var
  Albums: IPhotoAlbumCollection;
  Album: TPhotoAlbum;
begin
  Albums := GlobalContainer.Resolve<IPhotoAlbumCollection>;

  cbAlbums.Items.BeginUpdate;
  cbAlbums.Items.Clear;
  for Album in Albums.Albums do
    cbAlbums.Items.AddObject(Album.Name, Album);
  cbAlbums.Items.EndUpdate;
end;

procedure TwPhotoCollection.UpdatePreview;
begin
  if ApplicationSettings.PhotoCollectionFolderStyle = cfsPreview then
    FViewer.LoadFromFile(velFotos.SelectedPath);
end;

procedure TwPhotoCollection.velFotosCustomGroup(Sender:
    TCustomVirtualExplorerEasyListview; Groups: TEasyGroups; NS: TNamespace;
    var Group: TExplorerGroup);
var
  I: Integer;
begin
  if velFotos.View = elsThumbnail then
    begin
      I := 0;
      while not Assigned(Group) and (I < Groups.Count) do
        begin
          if Groups[I].Caption = DateToStr(NS.LastWriteDateTime) then
            Group := TExplorerGroup(Groups[I]);
          Inc(I);
        end;
      if not Assigned(Group) then
        begin
          Group := Groups.AddCustom(TExplorerGroup) as TExplorerGroup;
          Group.Caption := DateToStr(NS.LastWriteDateTime);
        end;
    end;
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

procedure TwPhotoCollection.velFotosItemCheckChange(
  Sender: TCustomEasyListview; Item: TEasyItem);
var
  ExplorerItem: TExplorerItem;
  Filename: String;
  Index: Integer;
begin
  if ActiveAlbum = nil then
    Exit;

  if not (Item is TExplorerItem) then
    Exit;

  ExplorerItem := TExplorerItem(Item);
  if ExplorerItem.Namespace = nil then
    Exit;

  Filename := ExplorerItem.Namespace.NameForParsing;
  Index := ActiveAlbum.Filenames.IndexOf(Filename);

  if Item.Checked then
    begin
      if Index < 0 then
        begin
          ActiveAlbum.Filenames.Add(Filename);
          GlobalEventBus.Post(TEventFactory.NewNewAlbumItemEvent(ActiveAlbum, Filename));
        end;
    end
  else
    begin
      if Index > -1 then
        begin
          ActiveAlbum.Filenames.Delete(Index);
          GlobalEventBus.Post(TEventFactory.NewDeleteAlbumItemEvent(ActiveAlbum, Filename));
        end;
    end;
end;

procedure TwPhotoCollection.velFotosItemInitialize(Sender: TCustomEasyListview;
  Item: TEasyItem);
var
  ExplorerItem: TExplorerItem;
begin
  if ActiveAlbum = nil then
    Exit;

  ExplorerItem := TExplorerItem(Item);
  Item.Checked := ActiveAlbum.Filenames.IndexOf(ExplorerItem.Namespace.NameForParsing) > -1;
end;

procedure TwPhotoCollection.velFotosItemSelectionChanged(Sender:
  TCustomEasyListview; Item: TEasyItem);
begin
  UpdatePreview;
end;

procedure TwPhotoCollection.velFotosOLEDragStart(Sender: TCustomEasyListview;
  ADataObject: IDataObject; var AvailableEffects: TCommonDropEffects;
  var AllowDrag: Boolean);
begin
  AvailableEffects := [cdeCopy];
end;

procedure TwPhotoCollection.velFotosRebuiltShellHeader(
  Sender: TCustomVirtualExplorerEasyListview);
begin
  // Die Spalte "Dateityp" wird immer ausgeblendet.
  velFotos.Header.Columns[2].Visible := false;
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
