USE [DQMF]
GO

/****** Object:  StoredProcedure [dbo].[SetAuditPkgExecution]    Script Date: 8/12/2016 12:02:59 AM ******/
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
	 -- gcwashere AutoTest...
	 EXEC AutoTest.dbo.uspInitPkgRegression @pPkgExecKey = @pPkgExecKeyOut;
END

IF @pIsProcessStart = 0
BEGIN

    UPDATE  dbo.AuditPkgExecution
       SET ExecStopDT = GETDATE()
           ,IsPackageSuccessful = @pIsPackageSuccessful
     WHERE PkgExecKey = @pPkgExecKey
	 -- gcwashere AutoTest...
	 EXEC AutoTest.dbo.uspInitPkgRegression @pPkgExecKey = @pPkgExecKey;
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


GO


