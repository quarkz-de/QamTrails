unit Qam.AlbumSelector;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.WinXCtrls,
  Vcl.ExtCtrls,
  VirtualTrees,
  Qodelib.DropdownForm,
  Qam.Events, Qam.PhotoAlbum, Qam.AlbumsVisualizer;

type
  TwAlbumSelector = class(TDropDownForm)
    Panel1: TPanel;
    edSuche: TSearchBox;
    btSelect: TButton;
    btNewAlbum: TButton;
    stAlbums: TVirtualStringTree;
    procedure btNewAlbumClick(Sender: TObject);
    procedure btSelectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure stAlbumsDblClick(Sender: TObject);
  private
    FAlbumVisualizer: IPhotoAlbumTreeVisualizer;
  protected
    procedure ApplyFormData; override;
  end;

var
  wAlbumSelector: TwAlbumSelector;

implementation

{$R *.dfm}

uses
  Spring.Container, Spring.Collections,
  EventBus,
  Qam.DataModule;

{ TwAlbumSelector }

procedure TwAlbumSelector.FormCreate(Sender: TObject);
var
  Albums: IList<TPhotoAlbum>;
begin
  FAlbumVisualizer := GlobalContainer.Resolve<IPhotoAlbumTreeVisualizer>;
  FAlbumVisualizer.SetVirtualTree(stAlbums);
  Albums := dmCommon.Database.GetSession.FindAll<TPhotoAlbum>();
  FAlbumVisualizer.SetPhotoAlbums(Albums);
  FAlbumVisualizer.UpdateContent;
end;

procedure TwAlbumSelector.ApplyFormData;
begin
  GlobalEventBus.Post(TEventFactory.NewActiveAlbumChangeEvent(FAlbumVisualizer.GetSelectedAlbum));
end;

procedure TwAlbumSelector.btNewAlbumClick(Sender: TObject);
begin
  FAlbumVisualizer.NewAlbum;
end;

procedure TwAlbumSelector.btSelectClick(Sender: TObject);
begin
  CloseDropDown(dcaApply);
end;

procedure TwAlbumSelector.stAlbumsDblClick(Sender: TObject);
begin
  CloseDropDown(dcaApply);
end;

end.
