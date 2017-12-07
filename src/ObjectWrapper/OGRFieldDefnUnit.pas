unit OGRFieldDefnUnit;

interface

uses GDALBaseHandleObjectUnit, ogr;

type
  IOGRFieldDefn = interface(IGDALBaseHandleObject)
    function GetNameRef: string;
    function GetType: OGRFieldType;
    function GetFieldTypeName: string;
    function GetWidth: integer;
    function GetPrecision: integer;
  end;
  
  OGRFieldDefn = class(GDALBaseHandleObject, IOGRFieldDefn)
  public
    function GetNameRef: string;
    function GetType: OGRFieldType;
    function GetFieldTypeName: string;
    function GetWidth: integer;
    function GetPrecision: integer;
  end;

implementation

{ OGRFieldDefn }

function OGRFieldDefn.GetFieldTypeName: string;
begin
  Result := OGR_GetFieldTypeName(GetType);
end;

function OGRFieldDefn.GetNameRef: string;
begin
  Result := OGR_Fld_GetNameRef(FHandle);
end;

function OGRFieldDefn.GetPrecision: integer;
begin
  Result := OGR_Fld_GetPrecision(FHandle);
end;

function OGRFieldDefn.GetType: OGRFieldType;
begin
  Result := OGR_Fld_GetType(FHandle);
end;

function OGRFieldDefn.GetWidth: integer;
begin
  Result := OGR_Fld_GetWidth(FHandle);
end;

end.
