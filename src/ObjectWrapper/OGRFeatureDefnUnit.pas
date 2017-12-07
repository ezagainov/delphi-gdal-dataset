unit OGRFeatureDefnUnit;

interface

uses GDALBaseHandleObjectUnit, OGRFieldDefnUnit, ogr;

type
  IOGRFeatureDefn = interface(IGDALBaseHandleObject)
    function GetFieldCount: integer;
    function GetFieldIndex(AFieldName: String): Integer;
    function GetFieldDefn(AIndex: integer): IOGRFieldDefn;
  end;

  OGRFeatureDefn = class(GDALBaseHandleObject, IOGRFeatureDefn)
  public
    function GetFieldCount: integer;
    function GetFieldIndex(AFieldName: String): Integer;
    function GetFieldDefn(AIndex: integer): IOGRFieldDefn;
  end;


implementation

{ OGRFeatureDefn }

function OGRFeatureDefn.GetFieldCount: integer;
begin
  Result := OGR_FD_GetFieldCount(FHandle);
end;

function OGRFeatureDefn.GetFieldDefn(AIndex: integer): IOGRFieldDefn;
begin
  Result := OGRFieldDefn.InternalCreateByHandle(OGR_FD_GetFieldDefn(FHandle, AIndex));
end;

function OGRFeatureDefn.GetFieldIndex(AFieldName: String): Integer;
begin
  Result := OGR_FD_GetFieldIndex(FHandle, PChar(AFieldName));
end;

end.
