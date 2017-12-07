unit OGRFeatureUnit;

interface

uses GDALBaseHandleObjectUnit, ogr, OGRFeatureDefnUnit;

type
  IOGRFeature = interface(IGDALBaseHandleObject)
    function GetFieldCount: integer;
    function GetFieldAsString(AIndex: integer): string;
    procedure SetFieldString(AIndex: integer; AValue: string);

    function GetFID: int64;
  end;

  OGRFeature = class(GDALBaseHandleObject, IOGRFeature)
  public
    constructor Create(AFeatureDefn: OGRFeatureDefn);
    destructor Destroy; override;
    function GetFieldCount: integer;
    function GetFieldAsString(AIndex: integer): string;
    procedure SetFieldString(AIndex: integer; AValue: string);
    function GetFID: int64;
  end;

implementation

{ OGRFeature }

constructor OGRFeature.Create(AFeatureDefn: OGRFeatureDefn);
begin
  FHandle := OGR_F_Create(AFeatureDefn.GetHandle);
end;

destructor OGRFeature.Destroy;
begin
//  OGR_F_Destroy(FHandle);
  inherited;
end;

function OGRFeature.GetFID: int64;
begin
  Result := OGR_F_GetFID(FHandle);
end;

function OGRFeature.GetFieldAsString(AIndex: integer): string;
begin
  Result := PChar(Utf8ToAnsi(OGR_F_GetFieldAsString(FHandle, AIndex)));
end;

function OGRFeature.GetFieldCount: integer;
begin
  Result := OGR_F_GetFieldCount(FHandle);
end;

procedure OGRFeature.SetFieldString(AIndex: integer; AValue: string);
var
  Utf8Buffer: Pointer;
begin
  Utf8Buffer := PUTF8String(AnsiToUtf8(PChar(AValue)));
  OGR_F_SetFieldString(FHandle, AIndex, Utf8Buffer);
end;

end.
