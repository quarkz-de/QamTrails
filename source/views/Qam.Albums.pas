unit Qam.Albums;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShlObj, Winapi.ActiveX,
  System.SysUtils, System.Variants, System.Classes, System.ImageList,
  System.Actions, System.Math,
  Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ControlList, Vcl.ToolWin, Vcl.ComCtrls, Vcl.ImgList,
  Vcl.VirtualImageList, Vcl.ActnList,
  Eventbus,
  VirtualTrees,
  EasyListview, VirtualExplorerEasyListview, MPCommonObjects, MPShellUtilities,
  MPDataObject, MPCommonUtilities, MPShellTypes,
  Qam.Forms, Qam.Events, Qam.PhotoAlbums, Qam.AlbumsVisualizer,
  VirtualShellNotifier;

type
  TwAlbums = class(TApplicationForm)
    stAlbums: TVirtualStringTree;
    spSplitter: TSplitter;
    tbToolbar: TToolBar;
    vilIcons: TVirtualImageList;
    alActions: TActionList;
    ToolButton1: TToolButton;
    acNewAlbum: TAction;
    velFotos: TVirtualMultiPathExplorerEasyListview;
    procedure acNewAlbumExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure stAlbumsFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex);
    procedure velFotosKeyAction(Sender: TCustomEasyListview; var CharCode: Word;
        var Shift: TShiftState; var DoDefault: Boolean);
    procedure velFotosOLEDragDrop(Sender: TCustomEasyListview; DataObject:
        IDataObject; KeyState: TCommonKeyStates; WindowPt: TPoint;
        AvailableEffects: TCommonDropEffects; var DesiredDropEffect:
        TCommonDropEffect; var Handled: Boolean);
    procedure velFotosOLEDragEnter(Sender: TCustomEasyListview; DataObject:
        IDataObject; KeyState: TCommonKeyStates; WindowPt: TPoint;
        AvailableEffects: TCommonDropEffects; var DesiredDropEffect:
        TCommonDropEffect);
  private
    FAlbumVisualizer: IPhotoAlbumTreeVisualizer;
    function GetActiveAlbum: TPhotoAlbum;
    procedure LoadAlbums;
    procedure AlbumChanged;
    procedure SetRootFolder;
    function GetHDropFormat: TFormatEtc;
  public
    property ActiveAlbum: TPhotoAlbum read GetActiveAlbum;
    [Subscribe]
    procedure OnThemeChange(AEvent: IThemeChangeEvent);
    [Subscribe]
    procedure OnNewAlbum(AEvent: INewAlbumEvent);
    [Subscribe]
    procedure OnNewAlbumItem(AEvent: INewAlbumItemEvent);
    [Subscribe]
    procedure OnSettingChange(AEvent: ISettingChangeEvent);
  end;

var
  wAlbums: TwAlbums;

implementation

{$R *.dfm}

uses
  Spring.Container, Spring.Collections,
  Qam.DataModule, Qam.Settings;

procedure TwAlbums.acNewAlbumExecute(Sender: TObject);
begin
  FAlbumVisualizer.NewAlbum;
end;

procedure TwAlbums.AlbumChanged;
var
  PIDL: PItemIDList;
  I: Integer;
begin
  velFotos.BeginUpdate;
  try
    velFotos.Clear;
    for I := 0 to ActiveAlbum.Count - 1 do
      begin
        PIDL := PathToPIDL(ActiveAlbum[I]);
        velFotos.AddCustomItem(nil, TNamespace.Create(PIDL, nil), True);
      end;
  finally
    velFotos.EndUpdate;
  end;
end;

procedure TwAlbums.FormCreate(Sender: TObject);
begin
  GlobalEventBus.RegisterSubscriberForEvents(Self);
  FAlbumVisualizer := GlobalContainer.Resolve<IPhotoAlbumTreeVisualizer>;
  FAlbumVisualizer.SetVirtualTree(stAlbums);

  velFotos.ThumbsManager.StorageFilename := 'QamTrails.album';
  velFotos.ThumbsManager.AutoLoad := true;
  velFotos.ThumbsManager.AutoSave := true;

  LoadAlbums;
