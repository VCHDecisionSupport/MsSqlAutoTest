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
JOIN ColumnProfileType AS col_pro_dim
ON col_pro.ColumnProfileTypeID = col_pro_dim.ColumnProfileTypeID

SELECT *
FROM ColumnProfile AS col_pro
JOIN ColumnHistogram AS col_hist
ON col_pro.ColumnProfileID = col_hist.ColumnProfileID


SELECT *
FROM ColumnHistogram

SELECT COUNT(*)
FROM Lien.Adtc.SM_02_DischargeFact x
JOIN Lien.Adtc.SM_03_DischargeFact y
ON x.AccountNum = y.AccountNum
AND x.PatientID = y.PatientID