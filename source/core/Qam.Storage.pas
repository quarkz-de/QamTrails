unit Qam.Storage;

interface

uses
  System.SysUtils;

type
  TDataStorage = class
  public
    class procedure Initialize;
  end;

implementation

uses
  System.IOUtils,
  Qam.Settings;

{ TDataStorage }

class procedure TDataStorage.Initialize;
var
  Folder: String;
begin
  Folder := ApplicationSettings.DataFoldername;
  if not TDirectory.Exists(Folder) then
    ForceDirectories(Folder);
{$IFDEF MSWINDOWS}
{$WARN SYMBOL_PLATFORM OFF}
  if FileGetAttr(Folder) and faHidden = 0 then
    FileSetAttr(Folder, faHidden);
{$WARN SYMBOL_PLATFORM ON}
{$ENDIF}
end;

end.
