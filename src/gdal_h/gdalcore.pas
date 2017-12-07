{
  Common constants and core portability definitions for GDAL

  Copyright (C) 2010 Alexander Bruy (alexander.bruy@gmail.com)

  Based on the sources automatically converted by H2Pas 1.0.0
  The original files are: gdal_version.h, cpl_error.h, cpl_port.h

  Permission is hereby granted, free of charge, to any person obtaining a
  copy of this software and associated documentation files (the "Software"),
  to deal in the Software without restriction, including without limitation
  the rights to use, copy, modify, merge, publish, distribute, sublicense,
  and/or sell copies of the Software, and to permit persons to whom the
  Software is furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included
  in all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  DEALINGS IN THE SOFTWARE.
}

{ ******************************************************************************
  * $Id: cpl_port.h 17734 2009-10-03 09:48:01Z rouault $
  *
  * Project:  CPL - Common Portability Library
  * Author:   Frank Warmerdam, warmerdam@pobox.com
  * Purpose:  Include file providing low level portability services for CPL.
  *           This should be the first include file for any CPL based code.
  *
  ******************************************************************************
  * Copyright (c) 1998, 2005, Frank Warmerdam <warmerdam@pobox.com>
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
  **************************************************************************** }
{ **********************************************************************
  * $Id: cpl_error.h 14047 2008-03-20 18:46:12Z rouault $
  *
  * Name:     cpl_error.h
  * Project:  CPL - Common Portability Library
  * Purpose:  CPL Error handling
  * Author:   Daniel Morissette, danmo@videotron.ca
  *
  **********************************************************************
  * Copyright (c) 1998, Daniel Morissette
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
  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
  * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  * DEALINGS IN THE SOFTWARE.
  **************************************************************************** }

{$H+}
{$IFDEF FPC}
{$MODE objfpc}
{$PACKRECORDS C}
{$ENDIF}
unit gdalcore;

interface

uses
  SysUtils, Windows;

  // ----------------------------------------------------------------------------
const
    { DLL }
  LibName = 'gdal202.dll';

    { GDAL Version Information (gdal_version.h) }
  GDAL_VERSION_MAJOR = 1;
  GDAL_VERSION_MINOR = 8;
  GDAL_VERSION_REV = 1;
  GDAL_VERSION_BUILD = 0;
  GDAL_VERSION_NUM = GDAL_VERSION_MAJOR * 1000 + GDAL_VERSION_MINOR * 100 + GDAL_VERSION_REV * 10 + GDAL_VERSION_BUILD;
  GDAL_RELEASE_DATE = 20110709;
  GDAL_RELEASE_NAME = '1.8.1';

    { GDAL version info requests }
  VERSION_NUM = 'VERSION_NUM';
  RELEASE_DATE = 'RELEASE_DATE';
  RELEASE_NAME = 'RELEASE_NAME';
  VERSION = '--version';
  LICENSE = 'LICENCE';

    // ---------------------------------------------------------------------------

type
    { Map C/C++ type to Delphi ones }
{$IFDEF FPC}
  CPChar = PChar;

  PCPChar = ^PChar;
{$ELSE}

  CPChar = PChar;

  PCPChar = PPChar;
{$ENDIF}
    { types for 16 and 32 bits integers, etc... }

  GInt32 = longint;

  GUInt32 = longint;

  GInt16 = smallint;

  GUInt16 = word;

  GByte = byte;

  GBool = longint;
    { 64bit support }

  GIntBig = int64;

  GUIntBig = int64;

    { cpl_error.h - CPL error handling services }
  CPLErr = (CE_None = 0, CE_Debug = 1, CE_Warning = 2, CE_Failure = 3, CE_Fatal = 4);

    // ---------------------------------------------------------------------------

{$REGION 'CPL'}

type
  TCPLErrorHandler = procedure(TeErrClass: CPLErr; err_no: integer; const msg: CPChar); stdcall;
    //

  TCPLSetErrorHandler = function(pfnErrorHandlerNew: TCPLErrorHandler): TCPLErrorHandler; stdcall;

  TCPLError = procedure(eErrClass: CPLErr; err_no: integer; const fmt: CPChar); stdcall;

  TCPLGetLastErrorMsg = function: CPChar; stdcall;

  TCPLGetConfigOption = function(const Key: CPChar; const Default: CPChar): CPChar; stdcall;

  TCPLSetConfigOption = procedure(const Key: CPChar; const Value: CPChar); stdcall;

var
  CPLSetErrorHandler: TCPLSetErrorHandler;
  CPLError: TCPLError;
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
  if (Lib > 32) then
  begin
    DispatchTableAssing(@CPLSetErrorHandler, '_CPLSetErrorHandler@4');
    DispatchTableAssing(@CPLError, 'CPLError');
    DispatchTableAssing(@CPLGetLastErrorMsg, '_CPLGetLastErrorMsg@0');
    DispatchTableAssing(@CPLGetConfigOption, '_CPLGetConfigOption@8');
    DispatchTableAssing(@CPLSetConfigOption, '_CPLSetConfigOption@8');
  end;
end;

end.

