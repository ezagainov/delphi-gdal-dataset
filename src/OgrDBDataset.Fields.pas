unit OgrDBDataset.Fields;

interface

uses
  ogr,
  DB,
  OGRFeatureUnit,
  OgrDBDataset;

type
  TStyleStringField = class(TSpecialField)
  protected
    class function FieldName: string; override;
    class function FieldType: TFieldType; override;
    class function FieldSize: integer; override;
    class function Value(const AFeature: IOGRFeature): variant; override;
  end;

  TGeomAreaField = class(TSpecialField)
  protected
    class function FieldName: string; override;
    class function FieldType: TFieldType; override;
    class function FieldSize: integer; override;
    class function Value(const AFeature: IOGRFeature): variant; override;
  end;

  TGeometryField = class(TSpecialField)
  protected
    class function FieldName: string; override;
    class function FieldType: TFieldType; override;
    class function FieldSize: integer; override;
    class function Value(const AFeature: IOGRFeature): variant; override;
  end;

  TGeometryCountField = class(TSpecialField)
  protected
    class function FieldName: string; override;
    class function FieldType: TFieldType; override;
    class function FieldSize: integer; override;
    class function Value(const AFeature: IOGRFeature): variant; override;
  end;

  TJsonGeometryField = class(TSpecialField)
  protected
    class function FieldName: string; override;
    class function FieldType: TFieldType; override;
    class function FieldSize: integer; override;
    class function Value(const AFeature: IOGRFeature): variant; override;
  end;

implementation

class function TStyleStringField.FieldName: string;
begin
  Result := 'OGR_STYLE';
end;

class function TStyleStringField.FieldSize: integer;
begin
  Result := 255;
end;

class function TStyleStringField.FieldType: TFieldType;
begin
  Result := ftString;
end;

class function TStyleStringField.Value(const AFeature: IOGRFeature): variant;
begin
  if AFeature.GetHandle <> nil then  
    Result := string(OGR_F_GetStyleString(AFeature.GetHandle));
end;

class function TGeomAreaField.FieldName: string;
begin
  Result := 'OGR_GEOM_AREA';
end;

class function TGeomAreaField.FieldSize: integer;
begin
  Result := 0;
end;

class function TGeomAreaField.FieldType: TFieldType;
begin
  Result := ftFloat;
end;

class function TGeomAreaField.Value(const AFeature: IOGRFeature): variant;
begin
  Result := OGR_G_GetArea(OGR_F_GetGeometryRef(AFeature.GetHandle));
end;

class function TGeometryField.FieldName: string;
begin
  Result := 'OGR_GEOMETRY';
end;

class function TGeometryField.FieldSize: integer;
begin
  Result := 255;
end;

class function TGeometryField.FieldType: TFieldType;
begin
  Result := ftString;
end;

class function TGeometryField.Value(const AFeature: IOGRFeature): variant;
begin
  Result := string(OGR_G_GetGeometryName(OGR_F_GetGeometryRef(AFeature.GetHandle)));
end;

class function TGeometryCountField.FieldName: string;
begin
  Result := 'OGR_GEOMETRYCOUNT';
end;

class function TGeometryCountField.FieldSize: integer;
begin
  Result := 0;
end;

class function TGeometryCountField.FieldType: TFieldType;
begin
  Result := ftInteger;
end;

class function TGeometryCountField.Value(const AFeature: IOGRFeature): variant;
begin
  Result := OGR_G_GetGeometryCount(OGR_F_GetGeometryRef(AFeature.GetHandle));
end;

class function TJsonGeometryField.FieldName: string;
begin
  Result := 'OGR_JSONGEOMETRY';
end;

class function TJsonGeometryField.FieldSize: integer;
begin
  Result := 255;
end;

class function TJsonGeometryField.FieldType: TFieldType;
begin
  Result := ftString;
end;

class function TJsonGeometryField.Value(const AFeature: IOGRFeature): variant;
begin
  Result := string(OGR_G_ExportToJson(OGR_F_GetGeometryRef(AFeature.GetHandle)));
end;

initialization
 {   SpecialFields.Add(TStyleStringField.Instance);
    SpecialFields.Add(TGeomAreaField.Instance);
    SpecialFields.Add(TGeometryField.Instance);
    SpecialFields.Add(TGeometryCountField.Instance);
    SpecialFields.Add(TJsonGeometryField.Instance);       }
end.
