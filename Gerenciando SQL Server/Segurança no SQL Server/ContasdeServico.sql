--mostra usuarios no sistema
SELECT * FROM MASTER.SYS.sql_logins
--mostra ultima ves que foi alterada a senha
SELECT name, LOGINPROPERTY(name, 'PasswordLastSetTime') from MASTER.SYS.sql_logins
--cria usuario e senha
CREATE LOGIN marco WITH PASSWORD = 'Password'
--ou LOGIN[DOMAIN/nome] FROM WINDOWS

DROP LOGIN marco

SELECT SERVERPROPERTY('<HOSTNAME>') AS SERVER_NAME
, NAME AS LOGIN_NAME FROM  MASTER.SYS.sql_logins
-- compara se o nome e senha dos usuarios e o mesmo
WHERE PWDCOMPARE(NAME, PASSWORD_HASH) = 1


/*permissoes:

sysadmin
bulkadmin
diskadmin
processadmin
public
securityadmin
serveradmin
setupadmin
dbcreator
*/
										--or [DOMAIN/marco] FROM WINDOWS
ALTER SERVER ROLE [dbcreator] ADD MEMBER [marco] 

ALTER SERVER ROLE [dbcreator] DROP MEMBER [marco] 

--mostra todas as permissoes a nivel de servidor
SELECT * FROM SYS.fn_builtin_permissions('') WHERE CLASS_DESC = 'SERVER'

USE SUCOS_VENDAS
--login é a autenticacao para acessar o sql
CREATE LOGIN jorge WITH PASSWORD = 'jorge@123'
--user é quem recebe segurança a nivel de servidor e banco de dados
CREATE USER jorge FOR LOGIN jorge
--concede permissoes a nivel servidor
USE SUCOS_VENDAS
EXEC sp_addrolemember 'db_datareader', 'jorge'
EXEC sp_addrolemember 'db_datawriter', 'jorge'
