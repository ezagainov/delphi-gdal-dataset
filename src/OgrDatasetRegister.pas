unit OgrDatasetRegister;

interface

uses
  Classes,
  Controls,
  Dialogs,
  ExtCtrls,
  Forms,
  Graphics,
  Messages,
  OgrDBDataset,
  StdCtrls,
  SysUtils,
  Windows;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('GDAL', [TOgrDataset]);
end;

end.
