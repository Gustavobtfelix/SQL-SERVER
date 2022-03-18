﻿/*	FUNÇÕES STRING	*/


SELECT LTRIM('      OLA')

SELECT RTRIM('OLA      ')

SELECT TRIM('      OLA		')

SELECT CONCAT('OLA ','TUDO BEM')

SELECT 'OLA ' + 'TUDO BEM'

SELECT LEFT('RUA AUGUSTA',3) 

SELECT RIGHT('RUA AUGUSTA',7) 

SELECT UPPER('rua augusta')   

SELECT LOWER('RUA AUGUSTA')   

SELECT REPLACE('R. AUGUSTA','R.','RUA') 

SELECT SUBSTRING('RUA AUGUSTA', 1, 3) 

SELECT SUBSTRING('RUA AUGUSTA', 5, 12) 

SELECT LEN('RUA AUGUSTA')  

SELECT * FROM [TABELA DE CLIENTES]

SELECT CONCAT(NOME, ' (', CPF, ') ') AS 'NOME E CPF' FROM [TABELA DE CLIENTES]

SELECT NOME, CONCAT(ESTADO,' ', CIDADE,' ', BAIRRO,' ', [ENDERECO 1] ) AS ENDERECO
FROM [TABELA DE CLIENTES] 

/*			-/-			-/-			-/-			-/-			-/-			-/-			-/-
	FUNÇÕES DATA	*/


SELECT SYSDATETIME()

SELECT SYSDATETIMEOFFSET()
--England time
SELECT SYSUTCDATETIME()

SELECT CURRENT_TIMESTAMP

SELECT GETDATE()

SELECT GETUTCDATE()
-- RETORNA EM STRING
SELECT DATENAME(YEAR,GETDATE())

SELECT DATENAME(MONTH,GETDATE())

SELECT DATENAME(DAY,GETDATE())

SELECT DATENAME(MICROSECOND,GETDATE())

SELECT DATENAME(MINUTE,GETDATE())
-- RETORNA EM INT
SELECT DATEPART(MONTH,GETDATE())

SELECT DAY(GETDATE())

SELECT YEAR(GETDATE())

SELECT DATEFROMPARTS(2015,9,1)

SELECT DATENAME(MONTH,DATEFROMPARTS(2015,9,1))

SELECT DATETIME2FROMPARTS(2015,9,1,13,12,11,120,4)

SELECT DATEDIFF(YEAR, DATEFROMPARTS(2015,9,1), GETDATE())

SELECT DATEADD(MONTH, 5, GETDATE())
--VERDADEIRO
SELECT ISDATE('2018-01-01')
--FALSO
SELECT ISDATE('2018-25-28')

SELECT * FROM [NOTAS FISCAIS]
			   --JUNTA(NOME    ANO						   MES							 DIA)
SELECT [DATA], CONCAT(DATENAME(YEAR, [DATA]), ' ',DATENAME(MONTH, [DATA]), ' ', DATENAME(DAY, [DATA]))
FROM [NOTAS FISCAIS]

SELECT * FROM [TABELA DE CLIENTES]
					--PEGA A IDADE ATUAL
SELECT NOME, DATEDIFF(YEAR, [DATA DE NASCIMENTO], GETDATE()) AS IDADE, CONCAT(YEAR(GETDATE()),'-',MONTH([DATA DE NASCIMENTO]),'-',DAY([DATA DE NASCIMENTO])) AS ANIVERSARIO FROM [TABELA DE CLIENTES]

/*			-/-			-/-			-/-			-/-			-/-			-/-			-/-
	FUNÇÕES MATEMATICAS	*/

		--arredonda para cima
SELECT CEILING(12.333223)
		--arredonda para baixo
SELECT FLOOR(12.333223)
		--randomico, se colocar um valor dentro o numero será fixo
SELECT RAND()

-- arredonda por posição
SELECT ROUND(12.73323323, 0)

SELECT * FROM [ITENS NOTAS FISCAIS]

SELECT * FROM [NOTAS FISCAIS]

--MULTIPLICA A QUANTIDADE DE ITENS PELO PRECO GERANDO O CAMPO TOTAL
SELECT [ITENS NOTAS FISCAIS].[QUANTIDADE], [ITENS NOTAS FISCAIS].[PREÇO], ROUND(([QUANTIDADE] * [PREÇO]),2) AS TOTAL FROM [ITENS NOTAS FISCAIS]

--SUBQUERY
--PEGA O ANO EM NOTAS FISCAIS E CALCULA O IMPOSTO TOTAL PARA CADA ANO
SELECT YEAR(DATA) AS DATA, FLOOR(SUM(IMPOSTO * QUANTIDADE)) AS TOTAL_IMPOSTO
FROM [NOTAS FISCAIS] NF
INNER JOIN [ITENS NOTAS FISCAIS] INF ON NF.NUMERO = INF.NUMERO
GROUP BY YEAR(DATA) ORDER BY DATA

