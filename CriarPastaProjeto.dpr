program CriarPastaProjeto;

uses
  Vcl.Forms,
  untPrincipal in 'untPrincipal.pas' {frmCriarPastaProjeto};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmCriarPastaProjeto, frmCriarPastaProjeto);
  Application.Run;
end.
