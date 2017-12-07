unit OgrDBDataset.SpatialFilter;

interface

uses
  
  
  OGRFeatureUnit,
  OGRLayerUnit;

const
  BofCrack = -1;

type
  TSpatialIndexCacheAbstract = class abstract(TObject)
  protected
    FLayer: IOGRLayer;
    procedure SetRecNum(const ANum: int64); virtual; abstract;
    function GetRecNum: int64; virtual; abstract;
    function FeatureByIndex(const AIndex: int64): IOGRFeature; virtual; abstract;

    constructor Create(const ALayer: IOGRLayer); virtual;
  public
    procedure ResetReading; virtual; abstract;
    function CurrentFeature: IOGRFeature; virtual; abstract;
    function Count: int64; virtual; abstract;
    property RecNum: int64 Read GetRecNum Write SetRecNum;
    procedure DeleteCurrent; virtual; abstract;
    procedure UpdateCount;virtual;   abstract;

  end;

  TFastSpatialIndexCache = class(TSpatialIndexCacheAbstract)
  private
    FCurrentIndex:   int64;
    FIndexOffset:    int64;
    FCurrentFeature: IOGRFeature;
    FRecordCount:    integer;
  protected
    procedure SetRecNum(const ANum: int64); override;
    function GetRecNum: int64; override;

    function FeatureByIndex(const AIndex: int64): IOGRFeature; override;

  public
    constructor Create(const ALayer: IOGRLayer); override;
    procedure ResetReading; override;
    function CurrentFeature: IOGRFeature; override;
    procedure DeleteCurrent; override;
    function Count: int64; override;
        procedure UpdateCount;override;
  end;

implementation



function TFastSpatialIndexCache.Count: int64;
begin
  Result := FRecordCount;
end;

constructor TFastSpatialIndexCache.Create(const ALayer: IOGRLayer);
begin
  FCurrentIndex := BofCrack;
  inherited;
end;

function TFastSpatialIndexCache.CurrentFeature: IOGRFeature;
begin
  FCurrentFeature := FLayer.GetFeature(FCurrentIndex + 1);
  Result := FCurrentFeature;
end;

procedure TFastSpatialIndexCache.DeleteCurrent;
begin
  FLayer.DeleteFeature(CurrentFeature);
end;

function TFastSpatialIndexCache.FeatureByIndex(const AIndex: int64): IOGRFeature;
begin
  if not Assigned(FCurrentFeature) then
    SetRecNum(AIndex);
  Result := FCurrentFeature;
end;

function TFastSpatialIndexCache.GetRecNum: int64;
begin
  Result := FCurrentIndex;
end;

procedure TFastSpatialIndexCache.ResetReading;
begin
  FCurrentIndex := BofCrack;
  FCurrentFeature := nil;
  FIndexOffset  := 0;
  FLayer.ResetReading;
  UpdateCount;
end;

procedure TFastSpatialIndexCache.SetRecNum(const ANum: int64);
begin
  FIndexOffset  := ANum - FCurrentIndex;
  FCurrentIndex := ANum;
end;

procedure TFastSpatialIndexCache.UpdateCount;
begin
  FRecordCount := FLayer.GetFeatureCount;
end;

constructor TSpatialIndexCacheAbstract.Create(const ALayer: IOGRLayer);
begin
  inherited Create;
  FLayer := ALayer;
end;

end.
