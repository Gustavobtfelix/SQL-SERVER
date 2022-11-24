--Only works with enterprize
--Select databases lists with cdc parameter
select name, is_cdc_enabled from sys.databases

--Select table lists with cdc parameter
select name, is_tracked_by_cdc from sys.tables

--Select active cdc tracking on existing tables
select OBJECT_NAME([object_id]), OBJECT_NAME(source_object_id), capture_instance
from cdc.change_tables


GO

EXEC sys.sp_cdc_enable_db
GO

EXEC sys.sp_cdc_enable_table
	@source_schema = N'dbo',
	@source_name = N'welcome',
	@role_name = N'cdc_admin',
	@captured_column_list = '[id], [dt_server], [ticket], [nome], [cpf], [rg], [home_office], [empresa], [local_trabalho], [area], [foto_editada], [polo_nome], [polo_endereco], [dt_welcome], [time_cracha], [empresa_cracha], [dt_ticket], [foto_recusada], [cracha_impresso], [primeiro_nome], [ultimo_nome], [nome_social], [liberado]'
GO

/*
$operation

1: DELETE
2: INSERT
3: Valor antes do UPDATE
4: Valor após o UPDATE

*/

 

--Add a new filegroup to the database to isolate the change tables
ALTER DATABASE [Credit]

ADD FILEGROUP [cdc_ChangeTables];

GO

--Add a file to the filegroup

ALTER DATABASE [Credit]
ADD FILE (  NAME = N'cdc_ChangeTables',
			FILENAME = N'E:\SQLData\Credit_cdc_ChangeTables.ndf',
			SIZE = 1048576KB ,
			FILEGROWTH = 1024008 )
TO FILEGROUP [cdc_ChangeTables];

--Create a second capture instance for the Category table on the new filegroup
--Note! Second capture instance requires the @capture_instance parameter
EXEC sys.sp_cdc_enable_table
	@source_schema = N'dbo',
	@source_name = N'welcome',
	@role_name = N'cdc_admin',
	@capture_instance = N'dbo_category_2',
	@Filegroup_name = N'cdc_ChangeTables' ;
GO

--View capture instance configuration
EXEC sys.sp_cdc_help_change_data_capture;
GO

--Disable all capture instances on the Category table
EXEC sys.sp_cdc_disable_table
	@source_schema = N'dbo',
	@source_name = N'category',
	@capture_instance = N'all' --it can also be specified for individual capture_instance
GO

--Create a new capture instance for the charge table
EXEC sys.sp_cdc_enable_table
	@source_schema = N'dbo',
	@source_name = N'welcome',
	@role_name = N'cdc_admin',
	@filegroup_name = 'cdc_ChangeTables',
	@supports_net_changes = 0;
GO
 

-- Enable a table with 2 subset of colums tracked
-- Note! This is a second capture instance on the table and requires explicitly naming the @capture_instance
EXEC sys.sp_cdc_enable_table
	@source_schema = N'dbo', 
	@source_name = N'welcome',
	@role_name = 'cdc_admin',
	@filegroup_name = 'cdc_ChangeTables',
	@supports_net_changes = 1,
	@capture_instance = N'dbo_charge_2',
	@captured_column_list = 'charge_no, charge_amt, charge_code';

   

--View capture instance configuration
EXEC sys.sp_cdc_help_change_data_capture;
GO

sp_helptext 'sys.sp_cdc_disable_table'



 
