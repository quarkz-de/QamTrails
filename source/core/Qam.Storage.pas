unit Qam.Storage;

interface

uses
  System.SysUtils;

type
  TThumbnailStorage = class
  public
    class procedure Initialize;
  end;

implementation

uses
  System.IOUtils,
  Qam.Settings;

{ TThumbnailStorage }

class procedure TThumbnailStorage.Initialize;
var
  Folder: String;
begin
  Folder := ApplicationSettings.ThumbnailsFoldername;
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
