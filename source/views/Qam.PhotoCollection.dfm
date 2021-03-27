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
    DefaultNodeHeight = 17
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
    TreeOptions.VETShellOptions = [toContextMenus]
    TreeOptions.VETSyncOptions = [toCollapseTargetFirst, toExpandTarget, toSelectTarget]
    TreeOptions.VETMiscOptions = [toBrowseExecuteFolder, toBrowseExecuteFolderShortcut, toBrowseExecuteZipFolder, toChangeNotifierThread, toRemoveContextMenuShortCut]
    TreeOptions.VETImageOptions = [toImages, toThreadedImages, toMarkCutAndCopy]
    OnChange = vetFoldersChange
    Columns = <>
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 786
    Height = 29
    Caption = 'ToolBar1'
    TabOrder = 1
    object ToolButton1: TToolButton
      Left = 0
      Top = 0
      Caption = 'ToolButton1'
      ImageIndex = 0
    end
    object ToolButton2: TToolButton
      Left = 23
      Top = 0
      Caption = 'ToolButton2'
      ImageIndex = 1
    end
    object cbView: TComboBox
      Left = 46
      Top = 0
      Width = 145
      Height = 21
      Style = csDropDownList
      TabOrder = 0
      OnChange = cbViewChange
    end
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
    TabOrder = 2
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
      ExplorerTreeview = vetFolders
      FileObjects = [foNonFolders]
      FileSizeFormat = vfsfDefault
      Grouped = False
      GroupingColumn = 0
      Header.Visible = True
      PaintInfoGroup.MarginBottom.CaptionIndent = 4
      PaintInfoGroup.MarginTop.Visible = False
      Sort.Algorithm = esaQuickSort
      Sort.AutoSort = True
      TabOrder = 0
      ThumbsManager.StorageFilename = 'QamTrails.album'
      ThumbsManager.UseExifOrientation = False
      View = elsThumbnail
      OnEnumFolder = velFotosEnumFolder
      OnItemSelectionChanged = velFotosItemSelectionChanged
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
end
