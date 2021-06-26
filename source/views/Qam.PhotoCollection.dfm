object wPhotoCollection: TwPhotoCollection
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Fotosammlung'
  ClientHeight = 454
  ClientWidth = 786
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 200
    Top = 29
    Height = 425
    ExplicitLeft = 392
    ExplicitTop = 176
    ExplicitHeight = 100
  end
  object vetFolders: TVirtualExplorerTreeview
    Left = 0
    Top = 29
    Width = 200
    Height = 425
    Active = False
    Align = alLeft
    BorderStyle = bsNone
    ColumnDetails = cdUser
    DefaultNodeHeight = 19
    DragHeight = 250
    DragWidth = 150
    FileObjects = [foFolders, foHidden, foEnableAsync]
    FileSizeFormat = fsfExplorer
    FileSort = fsFileType
    Header.AutoSizeIndex = 0
    Header.Height = 17
    Header.MainColumn = -1
    HintMode = hmHint
    ParentColor = False
    RootFolder = rfDesktop
    TabOrder = 0
    TabStop = True
    TreeOptions.AutoOptions = [toAutoScroll, toAutoChangeScale]
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toToggleOnDblClick]
    TreeOptions.PaintOptions = [toHideSelection, toShowButtons, toShowTreeLines, toUseBlendedImages, toGhostedIfUnfocused]
    TreeOptions.SelectionOptions = [toLevelSelectConstraint]
    TreeOptions.VETShellOptions = []
    TreeOptions.VETSyncOptions = [toCollapseTargetFirst, toExpandTarget, toSelectTarget]
    TreeOptions.VETMiscOptions = [toBrowseExecuteFolder, toBrowseExecuteFolderShortcut, toBrowseExecuteZipFolder, toChangeNotifierThread, toRemoveContextMenuShortCut]
    TreeOptions.VETImageOptions = [toImages, toThreadedImages, toMarkCutAndCopy]
    OnChange = vetFoldersChange
    OnEnumFolder = vetFoldersEnumFolder
    Columns = <>
  end
  object pnContent: TPanel
    Left = 203
    Top = 29
    Width = 583
    Height = 425
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pnContent'
    ShowCaption = False
    TabOrder = 1
    object velFotos: TVirtualExplorerEasyListview
      Left = 0
      Top = 0
      Width = 583
      Height = 152
      Align = alClient
      BorderStyle = bsNone
      CompressedFile.Color = clRed
      CompressedFile.Font.Charset = DEFAULT_CHARSET
      CompressedFile.Font.Color = clWindowText
      CompressedFile.Font.Height = -11
      CompressedFile.Font.Name = 'Tahoma'
      CompressedFile.Font.Style = []
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
      DragManager.DragMode = dmAutomatic
      DragManager.Enabled = True
      ExplorerTreeview = vetFolders
      FileObjects = [foNonFolders]
      FileSizeFormat = vfsfDefault
      Grouped = True
      GroupingColumn = 0
      OnRebuiltShellHeader = velFotosRebuiltShellHeader
      PaintInfoGroup.BandColor = clHighlight
      PaintInfoGroup.BandFullWidth = True
      PaintInfoGroup.BandThickness = 2
      PaintInfoGroup.MarginBottom.CaptionIndent = 4
      PaintInfoGroup.MarginTop.Visible = False
      PaintInfoItem.CheckType = ectBox
      PaintInfoItem.HideCaption = True
      ShowGroupMargins = True
      ShowThemedBorder = False
      Sort.Algorithm = esaQuickSort
      Sort.AutoSort = True
      Selection.MultiSelect = True
      TabOrder = 0
      ThumbsManager.StorageFilename = 'QamTrails.album'
      ThumbsManager.UseExifOrientation = False
      View = elsThumbnail
      OnCustomGroup = velFotosCustomGroup
      OnEnumFolder = velFotosEnumFolder
      OnGroupCompare = velFotosGroupCompare
      OnItemCheckChange = velFotosItemCheckChange
      OnItemInitialize = velFotosItemInitialize
      OnItemSelectionChanged = velFotosItemSelectionChanged
      OnOLEDragStart = velFotosOLEDragStart
    end
    object pnPreview: TPanel
      Left = 0
      Top = 152
      Width = 583
      Height = 273
      Align = alBottom
      BevelOuter = bvNone
      Caption = 'pnPreview'
      ShowCaption = False
      TabOrder = 1
    end
  end
  object tbToolbar: TToolBar
    Left = 0
    Top = 0
    Width = 786
    Height = 29
    ButtonHeight = 30
    ButtonWidth = 31
    Caption = 'tbToolbar'
    EdgeBorders = [ebBottom]
    Images = vilIcons
    TabOrder = 2
    object tbViewThumbnails: TToolButton
      Left = 0
      Top = 0
      Action = acViewThumbnails
      Style = tbsCheck
    end
    object tbViewPreview: TToolButton
      Left = 31
      Top = 0
      Action = acViewPreview
      Style = tbsCheck
    end
    object tbViewDetails: TToolButton
      Left = 62
      Top = 0
      Action = acViewDetails
      Style = tbsCheck
    end
    object tbDivider1: TToolButton
      Left = 93
      Top = 0
      Width = 8
      Caption = 'tbDivider1'
      Style = tbsSeparator
    end
    object tbNewFolder: TToolButton
      Left = 101
      Top = 0
      Action = acNewFolder
    end
    object ToolButton1: TToolButton
      Left = 132
      Top = 0
      Width = 8
      Caption = 'ToolButton1'
      ImageIndex = 12
      ImageName = '012_Remove_From_Album'
      Style = tbsSeparator
    end
    object cbAlbums: TComboBox
      Left = 140
      Top = 0
      Width = 145
      Height = 21
      Align = alCustom
      Style = csDropDownList
      TabOrder = 0
      OnChange = cbAlbumsChange
    end
    object tbAddToActiveAlbum: TToolButton
      Left = 285
      Top = 0
      Action = acAddToActiveAlbum
    end
    object tbRotateLeft: TToolButton
      Left = 316
      Top = 0
      Action = acRotateLeft
    end
    object tbRotateRight: TToolButton
      Left = 347
      Top = 0
      Action = acRotateRight
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
        CollectionName = '008_Add_Gallery'
        Disabled = False
        Name = '008_Add_Gallery'
      end
      item
        CollectionIndex = 9
        CollectionName = '009_Delete'
        Disabled = False
        Name = '009_Delete'
      end
      item
        CollectionIndex = 10
        CollectionName = '010_Edit'
        Disabled = False
        Name = '010_Edit'
      end
      item
        CollectionIndex = 11
        CollectionName = '011_Add_To_Album'
        Disabled = False
        Name = '011_Add_To_Album'
      end
      item
        CollectionIndex = 12
        CollectionName = '012_Remove_From_Album'
        Disabled = False
        Name = '012_Remove_From_Album'
      end
      item
        CollectionIndex = 13
        CollectionName = '013_Add_Folder'
        Disabled = False
        Name = '013_Add_Folder'
      end
      item
        CollectionIndex = 14
        CollectionName = '014_Rotate_Left'
        Disabled = False
        Name = '014_Rotate_Left'
      end
      item
        CollectionIndex = 15
        CollectionName = '015_Rotate_Right'
        Disabled = False
        Name = '015_Rotate_Right'
      end>
    ImageCollection = dmCommon.icDarkIcons
    Width = 24
    Height = 24
    Left = 23
    Top = 85
  end
  object alActions: TActionList
    Images = vilIcons
    Left = 72
    Top = 84
    object acViewThumbnails: TAction
      Checked = True
      GroupIndex = 1
      Hint = 'Ansicht als Raster'
      ImageIndex = 5
      ImageName = '005_Thumbnails'
      OnExecute = acViewThumbnailsExecute
    end
    object acViewPreview: TAction
      GroupIndex = 1
      Hint = 'Vorschau-Ansicht'
      ImageIndex = 7
      ImageName = '007_Full_Image'
      OnExecute = acViewPreviewExecute
    end
    object acViewDetails: TAction
      GroupIndex = 1
      Hint = 'Detail-Ansicht'
      ImageIndex = 6
      ImageName = '006_List'
      OnExecute = acViewDetailsExecute
    end
    object acAddToActiveAlbum: TAction
      Caption = 'acAddToActiveAlbum'
      Hint = 'Dem aktuellen Album hinzuf'#252'gen'
      ImageIndex = 11
      ImageName = '011_Add_To_Album'
      ShortCut = 45
      OnExecute = acAddToActiveAlbumExecute
    end
    object acNewFolder: TAction
      Caption = 'Neuer Ordner'
      ImageIndex = 13
      ImageName = '013_Add_Folder'
      OnExecute = acNewFolderExecute
    end
    object acRotateLeft: TAction
      Caption = '90'#176' nach links'
      ImageIndex = 14
      ImageName = '014_Rotate_Left'
      OnExecute = acRotateLeftExecute
    end
    object acRotateRight: TAction
      Caption = '90'#176' nach rechts'
      ImageIndex = 15
      ImageName = '015_Rotate_Right'
      OnExecute = acRotateRightExecute
    end
  end
end
