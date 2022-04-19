unit MIO;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,
  streamex,
  MPatient;

const
  filePath='patientDB.tsv';

function FileStreamToPatientList(inputStream: TFileStream): TPatientList;

//procedure PatientListToTSVFile(patientList: TPatientList; filePath: string);

procedure PatientListToFileStream(patientList: TPatientList; outStream: TFileStream);

implementation

const
  columnSeparator = #9;
  rowSeparator = LineEnding;

//function TSVFileToPatientList(filePath: string): TPatientList;
//var
//  //inFileStream: TFileStream;
//  rowList: TStringList;
//  columnList: TStringArray;
//  patient: TPatient;
//  i: integer;
//begin
//  result:=TPatientList.Create;
//  patient:=TPatient.Create;
//  //inFileStream:=TFileStream.Create(pathToPatientDB, fmOpenRead);
//  rowList:=TStringList.Create;
//  columnList:=TStringArray.Create;
//  rowList.LoadFromFile(filePath);
//  i:=0;
//  while i < rowList.Count do
//  begin
//    columnList:=rowList[i].Split(columnSeparator);
//    patient.NIC:=columnList[0];
//    result.Add(patient.Clone);
//    inc(i);
//  end;
//  patient.Free;
//  rowList.Free;
//end;

procedure PatientListToFileStream(patientList: TPatientList; outStream: TFileStream);
var
  row: string='';
  rowList: TStringList;
  columnList: TStringArray;
  patient: TPatient;
  i: integer;
  j: integer;
begin
  rowList:=TStringList.Create;
  columnList:=TStringArray.Create;
  SetLength(columnList, 1);
  i:=0;
  while i<patientList.Count do
  begin
    patient:=patientList[i].Clone;
    columnList[0]:=patient.NIC;
    for j:=Low(columnList) to High(columnList)-1 do
    begin
      row:=row+columnList[j]+MIO.columnSeparator;
    end;
    row:=row+columnList[High(columnList)]+MIO.rowSeparator;
    rowList.Add(row);
    row:='';
    inc(i);
    patient.Free;
  end;
  i:=0;
  outStream.Position:=0;
  while i<rowList.Count do
  begin
    outStream.Write(pointer(rowList[i])^,length(rowList[i]));
    inc(i);
  end;
  rowList.Free;
end;

function FileStreamToPatientList(inputStream: TFileStream): TPatientList;
var
  lineReader: TStreamReader;
  line: string;
  splitedLine: TStringArray;
  patient: MPatient.TPatient;
  patientList: MPatient.TPatientList;
begin
  lineReader:=TStreamReader.Create(inputStream);
  patient:=MPatient.TPatient.Create;
  patientList:=MPatient.TPatientList.Create;
  while not lineReader.Eof do
  begin
    lineReader.ReadLine(line);
    splitedLine:=line.Split(MIO.columnSeparator);
    patient.NIC:=splitedLine[0];
    if not patient.ValidateNIC then
    begin
      patient.Free;
      lineReader.Free;
      raise Exception.Create('Invalid NIC');
    end;
    patientList.Add(patient.Clone());
  end;
  result:=patientList;
  patient.Free;
  lineReader.Free;
end;

end.

