unit OGRSpatialReferenceUnit;

interface

uses gdal, GDALBaseHandleObjectUnit, gdalcore, ogr, OgrUtils, osr;

type
  IOGRSpatialReference = interface(IGDALBaseHandleObject)
    function AutoIdentifyEPSG: boolean;
    function GetAuthorityCode: string;
    function ExportToMICoordSys: string;
  end;

  OGRSpatialReference = class(GDALBaseHandleObject, IOGRSpatialReference)
  public
    function AutoIdentifyEPSG: boolean;
    function GetAuthorityCode: string;
    function ExportToMICoordSys: string;
  end;

implementation



{ OGRSpatialReference }


{ OGRSpatialReference }


function OGRSpatialReference.AutoIdentifyEPSG: boolean;
begin
  Result := OSRAutoIdentifyEPSG(FHandle) = OGRERR_NONE;
end;

function OGRSpatialReference.ExportToMICoordSys: string;
var
  StrList: PCPChar;
begin
  StrList := CPLMalloc(SizeOf(StrList));
  OgrCheck(OSRExportToMICoordSys(FHandle, StrList));
  Result := StrList^;
  VSIFree(StrList);
end;

function OGRSpatialReference.GetAuthorityCode: string;
begin
  Result := OSRGetAuthorityCode(FHandle, nil);
end;

end.
