unit OGRDatasetTests;

interface

uses AbstractTabTestsUnit, TestFrameWork, OGRLayerUnit;

type
  TOgrDatasetTests = class(TTabAbstractTestCase)
  published
    procedure GetLayerCount;
    procedure GetLayer;
    procedure GetLayerByName;
    procedure ExecuteSQL;
  end;

implementation


{ TOgrDatasetTests }

procedure TOgrDatasetTests.ExecuteSQL;
var
  Layer: IOGRLayer;
begin
  Layer := FDataset.ExecuteSQL('SELECT * FROM settlement_point WHERE osm_id > 1000000000');
  CheckNotNull(Layer);
  CheckEquals(58, Layer.GetFeatureCount);
end;

procedure TOgrDatasetTests.GetLayer;
begin
  CheckNotNull(FDataset.GetLayer(0));
end;

procedure TOgrDatasetTests.GetLayerByName;
begin
  CheckNotNull(FDataset.GetLayerByName('settlement_point'));
end;

procedure TOgrDatasetTests.GetLayerCount;
begin
  CheckEquals(FDataset.GetLayerCount, 1);
end;

initialization
  TestFramework.RegisterTest(TOgrDatasetTests.Suite);

end.
