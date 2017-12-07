unit AbstractTabTestsUnit;

interface

uses
  TestFrameWork, OGRLayerUnit, OgrDatasetUnit, ogr, SysUtils, Classes, gdalcore;

type
  TTabAbstractTestCase = class abstract(TTestCase)
  protected
    FDataset: IOGRDataset;
    procedure SetUp; override;
    procedure TearDown; override;
  end;

implementation

{ TTabAbstractTestCase }

procedure TTabAbstractTestCase.SetUp;
var
  Buf: string;
begin
  inherited;
  buf := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
    '..\test\data\settlement_point.tab';
  FDataset := OGRDataset.Open(buf, false);
  CPLGetConfigOption('GDAL_DATA', nil);
end;

procedure TTabAbstractTestCase.TearDown;
begin
  FDataset := nil;
  inherited;
end;

end.
