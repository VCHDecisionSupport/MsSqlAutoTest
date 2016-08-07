USE AutoTest
GO

SELECT tab_pro.RecordCount, tab_pro_dim.TableProfileTypeDesc
	,log.TestConfigLogID
	,col_pro.ColumnName
	,col_pro.ColumnCount
	,log.*
	,tab_pro.*
	--,col_pro.ColumnName
	--,col_pro.ColumnCount
	--,col_pro_dim.ColumnProfileTypeDesc
FROM TestConfigLog AS log
JOIN TableProfile AS tab_pro
ON log.TestConfigLogID = tab_pro.TestConfigLogID
JOIN TableProfileType AS tab_pro_dim
ON tab_pro.TableProfileTypeID = tab_pro_dim.TableProfileTypeID
LEFT JOIN ColumnProfile AS col_pro
ON tab_pro.TableProfileID = col_pro.TableProfileID
WHERE log.PreEtlSourceObjectFullName LIKE '%SM_02_DischargeFact%'
--AND tab_pro_dim.TableProfileTypeDesc LIKE 'Pre%'

SELECT *
FROM ColumnProfile AS col_pre

SELECT
	SUM(CASE WHEN post.AccountNum IS NULL THEN 1 ELSE 0 END) AS PreEtlKeyMisMatch
	,SUM(CASE WHEN pre.AccountNum IS NULL THEN 1 ELSE 0 END) AS PostEtlKeyMisMatch
	,SUM(CASE WHEN pre.AccountNum IS NOT NULL AND post.AccountNum IS NOT NULL THEN 1 ELSE 0 END) AS KeyMatch
FROM Lien.Adtc.SM_03_DischargeFact post
FULL JOIN Lien.Adtc.SM_02_DischargeFact pre
ON pre.AccountNum = post.AccountNum
AND pre.PatientID = post.PatientID
