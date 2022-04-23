unit FMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, FAdd,
  MPatient, MIO;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    patientList: TPatientList;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button6Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  inputStream: TFileStream;
begin
  if FileExists(MIO.filePath) then
  begin
    try
      try
        inputStream:=TFileStream.Create(filePath, fmOpenRead);
        patientList:=MIO.FileStreamToPatientList(inputStream);
      except
        on E: Exception do
          Label3.Caption:='Exception: '+E.ClassName;
      end;
    finally
      inputStream.Free;
    end;
      if patientList.Count=0 then
      begin
        Label3.Caption:='List is empty.';
      end;
  end
  else
  begin
    Label3.Caption:='File not found.';
    patientList:=TPatientList.Create;
    Label3.Caption:='Empty list in memory has been created.';
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  patientList.Free;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  fAdd1 : FAdd.Tform2;
begin
  fAdd1 := FAdd.TForm2.Create(Nil);
  fAdd1.AssignPatientList(patientList);
  fAdd1.ShowModal;
  FreeAndNil(fAdd1);
end;

initialization

finalization

end.

