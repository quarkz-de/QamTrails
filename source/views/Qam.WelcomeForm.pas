unit Qam.WelcomeForm;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Eventbus,
  Qam.Forms, Qam.Events;

type
  TwWelcomeForm = class(TApplicationForm)
    imIcon: TImage;
    imLogo: TImage;
    procedure FormCreate(Sender: TObject);
  private
  public
    [Subscribe]
    procedure OnThemeChange(AEvent: IThemeChangeEvent);
  end;

implementation

{$R *.dfm}

uses
  Qam.Settings;

{ TwWelcomeForm }

procedure TwWelcomeForm.FormCreate(Sender: TObject);
begin
  GlobalEventBus.RegisterSubscriberForEvents(Self);
end;

procedure TwWelcomeForm.OnThemeChange(AEvent: IThemeChangeEvent);
begin
  //
end;

end.
