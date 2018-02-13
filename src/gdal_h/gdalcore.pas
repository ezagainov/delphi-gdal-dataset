
{$H+}
{$IFDEF FPC}
{$MODE objfpc}
{$PACKRECORDS C}
{$ENDIF}
unit gdalcore;

interface

uses
  SysUtils, Windows;

const

  LibName = 'gdal202.dll';

  GDAL_VERSION_MAJOR = 1;
  GDAL_VERSION_MINOR = 8;
  GDAL_VERSION_REV   = 1;
  GDAL_VERSION_BUILD = 0;
  GDAL_VERSION_NUM   = GDAL_VERSION_MAJOR * 1000 + GDAL_VERSION_MINOR * 100 + GDAL_VERSION_REV * 10 + GDAL_VERSION_BUILD;
  GDAL_RELEASE_DATE  = 20110709;
  GDAL_RELEASE_NAME  = '1.8.1';

  VERSION_NUM  = 'VERSION_NUM';
  RELEASE_DATE = 'RELEASE_DATE';
  RELEASE_NAME = 'RELEASE_NAME';
  VERSION      = '--version';
  LICENSE      = 'LICENCE';

type

{$IFDEF FPC}
  CPChar = PChar;

  PCPChar = ^PChar;
{$ELSE}

  CPChar = PChar;

  PCPChar = PPChar;
{$ENDIF}

  GInt32 = longint;

  GUInt32 = longint;

  GInt16 = smallint;

  GUInt16 = word;

  GByte = byte;

  GBool = longint;

  GIntBig = int64;

  GUIntBig = int64;

  CPLErr = (CE_None = 0, CE_Debug = 1, CE_Warning = 2, CE_Failure = 3, CE_Fatal = 4);

{$REGION 'CPL'}

type
  TCPLErrorHandler = procedure(TeErrClass: CPLErr; err_no: integer; const msg: CPChar); stdcall;

  TCPLSetErrorHandler = function(pfnErrorHandlerNew: TCPLErrorHandler): TCPLErrorHandler; stdcall;

  TCPLError = procedure(eErrClass: CPLErr; err_no: integer; const fmt: CPChar); stdcall;

  TCPLGetLastErrorMsg = function: CPChar; stdcall;

  TCPLGetConfigOption = function(const Key: CPChar; const Default: CPChar): CPChar; stdcall;

  TCPLSetConfigOption = procedure(const Key: CPChar; const Value: CPChar); stdcall;

var
  CPLSetErrorHandler: TCPLSetErrorHandler;
  CPLError:           TCPLError;
  CPLGetLastErrorMsg: TCPLGetLastErrorMsg;
  CPLGetConfigOption: TCPLGetConfigOption;
  CPLSetConfigOption: TCPLSetConfigOption;

{$ENDREGION}

var
  Lib: THandle;

const
  ObjIsNULLError = 1001;

procedure LoadGdal;

implementation

procedure LoadGdal;

  procedure DispatchTableAssing(var Proc: Pointer; const Name: string);
  begin
    Proc := GetProcAddress(Lib, PChar(Name));
    Assert(Assigned(Proc), Format('Not loadded %s', [Name]));
  end;

begin
  Lib := LoadLibrary(PChar(LibName));
  if (Lib > 32) then begin
    DispatchTableAssing(@CPLSetErrorHandler, '_CPLSetErrorHandler@4');
    DispatchTableAssing(@CPLError, 'CPLError');
    DispatchTableAssing(@CPLGetLastErrorMsg, '_CPLGetLastErrorMsg@0');
    DispatchTableAssing(@CPLGetConfigOption, '_CPLGetConfigOption@8');
    DispatchTableAssing(@CPLSetConfigOption, '_CPLSetConfigOption@8');
  end;
end;

end.

