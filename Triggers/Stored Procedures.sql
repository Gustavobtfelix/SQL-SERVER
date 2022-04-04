
CREATE PROCEDURE BuscaPorEntidades @ENTIDADE AS VARCHAR(10)
AS
BEGIN
IF @ENTIDADE = 'CLIENTES'
  SELECT [CPF] AS IDENTIFICADOR, [NOME] AS DESCRITOR, 
  [BAIRRO] AS BAIRRO FROM [TABELA DE CLIENTES]
ELSE IF @ENTIDADE = 'PRODUTOS'
  SELECT [CODIGO DO PRODUTO] AS IDENTIFICADOR, [NOME DO PRODUTO] AS DESCRITOR 
  FROM [TABELA DE PRODUTOS]
ELSE IF @ENTIDADE = 'VENDEDORES'
  SELECT [MATRICULA] AS IDENTIFICADOR, [NOME] AS DESCRITOR, 
  [BAIRRO] AS BAIRRO FROM [TABELA DE VENDEDORES]
END

EXEC BuscaPorEntidades @ENTIDADE = 'CLIENTES'
EXEC BuscaPorEntidades @ENTIDADE = 'VENDEDORES'
EXEC BuscaPorEntidades @ENTIDADE = 'PRODUTOS'

DROP PROCEDURE BuscaPorEntidades

CREATE PROCEDURE CalculaIdade
AS
BEGIN
	UPDATE [TABELA DE CLIENTES] SET IDADE = DATEDIFF(YEAR, [DATA DE NASCIMENTO], GETDATE())
END
EXEC CalculaIdade

SELECT * FROM [NOTAS FISCAIS] NF
INNER JOIN [ITENS NOTAS FISCAIS] INF ON 
    NF.NUMERO = INF.NUMERO
INNER JOIN [TABELA DE PRODUTOS] TP ON 
    TP.[CODIGO DO PRODUTO] = INF.[CODIGO DO PRODUTO]

--atualizando valor de imposto por mes, ano, e embalagem
CREATE PROCEDURE AtualizaImposto @MES AS INT, @ANO AS INT, 
    @EMBALAGEM AS VARCHAR(10), @IMPOSTO AS FLOAT
AS
UPDATE NF SET NF.IMPOSTO = @IMPOSTO FROM [NOTAS FISCAIS] NF
    INNER JOIN [ITENS NOTAS FISCAIS] INF 
        ON NF.NUMERO = INF.NUMERO
    INNER JOIN [TABELA DE PRODUTOS] TP 
        ON TP.[CODIGO DO PRODUTO] = INF.[CODIGO DO PRODUTO]
    WHERE MONTH(NF.DATA) = @MES AND YEAR(NF.DATA) = @ANO 
        AND TP.EMBALAGEM = @EMBALAGEM

EXEC AtualizaImposto @MES = 2, @ANO = 2017, @EMBALAGEM = *, @IMPOSTO = 0.16