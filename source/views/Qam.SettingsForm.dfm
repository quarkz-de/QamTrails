object wSettingsForm: TwSettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 468
  ClientWidth = 777
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object txTheme: TLabel
    Left = 20
    Top = 24
    Width = 32
    Height = 13
    Caption = 'Thema'
  end
  object txMainCollectionFolderLabel: TLabel
    Left = 20
    Top = 56
    Width = 69
    Height = 13
    Caption = 'Fotosammlung'
  end
  object txMainCollectionFolder: TLabel
    Left = 124
    Top = 56
    Width = 108
    Height = 13
    Caption = 'txMainCollectionFolder'
  end
  object cbTheme: TComboBox
    Left = 124
    Top = 21
    Width = 145
    Height = 21
    Style = csDropDownList
    TabOrder = 0
    OnChange = cbThemeChange
  end
  object btSelectFolder: TButton
    Left = 124
    Top = 83
    Width = 75
    Height = 25
    Caption = 'Auswahl'
    TabOrder = 1
    OnClick = btSelectFolderClick
  end
  object dSelectFolder: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = [fdoPickFolders]
    Left = 204
    Top = 80
  end
end
