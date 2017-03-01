USE DQMF
GO

/****** Object:  StoredProcedure [dbo].[SetAuditPkgExecution]    Script Date: 12/15/2016 12:55:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE  [dbo].[SetAuditPkgExecution]
            @pPkgExecKey bigint = null
           ,@pParentPkgExecKey bigint = null
           ,@pPkgName varchar(100)
           ,@pPkgVersionMajor smallint
           ,@pPkgVersionMinor smallint = 0
           ,@pIsProcessStart bit
           ,@pIsPackageSuccessful bit
           ,@pPkgExecKeyOut int output
AS
SET NOCOUNT ON;

IF @pIsProcessStart = 1
BEGIN

    IF NOT EXISTS( SELECT *
                FROM dbo.ETL_Package
                WHERE PkgName = @pPkgName )
    BEGIN
        RAISERROR( 'DQMF SetAuditPkgExecution: The package name "%s" does not exist in the DQMF ETL_Package table!', 16, 1, @pPkgName )
        PRINT '' -- sometimes needed due to ssis bug
        RETURN 1
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
       FROM dbo.ETL_Package
      WHERE PkgName = @pPkgName

    SET @pPkgExecKeyOut = @@IDENTITY

	
END

IF @pIsProcessStart = 0
BEGIN

    UPDATE  dbo.AuditPkgExecution
       SET ExecStopDT = GETDATE()
           ,IsPackageSuccessful = @pIsPackageSuccessful
     WHERE PkgExecKey = @pPkgExecKey

	----------------------------------------------------
	-- AutoTest changes start
	/*
	2017-02-27 Graham Crowell DR9581 initial deployment
	*/
	DECLARE @PackagePath varchar(500);
	-- look in msdb for path of package:
	SELECT @PackagePath=PackageFullPath
	FROM msdb.dbo.vwPackagePath
	WHERE PackageName = @pPkgName

	IF(@PackagePath IS NOT NULL)
	BEGIN
		-- run C# executable here to populate AutoTest.Map.PackageTable
		DECLARE @cmd VARCHAR(500) = 'C:\\shared\\PackageTableMapper.exe "'+@PackagePath+'"';
		DECLARE @result int;  
		PRINT 'executing: xp_cmdshell '+@cmd;
		EXEC @result = xp_cmdshell @cmd, NO_OUTPUT
		IF (@result = 0)  
			PRINT CHAR(9)+'SUCCESS executing: '+@cmd
		ELSE  
			PRINT CHAR(9)+'ERROR executing command: '+@cmd+CHAR(13)+'Check if C:\\shared\\PackageTableMapper.exe exists; look at error log file: C:\\shared\\PackageTableMapper_ErrorLog.txt;  rerun command from server cmd'
	END
	ELSE 
	BEGIN
		PRINT CHAR(9)+'WARNING: msdb Package path for '+@pPkgName+' not found in msdb.dbo.vwPackagePath'
	END
	EXEC AutoTest.dbo.uspProfilePackageTables @pPackageName=@pPkgName,@pPkgExecKey=@pPkgExecKey;
	-- AutoTest changes end
	----------------------------------------------------


END

SELECT @pPkgExecKeyOut PkgExecKey

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
-- 
