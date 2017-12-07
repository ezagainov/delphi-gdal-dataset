unit OGRDatasetUnit;

interface

uses GDALDatasetUnit, OGRLayerUnit, ogr, OGRUtils;

type
  IOGRDataset = interface(IGDALDataset)
    function GetLayerCount: integer;
    function GetLayer(ALayerIndex: integer): IOGRLayer;
    function GetLayerByName(ALayerName: string): IOGRLayer;
    function ExecuteSQL(ASQLText: string): IOGRLayer;
    procedure ReleaseResultSet(ALayer: IOGRLayer);
  end;

  OGRDataset = class(GDALDataset, IOGRDataset)
  public
    constructor Open(AFileName: string; AReadOnly: boolean); override;
    constructor Create(AFileName, ADriverName: string);
    destructor Destroy; override;
    function GetLayerCount: integer; override;
  end;



implementation

{ OGRDataset }

constructor OGRDataset.Create(AFileName, ADriverName: string);
begin
  FHandle := OGR_Dr_CreateDataSource(OGRGetDriverByName(PChar(ADriverName)), PChar(AFileName), nil);
end;

destructor OGRDataset.Destroy;
begin
  OgrCheck(OGRReleaseDataSource(FHandle));
  inherited;
end;

function OGRDataset.GetLayerCount: integer;
begin
  Result := OGR_DS_GetLayerCount(FHandle);
end;

constructor OGRDataset.Open(AFileName: string; AReadOnly: boolean);
begin
  FHandle := OGROpen(PChar(AFileName), Integer(not AReadOnly), nil);
end;

end.
