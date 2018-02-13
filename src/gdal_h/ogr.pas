
{******************************************************************************
 * $Id: ogr_core.h 17722 2009-10-01 16:40:26Z warmerdam $
 *
 * Project:  OpenGIS Simple Features Reference Implementation
 * Purpose:  Define some core portability services for cross-platform OGR code.
 * Author:   Frank Warmerdam, warmerdam@pobox.com
 *
 ******************************************************************************
 * Copyright (c) 1999, Frank Warmerdam
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 ****************************************************************************}

{******************************************************************************
 * $Id: ogr_api.h 18226 2009-12-09 09:30:48Z chaitanya $
 *
 * Project:  OpenGIS Simple Features Reference Implementation
 * Purpose:  C API for OGR Geometry, Feature, Layers, DataSource and drivers.
 * Author:   Frank Warmerdam, warmerdam@pobox.com
 *
 ******************************************************************************
 * Copyright (c) 2002, Frank Warmerdam
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 ****************************************************************************}

{$H+}

{$IFDEF FPC}
  {$MODE objfpc}
  {$PACKRECORDS C}
{$ENDIF}

unit ogr;

interface

uses
  gdal, gdalcore, windows;

const

  OGRERR_NONE           = 0;
  OGRERR_NOT_ENOUGH_DATA = 1;
  OGRERR_NOT_ENOUGH_MEMORY = 2;
  OGRERR_UNSUPPORTED_GEOMETRY_TYPE = 3;
  OGRERR_UNSUPPORTED_OPERATION = 4;
  OGRERR_CORRUPT_DATA   = 5;
  OGRERR_FAILURE        = 6;
  OGRERR_UNSUPPORTED_SRS = 7;
  OGRERR_INVALID_HANDLE = 8;
  OGRERR_NON_EXISTING_FEATURE = 9;

  wkb25DBit = $80000000;

  ogrZMarker = $21125711;

  OGRNullFID     = -1;
  OGRUnsetMarker = -21121;

  OLCRandomRead         = 'RandomRead';
  OLCSequentialWrite    = 'SequentialWrite';
  OLCRandomWrite        = 'RandomWrite';
  OLCFastSpatialFilter  = 'FastSpatialFilter';
  OLCFastFeatureCount   = 'FastFeatureCount';
  OLCFastGetExtent      = 'FastGetExtent';
  OLCCreateField        = 'CreateField';
  OLCTransactions       = 'Transactions';
  OLCDeleteFeature      = 'DeleteFeature';
  OLCFastSetNextByIndex = 'FastSetNextByIndex';
  OLCStringsAsUTF8      = 'StringsAsUTF8';
  OLCIgnoreFields       = 'IgnoreFields';

  ODsCCreateLayer = 'CreateLayer';
  ODsCDeleteLayer = 'DeleteLayer';

  ODrCCreateDataSource = 'CreateDataSource';
  ODrCDeleteDataSource = 'DeleteDataSource';

type
  OGREnvelope = packed record
    MinX: double;
    MaxX: double;
    MinY: double;
    MaxY: double;
  end;

  OGRErr  = integer;
  POGRErr = ^OGRErr;

  OGRBoolean = GIntBig;

  OGRwkbGeometryType =
    (
    wkbUnknown = 0,
    wkbPoint = 1,

    wkbLineString = 2,
    wkbPolygon = 3,
    wkbMultiPoint = 4,
    wkbMultiLineString = 5,

    wkbMultiPolygon = 6,

    wkbGeometryCollection = 7,
    wkbNone = 100,
    wkbLinearRing = 101

    );

  OGRwkbByteOrder =
    (
    wkbXDR = 0,
    wkbNDR = 1
    );

  OGRFieldType =
    (
    OFTInteger = 0,
    OFTIntegerList = 1,
    OFTReal = 2,
    OFTRealList = 3,
    OFTString = 4,
    OFTStringList = 5,
    OFTWideString = 6,
    OFTWideStringList = 7,
    OFTBinary = 8,
    OFTDate = 9,
    OFTTime = 10,
    OFTDateTime = 11,
    OFTInteger64 = 12,
    OFTInteger64List = 13,
    OFTMaxType = 13
    );

  OGRJustification =
    (
    OJUndefined = 0,
    OJLeft = 1,
    OJRight = 2
    );

  OGRField = record
  end;

  ogr_style_tool_class_id =
    (
    OGRSTCNone = 0,
    OGRSTCPen = 1,
    OGRSTCBrush = 2,
    OGRSTCSymbol = 3,
    OGRSTCLabel = 4,
    OGRSTCVector = 5
    );
  OGRSTClassId = ogr_style_tool_class_id;

  ogr_style_tool_units_id =
    (
    OGRSTUGround = 0,
    OGRSTUPixel = 1,
    OGRSTUPoints = 2,
    OGRSTUMM = 3,
    OGRSTUCM = 4,
    OGRSTUInches = 5
    );
  OGRSTUnitId = ogr_style_tool_units_id;

  ogr_style_tool_param_pen_id =
    (
    OGRSTPenColor = 0,
    OGRSTPenWidth = 1,
    OGRSTPenPattern = 2,
    OGRSTPenId = 3,
    OGRSTPenPerOffset = 4,
    OGRSTPenCap = 5,
    OGRSTPenJoin = 6,
    OGRSTPenPriority = 7,
    OGRSTPenLast = 8
    );
  OGRSTPenParam = ogr_style_tool_param_pen_id;

  ogr_style_tool_param_brush_id =
    (
    OGRSTBrushFColor = 0,
    OGRSTBrushBColor = 1,
    OGRSTBrushId = 2,
    OGRSTBrushAngle = 3,
    OGRSTBrushSize = 4,
    OGRSTBrushDx = 5,
    OGRSTBrushDy = 6,
    OGRSTBrushPriority = 7,
    OGRSTBrushLast = 8
    );
  OGRSTBrushParam = ogr_style_tool_param_brush_id;

  ogr_style_tool_param_symbol_id =
    (
    OGRSTSymbolId = 0,
    OGRSTSymbolAngle = 1,
    OGRSTSymbolColor = 2,
    OGRSTSymbolSize = 3,
    OGRSTSymbolDx = 4,
    OGRSTSymbolDy = 5,
    OGRSTSymbolStep = 6,
    OGRSTSymbolPerp = 7,
    OGRSTSymbolOffset = 8,
    OGRSTSymbolPriority = 9,
    OGRSTSymbolFontName = 10,
    OGRSTSymbolOColor = 11,
    OGRSTSymbolLast = 12
    );
  OGRSTSymbolParam = ogr_style_tool_param_symbol_id;

  ogr_style_tool_param_label_id =
    (
    OGRSTLabelFontName = 0,
    OGRSTLabelSize = 1,
    OGRSTLabelTextString = 2,
    OGRSTLabelAngle = 3,
    OGRSTLabelFColor = 4,
    OGRSTLabelBColor = 5,
    OGRSTLabelPlacement = 6,
    OGRSTLabelAnchor = 7,
    OGRSTLabelDx = 8,
    OGRSTLabelDy = 9,
    OGRSTLabelPerp = 10,
    OGRSTLabelBold = 11,
    OGRSTLabelItalic = 12,
    OGRSTLabelUnderline = 13,
    OGRSTLabelPriority = 14,
    OGRSTLabelStrikeout = 15,
    OGRSTLabelStretch = 16,
    OGRSTLabelAdjHor = 17,
    OGRSTLabelAdjVert = 18,
    OGRSTLabelHColor = 19,
    OGRSTLabelOColor = 20,
    OGRSTLabelLast = 21
    );
  OGRSTLabelParam = ogr_style_tool_param_label_id;

  OGRGeometryH         = Pointer;
  OGRSpatialReferenceH = Pointer;
  OGRCoordinateTransformationH = Pointer;

  OGRFieldDefnH   = Pointer;
  OGRFeatureDefnH = Pointer;
  OGRFeatureH     = Pointer;
  OGRStyleTableH  = Pointer;

  OGRLayerH      = Pointer;
  OGRDataSourceH = Pointer;
  OGRSFDriverH   = Pointer;

  OGRStyleMgrH  = Pointer;
  OGRStyleToolH = Pointer;

