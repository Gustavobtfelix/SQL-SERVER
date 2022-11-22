/****** Object:  Table [dbo].[logs_dml]    Script Date: 11/22/2022 10:21:16 AM ******/
DROP TABLE if exists logs_dml
GO

/****** Object:  Table [dbo].[logs_dml]    Script Date: 11/22/2022 10:21:16 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[logs_dml](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[dt_server] [datetime] NOT NULL,
	[origin] [nvarchar](50) NOT NULL,
	[db_user] [nvarchar](250) NULL,
	[command] [nvarchar](10) NULL,
	[cpf] [nvarchar](14) NULL,
	[old_data] [nvarchar](3000) NULL,
	[new_data] [nvarchar](3000) NULL,
 CONSTRAINT [PK_logs_dml] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



ALTER TRIGGER DMLTriggerWelcome
ON [dbo].[welcome]  -- Trigger que adiciona log de alteração no banco de logs, fazendo com que apos cada insert ou update na tabela rastreada seja inserido um registro na tabela [logs_dml] 
AFTER INSERT, UPDATE
AS 
SET NOCOUNT ON
SET XACT_ABORT OFF
IF NOT ( UPDATE ([columnA]) OR UPDATE ([columnN]))
 BEGIN 
	PRINT('ignorando trigger')
 END
ELSE
BEGIN TRY
	-- termina acao para que o trigger nao possa dar erro
    -- acontece caso o update seja feito somente no campo cracha_impresso
    /*referencias para o codigo:
    https://learn.microsoft.com/en-us/sql/relational-databases/triggers/create-dml-triggers?view=sql-server-ver16
    https://www.vitoshacademy.com/sql-server-create-trigger-to-log-changes-in-db/
    
    referencias para auditoria:
    https://www.sqlshack.com/various-techniques-to-audit-sql-server-databases/
    https://www.red-gate.com/simple-talk/databases/sql-server/database-administration-sql-server/sql-server-triggers-good-scary/
    */

	
	declare @old_data nvarchar(2000), @new_data nvarchar(2000), @cpf nvarchar (14)
    declare @id2 int  
	SELECT * INTO #TEMPINSERTED FROM INSERTED
	SELECT * INTO #TEMPDELETED FROM DELETED
	ALTER TABLE #TEMPINSERTED DROP COLUMN IF EXISTS foto
	ALTER TABLE #TEMPINSERTED DROP COLUMN IF EXISTS foto_1
	ALTER TABLE #TEMPINSERTED DROP COLUMN IF EXISTS foto_2
	ALTER TABLE #TEMPDELETED DROP COLUMN IF EXISTS foto
	ALTER TABLE #TEMPDELETED DROP COLUMN IF EXISTS foto_1
	ALTER TABLE #TEMPDELETED DROP COLUMN IF EXISTS foto_2

    DECLARE @operation CHAR(6)
    	SET @operation = CASE
    		WHEN EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted)
    			THEN 'update'
    		WHEN EXISTS(SELECT * FROM inserted)
    			THEN 'insert'
    		WHEN EXISTS(SELECT * FROM deleted)
    			THEN 'delete'
    		ELSE NULL
    	END	
    
    declare CURSOR_TRIGGER cursor local for --cursor passa por cada campo que for modificado e faz insert para cada modificacao

        select   
        	id  
        from #TEMPINSERTED

    open CURSOR_TRIGGER  

    fetch next from CURSOR_TRIGGER into @id2  
        
    while @@fetch_status = 0  
    begin try
    	SELECT @cpf = (SELECT cpf FROM #TEMPINSERTED WHERE id = @id2)
    	SELECT @old_data = (SELECT *
    	   FROM #TEMPDELETED WHERE id = @id2 FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) --salva dados de colunas rastreadas no formato json
    	SELECT @new_data = (SELECT *
    	   FROM #TEMPINSERTED WHERE id = @id2 FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)

    	--faz o que precisa para cada registro  
    	INSERT INTO [DATA_LOGS].[dbo].[logs_dml] 
    	(dt_server, origin, db_user, command, cpf, old_data, new_data)
    	VALUES
    		( SYSDATETIME(), --data e hora
    		  'welcome',
    		  SUSER_SNAME(), --usuario no banco
    		  @operation, 
    		  @cpf, 
    		  @old_data,
    		  @new_data
    		  )
          
    		fetch next from CURSOR_TRIGGER into @id2  

    end try
	begin catch
		PRINT 'Error on line ' + CAST(ERROR_LINE() AS VARCHAR(10))
		PRINT ERROR_MESSAGE()
	end catch

    close CURSOR_TRIGGER  
    deallocate CURSOR_TRIGGER  
END TRY
BEGIN CATCH
	PRINT 'Error on line ' + CAST(ERROR_LINE() AS VARCHAR(10))
    PRINT ERROR_MESSAGE()
END CATCH
    


CREATE TRIGGER DMLTriggerWelcomeDelete
ON [dbo].[welcome]  -- Trigger que adiciona log de alteração no banco de logs, fazendo com que apos cada delete, seja inserido um registro na tabela [logs_dml] 
AFTER DELETE
AS
SET NOCOUNT ON
SET XACT_ABORT OFF
BEGIN TRY
 
	DECLARE @operation CHAR(6)
	SELECT @operation = 'delete'			
			
	declare @id int, @old_data nvarchar(2000), @new_data nvarchar(2000), @cpf nvarchar (14) 
	SELECT * INTO #TEMPDELETED FROM DELETED
	ALTER TABLE #TEMPDELETED DROP COLUMN IF EXISTS foto
	ALTER TABLE #TEMPDELETED DROP COLUMN IF EXISTS foto_1
	ALTER TABLE #TEMPDELETED DROP COLUMN IF EXISTS foto_2
 
		declare CURSOR_DELETE cursor local for
 
		select   
			id  
		from deleted
 
		open CURSOR_DELETE  
 
		fetch next from CURSOR_DELETE into @id 
      
		while @@fetch_status = 0  
		begin try

			SELECT @cpf = (SELECT cpf FROM #TEMPDELETED WHERE id = @id)
			SELECT @old_data = (SELECT *
			   FROM #TEMPDELETED WHERE id = @id FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
 
			--faz o que precisa para cada registro  
			INSERT INTO [DATA_LOGS].[dbo].[logs_dml] 
		(dt_server, origin, db_user, command, cpf, old_data)
		VALUES
			( SYSDATETIME(),
			  'welcome',
			  SUSER_SNAME(),
			  @operation, 
			  @cpf, 
			  @old_data
			  )
          
			fetch next from CURSOR_DELETE into @id  
 
		end try
		begin catch
			PRINT 'Error on line ' + CAST(ERROR_LINE() AS VARCHAR(10))
			PRINT ERROR_MESSAGE()
		end catch
 
		close CURSOR_DELETE  
		deallocate CURSOR_DELETE  
END TRY
BEGIN CATCH
	PRINT 'Error on line ' + CAST(ERROR_LINE() AS VARCHAR(10))
    PRINT ERROR_MESSAGE()
END CATCH