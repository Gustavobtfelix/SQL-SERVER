-- OPEN PROFILER AND COMPARE READS OVERHEAD

-- Getting transaction times for change table entries
-- Set the capture instance to lookup LSNs for
DECLARE @capture_instance sysname = 'dbo_welcome';

-- Get the current min LSN for the capture instance based on datetime
DECLARE @from_lsn binary(10) = sys.fn_cdc_get_min_lsn(@capture_instance),
		@to_lsn binary(10) = sys.fn_cdc_get_max_lsn();

DECLARE @welcome_ordinal INT = sys.fn_cdc_get_column_ordinal(@capture_instance, 'cracha_impresso'),
		@cpf_ordinal	 INT = sys.fn_cdc_get_column_ordinal(@capture_instance, 'cpf')

 
 

-- Get all changes from the capture instance within the LSN range

SELECT [__$start_lsn]
      ,[__$seqval]
	  ,sys.fn_cdc_is_bit_set( @welcome_ordinal, [__$update_mask] ) AS cracha_impresso_changed
	  ,sys.fn_cdc_is_bit_set( @cpf_ordinal , [__$update_mask] ) AS cpf_changed
	  ,[__$operation]
	  ,CASE [__$operation]
			WHEN 1 THEN 'Delete'
			WHEN 2 THEN 'Insert'
			WHEN 3 THEN 'Update From Value'
			WHEN 4 THEN 'Update To Value'
	  END AS [operation]
      ,[__$update_mask]
      ,*
FROM cdc.fn_cdc_get_all_changes_dbo_welcome (@from_lsn, @to_lsn, N'all update old');



-- Second Method (uses 6x more reads because it verifys every  row)



-- Getting transaction times for change table entries
-- Set the capture instance to lookup LSNs for
DECLARE @capture_instance sysname = 'dbo_welcome';

-- Get the current min LSN for the capture instance based on datetime
DECLARE @from_lsn binary(10) = sys.fn_cdc_get_min_lsn(@capture_instance),
		@to_lsn binary(10) = sys.fn_cdc_get_max_lsn();

-- Get all changes from the capture instance within the LSN range

SELECT [__$start_lsn]
      ,[__$seqval]
	  ,sys.fn_cdc_has_column_changed( 'dbo_welcome','cracha_impresso' , [__$update_mask] ) AS cracha_impresso_changed
	  ,sys.fn_cdc_has_column_changed( 'dbo_welcome','cpf' , [__$update_mask] ) AS cpf_changed
	  ,[__$operation]
	  ,CASE [__$operation]
			WHEN 1 THEN 'Delete'
			WHEN 2 THEN 'Insert'
			WHEN 3 THEN 'Update From Value'
			WHEN 4 THEN 'Update To Value'
	  END AS [operation]
      ,[__$update_mask]
      ,*
FROM cdc.fn_cdc_get_all_changes_dbo_welcome (@from_lsn, @to_lsn, N'all update old');

