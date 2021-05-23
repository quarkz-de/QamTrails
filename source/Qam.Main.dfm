object wMain: TwMain
  Left = 0
  Top = 0
  Caption = 'QamTrails'
  ClientHeight = 600
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
  OldCreateOrder = False
  ShowHint = True
  StyleElements = [seFont, seClient]
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 20
  object svSplitView: TSplitView
    Left = 0
    Top = 30
    Width = 170
    Height = 570
    BevelEdges = [beRight]
    BevelKind = bkTile
    CloseStyle = svcCompact
    CompactWidth = 42
    OpenedWidth = 170
    Placement = svpLeft
    TabOrder = 0
    OnClosed = svSplitViewClosed
    OnOpened = svSplitViewOpened
    object pnHeader: TPanel
      Left = 0
      Top = 0
      Width = 168
      Height = 45
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitWidth = 170
      object imBurgerButton: TVirtualImage
        Left = 6
        Top = 6
        Width = 32
        Height = 32
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = 0
        OnClick = imBurgerButtonClick
      end
      object txHeaderText: TLabel
        Left = 52
        Top = 6
        Width = 91
        Height = 30
        Caption = 'QamTrails'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
    end
    object pnNavigation: TPanel
      Left = 0
      Top = 45
      Width = 168
      Height = 525
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitWidth = 170
      object sbStart: TSpeedButton
        Left = 0
        Top = 0
        Width = 168
        Height = 38
        Action = acSectionWelcome
        Align = alTop
        GroupIndex = 1
        Images = vilLargeIcons
        Flat = True
        Margin = 6
        ExplicitTop = -6
        ExplicitWidth = 200
      end
      object sbSettings: TSpeedButton
        Left = 0
        Top = 487
        Width = 168
        Height = 38
        Action = acSectionSettings
        Align = alBottom
        GroupIndex = 1
        Images = vilLargeIcons
        Flat = True
        Margin = 6
        ExplicitTop = 4
        ExplicitWidth = 200
      end
      object SpeedButton1: TSpeedButton
        Left = 0
        Top = 38
        Width = 168
        Height = 38
        Action = acSectionPhotoCollection
        Align = alTop
        GroupIndex = 1
        Images = vilLargeIcons
        Flat = True
        Margin = 6
        ExplicitTop = 64
        ExplicitWidth = 170
      end
      object sbAlben: TSpeedButton
        Left = 0
        Top = 76
        Width = 168
        Height = 38
        Action = acSectionPhotoAlbums
        Align = alTop
        GroupIndex = 1
        Images = vilLargeIcons
        Flat = True
        Margin = 6
        ExplicitTop = 120
        ExplicitWidth = 170
      end
    end
  end
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
  object vilLargeIcons: TVirtualImageList
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
    Left = 476
    Top = 40
  end
end
