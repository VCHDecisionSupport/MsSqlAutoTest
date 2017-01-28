USE AutoTest
GO

DECLARE @ColumnName varchar(100) = 'AttendDrID'
DECLARE @ColumnHistogramTypeDesc varchar(100) = 'KeyMatchValueMatchColumnHistogram'

--;WITH actual AS (
--SELECT CAST(pre.AttendDrID AS varchar) AS ColumnValue, COUNT(*) AS ValueCount
--FROM Lien.Adtc.SM_02_DischargeFact pre
--JOIN Lien.Adtc.SM_03_DischargeFact post
--ON pre.AccountNum = post.AccountNum
--AND pre.PatientID = post.PatientID
--WHERE 1=1
--AND pre.AttendDrID = post.AttendDrID
--GROUP BY CAST(pre.AttendDrID AS varchar) 
--), autotest AS (


--SELECT  
--	tab_pro_dim.TableProfileTypeDesc
--	,col_pro.ColumnName
--	,col_pro.ColumnCount
--	,col_hist_dim.ColumnHistogramTypeDesc
--	,col_hist.ColumnValue
--	,col_hist.ValueCount
--FROM TestConfig AS log
--JOIN TableProfile AS tab_pro
--ON log.TestConfigID = tab_pro.TestConfigID
--JOIN TableProfileType AS tab_pro_dim
--ON tab_pro.TableProfileTypeID = tab_pro_dim.TableProfileTypeID
--JOIN ColumnProfile AS col_pro
--ON tab_pro.TableProfileID = col_pro.TableProfileID
--JOIN ColumnProfileType AS col_pro_dim
--ON col_pro.ColumnProfileTypeID = col_pro_dim.ColumnProfileTypeID
--JOIN ColumnHistogram AS col_hist
--ON col_pro.ColumnProfileID = col_hist.ColumnProfileID
--JOIN ColumnHistogramType AS col_hist_dim
--ON col_hist.ColumnHistogramTypeID = col_hist_dim.ColumnHistogramTypeID
--WHERE 1=1
--AND col_pro.ColumnName = @ColumnName
--AND col_hist_dim.ColumnHistogramTypeDesc = @ColumnHistogramTypeDesc
--)
--SELECT *
--FROM actual
--JOIN autotest
--ON actual.ColumnValue = autotest.ColumnValue


--SET @ColumnHistogramTypeDesc = 'PreEtlKeyMatchValueMisMatchColumnHistogram'

--;WITH actual AS (
--SELECT CAST(post.AttendDrID AS varchar) AS ColumnValue, COUNT(*) AS ValueCount_actual
--FROM Lien.Adtc.SM_02_DischargeFact pre
--JOIN Lien.Adtc.SM_03_DischargeFact post
--ON pre.AccountNum = post.AccountNum
--AND ISNULL(pre.PatientID, -1) = ISNULL(post.PatientID, -1)
--WHERE 1=1
--AND pre.AttendDrID != post.AttendDrID
--GROUP BY CAST(post.AttendDrID AS varchar) 
--), autotest AS (


--SELECT  
--	tab_pro_dim.TableProfileTypeDesc
--	,col_pro.ColumnName
--	,col_pro.ColumnCount
--	,col_hist_dim.ColumnHistogramTypeDesc
--	,col_hist.ColumnValue
--	,col_hist.ValueCount
--FROM TestConfig AS log
--JOIN TableProfile AS tab_pro
--ON log.TestConfigID = tab_pro.TestConfigID
--JOIN TableProfileType AS tab_pro_dim
--ON tab_pro.TableProfileTypeID = tab_pro_dim.TableProfileTypeID
--JOIN ColumnProfile AS col_pro
--ON tab_pro.TableProfileID = col_pro.TableProfileID
--JOIN ColumnProfileType AS col_pro_dim
--ON col_pro.ColumnProfileTypeID = col_pro_dim.ColumnProfileTypeID
--JOIN ColumnHistogram AS col_hist
--ON col_pro.ColumnProfileID = col_hist.ColumnProfileID
--JOIN ColumnHistogramType AS col_hist_dim
--ON col_hist.ColumnHistogramTypeID = col_hist_dim.ColumnHistogramTypeID
--WHERE 1=1
--AND col_pro.ColumnName = @ColumnName
--AND col_hist_dim.ColumnHistogramTypeDesc = @ColumnHistogramTypeDesc
--)
--SELECT *
--FROM actual
--JOIN autotest
--ON actual.ColumnValue = autotest.ColumnValue


