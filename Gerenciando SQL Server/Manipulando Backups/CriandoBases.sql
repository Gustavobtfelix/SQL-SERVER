
USE SUCOS_VENDAS
--mostra os detalhes da aba files do database
SELECT * FROM SYS.database_files

CREATE DATABASE ARCHIVE--			arquivo fisico primary
ON PRIMARY (NAME = ARCH1, FILENAME = 'C:\Temp\SQL\archive1.mdf', SIZE = 10MB, 
MAXSIZE = 200MB, FILEGROWTH = 20MB),
--							arquivo fisico secundary
(NAME = ARCH2, FILENAME = 'C:\Temp\SQL\archive2.ndf', SIZE = 10MB, 
MAXSIZE = 200MB, FILEGROWTH = 20MB)
--							arquivo fisico transacoes
LOG ON  (NAME = ARCH1LOG, FILENAME = 'C:\Temp\SQL\archive2.ldf', SIZE = 10MB, 
MAXSIZE = 200MB, FILEGROWTH = 20MB)

USE ARCHIVE --reduz tamanho do
--							torna bd desconectado do ambiente
ALTER DATABASE ARCHIVE SET RECOVERY SIMPLE
--reduz o tamanho da base em 2 etapas
DBCC SHRINKDATABASE ('ARCHIVE', NOTRUNCATE)
DBCC SHRINKDATABASE ('ARCHIVE', TRUNCATEONLY)
--							sobe a bd novamente para conecoes
ALTER DATABASE ARCHIVE SET RECOVERY FULL






