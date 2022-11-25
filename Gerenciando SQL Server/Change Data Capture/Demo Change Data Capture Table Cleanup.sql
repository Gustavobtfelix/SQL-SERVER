--Not working

-- Find the mappings to capture instances being tracked
SELECT *
FROM dbo.cdc_lsn_tracking AS lt
WHERE lt.capture_instance = N'dbo_charge';
GO

 

-- View the current rows waiting to be processed
-- Get the current min LSN for the capture instance
DECLARE @from_lsn binary(10),
		@to_lsn binary(10);

EXECUTE dbo.GetCDCProcessingRange @capture_instance = N'dbo_charge', @from_lsn = @from_lsn OUTPUT, @to_lsn = @to_lsn OUTPUT;

-- Get all changes from the capture instance within the LSN range
SELECT *
FROM cdc.fn_cdc_get_all_changes_dbo_charge (@fromlsn, @to_lsn, N'all');
GO

-- Clear out older data that has been processed already
DECLARE @from_lsn binary(10),
		@to_lsn binary(10),
		@capture_instance SYSNAME = N'dbo_charge',
		@cleanup_isn binary(10);

-- Get the from_isn processing range for the capture instance
EXECUTE dbo.GetCDCProcessingRange @capture_instance = N'dbo_charge', @fromlsn = @from_lsn OUTPUT, @to_lsn = @to_lsn OUTPUT;

-- Get the cleanup sn for manual cleanup
SELECT @cleanup_Isn = max(start_lsn)
FROM cdc.lsn.time_mapping
WHERE startlsn <= @from_lsn;
