
USE AutoTest
GO

DECLARE @PreEtlSourceObjectFullName varchar(200) = 'Lien.Adtc.SM_02_DischargeFact'
DECLARE @PostEtlSourceObjectFullName varchar(200) = 'Lien.Adtc.SM_03_DischargeFact'
--#region TableProfile
SELECT tab_pro.RecordCount, tab_pro_dim.TableProfileTypeDesc
	,log.TestConfigID
	,log.*
	,tab_pro.*
	--,col_pro.ColumnName
	--,col_pro.ColumnCount
	--,col_pro_dim.ColumnProfileTypeDesc
FROM TestConfig AS log
JOIN TableProfile AS tab_pro
ON log.TestConfigID = tab_pro.TestConfigID
JOIN TableProfileType AS tab_pro_dim
ON tab_pro.TableProfileTypeID = tab_pro_dim.TableProfileTypeID
WHERE 1=1
AND log.PreEtlSourceObjectFullName = @PreEtlSourceObjectFullName
AND log.PreEtlSourceObjectFullName = @PreEtlSourceObjectFullName

SELECT
	SUM(CASE WHEN post.AccountNum IS NULL THEN 1 ELSE 0 END) AS PreEtlKeyMisMatch
	,SUM(CASE WHEN pre.AccountNum IS NULL THEN 1 ELSE 0 END) AS PostEtlKeyMisMatch
	,SUM(CASE WHEN pre.AccountNum IS NOT NULL AND post.AccountNum IS NOT NULL THEN 1 ELSE 0 END) AS KeyMatch
FROM Lien.Adtc.SM_03_DischargeFact post
FULL JOIN Lien.Adtc.SM_02_DischargeFact pre
ON pre.AccountNum = post.AccountNum
AND pre.PatientID = post.PatientID
--#endregion TableProfile

--#region ColumnProfile
SELECT tab_pro.RecordCount, tab_pro_dim.TableProfileTypeDesc
	,log.TestConfigID
	,col_pro.ColumnName
	,col_pro.ColumnCount
	,col_pro_dim.ColumnProfileTypeDesc
FROM TestConfig AS log
JOIN TableProfile AS tab_pro
ON log.TestConfigID = tab_pro.TestConfigID
JOIN TableProfileType AS tab_pro_dim
ON tab_pro.TableProfileTypeID = tab_pro_dim.TableProfileTypeID
JOIN ColumnProfile AS col_pro
ON tab_pro.TableProfileID = col_pro.TableProfileID
JOIN ColumnProfileType AS col_pro_dim
ON col_pro.ColumnProfileTypeID = col_pro_dim.ColumnProfileTypeID
WHERE 1=1
AND log.PreEtlSourceObjectFullName = @PreEtlSourceObjectFullName
AND log.PreEtlSourceObjectFullName = @PreEtlSourceObjectFullName


