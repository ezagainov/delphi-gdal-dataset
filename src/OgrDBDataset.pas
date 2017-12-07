unit OgrDBDataset;

interface

uses
  Classes,
  Contnrs,
  DB,
  ADODB,
  Forms, ogr,
  GdalErrorHandler,
  OgrDBDataset.SpatialFilter,
  SysUtils,
  OGRFeatureUnit,
  OGRLayerUnit,
  OgrDatasetUnit,
  TypInfo,
  Windows;

const
  BofCrack = -1;

  {$m+}

type
  TSpecialField = class abstract(TObject)
  protected
    class function FieldName: string; virtual; abstract;
    class function Value(const AFeature: IOGRFeature): variant; virtual; abstract;
    class function FieldType: TFieldType; virtual; abstract;
    class function FieldSize: integer; virtual; abstract;
    class function Instance: TSpecialField;
  end;

  TOgrFeatureStatus = (fsNormal, fsDeleted, fsInserted);

  TOgrDataset = class(TDataSet)
  strict private
    type TOgrDSRecord = class(TObject)
    public
      Feature:      IOGRFeature;
      RecordStatus: TOgrFeatureStatus;
      Index:        int64;
      Bookmark:     longint;
      BookmarkFlag: TBookmarkFlag;
    end;

    type pOgrDSRecord = ^TOgrDSRecord;
  private
    FFileName:  TFileName;
    FLayerName: string;
    FDataset:   IOGRDataset;
    FLayer:     IOGRLayer;

    FLayerCanChange: boolean;

    FCount:       int64;
    FFieldsCount: integer;
    FHoldTransactions: boolean;
    FFeatures:    TSpatialIndexCacheAbstract;
    FEncoding:    string;
    FForceFullSpatialIndex: boolean;
    FCurrentSpatialRef: OGRSpatialReferenceH;
    FReadOnly:    boolean;
    procedure SetFileName(const Value: TFileName);
    function CurrentLayer: IOGRLayer;
    procedure InternalUpdateFilter;
    procedure SetEncoding(const Value: string);
    procedure SetForceFullSpatialIndex(const Value: boolean);
    function GetCurrentFeature: IOGRFeature;
    function GetRecordObject(Buffer: PChar): TOgrDSRecord;
