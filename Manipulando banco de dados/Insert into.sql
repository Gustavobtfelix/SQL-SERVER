/*Inserindo novos dados
Tambem pode ser feito pelo Editar 200 Linhas Superiores
*/


SELECT * FROM [SUCOS_VENDAS].[DBO].[TABELA DE PRODUTOS]

INSERT INTO [PRODUTOS] ([C�DIGO], [DESCRITOR], [SABOR], [TAMANHO], [EMBALAGEM], [PRE�O LISTA])
SELECT [CODIGO DO PRODUTO] AS [C�DIGO], [NOME DO PRODUTO] AS [DESCRITOR], [SABOR]
, [TAMANHO], [EMBALAGEM], [PRE�O DE LISTA] AS [PRE�O LISTA]
 FROM [SUCOS_VENDAS].[DBO].[TABELA DE PRODUTOS] WHERE [CODIGO DO PRODUTO] <> '1040107'

 INSERT INTO CLIENTES (CPF, NOME, ENDERE�O, BAIRRO, CIDADE, ESTADO, CEP, [DATA NASCIMENTO], IDADE, SEXO, [LIMITE DE CR�DITO],
 [VOLUME DE COMPRA], [PRIMEIRA COMPRA])
 SELECT CPF, NOME, [ENDERECO 1] AS ENDERE�O, BAIRRO, CIDADE, ESTADO, CEP, [DATA DE NASCIMENTO], IDADE, SEXO, [LIMITE DE CREDITO],
 [VOLUME DE COMPRA], [PRIMEIRA COMPRA]
 FROM SUCOS_VENDAS.DBO.[TABELA DE CLIENTES] WHERE CPF NOT IN('1471156710', '19290992743', '2600586709')