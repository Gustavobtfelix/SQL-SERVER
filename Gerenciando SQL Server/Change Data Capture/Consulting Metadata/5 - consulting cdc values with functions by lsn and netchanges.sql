-- Get capture instance name
SELECT *
FROM cdc.change_tables;
GO

-- Load some example charges
EXECUTE dbo.load_charges @target_charge_count
GO

-- Set the capture instance to lookup LSNs for
DECLARE @capture_instance sysname = 'dbo_welcome';

-- Get the current min LSN for the capture instance and the current max LSN
DECLARE @from_lsn binary(10) = sys.fn_cdc_get_min_lsn(@capture_instance),
		@to_lsn binary(10) = sys.fn_cdc_get_max_lsn();

SELECT @from_lsn, @to_lsn

-- Get all changes from the capture instance within the LSN range
SELECT *
FROM cdc.fn_cdc_get_all_changes_dbo_welcome (@from_lsn, @to_lsn, N'all');
GO

-- Perform an update to one of the captured charges
UPDATE dbo.welcome
SET value = 'new value'
WHERE parameter = 'column value parameter';
GO

-- Set the capture instance to lookup LsNs for
DECLARE @capture_instance sysname = 'dbo_welcome';

--Get the current ain LS for the capture instarice and the current wax USN
DECLARE @from_lsn binary(10) = sys.fn_cdc_get_min_lsn(@capture_instance),
		@to_lsn binary(10) = sys.fn_cdc_get_max_lsn();

-- Get all changes from the capture instance within the LSW range whithout from value

SELECT [__$start_lsn]
      ,[__$seqval]
	  ,CASE [__$operation]
			WHEN 1 THEN 'Delete'
			WHEN 2 THEN 'Insert'
			WHEN 3 THEN 'Update From Value'
			WHEN 4 THEN 'Update To Value'
	  END AS [operation]
      ,[__$update_mask]
      ,*
FROM cdc.fn_cdc_get_all_changes_dbo_welcome (@from_lsn, @to_lsn, N'all');

-- Get all changes from the capture instance whithin the LSN range

SELECT [__$start_lsn]
      ,[__$seqval]
	  ,CASE [__$operation]
			WHEN 1 THEN 'Delete'
			WHEN 2 THEN 'Insert'
			WHEN 3 THEN 'Update From Value'
			WHEN 4 THEN 'Update To Value'
	  END AS [operation]
      ,[__$update_mask]
      ,*
FROM cdc.fn_cdc_get_all_changes_dbo_welcome (@from_lsn, @to_lsn, N'all update old');
GO

-- Getting NET changes NOTE! This has limited column list to show how to set up the table capture
-- Set the capture instance to lookup LSNs for
DECLARE @capture_instance sysname = 'welcome';

-- Get the current min LSN for the capture instance and the current max LSN
DECLARE @from_lsn binary(10) = sys.fn_cdc_get_min_lsn(@capture_instance),
		@to_lsn binary(10) = sys.fn_cdc_get_max_lsn();

-- Get all changes from the capture instance within the LSN range 
SELECT [__$start_lsn]
	  ,CASE [__$operation]
			WHEN 1 THEN 'Delete'
			WHEN 2 THEN 'Insert'
			WHEN 3 THEN 'Update From Value'
			WHEN 4 THEN 'Update To Value'
	  END AS [operation]
      ,[__$update_mask]
      ,*
FROM cdc.fn_cdc_get_net_changes_dbo_welcome (@from_lsn, @to_lsn, N'all');

-- Getting transaction times for change table entries
-- Set the capture instance to lookup LSN for

SELECT [__$start_lsn]
	  ,CASE [__$operation]
			WHEN 1 THEN 'Delete'
			WHEN 2 THEN 'Insert'
			WHEN 3 THEN 'Update From Value'
			WHEN 4 THEN 'Update To Value'
	  END AS [operation]
      ,[__$update_mask]
      ,*
	  ,sys.fn_cdc_map_lsn_to_time([__$start_lsn]) AS [trans_time]
FROM cdc.fn_cdc_get_net_changes_dbo_welcome (@from_lsn, @to_lsn, N'all update old');