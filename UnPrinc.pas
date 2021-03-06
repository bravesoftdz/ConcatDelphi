unit UnPrinc;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Clipbrd, XPMan, ExtCtrls, StrUtils;

type
  TForm1 = class(TForm)
    mmoQuery: TMemo;
    mmoResult: TMemo;
    lbl2: TLabel;
    lbl3: TLabel;
    rgTipos: TRadioGroup;
    grp1: TGroupBox;
    lbl1: TLabel;
    btn1: TButton;
    edtQuery: TEdit;
    chkProcedure: TCheckBox;
    chkFunction: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure rgTiposClick(Sender: TObject);
    procedure chkProcedureClick(Sender: TObject);
  private
    { Private declarations }
    procedure HabilitaCheks(Ativa: Boolean);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  mmoQuery.Lines.Clear;
  mmoResult.Lines.Clear;
  rgTiposClick(Sender);
end;

procedure TForm1.btn1Click(Sender: TObject);
var
  I: Integer;
  Nome: string;
  ListaParam: TStringList;
begin
  if mmoQuery.Lines.Count < 1 then
  begin
    Application.MessageBox('Digite a query neh...Ou at� isso vou ter quer fazer?', 'Falo nada...', MB_ICONWARNING);
    Exit;
  end
  else
  begin
    mmoResult.Clear;
    case rgTipos.ItemIndex of
      0:
        begin
          for I := 0 to mmoQuery.Lines.Count - 1 do
          begin
            if Trim(mmoQuery.Lines.Strings[I]) <> '' then
            begin
              case (Trim(edtQuery.Text) = '') of
                True:
                  mmoResult.Lines.Add('SQL.Add(''' + StringReplace(mmoQuery.Lines.Strings[I], '''', '''''', [rfReplaceAll, rfIgnoreCase]) + ''');');
                False:
                  mmoResult.Lines.Add(Trim(edtQuery.Text) + '.SQL.Add(''' + StringReplace(mmoQuery.Lines.Strings[I], '''', '''''', [rfReplaceAll, rfIgnoreCase]) + ''');');
              end;
            end;
          end;
          for I := 0 to mmoQuery.Lines.Count - 1 do
          begin
            if Trim(mmoQuery.Lines.Strings[I]) <> '' then
            begin
              ListaParam := TStringList.Create;
            end;
          end;
        end;
      1:
        begin
          if Trim(edtQuery.Text) = EmptyStr then
          begin
            Application.MessageBox('Digite o nome do banco do DataBase neh!?', 'Falo nada...', MB_ICONWARNING);
          end;
          for I := 0 to mmoQuery.Lines.Count - 1 do
          begin
            if Trim(mmoQuery.Lines.Strings[I]) <> '' then
            begin
              if I = 0 then
              begin
                Nome := StringReplace((StringReplace(mmoQuery.Lines.Strings[I], ('CREATE TABLE ' + Trim(edtQuery.Text) + '.dbo.'), '', [rfReplaceAll, rfIgnoreCase])), '(', '', [rfReplaceAll, rfIgnoreCase]);
                mmoResult.Lines.Add('SET NOCOUNT ON');
                mmoResult.Lines.Add('');
                mmoResult.Lines.Add('IF NOT EXISTS(');
                mmoResult.Lines.Add('SELECT 1 FROM ' + UpperCase(Trim(edtQuery.Text)) + '.SYS.TABLES WHERE NAME = ' + QuotedStr(Trim(Nome)) + ')');
                mmoResult.Lines.Add('BEGIN');
                mmoResult.Lines.Add('        EXEC(''');
                mmoResult.Lines.Add(mmoQuery.Lines.Strings[I]);
              end
              else
              begin
                mmoResult.Lines.Add(mmoQuery.Lines.Strings[I]);
              end;
            end;
          end;
          mmoResult.Lines.Add('       '' )');
          mmoResult.Lines.Add('        PRINT ''Criada tabela ' + UpperCase(Trim(edtQuery.Text)) + '.dbo.' + Trim(Nome) + '''');
          mmoResult.Lines.Add('END ELSE');
          mmoResult.Lines.Add('BEGIN');
          mmoResult.Lines.Add('  PRINT ''Ja Existe a tabela ' + UpperCase(Trim(edtQuery.Text)) + '.dbo.' + Trim(Nome) + '''');
          mmoResult.Lines.Add('END');
        end;
    end;
  end;
  Clipboard.AsText := mmoResult.Text;
end;

procedure TForm1.rgTiposClick(Sender: TObject);
begin
  case rgTipos.ItemIndex of
    0:
      begin
        lbl1.Caption := 'Nome do TQuery:';
        edtQuery.Width := 853;
        edtQuery.Left := 100;
        HabilitaCheks(False);
      end;
    1:
      begin
        lbl1.Caption := 'Nome do DataBase:';
        edtQuery.Width := 841;
        edtQuery.Left := 112;
        HabilitaCheks(False);
      end;
    2:
      begin
        lbl1.Caption := 'Nome do DataBase:';
        edtQuery.Width := 841;
        edtQuery.Left := 108;
        HabilitaCheks(True);
      end;
    3:
      begin
        lbl1.Caption := 'Nome do DataBase:';
        edtQuery.Width := 100;
        HabilitaCheks(False);
      end;
  end;
end;

procedure TForm1.HabilitaCheks(Ativa: Boolean);
begin
  chkProcedure.Visible := Ativa;
  chkProcedure.Checked := False;
  chkFunction.Visible := Ativa;
  chkFunction.Checked := False;
end;

procedure TForm1.chkProcedureClick(Sender: TObject);
begin
  {if TCheckBox(Sender).Name = 'chkProcedure' then
  begin
    chkProcedure.Checked := True;
    chkFunction.Checked := False;
  end
  else if TCheckBox(Sender).Name = 'chkFunction' then
  begin
    chkFunction.Checked := True;  
    chkProcedure.Checked := False;
  end;}

 { case AnsiIndexStr(TCheckBox(Sender).Name, ['chkProcedure', 'chkFunction']) of
    0:
      begin
        chkFunction.Checked := False;
        chkProcedure.Checked := True;
      end;
    1:
      begin
        chkProcedure.Checked := False;
        chkFunction.Checked := True;
      end;

  end; }

end;

end.


