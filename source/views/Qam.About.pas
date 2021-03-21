unit Qam.About;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls;

type
  TwAbout = class(TForm)
    imLogo: TImage;
    btOk: TButton;
    imIcon: TImage;
    Label1: TLabel;
    txHomepage: TLinkLabel;
    procedure txHomepageLinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    function Execute: Boolean;
    class function ExecuteDialog: Boolean;
  end;

var
  wAbout: TwAbout;

implementation

{$R *.dfm}

{ TwAbout }

function TwAbout.Execute: Boolean;
begin
  Result := ShowModal = mrOk;
end;

class function TwAbout.ExecuteDialog: Boolean;
var
  Dialog: TwAbout;
begin
  Dialog := TwAbout.Create(nil);
  try
    Result := Dialog.Execute;
  finally
    Dialog.Free;
  end;
end;

procedure TwAbout.txHomepageLinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
begin
  if LinkType = sltURL then
    ShellExecute(0, 'open', PChar(Link), nil, nil, SW_SHOWNORMAL);
end;

end.
