object wAlbumSelector: TwAlbumSelector
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'wAlbumSelector'
  ClientHeight = 236
  ClientWidth = 332
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 332
    Height = 236
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    object edSuche: TSearchBox
      Left = 8
      Top = 8
      Width = 121
      Height = 21
      TabOrder = 0
      TextHint = 'Suche...'
    end
    object btSelect: TButton
      Left = 135
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Ausw'#228'hlen'
      TabOrder = 1
      OnClick = btSelectClick
    end
    object btNewAlbum: TButton
      Left = 248
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Neues Album'
      TabOrder = 2
      OnClick = btNewAlbumClick
    end
    object stAlbums: TVirtualStringTree
      Left = 8
      Top = 35
      Width = 315
      Height = 190
      BorderStyle = bsNone
      DefaultNodeHeight = 19
      DragOperations = [doMove]
      DragType = dtVCL
      Header.AutoSizeIndex = 0
      Header.MainColumn = -1
      TabOrder = 3
      TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowTreeLines, toThemeAware, toUseBlendedImages]
      TreeOptions.SelectionOptions = [toRightClickSelect]
      OnDblClick = stAlbumsDblClick
      Columns = <>
    end
  end
end