end;

function TwAlbums.GetActiveAlbum: TPhotoAlbum;
begin
  Result := FAlbumVisualizer.GetSelectedAlbum;
end;

function TwAlbums.GetHDropFormat: TFormatEtc;
begin
  Result.cfFormat := CF_HDROP;
  Result.ptd := nil;
  Result.dwAspect := DVASPECT_CONTENT;
  Result.lindex := -1;
  Result.tymed := TYMED_HGLOBAL
end;

procedure TwAlbums.LoadAlbums;
var
  Albums: IPhotoAlbumCollection;
begin
  Albums := GlobalContainer.Resolve<IPhotoAlbumCollection>;
  FAlbumVisualizer.SetPhotoAlbums(Albums);
  FAlbumVisualizer.UpdateContent;
end;

procedure TwAlbums.OnNewAlbum(AEvent: INewAlbumEvent);
begin
  FAlbumVisualizer.AddAlbum(AEvent.Album);
end;

procedure TwAlbums.OnNewAlbumItem(AEvent: INewAlbumItemEvent);
var
  PIDL: PItemIDList;
begin
  if AEvent.Album = ActiveAlbum then
    begin
      PIDL := PathToPIDL(AEvent.Filename);
      velFotos.AddCustomItem(nil, TNamespace.Create(PIDL, nil), True);
    end;
end;

procedure TwAlbums.OnSettingChange(AEvent: ISettingChangeEvent);
begin
  case AEvent.Value of
    svMainCollectionFolder:
      SetRootFolder;
  end;
end;

procedure TwAlbums.OnThemeChange(AEvent: IThemeChangeEvent);
begin
  vilIcons.ImageCollection := dmCommon.GetImageCollection;
end;

procedure TwAlbums.SetRootFolder;
begin
  velFotos.ThumbsManager.StorageRepositoryFolder := ApplicationSettings.DataFoldername;
end;

procedure TwAlbums.stAlbumsFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  AlbumChanged;
end;

procedure TwAlbums.velFotosKeyAction(Sender: TCustomEasyListview;
  var CharCode: Word; var Shift: TShiftState; var DoDefault: Boolean);
begin
  case CharCode of
    VK_DELETE:
      begin
        // todo:
        // velFotos.SelectedPaths aus dem Album entfernen
        DoDefault := false;
      end;
end;

procedure TwAlbums.velFotosOLEDragDrop(Sender: TCustomEasyListview;
  DataObject: IDataObject; KeyState: TCommonKeyStates; WindowPt: TPoint;
  AvailableEffects: TCommonDropEffects; var DesiredDropEffect: TCommonDropEffect;
  var Handled: Boolean);
var
  HDrop: TCommonHDrop;
  I: Integer;
begin
  DesiredDropEffect := cdeNone;
  if Succeeded(DataObject.QueryGetData(GetHDropFormat)) then
    begin
      HDrop := TCommonHDrop.Create;
      try
        if HDrop.LoadFromDataObject(DataObject) then
          begin
            for I := 0 to HDrop.FileCount - 1 do
              begin
                ActiveAlbum.Add(HDrop.FileName(I));
                GlobalEventBus.Post(TEventFactory.NewNewAlbumItemEvent(ActiveAlbum, HDrop.FileName(I)));
              end;
            DesiredDropEffect := cdeCopy;
          end;
      finally
        HDrop.Free;
      end;
    end;
end;

procedure TwAlbums.velFotosOLEDragEnter(Sender: TCustomEasyListview;
  DataObject: IDataObject; KeyState: TCommonKeyStates; WindowPt: TPoint;
  AvailableEffects: TCommonDropEffects;
  var DesiredDropEffect: TCommonDropEffect);
begin
  DesiredDropEffect := cdeNone;
end;

end.