type
  TOGRMergeGeometryTypes = function(eMain: OGRwkbGeometryType; eExtra: OGRwkbGeometryType): OGRwkbGeometryType; cdecl;
  TOGRParseDate = function(pszInput: CPChar; psOutput: OGRField; nOptions: GIntBig): GIntBig; cdecl;
  TGDALVersionInfo = function(pszRequest: CPChar): CPChar; cdecl;
  TGDALCheckVersion = function(nVersionMajor: GIntBig; nVersionMinor: GIntBig; pszCallingComponentName: CPChar): GIntBig; cdecl;
  TOGR_G_CreateFromWkb = function(pabyData: CPChar; hSRS: OGRSpatialReferenceH; phGeometry: OGRGeometryH; nBytes: GIntBig): OGRErr; cdecl;
  TOGR_G_CreateFromWkt = function(ppszData: CPChar; hSRS: OGRSpatialReferenceH; phGeometry: OGRGeometryH): OGRErr; cdecl;
  TOGR_G_DestroyGeometry = procedure(hGeom: OGRGeometryH); cdecl;
  TOGR_G_CreateGeometry = function(eGeometryType: OGRwkbGeometryType): OGRGeometryH; cdecl;
  TOGR_G_ForceToPolygon = function(hGeom: OGRGeometryH): OGRGeometryH; cdecl;
  TOGR_G_ForceToMultiPolygon = function(hGeom: OGRGeometryH): OGRGeometryH; cdecl;
  TOGR_G_ForceToMultiPoint = function(hGeom: OGRGeometryH): OGRGeometryH; cdecl;
  TOGR_G_ForceToMultiLineString = function(hGeom: OGRGeometryH): OGRGeometryH; cdecl;
  TOGR_G_GetDimension = function(hGeom: OGRGeometryH): GIntBig; cdecl;
  TOGR_G_GetCoordinateDimension = function(hGeom: OGRGeometryH): GIntBig; cdecl;
  TOGR_G_Clone = function(hGeom: OGRGeometryH): OGRGeometryH; cdecl;
  TOGR_G_GetEnvelope = procedure(hGeom: OGRGeometryH; psEnvelope: OGREnvelope); cdecl;
  TOGR_G_ImportFromWkb = function(hGeom: OGRGeometryH; pabyData: CPChar; nSize: GIntBig): OGRErr; cdecl;
  TOGR_G_ExportToWkb = function(hGeom: OGRGeometryH; eOrder: OGRwkbByteOrder; pabyDstBuffer: CPChar): OGRErr; cdecl;
  TOGR_G_WkbSize = function(hGeom: OGRGeometryH): GIntBig; cdecl;
  TOGR_G_ImportFromWkt = function(hGeom: OGRGeometryH; ppszSrcText: PCPChar): OGRErr; cdecl;
  TOGR_G_ExportToWkt = function(hGeom: OGRGeometryH; ppszSrcText: PCPChar): OGRErr; cdecl;
  TOGR_G_ExportToJson = function(hGeom: OGRGeometryH): CPChar; cdecl;
  TOGR_G_GetGeometryType = function(hGeom: OGRGeometryH): OGRwkbGeometryType; cdecl;
  TOGR_G_GetGeometryName = function(hGeom: OGRGeometryH): CPChar; cdecl;
  TOGR_G_DumpReadable = procedure(hGeom: OGRGeometryH; fp: Pointer; pszPrefix: CPChar); cdecl;
  TOGR_G_FlattenTo2D = procedure(hGeom: OGRGeometryH); cdecl;
  TOGR_G_AssignSpatialReference = procedure(hGeom: OGRGeometryH; hSRS: OGRSpatialReferenceH); cdecl;
  TOGR_G_Transform = function(hGeom: OGRGeometryH; hTransform: OGRCoordinateTransformationH): OGRErr; cdecl;
  TOGR_G_TransformTo = function(hGeom: OGRGeometryH; hSRS: OGRSpatialReferenceH): OGRErr; cdecl;
  TOGR_G_Segmentize = procedure(hGeom: OGRGeometryH; dfMaxLength: double); cdecl;
  TOGR_G_Intersects = function(hGeom: OGRGeometryH; hOtherGeom: OGRGeometryH): GIntBig; cdecl;
  TOGR_G_Equals = function(hGeom: OGRGeometryH; hOther: OGRGeometryH): GIntBig; cdecl;
  TOGR_G_Disjoint = function(hGeom: OGRGeometryH; hOther: OGRGeometryH): GIntBig; cdecl;
  TOGR_G_Touches = function(hThis: OGRGeometryH; hOther: OGRGeometryH): GIntBig; cdecl;
  TOGR_G_Crosses = function(hThis: OGRGeometryH; hOther: OGRGeometryH): GIntBig; cdecl;
  TOGR_G_Within = function(hThis: OGRGeometryH; hOther: OGRGeometryH): GIntBig; cdecl;
  TOGR_G_Contains = function(hThis: OGRGeometryH; hOther: OGRGeometryH): GIntBig; cdecl;
  TOGR_G_Overlaps = function(hThis: OGRGeometryH; hOther: OGRGeometryH): GIntBig; cdecl;
  TOGR_G_GetBoundary = function(hTarget: OGRGeometryH): OGRGeometryH; cdecl;
  TOGR_G_ConvexHull = function(hTarget: OGRGeometryH): OGRGeometryH; cdecl;
  TOGR_G_Buffer = function(hTarget: OGRGeometryH; dfDist: double; nQuadSegs: GIntBig): OGRGeometryH; cdecl;
  TOGR_G_Intersection = function(hThis: OGRGeometryH; hOther: OGRGeometryH): OGRGeometryH; cdecl;
  TOGR_G_Union = function(hThis: OGRGeometryH; hOther: OGRGeometryH): OGRGeometryH; cdecl;
  TOGR_G_UnionCascaded = function(hThis: OGRGeometryH): OGRGeometryH; cdecl;
  TOGR_G_Difference = function(hThis: OGRGeometryH; hOther: OGRGeometryH): OGRGeometryH; cdecl;
  TOGR_G_SymmetricDifference = function(hThis: OGRGeometryH; hOther: OGRGeometryH): OGRGeometryH; cdecl;
  TOGR_G_Distance = function(hFirst: OGRGeometryH; hOther: OGRGeometryH): double; cdecl;
  TOGR_G_GetArea = function(hGeom: OGRGeometryH): double; cdecl;
  TOGR_G_Centroid = function(hGeom: OGRGeometryH; hCentroidPoint: OGRGeometryH): GIntBig; cdecl;
  TOGR_G_Empty = procedure(hGeom: OGRGeometryH); cdecl;
  TOGR_G_IsEmpty = function(hGeom: OGRGeometryH): GIntBig; cdecl;
  TOGR_G_IsValid = function(hGeom: OGRGeometryH): GIntBig; cdecl;
  TOGR_G_IsSimple = function(hGeom: OGRGeometryH): GIntBig; cdecl;
  TOGR_G_IsRing = function(hGeom: OGRGeometryH): GIntBig; cdecl;
  TOGR_G_Intersect = function(hGeom: OGRGeometryH; hOtherGeom: OGRGeometryH): GIntBig; cdecl;
  TOGR_G_Equal = function(hGeom: OGRGeometryH; hOther: OGRGeometryH): GIntBig; cdecl;
  TOGR_G_GetPointCount = function(hGeom: OGRGeometryH): GIntBig; cdecl;
  TOGR_G_GetX = function(hGeom: OGRGeometryH; i: GIntBig): double; cdecl;
  TOGR_G_GetY = function(hGeom: OGRGeometryH; i: GIntBig): double; cdecl;
  TOGR_G_GetZ = function(hGeom: OGRGeometryH; i: GIntBig): double; cdecl;
  TOGR_G_GetPoint = procedure(hGeom: OGRGeometryH; i: GIntBig; pdfX: double; pdfY: double; pdfZ: double); cdecl;
  TOGR_G_SetPoint = procedure(hGeom: OGRGeometryH; i: GIntBig; dfX: double; dfY: double; dfZ: double); cdecl;
  TOGR_G_SetPoint_2D = procedure(hGeom: OGRGeometryH; i: GIntBig; pdfX: double; pdfY: double); cdecl;
  TOGR_G_AddPoint = procedure(hGeom: OGRGeometryH; dfX: double; dfY: double; dfZ: double); cdecl;
  TOGR_G_AddPoint_2D = procedure(hGeom: OGRGeometryH; dfX: double; dfY: double); cdecl;
  TOGR_G_GetGeometryCount = function(hGeom: OGRGeometryH): GIntBig; cdecl;
  TOGR_G_GetGeometryRef = function(hGeom: OGRGeometryH; iSubGeom: GIntBig): OGRGeometryH; cdecl;
  TOGR_G_AddGeometry = function(hGeom: OGRGeometryH; hNewSubGeom: OGRGeometryH): OGRErr; cdecl;
  TOGR_G_AddGeometryDirectly = function(hGeom: OGRGeometryH; hNewSubGeom: OGRGeometryH): OGRErr; cdecl;
  TOGR_G_RemoveGeometry = function(hGeom: OGRGeometryH; iGeom: GIntBig; bDelete: GIntBig): OGRErr; cdecl;
  TOGRBuildPolygonFromEdges = function(hLines: OGRGeometryH; bBestEffort: GIntBig; bAutoClose: GIntBig; dfTolerance: double; peErr: OGRErr): OGRGeometryH; cdecl;
  TOGR_Fld_Create = function(pszName: CPChar; eType: OGRFieldType): OGRFieldDefnH; cdecl;
  TOGR_Fld_Destroy = procedure(hDefn: OGRFieldDefnH); cdecl;
  TOGR_Fld_SetName = procedure(hDefn: OGRFieldDefnH; pszName: CPChar); cdecl;
  TOGR_Fld_GetNameRef = function(hDefn: OGRFieldDefnH): CPChar; cdecl;
  TOGR_Fld_GetType = function(hDefn: OGRFieldDefnH): OGRFieldType; cdecl;
  TOGR_Fld_SetType = procedure(hDefn: OGRFieldDefnH; eType: OGRFieldType); cdecl;
  TOGR_Fld_GetJustify = function(hDefn: OGRFieldDefnH): OGRJustification; cdecl;
  TOGR_Fld_SetJustify = procedure(hDefn: OGRFieldDefnH; eJustify: OGRJustification); cdecl;
  TOGR_Fld_GetWidth = function(hDefn: OGRFieldDefnH): GIntBig; cdecl;
  TOGR_Fld_SetWidth = procedure(hDefn: OGRFieldDefnH; nNewWidth: GIntBig); cdecl;
  TOGR_Fld_GetPrecision = function(hDefn: OGRFieldDefnH): GIntBig; cdecl;
  TOGR_Fld_SetPrecision = procedure(hDefn: OGRFieldDefnH; nPrecision: GIntBig); cdecl;
  TOGR_Fld_Set = procedure(hDefn: OGRFieldDefnH; pszNameIn: CPChar; eTypeIn: OGRFieldType; nWidthIn: GIntBig; nPrecision: GIntBig; eJustifyIn: OGRJustification); cdecl;
  TOGR_Fld_IsIgnored = function(hDefn: OGRFieldDefnH): GIntBig; cdecl;
  TOGR_Fld_SetIgnored = procedure(hDefn: OGRFieldDefnH; fieldIndex: GIntBig); cdecl;
  TOGR_GetFieldTypeName = function(eType: OGRFieldType): CPChar; cdecl;
  TOGR_FD_Create = function(pszName: CPChar): OGRFeatureDefnH; cdecl;
  TOGR_FD_Destroy = procedure(hDefn: OGRFeatureDefnH); cdecl;
  TOGR_FD_Release = procedure(hDefn: OGRFeatureDefnH); cdecl;
  TOGR_FD_GetName = function(hDefn: OGRFeatureDefnH): CPChar; cdecl;
  TOGR_FD_GetFieldCount = function(hDefn: OGRFeatureDefnH): GIntBig; cdecl;
  TOGR_FD_GetFieldDefn = function(hDefn: OGRFeatureDefnH; iField: GIntBig): OGRFieldDefnH; cdecl;
  TOGR_FD_GetFieldIndex = function(hDefn: OGRFeatureDefnH; pszFieldName: CPChar): GIntBig; cdecl;
  TOGR_FD_AddFieldDefn = procedure(hDefn: OGRFeatureDefnH; hNewField: OGRFieldDefnH); cdecl;
  TOGR_FD_GetGeomType = function(hDefn: OGRFeatureDefnH): OGRwkbGeometryType; cdecl;
  TOGR_FD_SetGeomType = procedure(hDefn: OGRFeatureDefnH; eType: OGRwkbGeometryType); cdecl;
  TOGR_FD_IsGeometryIgnored = function(hDefn: OGRFeatureDefnH): GIntBig; cdecl;
  TOGR_FD_SetGeometryIgnored = procedure(hDefn: OGRFeatureDefnH; bIgnored: GIntBig); cdecl;
  TOGR_FD_IsStyleIgnored = function(hDefn: OGRFeatureDefnH): GIntBig; cdecl;
  TOGR_FD_SetStyleIgnored = procedure(hDefn: OGRFeatureDefnH; bIgnored: GIntBig); cdecl;
  TOGR_FD_Reference = function(hDefn: OGRFeatureDefnH): GIntBig; cdecl;
  TOGR_FD_Dereference = function(hDefn: OGRFeatureDefnH): GIntBig; cdecl;
  TOGR_F_Create = function(hDefn: OGRFeatureDefnH): OGRFeatureH; cdecl;
  TOGR_F_Destroy = procedure(hFeat: OGRFeatureH); cdecl;
  TOGR_F_GetDefnRef = function(hFeat: OGRFeatureH): OGRFeatureDefnH; cdecl;
  TOGR_F_SetGeometryDirectly = function(hFeat: OGRFeatureH; hGeom: OGRGeometryH): OGRErr; cdecl;
  TOGR_F_SetGeometry = function(hFeat: OGRFeatureH; hGeom: OGRGeometryH): OGRErr; cdecl;
  TOGR_F_GetGeometryRef = function(hFeat: OGRFeatureH): OGRGeometryH; cdecl;
  TOGR_F_Clone = function(hFeat: OGRFeatureH): OGRFeatureH; cdecl;
  TOGR_F_Equal = function(hFeat: OGRFeatureH; hOtherFeat: OGRFeatureH): GIntBig; cdecl;
  TOGR_F_GetFieldCount = function(hFeat: OGRFeatureH): GIntBig; cdecl;
  TOGR_F_GetFieldDefnRef = function(hFeat: OGRFeatureH; i: GIntBig): OGRFieldDefnH; cdecl;
  TOGR_F_GetFieldIndex = function(hFeat: OGRFeatureH; pszName: CPChar): GIntBig; cdecl;
  TOGR_F_IsFieldSet = function(hFeat: OGRFeatureH; iField: GIntBig): GIntBig; cdecl;
  TOGR_F_UnsetField = procedure(hFeat: OGRFeatureH; iField: GIntBig); cdecl;
  TOGR_F_GetRawFieldRef = function(hFeat: OGRFeatureH; iField: GIntBig): OGRField; cdecl;
  TOGR_F_GetFieldAsInteger = function(hFeat: OGRFeatureH; iField: GIntBig): GIntBig; cdecl;
  TOGR_F_GetFieldAsDouble = function(hFeat: OGRFeatureH; iField: GIntBig): double; cdecl;
  TOGR_F_GetFieldAsString = function(hFeat: OGRFeatureH; iField: GIntBig): CPChar; cdecl;
  TOGR_F_GetFieldAsIntegerList = function(hFeat: OGRFeatureH; iField: GIntBig; pnCount: GIntBig): GIntBig; cdecl;
  TOGR_F_GetFieldAsDoubleList = function(hFeat: OGRFeatureH; iField: GIntBig; pnCount: PLongInt): double; cdecl;
  TOGR_F_GetFieldAsStringList = function(hFeat: OGRFeatureH; iField: GIntBig): CPChar; cdecl;
  TOGR_F_GetFieldAsBinary = function(hFeat: OGRFeatureH; iField: GIntBig; pnBytes: PLongInt): GByte; cdecl;
  TOGR_F_GetFieldAsDateTime = function(hFeat: OGRFeatureH; iField: GIntBig; pnYear: PLongInt; pnMonth: PLongInt; pnDay: PLongInt; pnHour: PLongInt; pnMinute: PLongInt; pnSecond: PLongInt; pnTZFlag: PLongInt): GIntBig; cdecl;
  TOGR_F_SetFieldInteger = procedure(hFeat: OGRFeatureH; iField: GIntBig; nValue: GIntBig); cdecl;
  TOGR_F_SetFieldDouble = procedure(hFeat: OGRFeatureH; iField: GIntBig; dfValue: double); cdecl;
  TOGR_F_SetFieldString = procedure(hFeat: OGRFeatureH; iField: integer; pszValue: CPChar); cdecl;
  TOGR_F_SetFieldIntegerList = procedure(hFeat: OGRFeatureH; iField: GIntBig; nCount: GIntBig; panValues: PLongInt); cdecl;
  TOGR_F_SetFieldDoubleList = procedure(hFeat: OGRFeatureH; iField: GIntBig; nCount: GIntBig; padfValues: Pdouble); cdecl;
  TOGR_F_SetFieldStringList = procedure(hFeat: OGRFeatureH; iField: GIntBig; papszValues: PCPChar); cdecl;
  TOGR_F_SetFieldRaw = procedure(hFeat: OGRFeatureH; iField: GIntBig; psValue: OGRField); cdecl;
  TOGR_F_SetFieldBinary = procedure(hFeat: OGRFeatureH; iField: GIntBig; nBytes: GIntBig; pabyData: GByte); cdecl;
  TOGR_F_SetFieldDateTime = procedure(hFeat: OGRFeatureH; iField: GIntBig; nYear: GIntBig; nMonth: GIntBig; nDay: GIntBig; nHour: GIntBig; nMinute: GIntBig; nSecond: GIntBig; nTZFlag: GIntBig); cdecl;
  TOGR_F_GetFID = function(hFeat: OGRFeatureH): GIntBig; cdecl;
  TOGR_F_SetFID = function(hFeat: OGRFeatureH; nFID: GIntBig): OGRErr; cdecl;
  TOGR_F_DumpReadable = procedure(hFeat: OGRFeatureH; fpOut: Pointer); cdecl;
  TOGR_F_SetFrom = function(hFeat: OGRFeatureH; hOtherFeat: OGRFeatureH; bForgiving: GIntBig): OGRErr; cdecl;
  TOGR_F_SetFromWithMap = function(hFeat: OGRFeatureH; hOtherFeat: OGRFeatureH; bForgiving: GIntBig; panMap: PLongInt): OGRErr; cdecl;
  TOGR_F_GetStyleString = function(hFeat: OGRFeatureH): CPChar; cdecl;
  TOGR_F_SetStyleString = procedure(hFeat: OGRFeatureH; pszStyle: CPChar); cdecl;
  TOGR_F_SetStyleStringDirectly = procedure(hFeat: OGRFeatureH; pszStyle: CPChar); cdecl;
  TOGR_L_Update = function(pLayerInput, pLayerMethod, pLayerResult: OGRLayerH; papszOptions: PCPChar; pfnProgress: GDALProgressFunc; pProgressData: Pointer): OGRErr; cdecl;
  TOGR_L_GetSpatialFilter = function(hLayer: OGRLayerH): OGRGeometryH; cdecl;
  TOGR_L_SetSpatialFilter = procedure(hLayer: OGRLayerH; hGeom: OGRGeometryH); cdecl;
  TOGR_L_SetSpatialFilterRect = procedure(hLayer: OGRLayerH; dfMinX: double; dfMinY: double; dfMaxX: double; dfMaxY: double); cdecl;
  TOGR_L_SetAttributeFilter = function(hLayer: OGRLayerH; pszQuery: CPChar): OGRErr; cdecl;
  TOGR_L_ResetReading = procedure(hLayer: OGRLayerH); cdecl;
  TOGR_L_GetNextFeature = function(hLayer: OGRLayerH): OGRFeatureH; cdecl;
  TOGR_L_GetName = function(hLayer: OGRLayerH): CPChar; cdecl;
  TOGR_L_SetNextByIndex = function(hLayer: OGRLayerH; nIndex: GIntBig): OGRErr; cdecl;
  TOGR_L_GetFeature = function(hLayer: OGRLayerH; nFeatureId: GIntBig): OGRFeatureH; cdecl;
  TOGR_L_SetFeature = function(hLayer: OGRLayerH; hFeat: OGRFeatureH): OGRErr; cdecl;
  TOGR_L_CreateFeature = function(hLayer: OGRLayerH; hFeat: OGRFeatureH): OGRErr; cdecl;
  TOGR_L_DeleteFeature = function(hLayer: OGRLayerH; nFID: GIntBig): OGRErr; cdecl;
  TOGR_L_GetLayerDefn = function(hLayer: OGRLayerH): OGRFeatureDefnH; cdecl;
  TOGR_L_GetSpatialRef = function(hLayer: OGRLayerH): OGRSpatialReferenceH; cdecl;
  TOGR_L_GetFeatureCount = function(hLayer: OGRLayerH; bForce: GIntBig): GIntBig; cdecl;
  TOGR_L_GetExtent = function(hLayer: OGRLayerH; var psExtent: OGREnvelope; bForce: integer): OGRErr; cdecl;
  TOGR_L_TestCapability = function(hLayer: OGRLayerH; pszCap: CPChar): integer; cdecl;
  TOGR_L_CreateField = function(hLayer: OGRLayerH; hField: OGRFieldDefnH; bApproxOK: GIntBig): OGRErr; cdecl;
  TOGR_L_StartTransaction = function(hLayer: OGRLayerH): OGRErr; cdecl;
  TOGR_L_CommitTransaction = function(hLayer: OGRLayerH): OGRErr; cdecl;
  TOGR_L_RollbackTransaction = function(hLayer: OGRLayerH): OGRErr; cdecl;
  TOGR_L_SyncToDisk = function(hLayer: OGRLayerH): OGRErr; cdecl;
  TOGR_L_GetFIDColumn = function(hLayer: OGRLayerH): CPChar; cdecl;
  TOGR_L_GetGeometryColumn = function(hLayer: OGRLayerH): CPChar; cdecl;
  TOGR_L_SetIgnoredFields = function(hLayer: OGRLayerH; fields: CPChar): OGRErr; cdecl;
  TOGR_DS_Destroy = procedure(hDataSource: OGRDataSourceH); cdecl;
  TOGR_DS_GetName = function(hDS: OGRDataSourceH): CPChar; cdecl;
  TOGR_DS_GetLayerCount = function(hDS: OGRDataSourceH): GIntBig; cdecl;
  TOGR_DS_GetLayer = function(hDS: OGRDataSourceH; iLayer: GIntBig): OGRLayerH; cdecl;
  TOGR_DS_GetLayerByName = function(hDS: OGRDataSourceH; pszLayerName: CPChar): OGRLayerH; cdecl;
  TOGR_DS_DeleteLayer = function(hDS: OGRDataSourceH; iLayer: GIntBig): OGRErr; cdecl;
  TOGR_DS_GetDriver = function(hDS: OGRDataSourceH): OGRSFDriverH; cdecl;
  TOGR_DS_CreateLayer = function(hDS: OGRDataSourceH; pszName: CPChar; hSpatialRef: OGRSpatialReferenceH; eType: OGRwkbGeometryType; papszOptions: PCPChar): OGRLayerH; cdecl;
  TOGR_DS_CopyLayer = function(hDS: OGRDataSourceH; hSrcLayer: OGRLayerH; pszNewName: CPChar; papszOptions: PCPChar): OGRLayerH; cdecl;
  TOGR_DS_TestCapability = function(hDS: OGRDataSourceH; pszCapability: CPChar): GIntBig; cdecl;
  TOGR_DS_ExecuteSQL = function(hDS: OGRDataSourceH; pszSQLCommand: CPChar; hSpatialFilter: OGRGeometryH; pszDialect: CPChar): OGRLayerH; cdecl;
  TOGR_DS_ReleaseResultSet = procedure(hDS: OGRDataSourceH; hLayer: OGRLayerH); cdecl;
  TOGR_DS_SyncToDisk = function(hDS: OGRDataSourceH): OGRErr; cdecl;
  TOGR_Dr_GetName = function(hDriver: OGRSFDriverH): CPChar; cdecl;
  TOGR_Dr_Open = function(hDriver: OGRSFDriverH; pszName: CPChar; bUpdate: GIntBig): OGRDataSourceH; cdecl;
  TOGR_Dr_TestCapability = function(hDriver: OGRSFDriverH; pszCap: CPChar): GIntBig; cdecl;
  TOGR_Dr_CreateDataSource = function(hDriver: OGRSFDriverH; pszName: CPChar; papszOptions: PCPChar): OGRDataSourceH; cdecl;
  TOGR_Dr_CopyDataSource = function(hDriver: OGRSFDriverH; hSrcDS: OGRDataSourceH; pszNewName: CPChar; papszOptions: PCPChar): OGRDataSourceH; cdecl;
  TOGR_Dr_DeleteDataSource = function(hDriver: OGRSFDriverH; pszDataSource: CPChar): OGRErr; cdecl;
  TOGROpen = function(pszName: CPChar; bUpdate: integer; pahDriverList: OGRSFDriverH): OGRDataSourceH; cdecl;
  TOGRReleaseDataSource = function(hDS: OGRDataSourceH): OGRErr; cdecl;
  TOGRRegisterDriver = procedure(hDriver: OGRSFDriverH); cdecl;
  TOGRDeregisterDriver = procedure(hDriver: OGRSFDriverH); cdecl;
  TOGRGetDriverCount = function: GIntBig; cdecl;
  TOGRGetDriver = function(iDriver: GIntBig): OGRSFDriverH; cdecl;
  TOGRGetDriverByName = function(pszName: CPChar): OGRSFDriverH; cdecl;
  TOGRGetOpenDSCount = function: GIntBig; cdecl;
  TOGRGetOpenDS = function(iDS: GIntBig): OGRDataSourceH; cdecl;
  TOGRRegisterAll = procedure; cdecl;
  TOGRCleanupAll = procedure; cdecl;
  TOGR_SM_Create = function(hStyleTable: OGRStyleTableH): OGRStyleMgrH; cdecl;
  TOGR_SM_Destroy = procedure(hSM: OGRStyleMgrH); cdecl;
  TOGR_SM_InitFromFeature = function(hSM: OGRStyleMgrH; hFeat: OGRFeatureH): CPChar; cdecl;
  TOGR_SM_InitStyleString = function(hSM: OGRStyleMgrH; pszStyleString: CPChar): GIntBig; cdecl;
  TOGR_SM_GetPartCount = function(hSM: OGRStyleMgrH; pszStyleString: CPChar): GIntBig; cdecl;
  TOGR_SM_GetPart = function(hSM: OGRStyleMgrH; nPartId: GIntBig; pszStyleString: CPChar): OGRStyleToolH; cdecl;
  TOGR_SM_AddPart = function(hSM: OGRStyleMgrH; hST: OGRStyleToolH): GIntBig; cdecl;
  TOGR_SM_AddStyle = function(hSM: OGRStyleMgrH; pszStyleName: CPChar; pszStyleString: CPChar): GIntBig; cdecl;
  TOGR_ST_Create = function(eClassId: OGRSTClassId): OGRStyleToolH; cdecl;
  TOGR_ST_Destroy = procedure(hST: OGRStyleToolH); cdecl;
  TOGR_ST_GetType = function(hST: OGRStyleToolH): OGRSTClassId; cdecl;
  TOGR_ST_GetUnit = function(hST: OGRStyleToolH): OGRSTUnitId; cdecl;
  TOGR_ST_SetUnit = procedure(hST: OGRStyleToolH; eUnit: OGRSTUnitId; dfGroundPaperScale: double); cdecl;
  TOGR_ST_GetParamStr = function(hST: OGRStyleToolH; eParam: GIntBig; bValueIsNull: PLongInt): PChar; cdecl;
  TOGR_ST_GetParamNum = function(hST: OGRStyleToolH; eParam: GIntBig; bValueIsNull: PLongInt): GIntBig; cdecl;
  TOGR_ST_GetParamDbl = function(hST: OGRStyleToolH; eParam: GIntBig; bValueIsNull: PLongInt): double; cdecl;
  TOGR_ST_SetParamStr = procedure(hST: OGRStyleToolH; eParam: GIntBig; pszValue: CPChar); cdecl;
  TOGR_ST_SetParamNum = procedure(hST: OGRStyleToolH; eParam: GIntBig; nValue: GIntBig); cdecl;
  TOGR_ST_SetParamDbl = procedure(hST: OGRStyleToolH; eParam: GIntBig; dfValue: double); cdecl;
  TOGR_ST_GetStyleString = function(hST: OGRStyleToolH): CPChar; cdecl;
  TOGR_ST_GetRGBFromString = function(hST: OGRStyleToolH; pszColor: CPChar; pnRed: PLongInt; pnGreen: PLongInt; pnBlue: PLongInt; pnAlpha: PLongInt): GIntBig; cdecl;
  TOGR_STBL_Create = function: OGRStyleTableH; cdecl;
  TOGR_STBL_Destroy = procedure(hSTBL: OGRStyleTableH); cdecl;
  TOGR_STBL_SaveStyleTable = function(hStyleTable: OGRStyleTableH; pszFilename: CPChar): GIntBig; cdecl;
  TOGR_STBL_LoadStyleTable = function(hStyleTable: OGRStyleTableH; pszFilename: CPChar): GIntBig; cdecl;
  TOGR_STBL_Find = function(hStyleTable: OGRStyleTableH; pszName: CPChar): CPChar; cdecl;
  TOGR_STBL_ResetStyleStringReading = procedure(hStyleTable: OGRStyleTableH); cdecl;
  TOGR_STBL_GetNextStyle = function(hStyleTable: OGRStyleTableH): CPChar; cdecl;
  TOGR_STBL_GetLastStyfleName = function(hStyleTable: OGRStyleTableH): CPChar; cdecl;