//    function GetActiveLayer: IOGRLayer;

  protected
    FIsTableOpen: boolean;
    FList:        TObjectList;
    FRecordSize:  integer;
    FLastIndex:   int64;
    procedure DataEvent(Event: TDataEvent; Info: longint); override;
    function GetActiveRecBuf(var RecBuf: PChar): boolean;
    procedure SetFiltered(Value: boolean); override;
    procedure SetFilterText(const Value: string); override;
    function AllocRecordBuffer: PChar; override;
    procedure FreeRecordBuffer(var Buffer: PChar); override;
    procedure GetBookmarkData(Buffer: PChar; Data: Pointer); override;
    function GetBookmarkFlag(Buffer: PChar): TBookmarkFlag; override;
    function GetRecord(Buffer: PChar; GetMode: TGetMode; DoCheck: boolean): TGetResult; override;
    function GetRecordSize: word; override;
    procedure InternalAddRecord(Buffer: Pointer; Append: boolean); override;
    procedure InternalClose; override;
    procedure InternalDelete; override;
    procedure InternalFirst; override;
    procedure InternalGotoBookmark(Bookmark: Pointer); override;
    procedure InternalHandleException; override;
    procedure InternalLast; override;
    procedure InternalOpen; override;
    procedure InternalSetLayer(const ALayer: IOGRLayer);
    procedure InternalPost; override;
    procedure InternalInsert; override;
    procedure InternalSetToRecord(Buffer: PChar); override;
    function IsCursorOpen: boolean; override;
    procedure SetBookmarkFlag(Buffer: PChar; Value: TBookmarkFlag); override;
    procedure SetBookmarkData(Buffer: PChar; Data: Pointer); override;
    function GetRecordCount: integer; override;
    procedure SetRecNo(Value: integer); override;
    function GetRecNo: integer; override;
    procedure ResetReading; virtual;
    procedure InternalInitFieldDefs; override;
    procedure SetFieldData(Field: TField; Buffer: Pointer); override;
    function GetCanModify: boolean; override;
    function CurrentTypedRecord: TOgrDSRecord;
    procedure SetReadOnly(AValue: boolean);
    //    procedure SetActiveRecord(Value: integer); override;
  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;
    procedure ExecuteSQL(const ASQLCommand: string);
    procedure ResetSQL;
  public
    function GetFieldData(Field: TField; Buffer: Pointer): boolean; override;
    property Layer: IOGRLayer Read FLayer;
    property CurrentFeature: IOGRFeature Read GetCurrentFeature;
    property CurrentSpatialRef: OGRSpatialReferenceH Read FCurrentSpatialRef;
    function DatasetHandle: Pointer;
  published
    property FileName: TFileName Read FFileName Write SetFileName;
    property HoldTransactions: boolean Read FHoldTransactions;
    property Encoding: string Read FEncoding Write SetEncoding;
    property ForceFullSpatialIndex: boolean Read FForceFullSpatialIndex Write SetForceFullSpatialIndex;
    property DataSource;
    property FieldDefs;
    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeInsert;
    property AfterInsert;
    property BeforeEdit;
    property AfterEdit;
    property BeforePost;
    property AfterPost;
    property BeforeCancel;
    property AfterCancel;
    property BeforeDelete;
    property AfterDelete;
    property BeforeScroll;
    property AfterScroll;
    property OnCalcFields;
    property OnDeleteError;
    property OnEditError;
    property OnNewRecord;
    property OnPostError;

    property Active default False;
    property AutoCalcFields;
    property ReadOnly: boolean Read FReadOnly Write SetReadOnly;
    property Filter;
    property Filtered;
  end;


var
  SpecialFields: TObjectList;

implementation

uses
  //  OgrDBDataset.FieldMapping,
  OgrUtils, Variants,
  VarUtils;

{ TLayerPainter }

function TOgrDataset.AllocRecordBuffer: PChar;
begin
  Result := Pointer(TOgrDSRecord.Create);
end;

constructor TOgrDataset.Create(Owner: TComponent);
begin
  inherited;
  SetEncoding('UTF-8');
  FList := TObjectList.Create(False); // owns objects
end;

function TOgrDataset.CurrentLayer: IOGRLayer;
begin
  //  if FSelectionLayer <> nil then
  //    Result := FSelectionLayer
  //  else
  Result := FLayer;
end;

function TOgrDataset.CurrentTypedRecord: TOgrDSRecord;
var
  RecBuf: PChar;
  RecExists: boolean;
begin
  Result := nil;
  RecExists := GetActiveRecBuf(RecBuf);
  if not RecExists then
    Exit;
  Result := GetRecordObject(RecBuf);
end;

procedure TOgrDataset.DataEvent(Event: TDataEvent; Info: integer);
begin
  case Event of
    deConnectChange:
      if Active and not Bool(Info) and Assigned(FDataset) then
        Close;
  end;
  inherited;
end;

function TOgrDataset.DatasetHandle: Pointer;
begin
  Result := FDataset.GetHandle;
end;

destructor TOgrDataset.Destroy;
begin
  FList.Free;
  inherited;
end;

procedure TOgrDataset.ExecuteSQL(const ASQLCommand: string);
begin
  FLayer := FDataset.ExecuteSQL(ASQLCommand);
  Filtered := True;
  FLayerCanChange := FLayer.TestCapability(OLCSequentialWrite) or FLayer.TestCapability(OLCRandomWrite);
  FFeatures.Free;
  FFeatures := TFastSpatialIndexCache.Create(FLayer);
  ResetReading;
  First;
end;

procedure TOgrDataset.FreeRecordBuffer(var Buffer: PChar);
begin
  GetRecordObject(Buffer).Free;
end;

//function TOgrDataset.GetActiveLayer: IOGRLayer;
//begin
//  Result := FLayer;
//end;

