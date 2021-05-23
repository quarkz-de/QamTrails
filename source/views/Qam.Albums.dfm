object wAlbums: TwAlbums
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'wAlbums'
  ClientHeight = 338
  ClientWidth = 651
  Color = clBtnFace
  ParentFont = True
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
  object stAlbums: TVirtualStringTree
    Left = 0
    Top = 29
    Width = 205
    Height = 309
    Align = alLeft
    BorderStyle = bsNone
    DefaultNodeHeight = 32
    DragOperations = [doMove]
    DragType = dtVCL
    Header.AutoSizeIndex = 0
    Header.MainColumn = -1
    TabOrder = 0
    TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowTreeLines, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
    OnFocusChanged = stAlbumsFocusChanged
    Columns = <>
  end
  object tbToolbar: TToolBar
    Left = 0
    Top = 0
    Width = 651
    Height = 29
    ButtonHeight = 30
    ButtonWidth = 31
    Caption = 'ToolBar1'
    EdgeBorders = [ebBottom]
    Images = vilIcons
    TabOrder = 1
    object btNewAlbum: TToolButton
      Left = 0
      Top = 0
      Action = acNewAlbum
    end
    object btDeleteAlbum: TToolButton
      Left = 31
      Top = 0
      Action = acDeleteAlbum
    end
  end
  object velFotos: TVirtualMultiPathExplorerEasyListview
    Left = 208
    Top = 29
    Width = 443
    Height = 309
    Align = alClient
    BorderStyle = bsNone
    CompressedFile.Color = clRed
    CompressedFile.Font.Charset = DEFAULT_CHARSET
    CompressedFile.Font.Color = clWindowText
    CompressedFile.Font.Height = -11
    CompressedFile.Font.Name = 'Tahoma'
    CompressedFile.Font.Style = []
    Ctl3D = True
    DefaultSortColumn = 0
    EditManager.Font.Charset = DEFAULT_CHARSET
    EditManager.Font.Color = clWindowText
    EditManager.Font.Height = -11
    EditManager.Font.Name = 'Tahoma'
    EditManager.Font.Style = []
    EncryptedFile.Color = 32832
    EncryptedFile.Font.Charset = DEFAULT_CHARSET
    EncryptedFile.Font.Color = clWindowText
    EncryptedFile.Font.Height = -11
    EncryptedFile.Font.Name = 'Tahoma'
    EncryptedFile.Font.Style = []
    FileSizeFormat = vfsfDefault
    DragManager.DragMode = dmAutomatic
    DragManager.Enabled = True
    Grouped = False
    GroupingColumn = 0
    PaintInfoGroup.MarginBottom.CaptionIndent = 4
    PaintInfoGroup.MarginTop.Visible = False
    ParentCtl3D = False
    ShowThemedBorder = False
    Sort.Algorithm = esaQuickSort
    Sort.AutoSort = True
    Selection.MultiSelect = True
    TabOrder = 2
    ThumbsManager.StorageFilename = 'Thumbnails.album'
    ThumbsManager.UseExifOrientation = False
    View = elsThumbnail
    OnKeyAction = velFotosKeyAction
    OnOLEDragEnter = velFotosOLEDragEnter
    OnOLEDragDrop = velFotosOLEDragDrop
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
        CollectionName = '008_Add_Gallery'
        Disabled = False
        Name = '008_Add_Gallery'
      end
      item
        CollectionIndex = 9
        CollectionName = '008_Delete'
        Disabled = False
        Name = '008_Delete'
      end
      item
        CollectionIndex = 10
        CollectionName = '009_Edit'
        Disabled = False
        Name = '009_Edit'
      end
      item
        CollectionIndex = 11
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
      ImageIndex = 8
      ImageName = '008_Add_Gallery'
      OnExecute = acNewAlbumExecute
    end
    object acDeleteAlbum: TAction
      Caption = 'acDeleteAlbum'
      ImageIndex = 9
      ImageName = '008_Delete'
      OnExecute = acDeleteAlbumExecute
    end
  end
end
