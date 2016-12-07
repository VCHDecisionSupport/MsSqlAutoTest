USE DSDW
GO

DECLARE @pPreEtlDatabaseName varchar(500);
DECLARE @pPreEtlSchemaName varchar(500);
DECLARE @pPreEtlTableName varchar(500);
DECLARE @pPostEtlDatabaseName varchar(500);
DECLARE @pPostEtlSchemaName varchar(500);
DECLARE @pPostEtlTableName varchar(500);
DECLARE @pObjectPkColumns varchar(500);


EXEC AutoTest.dbo.uspAdHocDataCompare
	@pPreEtlDatabaseName = @pPreEtlDatabaseName
	,@pPreEtlSchemaName = @pPreEtlSchemaName
	,@pPreEtlTableName = @pPreEtlTableName
	,@pPostEtlDatabaseName = @pPostEtlDatabaseName
	,@pPostEtlSchemaName = @pPostEtlSchemaName
	,@pPostEtlTableName = @pPostEtlTableName
	,@pObjectPkColumns = @pObjectPkColumns
