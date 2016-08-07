USE AutoTest
GO

SELECT tab_pro.RecordCount, tab_pro_dim.TableProfileTypeDesc
	,log.*
	,col_pro.ColumnName
	,col_pro.ColumnCount
	,col_pro_dim.ColumnProfileTypeDesc
FROM TestConfigLog AS log
JOIN TableProfile AS tab_pro
ON log.TestConfigLogID = tab_pro.TestConfigLogID
JOIN TableProfileType AS tab_pro_dim
ON tab_pro.TableProfileTypeID = tab_pro_dim.TableProfileTypeID
JOIN ColumnProfile AS col_pro
ON tab_pro.TableProfileID = col_pro.TableProfileID
WHERE log.PreEtlSourceObjectFullName LIKE '%SM_02_DischargeFact%'

--SELECT *
--FROM ColumnProfile AS col_pro
--JOIN ColumnHistogram AS col_hist
--ON col_pro.ColumnProfileID = col_hist.ColumnProfileID


--SELECT *
--FROM ColumnHistogram


-- KeyMatch
SELECT COUNT(*) AS KeyMatch
FROM Lien.Adtc.SM_02_DischargeFact x
JOIN Lien.Adtc.SM_03_DischargeFact y
ON x.AccountNum = y.AccountNum
AND x.PatientID = y.PatientID

-- PreEtlKeyMisMatch
SELECT COUNT(*) AS PreEtlKeyMisMatch
FROM Lien.Adtc.SM_02_DischargeFact PreEtl
LEFT JOIN Lien.Adtc.SM_03_DischargeFact PostEtl
ON PreEtl.AccountNum = PostEtl.AccountNum
AND PreEtl.PatientID = PostEtl.PatientID
WHERE PostEtl.ETLAuditID IS NULL