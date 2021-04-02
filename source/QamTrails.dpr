program QamTrails;

uses
  Spring.Container,
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  Vcl.Styles.Hooks,
  Vcl.Styles.UxTheme,
  Vcl.Styles.Utils.Menus,
  Vcl.Styles.Utils.Forms,
  Vcl.Styles.Utils.ComCtrls,
  Vcl.Styles.Utils.ScreenTips,
  Qam.Main in 'Qam.Main.pas' {wMain},
  Qam.DataModule in 'Qam.DataModule.pas' {dmCommon: TDataModule},
  Qam.Events in 'core\Qam.Events.pas',
  Qam.Settings in 'core\Qam.Settings.pas',
  Qam.About in 'views\Qam.About.pas' {wAbout},
  Qam.Forms in 'views\Qam.Forms.pas',
  Qam.SettingsForm in 'views\Qam.SettingsForm.pas' {wSettingsForm},
  Qam.WelcomeForm in 'views\Qam.WelcomeForm.pas' {wWelcomeForm},
  Qam.PhotoCollection in 'views\Qam.PhotoCollection.pas' {wPhotoCollection},
  Qam.PhotoViewer in 'views\Qam.PhotoViewer.pas' {frPhotoViewer: TFrame},
  Qam.Types in 'core\Qam.Types.pas',
  Qam.JpegLoader in 'graphics\Qam.JpegLoader.pas';

{$R *.res}

begin
{$ifdef DEBUG}
  ReportMemoryLeaksOnShutdown := True;
{$endif}
  GlobalContainer.Build;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmCommon, dmCommon);
  Application.CreateForm(TwMain, wMain);
  Application.CreateForm(TwPhotoCollection, wPhotoCollection);
  Application.Run;
end.
