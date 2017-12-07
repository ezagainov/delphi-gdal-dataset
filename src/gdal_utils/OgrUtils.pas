unit OgrUtils;

interface

uses
  Classes,
  
  
  
  gdal,
  gdalcore,
  
  ogr,
  
  SysUtils;

var
  AllowedExtList: TStringList;

function AllowedFileExts: TStringList;

function OgrCheck(RetVal: OGRErr): boolean;

implementation


function OgrCheck(RetVal: OGRErr): boolean;
begin
  Result := RetVal = OGRERR_NONE;
  if not Result then
    raise Exception.Create(CPLGetLastErrorMsg);
end;

function AllowedFileExts: TStringList;
var
  I: integer;
  Drv: GDALDriverH;
  AllExt: TStringList;

  procedure GetExtListByDriver(const ADriver: GDALDriverH;
    AAllowed, AAllExt: TStringList);
  var
    BufList: TStringList;
    ExtStr, DrvName: string;
    StrItem: string;
    i: integer;

  begin
    BufList := TStringList.Create;
    try
      BufList.Sorted := True;
      BufList.Duplicates := dupIgnore;
      BufList.Delimiter := ';';
      ExtStr  := Trim(string(GDALGetMetadataItem(Drv, 'DMD_EXTENSIONS', nil)));
      DrvName := Trim(string(GDALGetMetadataItem(Drv, 'DMD_LONGNAME', nil)));
      while Length(ExtStr) > 0 do begin
        i := Pos(' ', ExtStr);
        if i > 0 then begin
          StrItem := Format('*.%s', [Copy(ExtStr, 1, i - 1)]);
          Delete(ExtStr, 1, i);
        end
        else
        begin
          StrItem := Format('*.%s', [ExtStr]);
          ExtStr  := EmptyStr;
        end;
        BufList.Add(StrItem);

      end;
      if BufList.Count > 0 then begin
        AAllExt.AddStrings(BufList);
        AAllowed.AddObject(DrvName, BufList);
      end;
    except
      FreeAndNil(BufList);
    end;
  end;

begin
  with AllowedExtList do
    try
      AllExt := TStringList.Create;
      AllExt.Sorted := True;
      AllExt.Duplicates := dupIgnore;
      AllExt.Delimiter := ';';
      Sorted := True;
      Clear;
      for i := 0 to GDALGetDriverCount - 1 do begin
        Drv := GDALGetDriver(i);
        GetExtListByDriver(Drv, AllowedExtList, AllExt);
      end;
      Sorted := False;
      Insert(0, 'All map types');
      Objects[0] := AllExt;
    finally
      //Unlock
    end;
  Result := AllowedExtList;
end;

initialization
  AllowedExtList := TStringList.Create;
  OGRRegisterAll;

finalization
  FreeAndNil(AllowedExtList);
  OGRCleanupAll;


end.
