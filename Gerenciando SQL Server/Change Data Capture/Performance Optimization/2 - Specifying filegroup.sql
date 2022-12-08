-- Create a new capture instance for the Category table
EXEC sys. sp_cdc_enable_table
	@source_schema = N'dbo',
	@source_name = N'welcome',
	@role_name = N'user_log';
GO

-- Add a new filegroup to the database to isolate the change tables
ALTER DATABASE [db_name]
ADD FILEGROUP [cdc_ChangeTables];
GO

-- Add a file to the filegroup
ALTER DATABASE [db_name]
ADD FILE ( NAME = N'cdc_ChangeTables',
		   FILENAME = N'E:SQLData\cdc_ChangeTables.ndf',
		   SIZE = 1048576KB ,
		   FILEGROWTH = 102400KB )
TO FILEGROUP [cdc_ChangeTables];
GO

-- Create a second capture instance for the Category table on the new filegroup

-- Note! Second capture instance requires the @capture_instance parameter

EXEC sys.sp_cdc_enable_table
	@source_schema = N'dbo',
	@source_name = N'welcome',
	@role_name = N'user_log',
	@capture_instance = N'dbo_category_2',
	@Filegroup_name = N'cdc_ChangeTables';
GO

-- View capture instance configuration
EXEC sys.sp_cdc_help_change_data_capture;
GO
 
  

 
