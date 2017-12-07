unit OGRLayerTests;

interface

uses
  TestFrameWork, OGRLayerUnit, AbstractTabTestsUnit, ogr;

type


  TOGRLayerTest = class(TTabAbstractTestCase)
  protected
    FLayer: IOGRLayer;
    procedure SetUp; override;
  published
    procedure GetExtent;
    procedure TestCapability;
    procedure GetLayerDefn;
    procedure GetSpatialRef;
    procedure AutoIdentifyEPSG;
    procedure ExportToMICoordSys;  
    procedure FeaturesRandomRead;
    procedure FeaturesInterleaved;
    procedure GetName;
  end;

implementation

uses OGRFeatureUnit;

{ TOGRLayerTest }


procedure TOGRLayerTest.GetLayerDefn;
begin
  CheckNotNull(FLayer.GetLayerDefn);
end;

procedure TOGRLayerTest.GetName;
begin
  CheckEquals('settlement_point', FLayer.GetName);
end;

procedure TOGRLayerTest.GetSpatialRef;
begin
  CheckEquals('', FLayer.GetSpatialRef.GetAuthorityCode);
end;

procedure TOGRLayerTest.SetUp;
begin
  inherited;
  CheckTrue(FDataset.GetLayerCount >= 1);
  FLayer := FDataset.GetLayer(0);
end;

procedure TOGRLayerTest.TestCapability;
begin
  CheckFalse(FLayer.TestCapability(OLCTransactions));
  CheckTrue(FLayer.TestCapability(OLCCreateField));
  CheckTrue(FLayer.TestCapability(OLCRandomRead));

  CheckFalse(FLayer.TestCapability('RandomNonExistsCap'));
end;

procedure TOGRLayerTest.AutoIdentifyEPSG;
begin
  CheckFalse(FLayer.GetSpatialRef.AutoIdentifyEPSG);
end;

procedure TOGRLayerTest.ExportToMICoordSys;
begin
  CheckEquals('Earth Projection 10, 104, "m", 0',
    FLayer.GetSpatialRef.ExportToMICoordSys);
end;

procedure TOGRLayerTest.FeaturesInterleaved;
var
  F: IOGRFeature;
begin
   for f in FLayer.Features.FetchWith(ffInterleaved) do begin
    CheckNotNull(f);
  end;
end;

procedure TOGRLayerTest.FeaturesRandomRead;
var
  F: IOGRFeature;
begin
  for f in FLayer.Features.FetchWith(ffRandomRead) do begin
    CheckNotNull(f);
  end;
end;

procedure TOGRLayerTest.GetExtent;
begin
  CheckEquals(FLayer.GetExtent(False).MinX, FLayer.GetExtent(True).MinX);
  CheckEquals(FLayer.GetExtent(False).MinY, FLayer.GetExtent(True).MinY);
  CheckEquals(FLayer.GetExtent(False).MaxX, FLayer.GetExtent(True).MaxX);
  CheckEquals(FLayer.GetExtent(False).MaxY, FLayer.GetExtent(True).MaxY);
end;


initialization
  TestFramework.RegisterTest(TOGRLayerTest.Suite);

end.

