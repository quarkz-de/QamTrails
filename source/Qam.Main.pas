unit Qam.Main;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.ImageList,
  System.Actions,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ImgList,
  Vcl.VirtualImageList, Vcl.Buttons, Vcl.StdCtrls, Vcl.VirtualImage,
  Vcl.ExtCtrls, Vcl.WinXCtrls, Vcl.PlatformDefaultStyleActnCtrls,
  Vcl.ActnMan, Vcl.ToolWin, Vcl.ActnCtrls, Vcl.ActnMenus, Vcl.TitleBarCtrls,
  Vcl.ActnList, Vcl.StdActns,
  Eventbus,
  Qam.Events, Qam.Forms;

type
  TwMain = class(TForm)
    vilLargeIcons: TVirtualImageList;
    svSplitView: TSplitView;
    pnHeader: TPanel;
    imBurgerButton: TVirtualImage;
    txHeaderText: TLabel;
    txVersion: TLabel;
    pnNavigation: TPanel;
    sbStart: TSpeedButton;
    sbSettings: TSpeedButton;
    amActions: TActionManager;
    acFileExit: TFileExit;
    acHelpAbout: TAction;
    acSectionWelcome: TAction;
    acSectionSettings: TAction;
    tbpTitleBar: TTitleBarPanel;
    mbMain: TActionMainMenuBar;
    vilIcons: TVirtualImageList;
    procedure FormCreate(Sender: TObject);
    procedure imBurgerButtonClick(Sender: TObject);
    procedure mbMainPaint(Sender: TObject);
    procedure acSectionWelcomeExecute(Sender: TObject);
    procedure acSectionSettingsExecute(Sender: TObject);
    procedure acHelpAboutExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure svSplitViewClosed(Sender: TObject);
    procedure svSplitViewOpened(Sender: TObject);
  private
    FForms: TApplicationFormList;
    procedure InitSettings;
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
  protected
    property Forms: TApplicationFormList read FForms;
  public
    [Subscribe]
    procedure OnThemeChange(AEvent: IThemeChangeEvent);
  end;

var
  wMain: TwMain;

implementation

{$R *.dfm}

uses
  Qam.DataModule, Qam.Settings, Qam.About;

{ TwMain }

procedure TwMain.acHelpAboutExecute(Sender: TObject);
begin
  TwAbout.ExecuteDialog;
end;

procedure TwMain.acSectionSettingsExecute(Sender: TObject);
begin
  FForms.ShowForm(qftSettings);
end;

procedure TwMain.acSectionWelcomeExecute(Sender: TObject);
begin
  FForms.ShowForm(qftWelcome);
end;

procedure TwMain.FormCreate(Sender: TObject);
begin
  FForms := TApplicationFormList.Create(self);
  acSectionWelcome.Execute;
  GlobalEventBus.RegisterSubscriberForEvents(Self);
  dmCommon.MainFormCreated;
  InitSettings;
end;

procedure TwMain.FormDestroy(Sender: TObject);
begin
  ApplicationSettings.FormPosition.SavePosition(self);
  FForms.Free;
end;

procedure TwMain.imBurgerButtonClick(Sender: TObject);
begin
  svSplitView.Opened := not svSplitView.Opened;
end;

procedure TwMain.InitSettings;
begin
  ApplicationSettings.FormPosition.LoadPosition(self);
  svSplitView.Opened := ApplicationSettings.DrawerOpened;
end;

procedure TwMain.mbMainPaint(Sender: TObject);
var
  Color: TColor;
begin
  if CustomTitleBar.Enabled and not CustomTitleBar.SystemColors then
    begin
      if Active then
        Color := CustomTitleBar.BackgroundColor
      else
        Color := CustomTitleBar.InactiveBackgroundColor;
      mbMain.Canvas.Brush.Color := Color;
      mbMain.Canvas.FillRect(mbMain.ClientRect);
    end;
end;

procedure TwMain.OnThemeChange(AEvent: IThemeChangeEvent);
begin
  CustomTitleBar.SystemColors := AEvent.ThemeName = 'Windows';
  mbMain.Invalidate;
  imBurgerButton.ImageCollection := dmCommon.GetImageCollection;
  vilIcons.ImageCollection := dmCommon.GetImageCollection;
  vilLargeIcons.ImageCollection := dmCommon.GetImageCollection;
end;

procedure TwMain.svSplitViewClosed(Sender: TObject);
begin
  ApplicationSettings.DrawerOpened := false;
end;

procedure TwMain.svSplitViewOpened(Sender: TObject);
begin
  ApplicationSettings.DrawerOpened := true;
end;

procedure TwMain.WMActivate(var Message: TWMActivate);
begin
  inherited;
  if CustomTitleBar.Enabled and Assigned(mbMain) then
    mbMain.Invalidate;
end;

procedure TwMain.WMSize(var Message: TWMSize);
begin
  inherited;
  if Assigned(mbMain) then
    begin
      case Message.SizeType of
        SIZE_MAXIMIZED:
          mbMain.Top := 0;
        SIZE_RESTORED:
          mbMain.Top := (CustomTitleBar.Height - mbMain.Height) div 2;
      end;
    end;
end;

end.
