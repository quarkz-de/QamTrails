object wAlbums: TwAlbums
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'wAlbums'
  ClientHeight = 338
  ClientWidth = 651
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object spSplitter: TSplitter
    Left = 205
    Top = 29
    Height = 309
    ExplicitLeft = 324
    ExplicitTop = 120
    ExplicitHeight = 100
  end
  object clFotos: TControlList
    Left = 208
    Top = 29
    Width = 443
    Height = 309
    Align = alClient
    BorderStyle = bsNone
    ItemMargins.Left = 0
    ItemMargins.Top = 0
    ItemMargins.Right = 0
    ItemMargins.Bottom = 0
    ParentColor = False
    TabOrder = 0
    OnBeforeDrawItem = clFotosBeforeDrawItem
    OnShowControl = clFotosShowControl
    ExplicitLeft = 211
    object txFilename: TLabel
      Left = 108
      Top = 4
      Width = 52
      Height = 13
      Caption = 'txFilename'
    end
    object btEdit: TControlListButton
      Left = 371
      Top = 32
      Width = 34
      Height = 33
      Anchors = [akRight, akBottom]
      Images = vilIcons
      ImageIndex = 9
      ImageName = '009_Edit'
      LinkHotColor = clHighlight
      Style = clbkToolButton
      ExplicitLeft = 228
    end
    object btDelete: TControlListButton
      Left = 406
      Top = 32
      Width = 34
      Height = 33
      Anchors = [akRight, akBottom]
      Images = vilIcons
      ImageIndex = 8
      ImageName = '008_Delete'
      LinkHotColor = clHighlight
      Style = clbkToolButton
      ExplicitLeft = 263
    end
  end
  object stAlbums: TVirtualStringTree
    Left = 0
    Top = 29
    Width = 205
    Height = 309
    Align = alLeft
    BorderStyle = bsNone
    DefaultNodeHeight = 19
    DragOperations = [doMove]
    DragType = dtVCL
    Header.AutoSizeIndex = 0
    Header.MainColumn = -1
    TabOrder = 1
    TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowTreeLines, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toRightClickSelect]
    OnFocusChanged = stAlbumsFocusChanged
    Columns = <>
  end
  object tbToolbar: TToolBar
    Left = 0
    Top = 0
    Width = 651
    Height = 29
    Caption = 'ToolBar1'
    TabOrder = 2
    object ToolButton1: TToolButton
      Left = 0
      Top = 0
      Action = acNewAlbum
    end
  end
  object vilIcons: TVirtualImageList
    AutoFill = True
    DisabledGrayscale = False
    DisabledSuffix = '_Disabled'
    Images = <
      item
        CollectionIndex = 0
        CollectionName = '000_Menu'
        Disabled = False
        Name = '000_Menu'
      end
      item
        CollectionIndex = 1
        CollectionName = '001_Home'
        Disabled = False
        Name = '001_Home'
      end
      item
        CollectionIndex = 2
        CollectionName = '002_Settings'
        Disabled = False
        Name = '002_Settings'
      end
      item
        CollectionIndex = 3
        CollectionName = '003_Gallery'
        Disabled = False
        Name = '003_Gallery'
      end
      item
        CollectionIndex = 4
        CollectionName = '004_FilmRoll'
        Disabled = False
        Name = '004_FilmRoll'
      end
      item
        CollectionIndex = 5
        CollectionName = '005_Thumbnails'
        Disabled = False
        Name = '005_Thumbnails'
      end
      item
        CollectionIndex = 6
        CollectionName = '006_List'
        Disabled = False
        Name = '006_List'
      end
      item
        CollectionIndex = 7
        CollectionName = '007_Full_Image'
        Disabled = False
        Name = '007_Full_Image'
      end
      item
        CollectionIndex = 8
        CollectionName = '008_Delete'
        Disabled = False
        Name = '008_Delete'
      end
      item
        CollectionIndex = 9
        CollectionName = '009_Edit'
        Disabled = False
        Name = '009_Edit'
      end
      item
        CollectionIndex = 10
        CollectionName = '010_Add_To_Album'
        Disabled = False
        Name = '010_Add_To_Album'
      end>
    ImageCollection = dmCommon.icDarkIcons
    Width = 24
    Height = 24
    Left = 23
    Top = 85
  end
  object alActions: TActionList
    Images = vilIcons
    Left = 68
    Top = 84
    object acNewAlbum: TAction
      OnExecute = acNewAlbumExecute
    end
  end
end
