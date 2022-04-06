﻿--Criando Function para gerar numeros aleatorios



--- VALOR MINIMO SEJA 100
--- VALOR MAXIMO SEJA 500
-- ROUND NAO PODE SER CHAMADO DENTRO DE UMA FUNCAO
SELECT ROUND(((500 - 100 - 1) * RAND() + 100), 0)
--CRIANDO VIEW COM O VALOR DE ROUND
CREATE VIEW VW_ALEATORIO AS SELECT RAND() AS VALUE
--GERA VALOR ALEATORIO
SELECT * FROM VW_ALEATORIO
--OR ALTER
CREATE FUNCTION NumeroAleatorio(@VAL_INIC INT, @VAL_FINAL INT) RETURNS INT
AS
BEGIN
DECLARE @ALEATORIO INT
DECLARE @ALEATORIO_FLOAT FLOAT
--CRIA VARIAVEL PARA RECEBER VALOR DA VIEW ALEATORIO
SELECT @ALEATORIO_FLOAT = VALUE FROM VW_ALEATORIO
SET @ALEATORIO = ROUND(((@VAL_FINAL - @VAL_INIC) * @ALEATORIO_FLOAT + @VAL_INIC), 0)
RETURN @ALEATORIO
END
-- GERA UM NUMERO ALEATORIO ENTRE X E Y
SELECT [dbo].[NumeroAleatorio](0,1000)
--		//				//				//				//				//			
-- Inserindo valores aleatorios em uma tabela com primary key
DECLARE @TABELA TABLE (NUMERO INT UNIQUE)
DECLARE @CONTADOR INT
DECLARE @CONTMAXIMO INT
SET @CONTADOR = 1
SET @CONTMAXIMO = 100
WHILE @CONTADOR <= @CONTMAXIMO
BEGIN
	BEGIN TRY
		INSERT INTO @TABELA (NUMERO) VALUES 
			([dbo].[NumeroAleatorio](0,1000))
		SET @CONTADOR += 1
	END TRY
	BEGIN CATCH
	PRINT('ERRO')
	END CATCH
END
SELECT * FROM @TABELA ORDER BY 1

--		//				//				//				//				//		

-- Pegando CLIENTE ALEATORIO

DECLARE @CLIENTE_ALEATORIO VARCHAR(12) --12 CARACTERES
DECLARE @VAL_INICIAL INT
DECLARE @VAL_FINAL INT
DECLARE @ALEATORIO INT
DECLARE @CONTADOR INT

SET @CONTADOR = 1
SET @VAL_INICIAL = 1
SELECT @VAL_FINAL = COUNT(*) FROM [TABELA DE CLIENTES]
SET @ALEATORIO = [dbo].[NumeroAleatorio](@VAL_INICIAL, @VAL_FINAL)
DECLARE CURSOR1 CURSOR FOR SELECT CPF FROM [TABELA DE CLIENTES]
OPEN CURSOR1
FETCH NEXT FROM CURSOR1 INTO @CLIENTE_ALEATORIO
WHILE @CONTADOR < @ALEATORIO
BEGIN
   FETCH NEXT FROM CURSOR1 INTO @CLIENTE_ALEATORIO
   SET @CONTADOR = @CONTADOR + 1
END
CLOSE CURSOR1
DEALLOCATE CURSOR1
SELECT @CLIENTE_ALEATORIO

--		//				//				//				//				//			
--CRIANDO FUNÇÃO COM OPÇÃO DE BUSCA DE VALOR ALEATORIO
CREATE FUNCTION EntidadeAleatoria (@TIPO VARCHAR(12)) RETURNS VARCHAR(20)
AS
BEGIN
DECLARE @ENTIDADE_ALEATORIO VARCHAR(12)
DECLARE @TABELA TABLE (CODIGO VARCHAR(20))
DECLARE @VAL_INICIAL INT
DECLARE @VAL_FINAL INT
DECLARE @ALEATORIO INT
DECLARE @CONTADOR INT

IF @TIPO = 'CLIENTE'
BEGIN
   INSERT INTO @TABELA (CODIGO) SELECT CPF AS CODIGO FROM [TABELA DE CLIENTES]
