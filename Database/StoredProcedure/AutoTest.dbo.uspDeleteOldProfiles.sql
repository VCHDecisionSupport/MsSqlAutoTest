USE AutoTest
GO

/*
2017-02-27 Graham Crowell DR9581 initial deployment
*/

IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.uspDeleteOldProfiles') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	EXEC ('CREATE PROCEDURE dbo.uspDeleteOldProfiles AS');
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON 
GO
ALTER PROCEDURE dbo.uspDeleteOldProfiles
	@pNumberOfProfilesToKeep int = 5
AS
BEGIN
	PRINT('dbo.uspDeleteOldProfiles @pNumberOfProfilesToKeep='+CAST(@pNumberOfProfilesToKeep AS varchar)+';')

	DECLARE @profile_id int;

	DECLARE profile_cur CURSOR LOCAL
	FOR
	SELECT ProfileID
	FROM AutoTest.dbo.vwProfileAge
	WHERE ProfileRelativeAge > @pNumberOfProfilesToKeep

	OPEN profile_cur;

	FETCH NEXT FROM profile_cur INTO 
		@profile_id

	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT('DELETE ProfileID = '+CAST(@profile_id AS varchar))

		DELETE AutoTest.dbo.TableProfile WHERE ProfileID = @profile_id;
		DELETE AutoTest.dbo.ColumnProfile WHERE ProfileID = @profile_id;
		DELETE AutoTest.dbo.ColumnHistogram WHERE ProfileID = @profile_id;

		FETCH NEXT FROM profile_cur INTO @profile_id
	END

	CLOSE profile_cur;
	DEALLOCATE profile_cur;
END
GO

-- dbo.uspDeleteOldProfiles @pNumberOfProfilesToKeep=5;