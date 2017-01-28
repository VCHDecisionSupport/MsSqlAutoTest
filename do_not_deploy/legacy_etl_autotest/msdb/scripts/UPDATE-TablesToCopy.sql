USE msdb
GO

UPDATE msdb.dbo.TablesToCopy
SET IsActive = 0
FROM msdb.dbo.TablesToCopy AS tbl
WHERE tbl.ObjectPhysicalName IN ('MD_Object', 'MD_ObjectAttribute')
AND tbl.ObjectDBName = 'DQMF'