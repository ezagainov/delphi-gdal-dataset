unit GDALBaseHandleObjectUnit;

interface

type
  GDALBaseHandleObject = class;
  
  IGDALBaseHandleObject = interface
    function GetHandle: Pointer;
    function GetObject: GDALBaseHandleObject;
  end;

  GDALBaseHandleObject = class(TInterfacedObject, IGDALBaseHandleObject)
  protected
    FHandle: Pointer;
  public
    destructor Destroy; override;
    function GetHandle: Pointer;
    function GetObject: GDALBaseHandleObject;
    constructor InternalCreateByHandle(const AHandle: Pointer); virtual;
  end;

implementation

{ GDALBaseHandleObject }

destructor GDALBaseHandleObject.Destroy;
begin
  FHandle := nil;
  inherited;
end;

function GDALBaseHandleObject.GetHandle: Pointer;
begin
  Result := FHandle;
end;

function GDALBaseHandleObject.GetObject: GDALBaseHandleObject;
begin
  Result := Self;
end;

constructor GDALBaseHandleObject.InternalCreateByHandle(const AHandle: Pointer);
begin
  FHandle := AHandle;
end;

end.
