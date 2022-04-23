unit FAdd;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  MPatient, MIO;

type

  { TForm2 }

  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    patientList: TPatientList;
  public
    procedure AssignPatientList(patientListForm1: TPatientList);
  end;

var
  Form2: TForm2;

implementation

{$R *.lfm}

{ TForm2 }

procedure TForm2.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm2.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

end;

procedure TForm2.FormCreate(Sender: TObject);
begin
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
end;

procedure TForm2.Button1Click(Sender: TObject);
var
  bufferInput: string;
  patient: TPatient;
  outStream: TFileStream;
begin
  patient:=TPAtient.Create;
  patient.NIC:=Edit1.Text;
  if patient.ValidateNIC() then
  begin
    Label9.Caption:=patient.NIC;
    patientList.Add(patient.Clone);
    if patientList.Count <> 0 then
    begin
      Label9.Caption:='Writing patients to file...';
      try
        if not FileExists(MIO.filePath) then
        begin
          outStream:=TFileStream.Create(MIO.filePath, fmCreate);
        end
        else
        begin
          outStream:=TFileStream.Create(MIO.filepath, fmOpenWrite);
        end;
        MIO.PatientListToFileStream(patientList, outStream);
        outStream.Free;
      except
        on E: Exception do
          Label9.Caption:='Exception: '+E.ClassName+' '+E.Message;
      end;
    end
    else
    begin
      Label3.Caption:='List is empty';
    end;
  end
  else
  begin
    Label9.Caption:='Invalid NIC';
  end;
  patient.Free;
end;

{Form2.Custom}

procedure TForm2.AssignPatientList(patientListForm1: TPatientList);
begin
  patientList:=patientListForm1;
end;

initialization

finalization

end.

