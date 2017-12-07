unit OGRLayerUnit;

interface

uses
  SysUtils, GDALMajorObjectUnit, OGRGeometryUnit, OGRFeatureDefnUnit,
  OGRSpatialReferenceUnit, OGRFeatureUnit, Classes, ogr, ogrUtils;

type
  TFeatureFetchMode = (ffInterleaved, ffRandomRead);
  IOGRFeatureListAbstractEnumerator = interface
    function GetCurrent: IOGRFeature;
    function MoveNext: boolean;
    property Current: IOGRFeature Read GetCurrent;
  end;

  
  IOGRFeatureList = interface
    function GetEnumerator: IOGRFeatureListAbstractEnumerator;
    function FetchWith(const Value: TFeatureFetchMode): IOGRFeatureList;
  end;

  IOGRLayer = interface(IGDALMajorObject)
    function TestCapability(const ACapability: string): boolean;
    function GetExtent(AForce: boolean = True): OGREnvelope;
    function GetLayerDefn: IOGRFeatureDefn;
    function GetSpatialRef: IOGRSpatialReference;
    procedure CreateFeature(AFeature: IOGRFeature);
    procedure SetFeature(AFeature: IOGRFeature);
    function GetFeature(AIndex: int64): IOGRFeature;
    function GetNextFeature: IOGRFeature;
    function CreateField(AFieldName: String; AFieldType: OGRFieldType): OGRFieldDefnH;
    function GetName: String;
    procedure DeleteFeature(AFeature: IOGRFeature);

  procedure ResetReading;
    function Features: IOGRFeatureList;
    function GetFeatureCount: int64;
//    property SpatialFilter: OGRGeometry;
  end;

  OGRLayer = class(GDALMajorObject, IOGRLayer)
  private
    FFastFeatureCount: Boolean;
    //
    function GetSpatialFilter: OGRGeometry; virtual;
    procedure SetSpatialFilter(const Value: OGRGeometry); virtual;
  public
    constructor InternalCreateByHandle(const AHandle: Pointer); override;

    function TestCapability(const ACapability: string): boolean;
    function GetExtent(AForce: boolean = True): OGREnvelope;
    function GetLayerDefn: IOGRFeatureDefn;
    function GetSpatialRef: IOGRSpatialReference;
    procedure CreateFeature(AFeature: IOGRFeature);
    procedure SetFeature(AFeature: IOGRFeature);
    function GetFeature(AIndex: int64): IOGRFeature;
    function GetNextFeature: IOGRFeature;
    function GetName: String;
    procedure DeleteFeature(AFeature: IOGRFeature);
    function CreateField(AFieldName: String; AFieldType: OGRFieldType): OGRFieldDefnH;

//    function GetField()

    procedure ResetReading;
    function Features: IOGRFeatureList;
    function GetFeatureCount: int64;
    property SpatialFilter: OGRGeometry Read GetSpatialFilter Write SetSpatialFilter;
  end;

  OGRFilteredLayer = class(OGRLayer, IOGRLayer)
  private
    FOnDestroy: TGDALObjectNotifyEvent;
    procedure SetOnDestroy(const Value: TGDALObjectNotifyEvent);
  public
    constructor InternalCreateByHandle(const AHandle: Pointer); override;
    destructor Destroy; override;
    property OnDestroy: TGDALObjectNotifyEvent read FOnDestroy write SetOnDestroy;
  end;

  //
  IOGRFeatureListRandomReadEnumerator = class(TInterfacedObject, IOGRFeatureListAbstractEnumerator)
  private
    FOwner:         IOGRLayer;
    FIndex, FCount: int64;
  public
    constructor Create(ALayer: IOGRLayer);
    function GetCurrent: IOGRFeature;
    function MoveNext: boolean;
    property Current: IOGRFeature Read GetCurrent;
  end;

  IOGRFeatureListInterleavedEnumerator = class(TInterfacedObject, IOGRFeatureListAbstractEnumerator)
  private
    FOwner:         IOGRLayer;
    FIndex, FCount: int64;
    FFeatureMap : TInterfaceList;
  public
    constructor Create(ALayer: IOGRLayer);
    destructor Destroy; override;
    function GetCurrent: IOGRFeature;
    function MoveNext: boolean;
    property Current: IOGRFeature Read GetCurrent;
  end;

  OGRFeatureList = class(TInterfaceList, IOGRFeatureList)
  private
    FOwner: IOGRLayer;
    FFetchMode: TFeatureFetchMode;
    procedure SetFetchMode(const Value: TFeatureFetchMode);  overload;
  public
    function GetEnumerator: IOGRFeatureListAbstractEnumerator;
    constructor Create(ALayer: IOGRLayer);
    property FetchMode: TFeatureFetchMode read FFetchMode write SetFetchMode;
    function FetchWith(const Value: TFeatureFetchMode): IOGRFeatureList;
  end;

implementation

{ OGRLayer }

procedure OGRLayer.CreateFeature(AFeature: IOGRFeature);
begin
  OgrCheck(OGR_L_CreateFeature(FHandle, AFeature.GetHandle));
end;

function OGRLayer.CreateField(AFieldName: String; AFieldType: OGRFieldType): OGRFieldDefnH;
begin
  Result := OGR_Fld_Create(PChar(AFieldName), AFieldType);
  OGR_L_CreateField(FHandle, Result, 0);
end;

procedure OGRLayer.DeleteFeature(AFeature: IOGRFeature);
begin
  OGR_L_DeleteFeature(FHandle, AFeature.GetFID);
end;

function OGRLayer.Features: IOGRFeatureList;
begin
  Result := OGRFeatureList.Create(Self);
end;

