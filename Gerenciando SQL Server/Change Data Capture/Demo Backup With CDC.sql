-- Take a backup of the CDC enabled database
BACKUP DATABASE [Credit] TO DISK = N'C:\TEMP\CreditBackup_PSDemo.bak'

WITH INIT,
	NAME = N'Credit-Full Database Backup for Pluralsight Demos',
	COMPRESSION,
	STATS = 10,
	CHECKSUM;
GO

-- Restore the database as Credit_CDCKeep using the UI first

-- Check CDC enabled bit in sys.databases (Since the backup had with recovery, it will be disabled)
SELECT database_id, name, is_cdc_enabled
FROM sys.databases
WHERE name = N'Credit_CDCKeep';
GO


-- Now restore database as Credit_CDCKeep using TSQL and KEEP_CDC option
RESTORE DATABASE [Credit_CDCKeep]
FROM DISK = N'C:\TEMP\CreditBackup_PSDemo.bak'
WITH FILE = 1,
	REPLACE,
	STATS = 5,
	KEEP_CDC;
GO

-- Check CDC enabled bit in sys.databases
SELECT database_id, name, is_cdc_enabled
FROM sys.databases
WHERE name = N'Credit_CDCKeep';
GO

 --all that is nedeed later is to call sp_cdc_add_job