var
  OGRMergeGeometryTypes: TOGRMergeGeometryTypes;
  OGRParseDate:      TOGRParseDate;
  GDALVersionInfo:   TGDALVersionInfo;
  OGR_G_CreateFromWkb: TOGR_G_CreateFromWkb;
  OGR_G_CreateFromWkt: TOGR_G_CreateFromWkt;
  OGR_G_DestroyGeometry: TOGR_G_DestroyGeometry;
  OGR_G_CreateGeometry: TOGR_G_CreateGeometry;
  OGR_G_ForceToPolygon: TOGR_G_ForceToPolygon;
  OGR_G_ForceToMultiPolygon: TOGR_G_ForceToMultiPolygon;
  OGR_G_ForceToMultiPoint: TOGR_G_ForceToMultiPoint;
  OGR_G_ForceToMultiLineString: TOGR_G_ForceToMultiLineString;
  OGR_G_GetDimension: TOGR_G_GetDimension;
  OGR_G_GetCoordinateDimension: TOGR_G_GetCoordinateDimension;
  OGR_G_Clone:       TOGR_G_Clone;
  OGR_G_GetEnvelope: TOGR_G_GetEnvelope;
  OGR_G_ImportFromWkb: TOGR_G_ImportFromWkb;
  OGR_G_ExportToWkb: TOGR_G_ExportToWkb;
  OGR_G_WkbSize:     TOGR_G_WkbSize;
  OGR_G_ImportFromWkt: TOGR_G_ImportFromWkt;
  OGR_G_ExportToWkt: TOGR_G_ExportToWkt;
  OGR_G_ExportToJson: TOGR_G_ExportToJson;
  OGR_G_GetGeometryType: TOGR_G_GetGeometryType;
  OGR_G_GetGeometryName: TOGR_G_GetGeometryName;
  OGR_G_DumpReadable: TOGR_G_DumpReadable;
  OGR_G_FlattenTo2D: TOGR_G_FlattenTo2D;
  OGR_G_AssignSpatialReference: TOGR_G_AssignSpatialReference;
  OGR_G_Transform:   TOGR_G_Transform;
  OGR_G_TransformTo: TOGR_G_TransformTo;
  OGR_G_Segmentize:  TOGR_G_Segmentize;
  OGR_G_Intersects:  TOGR_G_Intersects;
  OGR_G_Equals:      TOGR_G_Equals;
  OGR_G_Disjoint:    TOGR_G_Disjoint;
  OGR_G_Touches:     TOGR_G_Touches;
  OGR_G_Crosses:     TOGR_G_Crosses;
  OGR_G_Within:      TOGR_G_Within;
  OGR_G_Contains:    TOGR_G_Contains;
  OGR_G_Overlaps:    TOGR_G_Overlaps;
  OGR_G_GetBoundary: TOGR_G_GetBoundary;
  OGR_G_ConvexHull:  TOGR_G_ConvexHull;
  OGR_G_Buffer:      TOGR_G_Buffer;
  OGR_G_Intersection: TOGR_G_Intersection;
  OGR_G_Union:       TOGR_G_Union;
  OGR_G_UnionCascaded: TOGR_G_UnionCascaded;
  OGR_G_Difference:  TOGR_G_Difference;
  OGR_G_SymmetricDifference: TOGR_G_SymmetricDifference;
  OGR_G_Distance:    TOGR_G_Distance;
  OGR_G_GetArea:     TOGR_G_GetArea;
  OGR_G_Centroid:    TOGR_G_Centroid;
  OGR_G_Empty:       TOGR_G_Empty;
  OGR_G_IsEmpty:     TOGR_G_IsEmpty;
  OGR_G_IsValid:     TOGR_G_IsValid;
  OGR_G_IsSimple:    TOGR_G_IsSimple;
  OGR_G_IsRing:      TOGR_G_IsRing;
  OGR_G_Intersect:   TOGR_G_Intersect;
  OGR_G_Equal:       TOGR_G_Equal;
  OGR_G_GetPointCount: TOGR_G_GetPointCount;
  OGR_G_GetX:        TOGR_G_GetX;
  OGR_G_GetY:        TOGR_G_GetY;
  OGR_G_GetZ:        TOGR_G_GetZ;
  OGR_G_GetPoint:    TOGR_G_GetPoint;
  OGR_G_SetPoint:    TOGR_G_SetPoint;
  OGR_G_SetPoint_2D: TOGR_G_SetPoint_2D;
  OGR_G_AddPoint:    TOGR_G_AddPoint;
  OGR_G_AddPoint_2D: TOGR_G_AddPoint_2D;
  OGR_G_GetGeometryCount: TOGR_G_GetGeometryCount;
  OGR_G_GetGeometryRef: TOGR_G_GetGeometryRef;
  OGR_G_AddGeometry: TOGR_G_AddGeometry;
  OGR_G_AddGeometryDirectly: TOGR_G_AddGeometryDirectly;
  OGR_G_RemoveGeometry: TOGR_G_RemoveGeometry;
  OGRBuildPolygonFromEdges: TOGRBuildPolygonFromEdges;
  OGR_Fld_Create:    TOGR_Fld_Create;
  OGR_Fld_Destroy:   TOGR_Fld_Destroy;
  OGR_Fld_SetName:   TOGR_Fld_SetName;
  OGR_Fld_GetNameRef: TOGR_Fld_GetNameRef;
  OGR_Fld_GetType:   TOGR_Fld_GetType;
  OGR_Fld_SetType:   TOGR_Fld_SetType;
  OGR_Fld_GetJustify: TOGR_Fld_GetJustify;
  OGR_Fld_SetJustify: TOGR_Fld_SetJustify;
  OGR_Fld_GetWidth:  TOGR_Fld_GetWidth;
  OGR_Fld_SetWidth:  TOGR_Fld_SetWidth;
  OGR_Fld_GetPrecision: TOGR_Fld_GetPrecision;
  OGR_Fld_SetPrecision: TOGR_Fld_SetPrecision;
  OGR_Fld_Set:       TOGR_Fld_Set;
  OGR_Fld_IsIgnored: TOGR_Fld_IsIgnored;
  OGR_Fld_SetIgnored: TOGR_Fld_SetIgnored;
  OGR_GetFieldTypeName: TOGR_GetFieldTypeName;
  OGR_FD_Create:     TOGR_FD_Create;
  OGR_FD_Destroy:    TOGR_FD_Destroy;
  OGR_FD_Release:    TOGR_FD_Release;
  OGR_FD_GetName:    TOGR_FD_GetName;
  OGR_FD_GetFieldCount: TOGR_FD_GetFieldCount;
  OGR_FD_GetFieldDefn: TOGR_FD_GetFieldDefn;
  OGR_FD_GetFieldIndex: TOGR_FD_GetFieldIndex;
  OGR_FD_AddFieldDefn: TOGR_FD_AddFieldDefn;
  OGR_FD_GetGeomType: TOGR_FD_GetGeomType;
  OGR_FD_SetGeomType: TOGR_FD_SetGeomType;
  OGR_FD_IsGeometryIgnored: TOGR_FD_IsGeometryIgnored;
  OGR_FD_SetGeometryIgnored: TOGR_FD_SetGeometryIgnored;
  OGR_FD_IsStyleIgnored: TOGR_FD_IsStyleIgnored;
  OGR_FD_SetStyleIgnored: TOGR_FD_SetStyleIgnored;
  OGR_FD_Reference:  TOGR_FD_Reference;
  OGR_FD_Dereference: TOGR_FD_Dereference;
  OGR_F_Create:      TOGR_F_Create;
  OGR_F_Destroy:     TOGR_F_Destroy;
  OGR_F_GetDefnRef:  TOGR_F_GetDefnRef;
  OGR_F_SetGeometryDirectly: TOGR_F_SetGeometryDirectly;
  OGR_F_SetGeometry: TOGR_F_SetGeometry;
  OGR_F_GetGeometryRef: TOGR_F_GetGeometryRef;
  OGR_F_Clone:       TOGR_F_Clone;
  OGR_F_Equal:       TOGR_F_Equal;
  OGR_F_GetFieldCount: TOGR_F_GetFieldCount;
  OGR_F_GetFieldDefnRef: TOGR_F_GetFieldDefnRef;
  OGR_F_GetFieldIndex: TOGR_F_GetFieldIndex;
  OGR_F_IsFieldSet:  TOGR_F_IsFieldSet;
  OGR_F_UnsetField:  TOGR_F_UnsetField;
  OGR_F_GetRawFieldRef: TOGR_F_GetRawFieldRef;
  OGR_F_GetFieldAsInteger: TOGR_F_GetFieldAsInteger;
  OGR_F_GetFieldAsDouble: TOGR_F_GetFieldAsDouble;
  OGR_F_GetFieldAsString: TOGR_F_GetFieldAsString;
  OGR_F_GetFieldAsIntegerList: TOGR_F_GetFieldAsIntegerList;
  OGR_F_GetFieldAsDoubleList: TOGR_F_GetFieldAsDoubleList;
  OGR_F_GetFieldAsStringList: TOGR_F_GetFieldAsStringList;
  OGR_F_GetFieldAsBinary: TOGR_F_GetFieldAsBinary;
  OGR_F_GetFieldAsDateTime: TOGR_F_GetFieldAsDateTime;
  OGR_F_SetFieldInteger: TOGR_F_SetFieldInteger;
  OGR_F_SetFieldDouble: TOGR_F_SetFieldDouble;
  OGR_F_SetFieldString: TOGR_F_SetFieldString;
  OGR_F_SetFieldIntegerList: TOGR_F_SetFieldIntegerList;
  OGR_F_SetFieldDoubleList: TOGR_F_SetFieldDoubleList;
  OGR_F_SetFieldStringList: TOGR_F_SetFieldStringList;
  OGR_F_SetFieldRaw: TOGR_F_SetFieldRaw;
  OGR_F_SetFieldBinary: TOGR_F_SetFieldBinary;
  OGR_F_SetFieldDateTime: TOGR_F_SetFieldDateTime;
  OGR_F_GetFID:      TOGR_F_GetFID;
  OGR_F_SetFID:      TOGR_F_SetFID;
  OGR_F_DumpReadable: TOGR_F_DumpReadable;
  OGR_F_SetFrom:     TOGR_F_SetFrom;
  OGR_F_SetFromWithMap: TOGR_F_SetFromWithMap;
  OGR_F_GetStyleString: TOGR_F_GetStyleString;
  OGR_F_SetStyleString: TOGR_F_SetStyleString;
  OGR_F_SetStyleStringDirectly: TOGR_F_SetStyleStringDirectly;
  OGR_L_Update:      TOGR_L_Update;
  OGR_L_GetSpatialFilter: TOGR_L_GetSpatialFilter;
  OGR_L_SetSpatialFilter: TOGR_L_SetSpatialFilter;
  OGR_L_SetSpatialFilterRect: TOGR_L_SetSpatialFilterRect;
  OGR_L_SetAttributeFilter: TOGR_L_SetAttributeFilter;
  OGR_L_ResetReading: TOGR_L_ResetReading;
  OGR_L_GetNextFeature: TOGR_L_GetNextFeature;
  OGR_L_GetName:     TOGR_L_GetName;
  OGR_L_SetNextByIndex: TOGR_L_SetNextByIndex;
  OGR_L_GetFeature:  TOGR_L_GetFeature;
  OGR_L_SetFeature:  TOGR_L_SetFeature;
  OGR_L_CreateFeature: TOGR_L_CreateFeature;
  OGR_L_DeleteFeature: TOGR_L_DeleteFeature;
  OGR_L_GetLayerDefn: TOGR_L_GetLayerDefn;
  OGR_L_GetSpatialRef: TOGR_L_GetSpatialRef;
  OGR_L_GetFeatureCount: TOGR_L_GetFeatureCount;
  OGR_L_GetExtent:   TOGR_L_GetExtent;
  OGR_L_TestCapability: TOGR_L_TestCapability;
  OGR_L_CreateField: TOGR_L_CreateField;
  OGR_L_StartTransaction: TOGR_L_StartTransaction;
  OGR_L_CommitTransaction: TOGR_L_CommitTransaction;
  OGR_L_RollbackTransaction: TOGR_L_RollbackTransaction;
  OGR_L_SyncToDisk:  TOGR_L_SyncToDisk;
  OGR_L_GetFIDColumn: TOGR_L_GetFIDColumn;
  OGR_L_GetGeometryColumn: TOGR_L_GetGeometryColumn;
  OGR_L_SetIgnoredFields: TOGR_L_SetIgnoredFields;
  OGR_DS_Destroy:    TOGR_DS_Destroy;
  OGR_DS_GetName:    TOGR_DS_GetName;
  OGR_DS_GetLayerCount: TOGR_DS_GetLayerCount;
  OGR_DS_GetLayer:   TOGR_DS_GetLayer;
  OGR_DS_GetLayerByName: TOGR_DS_GetLayerByName;
  OGR_DS_DeleteLayer: TOGR_DS_DeleteLayer;
  OGR_DS_GetDriver:  TOGR_DS_GetDriver;
  OGR_DS_CreateLayer: TOGR_DS_CreateLayer;
  OGR_DS_CopyLayer:  TOGR_DS_CopyLayer;
  OGR_DS_TestCapability: TOGR_DS_TestCapability;
  OGR_DS_ExecuteSQL: TOGR_DS_ExecuteSQL;
  OGR_DS_ReleaseResultSet: TOGR_DS_ReleaseResultSet;
  OGR_DS_SyncToDisk: TOGR_DS_SyncToDisk;
  OGR_Dr_GetName:    TOGR_Dr_GetName;
  OGR_Dr_Open:       TOGR_Dr_Open;
  OGR_Dr_TestCapability: TOGR_Dr_TestCapability;
  OGR_Dr_CreateDataSource: TOGR_Dr_CreateDataSource;
  OGR_Dr_CopyDataSource: TOGR_Dr_CopyDataSource;
  OGR_Dr_DeleteDataSource: TOGR_Dr_DeleteDataSource;
  OGROpen:           TOGROpen;
  OGRReleaseDataSource: TOGRReleaseDataSource;
  OGRRegisterDriver: TOGRRegisterDriver;
  OGRDeregisterDriver: TOGRDeregisterDriver;
  OGRGetDriverCount: TOGRGetDriverCount;
  OGRGetDriver:      TOGRGetDriver;
  OGRGetDriverByName: TOGRGetDriverByName;
  OGRGetOpenDSCount: TOGRGetOpenDSCount;
  OGRGetOpenDS:      TOGRGetOpenDS;
  OGRRegisterAll:    TOGRRegisterAll;
  OGRCleanupAll:     TOGRCleanupAll;
  OGR_SM_Create:     TOGR_SM_Create;
  OGR_SM_Destroy:    TOGR_SM_Destroy;
  OGR_SM_InitFromFeature: TOGR_SM_InitFromFeature;
  OGR_SM_InitStyleString: TOGR_SM_InitStyleString;
  OGR_SM_GetPartCount: TOGR_SM_GetPartCount;
  OGR_SM_GetPart:    TOGR_SM_GetPart;
  OGR_SM_AddPart:    TOGR_SM_AddPart;
  OGR_SM_AddStyle:   TOGR_SM_AddStyle;
  OGR_ST_Create:     TOGR_ST_Create;
  OGR_ST_Destroy:    TOGR_ST_Destroy;
  OGR_ST_GetType:    TOGR_ST_GetType;
  OGR_ST_GetUnit:    TOGR_ST_GetUnit;
  OGR_ST_SetUnit:    TOGR_ST_SetUnit;
  OGR_ST_GetParamStr: TOGR_ST_GetParamStr;
  OGR_ST_GetParamNum: TOGR_ST_GetParamNum;
  OGR_ST_GetParamDbl: TOGR_ST_GetParamDbl;
  OGR_ST_SetParamStr: TOGR_ST_SetParamStr;
  OGR_ST_SetParamNum: TOGR_ST_SetParamNum;
  OGR_ST_SetParamDbl: TOGR_ST_SetParamDbl;
  OGR_ST_GetStyleString: TOGR_ST_GetStyleString;
  OGR_ST_GetRGBFromString: TOGR_ST_GetRGBFromString;
  OGR_STBL_Create:   TOGR_STBL_Create;
  OGR_STBL_Destroy:  TOGR_STBL_Destroy;
  OGR_STBL_SaveStyleTable: TOGR_STBL_SaveStyleTable;
  OGR_STBL_LoadStyleTable: TOGR_STBL_LoadStyleTable;
  OGR_STBL_Find:     TOGR_STBL_Find;
  OGR_STBL_ResetStyleStringReading: TOGR_STBL_ResetStyleStringReading;
  OGR_STBL_GetNextStyle: TOGR_STBL_GetNextStyle;
