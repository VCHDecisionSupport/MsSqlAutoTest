USE gcDev
GO


DECLARE @CubeName varchar(100), 
	@MeasureName varchar(100),
	@CubeProcessDate datetime
SET @CubeName = 'ReferralEDVisitCube'
SET @MeasureName = 'Active Referrals'

SELECT @CubeProcessDate=MAX(CubeProcessDate)
FROM gcDev.dbo.vwDiff AS vw
WHERE 1=1
AND vw.CubeName = @CubeName
SELECT TOP 1000
	vw.*
FROM gcDev.dbo.vwDiff AS vw
WHERE 1=1
AND vw.CubeName = @CubeName
--AND vw.MeasureName = @MeasureName
AND vw.CubeProcessDate = @CubeProcessDate
--AND vw.DimensionAValue != 2017
AND ABS(vw.AbsDelta) > 0
ORDER BY vw.TestResultDate DESC, ABS(vw.AbsDelta) DESC
