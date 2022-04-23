unit mpatient;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fgl;

const
  C_NIC_MIN = 1;
  C_NIC_MAX = 99999999;

type

  TPatient = class
    public
      NIC: string;
      function ValidateNIC: boolean;
      function Clone(): TPatient;
  end;

  TPatientList = specialize TFPGObjectList<TPatient>;

implementation

function TPatient.ValidateNIC: boolean;
var
  valueAsInteger: integer;
begin
  result:=true;
  if TryStrToInt(NIC, valueAsInteger) then
  begin
    if valueAsInteger < C_NIC_MIN then
    begin
      result:=false;
    end
    else
    if valueAsInteger > C_NIC_MAX then
    begin
      result:=false;
    end;
  end
  else
  begin
    result:=false;
  end;
end;

function TPatient.Clone(): TPatient;
begin
  result:=TPatient.Create;
  result.Create;
  result.NIC:=self.NIC;
end;

end.

