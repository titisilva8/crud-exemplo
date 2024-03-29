unit Biblioteca;

interface

 uses System.SysUtils, Classes, System.MaskUtils,Vcl.StdCtrls,
 Vcl.DBCtrls,System.Math,Vcl.Forms;

 type
    TFormato = (CNPJ, CPF, InscricaoEstadual, CNPJorCPF, TelefoneFixo, Celular, Personalizado,
                Valor2,Valor4, Money, CEP, Dt, Peso);

procedure Formatar(Obj: TObject; Formato : TFormato; Extra : string = '');
function ValidaCPF(xCPF: String): Boolean;
function ArredondaTruncaValor(Operacao: String; Value: Extended; Casas: integer): Extended;
function CaminhoBD():String;

implementation

function CaminhoBD():String;
var tamanhoString:Integer;
begin
  Result := ExtractFilePath(Application.ExeName);
  tamanhoString:=Length(Result);
  Result:=Copy(Result,1,tamanhoString-4)+'data\'
end;


Function ArredondaTruncaValor(Operacao: String; Value: Extended; Casas: integer): Extended;
Var
  sValor: String;
  nPos: integer;
begin
  if Operacao = 'A' then
    Result := SimpleRoundTo(Value, Casas * -1)
  else
  begin
    // Transforma o valor em string
    sValor := FloatToStr(Value);

    // Verifica se possui ponto decimal
    nPos := Pos(FormatSettings.DecimalSeparator, sValor);
    If (nPos > 0) Then
    begin
      sValor := Copy(sValor, 1, nPos + Casas);
    End;

    Result := StrToFloat(sValor);
  end;
end;

{ Valida o CPF digitado }
function ValidaCPF(xCPF: String): Boolean;
Var
  d1, d4, xx, nCount, resto, digito1, digito2: integer;
  Check: String;
Begin
  d1 := 0;
  d4 := 0;
  xx := 1;
  for nCount := 1 to Length(xCPF) - 2 do
  begin
    if Pos(Copy(xCPF, nCount, 1), '/-.') = 0 then
    begin
      d1 := d1 + (11 - xx) * StrToInt(Copy(xCPF, nCount, 1));
      d4 := d4 + (12 - xx) * StrToInt(Copy(xCPF, nCount, 1));
      xx := xx + 1;
    end;
  end;
  resto := (d1 mod 11);
  if resto < 2 then
  begin
    digito1 := 0;
  end
  else
  begin
    digito1 := 11 - resto;
  end;
  d4 := d4 + 2 * digito1;
  resto := (d4 mod 11);
  if resto < 2 then
  begin
    digito2 := 0;
  end
  else
  begin
    digito2 := 11 - resto;
  end;
  Check := IntToStr(digito1) + IntToStr(digito2);

  if Check <> Copy(xCPF, succ(Length(xCPF) - 2), 2) then
  begin
    Result := False;
  end
  else
  begin
    Result := True;
  end;
end;

function SomenteNumero(str : string) : string;
var
    x : integer;
begin
    Result := '';
    for x := 0 to Length(str) - 1 do
        if (str.Chars[x] In ['0'..'9']) then
            Result := Result + str.Chars[x];
end;

function FormataValor2(str : string) : string;
var valor:string;
begin
    if Str = '' then
        Str := '0';

    try
        Result := FormatFloat('0.00', strtofloat(str) / 100);
        valor:=Result;
    except
        Result := FormatFloat('0.00', 0);
    end;
end;

function FormataValor4(str : string) : string;
begin
    if Str = '' then
        Str := '0';

     try
        Result := FormatFloat('0.0000', strtofloat(str) / 10000);
    except
        Result := FormatFloat('0.0000', 0);
    end;
end;

function FormataPeso(str : string) : string;
begin
    if Str.IsEmpty then
        Str := '0';

    try
        Result := FormatFloat('#,##0.000', strtofloat(str) / 1000);
    except
        Result := FormatFloat('#,##0.000', 0);
    end;
end;

function Mask(Mascara, Str : string) : string;
var
    x, p : integer;
begin
    p := 0;
    Result := '';

    if Str.IsEmpty then
        exit;

    for x := 0 to Length(Mascara) - 1 do
    begin
        if Mascara.Chars[x] = '#' then
        begin
            Result := Result + Str.Chars[p];
            inc(p);
        end
        else
            Result := Result + Mascara.Chars[x];

        if p = Length(Str) then
            break;
    end;
end;

function FormataIE(Num, UF: string): string;
var
    Mascara : string;
