unit GdalErrorHandler;

interface

uses
  Classes,
  gdalcore,
  SysUtils,
  Windows;

procedure HandleCPLError(TeErrClass: CPLErr; err_no: integer; const msg: CPChar); stdcall;

type
  TCPLException = class(Exception);

  TCPLSQLExpressionParsingError = class(TCPLException);
  TOGRReleaseDatasourceError = class(TCPLException);
  TCPLSQLConversionFailed = class(TCPLException);

implementation

procedure HandleCPLError(TeErrClass: CPLErr; err_no: integer; const msg: CPChar);
begin
  OutputDebugStringA(msg);

  case TeErrClass of
    CE_Fatal: begin

    end;
    CE_Debug: ;
    CE_Failure:
      case err_no of
        1:
          raise TCPLSQLExpressionParsingError.Create(msg);
        10:
          raise TOGRReleaseDatasourceError.Create(Msg);
      end;
    CE_Warning:
      case err_no of
        6:
          raise TCPLSQLConversionFailed.Create(msg);
      end
    else
      raise TCPLException.Create(msg);
  end;
end;

initialization
  LoadGdal;
  CPLSetErrorHandler(HandleCPLError);
  CPLSetConfigOption('GDAL_FILENAME_IS_UTF8', 'NO');

end.
