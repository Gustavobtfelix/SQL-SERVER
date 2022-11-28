USE Credit;
GO

-- Get capture table name
select
	object_name(object_id) AS capture_table_name,
	*
FROM cdc.change_tables;
GO

-- Query directly from the capture table to see columns - NOT GENERALLY RECOMMENDED
SELECT *
FROM cdc.dbo_welcome_CT;
GO

-- Load some example charges
EXECUTE dbo.load_charges @target_charge_count = 2;
GO

-- Query directly from the capture table to see columns - NOT GENERALLY RECOMMENDED
SELECT *
FROM cdc.dbo_welcome_CT;
GO 

-- Perform an update to one of the captured charges
UPDATE dbo.charge
SET charge_amt = 4621.00
WHERE charge_no = 2000001;
GO

-- Query directly from the capture table to see columns - NOT GENERALLY RECOMMENDED
SELECT *
FROM cdc.dbo_welcome_CT;
GO


--Transpose the operation column
USE Credit
GO

SELECT [__$start_lsn]
      ,[__$end_lsn]
      ,[__$seqval]
	  ,CASE [__$operation]
			WHEN 1 THEN 'Delete'
			WHEN 2 THEN 'Insert'
			WHEN 3 THEN 'Update From Value'
			WHEN 4 THEN 'Update To Value'
	  END AS [operation]
      ,[__$update_mask]
      ,*
  FROM [cdc].[welcome]
GO