//  OGR_STBL_GetLastStyleName: TOGR_STBL_GetLastStyleName;

implementation

procedure DynamicLoad(const ALibName: string);
var
  dllHandle: cardinal;
begin
  dllHandle := LoadLibrary(PAnsiChar(ALibName));
  @OGRMergeGeometryTypes := GetProcAddress(dllHandle, 'OGRMergeGeometryTypes');
  @OGRParseDate := GetProcAddress(dllHandle, 'OGRParseDate');
  @GDALVersionInfo := GetProcAddress(dllHandle, 'GDALVersionInfo');
  @GDALCheckVersion := GetProcAddress(dllHandle, 'GDALCheckVersion');
  @OGR_G_CreateFromWkb := GetProcAddress(dllHandle, 'OGR_G_CreateFromWkb');
  @OGR_G_CreateFromWkt := GetProcAddress(dllHandle, 'OGR_G_CreateFromWkt');
  @OGR_G_DestroyGeometry := GetProcAddress(dllHandle, 'OGR_G_DestroyGeometry');
  @OGR_G_CreateGeometry := GetProcAddress(dllHandle, 'OGR_G_CreateGeometry');
  @OGR_G_ForceToPolygon := GetProcAddress(dllHandle, 'OGR_G_ForceToPolygon');
  @OGR_G_ForceToMultiPolygon := GetProcAddress(dllHandle, 'OGR_G_ForceToMultiPolygon');
  @OGR_G_ForceToMultiPoint := GetProcAddress(dllHandle, 'OGR_G_ForceToMultiPoint');
  @OGR_G_ForceToMultiLineString := GetProcAddress(dllHandle, 'OGR_G_ForceToMultiLineString');
  @OGR_G_GetDimension := GetProcAddress(dllHandle, 'OGR_G_GetDimension');
  @OGR_G_GetCoordinateDimension := GetProcAddress(dllHandle, 'OGR_G_GetCoordinateDimension');
  @OGR_G_Clone := GetProcAddress(dllHandle, 'OGR_G_Clone');
  @OGR_G_GetEnvelope := GetProcAddress(dllHandle, 'OGR_G_GetEnvelope');
  @OGR_G_ImportFromWkb := GetProcAddress(dllHandle, 'OGR_G_ImportFromWkb');
  @OGR_G_ExportToWkb := GetProcAddress(dllHandle, 'OGR_G_ExportToWkb');
  @OGR_G_WkbSize := GetProcAddress(dllHandle, 'OGR_G_WkbSize');
  @OGR_G_ImportFromWkt := GetProcAddress(dllHandle, 'OGR_G_ImportFromWkt');
  @OGR_G_ExportToWkt := GetProcAddress(dllHandle, 'OGR_G_ExportToWkt');
  @OGR_G_ExportToJson := GetProcAddress(dllHandle, 'OGR_G_ExportToJson');
  @OGR_G_GetGeometryType := GetProcAddress(dllHandle, 'OGR_G_GetGeometryType');
  @OGR_G_GetGeometryName := GetProcAddress(dllHandle, 'OGR_G_GetGeometryName');
  @OGR_G_DumpReadable := GetProcAddress(dllHandle, 'OGR_G_DumpReadable');
  @OGR_G_FlattenTo2D := GetProcAddress(dllHandle, 'OGR_G_FlattenTo2D');
  @OGR_G_AssignSpatialReference := GetProcAddress(dllHandle, 'OGR_G_AssignSpatialReference');
  @OGR_G_Transform := GetProcAddress(dllHandle, 'OGR_G_Transform');
  @OGR_G_TransformTo := GetProcAddress(dllHandle, 'OGR_G_TransformTo');
  @OGR_G_Segmentize := GetProcAddress(dllHandle, 'OGR_G_Segmentize');
  @OGR_G_Intersects := GetProcAddress(dllHandle, 'OGR_G_Intersects');
  @OGR_G_Equals := GetProcAddress(dllHandle, 'OGR_G_Equals');
  @OGR_G_Disjoint := GetProcAddress(dllHandle, 'OGR_G_Disjoint');
  @OGR_G_Touches := GetProcAddress(dllHandle, 'OGR_G_Touches');
  @OGR_G_Crosses := GetProcAddress(dllHandle, 'OGR_G_Crosses');
  @OGR_G_Within := GetProcAddress(dllHandle, 'OGR_G_Within');
  @OGR_G_Contains := GetProcAddress(dllHandle, 'OGR_G_Contains');
  @OGR_G_Overlaps := GetProcAddress(dllHandle, 'OGR_G_Overlaps');
  @OGR_G_GetBoundary := GetProcAddress(dllHandle, 'OGR_G_GetBoundary');
  @OGR_G_ConvexHull := GetProcAddress(dllHandle, 'OGR_G_ConvexHull');
  @OGR_G_Buffer := GetProcAddress(dllHandle, 'OGR_G_Buffer');
  @OGR_G_Intersection := GetProcAddress(dllHandle, 'OGR_G_Intersection');
  @OGR_G_Union := GetProcAddress(dllHandle, 'OGR_G_Union');
  @OGR_G_UnionCascaded := GetProcAddress(dllHandle, 'OGR_G_UnionCascaded');
  @OGR_G_Difference := GetProcAddress(dllHandle, 'OGR_G_Difference');
  @OGR_G_SymmetricDifference := GetProcAddress(dllHandle, 'OGR_G_SymmetricDifference');
  @OGR_G_Distance := GetProcAddress(dllHandle, 'OGR_G_Distance');
  @OGR_G_GetArea := GetProcAddress(dllHandle, 'OGR_G_GetArea');
  @OGR_G_Centroid := GetProcAddress(dllHandle, 'OGR_G_Centroid');
  @OGR_G_Empty := GetProcAddress(dllHandle, 'OGR_G_Empty');
  @OGR_G_IsEmpty := GetProcAddress(dllHandle, 'OGR_G_IsEmpty');
  @OGR_G_IsValid := GetProcAddress(dllHandle, 'OGR_G_IsValid');
  @OGR_G_IsSimple := GetProcAddress(dllHandle, 'OGR_G_IsSimple');
  @OGR_G_IsRing := GetProcAddress(dllHandle, 'OGR_G_IsRing');
  @OGR_G_Intersect := GetProcAddress(dllHandle, 'OGR_G_Intersect');
  @OGR_G_Equal := GetProcAddress(dllHandle, 'OGR_G_Equal');
  @OGR_G_GetPointCount := GetProcAddress(dllHandle, 'OGR_G_GetPointCount');
  @OGR_G_GetX := GetProcAddress(dllHandle, 'OGR_G_GetX');
  @OGR_G_GetY := GetProcAddress(dllHandle, 'OGR_G_GetY');
  @OGR_G_GetZ := GetProcAddress(dllHandle, 'OGR_G_GetZ');
  @OGR_G_GetPoint := GetProcAddress(dllHandle, 'OGR_G_GetPoint');
  @OGR_G_SetPoint := GetProcAddress(dllHandle, 'OGR_G_SetPoint');
  @OGR_G_SetPoint_2D := GetProcAddress(dllHandle, 'OGR_G_SetPoint_2D');
  @OGR_G_AddPoint := GetProcAddress(dllHandle, 'OGR_G_AddPoint');
  @OGR_G_AddPoint_2D := GetProcAddress(dllHandle, 'OGR_G_AddPoint_2D');
  @OGR_G_GetGeometryCount := GetProcAddress(dllHandle, 'OGR_G_GetGeometryCount');
  @OGR_G_GetGeometryRef := GetProcAddress(dllHandle, 'OGR_G_GetGeometryRef');
  @OGR_G_AddGeometry := GetProcAddress(dllHandle, 'OGR_G_AddGeometry');
  @OGR_G_AddGeometryDirectly := GetProcAddress(dllHandle, 'OGR_G_AddGeometryDirectly');
  @OGR_G_RemoveGeometry := GetProcAddress(dllHandle, 'OGR_G_RemoveGeometry');
  @OGRBuildPolygonFromEdges := GetProcAddress(dllHandle, 'OGRBuildPolygonFromEdges');
  @OGR_Fld_Create := GetProcAddress(dllHandle, 'OGR_Fld_Create');
  @OGR_Fld_Destroy := GetProcAddress(dllHandle, 'OGR_Fld_Destroy');
  @OGR_Fld_SetName := GetProcAddress(dllHandle, 'OGR_Fld_SetName');
  @OGR_Fld_GetNameRef := GetProcAddress(dllHandle, 'OGR_Fld_GetNameRef');
  @OGR_Fld_GetType := GetProcAddress(dllHandle, 'OGR_Fld_GetType');
  @OGR_Fld_SetType := GetProcAddress(dllHandle, 'OGR_Fld_SetType');
  @OGR_Fld_GetJustify := GetProcAddress(dllHandle, 'OGR_Fld_GetJustify');
  @OGR_Fld_SetJustify := GetProcAddress(dllHandle, 'OGR_Fld_SetJustify');
  @OGR_Fld_GetWidth := GetProcAddress(dllHandle, 'OGR_Fld_GetWidth');
  @OGR_Fld_SetWidth := GetProcAddress(dllHandle, 'OGR_Fld_SetWidth');
  @OGR_Fld_GetPrecision := GetProcAddress(dllHandle, 'OGR_Fld_GetPrecision');
  @OGR_Fld_SetPrecision := GetProcAddress(dllHandle, 'OGR_Fld_SetPrecision');
  @OGR_Fld_Set := GetProcAddress(dllHandle, 'OGR_Fld_Set');
  @OGR_Fld_IsIgnored := GetProcAddress(dllHandle, 'OGR_Fld_IsIgnored');
  @OGR_Fld_SetIgnored := GetProcAddress(dllHandle, 'OGR_Fld_SetIgnored');
  @OGR_GetFieldTypeName := GetProcAddress(dllHandle, 'OGR_GetFieldTypeName');
  @OGR_FD_Create := GetProcAddress(dllHandle, 'OGR_FD_Create');
  @OGR_FD_Destroy := GetProcAddress(dllHandle, 'OGR_FD_Destroy');
  @OGR_FD_Release := GetProcAddress(dllHandle, 'OGR_FD_Release');
  @OGR_FD_GetName := GetProcAddress(dllHandle, 'OGR_FD_GetName');
  @OGR_FD_GetFieldCount := GetProcAddress(dllHandle, 'OGR_FD_GetFieldCount');
  @OGR_FD_GetFieldDefn := GetProcAddress(dllHandle, 'OGR_FD_GetFieldDefn');
  @OGR_FD_GetFieldIndex := GetProcAddress(dllHandle, 'OGR_FD_GetFieldIndex');
  @OGR_FD_AddFieldDefn := GetProcAddress(dllHandle, 'OGR_FD_AddFieldDefn');
  @OGR_FD_GetGeomType := GetProcAddress(dllHandle, 'OGR_FD_GetGeomType');
  @OGR_FD_SetGeomType := GetProcAddress(dllHandle, 'OGR_FD_SetGeomType');
  @OGR_FD_IsGeometryIgnored := GetProcAddress(dllHandle, 'OGR_FD_IsGeometryIgnored');
  @OGR_FD_SetGeometryIgnored := GetProcAddress(dllHandle, 'OGR_FD_SetGeometryIgnored');
  @OGR_FD_IsStyleIgnored := GetProcAddress(dllHandle, 'OGR_FD_IsStyleIgnored');
  @OGR_FD_SetStyleIgnored := GetProcAddress(dllHandle, 'OGR_FD_SetStyleIgnored');
  @OGR_FD_Reference := GetProcAddress(dllHandle, 'OGR_FD_Reference');
  @OGR_FD_Dereference := GetProcAddress(dllHandle, 'OGR_FD_Dereference');
  @OGR_F_Create := GetProcAddress(dllHandle, 'OGR_F_Create');
  @OGR_F_Destroy := GetProcAddress(dllHandle, 'OGR_F_Destroy');
  @OGR_F_GetDefnRef := GetProcAddress(dllHandle, 'OGR_F_GetDefnRef');
  @OGR_F_SetGeometryDirectly := GetProcAddress(dllHandle, 'OGR_F_SetGeometryDirectly');
  @OGR_F_SetGeometry := GetProcAddress(dllHandle, 'OGR_F_SetGeometry');
  @OGR_F_GetGeometryRef := GetProcAddress(dllHandle, 'OGR_F_GetGeometryRef');
  @OGR_F_Clone := GetProcAddress(dllHandle, 'OGR_F_Clone');
  @OGR_F_Equal := GetProcAddress(dllHandle, 'OGR_F_Equal');
  @OGR_F_GetFieldCount := GetProcAddress(dllHandle, 'OGR_F_GetFieldCount');
  @OGR_F_GetFieldDefnRef := GetProcAddress(dllHandle, 'OGR_F_GetFieldDefnRef');
  @OGR_F_GetFieldIndex := GetProcAddress(dllHandle, 'OGR_F_GetFieldIndex');
  @OGR_F_IsFieldSet := GetProcAddress(dllHandle, 'OGR_F_IsFieldSet');
  @OGR_F_UnsetField := GetProcAddress(dllHandle, 'OGR_F_UnsetField');
  @OGR_F_GetRawFieldRef := GetProcAddress(dllHandle, 'OGR_F_GetRawFieldRef');
  @OGR_F_GetFieldAsInteger := GetProcAddress(dllHandle, 'OGR_F_GetFieldAsInteger');
  @OGR_F_GetFieldAsDouble := GetProcAddress(dllHandle, 'OGR_F_GetFieldAsDouble');
  @OGR_F_GetFieldAsString := GetProcAddress(dllHandle, 'OGR_F_GetFieldAsString');
  @OGR_F_GetFieldAsIntegerList := GetProcAddress(dllHandle, 'OGR_F_GetFieldAsIntegerList');
  @OGR_F_GetFieldAsDoubleList := GetProcAddress(dllHandle, 'OGR_F_GetFieldAsDoubleList');
  @OGR_F_GetFieldAsStringList := GetProcAddress(dllHandle, 'OGR_F_GetFieldAsStringList');
  @OGR_F_GetFieldAsBinary := GetProcAddress(dllHandle, 'OGR_F_GetFieldAsBinary');
  @OGR_F_GetFieldAsDateTime := GetProcAddress(dllHandle, 'OGR_F_GetFieldAsDateTime');
  @OGR_F_SetFieldInteger := GetProcAddress(dllHandle, 'OGR_F_SetFieldInteger');
  @OGR_F_SetFieldDouble := GetProcAddress(dllHandle, 'OGR_F_SetFieldDouble');
  @OGR_F_SetFieldString := GetProcAddress(dllHandle, 'OGR_F_SetFieldString');
  @OGR_F_SetFieldIntegerList := GetProcAddress(dllHandle, 'OGR_F_SetFieldIntegerList');
  @OGR_F_SetFieldDoubleList := GetProcAddress(dllHandle, 'OGR_F_SetFieldDoubleList');
  @OGR_F_SetFieldStringList := GetProcAddress(dllHandle, 'OGR_F_SetFieldStringList');
  @OGR_F_SetFieldRaw := GetProcAddress(dllHandle, 'OGR_F_SetFieldRaw');
  @OGR_F_SetFieldBinary := GetProcAddress(dllHandle, 'OGR_F_SetFieldBinary');
  @OGR_F_SetFieldDateTime := GetProcAddress(dllHandle, 'OGR_F_SetFieldDateTime');
  @OGR_F_GetFID := GetProcAddress(dllHandle, 'OGR_F_GetFID');
  @OGR_F_SetFID := GetProcAddress(dllHandle, 'OGR_F_SetFID');
  @OGR_F_DumpReadable := GetProcAddress(dllHandle, 'OGR_F_DumpReadable');
  @OGR_F_SetFrom := GetProcAddress(dllHandle, 'OGR_F_SetFrom');
  @OGR_F_SetFromWithMap := GetProcAddress(dllHandle, 'OGR_F_SetFromWithMap');
  @OGR_F_GetStyleString := GetProcAddress(dllHandle, 'OGR_F_GetStyleString');
  @OGR_F_SetStyleString := GetProcAddress(dllHandle, 'OGR_F_SetStyleString');
  @OGR_F_SetStyleStringDirectly := GetProcAddress(dllHandle, 'OGR_F_SetStyleStringDirectly');
  @OGR_L_Update := GetProcAddress(dllHandle, 'OGR_L_Update');
  @OGR_L_GetSpatialFilter := GetProcAddress(dllHandle, 'OGR_L_GetSpatialFilter');
  @OGR_L_SetSpatialFilter := GetProcAddress(dllHandle, 'OGR_L_SetSpatialFilter');
  @OGR_L_SetSpatialFilterRect := GetProcAddress(dllHandle, 'OGR_L_SetSpatialFilterRect');
  @OGR_L_SetAttributeFilter := GetProcAddress(dllHandle, 'OGR_L_SetAttributeFilter');
  @OGR_L_ResetReading := GetProcAddress(dllHandle, 'OGR_L_ResetReading');
  @OGR_L_GetNextFeature := GetProcAddress(dllHandle, 'OGR_L_GetNextFeature');
  @OGR_L_GetName := GetProcAddress(dllHandle, 'OGR_L_GetName');
  @OGR_L_SetNextByIndex := GetProcAddress(dllHandle, 'OGR_L_SetNextByIndex');
  @OGR_L_GetFeature := GetProcAddress(dllHandle, 'OGR_L_GetFeature');
  @OGR_L_SetFeature := GetProcAddress(dllHandle, 'OGR_L_SetFeature');
  @OGR_L_CreateFeature := GetProcAddress(dllHandle, 'OGR_L_CreateFeature');
  @OGR_L_DeleteFeature := GetProcAddress(dllHandle, 'OGR_L_DeleteFeature');
  @OGR_L_GetLayerDefn := GetProcAddress(dllHandle, 'OGR_L_GetLayerDefn');
  @OGR_L_GetSpatialRef := GetProcAddress(dllHandle, 'OGR_L_GetSpatialRef');
  @OGR_L_GetFeatureCount := GetProcAddress(dllHandle, 'OGR_L_GetFeatureCount');
  @OGR_L_GetExtent := GetProcAddress(dllHandle, 'OGR_L_GetExtent');
  @OGR_L_TestCapability := GetProcAddress(dllHandle, 'OGR_L_TestCapability');
  @OGR_L_CreateField := GetProcAddress(dllHandle, 'OGR_L_CreateField');
  @OGR_L_StartTransaction := GetProcAddress(dllHandle, 'OGR_L_StartTransaction');
  @OGR_L_CommitTransaction := GetProcAddress(dllHandle, 'OGR_L_CommitTransaction');
  @OGR_L_RollbackTransaction := GetProcAddress(dllHandle, 'OGR_L_RollbackTransaction');
  @OGR_L_SyncToDisk := GetProcAddress(dllHandle, 'OGR_L_SyncToDisk');
  @OGR_L_GetFIDColumn := GetProcAddress(dllHandle, 'OGR_L_GetFIDColumn');
  @OGR_L_GetGeometryColumn := GetProcAddress(dllHandle, 'OGR_L_GetGeometryColumn');
  @OGR_L_SetIgnoredFields := GetProcAddress(dllHandle, 'OGR_L_SetIgnoredFields');
  @OGR_DS_Destroy := GetProcAddress(dllHandle, 'OGR_DS_Destroy');
  @OGR_DS_GetName := GetProcAddress(dllHandle, 'OGR_DS_GetName');
  @OGR_DS_GetLayerCount := GetProcAddress(dllHandle, 'OGR_DS_GetLayerCount');
  @OGR_DS_GetLayer := GetProcAddress(dllHandle, 'OGR_DS_GetLayer');
  @OGR_DS_GetLayerByName := GetProcAddress(dllHandle, 'OGR_DS_GetLayerByName');
  @OGR_DS_DeleteLayer := GetProcAddress(dllHandle, 'OGR_DS_DeleteLayer');
  @OGR_DS_GetDriver := GetProcAddress(dllHandle, 'OGR_DS_GetDriver');
  @OGR_DS_CreateLayer := GetProcAddress(dllHandle, 'OGR_DS_CreateLayer');
  @OGR_DS_CopyLayer := GetProcAddress(dllHandle, 'OGR_DS_CopyLayer');
  @OGR_DS_TestCapability := GetProcAddress(dllHandle, 'OGR_DS_TestCapability');
  @OGR_DS_ExecuteSQL := GetProcAddress(dllHandle, 'OGR_DS_ExecuteSQL');
  @OGR_DS_ReleaseResultSet := GetProcAddress(dllHandle, 'OGR_DS_ReleaseResultSet');
  @OGR_DS_SyncToDisk := GetProcAddress(dllHandle, 'OGR_DS_SyncToDisk');
  @OGR_Dr_GetName := GetProcAddress(dllHandle, 'OGR_Dr_GetName');
  @OGR_Dr_Open := GetProcAddress(dllHandle, 'OGR_Dr_Open');
  @OGR_Dr_TestCapability := GetProcAddress(dllHandle, 'OGR_Dr_TestCapability');
  @OGR_Dr_CreateDataSource := GetProcAddress(dllHandle, 'OGR_Dr_CreateDataSource');
  @OGR_Dr_CopyDataSource := GetProcAddress(dllHandle, 'OGR_Dr_CopyDataSource');
  @OGR_Dr_DeleteDataSource := GetProcAddress(dllHandle, 'OGR_Dr_DeleteDataSource');
  @OGROpen  := GetProcAddress(dllHandle, 'OGROpen');
  @OGRReleaseDataSource := GetProcAddress(dllHandle, 'OGRReleaseDataSource');
  @OGRRegisterDriver := GetProcAddress(dllHandle, 'OGRRegisterDriver');
  @OGRDeregisterDriver := GetProcAddress(dllHandle, 'OGRDeregisterDriver');
  @OGRGetDriverCount := GetProcAddress(dllHandle, 'OGRGetDriverCount');
  @OGRGetDriver := GetProcAddress(dllHandle, 'OGRGetDriver');
  @OGRGetDriverByName := GetProcAddress(dllHandle, 'OGRGetDriverByName');
  @OGRGetOpenDSCount := GetProcAddress(dllHandle, 'OGRGetOpenDSCount');
  @OGRGetOpenDS := GetProcAddress(dllHandle, 'OGRGetOpenDS');
  @OGRRegisterAll := GetProcAddress(dllHandle, 'OGRRegisterAll');
  @OGRCleanupAll := GetProcAddress(dllHandle, 'OGRCleanupAll');
  @OGR_SM_Create := GetProcAddress(dllHandle, 'OGR_SM_Create');
  @OGR_SM_Destroy := GetProcAddress(dllHandle, 'OGR_SM_Destroy');
  @OGR_SM_InitFromFeature := GetProcAddress(dllHandle, 'OGR_SM_InitFromFeature');
  @OGR_SM_InitStyleString := GetProcAddress(dllHandle, 'OGR_SM_InitStyleString');
  @OGR_SM_GetPartCount := GetProcAddress(dllHandle, 'OGR_SM_GetPartCount');
  @OGR_SM_GetPart := GetProcAddress(dllHandle, 'OGR_SM_GetPart');
  @OGR_SM_AddPart := GetProcAddress(dllHandle, 'OGR_SM_AddPart');
  @OGR_SM_AddStyle := GetProcAddress(dllHandle, 'OGR_SM_AddStyle');
  @OGR_ST_Create := GetProcAddress(dllHandle, 'OGR_ST_Create');
  @OGR_ST_Destroy := GetProcAddress(dllHandle, 'OGR_ST_Destroy');
  @OGR_ST_GetType := GetProcAddress(dllHandle, 'OGR_ST_GetType');
  @OGR_ST_GetUnit := GetProcAddress(dllHandle, 'OGR_ST_GetUnit');
  @OGR_ST_SetUnit := GetProcAddress(dllHandle, 'OGR_ST_SetUnit');
  @OGR_ST_GetParamStr := GetProcAddress(dllHandle, 'OGR_ST_GetParamStr');
  @OGR_ST_GetParamNum := GetProcAddress(dllHandle, 'OGR_ST_GetParamNum');
  @OGR_ST_GetParamDbl := GetProcAddress(dllHandle, 'OGR_ST_GetParamDbl');
  @OGR_ST_SetParamStr := GetProcAddress(dllHandle, 'OGR_ST_SetParamStr');
  @OGR_ST_SetParamNum := GetProcAddress(dllHandle, 'OGR_ST_SetParamNum');
  @OGR_ST_SetParamDbl := GetProcAddress(dllHandle, 'OGR_ST_SetParamDbl');
  @OGR_ST_GetStyleString := GetProcAddress(dllHandle, 'OGR_ST_GetStyleString');
  @OGR_ST_GetRGBFromString := GetProcAddress(dllHandle, 'OGR_ST_GetRGBFromString');
  @OGR_STBL_Create := GetProcAddress(dllHandle, 'OGR_STBL_Create');
  @OGR_STBL_Destroy := GetProcAddress(dllHandle, 'OGR_STBL_Destroy');
  @OGR_STBL_SaveStyleTable := GetProcAddress(dllHandle, 'OGR_STBL_SaveStyleTable');
  @OGR_STBL_LoadStyleTable := GetProcAddress(dllHandle, 'OGR_STBL_LoadStyleTable');
  @OGR_STBL_Find := GetProcAddress(dllHandle, 'OGR_STBL_Find');
  @OGR_STBL_ResetStyleStringReading := GetProcAddress(dllHandle, 'OGR_STBL_ResetStyleStringReading');
  @OGR_STBL_GetNextStyle := GetProcAddress(dllHandle, 'OGR_STBL_GetfNextStyle');
end;

initialization
  DynamicLoad(LibName);
end.

