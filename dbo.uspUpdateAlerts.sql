USE AutoTest
GO


IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.uspUpdateAlerts') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	EXEC ('CREATE PROCEDURE dbo.uspUpdateAlerts AS');
END
GO

/****** Object:  StoredProcedure dbo.uspUpdateAlerts   DR0000 Graham Crowell 2016-01-00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON 
GO
ALTER PROCEDURE dbo.uspUpdateAlerts
	@pProfileID int
AS
BEGIN
	PRINT('dbo.uspUpdateAlerts @pProfileID='+CAST(@pProfileID AS varchar)+';')
	
END
GO