﻿SELECT * FROM [TABELA DE PRODUTOS]

UPDATE [TABELA DE PRODUTOS] SET [PREÇO DE LISTA] = 5
WHERE [CODIGO DO PRODUTO] = '1040107'

UPDATE [TABELA DE PRODUTOS] SET [SABOR] = 'Laranja', [EMBALAGEM] = 'PET'
WHERE [CODIGO DO PRODUTO] = '1040107'

SELECT * FROM [TABELA DE PRODUTOS] WHERE [SABOR] = 'Manga'

UPDATE [TABELA DE PRODUTOS] SET [PREÇO DE LISTA] = [PREÇO DE LISTA] * 1.10
WHERE [SABOR] = 'Manga'

SELECT * FROM [TABELA DE PRODUTOS] WHERE [SABOR] = 'Manga'