--SUBQUERY
        --MULTIPLICA  QUANTIDADE DE ITENS PELO LUCRO         //              ,NOTAS FISCAIS * ITENS NOTAS FISCAIS
SELECT YEAR(DATA) AS 'ANO',COUNT(*) AS 'Q. VENDAS', FLOOR(SUM(QUANTIDADE * PREÇO)) AS 'LUCRO NAO DESCONTADO' FROM [NOTAS FISCAIS] INNER JOIN
[ITENS NOTAS FISCAIS] ON [NOTAS FISCAIS].NUMERO = [ITENS NOTAS FISCAIS].NUMERO
GROUP BY YEAR(DATA) ORDER BY ANO

--INNER JOIN
-- MOSTRA ANO, IMPOSTO GERADO POR VENDAS, VALOR BRUTO GERADO POR VENDAS E VALOR REDUZIDO DO IMPOSTO GERADO NAS VENDAS
SELECT I.DATA, I.TOTAL_IMPOSTO AS IMPOSTO, L.LUCRO AS VBRUTO, SUM(L.LUCRO - I.TOTAL_IMPOSTO) AS VLUCRO FROM (SELECT YEAR(DATA) AS DATA, FLOOR(SUM(IMPOSTO * QUANTIDADE)) AS TOTAL_IMPOSTO
FROM [NOTAS FISCAIS] NF
INNER JOIN [ITENS NOTAS FISCAIS] INF ON NF.NUMERO = INF.NUMERO
GROUP BY YEAR(DATA)) I INNER JOIN (SELECT YEAR(DATA) AS 'ANO',COUNT(*) AS 'Q. VENDAS', FLOOR(SUM(QUANTIDADE * PREÇO)) AS 'LUCRO' FROM [NOTAS FISCAIS] INNER JOIN
[ITENS NOTAS FISCAIS] ON [NOTAS FISCAIS].NUMERO = [ITENS NOTAS FISCAIS].NUMERO
GROUP BY YEAR(DATA)) L ON I.DATA = L.ANO
GROUP BY I.DATA, I.TOTAL_IMPOSTO, L.LUCRO ORDER BY I.DATA

--VERSÃO SIMPLIFICADA

SELECT YEAR(DATA) AS DATA,
       ROUND(SUM(IMPOSTO * QUANTIDADE),0) AS TOTAL_IMPOSTO,
       ROUND(SUM(QUANTIDADE * PREÇO),0) AS TOTAL_FATURAMENTO,
       ROUND(SUM(QUANTIDADE * (PREÇO - IMPOSTO)),0) AS TOTAL_LUCRO
FROM [NOTAS FISCAIS] NF
INNER JOIN [ITENS NOTAS FISCAIS] INF ON NF.NUMERO = INF.NUMERO
GROUP BY YEAR(DATA)
ORDER BY DATA

/*			-/-			-/-			-/-			-/-			-/-			-/-			-/-
	CONVERT & CAST
*/
-- MM/DD/YY
SELECT CONVERT(VARCHAR, GETDATE(), 101)
--DD/MM//YY
SELECT CONVERT(VARCHAR, GETDATE(), 106)
--DD/MM/YY
SELECT CONVERT(VARCHAR, GETDATE(), 105)

SELECT CONVERT(CHAR, 10)
--				converte 193.57 em um decimal com 3 casas
SELECT CONVERT(decimal(10,3), 193.57)

-- NÃO FUNCIONA				   VARCHAR						SMALLMONEY
SELECT 'O preço do produto ' + [NOME DO PRODUTO] + ' ・' +  [PREÇO DE LISTA] 
from [TABELA DE PRODUTOS]
--FUNCIONA
SELECT 'O preço do produto ' + [NOME DO PRODUTO] + ' ・' +  CONVERT(VARCHAR, [PREÇO DE LISTA]) 
from [TABELA DE PRODUTOS]

SELECT 'O cliente ' +NOME+ ' faturou ' +CONVERT(VARCHAR, 120000)+ ' no ano de 2016' FROM [TABELA DE CLIENTES]

SELECT YEAR(DATA) AS ANO, NOME, CONVERT(DECIMAL(15,2), SUM(QUANTIDADE * PREÇO)) AS FATUROU FROM [NOTAS FISCAIS] NF
INNER JOIN [ITENS NOTAS FISCAIS] INF ON NF.NUMERO = INF.NUMERO
INNER JOIN [TABELA DE CLIENTES] TC ON NF.CPF = TC.CPF
GROUP BY YEAR(DATA), NOME ORDER BY YEAR(DATA), NOME