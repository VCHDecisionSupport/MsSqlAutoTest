USE DQMF
GO
/****** Object:  StoredProcedure [dbo].[SetAuditPkgExecution]    Script Date: 7/21/2016 6:51:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[gcSetAuditPkgExecution] @pPkgExecKey INT = NULL, @pParentPkgExecKey BIGINT = NULL, @pPkgName VARCHAR(100), @pPkgVersionMajor SMALLINT, @pPkgVersionMinor SMALLINT, @pIsProcessStart BIT, @pIsPackageSuccessful BIT, @pPkgExecKeyOut INT OUTPUT, @pDoRegression BIT = 0
AS
	SET NOCOUNT ON;
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
--DECLARE
--            @pPkgExecKey bigint = 312717 -- null
--           ,@pParentPkgExecKey bigint = null
--           ,@pPkgName varchar(100) = 'PopulateCommunityMart'
--           ,@pPkgVersionMajor smallint = 4
--           ,@pPkgVersionMinor smallint = 0
--           ,@pIsProcessStart bit = 0 -- = 1
--           ,@pIsPackageSuccessful bit = 1 -- =NULL
--		   ,@pPkgExecKeyOut int
SET NOCOUNT ON;
BEGIN
	IF @pIsProcessStart = 1
	BEGIN
		IF NOT EXISTS (
				SELECT *
				FROM dbo.ETL_Package
				WHERE PkgName = @pPkgName
				)
		BEGIN
			RAISERROR ('DQMF SetAuditPkgExecution: The package name "%s" does not exist in the DQMF ETL_Package table!', 16, 1, @pPkgName)
			PRINT '' -- sometimes needed due to ssis bug
				--RETURN 1
		END
		INSERT INTO [DQMF].[dbo].[AuditPkgExecution] ([ParentPkgExecKey], [PkgName], [PkgKey], [PkgVersionMajor], [PkgVersionMinor], [ExecStartDT], [ExecStopDT], [IsPackageSuccessful])
		SELECT @pParentPkgExecKey, @pPkgName, PkgID, @pPkgVersionMajor, @pPkgVersionMinor, GETDATE(), NULL, 0
		FROM dbo.ETL_Package
		WHERE PkgName = @pPkgName
		SET @pPkgExecKeyOut = @@IDENTITY
		SET @pPkgExecKey = @pPkgExecKeyOut
	END
	IF @pIsProcessStart = 0
	BEGIN
		UPDATE dbo.AuditPkgExecution
		SET ExecStopDT = GETDATE(), IsPackageSuccessful = @pIsPackageSuccessful
		WHERE PkgExecKey = @pPkgExecKey
	END
END
IF @pDoRegression = 1
BEGIN
	EXEC TestLog.dbo.uspPkgExecAutoTest @pPkgExecKey = @pPkgExecKey, @pIsProcessStart = @pIsProcessStart
END
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

