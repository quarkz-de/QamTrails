object wMain: TwMain
  Left = 0
  Top = 0
  Caption = 'QamTrails'
  ClientHeight = 507
  ClientWidth = 909
  Color = clBtnFace
  CustomTitleBar.CaptionAlignment = taCenter
  CustomTitleBar.Control = tbpTitleBar
  CustomTitleBar.Enabled = True
  CustomTitleBar.Height = 31
  CustomTitleBar.BackgroundColor = 14123008
  CustomTitleBar.ForegroundColor = clWhite
  CustomTitleBar.InactiveBackgroundColor = clWhite
  CustomTitleBar.InactiveForegroundColor = 10066329
  CustomTitleBar.ButtonForegroundColor = clWhite
  CustomTitleBar.ButtonBackgroundColor = 14123008
  CustomTitleBar.ButtonHoverForegroundColor = clWhite
  CustomTitleBar.ButtonHoverBackgroundColor = 11364608
  CustomTitleBar.ButtonPressedForegroundColor = clWhite
  CustomTitleBar.ButtonPressedBackgroundColor = 7160320
  CustomTitleBar.ButtonInactiveForegroundColor = 10066329
  CustomTitleBar.ButtonInactiveBackgroundColor = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Segoe UI'
  Font.Style = []
  GlassFrame.Enabled = True
  GlassFrame.Top = 31
  ShowHint = True
  StyleElements = [seFont, seClient]
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 20
  object tbpTitleBar: TTitleBarPanel
    Left = 0
    Top = 0
    Width = 909
    Height = 30
    CustomButtons = <>
    object mbMain: TActionMainMenuBar
      Left = 32
      Top = 0
      Width = 90
      Height = 24
      UseSystemFont = False
      ActionManager = amActions
      Align = alNone
      Caption = 'mbMain'
      Color = clMenuBar
      ColorMap.DisabledFontColor = 7171437
      ColorMap.HighlightColor = clWhite
      ColorMap.BtnSelectedFont = clBlack
      ColorMap.UnusedColor = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      Spacing = 0
      OnPaint = mbMainPaint
    end
  end
  object svSplitView: TSplitView
    Left = 0
    Top = 30
    Width = 170
    Height = 477
    CloseStyle = svcCompact
    CompactWidth = 60
    OpenedWidth = 170
    Placement = svpLeft
    TabOrder = 1
    OnClosed = svSplitViewClosed
    OnOpened = svSplitViewOpened
    ExplicitLeft = 4
    ExplicitTop = 34
    ExplicitHeight = 403
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 170
      Height = 45
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object imBurgerButton: TVirtualImage
        Left = 15
        Top = 6
        Width = 32
        Height = 32
        ImageCollection = dmCommon.icDarkIcons
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = 0
        ImageName = '000_Menu'
        OnClick = imBurgerButton1Click
      end
    end
    object nvNavigation: TQzNavigationView
      Left = 0
      Top = 45
      Width = 170
      Height = 383
      Align = alClient
      BorderStyle = bsNone
      ButtonHeight = 48
      ButtonOptions = [nboAllowReorder, nboGroupStyle, nboShowCaptions]
      Images = vilLargeIcons
      Items = <
        item
          Action = acSectionWelcome
          AllowReorder = False
        end
        item
          Action = acSectionPhotoCollection
        end
        item
          Action = acSectionPhotoAlbums
        end>
      ItemIndex = 0
      TabOrder = 1
      OnButtonClicked = nvNavigationButtonClicked
      ExplicitTop = 50
    end
    object nvFooter: TQzNavigationView
      Left = 0
      Top = 428
      Width = 170
      Height = 49
      Align = alBottom
      BorderStyle = bsNone
      ButtonHeight = 48
      ButtonOptions = [nboGroupStyle, nboShowCaptions]
      Images = vilLargeIcons
      Items = <
        item
          Action = acSectionSettings
        end>
      TabOrder = 2
      OnButtonClicked = nvFooterButtonClicked
      ExplicitLeft = 4
    end
  end
  object vilLargeIcons: TVirtualImageList
    AutoFill = True
    Images = <
      item
        CollectionIndex = 0
        CollectionName = '000_Menu'
        Name = '000_Menu'
      end
      item
        CollectionIndex = 1
        CollectionName = '001_Home'
        Name = '001_Home'
      end
      item
        CollectionIndex = 2
        CollectionName = '002_Settings'
        Name = '002_Settings'
      end
      item
        CollectionIndex = 3
        CollectionName = '003_Gallery'
        Name = '003_Gallery'
      end
      item
        CollectionIndex = 4
        CollectionName = '004_FilmRoll'
        Name = '004_FilmRoll'
      end
      item
        CollectionIndex = 5
        CollectionName = '005_Thumbnails'
        Name = '005_Thumbnails'
      end
      item
        CollectionIndex = 6
        CollectionName = '006_List'
        Name = '006_List'
      end
      item
        CollectionIndex = 7
        CollectionName = '007_Full_Image'
        Name = '007_Full_Image'
      end
      item
        CollectionIndex = 8
        CollectionName = '008_Add_Gallery'
        Name = '008_Add_Gallery'
      end
      item
        CollectionIndex = 9
        CollectionName = '009_Delete'
        Name = '009_Delete'
      end
      item
        CollectionIndex = 10
        CollectionName = '010_Edit'
        Name = '010_Edit'
      end
      item
        CollectionIndex = 11
        CollectionName = '011_Add_To_Album'
        Name = '011_Add_To_Album'
      end
      item
        CollectionIndex = 12
        CollectionName = '012_Remove_From_Album'
        Name = '012_Remove_From_Album'
      end
      item
        CollectionIndex = 13
        CollectionName = '013_Add_Folder'
        Name = '013_Add_Folder'
      end
      item
        CollectionIndex = 14
        CollectionName = '014_Rotate_Left'
        Name = '014_Rotate_Left'
      end
      item
        CollectionIndex = 15
        CollectionName = '015_Rotate_Right'
        Name = '015_Rotate_Right'
      end>
    ImageCollection = dmCommon.icDarkIcons
    Width = 32
    Height = 32
    Left = 524
    Top = 40
  end
  object amActions: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Items = <
              item
                Caption = '-'
              end
              item
                Action = acFileExit
              end>
            Caption = '&Datei'
          end
          item
            Items = <
              item
                Action = acHelpAbout
              end>
            Caption = '&Hilfe'
          end>
        ActionBar = mbMain
      end>
    Images = vilIcons
    Left = 424
    Top = 40
    StyleName = 'Platform Default'
    object acFileExit: TFileExit
      Category = 'Datei'
      Caption = '&Beenden'
      Hint = 'Beenden|Anwendung beenden'
    end
    object acHelpAbout: TAction
      Category = 'Hilfe'
      Caption = '&'#220'ber...'
      OnExecute = acHelpAboutExecute
    end
    object acSectionWelcome: TAction
      Category = 'Bereich'
      AutoCheck = True
      Caption = 'Startseite'
      GroupIndex = 1
      ImageIndex = 1
      ImageName = '001_Home'
      OnExecute = acSectionWelcomeExecute
    end
    object acSectionSettings: TAction
      Category = 'Bereich'
      Caption = 'Einstellungen'
      GroupIndex = 1
      ImageIndex = 2
      ImageName = '002_Settings'
      OnExecute = acSectionSettingsExecute
    end
    object acSectionPhotoCollection: TAction
      Category = 'Bereich'
      Caption = 'Fotosammlung'
      GroupIndex = 1
      ImageIndex = 4
      ImageName = '004_FilmRoll'
      OnExecute = acSectionPhotoCollectionExecute
    end
    object acSectionPhotoAlbums: TAction
      Category = 'Bereich'
      Caption = 'Alben'
      GroupIndex = 1
      ImageIndex = 3
      ImageName = '003_Gallery'
      OnExecute = acSectionPhotoAlbumsExecute
    end
  end
  object vilIcons: TVirtualImageList
    AutoFill = True
    Images = <
      item
        CollectionIndex = 0
        CollectionName = '000_Menu'
        Name = '000_Menu'
      end
      item
        CollectionIndex = 1
        CollectionName = '001_Home'
        Name = '001_Home'
      end
      item
        CollectionIndex = 2
        CollectionName = '002_Settings'
        Name = '002_Settings'
      end
      item
        CollectionIndex = 3
        CollectionName = '003_Gallery'
        Name = '003_Gallery'
      end
      item
        CollectionIndex = 4
        CollectionName = '004_FilmRoll'
        Name = '004_FilmRoll'
      end
      item
        CollectionIndex = 5
        CollectionName = '005_Thumbnails'
        Name = '005_Thumbnails'
      end
      item
        CollectionIndex = 6
        CollectionName = '006_List'
        Name = '006_List'
      end
      item
        CollectionIndex = 7
        CollectionName = '007_Full_Image'
        Name = '007_Full_Image'
      end
      item
        CollectionIndex = 8
        CollectionName = '008_Add_Gallery'
        Name = '008_Add_Gallery'
      end
      item
        CollectionIndex = 9
        CollectionName = '009_Delete'
        Name = '009_Delete'
      end
      item
        CollectionIndex = 10
        CollectionName = '010_Edit'
        Name = '010_Edit'
      end
      item
        CollectionIndex = 11
        CollectionName = '011_Add_To_Album'
        Name = '011_Add_To_Album'
      end
      item
        CollectionIndex = 12
        CollectionName = '012_Remove_From_Album'
        Name = '012_Remove_From_Album'
      end
      item
        CollectionIndex = 13
        CollectionName = '013_Add_Folder'
        Name = '013_Add_Folder'
      end
      item
        CollectionIndex = 14
        CollectionName = '014_Rotate_Left'
        Name = '014_Rotate_Left'
      end
      item
        CollectionIndex = 15
        CollectionName = '015_Rotate_Right'
        Name = '015_Rotate_Right'
      end>
    ImageCollection = dmCommon.icDarkIcons
    Left = 476
    Top = 40
  end
end
