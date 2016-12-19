PRINT '
	executing sqlcmd_deployment.sql with variable pathvar $(pathvar)'

USE master
GO

DECLARE @path varchar(500) = '$(pathvar)'
PRINT @path

:r $(pathvar)\TestLog.sql
:r $(pathvar)\Table\dbo.KeyColumn.sql
:r $(pathvar)\Table\dbo.KeyComparison.sql
:r $(pathvar)\Table\dbo.ValueColumn.sql
:r $(pathvar)\Table\dbo.ValueComparison.sql
:r $(pathvar)\Constraint\ForeignKey.sql

:r $(pathvar)\View\vwKeyColumn.sql
:r $(pathvar)\View\vwValueColumn.sql

:r $(pathvar)\StoredProcedure\dbo.uspInsTableCompare.sql

-- :r $(pathvar)\Function\???.sql

:r $(pathvar)\Permissions.sql
:r $(pathvar)\unittests.sql