function OGRLayer.GetExtent(AForce: boolean): OGREnvelope;
var
  Buff: OGREnvelope;
begin
  OgrCheck(OGR_L_GetExtent(FHandle, Buff, integer(AForce)));
  Result := Buff;
end;

function OGRLayer.GetFeature(AIndex: int64): IOGRFeature;
var
  Handle : Pointer;
begin
  Handle := OGR_L_GetFeature(FHandle, AIndex);
  Result := OGRFeature.InternalCreateByHandle(Handle);
end;

function OGRLayer.GetFeatureCount: int64;
begin
  Result := OGR_L_GetFeatureCount(FHandle, Int64(not FFastFeatureCount));
 end;

function OGRLayer.TestCapability(const ACapability: string): boolean;
begin
  Result := OGR_L_TestCapability(FHandle, PChar(ACapability)) <> 0;
end;

procedure OGRLayer.SetFeature(AFeature: IOGRFeature);
begin
  OgrCheck(OGR_L_SetFeature(FHandle, AFeature.GetHandle));
end;

procedure OGRLayer.SetSpatialFilter(const Value: OGRGeometry);
begin
  //TODO: implement
end;

function OGRLayer.GetLayerDefn: IOGRFeatureDefn;
begin
  Result := OGRFeatureDefn.InternalCreateByHandle(OGR_L_GetLayerDefn(FHandle));
end;

function OGRLayer.GetName: String;
begin
  Result := OGR_L_GetName(FHandle);
end;

function OGRLayer.GetNextFeature: IOGRFeature;
var
  Handle: Pointer;
begin
  Handle := OGR_L_GetNextFeature(FHandle);
  if Assigned(Handle) then  
    Result := OGRFeature.InternalCreateByHandle(Handle);
end;

function OGRLayer.GetSpatialFilter: OGRGeometry;
begin
  Result := OGRGeometry.InternalCreateByHandle(OGR_L_GetSpatialFilter(FHandle));
end;

function OGRLayer.GetSpatialRef: IOGRSpatialReference;
begin
  Result := OGRSpatialReference.InternalCreateByHandle(OGR_L_GetSpatialRef(FHandle));
end;


constructor OGRLayer.InternalCreateByHandle(const AHandle: Pointer);
begin
  inherited;
  FFastFeatureCount := TestCapability(OLCFastFeatureCount);
end;

procedure OGRLayer.ResetReading;
begin
  OGR_L_ResetReading(FHandle);
end;

{ IOGRFeatureList }

constructor IOGRFeatureListRandomReadEnumerator.Create(ALayer: IOGRLayer);
begin
  inherited Create;
  FOwner := ALayer;
  FCount := ALayer.GetFeatureCount;
end;

function IOGRFeatureListRandomReadEnumerator.GetCurrent: IOGRFeature;
begin
  Result := FOwner.GetFeature(FIndex);
end;

function IOGRFeatureListRandomReadEnumerator.MoveNext: boolean;
begin
  Result := FIndex < FCount - 1;
  if Result then
    Inc(FIndex);
end;

{ IOGRFeatureList }

constructor OGRFeatureList.Create(ALayer: IOGRLayer);
begin
  FOwner := ALayer;
  if FOwner.TestCapability(OLCRandomRead) then
    FFetchMode := ffRandomRead;
end;

function OGRFeatureList.GetEnumerator: IOGRFeatureListAbstractEnumerator;
begin
  case FFetchMode of
    ffRandomRead: Result := IOGRFeatureListRandomReadEnumerator.Create(FOwner);
    ffInterleaved: Result := IOGRFeatureListInterleavedEnumerator.Create(FOwner);
  end;
end;


function OGRFeatureList.FetchWith(
  const Value: TFeatureFetchMode): IOGRFeatureList;
begin
  SetFetchMode(Value);
  Result := Self;
end;

procedure OGRFeatureList.SetFetchMode(const Value: TFeatureFetchMode);
begin
  FFetchMode := Value;
end;

{ IOGRFeatureListInterleavedEnumerator }

constructor IOGRFeatureListInterleavedEnumerator.Create(ALayer: IOGRLayer);
var
  CurrentFeature: IOGRFeature;
  Index: Integer;
begin
  inherited Create;
  FOwner := ALayer;
  FCount := ALayer.GetFeatureCount;
  FFeatureMap := TInterfaceList.Create;
  FFeatureMap.Count := FCount;
  Index := 0;
  //
  FOwner.ResetReading;

  while Index <> FCount do begin
    CurrentFeature := FOwner.GetNextFeature;
    FFeatureMap.Items[Index] := CurrentFeature;
    Inc(Index);
  end;
end;

destructor IOGRFeatureListInterleavedEnumerator.Destroy;
begin
  FFeatureMap.Free;
  inherited;
end;

function IOGRFeatureListInterleavedEnumerator.GetCurrent: IOGRFeature;
begin
  Result := IOGRFeature(FFeatureMap.Items[FIndex]);
end;

function IOGRFeatureListInterleavedEnumerator.MoveNext: boolean;
begin
  Result := FIndex < FCount - 1;
  if Result then
    Inc(FIndex);
end;

{ OGRFilteredLayer }

destructor OGRFilteredLayer.Destroy;
begin
  if Assigned(FOnDestroy) then begin
    FOnDestroy(Self);
  end;
end;

constructor OGRFilteredLayer.InternalCreateByHandle(const AHandle: Pointer);
begin
  inherited;
  FFastFeatureCount := False;
end;

procedure OGRFilteredLayer.SetOnDestroy(const Value: TGDALObjectNotifyEvent);
begin
  FOnDestroy := Value;
end;

end.