function TOgrDataset.GetActiveRecBuf(var RecBuf: PChar): boolean;
begin
  RecBuf := ActiveBuffer;
  Result := RecBuf <> nil;
end;

procedure TOgrDataset.GetBookmarkData(Buffer: PChar; Data: Pointer);
begin
  PInteger(Data)^ := GetRecordObject(Buffer).Bookmark;
end;

function TOgrDataset.GetBookmarkFlag(Buffer: PChar): TBookmarkFlag;
begin
  Result := GetRecordObject(Buffer).BookmarkFlag;
end;

function TOgrDataset.GetCanModify: boolean;
begin
  Result := Assigned(FDataset) and (CurrentTypedRecord <> nil) and (CurrentTypedRecord.RecordStatus <> fsDeleted) and FLayerCanChange;
end;

function TOgrDataset.GetCurrentFeature: IOGRFeature;
begin
  Result := IOGRFeature(CurrentTypedRecord.Feature);
end;

function TOgrDataset.GetFieldData(Field: TField; Buffer: Pointer): boolean;
var
  Feature: IOGRFeature;
  FloatBuf: double;
  IntBuf: integer;
  Rec: TOgrDSRecord;
begin
  Rec := CurrentTypedRecord;
  Result := Active and Assigned(Rec);
  if not Result then
    Exit;
  if Buffer = nil then begin
    //    Result := False;
    Exit;
  end;

  Feature := Rec.Feature;
  //  Log.Info('GetFieldData(%d, %d)', [Field.Index, Rec.Index]);
  if Field.Index < FFieldsCount then begin
    case Rec.RecordStatus of
      fsNormal:
        StrCopy(Buffer, PChar(Feature.GetFieldAsString(Field.Index)));
      fsDeleted, fsInserted:
        StrCopy(Buffer, PChar(EmptyStr));
    end;
  end
  else
    with TSpecialField(SpecialFields.Items[Field.index - FFieldsCount]) do
      case FieldType of
        ftString:
          StrCopy(Buffer, PChar(VarToStrDef(Value(Feature), EmptyStr)));
        ftFloat: begin
          FloatBuf := Value(Feature);
          Move(FloatBuf, Buffer^, sizeof(FloatBuf));
        end;
        ftInteger: begin
          IntBuf := Value(Feature);
          Move(IntBuf, Buffer^, sizeof(IntBuf));
        end;
      end;
  Result := True;
end;

function TOgrDataset.GetRecNo: integer;
begin
  Result := integer(FFeatures.RecNum);
end;

function TOgrDataset.GetRecord(Buffer: PChar; GetMode: TGetMode; DoCheck: boolean): TGetResult;
begin
  Result := grOK; // default
  case GetMode of
    gmNext: // move on
      if FFeatures.RecNum < GetRecordCount - 1 then
        FFeatures.RecNum := FFeatures.RecNum + 1
      else
        Result := grEOF; // end of file
    gmPrior: // move back
      if FFeatures.RecNum > 0 then
        FFeatures.RecNum := FFeatures.RecNum - 1
      else
        Result := grBOF; // begin of file
    gmCurrent: // check if empty
      if FFeatures.RecNum >= GetRecordCount then
        Result := grEOF;
  end;
  if Result = grOK then begin
    with GetRecordObject(Buffer) do begin
      Feature := FFeatures.CurrentFeature;
      Index := FFeatures.RecNum;
      BookmarkFlag := bfCurrent;
      Bookmark := FFeatures.RecNum;
      if Feature.GetHandle = nil then
        RecordStatus := fsDeleted
      else
        RecordStatus := fsNormal;
    end;
  end;
end;

function TOgrDataset.GetRecordCount: integer;
begin
  if Assigned(FFeatures) then
    Result := integer(FFeatures.Count)
  else
    Result := BofCrack;
end;

function TOgrDataset.GetRecordObject(Buffer: PChar): TOgrDSRecord;
begin
  Result := pOgrDSRecord(Addr(Buffer))^;
end;

function TOgrDataset.GetRecordSize: word;
begin
  Result := SizeOf(Pointer);