SELECT 
COUNT(DISTINCT pre.SourceSystemCode) AS SourceSystemCode
,COUNT(DISTINCT pre.AccountNum) AS AccountNum
,COUNT(DISTINCT pre.MRN) AS MRN
,COUNT(DISTINCT pre.PatientID) AS PatientID
,COUNT(DISTINCT pre.PatientServiceID) AS PatientServiceID
,COUNT(DISTINCT pre.AccountTypeID) AS AccountTypeID
,COUNT(DISTINCT pre.DischargeLocationID) AS DischargeLocationID
,COUNT(DISTINCT pre.NursingUnitID) AS NursingUnitID
,COUNT(DISTINCT pre.Bed) AS Bed
,COUNT(DISTINCT pre.Room) AS Room
,COUNT(DISTINCT pre.DischargeDateID) AS DischargeDateID
,COUNT(DISTINCT pre.DischargeTimeID) AS DischargeTimeID
,COUNT(DISTINCT pre.AdmissionDateID) AS AdmissionDateID
,COUNT(DISTINCT pre.AdmissionTimeID) AS AdmissionTimeID
,COUNT(DISTINCT pre.DischargeDispositionID) AS DischargeDispositionID
,COUNT(DISTINCT pre.FacilityID) AS FacilityID
,COUNT(DISTINCT pre.PatientTeamID) AS PatientTeamID
,COUNT(DISTINCT pre.InfectiousDiseaseID) AS InfectiousDiseaseID
,COUNT(DISTINCT pre.AttendDrID) AS AttendDrID
,COUNT(DISTINCT pre.IsTrauma) AS IsTrauma
,COUNT(DISTINCT pre.AcctSubTypeID) AS AcctSubTypeID
,COUNT(DISTINCT pre.AlertId) AS AlertId
,COUNT(DISTINCT pre.ReadmissionRiskFlagID) AS ReadmissionRiskFlagID
,COUNT(DISTINCT pre.LastUpdateDT) AS LastUpdateDT
,COUNT(DISTINCT pre.Payor1ID) AS Payor1ID
,COUNT(DISTINCT pre.Payor2ID) AS Payor2ID
,COUNT(DISTINCT pre.Payor3ID) AS Payor3ID
,COUNT(DISTINCT pre.Guarantor) AS Guarantor
FROM Lien.Adtc.SM_02_DischargeFact pre
LEFT JOIN Lien.Adtc.SM_03_DischargeFact post
ON pre.AccountNum = post.AccountNum
AND pre.PatientID = post.PatientID
WHERE post.AccountNum IS NULL
--#endregion ColumnProfile

--#region ColumnHistogram
DECLARE @ColumnName varchar(100) = 'AdmissionDateID'
DECLARE @ColumnHistogramTypeDesc varchar(200) = 'PreEtlKeyMisMatchColumnHistogram'

SELECT tab_pro.RecordCount, tab_pro_dim.TableProfileTypeDesc
	,log.TestConfigID
	,col_pro.ColumnName
	,col_pro.ColumnCount
	,col_pro_dim.ColumnProfileTypeDesc
	,col_hist.ColumnValue
	,col_hist.ValueCount
	,col_hist_dim.ColumnHistogramTypeDesc
FROM TestConfig AS log
JOIN TableProfile AS tab_pro
ON log.TestConfigID = tab_pro.TestConfigID
JOIN TableProfileType AS tab_pro_dim
ON tab_pro.TableProfileTypeID = tab_pro_dim.TableProfileTypeID
JOIN ColumnProfile AS col_pro
ON tab_pro.TableProfileID = col_pro.TableProfileID
JOIN ColumnProfileType AS col_pro_dim
ON col_pro.ColumnProfileTypeID = col_pro_dim.ColumnProfileTypeID
JOIN ColumnHistogram AS col_hist
ON col_pro.ColumnProfileID = col_hist.ColumnProfileID
JOIN ColumnHistogramType AS col_hist_dim
ON col_hist.ColumnHistogramTypeID = col_hist_dim.ColumnHistogramTypeID
WHERE 1=1
AND log.PreEtlSourceObjectFullName = @PreEtlSourceObjectFullName
AND log.PreEtlSourceObjectFullName = @PreEtlSourceObjectFullName
AND col_pro.ColumnName = @ColumnName
AND col_hist_dim.ColumnHistogramTypeDesc = @ColumnHistogramTypeDesc
ORDER BY col_hist.ColumnValue

SELECT pre.AdmissionDateID AS ColumnValue, COUNT(*) AS ValueCount
FROM Lien.Adtc.SM_02_DischargeFact pre
LEFT JOIN Lien.Adtc.SM_03_DischargeFact post
ON pre.AccountNum = post.AccountNum
AND pre.PatientID = post.PatientID
WHERE post.AccountNum IS NULL
GROUP BY pre.AdmissionDateID
ORDER BY pre.AdmissionDateID

