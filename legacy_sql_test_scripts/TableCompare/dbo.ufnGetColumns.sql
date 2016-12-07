
USE [DSDW]
GO

IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.uspGetViewSql') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	EXEC ('CREATE PROCEDURE dbo.uspGetViewSql AS');
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE dbo.uspGetViewSql
	@pQuerySql varchar(max),
	@pDebug tinyint = 0
AS
BEGIN 
	SET ANSI_NULLS ON;
	SET NOCOUNT ON;
	IF @pDebug > 0 RAISERROR( 'dbo.uspGetViewSql:', 0, 1) WITH NOWAIT;

	DECLARE @sql nvarchar(max);
	DECLARE @params nvarchar(max);

	SET @sql = 'CREATE VIEW tmp AS '+@pQuerySql
	EXEC(@sql);
END
GO


EXEC dbo.uspGetViewSql 'SELECT * FROM sys.columns'

SELECT *
FROM sys.columns
WHERE OBJECT_ID('tmp','V') = object_id