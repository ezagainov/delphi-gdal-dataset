
{******************************************************************************
 * $Id: gdal.h 17687 2009-09-25 13:43:56Z dron $
 *
 * Project:  GDAL Core
 * Purpose:  GDAL Core C/Public declarations.
 * Author:   Frank Warmerdam, warmerdam@pobox.com
 *
 ******************************************************************************
 * Copyright (c) 1998, 2002 Frank Warmerdam
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

unit gdal;

interface

uses
  gdalcore, windows;

const

  GDALMD_AREA_OR_POINT = 'AREA_OR_POINT';
  GDALMD_AOP_AREA      = 'Area';
  GDALMD_AOP_POINT     = 'Point';

  CPLE_WrongFormat = 200;

  GDAL_DMD_LONGNAME           = 'DMD_LONGNAME';
  GDAL_DMD_HELPTOPIC          = 'DMD_HELPTOPIC';
  GDAL_DMD_MIMETYPE           = 'DMD_MIMETYPE';
  GDAL_DMD_EXTENSION          = 'DMD_EXTENSION';
  GDAL_DMD_CREATIONOPTIONLIST = 'DMD_CREATIONOPTIONLIST';
  GDAL_DMD_CREATIONDATATYPES  = 'DMD_CREATIONDATATYPES';

  GDAL_DCAP_CREATE     = 'DCAP_CREATE';
  GDAL_DCAP_CREATECOPY = 'DCAP_CREATECOPY';
  GDAL_DCAP_VIRTUALIO  = 'DCAP_VIRTUALIO';

  GMF_ALL_VALID   = $01;
  GMF_PER_DATASET = $02;
  GMF_ALPHA       = $04;
  GMF_NODATA      = $08;

type

  GDALDataType =
    (
    GDT_Unknown = 0,
    GDT_Byte = 1,
    GDT_UInt16 = 2,
    GDT_Int16 = 3,
    GDT_UInt32 = 4,
    GDT_Int32 = 5,
    GDT_Float32 = 6,
    GDT_Float64 = 7,
    GDT_CInt16 = 8,
    GDT_CInt32 = 9,
    GDT_CFloat32 = 10,
    GDT_CFloat64 = 11,
    GDT_TypeCount = 12
    );

  GDALAccess =
    (
    GA_ReadOnly = 0,
    GA_Update = 1
    );

  GDALRWFlag =
    (
    GF_Read = 0,
    GF_Write = 1
    );

  GDALColorInterp =
    (
    GCI_Undefined = 0,
    GCI_GrayIndex = 1,
    GCI_PaletteIndex = 2,
    GCI_RedBand = 3,
    GCI_GreenBand = 4,
    GCI_BlueBand = 5,
    GCI_AlphaBand = 6,
    GCI_HueBand = 7,
    GCI_SaturationBand = 8,
    GCI_LightnessBand = 9,
    GCI_CyanBand = 10,
    GCI_MagentaBand = 11,
    GCI_YellowBand = 12,
    GCI_BlackBand = 13,
    GCI_YCbCr_YBand = 14,
    GCI_YCbCr_CbBand = 15,
    GCI_YCbCr_CrBand = 16,
    GCI_Max = 16
    );

  GDALPaletteInterp =
    (
    GPI_Gray = 0,
    GPI_RGB = 1,
    GPI_CMYK = 2,
    GPI_HLS = 3
    );

  GDALOptionDefinition = record
    pszOptionName:  CPChar;
    pszValueType:   CPChar;
    pszDescription: CPChar;
    papszOptions:   PCPChar;
  end;

  GDAL_GCP = record
    pszId:      CPChar;
    pszInfo:    CPChar;
    dfGCPPixel: double;
    dfGCPLine:  double;
    dfGCPX:     double;
    dfGCPY:     double;
    dfGCPZ:     double;
  end;
  PGDAL_GCP = ^GDAL_GCP;

  GDALRPCInfo = record
    dfLINE_OFF:        double;
    dfSAMP_OFF:        double;
    dfLAT_OFF:         double;
    dfLONG_OFF:        double;
    dfHEIGHT_OFF:      double;
    dfLINE_SCALE:      double;
    dfSAMP_SCALE:      double;
    dfLAT_SCALE:       double;
    dfLONG_SCALE:      double;
    dfHEIGHT_SCALE:    double;
    adfLINE_NUM_COEFF: array[0..19] of double;
    adfLINE_DEN_COEFF: array[0..19] of double;
    adfSAMP_NUM_COEFF: array[0..19] of double;
    adfSAMP_DEN_COEFF: array[0..19] of double;
    dfMIN_LONG:        double;
    dfMIN_LAT:         double;
    dfMAX_LONG:        double;
    dfMAX_LAT:         double;
  end;

  GDALColorEntry = record
    c1: smallint;
    c2: smallint;
    c3: smallint;
    c4: smallint;
  end;

  GDALRATFieldType =
    (
    GFT_Integer,
    GFT_Real,
    GFT_String
    );

  GDALRATFieldUsage =
    (
    GFU_Generic = 0,
    GFU_PixelCount = 1,
    GFU_Name = 2,
    GFU_Min = 3,
    GFU_Max = 4,
    GFU_MinMax = 5,
    GFU_Red = 6,
    GFU_Green = 7,
    GFU_Blue = 8,
    GFU_Alpha = 9,
    GFU_RedMin = 10,
    GFU_GreenMin = 11,
    GFU_BlueMin = 12,
    GFU_AlphaMin = 13,
    GFU_RedMax = 14,
    GFU_GreenMax = 15,
    GFU_BlueMax = 16,
    GFU_AlphaMax = 17,
    GFU_MaxCount
    );

  GDALMajorObjectH = Pointer;

  GDALDatasetH = Pointer;

  GDALRasterBandH = Pointer;

  GDALDriverH = Pointer;

  GDALProjDefH = Pointer;

  GDALColorTableH = Pointer;

  GDALRasterAttributeTableH = Pointer;

  GDALProgressFunc = function(dfComplete: double; pszMessage: CPChar; pProgressArg: Pointer): integer;

  TGDALGetDataTypeSize = function(eDataType: GDALDataType): longint; stdcall;
  TGDALDataTypeIsComplex = function(eDataType: GDALDataType): GIntBig; stdcall;
  TGDALGetDataTypeName = function(eDataType: GDALDataType): CPChar; stdcall;
  TGDALGetDataTypeByName = function(pszName: CPChar): GDALDataType; stdcall;
  TGDALDataTypeUnion = function(eType1: GDALDataType; eType2: GDALDataType): GDALDataType; stdcall;
  TGDALGetColorInterpretationName = function(eInterp: GDALColorInterp): CPChar; stdcall;
  TGDALGetColorInterpretationByName = function(pszName: CPChar): GDALColorInterp; stdcall;
  TGDALGetPaletteInterpretationName = function(eInterp: GDALPaletteInterp): CPChar; stdcall;
  TGDALDummyProgress = function(dfComplete: double; pszMessage: CPChar; pData: Pointer): GIntBig; stdcall;
  TGDALTermProgress = function(dfComplete: double; pszMessage: CPChar; pProgressArg: Pointer): GIntBig; stdcall;
  TGDALScaledProgress = function(dfComplete: double; pszMessage: CPChar; pData: Pointer): GIntBig; stdcall;
  TGDALCreateScaledProgress = function(dfMin: double; dfMax: double; pfnProgress: GDALProgressFunc; pData: Pointer): Pointer; stdcall;
  TGDALDestroyScaledProgress = procedure(pData: Pointer); stdcall;
  TGDALAllRegister = procedure stdcall;
  TGDALCreate      = function(hDriver: GDALDriverH; pszFilename: CPChar; nXSize3: GIntBig; nYSize: GIntBig; nBands: GIntBig; eBandType: GDALDataType; papszOptions: PCPChar): GDALDatasetH; stdcall;
  TGDALCreateCopy = function(hDriver: GDALDriverH; pszFilename: CPChar; hSrcDS: GDALDatasetH; bStrict: integer; papszOptions: PCPChar; pfnProgress: GDALProgressFunc; pProgressData: Pointer): GDALDatasetH; cdecl;
  TGDALDatasetCopyLayer = function(hDS: GDALDatasetH; hSrcLayer: Pointer; pszNewName: CPChar; papszOptions: PCPChar): Pointer; stdcall;
  TGDALDatasetGetLayer = function(hDS: GDALDatasetH; iLayer: integer): Pointer; cdecl;
  TGDALDatasetGetLayerByName = function(hDS: GDALDatasetH; const pszName: CPChar): Pointer; cdecl;
  TGDALDatasetReleaseResultSet = procedure(hDS: GDALDatasetH; hLayer: Pointer); cdecl;
  TGDALDatasetExecuteSQL = function(hDS: GDALDatasetH; pszStatement: CPChar; hSpatialFilter: Pointer; pszDialect: CPChar): Pointer; cdecl;
  TGDALOpen = function(pszFilename: CPChar; eAccess: GDALAccess): GDALDatasetH; cdecl;
  TGDALOpenShared = function(pszFilename: CPChar; eAccess: GDALAccess): GDALDatasetH; cdecl;
  TGDALDumpOpenDatasets = function(fp: Pointer): GIntBig; cdecl;
  TGDALGetDriverByName = function(pszName: CPChar): GDALDriverH; cdecl;
  TGDALGetDriverCount = function: GIntBig; cdecl;
  TGDALGetDriver = function(iDriver: GIntBig): GDALDriverH; cdecl;
  TGDALDestroyDriver = procedure(hDriver: GDALDriverH); cdecl;
  TGDALRegisterDriver = function(hDriver: GDALDriverH): GIntBig; cdecl;
  TGDALDeregisterDriver = procedure(hDriver: GDALDriverH); cdecl;
  TGDALDestroyDriverManager = procedure; cdecl;
  TGDALDeleteDataset = function(hDriver: GDALDriverH; pszFilename: CPChar): CPLErr; cdecl;
  TGDALRenameDataset = function(hDriver: GDALDriverH; pszNewName: CPChar; pszOldName: CPChar): CPLErr; cdecl;
  TGDALCopyDatasetFiles = function(hDriver: GDALDriverH; pszNewName: CPChar; pszOldName: CPChar): CPLErr; cdecl;
  TGDALValidateCreationOptions = function(hDriver: GDALDriverH; papszCreationOptions: PCPChar): GIntBig; cdecl;
  TGDALGetDriverShortName = function(hDriver: GDALDriverH): CPChar; cdecl;
  TGDALGetDriverLongName = function(hDriver: GDALDriverH): CPChar; cdecl;
  TGDALGetDriverHelpTopic = function(hDriver: GDALDriverH): CPChar; cdecl;
  TGDALGetDriverCreationOptionList = function(hDriver: GDALDriverH): CPChar; cdecl;
  TGDALInitGCPs = procedure(_para1: GIntBig; _para2: PGDAL_GCP); cdecl;
  TGDALDeinitGCPs = procedure(_para1: GIntBig; _para2: PGDAL_GCP); cdecl;
  TGDALDuplicateGCPs = function(_para1: GIntBig; _para2: PGDAL_GCP): PGDAL_GCP; cdecl;
  TGDALGCPsToGeoTransform = function(nGCPCount: GIntBig; pasGCPs: PGDAL_GCP; padfGeoTransform: Pdouble; bApproxOK: GIntBig): GIntBig; cdecl;
  TGDALInvGeoTransform = function(padfGeoTransformIn: Pdouble; padfInvGeoTransformOut: Pdouble): GIntBig; cdecl;
  TGDALApplyGeoTransform = procedure(padfGeoTransform: Pdouble; dfPixel: double; dfLine: double; pdfGeoX: Pdouble; pdfGeoY: Pdouble); cdecl;
  TGDALGetMetadata = function(hObject: GDALMajorObjectH; pszDomain: CPChar): PCPChar; cdecl;
  TCSLCount = function(papszStrList: PCPChar): integer; cdecl;
  TCSLSave = function(papszStrList: PCPChar; pszFname: CPChar): GIntBig; cdecl;
  TCSLDestroy = procedure(papszStrList: PCPChar); cdecl;
  TCSLGetField = function(papszStrList: PCPChar; iField: integer): CPChar; cdecl;
  TGDALGetMetadataDomainList = function(hObject: GDALMajorObjectH): PCPChar; cdecl;
  TGDALSetMetadata = function(hObject: GDALMajorObjectH; papszMD: PCPChar; pszDomain: CPChar): CPLErr; cdecl;
  TGDALGetMetadataItem = function(hObject: GDALMajorObjectH; pszName: CPChar; pszDomain3: CPChar): CPChar; cdecl;
  TGDALSetMetadataItem = function(hObject: GDALMajorObjectH; pszName: CPChar; pszValue: CPChar; pszDomain: CPChar): CPLErr; cdecl;
  TGDALGetDescription = function(hObject: GDALMajorObjectH): CPChar; cdecl;
  TGDALSetDescription = procedure(hObject: GDALMajorObjectH; pszNewDesc: CPChar); cdecl;
  TGDALGetDatasetDriver = function(hDataset: GDALDatasetH): GDALDriverH; cdecl;
  TGDALGetFileList = function(hDS: GDALDatasetH): PCPChar; cdecl;
  TGDALClose = procedure(hDS: GDALDatasetH); cdecl;
  TGDALGetRasterXSize = function(hDataset: GDALDatasetH): GIntBig; cdecl;
  TGDALGetRasterYSize = function(hDataset: GDALDatasetH): GIntBig; cdecl;
  TGDALGetRasterCount = function(hDS: GDALDatasetH): GIntBig; cdecl;
  TGDALGetRasterBand = function(hDS: GDALDatasetH; nBandId: GIntBig): GDALRasterBandH; cdecl;
  TGDALAddBand = function(hDS: GDALDatasetH; eType: GDALDataType; papszOptions: PCPChar): CPLErr; cdecl;
  TGDALDatasetRasterIO = function(hDS: GDALDatasetH; eRWFlag: GDALRWFlag; nDSXOff: GIntBig; nDSYOff: GIntBig; nDSXSize: GIntBig; nDSYSize: GIntBig; pBuffer: Pointer; nBXSize: GIntBig; nBYSize: GIntBig; eBDataType: GDALDataType; nBandCount: GIntBig; panBandCount: PLongint; nPixelSpace: GIntBig; nLineSpace: GIntBig; nBandSpace: GIntBig): CPLErr; cdecl;
  TGDALDatasetAdviseRead = function(hDS: GDALDatasetH; nDSXOff: GIntBig; nDSYOff: GIntBig; nDSXSize: GIntBig; nDSYSize: GIntBig; nBXSize: GIntBig; nBYSize: GIntBig; eBDataType: GDALDataType; nBandCount: GIntBig; panBandCount: PLongint; papszOptions: PCPChar): CPLErr; cdecl;
  TGDALGetProjectionRef = function(hDS: GDALDatasetH): CPChar; cdecl;
  TGDALSetProjection = function(hDS: GDALDatasetH; pszProjection: CPChar): CPLErr; cdecl;
  TGDALGetGeoTransform = function(hDS: GDALDatasetH; padfTransform: Pdouble): CPLErr; cdecl;
  TGDALSetGeoTransform = function(hDS: GDALDatasetH; padfTransform: Pdouble): CPLErr; cdecl;
  TGDALGetGCPCount = function(hDS: GDALDatasetH): GIntBig; cdecl;
  TGDALGetGCPProjection = function(hDS: GDALDatasetH): CPChar; cdecl;
  TGDALGetGCPs = function(hDS: GDALDatasetH): PGDAL_GCP; cdecl;
  TGDALSetGCPs = function(hDS: GDALDatasetH; nGCPCount: GIntBig; pasGCPList: PGDAL_GCP; pszGCPProjection: CPChar): CPLErr; cdecl;
  TGDALGetInternalHandle = function(hDS: GDALDatasetH; pszRequest: CPChar): Pointer; cdecl;
  TGDALReferenceDataset = function(hDataset: GDALDatasetH): GIntBig; cdecl;
  TGDALDereferenceDataset = function(hDataset: GDALDatasetH): GIntBig; cdecl;
  TGDALBuildOverviews = function(hDataset: GDALDatasetH; pszResampling: CPChar; nOverviews: GIntBig; panOverviewList: PLongInt; nListBands: GIntBig; panBandList: PLongInt; pfnProgress: GDALProgressFunc; pProgressData: Pointer): CPLErr; cdecl;
  TGDALGetOpenDatasets = procedure(hDS: GDALDatasetH; pnCount: PLongInt); cdecl;
  TGDALGetAccess = function(hDS: GDALDatasetH): GIntBig; cdecl;
  TGDALFlushCache = procedure(hDS: GDALDatasetH); cdecl;
  TGDALCreateDatasetMaskBand = function(hDS: GDALDatasetH; nFlags: GIntBig): CPLErr; cdecl;
  TGDALDatasetCopyWholeRaster = function(hSrcDS: GDALDatasetH; hDstDS: GDALDatasetH; papszOptions: PCPChar; pfnProgress: GDALProgressFunc; pProgressData: Pointer): CPLErr; cdecl;
  TGDALRegenerateOverviews = function(hSrcBand: GDALRasterBandH; nOverviewCount: GIntBig; pahOverviewBands: GDALRasterBandH; pszResampling: CPChar; pfnProgress: GDALProgressFunc; pProgressData: Pointer): CPLErr; cdecl;
  TGDALGetRasterDataType = function(hBand: GDALRasterBandH): GDALDataType; cdecl;
  TGDALGetBlockSize = procedure(hBand: GDALRasterBandH; pnXSize: PLongInt; pnYSize: PLongInt); cdecl;
  TGDALRasterAdviseRead = function(hBand: GDALRasterBandH; nDSXOff: GIntBig; nDSYOff: GIntBig; nDSXSize: GIntBig; nDSYSize: GIntBig; nBXSize: GIntBig; nBYSize: GIntBig; eBDataType: GDALDataType; papszOptions: PCPChar): CPLErr; cdecl;
  TGDALRasterIO = function(hBand: GDALRasterBandH; eRWFlag: GDALRWFlag; nDSXOff: GIntBig; nDSYOff: GIntBig; nDSXSize: GIntBig; nDSYSize: GIntBig; pBuffer: Pointer; nBXSize: GIntBig; nBYSize: GIntBig; eBDataType: GDALDataType; nPixelSpace: GIntBig; nLineSpace: GIntBig): CPLErr; cdecl;
  TGDALReadBlock = function(hBand: GDALRasterBandH; nXOff: GIntBig; nYOff: GIntBig; pData: Pointer): CPLErr; cdecl;
  TGDALWriteBlock = function(hBand: GDALRasterBandH; nXOff: GIntBig; nYOff: GIntBig; pData: Pointer): CPLErr; cdecl;
  TGDALGetRasterBandXSize = function(hBand: GDALRasterBandH): GIntBig; cdecl;
  TGDALGetRasterBandYSize = function(hBand: GDALRasterBandH): GIntBig; cdecl;
  TGDALGetRasterAccess = function(hBand: GDALRasterBandH): GDALAccess; cdecl;
  TGDALGetBandNumber = function(hBand: GDALRasterBandH): GIntBig; cdecl;
  TGDALGetBandDataset = function(hBand: GDALRasterBandH): GDALDatasetH; cdecl;
  TGDALGetRasterColorInterpretation = function(hBand: GDALRasterBandH): GDALColorInterp; cdecl;
  TGDALSetRasterColorInterpretation = function(hBand: GDALRasterBandH; eColorInterp: GDALColorInterp): CPLErr; cdecl;
  TGDALGetRasterColorTable = function(hBand: GDALRasterBandH): GDALColorTableH; cdecl;
  TGDALSetRasterColorTable = function(hBand: GDALRasterBandH; hCT: GDALColorTableH): CPLErr; cdecl;
  TGDALHasArbitraryOverviews = function(hBand: GDALRasterBandH): GIntBig; cdecl;
  TGDALGetOverviewCount = function(hBand: GDALRasterBandH): GIntBig; cdecl;
  TGDALGetOverview = function(hBand: GDALRasterBandH; i: GIntBig): GDALRasterBandH; cdecl;
  TGDALGetRasterNoDataValue = function(hBand: GDALRasterBandH; pbSuccess: PLongInt): double; cdecl;
  TGDALSetRasterNoDataValue = function(hBand: GDALRasterBandH; dfValue: double): CPLErr; cdecl;
  TGDALGetRasterCategoryNames = function(hBand: GDALRasterBandH): PCPChar; cdecl;
  TGDALSetRasterCategoryNames = function(hBand: GDALRasterBandH; papszNames: PCPChar): CPLErr; cdecl;
  TGDALGetRasterMinimum = function(hBand: GDALRasterBandH; pbSuccess: PLongInt): double; cdecl;
  TGDALGetRasterMaximum = function(hBand: GDALRasterBandH; pbSuccess: PLongInt): double; cdecl;
  TGDALGetRasterStatistics = function(hBand: GDALRasterBandH; bApproxOK: GIntBig; bForce: GIntBig; pdfMin: Pdouble; pdfMax: Pdouble; pdfMean: Pdouble; pdfStdDev: Pdouble): CPLErr; cdecl;
  TGDALComputeRasterStatistics = function(hBand: GDALRasterBandH; bApproxOK: GIntBig; pdfMin: Pdouble; pdfMax: Pdouble; pdfMean: Pdouble; pdfStdDev: Pdouble; pfnProgress: GDALProgressFunc; pProgressData: pointer): CPLErr; cdecl;
  TGDALSetRasterStatistics = function(hBand: GDALRasterBandH; dfMin: double; dfMax: double; dfMean: double; dfStdDev: double): CPLErr; cdecl;
  TGDALGetRasterUnitType = function(hBand: GDALRasterBandH): CPChar; cdecl;
  TGDALGetRasterOffset = function(hBand: GDALRasterBandH; pbSuccess: PLongInt): double; cdecl;
  TGDALSetRasterOffset = function(hBand: GDALRasterBandH; dfNewOffset: double): CPLErr; cdecl;
  TGDALGetRasterScale = function(hBand: GDALRasterBandH; pbSuccess: PLongInt): double; cdecl;
  TGDALSetRasterScale = function(hBand: GDALRasterBandH; dfNewOffset: double): CPLErr; cdecl;
  TGDALComputeRasterMinMax = procedure(hBand: GDALRasterBandH; bApproxOK: GIntBig; adfMinMax: array of double); cdecl;
  TGDALFlushRasterCache = function(hBand: GDALRasterBandH): CPLErr; cdecl;
  TGDALGetRasterHistogram = function(hBand: GDALRasterBandH; dfMin: double; dfMax: double; nBuckets: GIntBig; panHistogram: PLongInt; bIncludeOutOfRange: GIntBig; bApproxOK: GIntBig; pfnProgress: GDALProgressFunc; pProgressData: Pointer): CPLErr; cdecl;
  TGDALGetDefaultHistogram = function(hBand: GDALRasterBandH; pdfMin: Pdouble; pdfMax: Pdouble; pnBuckets: PLongInt; ppanHistogram: PLongInt; bForce: GIntBig; pfnProgress: GDALProgressFunc; pProgressData: Pointer): CPLErr; cdecl;
  TGDALSetDefaultHistogram = function(hBand: GDALRasterBandH; dfMin: double; dfMax: double; nBuckets: GIntBig; panHistogram: PLongInt): CPLErr; cdecl;
  TGDALGetRandomRasterSample = function(hBand: GDALRasterBandH; _para2: GIntBig; _para3: Psingle): GIntBig; cdecl;
  TGDALGetRasterSampleOverview = function(hBand: GDALRasterBandH; nDesiredSamples: GIntBig): GDALRasterBandH; cdecl;
  TGDALFillRaster = function(hBand: GDALRasterBandH; dfRealValue: double; dfImaginaryValue: double): CPLErr; cdecl;
  TGDALComputeBandStats = function(hBand: GDALRasterBandH; nSampleStep: GIntBig; pdfMean: Pdouble; pdfStdDev: Pdouble; pfnProgress: GDALProgressFunc; pProgressData: pointer): CPLErr; cdecl;
  TGDALOverviewMagnitudeCorrection = function(hBaseBand: GDALRasterBandH; nOverviewCount: GIntBig; pahOverviews: GDALRasterBandH; pfnProgress: GDALProgressFunc; pProgressData: Pointer): CPLErr; cdecl;
  TGDALGetDefaultRAT = function(hBand: GDALRasterBandH): GDALRasterAttributeTableH; cdecl;
  TGDALSetDefaultRAT = function(hBand: GDALRasterBandH; hRAT: GDALRasterAttributeTableH): CPLErr; cdecl;
  TGDALGetMaskBand = function(hBand: GDALRasterBandH): GDALRasterBandH; cdecl;
  TGDALGetMaskFlags = function(hBand: GDALRasterBandH): GIntBig; cdecl;
  TGDALCreateMaskBand = function(hBand: GDALRasterBandH; nFlags: GIntBig): CPLErr; cdecl;
  TGDALGeneralCmdLineProcessor = function(nArgc: GIntBig; ppapszArgv: PChar; nOptions: GIntBig): GIntBig; cdecl;
  TGDALSwapWords = procedure(pData: Pointer; nWordSize: GIntBig; nWordCount: GIntBig; nWordSkip: GIntBig); cdecl;
  TGDALCopyWords = procedure(pSrcData: Pointer; eSrcType: GDALDataType; nSrcPixelOffset: GIntBig; pDstData: Pointer; eDstType: GDALDataType; nDstPixelOffset: GIntBig; nWordCount: GIntBig); cdecl;
  TGDALCopyBits = procedure(pabySrcData: GByte; nSrcOffset: GIntBig; nSrcStep: GIntBig; pabyDstData: GByte; nDstOffset: GIntBig; nDstStep: GIntBig; nBitCount: GIntBig; nStepCount: GIntBig); cdecl;
  TGDALLoadWorldFile = function(pszFilename: CPChar; padfGeoTransform: Pdouble): GIntBig; cdecl;
  TGDALReadWorldFile = function(pszBaseFilename: CPChar; pszExtension: CPChar; padfGeoTransform: Pdouble): GIntBig; cdecl;
  TGDALWriteWorldFile = function(pszBaseFilename: CPChar; pszExtension: CPChar; padfGeoTransform: Pdouble): GIntBig; cdecl;
  TGDALLoadTabFile = function(_para1: CPChar; _para2: Pdouble; _para3: PCPChar; _para4: PLongInt; _para5: PGDAL_GCP): GIntBig; cdecl;
  TGDALReadTabFile = function(_para1: CPChar; _para2: Pdouble; _para3: PCPChar; _para4: PLongInt; _para5: PGDAL_GCP): GIntBig; cdecl;
  TGDALLoadOziMapFile = function(_para1: CPChar; _para2: Pdouble; _para3: PCPChar; _para4: PLongInt; _para5: PGDAL_GCP): GIntBig; cdecl;
  TGDALReadOziMapFile = function(_para1: CPChar; _para2: Pdouble; _para3: PCPChar; _para4: PLongInt; _para5: PGDAL_GCP): GIntBig; cdecl;
  TGDALLoadRPBFile = function(pszFilename: CPChar; papszSiblingFiles: PCPChar): PCPChar; cdecl;
  TGDALWriteRPBFile = function(pszFilename: CPChar; papszMD: PCPChar): CPLErr; cdecl;
  TGDALLoadIMDFile = function(pszFilename: CPChar; papszSiblingFiles: PCPChar): PCPChar; cdecl;
  TGDALWriteIMDFile = function(pszFilename: CPChar; papszMD: PCPChar): CPLErr; cdecl;
  TGDALDecToDMS = function(_para1: double; _para2: CPChar; _para3: GIntBig): CPChar; cdecl;
  TGDALPackedDMSToDec = function(dfPacked: double): double; cdecl;
  TGDALDecToPackedDMS = function(dfDec: double): double; cdecl;
  TGDALVersionInfo = function(pszRequest: CPChar): CPChar; cdecl;
  TGDALCheckVersion = function(nVersionMajor: GIntBig; nVersionMinor: GIntBig; pszCallingComponentName: CPChar): GIntBig; cdecl;
  TGDALExtractRPCInfo = function(_para1: PCPChar; _para2: GDALRPCInfo): GIntBig; cdecl;
  TGDALCreateColorTable = function(eInterp: GDALPaletteInterp): GDALColorTableH; cdecl;
  TGDALDestroyColorTable = procedure(hTable: GDALColorTableH); cdecl;
  TGDALCloneColorTable = function(hTable: GDALColorTableH): GDALColorTableH; cdecl;
  TGDALGetPaletteInterpretation = function(hTable: GDALColorTableH): GDALPaletteInterp; cdecl;
  TGDALGetColorEntryCount = function(hTable: GDALColorTableH): GIntBig; cdecl;
  TGDALGetColorEntry = function(hTable: GDALColorTableH; i: GIntBig): GDALColorEntry; cdecl;
  TGDALGetColorEntryAsRGB = function(hTable: GDALColorTableH; i: GIntBig; poEntry: GDALColorEntry): GIntBig; cdecl;
  TGDALSetColorEntry = procedure(hTable: GDALColorTableH; i: GIntBig; poEntry: GDALColorEntry); cdecl;
  TGDALCreateColorRamp = procedure(hTable: GDALColorTableH; nStartIndex: GIntBig; psStartColor: GDALColorEntry; nEndIndex: GIntBig; psEndColor: GDALColorEntry); cdecl;
  TGDALCreateRasterAttributeTable = function: GDALRasterAttributeTableH; cdecl;
  TGDALDestroyRasterAttributeTable = procedure(_para1: GDALRasterAttributeTableH); cdecl;
  TGDALRATGetColumnCount = function(hRAT: GDALRasterAttributeTableH): GIntBig; cdecl;
  TGDALRATGetNameOfCol = function(hRAT: GDALRasterAttributeTableH; iCol: GIntBig): CPChar; cdecl;
  TGDALRATGetUsageOfCol = function(hRAT: GDALRasterAttributeTableH; iCol: GIntBig): GDALRATFieldUsage; cdecl;
  TGDALRATGetTypeOfCol = function(hRAT: GDALRasterAttributeTableH; iCol: GIntBig): GDALRATFieldType; cdecl;
  TGDALRATGetColOfUsage = function(hRAT: GDALRasterAttributeTableH; eUsage: GDALRATFieldUsage): GIntBig; cdecl;
  TGDALRATGetRowCount = function(hRAT: GDALRasterAttributeTableH): GIntBig; cdecl;
  TGDALRATGetValueAsString = function(hRAT: GDALRasterAttributeTableH; iRow: GIntBig; iField: GIntBig): CPChar; cdecl;
  TGDALRATGetValueAsInt = function(hRAT: GDALRasterAttributeTableH; iRow: GIntBig; iField: GIntBig): GIntBig; cdecl;
  TGDALRATGetValueAsDouble = function(hRAT: GDALRasterAttributeTableH; iRow: GIntBig; iField: GIntBig): double; cdecl;
  TGDALRATSetValueAsString = procedure(hRAT: GDALRasterAttributeTableH; iRow: GIntBig; iField: GIntBig; pszValue: CPChar); cdecl;
  TGDALRATSetValueAsInt = procedure(hRAT: GDALRasterAttributeTableH; iRow: GIntBig; iField: GIntBig; nValue: GIntBig); cdecl;
  TGDALRATSetValueAsDouble = procedure(hRAT: GDALRasterAttributeTableH; iRow: GIntBig; iField: GIntBig; dfValue: double); cdecl;
  TGDALRATSetRowCount = procedure(hRAT: GDALRasterAttributeTableH; nNewCount: GIntBig); cdecl;
  TGDALRATCreateColumn = function(hRAT: GDALRasterAttributeTableH; pszFieldName: CPChar; eFieldType: GDALRATFieldType; eFieldUsage: GDALRATFieldUsage): CPLErr; cdecl;
  TGDALRATSetLinearBinning = function(hRAT: GDALRasterAttributeTableH; dfRow0Min: double; dfBinSize: double): CPLErr; cdecl;
  TGDALRATGetLinearBinning = function(hRAT: GDALRasterAttributeTableH; pdfRow0Min: Pdouble; pdfBinSize: Pdouble): GIntBig; cdecl;
  TGDALRATInitializeFromColorTable = function(hRAT: GDALRasterAttributeTableH; hCT: GDALColorTableH): CPLErr; cdecl;
  TGDALRATTranslateToColorTable = function(hRAT: GDALRasterAttributeTableH; nEntryCount: GIntBig): GDALColorTableH; cdecl;
  TGDALRATDumpReadable = procedure(hRAT: GDALRasterAttributeTableH; fp: Pointer); cdecl;
  TGDALRATClone = function(hRAT: GDALRasterAttributeTableH): GDALRasterAttributeTableH; cdecl;
  TGDALRATGetRowOfValue = function(hRAT: GDALRasterAttributeTableH; dfValue: double): GIntBig; cdecl;
  TGDALSetCacheMax = procedure(nBytes: GIntBig); cdecl;
  TGDALGetCacheMax = function: GIntBig; cdecl;
  TGDALGetCacheUsed = function: GIntBig; cdecl;
  TGDALFlushCacheBlock = function: GIntBig; cdecl;
  TCPLListCount = function(cpllist: Pointer): integer; cdecl;
  TCPLMalloc = function(size: integer): Pointer; cdecl;
  TVSIFree = procedure(p: Pointer); cdecl;

var
  GDALGetDataTypeSize: TGDALGetDataTypeSize;
  GDALDataTypeIsComplex: TGDALDataTypeIsComplex;
  GDALGetDataTypeName: TGDALGetDataTypeName;
  GDALGetDataTypeByName: TGDALGetDataTypeByName;
  GDALDataTypeUnion: TGDALDataTypeUnion;
  GDALGetColorInterpretationName: TGDALGetColorInterpretationName;
  GDALGetColorInterpretationByName: TGDALGetColorInterpretationByName;
  GDALGetPaletteInterpretationName: TGDALGetPaletteInterpretationName;
  GDALDummyProgress: TGDALDummyProgress;
  GDALTermProgress:  TGDALTermProgress;
  GDALScaledProgress: TGDALScaledProgress;
  GDALCreateScaledProgress: TGDALCreateScaledProgress;
  GDALDestroyScaledProgress: TGDALDestroyScaledProgress;
  GDALAllRegister:   TGDALAllRegister;
  GDALCreate:        TGDALCreate;
  GDALCreateCopy:    TGDALCreateCopy;
  GDALDatasetCopyLayer: TGDALDatasetCopyLayer;
  GDALDatasetGetLayer: TGDALDatasetGetLayer;
  GDALDatasetGetLayerByName: TGDALDatasetGetLayerByName;
  GDALDatasetReleaseResultSet: TGDALDatasetReleaseResultSet;
  GDALDatasetExecuteSQL: TGDALDatasetExecuteSQL;
  GDALOpen:          TGDALOpen;
  GDALOpenShared:    TGDALOpenShared;
  GDALDumpOpenDatasets: TGDALDumpOpenDatasets;
  GDALGetDriverByName: TGDALGetDriverByName;
  GDALGetDriverCount: TGDALGetDriverCount;
  GDALGetDriver:     TGDALGetDriver;
  GDALDestroyDriver: TGDALDestroyDriver;
  GDALRegisterDriver: TGDALRegisterDriver;
  GDALDeregisterDriver: TGDALDeregisterDriver;
  GDALDestroyDriverManager: TGDALDestroyDriverManager;
  GDALDeleteDataset: TGDALDeleteDataset;
  GDALRenameDataset: TGDALRenameDataset;
  GDALCopyDatasetFiles: TGDALCopyDatasetFiles;
  GDALValidateCreationOptions: TGDALValidateCreationOptions;
  GDALGetDriverShortName: TGDALGetDriverShortName;
  GDALGetDriverLongName: TGDALGetDriverLongName;
  GDALGetDriverHelpTopic: TGDALGetDriverHelpTopic;
  GDALGetDriverCreationOptionList: TGDALGetDriverCreationOptionList;
  GDALInitGCPs:      TGDALInitGCPs;
  GDALDeinitGCPs:    TGDALDeinitGCPs;
  GDALDuplicateGCPs: TGDALDuplicateGCPs;
  GDALGCPsToGeoTransform: TGDALGCPsToGeoTransform;
  GDALInvGeoTransform: TGDALInvGeoTransform;
  GDALApplyGeoTransform: TGDALApplyGeoTransform;
  GDALGetMetadata:   TGDALGetMetadata;
  CSLCount:          TCSLCount;
  CSLSave:           TCSLSave;
  CSLDestroy:        TCSLDestroy;
  CSLGetField:       TCSLGetField;
  GDALGetMetadataDomainList: TGDALGetMetadataDomainList;
  GDALSetMetadata:   TGDALSetMetadata;
  GDALGetMetadataItem: TGDALGetMetadataItem;
  GDALSetMetadataItem: TGDALSetMetadataItem;
  GDALGetDescription: TGDALGetDescription;
  GDALSetDescription: TGDALSetDescription;
  GDALGetDatasetDriver: TGDALGetDatasetDriver;
  GDALGetFileList:   TGDALGetFileList;
  GDALClose:         TGDALClose;
  GDALGetRasterXSize: TGDALGetRasterXSize;
  GDALGetRasterYSize: TGDALGetRasterYSize;
  GDALGetRasterCount: TGDALGetRasterCount;
  GDALGetRasterBand: TGDALGetRasterBand;
  GDALAddBand:       TGDALAddBand;
  GDALDatasetRasterIO: TGDALDatasetRasterIO;
  GDALDatasetAdviseRead: TGDALDatasetAdviseRead;
  GDALGetProjectionRef: TGDALGetProjectionRef;
  GDALSetProjection: TGDALSetProjection;
  GDALGetGeoTransform: TGDALGetGeoTransform;
  GDALSetGeoTransform: TGDALSetGeoTransform;
  GDALGetGCPCount:   TGDALGetGCPCount;
  GDALGetGCPProjection: TGDALGetGCPProjection;
  GDALGetGCPs:       TGDALGetGCPs;
  GDALSetGCPs:       TGDALSetGCPs;
  GDALGetInternalHandle: TGDALGetInternalHandle;
  GDALReferenceDataset: TGDALReferenceDataset;
  GDALDereferenceDataset: TGDALDereferenceDataset;
  GDALBuildOverviews: TGDALBuildOverviews;
  GDALGetOpenDatasets: TGDALGetOpenDatasets;
  GDALGetAccess:     TGDALGetAccess;
  GDALFlushCache:    TGDALFlushCache;
  GDALCreateDatasetMaskBand: TGDALCreateDatasetMaskBand;
  GDALDatasetCopyWholeRaster: TGDALDatasetCopyWholeRaster;
  GDALRegenerateOverviews: TGDALRegenerateOverviews;
  GDALGetRasterDataType: TGDALGetRasterDataType;
  GDALGetBlockSize:  TGDALGetBlockSize;
  GDALRasterAdviseRead: TGDALRasterAdviseRead;
  GDALRasterIO:      TGDALRasterIO;
  GDALReadBlock:     TGDALReadBlock;
  GDALWriteBlock:    TGDALWriteBlock;
  GDALGetRasterBandXSize: TGDALGetRasterBandXSize;
  GDALGetRasterBandYSize: TGDALGetRasterBandYSize;
  GDALGetRasterAccess: TGDALGetRasterAccess;
  GDALGetBandNumber: TGDALGetBandNumber;
  GDALGetBandDataset: TGDALGetBandDataset;
  GDALGetRasterColorInterpretation: TGDALGetRasterColorInterpretation;
  GDALSetRasterColorInterpretation: TGDALSetRasterColorInterpretation;
  GDALGetRasterColorTable: TGDALGetRasterColorTable;
  GDALSetRasterColorTable: TGDALSetRasterColorTable;
  GDALHasArbitraryOverviews: TGDALHasArbitraryOverviews;
  GDALGetOverviewCount: TGDALGetOverviewCount;
  GDALGetOverview:   TGDALGetOverview;
  GDALGetRasterNoDataValue: TGDALGetRasterNoDataValue;
  GDALSetRasterNoDataValue: TGDALSetRasterNoDataValue;
  GDALGetRasterCategoryNames: TGDALGetRasterCategoryNames;
  GDALSetRasterCategoryNames: TGDALSetRasterCategoryNames;
  GDALGetRasterMinimum: TGDALGetRasterMinimum;
  GDALGetRasterMaximum: TGDALGetRasterMaximum;
  GDALGetRasterStatistics: TGDALGetRasterStatistics;
  GDALComputeRasterStatistics: TGDALComputeRasterStatistics;
  GDALSetRasterStatistics: TGDALSetRasterStatistics;
  GDALGetRasterUnitType: TGDALGetRasterUnitType;
  GDALGetRasterOffset: TGDALGetRasterOffset;
  GDALSetRasterOffset: TGDALSetRasterOffset;
  GDALGetRasterScale: TGDALGetRasterScale;
  GDALSetRasterScale: TGDALSetRasterScale;
  GDALComputeRasterMinMax: TGDALComputeRasterMinMax;
  GDALFlushRasterCache: TGDALFlushRasterCache;
  GDALGetRasterHistogram: TGDALGetRasterHistogram;
  GDALGetDefaultHistogram: TGDALGetDefaultHistogram;
  GDALSetDefaultHistogram: TGDALSetDefaultHistogram;
  GDALGetRandomRasterSample: TGDALGetRandomRasterSample;
  GDALGetRasterSampleOverview: TGDALGetRasterSampleOverview;
  GDALFillRaster:    TGDALFillRaster;
  GDALComputeBandStats: TGDALComputeBandStats;
  GDALOverviewMagnitudeCorrection: TGDALOverviewMagnitudeCorrection;
  GDALGetDefaultRAT: TGDALGetDefaultRAT;
  GDALSetDefaultRAT: TGDALSetDefaultRAT;
  GDALGetMaskBand:   TGDALGetMaskBand;
  GDALGetMaskFlags:  TGDALGetMaskFlags;
  GDALCreateMaskBand: TGDALCreateMaskBand;
  GDALGeneralCmdLineProcessor: TGDALGeneralCmdLineProcessor;
  GDALSwapWords:     TGDALSwapWords;
  GDALCopyWords:     TGDALCopyWords;
  GDALCopyBits:      TGDALCopyBits;
  GDALLoadWorldFile: TGDALLoadWorldFile;
  GDALReadWorldFile: TGDALReadWorldFile;
  GDALWriteWorldFile: TGDALWriteWorldFile;
  GDALLoadTabFile:   TGDALLoadTabFile;
  GDALReadTabFile:   TGDALReadTabFile;
  GDALLoadOziMapFile: TGDALLoadOziMapFile;
  GDALReadOziMapFile: TGDALReadOziMapFile;
  GDALLoadRPBFile:   TGDALLoadRPBFile;
  GDALWriteRPBFile:  TGDALWriteRPBFile;
  GDALLoadIMDFile:   TGDALLoadIMDFile;
  GDALWriteIMDFile:  TGDALWriteIMDFile;
  GDALDecToDMS:      TGDALDecToDMS;
  GDALPackedDMSToDec: TGDALPackedDMSToDec;
  GDALDecToPackedDMS: TGDALDecToPackedDMS;
  GDALVersionInfo:   TGDALVersionInfo;
  GDALCheckVersion:  TGDALCheckVersion;
  GDALExtractRPCInfo: TGDALExtractRPCInfo;
  GDALCreateColorTable: TGDALCreateColorTable;
  GDALDestroyColorTable: TGDALDestroyColorTable;
  GDALCloneColorTable: TGDALCloneColorTable;
  GDALGetPaletteInterpretation: TGDALGetPaletteInterpretation;
  GDALGetColorEntryCount: TGDALGetColorEntryCount;
  GDALGetColorEntry: TGDALGetColorEntry;
  GDALGetColorEntryAsRGB: TGDALGetColorEntryAsRGB;
  GDALSetColorEntry: TGDALSetColorEntry;
  GDALCreateColorRamp: TGDALCreateColorRamp;
  GDALCreateRasterAttributeTable: TGDALCreateRasterAttributeTable;
  GDALDestroyRasterAttributeTable: TGDALDestroyRasterAttributeTable;
  GDALRATGetColumnCount: TGDALRATGetColumnCount;
  GDALRATGetNameOfCol: TGDALRATGetNameOfCol;
  GDALRATGetUsageOfCol: TGDALRATGetUsageOfCol;
  GDALRATGetTypeOfCol: TGDALRATGetTypeOfCol;
  GDALRATGetColOfUsage: TGDALRATGetColOfUsage;
  GDALRATGetRowCount: TGDALRATGetRowCount;
  GDALRATGetValueAsString: TGDALRATGetValueAsString;
  GDALRATGetValueAsInt: TGDALRATGetValueAsInt;
  GDALRATGetValueAsDouble: TGDALRATGetValueAsDouble;
  GDALRATSetValueAsString: TGDALRATSetValueAsString;
  GDALRATSetValueAsInt: TGDALRATSetValueAsInt;
  GDALRATSetValueAsDouble: TGDALRATSetValueAsDouble;
  GDALRATSetRowCount: TGDALRATSetRowCount;
  GDALRATCreateColumn: TGDALRATCreateColumn;
  GDALRATSetLinearBinning: TGDALRATSetLinearBinning;
  GDALRATGetLinearBinning: TGDALRATGetLinearBinning;
  GDALRATInitializeFromColorTable: TGDALRATInitializeFromColorTable;
  GDALRATTranslateToColorTable: TGDALRATTranslateToColorTable;
  GDALRATDumpReadable: TGDALRATDumpReadable;
  GDALRATClone:      TGDALRATClone;
  GDALRATGetRowOfValue: TGDALRATGetRowOfValue;
  GDALSetCacheMax:   TGDALSetCacheMax;
  GDALGetCacheMax:   TGDALGetCacheMax;
  GDALGetCacheUsed:  TGDALGetCacheUsed;
  GDALFlushCacheBlock: TGDALFlushCacheBlock;
  CPLListCount:      TCPLListCount;
  CPLMalloc:         TCPLMalloc;
  VSIFree:           TVSIFree;

implementation

procedure DynamicLoad(const ALibName: string);
var
  dllHandle: cardinal;
begin
  dllHandle := LoadLibrary(PAnsiChar(ALibName));
  @VSIFree  := GetProcAddress(dllHandle, 'VSIFree');
  @GDALGetDataTypeSize := GetProcAddress(dllHandle, 'GDALGetDataTypeSize');
  @GDALDataTypeIsComplex := GetProcAddress(dllHandle, 'GDALDataTypeIsComplex');
  @GDALGetDataTypeName := GetProcAddress(dllHandle, 'GDALGetDataTypeName');
  @GDALGetDataTypeByName := GetProcAddress(dllHandle, 'GDALGetDataTypeByName');
  @GDALDataTypeUnion := GetProcAddress(dllHandle, 'GDALDataTypeUnion');
  @GDALGetColorInterpretationName := GetProcAddress(dllHandle, 'GDALGetColorInterpretationName');
  @GDALGetColorInterpretationByName := GetProcAddress(dllHandle, 'GDALGetColorInterpretationByName');
  @GDALGetPaletteInterpretationName := GetProcAddress(dllHandle, 'GDALGetPaletteInterpretationName');
  @GDALDummyProgress := GetProcAddress(dllHandle, 'GDALDummyProgress');
  @GDALTermProgress := GetProcAddress(dllHandle, 'GDALTermProgress');
  @GDALScaledProgress := GetProcAddress(dllHandle, 'GDALScaledProgress');
  @GDALCreateScaledProgress := GetProcAddress(dllHandle, 'GDALCreateScaledProgress');
  @GDALDestroyScaledProgress := GetProcAddress(dllHandle, 'GDALDestroyScaledProgress');
  @GDALAllRegister := GetProcAddress(dllHandle, 'GDALAllRegister');
  @GDALCreate := GetProcAddress(dllHandle, 'GDALCreate');
  @GDALCreateCopy := GetProcAddress(dllHandle, 'GDALCreateCopy');
  @GDALDatasetCopyLayer := GetProcAddress(dllHandle, 'GDALDatasetCopyLayer');
  @GDALDatasetGetLayer := GetProcAddress(dllHandle, 'GDALDatasetGetLayer');
  @GDALDatasetGetLayerByName := GetProcAddress(dllHandle, 'GDALDatasetGetLayerByName');
  @GDALDatasetReleaseResultSet := GetProcAddress(dllHandle, 'GDALDatasetReleaseResultSet');
  @GDALDatasetExecuteSQL := GetProcAddress(dllHandle, 'GDALDatasetExecuteSQL');
  @GDALOpen := GetProcAddress(dllHandle, 'GDALOpen');
  @GDALOpenShared := GetProcAddress(dllHandle, 'GDALOpenShared');
  @GDALDumpOpenDatasets := GetProcAddress(dllHandle, 'GDALDumpOpenDatasets');
  @GDALGetDriverByName := GetProcAddress(dllHandle, 'GDALGetDriverByName');
  @GDALGetDriverCount := GetProcAddress(dllHandle, 'GDALGetDriverCount');
  @GDALGetDriver := GetProcAddress(dllHandle, 'GDALGetDriver');
  @GDALDestroyDriver := GetProcAddress(dllHandle, 'GDALDestroyDriver');
  @GDALRegisterDriver := GetProcAddress(dllHandle, 'GDALRegisterDriver');
  @GDALDeregisterDriver := GetProcAddress(dllHandle, 'GDALDeregisterDriver');
  @GDALDestroyDriverManager := GetProcAddress(dllHandle, 'GDALDestroyDriverManager');
  @GDALDeleteDataset := GetProcAddress(dllHandle, 'GDALDeleteDataset');
  @GDALRenameDataset := GetProcAddress(dllHandle, 'GDALRenameDataset');
  @GDALCopyDatasetFiles := GetProcAddress(dllHandle, 'GDALCopyDatasetFiles');
  @GDALValidateCreationOptions := GetProcAddress(dllHandle, 'GDALValidateCreationOptions');
  @GDALGetDriverShortName := GetProcAddress(dllHandle, 'GDALGetDriverShortName');
  @GDALGetDriverLongName := GetProcAddress(dllHandle, 'GDALGetDriverLongName');
  @GDALGetDriverHelpTopic := GetProcAddress(dllHandle, 'GDALGetDriverHelpTopic');
  @GDALGetDriverCreationOptionList := GetProcAddress(dllHandle, 'GDALGetDriverCreationOptionList');
  @GDALInitGCPs := GetProcAddress(dllHandle, 'GDALInitGCPs');
  @GDALDeinitGCPs := GetProcAddress(dllHandle, 'GDALDeinitGCPs');
  @GDALDuplicateGCPs := GetProcAddress(dllHandle, 'GDALDuplicateGCPs');
  @GDALGCPsToGeoTransform := GetProcAddress(dllHandle, 'GDALGCPsToGeoTransform');
  @GDALInvGeoTransform := GetProcAddress(dllHandle, 'GDALInvGeoTransform');
  @GDALApplyGeoTransform := GetProcAddress(dllHandle, 'GDALApplyGeoTransform');
  @GDALGetMetadata := GetProcAddress(dllHandle, 'GDALGetMetadata');
  @CSLCount := GetProcAddress(dllHandle, 'CSLCount');
  @CSLSave  := GetProcAddress(dllHandle, 'CSLSave');
  @CSLDestroy := GetProcAddress(dllHandle, 'CSLDestroy');
  @CSLGetField := GetProcAddress(dllHandle, 'CSLGetField');
  @GDALGetMetadataDomainList := GetProcAddress(dllHandle, 'GDALGetMetadataDomainList');
  @GDALSetMetadata := GetProcAddress(dllHandle, 'GDALSetMetadata');
  @GDALGetMetadataItem := GetProcAddress(dllHandle, 'GDALGetMetadataItem');
  @GDALSetMetadataItem := GetProcAddress(dllHandle, 'GDALSetMetadataItem');
  @GDALGetDescription := GetProcAddress(dllHandle, 'GDALGetDescription');
  @GDALSetDescription := GetProcAddress(dllHandle, 'GDALSetDescription');
  @GDALGetDatasetDriver := GetProcAddress(dllHandle, 'GDALGetDatasetDriver');
  @GDALGetFileList := GetProcAddress(dllHandle, 'GDALGetFileList');
  @GDALClose := GetProcAddress(dllHandle, 'GDALClose');
  @GDALGetRasterXSize := GetProcAddress(dllHandle, 'GDALGetRasterXSize');
  @GDALGetRasterYSize := GetProcAddress(dllHandle, 'GDALGetRasterYSize');
  @GDALGetRasterCount := GetProcAddress(dllHandle, 'GDALGetRasterCount');
  @GDALGetRasterBand := GetProcAddress(dllHandle, 'GDALGetRasterBand');
  @GDALAddBand := GetProcAddress(dllHandle, 'GDALAddBand');
  @GDALDatasetRasterIO := GetProcAddress(dllHandle, 'GDALDatasetRasterIO');
  @GDALDatasetAdviseRead := GetProcAddress(dllHandle, 'GDALDatasetAdviseRead');
  @GDALGetProjectionRef := GetProcAddress(dllHandle, 'GDALGetProjectionRef');
  @GDALSetProjection := GetProcAddress(dllHandle, 'GDALSetProjection');
  @GDALGetGeoTransform := GetProcAddress(dllHandle, 'GDALGetGeoTransform');
  @GDALSetGeoTransform := GetProcAddress(dllHandle, 'GDALSetGeoTransform');
  @GDALGetGCPCount := GetProcAddress(dllHandle, 'GDALGetGCPCount');
  @GDALGetGCPProjection := GetProcAddress(dllHandle, 'GDALGetGCPProjection');
  @GDALGetGCPs := GetProcAddress(dllHandle, 'GDALGetGCPs');
  @GDALSetGCPs := GetProcAddress(dllHandle, 'GDALSetGCPs');
  @GDALGetInternalHandle := GetProcAddress(dllHandle, 'GDALGetInternalHandle');
  @GDALReferenceDataset := GetProcAddress(dllHandle, 'GDALReferenceDataset');
  @GDALDereferenceDataset := GetProcAddress(dllHandle, 'GDALDereferenceDataset');
  @GDALBuildOverviews := GetProcAddress(dllHandle, 'GDALBuildOverviews');
  @GDALGetOpenDatasets := GetProcAddress(dllHandle, 'GDALGetOpenDatasets');
  @GDALGetAccess := GetProcAddress(dllHandle, 'GDALGetAccess');
  @GDALFlushCache := GetProcAddress(dllHandle, 'GDALFlushCache');
  @GDALCreateDatasetMaskBand := GetProcAddress(dllHandle, 'GDALCreateDatasetMaskBand');
  @GDALDatasetCopyWholeRaster := GetProcAddress(dllHandle, 'GDALDatasetCopyWholeRaster');
  @GDALRegenerateOverviews := GetProcAddress(dllHandle, 'GDALRegenerateOverviews');
  @GDALGetRasterDataType := GetProcAddress(dllHandle, 'GDALGetRasterDataType');
  @GDALGetBlockSize := GetProcAddress(dllHandle, 'GDALGetBlockSize');
  @GDALRasterAdviseRead := GetProcAddress(dllHandle, 'GDALRasterAdviseRead');
  @GDALRasterIO := GetProcAddress(dllHandle, 'GDALRasterIO');
  @GDALReadBlock := GetProcAddress(dllHandle, 'GDALReadBlock');
  @GDALWriteBlock := GetProcAddress(dllHandle, 'GDALWriteBlock');
  @GDALGetRasterBandXSize := GetProcAddress(dllHandle, 'GDALGetRasterBandXSize');
  @GDALGetRasterBandYSize := GetProcAddress(dllHandle, 'GDALGetRasterBandYSize');
  @GDALGetRasterAccess := GetProcAddress(dllHandle, 'GDALGetRasterAccess');
  @GDALGetBandNumber := GetProcAddress(dllHandle, 'GDALGetBandNumber');
  @GDALGetBandDataset := GetProcAddress(dllHandle, 'GDALGetBandDataset');
  @GDALGetRasterColorInterpretation := GetProcAddress(dllHandle, 'GDALGetRasterColorInterpretation');
  @GDALSetRasterColorInterpretation := GetProcAddress(dllHandle, 'GDALSetRasterColorInterpretation');
  @GDALGetRasterColorTable := GetProcAddress(dllHandle, 'GDALGetRasterColorTable');
  @GDALSetRasterColorTable := GetProcAddress(dllHandle, 'GDALSetRasterColorTable');
  @GDALHasArbitraryOverviews := GetProcAddress(dllHandle, 'GDALHasArbitraryOverviews');
  @GDALGetOverviewCount := GetProcAddress(dllHandle, 'GDALGetOverviewCount');
  @GDALGetOverview := GetProcAddress(dllHandle, 'GDALGetOverview');
  @GDALGetRasterNoDataValue := GetProcAddress(dllHandle, 'GDALGetRasterNoDataValue');
  @GDALSetRasterNoDataValue := GetProcAddress(dllHandle, 'GDALSetRasterNoDataValue');
  @GDALGetRasterCategoryNames := GetProcAddress(dllHandle, 'GDALGetRasterCategoryNames');
  @GDALSetRasterCategoryNames := GetProcAddress(dllHandle, 'GDALSetRasterCategoryNames');
  @GDALGetRasterMinimum := GetProcAddress(dllHandle, 'GDALGetRasterMinimum');
  @GDALGetRasterMaximum := GetProcAddress(dllHandle, 'GDALGetRasterMaximum');
  @GDALGetRasterStatistics := GetProcAddress(dllHandle, 'GDALGetRasterStatistics');
  @GDALComputeRasterStatistics := GetProcAddress(dllHandle, 'GDALComputeRasterStatistics');
  @GDALSetRasterStatistics := GetProcAddress(dllHandle, 'GDALSetRasterStatistics');
  @GDALGetRasterUnitType := GetProcAddress(dllHandle, 'GDALGetRasterUnitType');
  @GDALGetRasterOffset := GetProcAddress(dllHandle, 'GDALGetRasterOffset');
  @GDALSetRasterOffset := GetProcAddress(dllHandle, 'GDALSetRasterOffset');
  @GDALGetRasterScale := GetProcAddress(dllHandle, 'GDALGetRasterScale');
  @GDALSetRasterScale := GetProcAddress(dllHandle, 'GDALSetRasterScale');
  @GDALComputeRasterMinMax := GetProcAddress(dllHandle, 'GDALComputeRasterMinMax');
  @GDALFlushRasterCache := GetProcAddress(dllHandle, 'GDALFlushRasterCache');
  @GDALGetRasterHistogram := GetProcAddress(dllHandle, 'GDALGetRasterHistogram');
  @GDALGetDefaultHistogram := GetProcAddress(dllHandle, 'GDALGetDefaultHistogram');
  @GDALSetDefaultHistogram := GetProcAddress(dllHandle, 'GDALSetDefaultHistogram');
  @GDALGetRandomRasterSample := GetProcAddress(dllHandle, 'GDALGetRandomRasterSample');
  @GDALGetRasterSampleOverview := GetProcAddress(dllHandle, 'GDALGetRasterSampleOverview');
  @GDALFillRaster := GetProcAddress(dllHandle, 'GDALFillRaster');
  @GDALComputeBandStats := GetProcAddress(dllHandle, 'GDALComputeBandStats');
  @GDALOverviewMagnitudeCorrection := GetProcAddress(dllHandle, 'GDALOverviewMagnitudeCorrection');
  @GDALGetDefaultRAT := GetProcAddress(dllHandle, 'GDALGetDefaultRAT');
  @GDALSetDefaultRAT := GetProcAddress(dllHandle, 'GDALSetDefaultRAT');
  @GDALGetMaskBand := GetProcAddress(dllHandle, 'GDALGetMaskBand');
  @GDALGetMaskFlags := GetProcAddress(dllHandle, 'GDALGetMaskFlags');
  @GDALCreateMaskBand := GetProcAddress(dllHandle, 'GDALCreateMaskBand');
  @GDALGeneralCmdLineProcessor := GetProcAddress(dllHandle, 'GDALGeneralCmdLineProcessor');
  @GDALSwapWords := GetProcAddress(dllHandle, 'GDALSwapWords');
  @GDALCopyWords := GetProcAddress(dllHandle, 'GDALCopyWords');
  @GDALCopyBits := GetProcAddress(dllHandle, 'GDALCopyBits');
  @GDALLoadWorldFile := GetProcAddress(dllHandle, 'GDALLoadWorldFile');
  @GDALReadWorldFile := GetProcAddress(dllHandle, 'GDALReadWorldFile');
  @GDALWriteWorldFile := GetProcAddress(dllHandle, 'GDALWriteWorldFile');
  @GDALLoadTabFile := GetProcAddress(dllHandle, 'GDALLoadTabFile');
  @GDALReadTabFile := GetProcAddress(dllHandle, 'GDALReadTabFile');
  @GDALLoadOziMapFile := GetProcAddress(dllHandle, 'GDALLoadOziMapFile');
  @GDALReadOziMapFile := GetProcAddress(dllHandle, 'GDALReadOziMapFile');
  @GDALLoadRPBFile := GetProcAddress(dllHandle, 'GDALLoadRPBFile');
  @GDALWriteRPBFile := GetProcAddress(dllHandle, 'GDALWriteRPBFile');
  @GDALLoadIMDFile := GetProcAddress(dllHandle, 'GDALLoadIMDFile');
  @GDALWriteIMDFile := GetProcAddress(dllHandle, 'GDALWriteIMDFile');
  @GDALDecToDMS := GetProcAddress(dllHandle, 'GDALDecToDMS');
  @GDALPackedDMSToDec := GetProcAddress(dllHandle, 'GDALPackedDMSToDec');
  @GDALDecToPackedDMS := GetProcAddress(dllHandle, 'GDALDecToPackedDMS');
  @GDALVersionInfo := GetProcAddress(dllHandle, 'GDALVersionInfo');
  @GDALCheckVersion := GetProcAddress(dllHandle, 'GDALCheckVersion');
  @GDALExtractRPCInfo := GetProcAddress(dllHandle, 'GDALExtractRPCInfo');
  @GDALCreateColorTable := GetProcAddress(dllHandle, 'GDALCreateColorTable');
  @GDALDestroyColorTable := GetProcAddress(dllHandle, 'GDALDestroyColorTable');
  @GDALCloneColorTable := GetProcAddress(dllHandle, 'GDALCloneColorTable');
  @GDALGetPaletteInterpretation := GetProcAddress(dllHandle, 'GDALGetPaletteInterpretation');
  @GDALGetColorEntryCount := GetProcAddress(dllHandle, 'GDALGetColorEntryCount');
  @GDALGetColorEntry := GetProcAddress(dllHandle, 'GDALGetColorEntry');
  @GDALGetColorEntryAsRGB := GetProcAddress(dllHandle, 'GDALGetColorEntryAsRGB');
  @GDALSetColorEntry := GetProcAddress(dllHandle, 'GDALSetColorEntry');
  @GDALCreateColorRamp := GetProcAddress(dllHandle, 'GDALCreateColorRamp');
  @GDALCreateRasterAttributeTable := GetProcAddress(dllHandle, 'GDALCreateRasterAttributeTable');
  @GDALDestroyRasterAttributeTable := GetProcAddress(dllHandle, 'GDALDestroyRasterAttributeTable');
  @GDALRATGetColumnCount := GetProcAddress(dllHandle, 'GDALRATGetColumnCount');
  @GDALRATGetNameOfCol := GetProcAddress(dllHandle, 'GDALRATGetNameOfCol');
  @GDALRATGetUsageOfCol := GetProcAddress(dllHandle, 'GDALRATGetUsageOfCol');
  @GDALRATGetTypeOfCol := GetProcAddress(dllHandle, 'GDALRATGetTypeOfCol');
  @GDALRATGetColOfUsage := GetProcAddress(dllHandle, 'GDALRATGetColOfUsage');
  @GDALRATGetRowCount := GetProcAddress(dllHandle, 'GDALRATGetRowCount');
  @GDALRATGetValueAsString := GetProcAddress(dllHandle, 'GDALRATGetValueAsString');
  @GDALRATGetValueAsInt := GetProcAddress(dllHandle, 'GDALRATGetValueAsInt');
  @GDALRATGetValueAsDouble := GetProcAddress(dllHandle, 'GDALRATGetValueAsDouble');
  @GDALRATSetValueAsString := GetProcAddress(dllHandle, 'GDALRATSetValueAsString');
  @GDALRATSetValueAsInt := GetProcAddress(dllHandle, 'GDALRATSetValueAsInt');
  @GDALRATSetValueAsDouble := GetProcAddress(dllHandle, 'GDALRATSetValueAsDouble');
  @GDALRATSetRowCount := GetProcAddress(dllHandle, 'GDALRATSetRowCount');
  @GDALRATCreateColumn := GetProcAddress(dllHandle, 'GDALRATCreateColumn');
  @GDALRATSetLinearBinning := GetProcAddress(dllHandle, 'GDALRATSetLinearBinning');
  @GDALRATGetLinearBinning := GetProcAddress(dllHandle, 'GDALRATGetLinearBinning');
  @GDALRATInitializeFromColorTable := GetProcAddress(dllHandle, 'GDALRATInitializeFromColorTable');
  @GDALRATTranslateToColorTable := GetProcAddress(dllHandle, 'GDALRATTranslateToColorTable');
  @GDALRATDumpReadable := GetProcAddress(dllHandle, 'GDALRATDumpReadable');
  @GDALRATClone := GetProcAddress(dllHandle, 'GDALRATClone');
  @GDALRATGetRowOfValue := GetProcAddress(dllHandle, 'GDALRATGetRowOfValue');
  @GDALSetCacheMax := GetProcAddress(dllHandle, 'GDALSetCacheMax');
  @GDALGetCacheMax := GetProcAddress(dllHandle, 'GDALGetCacheMax');
  @GDALGetCacheUsed := GetProcAddress(dllHandle, 'GDALGetCacheUsed');
  @GDALFlushCacheBlock := GetProcAddress(dllHandle, 'GDALFlushCacheBlock');
  @CPLListCount := GetProcAddress(dllHandle, 'CPLListCount');
  @CPLMalloc := GetProcAddress(dllHandle, 'CPLMalloc');
end;

initialization
  DynamicLoad(LibName);

end.

