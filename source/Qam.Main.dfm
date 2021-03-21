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
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  GlassFrame.Enabled = True
  GlassFrame.Top = 31
  OldCreateOrder = False
  StyleElements = [seFont, seClient]
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object svSplitView: TSplitView
    Left = 0
    Top = 30
    Width = 170
    Height = 570
    CloseStyle = svcCompact
    CompactWidth = 42
    OpenedWidth = 170
    Placement = svpLeft
    TabOrder = 0
    object pnHeader: TPanel
      Left = 0
      Top = 0
      Width = 170
      Height = 45
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
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
        Top = 12
        Width = 70
        Height = 21
        Caption = 'QamTrails'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object txVersion: TLabel
        Left = 136
        Top = 16
        Width = 16
        Height = 13
        Caption = '1.0'
      end
    end
    object pnNavigation: TPanel
      Left = 0
      Top = 45
      Width = 170
      Height = 525
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object sbStart: TSpeedButton
        Left = 0
        Top = 0
        Width = 170
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
        Width = 170
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
      Width = 257
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
      end>
    ImageCollection = dmCommon.icLightIcons
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
      end>
    ImageCollection = dmCommon.icDarkIcons
    Left = 476
    Top = 40
  end
end
