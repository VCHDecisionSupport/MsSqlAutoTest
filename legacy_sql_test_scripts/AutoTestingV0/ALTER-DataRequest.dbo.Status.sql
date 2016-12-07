USE gcDataRequest
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE OBJECT_NAME(object_id) = 'Status' AND name = 'TargetServer')
ALTER TABLE Status ADD TargetServer varchar(100);
GO

UPDATE Status
SET TargetServer = 'STDBDECSUP01'
FROM Status AS st
WHERE st.status LIKE '%Test%'
GO