--SELECT CAST(pre.AttendDrID AS varchar) AS ColumnValue, COUNT(*) AS ValueCount_actual
--FROM Lien.Adtc.SM_02_DischargeFact pre
--JOIN Lien.Adtc.SM_03_DischargeFact post
--ON pre.AccountNum = post.AccountNum
--AND pre.PatientID = post.PatientID
--WHERE 1=1
--AND pre.AttendDrID != post.AttendDrID
--AND pre.AttendDrID = '3180'
--GROUP BY pre.AttendDrID


--SELECT 
--	pre_AttendDrID
--	,COUNT(*)
--FROM AutoTest.SnapShot.KeyMatch_TestConfigID10
--WHERE pre_AttendDrID != post_AttendDrID
--GROUP BY pre_AttendDrID


;WITH misval AS (

SELECT 
	pre_AttendDrID
	,post_AttendDrID
FROM AutoTest.SnapShot.KeyMatch_TestConfigID7 merged
--WHERE pre_AttendDrID != post_AttendDrID
WHERE ISNULL(merged.pre_AttendDrID,-1)<>ISNULL(merged.post_AttendDrID,-1)
), pre AS (
	SELECT COUNT(*) AS ValueCount, 'pre' AS Etl
		,pre_AttendDrID AS AttendDrID
	FROM misval
	GROUP BY pre_AttendDrID
), post AS (
SELECT COUNT(*) AS ValueCount, 'post' AS Etl
		,post_AttendDrID AS AttendDrID
	FROM misval
	GROUP BY post_AttendDrID
), both AS (
SELECT *
FROM pre
UNION
SELECT *
FROM post
)
SELECT *
FROM both
ORDER BY CAST(both.AttendDrID AS varchar) 


SELECT CAST(pre.AttendDrID AS varchar) AS ColumnValue, COUNT(*) AS ValueCount
FROM Lien.Adtc.SM_03_DischargeFact pre
JOIN Lien.Adtc.SM_02_DischargeFact post
ON pre.AccountNum = post.AccountNum
AND pre.PatientID = post.PatientID
WHERE 1=1
--AND pre.AttendDrID != post.AttendDrID
AND ISNULL(pre.AttendDrID,-1) != ISNULL(post.AttendDrID,-1)
GROUP BY CAST(pre.AttendDrID AS varchar)

SELECT CAST(post.AttendDrID AS varchar) AS ColumnValue, COUNT(*) AS ValueCount
FROM Lien.Adtc.SM_03_DischargeFact pre
JOIN Lien.Adtc.SM_02_DischargeFact post
ON pre.AccountNum = post.AccountNum
AND pre.PatientID = post.PatientID
WHERE 1=1
--AND pre.AttendDrID != post.AttendDrID
AND ISNULL(pre.AttendDrID,-1) != ISNULL(post.AttendDrID,-1)
GROUP BY CAST(post.AttendDrID AS varchar)

SELECT COUNT(*),pre_AttendDrID
	--pre_AttendDrID
	--,post_AttendDrID
FROM AutoTest.SnapShot.KeyMatch_TestConfigID7 merged
WHERE 1=1
AND ISNULL(merged.pre_AttendDrID,-1)<>ISNULL(merged.post_AttendDrID,-1)
--AND pre_AttendDrID != post_AttendDrID
GROUP BY pre_AttendDrID

SELECT COUNT(*),post_AttendDrID
	--pre_AttendDrID
	--,post_AttendDrID
FROM AutoTest.SnapShot.KeyMatch_TestConfigID7 merged
WHERE 1=1
AND ISNULL(merged.pre_AttendDrID,-1)<>ISNULL(merged.post_AttendDrID,-1)
--AND pre_AttendDrID != post_AttendDrID
GROUP BY post_AttendDrID

