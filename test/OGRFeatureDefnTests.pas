unit OGRFeatureDefnTests;

interface

uses AbstractTabTestsUnit, TestFramework, OGRLayerUnit, OGRFeatureDefnUnit;

type
  TOGRFeatureDefnTests = class(TTabAbstractTestCase)
  protected
    FLayer: IOGRLayer;
    FDefn:  IOGRFeatureDefn;
    procedure SetUp; override;
  published
    procedure GetFieldCount;
    procedure GetFieldDefn;
    procedure GetFieldIndex;
    procedure GetFieldNameRef;
  end;

implementation

{ TOGRFeatureDefnTests }

procedure TOGRFeatureDefnTests.GetFieldCount;
begin
  CheckEquals(10, FDefn.GetFieldCount);
end;

procedure TOGRFeatureDefnTests.GetFieldDefn;
begin
  CheckNotNull(FDefn.GetFieldDefn(1));
end;

procedure TOGRFeatureDefnTests.GetFieldIndex;
begin
  CheckEquals(1, FDefn.GetFieldIndex('NAME'));
end;

procedure TOGRFeatureDefnTests.GetFieldNameRef;
begin
  CheckEquals('NAME', FDefn.GetFieldDefn(1).GetNameRef);
end;

procedure TOGRFeatureDefnTests.SetUp;
begin
  inherited;
  FLayer := FDataset.GetLayer(0);
  FDefn  := FLayer.GetLayerDefn;
end;

initialization
  TestFramework.RegisterTest(TOGRFeatureDefnTests.Suite);

end.