begin
    Mascara := '';
    IF UF = 'AC' Then Mascara := '##.###.###/###-##';
    IF UF = 'AL' Then Mascara := '#########';
    IF UF = 'AP' Then Mascara := '#########';
    IF UF = 'AM' Then Mascara := '##.###.###-#';
    IF UF = 'BA' Then Mascara := '######-##';
    IF UF = 'CE' Then Mascara := '########-#';
    IF UF = 'DF' Then Mascara := '###########-##';
    IF UF = 'ES' Then Mascara := '#########';
    IF UF = 'GO' Then Mascara := '##.###.###-#';
    IF UF = 'MA' Then Mascara := '#########';
    IF UF = 'MT' Then Mascara := '##########-#';
    IF UF = 'MS' Then Mascara := '#########';
    IF UF = 'MG' Then Mascara := '###.###.###/####';
    IF UF = 'PA' Then Mascara := '##-######-#';
    IF UF = 'PB' Then Mascara := '########-#';
    IF UF = 'PR' Then Mascara := '########-##';
    IF UF = 'PE' Then Mascara := '##.#.###.#######-#';
    IF UF = 'PI' Then Mascara := '#########';
    IF UF = 'RJ' Then Mascara := '##.###.##-#';
    IF UF = 'RN' Then Mascara := '##.###.###-#';
    IF UF = 'RS' Then Mascara := '###/#######';
    IF UF = 'RO' Then Mascara := '###.#####-#';
    IF UF = 'RR' Then Mascara := '########-#';
    IF UF = 'SC' Then Mascara := '###.###.###';
    IF UF = 'SP' Then Mascara := '###.###.###.###';
    IF UF = 'SE' Then Mascara := '#########-#';
    IF UF = 'TO' Then Mascara := '###########';

    Result := Mask(mascara, Num);
end;

function FormataData(str : string): string;
begin
    str := Copy(str, 1, 8);

    if Length(str) < 8 then
        Result := Mask('##/##/####', str)
    else
    begin
        try
            str := Mask('##/##/####', str);
            strtodate(str);
            Result := str;
        except
            Result := '';
        end;
    end;
end;

procedure Formatar(Obj: TObject; Formato : TFormato; Extra : string = '');
var
    texto : string;
begin
    TThread.Queue(Nil, procedure
    begin
        if (obj is TEdit) or (obj is TDBEdit) then
            texto := TEdit(obj).Text;

        // Telefone Fixo...
        if formato = TelefoneFixo then
            texto := Mask('(##) ####-####', SomenteNumero(texto));

        // Celular...
        if formato = Celular then
            texto := Mask('(##) #####-####', SomenteNumero(texto));

        // CNPJ...
        if formato = CNPJ then
            texto := Mask('##.###.###/####-##', SomenteNumero(texto));

        // CPF...
        if formato = CPF then
            texto := Mask('###.###.###-##', SomenteNumero(texto));

        // Inscricao Estadual (IE)...
        if formato = InscricaoEstadual then
            texto := FormataIE(SomenteNumero(texto), Extra);

        // CNPJ ou CPF...
        if formato = CNPJorCPF then
            if Length(SomenteNumero(texto)) <= 11 then
                texto := Mask('###.###.###-##', SomenteNumero(texto))
            else
                texto := Mask('##.###.###/####-##', SomenteNumero(texto));

        // Personalizado...
        if formato = Personalizado then
            texto := Mask(Extra, SomenteNumero(texto));

        // Valor...
        if Formato = Valor2 then
            texto := FormataValor2(SomenteNumero(texto));

         // Valor...
        if Formato = Valor4 then
            texto := FormataValor4(SomenteNumero(texto));

        // Money (com simbolo da moeda)...
        if Formato = Money then
        begin
            if Extra = '' then
                Extra := 'R$';

            texto := Extra + ' ' + FormataValor2(SomenteNumero(texto));
        end;

        // CEP...
        if Formato = CEP then
            texto := Mask('##.###-###', SomenteNumero(texto));

        // Data...
        if formato = Dt then
            texto := FormataData(SomenteNumero(texto));

        // Peso...
        if Formato = Peso then
            texto := FormataPeso(SomenteNumero(texto));


        if obj is TEdit then
        begin
            TEdit(obj).Text := texto;
            TEdit(obj).SelStart := high(TEdit(obj).Text);
        end;

        if obj is TDBEdit then
        begin
            TDBEdit(obj).Text := texto;
            TDBEdit(obj).SelStart := high(TEdit(obj).Text);
        end;

    end);

end;

end.
