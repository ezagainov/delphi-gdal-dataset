unit GDALMajorObjectUnit;

interface

uses GDALBaseHandleObjectUnit;

type

  IGDALMajorObject = interface(IGDALBaseHandleObject)
  end;
  GDALMajorObject = class(GDALBaseHandleObject, IGDALMajorObject);
  TGDALObjectNotifyEvent = procedure (Sender: GDALMajorObject) of object;
implementation

end.
