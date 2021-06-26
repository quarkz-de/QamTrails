object frPhotoViewer: TfrPhotoViewer
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object imPhoto: TImgView32
    Left = 0
    Top = 0
    Width = 320
    Height = 240
    Align = alClient
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baCustom
    Scale = 1.000000000000000000
    ScaleMode = smOptimalScaled
    ScrollBars.ShowHandleGrip = True
    ScrollBars.Style = rbsDefault
    ScrollBars.Size = 17
    OverSize = 0
    TabOrder = 0
  end
end
