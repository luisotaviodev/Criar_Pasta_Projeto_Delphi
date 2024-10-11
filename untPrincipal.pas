unit untPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, JvExStdCtrls, JvMemo;

type
  TfrmCriarPastaProjeto = class(TForm)
    edtNumeroProjeto: TEdit;
    mmoNomeProjeto: TJvMemo;
    lblNumeroProjeto: TLabel;
    lblNomeProjeto: TLabel;
    btnCriarPasta: TButton;
    edtDiretorio: TEdit;
    lblDiretorio: TLabel;
    lblDesenvolvedor: TLabel;
    procedure FormShow(Sender: TObject);
    procedure edtDiretorioKeyPress(Sender: TObject; var Key: Char);
    procedure edtNumeroProjetoKeyPress(Sender: TObject; var Key: Char);
    procedure mmoNomeProjetoKeyPress(Sender: TObject; var Key: Char);
    procedure mmoNomeProjetoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCriarPastaClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    plQuebraLinha: Boolean;
    pcProjeto: String;
    function CriarPastaPrincipal: String;
    function CriarSubPasta(cCaminhoPastaPrincipal, cNomeSubPasta: String): String;
    procedure CriarArquivoTxT(cCaminho, cNomeArquivoTxT: String);
    procedure LimparCampos;
    procedure CriarPasta;
    procedure Validar(lCondicao: Boolean; cMensagem: String; oComponente: TWinControl);
    { Private declarations }

  public
    { Public declarations }
  end;

var
  frmCriarPastaProjeto: TfrmCriarPastaProjeto;

implementation

{$R *.dfm}

{ TfrmCriarPastaProjeto }

function TfrmCriarPastaProjeto.CriarPastaPrincipal: String;
var
  cNomePasta: String;
begin
  pcProjeto  := Format('Projeto #%s - ', [edtNumeroProjeto.Text]);
  cNomePasta := ExtractFilePath(ParamStr(0)) + Format('Projeto #%s - ', [edtNumeroProjeto.Text]) + UpperCase(mmoNomeProjeto.Text);

  if(not(DirectoryExists(cNomePasta)))then
  begin
    CreateDir(cNomePasta);
    ShowMessage('Pasta Criada com Sucesso.');
    Result := cNomePasta;
  end
  else
  begin
    ShowMessage('Est� Pasta j� Existe.');
    Result := '';
    Abort;
  end;

  LimparCampos;
end;

procedure TfrmCriarPastaProjeto.LimparCampos;
begin
  edtNumeroProjeto.Text := '';
  mmoNomeProjeto.Text   := '';
  edtNumeroProjeto.SetFocus;
end;

procedure TfrmCriarPastaProjeto.mmoNomeProjetoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  plQuebraLinha := ((Key = VK_RETURN)and(ssShift in Shift));
end;

procedure TfrmCriarPastaProjeto.mmoNomeProjetoKeyPress(Sender: TObject; var Key: Char);
begin
  if((Key = #13)and(not(plQuebraLinha)))then
    SelectNext(ActiveControl as TWinControl,True,True);
end;

function TfrmCriarPastaProjeto.CriarSubPasta(cCaminhoPastaPrincipal, cNomeSubPasta: String): String;
var
  cCaminho: String;
begin
  cCaminho := cCaminhoPastaPrincipal + '\' + cNomeSubPasta;
  CreateDir(cCaminho);

  Result := cCaminho;
end;

procedure TfrmCriarPastaProjeto.edtDiretorioKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    SelectNext(ActiveControl as TWinControl,True,True);
end;

procedure TfrmCriarPastaProjeto.edtNumeroProjetoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    SelectNext(ActiveControl as TWinControl,True,True);

  if(not(key in ['0'..'9', #8]))then
    key := #0;
end;

procedure TfrmCriarPastaProjeto.CriarPasta;
var
  cCaminhoPastaPrincipal, cCaminhoSubPasta: String;
begin
  cCaminhoPastaPrincipal := CriarPastaPrincipal;

  cCaminhoSubPasta := CriarSubPasta(cCaminhoPastaPrincipal, 'Docs');
  CriarSubPasta(cCaminhoSubPasta, 'Prints');
  CriarArquivoTxT(cCaminhoSubPasta, 'Link do Docs');

  CriarSubPasta(cCaminhoPastaPrincipal, 'Imagens Adicionadas No Projeto');

  cCaminhoSubPasta := CriarSubPasta(cCaminhoPastaPrincipal, 'Referencias');
  CriarSubPasta(cCaminhoSubPasta, 'Prints');
  CriarSubPasta(cCaminhoSubPasta, 'Tabelas');

  CriarSubPasta(cCaminhoPastaPrincipal, 'Scripts SQL');

  cCaminhoSubPasta := CriarSubPasta(cCaminhoPastaPrincipal, 'Textos Form DEV');
  CriarSubPasta(cCaminhoSubPasta, pcProjeto + 'Form DEV');

  cCaminhoSubPasta := CriarSubPasta(cCaminhoPastaPrincipal, 'Textos Form HOM');
  CriarSubPasta(cCaminhoSubPasta, pcProjeto + 'Form HOM');
end;

procedure TfrmCriarPastaProjeto.Validar(lCondicao: Boolean; cMensagem: String; oComponente: TWinControl);
begin
  if(lCondicao)then
  begin
    ShowMessage(cMensagem);
    oComponente.SetFocus;
    Abort;
  end;
end;

procedure TfrmCriarPastaProjeto.btnCriarPastaClick(Sender: TObject);
begin
  Validar(Trim(edtNumeroProjeto.Text) = '', '� necess�rio preencher o N�mero do Projeto.', edtNumeroProjeto);
  Validar(Trim(mmoNomeProjeto.Text) = '', '� necess�rio preencher o Nome do Projeto.', mmoNomeProjeto);

  CriarPasta
end;

procedure TfrmCriarPastaProjeto.CriarArquivoTxT(cCaminho, cNomeArquivoTxT: String);
var
  txtArquivo: TextFile;
begin
  AssignFile(txtArquivo, cCaminho + '\' + cNomeArquivoTxT + '.txt');
  Rewrite(txtArquivo);

  Writeln(txtArquivo, '');
  CloseFile(txtArquivo);
end;

procedure TfrmCriarPastaProjeto.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if(Key = #27)then
    Close;
end;

procedure TfrmCriarPastaProjeto.FormShow(Sender: TObject);
begin
  LimparCampos;
  edtDiretorio.Text := ExtractFilePath(ParamStr(0));
end;

end.