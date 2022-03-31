/* 
X OR Y
X AND Y
NOT(X)
IN(X,Y)  = Contém 
NOT IN (X,Y) = Não Contém
BETWEEN X AND Y
LIKE = string igual
%LIKE = possui semelhante no final
LIKE% = possui semelhante no inicio
%LIKE% = possui semelhante

DISTINCT [COLUNA]  = Mostra apenas linhas que não se repetem entre as colunas selecionadas

TOP N = Mostra n valores  conforme a seleção de tabela e condições

ORDER BY ASC = Ordena na ordem crescente pela última coluna
ORDER BY DESC = Ordena na ordem decescente
ORDER BY CAMPO1 DESC = ordena na ordem descendente com base no campo 1
ORDER BY CAMPO1, CAMPO2 = ordena de forma crescente pelo campo 1 e entre aqueles no campo 1 ordena pelos que aparecem de forma crescente no campo 2
*/


SELECT * FROM [TABELA DE PRODUTOS] WHERE  [SABOR] = 'Manga' OR [TAMANHO] = '700 ml' 

SELECT * FROM [TABELA DE PRODUTOS] WHERE [SABOR] = 'Manga' AND [TAMANHO] = '700 ml' 

SELECT * FROM [TABELA DE PRODUTOS] WHERE NOT ([SABOR] = 'Manga' AND [TAMANHO] = '700 ml')

SELECT * FROM [TABELA DE PRODUTOS] WHERE NOT ([SABOR] = 'Manga' OR [TAMANHO] = '700 ml')

SELECT * FROM [TABELA DE PRODUTOS] WHERE [SABOR] = 'Manga' AND NOT ( [TAMANHO] = '700 ml')

SELECT * FROM [TABELA DE PRODUTOS] WHERE [SABOR] IN ('Manga', 'Laranja')

SELECT * FROM [TABELA DE PRODUTOS] WHERE [SABOR] = 'Manga' OR [SABOR] ='Laranja'

SELECT * FROM [TABELA DE PRODUTOS] WHERE [SABOR] NOT IN ('Manga', 'Laranja')

SELECT * FROM [TABELA DE PRODUTOS] WHERE NOT ([SABOR] = 'Manga' OR [SABOR] ='Laranja')

SELECT * FROM [TABELA DE PRODUTOS] WHERE [SABOR] IN ('Manga', 'Laranja') AND [PREÇO DE LISTA] > 10

SELECT * FROM [TABELA DE PRODUTOS] WHERE [SABOR] IN ('Manga', 'Laranja') AND [PREÇO DE LISTA] BETWEEN 10 AND 13

SELECT * FROM [TABELA DE PRODUTOS] WHERE [SABOR] IN ('Manga', 'Laranja') AND [PREÇO DE LISTA] >= 10 AND [PREÇO DE LISTA] <= 13


SELECT * FROM [TABELA DE PRODUTOS] WHERE [NOME DO PRODUTO] LIKE '%Litros%'
--Has in any position
SELECT * FROM [TABELA DE PRODUTOS] WHERE [SABOR] LIKE '%Cereja%'
-- Start with
SELECT * FROM [TABELA DE PRODUTOS] WHERE [NOME DO PRODUTO] LIKE 'Litros%'
-- Finish with
SELECT * FROM [TABELA DE PRODUTOS] WHERE [SABOR] LIKE '%Cereja'
 OR [SABOR] = 'Laranja'
 /*
WHERE CustomerName LIKE '_r%'	Finds any values that have "r" in the second position
WHERE CustomerName LIKE 'a_%'	Finds any values that start with "a" and are at least 2 characters in length
WHERE CustomerName LIKE 'a__%'	Finds any values that start with "a" and are at least 3 characters in length
WHERE ContactName LIKE 'a%o'	Finds any values that start with "a" and ends with "o"
*/

SELECT DISTINCT SABOR FROM [TABELA DE PRODUTOS]

SELECT DISTINCT EMBALAGEM, TAMANHO FROM [TABELA DE PRODUTOS]

SELECT DISTINCT EMBALAGEM, TAMANHO, SABOR FROM [TABELA DE PRODUTOS] WHERE [SABOR] = 'Laranja'


SELECT TOP 3 * FROM [TABELA DE PRODUTOS]

SELECT TOP 3 * FROM [TABELA DE PRODUTOS] WHERE [SABOR] = 'Laranja'

SELECT DISTINCT TOP 3 EMBALAGEM, TAMANHO FROM [TABELA DE PRODUTOS]


SELECT * FROM [TABELA DE PRODUTOS] ORDER BY [PREÇO DE LISTA]

SELECT * FROM [TABELA DE PRODUTOS] ORDER BY [PREÇO DE LISTA] DESC

SELECT * FROM [TABELA DE PRODUTOS] ORDER BY [NOME DO PRODUTO]

SELECT [EMBALAGEM], [NOME DO PRODUTO] FROM [TABELA DE PRODUTOS] 
ORDER BY [EMBALAGEM], [NOME DO PRODUTO]

SELECT [EMBALAGEM], [NOME DO PRODUTO] FROM [TABELA DE PRODUTOS] 
ORDER BY [EMBALAGEM] DESC, [NOME DO PRODUTO] ASC

