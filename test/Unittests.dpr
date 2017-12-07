program Unittests;


uses
  Forms,
  TestFrameWork,
  GUITestRunner,
  CPLUtils in '..\src\gdal_utils\CPLUtils.pas',
  GdalErrorHandler in '..\src\gdal_utils\GdalErrorHandler.pas',
  OgrUtils in '..\src\gdal_utils\OgrUtils.pas',
  gdal in '..\src\gdal_h\gdal.pas',
  gdalcore in '..\src\gdal_h\gdalcore.pas',
  ogr in '..\src\gdal_h\ogr.pas',
  osr in '..\src\gdal_h\osr.pas',
  AbstractTabTestsUnit in 'AbstractTabTestsUnit.pas',
  DGALDatasetTests in 'DGALDatasetTests.pas',
  OGRDatasetTests in 'OGRDatasetTests.pas',
  OGRFeatureDefnTests in 'OGRFeatureDefnTests.pas',
  OGRLayerTests in 'OGRLayerTests.pas',
  GDALBaseHandleObjectUnit in '..\src\ObjectWrapper\GDALBaseHandleObjectUnit.pas',
  GDALDatasetUnit in '..\src\ObjectWrapper\GDALDatasetUnit.pas',
  GDALMajorObjectUnit in '..\src\ObjectWrapper\GDALMajorObjectUnit.pas',
  OGRDatasetUnit in '..\src\ObjectWrapper\OGRDatasetUnit.pas',
  OGREnvelopeUnit in '..\src\ObjectWrapper\OGREnvelopeUnit.pas',
  OGRFeatureDefnUnit in '..\src\ObjectWrapper\OGRFeatureDefnUnit.pas',
  OGRFeatureUnit in '..\src\ObjectWrapper\OGRFeatureUnit.pas',
  OGRFieldDefnUnit in '..\src\ObjectWrapper\OGRFieldDefnUnit.pas',
  OGRGeometryUnit in '..\src\ObjectWrapper\OGRGeometryUnit.pas',
  OGRLayerUnit in '..\src\ObjectWrapper\OGRLayerUnit.pas',
  OGRSpatialReferenceUnit in '..\src\ObjectWrapper\OGRSpatialReferenceUnit.pas';

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  GUITestRunner.RunRegisteredTests;
end.

