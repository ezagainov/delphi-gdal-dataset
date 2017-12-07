unit GDALDatasetUnit;

interface

uses GDALMajorObjectUnit, OGRSpatialReferenceUnit, OGRLayerUnit, gdal, ogr;

type
  IGDALDataset = interface(IGDALMajorObject)
    function GetLayerCount: integer;
    function GetLayer(ALayerIndex: integer): IOGRLayer;
    function CreateLayer(ALayerName: string; ASpatialRef: OGRSpatialReference;
      AGeometryType: OGRwkbGeometryType): IOGRLayer;
    function GetLayerByName(ALayerName: string): IOGRLayer;
    function ExecuteSQL(ASQLText: string): IOGRLayer;
    procedure ReleaseResultSet(ALayer: IOGRLayer);
  end;

  GDALDataset = class(GDALMajorObject, IGDALDataset)
  private
    procedure DoFilteredDatasetDestroy(Sender: GDALMajorObject);
  public
    constructor Open(AFileName: string; AReadOnly: boolean); virtual;
    destructor Destroy; override;
    function GetLayerCount: integer; virtual; abstract;
    function GetLayer(ALayerIndex: integer): IOGRLayer;
    function CreateLayer(ALayerName: string; ASpatialRef: OGRSpatialReference;
      AGeometryType: OGRwkbGeometryType): IOGRLayer;
    function GetLayerByName(ALayerName: string): IOGRLayer;
    function ExecuteSQL(ASQLText: string): IOGRLayer;
    procedure ReleaseResultSet(ALayer: IOGRLayer);
  end;

implementation



{ GDALDataset }

constructor GDALDataset.Open(AFileName: string; AReadOnly: boolean);
begin
  FHandle := gdal.GdalOpen(PChar(AFileName), GA_Update);
end;

procedure GDALDataset.ReleaseResultSet(ALayer: IOGRLayer);
begin
  GDALDatasetReleaseResultSet(FHandle, ALayer.GetHandle);
end;

function GDALDataset.CreateLayer(ALayerName: string; ASpatialRef: OGRSpatialReference;
  AGeometryType: OGRwkbGeometryType): IOGRLayer;
begin
  Result := OGRLayer.InternalCreateByHandle(
    OGR_DS_CreateLayer(FHandle, PChar(ALayerName), ASpatialRef.GetHandle,
    AGeometryType, nil));
end;

destructor GDALDataset.Destroy;
begin
  inherited;
end;

procedure GDALDataset.DoFilteredDatasetDestroy(Sender: GDALMajorObject);
begin
  OGR_DS_ReleaseResultSet(Self.GetHandle, Sender.GetHandle);
end;

function GDALDataset.ExecuteSQL(ASQLText: string): IOGRLayer;
var
  Layer: OGRFilteredLayer;
begin
  Layer := OGRFilteredLayer.InternalCreateByHandle(
    OGR_DS_ExecuteSQL(FHandle, PChar(ASQLText), nil, nil));
  Layer.OnDestroy := DoFilteredDatasetDestroy;
  Result := Layer;
end;

function GDALDataset.GetLayer(ALayerIndex: integer): IOGRLayer;
begin
  Result := OGRLayer.InternalCreateByHandle(GDALDatasetGetLayer(FHandle, ALayerIndex));
end;

function GDALDataset.GetLayerByName(ALayerName: string): IOGRLayer;
begin
  Result := OGRLayer.InternalCreateByHandle(
    GDALDatasetGetLayerByName(FHandle, PChar(ALayerName)));
end;

end.
