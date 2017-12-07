unit CPLUtils;

interface

uses Classes, gdal, gdalcore, SysUtils, Windows;

type
  NPPCharArray = array[0..(MAXSHORT div SizeOf(PChar)) - 1] of PChar;

procedure UnpackCPLCharArray(const AArray: Pointer; var AList: TStringList);

implementation

procedure UnpackCPLCharArray(const AArray: Pointer; var AList: TStringList);
var
  Str: PChar;
  StrArr: NPPCharArray;
  i: integer;
begin
  i := 0;
  StrArr := NPPCharArray(AArray^);
  while StrArr[i] <> nil do begin
    New(Str);
    StrCopy(Str, StrArr[i]);
    AList.Add(Str);
    Inc(i);
  end;
end;

end.
