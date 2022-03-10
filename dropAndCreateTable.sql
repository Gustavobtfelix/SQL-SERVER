USE [HELLO_WORLD]
GO

/****** Object:  Table [dbo].[TABELA DE CLIENTES]    Script Date: 10/09/2021 12:33:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TABELA DE CLIENTES]') AND type in (N'U'))
DROP TABLE [dbo].[TABELA DE CLIENTES]
GO

/****** Object:  Table [dbo].[TABELA DE CLIENTES]    Script Date: 10/09/2021 12:33:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TABELA DE CLIENTES](
	[CPF] [char](11) NULL,
	[NOME] [varchar](100) NULL,
	[ENDERECO1] [varchar](150) NULL,
	[ENDERECO2] [varchar](150) NULL,
	[BAIRRO] [varchar](50) NULL,
	[CIDADE] [varchar](50) NULL,
	[ESTADO] [char](2) NULL,
	[CEP] [char](8) NULL,
	[DATA DE NASCIMENTO] [date] NULL,
	[IDADE] [smallint] NULL,
	[SEXO] [char](1) NULL,
	[LIMITE DE CREDITO] [money] NULL,
	[VOLUME DE COMPRA] [float] NULL,
	[PRIMEIRA COMPRA] [bit] NULL
) ON [PRIMARY]
GO


