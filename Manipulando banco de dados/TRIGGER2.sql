CREATE TABLE t1 (
    id int IDENTITY(1,1) NOT NULL,
    c1 int DEFAULT 0,
    c2 int DEFAULT 0,
    c3 int DEFAULT 0
);


CREATE TRIGGER trg_t1
ON t1
AFTER UPDATE
AS
IF ( UPDATE (c1) )
BEGIN
	DECLARE @id int

	SELECT @id = id from INSERTED

	SELECT * from t1 as A where A.id = @id
END;

select * from t1

insert into t1 values (1,2,3,4)

update t1 set c1 = 4 where id = 3



CREATE TABLE welcome (
    id int IDENTITY(1,1) NOT NULL,
    nome nvarchar(250),
    cpf nvarchar (14),
	cracha_impresso int,
);

INSERT INTO welcome 
		(nome, cpf, cracha_impresso) 
	values
		( 'E', 'CPF', 0)
select * from welcome
select * from registrosImpressoes


UPDATE [dbo].[welcome]
   SET 
      [cracha_impresso] = 6,
	  nome = 'GG'
 WHERE cpf = 'CPF2'



CREATE TRIGGER DMLnovaImpressao
ON [dbo].[welcome]
AFTER UPDATE
AS
IF ( UPDATE(cracha_impresso) )
BEGIN
	DECLARE @cpf nvarchar (14)
	
	SELECT @cpf = cpf FROM INSERTED

    --SELECT @sys_user = SYSTEM_USER; 

	--SELECT @novo = (SELECT cpf from [dbo].[welcome] as A where A.id = @id)

	--PRINT @cpf
	--PRINT @sys_user

	INSERT INTO [SUCOS_VENDAS].[dbo].[registrosImpressoes] 
		(dt_server, origin, usuario, Command, cpf, OldRowData, NewRowData)
		VALUES
			( SYSDATETIME(),
			  'WELCOME',
			  SUSER_SNAME(),
			  'UPDATE', 
			  @cpf, 
			  (SELECT * FROM DELETED FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),
			  (SELECT * FROM INSERTED FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
			  )
END

