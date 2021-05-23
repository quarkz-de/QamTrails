unit Qam.AlbumsVisualizer;

interface

uses
  System.SysUtils, System.Classes,
  Spring.Collections, Spring.Container,
  VirtualTrees,
  EventBus,
  Qam.PhotoAlbums;

type
  IPhotoAlbumTreeVisualizer = interface
    ['{6CCF634C-86D7-4CFF-8929-AA133A03CCA6}']
    procedure SetVirtualTree(const ATree: TVirtualStringTree);
    procedure SetPhotoAlbums(const AList: IPhotoAlbumCollection);
    procedure UpdateContent;
    function NewAlbum: TPhotoAlbum;
    procedure AddAlbum(const AAlbum: TPhotoAlbum);
    function DeleteSelectedAlbum: Boolean;
    function GetSelectedAlbum: TPhotoAlbum;
    function GetAlbum(const Node: PVirtualNode): TPhotoAlbum;
  end;

implementation

uses
  Qam.Events;

type
  TAlbumItem = record
    Album: TPhotoAlbum;
  end;
  PAlbumItem = ^TAlbumItem;

  TPhotoAlbumTreeVisualizer = class(TInterfacedObject, IPhotoAlbumTreeVisualizer)
  private
    FTree: TVirtualStringTree;
    FAlbums: IPhotoAlbumCollection;
    procedure GetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize:
      Integer);
    procedure GetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure Edited(Sender: TBaseVirtualTree; Node:
      PVirtualNode; Column: TColumnIndex);
    procedure Editing(Sender: TBaseVirtualTree; Node:
      PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure NewText(Sender: TBaseVirtualTree; Node:
      PVirtualNode; Column: TColumnIndex; NewText: string);
    procedure CompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    function DoAddAlbum(const AAlbum: TPhotoAlbum): PVirtualNode;
  public
    procedure SetVirtualTree(const ATree: TVirtualStringTree);
    procedure SetPhotoAlbums(const AList: IPhotoAlbumCollection);
    procedure UpdateContent;
    function NewAlbum: TPhotoAlbum;
    procedure AddAlbum(const AAlbum: TPhotoAlbum);
    function DeleteSelectedAlbum: Boolean;
    function GetSelectedAlbum: TPhotoAlbum;
    function GetAlbum(const Node: PVirtualNode): TPhotoAlbum;
  end;

{ TPhotoAlbumTreeVisualizer }

procedure TPhotoAlbumTreeVisualizer.AddAlbum(const AAlbum: TPhotoAlbum);
begin
  DoAddAlbum(AAlbum);
end;

procedure TPhotoAlbumTreeVisualizer.CompareNodes(Sender: TBaseVirtualTree;
  Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PAlbumItem;
begin
  Data1 := FTree.GetNodeData(Node1);
  Data2 := FTree.GetNodeData(Node2);

  Result := CompareText(Data1.Album.Name, Data2.Album.Name);
end;

function TPhotoAlbumTreeVisualizer.DeleteSelectedAlbum: Boolean;
var
  Data: PAlbumItem;
  Node, NextNode: PVirtualNode;
begin
  Result := false;
  Node := FTree.FocusedNode;
  if Node <> nil then
    begin
      FTree.BeginUpdate;
      NextNode := Node.PrevSibling;
      if NextNode = nil then
        NextNode := Node.NextSibling;
      if NextNode = nil then
        NextNode := Node.Parent;

      Data := FTree.GetNodeData(Node);
      GlobalEventBus.Post(TEventFactory.NewDeleteAlbumEvent(Data.Album));
      FAlbums.DeleteAlbum(Data.Album);
      FTree.DeleteNode(Node);

      if NextNode <> nil then
        begin
          FTree.FocusedNode := NextNode;
          FTree.Selected[NextNode] := true;
        end;
      FTree.EndUpdate;
    end;
end;

function TPhotoAlbumTreeVisualizer.DoAddAlbum(
  const AAlbum: TPhotoAlbum): PVirtualNode;
var
  Data: PAlbumItem;
begin
  FTree.BeginUpdate;

  FAlbums.Albums.Add(AAlbum);

  Result := FTree.AddChild(nil);
  Data := FTree.GetNodeData(Result);
  Data.Album := AAlbum;

  FTree.EndUpdate;

  FTree.FocusedNode := Result;
  FTree.Selected[Result] := true;

  FAlbums.SortAlbumList;
end;

procedure TPhotoAlbumTreeVisualizer.Edited(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
//var
//  Data: PAlbumItem;
begin
//  Data := FTree.GetNodeData(Node);
//  GlobalEventBus.Post(TEventFactory.NewPhotoAlbumEditEvent(Data.Album));
end;

procedure TPhotoAlbumTreeVisualizer.Editing(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := true;
end;

function TPhotoAlbumTreeVisualizer.GetAlbum(
  const Node: PVirtualNode): TPhotoAlbum;
var
  Data: PAlbumItem;
begin
  if Node = nil then
    begin
      Result := nil;
    end
  else
    begin
      Data := FTree.GetNodeData(Node);
      Result := Data.Album;
    end;
end;

procedure TPhotoAlbumTreeVisualizer.GetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TAlbumItem);
end;

function TPhotoAlbumTreeVisualizer.GetSelectedAlbum: TPhotoAlbum;
begin
  Result := GetAlbum(FTree.FocusedNode);
end;

procedure TPhotoAlbumTreeVisualizer.GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  Data: PAlbumItem;
begin
  Data := FTree.GetNodeData(Node);
  CellText := Data.Album.Name;
end;

function TPhotoAlbumTreeVisualizer.NewAlbum: TPhotoAlbum;
var
  Node: PVirtualNode;
begin
  Result := TPhotoAlbum.Create;
  Result.Name := 'unbenanntes Album';
  Node := DoAddAlbum(Result);
  FTree.EditNode(Node, -1);
end;

procedure TPhotoAlbumTreeVisualizer.NewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; NewText: string);
var
  Data: PAlbumItem;
  IsNew: Boolean;
begin
  Data := FTree.GetNodeData(Node);
  IsNew := Data.Album.Filename = '';
  Data.Album.Name := NewText;
  FAlbums.SortAlbumList;

  if IsNew then
    GlobalEventBus.Post(TEventFactory.NewNewAlbumEvent(Data.Album));
end;

procedure TPhotoAlbumTreeVisualizer.SetPhotoAlbums(
  const AList: IPhotoAlbumCollection);
begin
  FAlbums := AList;
end;

procedure TPhotoAlbumTreeVisualizer.SetVirtualTree(
  const ATree: TVirtualStringTree);
begin
  FTree := ATree;
  FTree.OnGetNodeDataSize := GetNodeDataSize;
  FTree.OnGetText := GetText;
  FTree.OnEdited := Edited;
  FTree.OnEditing := Editing;
  FTree.OnNewText := NewText;
  FTree.OnCompareNodes := CompareNodes;
end;

procedure TPhotoAlbumTreeVisualizer.UpdateContent;
var
  Node: PVirtualNode;
  Data: PAlbumItem;
  Album: TPhotoAlbum;
begin
  FTree.Clear;
  FTree.BeginUpdate;

  for Album in FAlbums.Albums do
    begin
      Node := FTree.AddChild(nil);
      Data := FTree.GetNodeData(Node);
      Data.Album := Album;
    end;

  FTree.SortTree(0, sdAscending);
  FTree.EndUpdate;
end;

initialization
  GlobalContainer.RegisterType<TPhotoAlbumTreeVisualizer>.Implements<IPhotoAlbumTreeVisualizer>;
end.
