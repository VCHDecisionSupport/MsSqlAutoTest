USE AutoTest
GO

SELECT tab_pro.RecordCount, tab_pro_dim.TableProfileTypeDesc
	,log.*
	,tab_pro.*
FROM TestConfigLog AS log
JOIN TableProfile AS tab_pro
ON log.TestConfigLogID = tab_pro.TestConfigLogID
JOIN TableProfileType AS tab_pro_dim
ON tab_pro.TableProfileTypeID = tab_pro_dim.TableProfileTypeID

SELECT COUNT(*)
FROM Lien.Adtc.SM_02_DischargeFact x
JOIN Lien.Adtc.SM_03_DischargeFact y
ON x.AccountNum = y.AccountNum
AND x.PatientID = y.PatientID