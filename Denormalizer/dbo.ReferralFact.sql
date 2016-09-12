SELECT
	Dim.LocalReportingOffice.CommunityProgramID
	,Dim.LocalReportingOffice.ProviderID
	,Dim.Provider.LevelOfCareId
	,Dim.Provider.FacilityID
	,Dim.Facility.HSDAID
	,Dim.ReferralSourceLookup.ReferralSourceID
	,Dim.DischargeDispositionLookupCOM.DischargeDispositionID
	,Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
	,dbo.PersonFact.DeathLocationID
	,dbo.PersonFact.EthnicityID
	,dbo.PersonFact.EducationLevelCodeID
	,Dim.EducationLevelLookup.EducationLevelID
	,dbo.PersonFact.GenderID
FROM dbo.ReferralFact
LEFT JOIN Dim.LocalReportingOffice
ON Dim.LocalReportingOffice.LocalReportingOfficeID=dbo.ReferralFact.LocalReportingOfficeID
	LEFT JOIN Dim.CommunityProgram
	ON Dim.CommunityProgram.CommunityProgramID=Dim.LocalReportingOffice.CommunityProgramID
	LEFT JOIN Dim.Provider
	ON Dim.Provider.ProviderID=Dim.LocalReportingOffice.ProviderID
		LEFT JOIN Dim.LevelOfCare
		ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
		LEFT JOIN Dim.Facility
		ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
			LEFT JOIN Dim.HSDA
			ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
LEFT JOIN Dim.ReferralSourceLookup
ON Dim.ReferralSourceLookup.ReferralSourceLookupID=dbo.ReferralFact.ReferralSourceLookupID
	LEFT JOIN Dim.ReferralSource
	ON Dim.ReferralSource.ReferralSourceID=Dim.ReferralSourceLookup.ReferralSourceID
LEFT JOIN Dim.DischargeDispositionLookupCOM
ON Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=dbo.ReferralFact.DischargeDispositionCodeID
	LEFT JOIN Dim.DischargeDisposition
	ON Dim.DischargeDisposition.DischargeDispositionID=Dim.DischargeDispositionLookupCOM.DischargeDispositionID
LEFT JOIN Dim.ReferralPriority
ON Dim.ReferralPriority.ReferralPriorityID=dbo.ReferralFact.ReferralPriorityID
LEFT JOIN Dim.ReasonEndingServiceLookup
ON Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=dbo.ReferralFact.ReasonEndingServiceCodeID
	LEFT JOIN Dim.ReasonEndingService
	ON Dim.ReasonEndingService.ReasonEndingServiceID=Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
LEFT JOIN Dim.ReferralReason
ON Dim.ReferralReason.ReferralReasonID=dbo.ReferralFact.ReferralReasonID
LEFT JOIN dbo.PersonFact
ON dbo.PersonFact.SourceSystemClientID=dbo.ReferralFact.SourceSystemClientID
	LEFT JOIN Dim.DeathLocation
	ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
	LEFT JOIN Dim.Ethnicity
	ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
	LEFT JOIN Dim.EducationLevelLookup
	ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
		LEFT JOIN Dim.EducationLevel
		ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
	LEFT JOIN Dim.Gender
	ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
LEFT JOIN Dim.DischargeOutcome
ON Dim.DischargeOutcome.DischargeOutcomeID=dbo.ReferralFact.DischargeOutcomeID
LEFT JOIN Dim.ReferralType
ON Dim.ReferralType.ReferralTypeID=dbo.ReferralFact.ReferralTypeID