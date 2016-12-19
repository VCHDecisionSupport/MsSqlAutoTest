--#region CREATE/ALTER PROC
USE DSDW
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspToCreateView';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspToCreateView
	@pUserSql varchar(max)
	,@pViewName varchar(max) = NULL
	,@pViewSqlOut varchar(max) OUTPUT
AS
BEGIN
	RAISERROR('dbo.uspToCreateView',0,1) WITH NOWAIT;
	BEGIN TRY
		IF @pViewName IS NULL
		BEGIN
			RAISERROR('WARNING: @pViewName IS NULL',10,1) WITH NOWAIT;
			SET @pViewName = 'NoName1'
		END
		SET @pViewSqlOut = FORMATMESSAGE('CREATE VIEW %s AS %s;',@pViewName, @pUserSql);
		--RAISERROR(@pUserSql,0,1) WITH NOWAIT;
		EXEC(@pViewSqlOut);
	END TRY
	BEGIN CATCH
		SELECT 
			ERROR_NUMBER() AS ErrorNumber,  
			ERROR_SEVERITY() AS ErrorSeverity,  
			ERROR_STATE() AS ErrorState,  
			ERROR_PROCEDURE() AS ErrorProcedure,  
			ERROR_MESSAGE() AS ErrorMessage;  
	END CATCH
END
GO
--#endregion CREATE/ALTER PROC
DECLARE @UserSql varchar(max);
DECLARE @SqlView varchar(max);
SET @UserSql = 'Select * from sys.columns'
EXEC dbo.uspToCreateView @pUserSql=@UserSql, @pViewSqlOut=@SqlView OUT
PRINT @SqlView;
