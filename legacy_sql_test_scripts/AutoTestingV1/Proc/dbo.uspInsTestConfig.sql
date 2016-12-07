USE TestLog
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspInsTestConfig';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspInsTestConfig
	@pPkgId int
	,@pPkgExecKey int
AS
BEGIN
	RAISERROR('uspInsTestConfig: PkgID: %i (PkgExecKey: %i)', 0, 1, @pPkgId, @pPkgExecKey) WITH NOWAIT;

	INSERT INTO dbo.TestConfig
	(
		DataRequestTestConfigID
		,DataRequestID
		,PkgID
		,ObjectID
		,PkgExecKey
		,TestTypeID
	)
	SELECT 
		config.DataRequestTestConfigID
		,config.DataRequestID
		,config.PkgID
		,config.ObjectID
		,@pPkgExecKey
		,1
	FROM TestLog.dbo.DataRequestTestConfig AS config
	JOIN DQMF.dbo.ETL_Package AS pkg
	ON config.PkgID = pkg.PkgID
	JOIN DQMF.dbo.MD_Object AS obj
	ON config.ObjectID = obj.ObjectID
	JOIN DQMF.dbo.MD_Database AS db
	ON obj.DatabaseId = db.DatabaseId
	WHERE pkg.PkgID = @pPkgId



	INSERT INTO dbo.TestConfig
	(
		DataRequestTestConfigID
		,DataRequestID
		,PkgID
		,ObjectID
		,PkgExecKey
		,TestTypeID
	)
	SELECT 
		DISTINCT
		--config.DataRequestTestConfigID
		--,config.DataRequestID
		NULL
		,NULL
		,config.PkgID
		,config.ObjectID
		,@pPkgExecKey
		,1
	FROM DQMF.dbo.ETL_PackageObject AS config
	JOIN DQMF.dbo.ETL_Package AS pkg
	ON config.PkgID = pkg.PkgID
	JOIN DQMF.dbo.MD_Object AS obj
	ON config.ObjectID = obj.ObjectID
	JOIN DQMF.dbo.MD_Database AS db
	ON obj.DatabaseId = db.DatabaseId
	WHERE pkg.PkgID = @pPkgId

	DECLARE @TestConfigID int = @@identity;
	RAISERROR('uspInsTestConfig: TestConfigID: %i', 0, 1, @TestConfigID) WITH NOWAIT;
	--;WITH src AS (

	--	SELECT 
	--		config.DataRequestTestConfigID
	--		,config.DataRequestID
	--		,config.PkgID
	--		,config.ObjectID
	--		--,@pPkgExecKey
	--		--,@pTestTypeDesc
	--	FROM dbo.DataRequestTestConfig AS config
	--	JOIN DQMF.dbo.ETL_Package AS pkg
	--	ON config.PkgID = pkg.PkgID
	--	JOIN DQMF.dbo.MD_Object AS obj
	--	ON config.ObjectID = obj.ObjectID
	--	JOIN DQMF.dbo.MD_Database AS db
	--	ON obj.DatabaseId = db.DatabaseId
	--	WHERE pkg.PkgID = @pPkgId
	--)
	--MERGE INTO dbo.TestConfig AS dst

END
GO

-- DECLARE @pPkgId int = 291
-- 	,@pPkgExecKey int = 1
-- 	,@pTestTypeDesc varchar(100) = 'hi there'

-- EXEC dbo.uspInsTestConfig 
-- 	@pPkgId = @pPkgId
-- 	,@pPkgExecKey = @pPkgExecKey
-- 	,@pTestTypeDesc = @pTestTypeDesc

-- GO

-- SELECT *
-- FROM dbo.TestConfig