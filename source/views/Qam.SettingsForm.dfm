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
  object cbTheme: TComboBox
    Left = 124
    Top = 21
    Width = 145
    Height = 21
    Style = csDropDownList
    TabOrder = 0
    OnChange = cbThemeChange
  end
end