end;

procedure TOgrDataset.InternalAddRecord(Buffer: Pointer; Append: boolean);
begin
  if Append then
    SetBookmarkFlag(Buffer, bfEOF);
  InternalPost;
end;

procedure TOgrDataset.InternalClose;
begin
  FreeAndNil(FFeatures);
  FDataset := nil;
  BindFields(False);
  if DefaultFields then
    DestroyFields;
  FIsTableOpen := False;
end;

procedure TOgrDataset.InternalDelete;
begin
  if CurrentTypedRecord.RecordStatus = fsDeleted then
    Exit;
  FFeatures.DeleteCurrent;
  CurrentTypedRecord.RecordStatus := fsDeleted;
  CurrentTypedRecord.Feature := nil;
end;

procedure TOgrDataset.InternalFirst;
begin
  FFeatures.RecNum := BofCrack;
end;

procedure TOgrDataset.InternalGotoBookmark(Bookmark: Pointer);
begin
  if (Bookmark <> nil) then
    FFeatures.RecNum := int64(Bookmark);
end;

procedure TOgrDataset.InternalHandleException;
begin
  Application.HandleException(Self);
end;

procedure TOgrDataset.InternalInitFieldDefs;
var
  i: integer;
  fieldWidth: integer;
begin
  inherited;

  if not Assigned(FDataset) then
    Active := True
  else
  begin

    FieldDefs.Clear;
    for i := 0 to FLayer.GetLayerDefn.GetFieldCount - 1 do begin
      with FLayer.GetLayerDefn.GetFieldDefn(i) do begin
        if GetType = OFTString then
          fieldWidth := GetWidth
        else
          fieldWidth := 128;
        FieldDefs.Add(GetNameRef, ftString, fieldWidth);
      end;
    end;

    FFieldsCount := FieldDefs.Count;
    for I := 0 to SpecialFields.Count - 1 do
      FieldDefs.Add(TSpecialField(SpecialFields.Items[i]).FieldName,
        TSpecialField(SpecialFields.Items[i]).FieldType,
        TSpecialField(SpecialFields.Items[i]).FieldSize);
  end;
end;

procedure TOgrDataset.InternalInsert;
begin
  CurrentTypedRecord.Feature := OGRFeature.InternalCreateByHandle(OGR_F_Create(FLayer.GetLayerDefn.GetHandle));
end;

procedure TOgrDataset.InternalLast;
begin
  // EOF crack
  FFeatures.RecNum := RecordCount;
end;

procedure TOgrDataset.InternalOpen;
begin
  FDataset := OGRDataset.Open(FFileName, FReadOnly);
  InternalSetLayer(FDataset.GetLayer(FDataset.GetLayerCount - 1));

  InternalInitFieldDefs;

  if DefaultFields then
    CreateFields;

  BindFields(True);
  ResetReading;
  FRecordSize  := SizeOf(TOgrDSRecord);
  FFeatures.RecNum := BofCrack;
  BookmarkSize := SizeOf(int64);
  FIsTableOpen := True;
end;

procedure TOgrDataset.InternalSetLayer(const ALayer: IOGRLayer);
begin
  if FLayer = ALayer then
    Exit;
  FLayer := ALayer;
  FLayerCanChange := FLayer.TestCapability(OLCSequentialWrite) or FLayer.TestCapability(OLCRandomWrite);
  FFeatures := TFastSpatialIndexCache.Create(FLayer);
end;

procedure TOgrDataset.InternalPost;
var
  Rec: TOgrDSRecord;
begin
  inherited;
  Rec := CurrentTypedRecord;
  if Rec.RecordStatus = fsDeleted then
    Exit;

  case State of
    dsEdit:
      CurrentLayer.SetFeature(Rec.Feature);
    dsInsert: begin
      Rec.Index := FFeatures.Count;
      CurrentLayer.CreateFeature(Rec.Feature);
      FFeatures.UpdateCount;
    end;
  end;
end;

procedure TOgrDataset.InternalSetToRecord(Buffer: PChar);
begin
  FFeatures.RecNum := GetRecordObject(Buffer).Index;
