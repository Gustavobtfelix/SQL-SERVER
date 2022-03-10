--CPF do cliente
--O nome completo do cliente
--Endereço com Rua, bairro, cidade, estado e CEP
--Data de nascimento
--A idade
--Gênero
--O limite do crédito do cliente para ele comprar produtos na empresa
--O volume mínimo de produtos que ele pode comprar
--Se ele já realizou a primeira compra.

CREATE TABLE [TABELA DE CLIENTES]
([CPF] [CHAR] (11),
[NOME] [VARCHAR] (100),
[ENDERECO1]	[VARCHAR] (150),
[ENDERECO2]	[VARCHAR] (150),
[BAIRRO] [VARCHAR] (50),
[CIDADE] [VARCHAR] (50),
[ESTADO] [CHAR] (2),
[CEP] [CHAR] (8),
[DATA DE NASCIMENTO] [DATE],
[IDADE] [SMALLINT],
[SEXO] [CHAR] (1),
[LIMITE DE CREDITO] [MONEY],
[VOLUME DE COMPRA] [FLOAT],
[PRIMEIRA COMPRA] [BIT]);

--Número da matricula com 5digitos
--Nome do vendedor com 100 digitos
--Percentual da comissão 

CREATE TABLE [TABELA DE VENDEDORES]
([MATRICULA] [CHAR] (5),
[NOME] [VARCHAR] (100),
[PERCENTUAL COMISSÃO] float);
