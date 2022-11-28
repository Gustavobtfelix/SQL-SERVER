USE Credit;
Go

-- Get information about all capture instances
EXECUTE sys.sp_cdc_help_change_data_capture;
GO

-- Get information about the dbo.charge tables capture instances
EXECUTE sys.sp_cdc_help_change_data_capture @source_schema = N'dbo', @source_name = N'welcome';
GO

-- Get captured columns for each capture instance on dbo.charge
EXECUTE sys.sp_cdc_get_captured_columns @capture_instance = N'dbo_welcome';
GO
EXECUTE sys.sp_cdc_get_captured_columns @capture_instance = N'dbo_charge_2';
go

-- Query system tables directly -- NOT GENERALLY RECOMMENDED
SELECT *
FROM cdc.change_tables;
GO

-- Expanded data for change tables|
SELECT
	SCHEMA_NAME(src.schema_id) AS source_schema,
	src.name AS source_name,
	o.name AS change_table_name,
	ct.*
FROM cdc.change_tables AS ct
INNER JOIN sys.objects AS o
	ON ct.object_id = o.object_id
INNER JOIN sys.objects AS src
	ON ct.source_object_id = src.object_id;
GO

-- Get column Lists from system tables
SELECT *
FROM cdc.captured_columns;
GO

-- Expanded data for captured colums
SELECT
	SCHEMA_NAME(src.schema_id) AS source_schema,
	src.name AS source_name,
	ct.capture_instance,
	cc.*
FROM cdc.captured_columns AS cc
INNER JOIN cdc.change_tables AS ct
	ON cc.object_id = ct.object_id
INNER JOIN sys.objects AS o
	ON ct.object_id = o.object_id
INNER JOIN sys.objects AS src
	ON ct.source_object_id = src.object_id;
GO


 

   