end;

procedure TOgrDataset.InternalUpdateFilter;
{var
  OgrErr: integer; }
begin
{  if Filtered then
    OgrErr := OGR_L_SetAttributeFilter(CurrentLayer.GetHandle, PAnsiChar(Filter))
  else
    OgrErr := OGR_L_SetAttributeFilter(CurrentLayer.GetHandle, nil);

  ResetReading;
  First;}
end;

function TOgrDataset.IsCursorOpen: boolean;
begin
  Result := FIsTableOpen;
end;

procedure TOgrDataset.ResetReading;
begin
  FCount := 0;
  FFeatures.ResetReading;
end;

procedure TOgrDataset.ResetSQL;
begin
  FDataset.ReleaseResultSet(FLayer);
  FLayer := FDataset.GetLayer(0);
  FLayerCanChange := FLayer.TestCapability(OLCSequentialWrite) or FLayer.TestCapability(OLCRandomWrite);
  FFeatures.Free;
  FFeatures := TFastSpatialIndexCache.Create(FLayer);
  ResetReading;
  First;
end;

procedure TOgrDataset.SetBookmarkData(Buffer: PChar; Data: Pointer);
begin
  GetRecordObject(Buffer).Bookmark := PInt64(Data)^;
end;

procedure TOgrDataset.SetBookmarkFlag(Buffer: PChar; Value: TBookmarkFlag);
begin
  GetRecordObject(Buffer).BookmarkFlag := Value;
end;

procedure TOgrDataset.SetEncoding(const Value: string);
begin
  FEncoding := UpperCase(Value);
  //  CPLSetConfigOption('SHAPE_ENCODING', PChar(FEncoding));
  //  FEncodingIsUtf8 := AnsiSameText(FEncoding, 'UTF-8');
  if FIsTableOpen then begin
    Close;
    Open;
  end;
end;

procedure TOgrDataset.SetFieldData(Field: TField; Buffer: Pointer);
var
  FFeature: IOGRFeature;
  Rec: TOgrDSRecord;
begin
  if (Field.FieldNo >= 0) and (Field.FieldNo <= FLayer.GetLayerDefn.GetFieldCount) then begin
    Rec := CurrentTypedRecord;
    if Rec.RecordStatus <> fsDeleted then begin
      FFeature := Rec.Feature;
      FFeature.SetFieldString(Field.Index, PChar(Buffer));
      DataEvent(deFieldChange, longint(Field));
    end;
  end;
end;

procedure TOgrDataset.SetFileName(const Value: TFileName);
var
  Reopen: boolean;
begin
  if FFileName = Value then
    Exit;
  Reopen := Active;
  if Reopen then
    Close;
  FFileName  := Value;
  FLayerName := ChangeFileExt(ExtractFileName(FFileName), EmptyStr);
  if Reopen then
    Open;
end;

procedure TOgrDataset.SetFiltered(Value: boolean);
begin
  if Filtered = Value then
    Exit;
  inherited;
  InternalUpdateFilter;
end;

procedure TOgrDataset.SetFilterText(const Value: string);
begin
  if Filter = Value then
    Exit;
  inherited;
  if not Filtered then
    Exit;
  InternalUpdateFilter;
end;

procedure TOgrDataset.SetForceFullSpatialIndex(const Value: boolean);
begin
  FForceFullSpatialIndex := Value;
end;

procedure TOgrDataset.SetReadOnly(AValue: boolean);
begin
  if FReadOnly = AValue then
    Exit;
  FReadOnly := AValue;
  if Active then begin
    Close;
    Open;
  end;
end;

procedure TOgrDataset.SetRecNo(Value: integer);
begin
  FFeatures.RecNum := int64(Value);
end;

class function TSpecialField.Instance: TSpecialField;
begin
  Result := Self.Create;
end;

initialization
  OGRRegisterAll;
  SpecialFields := TObjectList.Create;

finalization
  OGRCleanupAll;
  FreeAndNil(SpecialFields);

end.
