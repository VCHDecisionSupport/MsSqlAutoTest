USE TestLog
GO

/****** Object:  StoredProcedure [dbo].[SetAuditPkgExecution]    Script Date: 7/21/2016 6:51:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--ALTER PROCEDURE  [dbo].[gcSetAuditPkgExecution]
--            @pPkgExecKey bigint = null
--           ,@pParentPkgExecKey bigint = null
--           ,@pPkgName varchar(100)
--           ,@pPkgVersionMajor smallint
--           ,@pPkgVersionMinor smallint = 0
--           ,@pIsProcessStart bit
--           ,@pIsPackageSuccessful bit
--           ,@pPkgExecKeyOut int output
--AS
DECLARE
            @pPkgExecKey bigint = 312717 -- null
           ,@pParentPkgExecKey bigint = null
           ,@pPkgName varchar(100) = 'PopulateCommunityMart'
           ,@pPkgVersionMajor smallint = 4
           ,@pPkgVersionMinor smallint = 0
           ,@pIsProcessStart bit = 0 -- = 1
           ,@pIsPackageSuccessful bit = 1 -- =NULL
		   ,@pPkgExecKeyOut int
SET NOCOUNT ON;

IF @pIsProcessStart = 1
BEGIN

    IF NOT EXISTS( SELECT *
                FROM DQMF.dbo.ETL_Package
                WHERE PkgName = @pPkgName )
    BEGIN
        RAISERROR( 'DQMF SetAuditPkgExecution: The package name "%s" does not exist in the DQMF ETL_Package table!', 16, 1, @pPkgName )
        PRINT '' -- sometimes needed due to ssis bug
        --RETURN 1
    END
	


     INSERT INTO [DQMF].[dbo].[AuditPkgExecution]
           ([ParentPkgExecKey]
           ,[PkgName]
           ,[PkgKey]
           ,[PkgVersionMajor]
           ,[PkgVersionMinor]
           ,[ExecStartDT]
           ,[ExecStopDT]
           ,[IsPackageSuccessful])
     SELECT @pParentPkgExecKey
           ,@pPkgName
           ,PkgID
           ,@pPkgVersionMajor
           ,@pPkgVersionMinor
           ,GETDATE()
           ,null
           ,0
       FROM DQMF.dbo.ETL_Package
      WHERE PkgName = @pPkgName

    SET @pPkgExecKeyOut = @@IDENTITY





END

IF @pIsProcessStart = 0
BEGIN

    UPDATE  DQMF.dbo.AuditPkgExecution
       SET ExecStopDT = GETDATE()
           ,IsPackageSuccessful = @pIsPackageSuccessful
     WHERE PkgExecKey = @pPkgExecKey
END




--#region gcwashere
-- take snap shots
BEGIN
	DECLARE @pkgID int,
		@dataDesc varchar(300);
	SELECT @pkgID = PkgID
	FROM DQMF.dbo.ETL_Package
	WHERE PkgName = @pPkgName

	IF @pIsProcessStart = 1
	BEGIN
		SET @pPkgExecKey=@pPkgExecKeyOut
		--Populate TestConfig table from DataRequestTestConfig
		EXEC TestLog.dbo.uspInsTestConfig 
			@pPkgId = @pkgId
			,@pPkgExecKey = @pPkgExecKey
			,@pTestTypeDesc = 'Regression'

	END
	IF @pIsProcessStart = 0
		SET @pPkgExecKey=@pPkgExecKey


	
	SELECT @dataDesc = DataDescPrefix FROM TestLog.dbo.DataDesc WHERE IsProcessStart = @pIsProcessStart;
	
	RAISERROR('@dataDesc: %s', 0, 1, @dataDesc) WITH NOWAIT;


	

	

	BEGIN 
		DECLARE cur CURSOR
		FOR
		SELECT DISTINCT 
			db.DatabaseName
			,obj.ObjectSchemaName
			,obj.ObjectPhysicalName
			,obj.ObjectID
			,config.TestConfigID
			,config.DataRequestID
			,config.PkgID
		FROM TestLog.dbo.TestConfig AS config
		JOIN DQMF.dbo.MD_Object AS obj
		ON config.ObjectID = obj.ObjectID
		JOIN DQMF.dbo.MD_Database AS db
		ON obj.DatabaseId = db.DatabaseId
		WHERE PkgExecKey = @pPkgExecKey;

		DECLARE @databaseName varchar(100),
			@schemaName varchar(100),
			@tableName varchar(100),
			@objectID int,
			@testConfigID int,
			@dataRequestID int,
			@tableProfileID int,
			@snapShotName varchar(100);

		OPEN cur;

		FETCH NEXT FROM cur INTO @databaseName, @schemaName, @tableName, @objectID, @testConfigID, @dataRequestID, @pkgID;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			RAISERROR('

Regression Testing: %s.%s.%s',0,1,@databaseName, @schemaName, @tableName) WITH NOWAIT;
			--EXEC DQMF.dbo.SetMDObjectAttribute @pObjectID = @objectID
			SELECT @snapShotName = TestLog.dbo.ufnGetSnapShotName(@dataDesc,@dataRequestID, @tableName, @pPkgExecKey, NULL);
			--EXEC TestLog.dbo.uspCreateMDObjectSnapShot @pObjectID = @objectID, @pDestTableName = @snapShotName;
			RAISERROR('  uspCreateSnapShot complete', 0, 1) WITH NOWAIT;
			--EXEC TestLog.dbo.uspCreateProfile @pTestConfigID = @testConfigID, @pTargetTableName = @snapShotName, @pDataDesc = @dataDesc;
			RAISERROR('uspCreateProfile complete', 0, 1) WITH NOWAIT;
			FETCH NEXT FROM cur INTO @databaseName, @schemaName, @tableName, @objectID, @testConfigID, @dataRequestID, @pkgID;
		END

		CLOSE cur;
		DEALLOCATE cur;

		-- do regression test
		IF @pIsProcessStart = 0
		BEGIN
			-- get snapShot table names...
			DECLARE @preEtlSnapPrefix nvarchar(100);
			SELECT @preEtlSnapPrefix=DataDescPrefix FROM TestLog.dbo.DataDesc WHERE IsProcessStart = 1;
			DECLARE @preEtlSnapName nvarchar(100) = TestLog.dbo.ufnGetSnapShotName(@preEtlSnapPrefix,@dataRequestID, @tableName, @pPkgExecKey, NULL)
				,@postEtlSnapName nvarchar(100) = @snapShotName
			
			DECLARE @RecordMatchViewDataDescPrefix nvarchar(100);
			SELECT @RecordMatchViewDataDescPrefix=DataDescPrefix FROM TestLog.dbo.DataDesc WHERE DataDescLong LIKE 'RecordMatch'
			DECLARE @RecordMatchViewName nvarchar(100);
			SELECT @RecordMatchViewName = TestLog.dbo.ufnGetSnapShotName(@RecordMatchViewDataDescPrefix,@dataRequestID, @tableName, @pPkgExecKey, NULL);
			RAISERROR('@RecordMatchViewName = %s',0,1,@RecordMatchViewName);
			DECLARE @sql nvarchar(max);
			
			DECLARE @cols varchar(max) = ''
			SELECT @cols = TestLog.dbo.ufnGetColumnNames(@objectID)
			RAISERROR('@cols = %s',0,1,@cols);
			DECLARE @pkField nvarchar(200);
			SELECT @pkField=obj.ObjectPKField FROM DQMF.dbo.MD_Object AS obj WHERE 1=1 AND ObjectID = @objectID;
			RAISERROR('@pkField = %s',0,1,@pkField);

			SET @sql = FORMATMESSAGE('
			SELECT 
				%s 
			FROM TestLog.SnapShot.%s 
			INTERSECT 
			SELECT 
				%s 
			FROM TestLog.SnapShot.%s', @cols,@preEtlSnapName, @cols, @postEtlSnapName)
			RAISERROR('@sql = %s',0,1,@sql);
			EXEC uspCreateQuerySnapShot @sql, @pPkField=@pkField, @pDestTableName=@RecordMatchViewName

			EXEC TestLog.dbo.uspCreateProfile @pTestConfigID = @testConfigID, @pTargetTableName = @RecordMatchViewName, @pDataDesc = @RecordMatchViewDataDescPrefix;




			SET @sql = FORMATMESSAGE('
			SELECT 
				%s 
			FROM TestLog.SnapShot.%s AS pre
			INNER JOIN TestLog.SnapShot.%s AS post
			pre.__pkhash__ = post.__pkhash__
', @cols,@preEtlSnapName, @postEtlSnapName)
			RAISERROR('@sql = %s',0,1,@sql);
			EXEC uspCreateQuerySnapShot @sql, @pPkField=@pkField, @pDestTableName=@RecordMatchViewName

			EXEC TestLog.dbo.uspCreateProfile @pTestConfigID = @testConfigID, @pTargetTableName = @RecordMatchViewName, @pDataDesc = @RecordMatchViewDataDescPrefix;



		END

	END
END



--#endregion gcwashere












--SELECT @pPkgExecKeyOut PkgExecKey

/*
DEClaRE @pPkgExecKeyout  bigint

exec [SetAuditPkgExecution]
            @pPkgExecKey = null
           ,@pParentPkgExecKey = null
           ,@pPkgName = 'EmergencyPCIST1Parent'
           ,@pPkgVersionMajor = 1
           ,@pPkgVersionMinor  = 1
           ,@pIsProcessStart  = 1
           ,@pIsPackageSuccessful  = 0
           ,@pPkgExecKeyout  = @pPkgExecKeyout   output

SELECT @pPkgExecKeyout


*/


GO