END
IF @TIPO = 'VENDEDOR'
BEGIN
   INSERT INTO @TABELA (CODIGO) SELECT MATRICULA FROM [TABELA DE VENDEDORES]
END
IF @TIPO = 'PRODUTO'
BEGIN
   INSERT INTO @TABELA (CODIGO) SELECT [CODIGO DO PRODUTO] FROM [TABELA DE PRODUTOS]
END

SET @CONTADOR = 1
SET @VAL_INICIAL = 1
SELECT @VAL_FINAL = COUNT(*) FROM @TABELA
SET @ALEATORIO = [dbo].[NumeroAleatorio](@VAL_INICIAL, @VAL_FINAL)
DECLARE CURSOR1 CURSOR FOR SELECT CODIGO FROM @TABELA
OPEN CURSOR1
FETCH NEXT FROM CURSOR1 INTO @ENTIDADE_ALEATORIO
WHILE @CONTADOR < @ALEATORIO
BEGIN
   FETCH NEXT FROM CURSOR1 INTO @ENTIDADE_ALEATORIO
   SET @CONTADOR = @CONTADOR + 1
END
CLOSE CURSOR1
DEALLOCATE CURSOR1
RETURN @ENTIDADE_ALEATORIO
END



SELECT [dbo].[EntidadeAleatoria]('CLIENTE')AS CPF, [dbo].[EntidadeAleatoria]('PRODUTO') AS [CODIGO DO PRODUTO],
[dbo].[EntidadeAleatoria]('VENDEDOR') AS MATRICULA

--		//				//				//				//				//		
--CRIA NOTA FISCAL ALEATORIA E ADICIONA NA TABELA NOTAS FISCAIS
CREATE PROCEDURE CriaNotaFiscal 
@DATA AS DATE
AS
BEGIN

DECLARE @CLIENTE VARCHAR(12)
DECLARE @VENDEDOR VARCHAR(12)
DECLARE @PRODUTO VARCHAR(12)
DECLARE @NUMERO INT
DECLARE @IMPOSTO FLOAT
DECLARE @NUM_ITENS INT
DECLARE @CONTADOR INT
DECLARE @QUANTIDADE INT
DECLARE @PRECO FLOAT
DECLARE @LISTAPRODUTOS TABLE (PRODUTO VARCHAR(20))
DECLARE @AUXPRODUTO INT

SET @DATA = '20180521'
SET @CLIENTE = [dbo].[EntidadeAleatoria]('CLIENTE')
SET @VENDEDOR = [dbo].[EntidadeAleatoria]('VENDEDOR')
SELECT @NUMERO = MAX(NUMERO) + 1 FROM [NOTAS FISCAIS]
SET @IMPOSTO = 0.18
SET @CONTADOR = 1
SET @NUM_ITENS = [dbo].[NumeroAleatorio](2, 10)

INSERT INTO [NOTAS FISCAIS] (CPF, MATRICULA, DATA, NUMERO, IMPOSTO)
VALUES (@CLIENTE, @VENDEDOR, @DATA, @NUMERO, @IMPOSTO)

WHILE @CONTADOR <= @NUM_ITENS
BEGIN
	SET @PRODUTO = [dbo].[EntidadeAleatoria]('PRODUTO')
	SELECT @AUXPRODUTO = COUNT(*) FROM @LISTAPRODUTOS WHERE PRODUTO = @PRODUTO 
	IF @AUXPRODUTO = 0
	BEGIN
	   SET @QUANTIDADE = [dbo].[NumeroAleatorio](5, 100)
	   SELECT @PRECO = [PREÇO DE LISTA] FROM [TABELA DE PRODUTOS] WHERE [CODIGO DO PRODUTO] = @PRODUTO
	   INSERT INTO [ITENS NOTAS FISCAIS] (NUMERO, [CODIGO DO PRODUTO], QUANTIDADE, PREÇO)
	   VALUES (@NUMERO, @PRODUTO, @QUANTIDADE, @PRECO)
	   SET @CONTADOR = @CONTADOR + 1
	END
	INSERT INTO @LISTAPRODUTOS (PRODUTO) VALUES (@PRODUTO)
END 
END;

EXEC [dbo].[CriaNotaFiscal] '20180521'
