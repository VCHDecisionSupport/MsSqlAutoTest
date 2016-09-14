

--#region BR dbo.ImmunizationHistoryFact
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '80d16c58-7a27-11e6-a2ba-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		dbo.ImmunizationHistoryFact.ETLAuditID,
	dbo.PersonFact.DeathLocationID
		,dbo.PersonFact.EducationLevelCodeID
		,Dim.EducationLevelLookup.EducationLevelID
		,dbo.PersonFact.GenderID
		,dbo.PersonFact.EthnicityID
		,Dim.LocalReportingOffice.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,Dim.LocalReportingOffice.CommunityProgramID
FROM dbo.ImmunizationHistoryFact
LEFT JOIN Dim.Antigen
ON Dim.Antigen.AntigenID=dbo.ImmunizationHistoryFact.AntigenID
LEFT JOIN Dim.CommunityServiceLocation
ON Dim.CommunityServiceLocation.CommunityServiceLocationID=dbo.ImmunizationHistoryFact.CommunityServiceLocationID
LEFT JOIN dbo.PersonFact
ON dbo.PersonFact.SourceSystemClientID=dbo.ImmunizationHistoryFact.SourceSystemClientID
	LEFT JOIN Dim.DeathLocation
	ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
	LEFT JOIN Dim.EducationLevelLookup
	ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
		LEFT JOIN Dim.EducationLevel
		ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
	LEFT JOIN Dim.Gender
	ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
	LEFT JOIN Dim.Ethnicity
	ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
LEFT JOIN Dim.LocalReportingOffice
ON Dim.LocalReportingOffice.LocalReportingOfficeID=dbo.ImmunizationHistoryFact.LocalReportingOfficeID
	LEFT JOIN Dim.Provider
	ON Dim.Provider.ProviderID=Dim.LocalReportingOffice.ProviderID
		LEFT JOIN Dim.Facility
		ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
			LEFT JOIN Dim.HSDA
			ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
		LEFT JOIN Dim.LevelOfCare
		ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
	LEFT JOIN Dim.CommunityProgram
	ON Dim.CommunityProgram.CommunityProgramID=Dim.LocalReportingOffice.CommunityProgramID
)
MERGE INTO dbo.ImmunizationHistoryFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.DeathLocationID=src.DeathLocationID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.GenderID=src.GenderID,
	dst.EthnicityID=src.EthnicityID,
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.CommunityProgramID=src.CommunityProgramID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='dbo.ImmunizationHistoryFact', 
@pRuleDesc='', 
@pConditionSQL='', 
@pActionID=, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='', 
@pTargetAttributePhysicalName='', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR dbo.ImmunizationHistoryFact



--#region BR dbo.ImmAdverseEventFact
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '80d31a12-7a27-11e6-ad81-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		dbo.ImmAdverseEventFact.ETLAuditID,
	dbo.PersonFact.DeathLocationID
		,dbo.PersonFact.EducationLevelCodeID
		,Dim.EducationLevelLookup.EducationLevelID
		,dbo.PersonFact.GenderID
		,dbo.PersonFact.EthnicityID
FROM dbo.ImmAdverseEventFact
LEFT JOIN dbo.PersonFact
ON dbo.PersonFact.SourceSystemClientID=dbo.ImmAdverseEventFact.SourceSystemClientID
	LEFT JOIN Dim.DeathLocation
	ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
	LEFT JOIN Dim.EducationLevelLookup
	ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
		LEFT JOIN Dim.EducationLevel
		ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
	LEFT JOIN Dim.Gender
	ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
	LEFT JOIN Dim.Ethnicity
	ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
)
MERGE INTO dbo.ImmAdverseEventFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.DeathLocationID=src.DeathLocationID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.GenderID=src.GenderID,
	dst.EthnicityID=src.EthnicityID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='dbo.ImmAdverseEventFact', 
@pRuleDesc='', 
@pConditionSQL='', 
@pActionID=, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='', 
@pTargetAttributePhysicalName='', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR dbo.ImmAdverseEventFact



--#region BR dbo.WaitTimeFact
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '80d4c7cc-7a27-11e6-9927-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		dbo.WaitTimeFact.ETLAuditID,
	Dim.LocalReportingOffice.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,Dim.LocalReportingOffice.CommunityProgramID
		,dbo.PersonFact.DeathLocationID
		,dbo.PersonFact.EducationLevelCodeID
		,Dim.EducationLevelLookup.EducationLevelID
		,dbo.PersonFact.GenderID
		,dbo.PersonFact.EthnicityID
FROM dbo.WaitTimeFact
LEFT JOIN Dim.ReferralPriority
ON Dim.ReferralPriority.ReferralPriorityID=dbo.WaitTimeFact.ReferralPriorityID
LEFT JOIN Dim.LocalReportingOffice
ON Dim.LocalReportingOffice.LocalReportingOfficeID=dbo.WaitTimeFact.LocalReportingOfficeID
	LEFT JOIN Dim.Provider
	ON Dim.Provider.ProviderID=Dim.LocalReportingOffice.ProviderID
		LEFT JOIN Dim.Facility
		ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
			LEFT JOIN Dim.HSDA
			ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
		LEFT JOIN Dim.LevelOfCare
		ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
	LEFT JOIN Dim.CommunityProgram
	ON Dim.CommunityProgram.CommunityProgramID=Dim.LocalReportingOffice.CommunityProgramID
LEFT JOIN Dim.Age
ON Dim.Age.AgeID=dbo.WaitTimeFact.AgeID
LEFT JOIN Dim.Gender
ON Dim.Gender.GenderID=dbo.WaitTimeFact.GenderID
LEFT JOIN Dim.CommunityLHA
ON Dim.CommunityLHA.CommunityLHAID=dbo.WaitTimeFact.CommunityLHAID
LEFT JOIN dbo.PersonFact
ON dbo.PersonFact.SourceSystemClientID=dbo.WaitTimeFact.SourceSystemClientID
	LEFT JOIN Dim.DeathLocation
	ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
	LEFT JOIN Dim.EducationLevelLookup
	ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
		LEFT JOIN Dim.EducationLevel
		ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
	LEFT JOIN Dim.Gender
	ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
	LEFT JOIN Dim.Ethnicity
	ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
)
MERGE INTO dbo.WaitTimeFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.GenderID=src.GenderID,
	dst.EthnicityID=src.EthnicityID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='dbo.WaitTimeFact', 
@pRuleDesc='', 
@pConditionSQL='', 
@pActionID=, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='', 
@pTargetAttributePhysicalName='', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR dbo.WaitTimeFact



--#region BR dbo.HomeSupportActivityFact
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '80d738de-7a27-11e6-bbd8-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		dbo.HomeSupportActivityFact.ETLAuditID,
	dbo.ReferralFact.SourceSystemClientID
		,dbo.PersonFact.DeathLocationID
		,dbo.PersonFact.EducationLevelCodeID
		,Dim.EducationLevelLookup.EducationLevelID
		,dbo.PersonFact.GenderID
		,dbo.PersonFact.EthnicityID
		,dbo.ReferralFact.ReferralPriorityID
		,dbo.ReferralFact.LocalReportingOfficeID
		,Dim.LocalReportingOffice.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,Dim.LocalReportingOffice.CommunityProgramID
		,dbo.ReferralFact.ReasonEndingServiceCodeID
		,Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
		,dbo.ReferralFact.ReferralReasonID
		,dbo.ReferralFact.ReferralSourceLookupID
		,Dim.ReferralSourceLookup.ReferralSourceID
		,dbo.ReferralFact.DischargeDispositionCodeID
		,Dim.DischargeDispositionLookupCOM.DischargeDispositionID
		,dbo.ReferralFact.ReferralTypeID
		,dbo.ReferralFact.DischargeOutcomeID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,Dim.LocalReportingOffice.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,Dim.LocalReportingOffice.CommunityProgramID
		,dbo.InterventionFact.InterventionID
		,Dim.Intervention.InterventionTypeID
		,dbo.InterventionFact.SourceReferralID
		,dbo.ReferralFact.SourceSystemClientID
		,dbo.PersonFact.DeathLocationID
		,dbo.PersonFact.EducationLevelCodeID
		,Dim.EducationLevelLookup.EducationLevelID
		,dbo.PersonFact.GenderID
		,dbo.PersonFact.EthnicityID
		,dbo.ReferralFact.ReferralPriorityID
		,dbo.ReferralFact.LocalReportingOfficeID
		,Dim.LocalReportingOffice.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,Dim.LocalReportingOffice.CommunityProgramID
		,dbo.ReferralFact.ReasonEndingServiceCodeID
		,Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
		,dbo.ReferralFact.ReferralReasonID
		,dbo.ReferralFact.ReferralSourceLookupID
		,Dim.ReferralSourceLookup.ReferralSourceID
		,dbo.ReferralFact.DischargeDispositionCodeID
		,Dim.DischargeDispositionLookupCOM.DischargeDispositionID
		,dbo.ReferralFact.ReferralTypeID
		,dbo.ReferralFact.DischargeOutcomeID
		,dbo.InterventionFact.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,Dim.Intervention.InterventionTypeID
		,dbo.PersonFact.DeathLocationID
		,dbo.PersonFact.EducationLevelCodeID
		,Dim.EducationLevelLookup.EducationLevelID
		,dbo.PersonFact.GenderID
		,dbo.PersonFact.EthnicityID
FROM dbo.HomeSupportActivityFact
LEFT JOIN dbo.ReferralFact
ON dbo.ReferralFact.SourceReferralID=dbo.HomeSupportActivityFact.SourceReferralID
	LEFT JOIN dbo.PersonFact
	ON dbo.PersonFact.SourceSystemClientID=dbo.ReferralFact.SourceSystemClientID
		LEFT JOIN Dim.DeathLocation
		ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
		LEFT JOIN Dim.EducationLevelLookup
		ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
			LEFT JOIN Dim.EducationLevel
			ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
		LEFT JOIN Dim.Gender
		ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
		LEFT JOIN Dim.Ethnicity
		ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
	LEFT JOIN Dim.ReferralPriority
	ON Dim.ReferralPriority.ReferralPriorityID=dbo.ReferralFact.ReferralPriorityID
	LEFT JOIN Dim.LocalReportingOffice
	ON Dim.LocalReportingOffice.LocalReportingOfficeID=dbo.ReferralFact.LocalReportingOfficeID
		LEFT JOIN Dim.Provider
		ON Dim.Provider.ProviderID=Dim.LocalReportingOffice.ProviderID
			LEFT JOIN Dim.Facility
			ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
				LEFT JOIN Dim.HSDA
				ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
			LEFT JOIN Dim.LevelOfCare
			ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
		LEFT JOIN Dim.CommunityProgram
		ON Dim.CommunityProgram.CommunityProgramID=Dim.LocalReportingOffice.CommunityProgramID
	LEFT JOIN Dim.ReasonEndingServiceLookup
	ON Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=dbo.ReferralFact.ReasonEndingServiceCodeID
		LEFT JOIN Dim.ReasonEndingService
		ON Dim.ReasonEndingService.ReasonEndingServiceID=Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
	LEFT JOIN Dim.ReferralReason
	ON Dim.ReferralReason.ReferralReasonID=dbo.ReferralFact.ReferralReasonID
	LEFT JOIN Dim.ReferralSourceLookup
	ON Dim.ReferralSourceLookup.ReferralSourceLookupID=dbo.ReferralFact.ReferralSourceLookupID
		LEFT JOIN Dim.ReferralSource
		ON Dim.ReferralSource.ReferralSourceID=Dim.ReferralSourceLookup.ReferralSourceID
	LEFT JOIN Dim.DischargeDispositionLookupCOM
	ON Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=dbo.ReferralFact.DischargeDispositionCodeID
		LEFT JOIN Dim.DischargeDisposition
		ON Dim.DischargeDisposition.DischargeDispositionID=Dim.DischargeDispositionLookupCOM.DischargeDispositionID
	LEFT JOIN Dim.ReferralType
	ON Dim.ReferralType.ReferralTypeID=dbo.ReferralFact.ReferralTypeID
	LEFT JOIN Dim.DischargeOutcome
	ON Dim.DischargeOutcome.DischargeOutcomeID=dbo.ReferralFact.DischargeOutcomeID
LEFT JOIN Dim.Provider
ON Dim.Provider.ProviderID=dbo.HomeSupportActivityFact.ProviderID
	LEFT JOIN Dim.Facility
	ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
		LEFT JOIN Dim.HSDA
		ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
	LEFT JOIN Dim.LevelOfCare
	ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
LEFT JOIN Dim.LocalReportingOffice
ON Dim.LocalReportingOffice.LocalReportingOfficeID=dbo.HomeSupportActivityFact.LocalReportingOfficeID
	LEFT JOIN Dim.Provider
	ON Dim.Provider.ProviderID=Dim.LocalReportingOffice.ProviderID
		LEFT JOIN Dim.Facility
		ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
			LEFT JOIN Dim.HSDA
			ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
		LEFT JOIN Dim.LevelOfCare
		ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
	LEFT JOIN Dim.CommunityProgram
	ON Dim.CommunityProgram.CommunityProgramID=Dim.LocalReportingOffice.CommunityProgramID
LEFT JOIN Dim.InterventionType
ON Dim.InterventionType.InterventionTypeID=dbo.HomeSupportActivityFact.InterventionTypeID
LEFT JOIN dbo.InterventionFact
ON dbo.InterventionFact.SourceInterventionID=dbo.HomeSupportActivityFact.SourceInterventionID
	LEFT JOIN Dim.Intervention
	ON Dim.Intervention.InterventionID=dbo.InterventionFact.InterventionID
		LEFT JOIN Dim.InterventionType
		ON Dim.InterventionType.InterventionTypeID=Dim.Intervention.InterventionTypeID
	LEFT JOIN dbo.ReferralFact
	ON dbo.ReferralFact.SourceReferralID=dbo.InterventionFact.SourceReferralID
		LEFT JOIN dbo.PersonFact
		ON dbo.PersonFact.SourceSystemClientID=dbo.ReferralFact.SourceSystemClientID
			LEFT JOIN Dim.DeathLocation
			ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
			LEFT JOIN Dim.EducationLevelLookup
			ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
				LEFT JOIN Dim.EducationLevel
				ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
			LEFT JOIN Dim.Gender
			ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
			LEFT JOIN Dim.Ethnicity
			ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
		LEFT JOIN Dim.ReferralPriority
		ON Dim.ReferralPriority.ReferralPriorityID=dbo.ReferralFact.ReferralPriorityID
		LEFT JOIN Dim.LocalReportingOffice
		ON Dim.LocalReportingOffice.LocalReportingOfficeID=dbo.ReferralFact.LocalReportingOfficeID
			LEFT JOIN Dim.Provider
			ON Dim.Provider.ProviderID=Dim.LocalReportingOffice.ProviderID
				LEFT JOIN Dim.Facility
				ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
					LEFT JOIN Dim.HSDA
					ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
				LEFT JOIN Dim.LevelOfCare
				ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
			LEFT JOIN Dim.CommunityProgram
			ON Dim.CommunityProgram.CommunityProgramID=Dim.LocalReportingOffice.CommunityProgramID
		LEFT JOIN Dim.ReasonEndingServiceLookup
		ON Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=dbo.ReferralFact.ReasonEndingServiceCodeID
			LEFT JOIN Dim.ReasonEndingService
			ON Dim.ReasonEndingService.ReasonEndingServiceID=Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
		LEFT JOIN Dim.ReferralReason
		ON Dim.ReferralReason.ReferralReasonID=dbo.ReferralFact.ReferralReasonID
		LEFT JOIN Dim.ReferralSourceLookup
		ON Dim.ReferralSourceLookup.ReferralSourceLookupID=dbo.ReferralFact.ReferralSourceLookupID
			LEFT JOIN Dim.ReferralSource
			ON Dim.ReferralSource.ReferralSourceID=Dim.ReferralSourceLookup.ReferralSourceID
		LEFT JOIN Dim.DischargeDispositionLookupCOM
		ON Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=dbo.ReferralFact.DischargeDispositionCodeID
			LEFT JOIN Dim.DischargeDisposition
			ON Dim.DischargeDisposition.DischargeDispositionID=Dim.DischargeDispositionLookupCOM.DischargeDispositionID
		LEFT JOIN Dim.ReferralType
		ON Dim.ReferralType.ReferralTypeID=dbo.ReferralFact.ReferralTypeID
		LEFT JOIN Dim.DischargeOutcome
		ON Dim.DischargeOutcome.DischargeOutcomeID=dbo.ReferralFact.DischargeOutcomeID
	LEFT JOIN Dim.Provider
	ON Dim.Provider.ProviderID=dbo.InterventionFact.ProviderID
		LEFT JOIN Dim.Facility
		ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
			LEFT JOIN Dim.HSDA
			ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
		LEFT JOIN Dim.LevelOfCare
		ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
LEFT JOIN Dim.Intervention
ON Dim.Intervention.InterventionID=dbo.HomeSupportActivityFact.InterventionID
	LEFT JOIN Dim.InterventionType
	ON Dim.InterventionType.InterventionTypeID=Dim.Intervention.InterventionTypeID
LEFT JOIN dbo.PersonFact
ON dbo.PersonFact.SourceSystemClientID=dbo.HomeSupportActivityFact.SourceSystemClientID
	LEFT JOIN Dim.DeathLocation
	ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
	LEFT JOIN Dim.EducationLevelLookup
	ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
		LEFT JOIN Dim.EducationLevel
		ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
	LEFT JOIN Dim.Gender
	ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
	LEFT JOIN Dim.Ethnicity
	ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
)
MERGE INTO dbo.HomeSupportActivityFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.GenderID=src.GenderID,
	dst.EthnicityID=src.EthnicityID,
	dst.ReferralPriorityID=src.ReferralPriorityID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.ReasonEndingServiceCodeID=src.ReasonEndingServiceCodeID,
	dst.ReasonEndingServiceID=src.ReasonEndingServiceID,
	dst.ReferralReasonID=src.ReferralReasonID,
	dst.ReferralSourceLookupID=src.ReferralSourceLookupID,
	dst.ReferralSourceID=src.ReferralSourceID,
	dst.DischargeDispositionCodeID=src.DischargeDispositionCodeID,
	dst.DischargeDispositionID=src.DischargeDispositionID,
	dst.ReferralTypeID=src.ReferralTypeID,
	dst.DischargeOutcomeID=src.DischargeOutcomeID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.InterventionID=src.InterventionID,
	dst.InterventionTypeID=src.InterventionTypeID,
	dst.SourceReferralID=src.SourceReferralID,
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.GenderID=src.GenderID,
	dst.EthnicityID=src.EthnicityID,
	dst.ReferralPriorityID=src.ReferralPriorityID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.ReasonEndingServiceCodeID=src.ReasonEndingServiceCodeID,
	dst.ReasonEndingServiceID=src.ReasonEndingServiceID,
	dst.ReferralReasonID=src.ReferralReasonID,
	dst.ReferralSourceLookupID=src.ReferralSourceLookupID,
	dst.ReferralSourceID=src.ReferralSourceID,
	dst.DischargeDispositionCodeID=src.DischargeDispositionCodeID,
	dst.DischargeDispositionID=src.DischargeDispositionID,
	dst.ReferralTypeID=src.ReferralTypeID,
	dst.DischargeOutcomeID=src.DischargeOutcomeID,
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.InterventionTypeID=src.InterventionTypeID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.GenderID=src.GenderID,
	dst.EthnicityID=src.EthnicityID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='dbo.HomeSupportActivityFact', 
@pRuleDesc='', 
@pConditionSQL='', 
@pActionID=, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='', 
@pTargetAttributePhysicalName='', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR dbo.HomeSupportActivityFact



--#region BR dbo.CDPublicHealthMeasureFact
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '80da1f1e-7a27-11e6-9d07-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		dbo.CDPublicHealthMeasureFact.ETLAuditID,
	dbo.AssessmentHeaderFact.SourceReferralID
		,dbo.ReferralFact.SourceSystemClientID
		,dbo.PersonFact.DeathLocationID
		,dbo.PersonFact.EducationLevelCodeID
		,Dim.EducationLevelLookup.EducationLevelID
		,dbo.PersonFact.GenderID
		,dbo.PersonFact.EthnicityID
		,dbo.ReferralFact.ReferralPriorityID
		,dbo.ReferralFact.LocalReportingOfficeID
		,Dim.LocalReportingOffice.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,Dim.LocalReportingOffice.CommunityProgramID
		,dbo.ReferralFact.ReasonEndingServiceCodeID
		,Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
		,dbo.ReferralFact.ReferralReasonID
		,dbo.ReferralFact.ReferralSourceLookupID
		,Dim.ReferralSourceLookup.ReferralSourceID
		,dbo.ReferralFact.DischargeDispositionCodeID
		,Dim.DischargeDispositionLookupCOM.DischargeDispositionID
		,dbo.ReferralFact.ReferralTypeID
		,dbo.ReferralFact.DischargeOutcomeID
		,dbo.AssessmentHeaderFact.AssessmentTypeID
		,dbo.AssessmentHeaderFact.AssessmentReasonID
		,dbo.CDPreviousTestResultFact.CommunityDiseaseID
FROM dbo.CDPublicHealthMeasureFact
LEFT JOIN dbo.AssessmentHeaderFact
ON dbo.AssessmentHeaderFact.SourceAssessmentID=dbo.CDPublicHealthMeasureFact.SourceAssessmentID
	LEFT JOIN dbo.ReferralFact
	ON dbo.ReferralFact.SourceReferralID=dbo.AssessmentHeaderFact.SourceReferralID
		LEFT JOIN dbo.PersonFact
		ON dbo.PersonFact.SourceSystemClientID=dbo.ReferralFact.SourceSystemClientID
			LEFT JOIN Dim.DeathLocation
			ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
			LEFT JOIN Dim.EducationLevelLookup
			ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
				LEFT JOIN Dim.EducationLevel
				ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
			LEFT JOIN Dim.Gender
			ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
			LEFT JOIN Dim.Ethnicity
			ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
		LEFT JOIN Dim.ReferralPriority
		ON Dim.ReferralPriority.ReferralPriorityID=dbo.ReferralFact.ReferralPriorityID
		LEFT JOIN Dim.LocalReportingOffice
		ON Dim.LocalReportingOffice.LocalReportingOfficeID=dbo.ReferralFact.LocalReportingOfficeID
			LEFT JOIN Dim.Provider
			ON Dim.Provider.ProviderID=Dim.LocalReportingOffice.ProviderID
				LEFT JOIN Dim.Facility
				ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
					LEFT JOIN Dim.HSDA
					ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
				LEFT JOIN Dim.LevelOfCare
				ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
			LEFT JOIN Dim.CommunityProgram
			ON Dim.CommunityProgram.CommunityProgramID=Dim.LocalReportingOffice.CommunityProgramID
		LEFT JOIN Dim.ReasonEndingServiceLookup
		ON Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=dbo.ReferralFact.ReasonEndingServiceCodeID
			LEFT JOIN Dim.ReasonEndingService
			ON Dim.ReasonEndingService.ReasonEndingServiceID=Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
		LEFT JOIN Dim.ReferralReason
		ON Dim.ReferralReason.ReferralReasonID=dbo.ReferralFact.ReferralReasonID
		LEFT JOIN Dim.ReferralSourceLookup
		ON Dim.ReferralSourceLookup.ReferralSourceLookupID=dbo.ReferralFact.ReferralSourceLookupID
			LEFT JOIN Dim.ReferralSource
			ON Dim.ReferralSource.ReferralSourceID=Dim.ReferralSourceLookup.ReferralSourceID
		LEFT JOIN Dim.DischargeDispositionLookupCOM
		ON Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=dbo.ReferralFact.DischargeDispositionCodeID
			LEFT JOIN Dim.DischargeDisposition
			ON Dim.DischargeDisposition.DischargeDispositionID=Dim.DischargeDispositionLookupCOM.DischargeDispositionID
		LEFT JOIN Dim.ReferralType
		ON Dim.ReferralType.ReferralTypeID=dbo.ReferralFact.ReferralTypeID
		LEFT JOIN Dim.DischargeOutcome
		ON Dim.DischargeOutcome.DischargeOutcomeID=dbo.ReferralFact.DischargeOutcomeID
	LEFT JOIN Dim.AssessmentType
	ON Dim.AssessmentType.AssessmentTypeID=dbo.AssessmentHeaderFact.AssessmentTypeID
	LEFT JOIN Dim.AssessmentReason
	ON Dim.AssessmentReason.AssessmentReasonID=dbo.AssessmentHeaderFact.AssessmentReasonID
LEFT JOIN dbo.CDPreviousTestResultFact
ON dbo.CDPreviousTestResultFact.SourceAssessmentID=dbo.CDPublicHealthMeasureFact.SourceAssessmentID
	LEFT JOIN Dim.CommunityDisease
	ON Dim.CommunityDisease.CommunityDiseaseID=dbo.CDPreviousTestResultFact.CommunityDiseaseID
)
MERGE INTO dbo.CDPublicHealthMeasureFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.SourceReferralID=src.SourceReferralID,
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.GenderID=src.GenderID,
	dst.EthnicityID=src.EthnicityID,
	dst.ReferralPriorityID=src.ReferralPriorityID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.ReasonEndingServiceCodeID=src.ReasonEndingServiceCodeID,
	dst.ReasonEndingServiceID=src.ReasonEndingServiceID,
	dst.ReferralReasonID=src.ReferralReasonID,
	dst.ReferralSourceLookupID=src.ReferralSourceLookupID,
	dst.ReferralSourceID=src.ReferralSourceID,
	dst.DischargeDispositionCodeID=src.DischargeDispositionCodeID,
	dst.DischargeDispositionID=src.DischargeDispositionID,
	dst.ReferralTypeID=src.ReferralTypeID,
	dst.DischargeOutcomeID=src.DischargeOutcomeID,
	dst.AssessmentTypeID=src.AssessmentTypeID,
	dst.AssessmentReasonID=src.AssessmentReasonID,
	dst.CommunityDiseaseID=src.CommunityDiseaseID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='dbo.CDPublicHealthMeasureFact', 
@pRuleDesc='', 
@pConditionSQL='', 
@pActionID=, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='', 
@pTargetAttributePhysicalName='', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR dbo.CDPublicHealthMeasureFact



--#region BR dbo.YouthClinicActivityFact
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '80dc1afe-7a27-11e6-bacd-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		dbo.YouthClinicActivityFact.ETLAuditID,
	dbo.CDPreviousTestResultFact.CommunityDiseaseID
		,dbo.AssessmentHeaderFact.SourceReferralID
		,dbo.ReferralFact.SourceSystemClientID
		,dbo.PersonFact.DeathLocationID
		,dbo.PersonFact.EducationLevelCodeID
		,Dim.EducationLevelLookup.EducationLevelID
		,dbo.PersonFact.GenderID
		,dbo.PersonFact.EthnicityID
		,dbo.ReferralFact.ReferralPriorityID
		,dbo.ReferralFact.LocalReportingOfficeID
		,Dim.LocalReportingOffice.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,Dim.LocalReportingOffice.CommunityProgramID
		,dbo.ReferralFact.ReasonEndingServiceCodeID
		,Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
		,dbo.ReferralFact.ReferralReasonID
		,dbo.ReferralFact.ReferralSourceLookupID
		,Dim.ReferralSourceLookup.ReferralSourceID
		,dbo.ReferralFact.DischargeDispositionCodeID
		,Dim.DischargeDispositionLookupCOM.DischargeDispositionID
		,dbo.ReferralFact.ReferralTypeID
		,dbo.ReferralFact.DischargeOutcomeID
		,dbo.AssessmentHeaderFact.AssessmentTypeID
		,dbo.AssessmentHeaderFact.AssessmentReasonID
FROM dbo.YouthClinicActivityFact
LEFT JOIN Dim.ServiceProviderCategoryLookup
ON Dim.ServiceProviderCategoryLookup.ServiceProviderCategoryCodeID=dbo.YouthClinicActivityFact.ServiceProviderCategoryCodeID
LEFT JOIN Dim.CommunityServiceLocation
ON Dim.CommunityServiceLocation.CommunityServiceLocationID=dbo.YouthClinicActivityFact.CommunityServiceLocationID
LEFT JOIN dbo.CDPreviousTestResultFact
ON dbo.CDPreviousTestResultFact.SourceAssessmentID=dbo.YouthClinicActivityFact.SourceAssessmentID
	LEFT JOIN Dim.CommunityDisease
	ON Dim.CommunityDisease.CommunityDiseaseID=dbo.CDPreviousTestResultFact.CommunityDiseaseID
LEFT JOIN dbo.AssessmentHeaderFact
ON dbo.AssessmentHeaderFact.SourceAssessmentID=dbo.YouthClinicActivityFact.SourceAssessmentID
	LEFT JOIN dbo.ReferralFact
	ON dbo.ReferralFact.SourceReferralID=dbo.AssessmentHeaderFact.SourceReferralID
		LEFT JOIN dbo.PersonFact
		ON dbo.PersonFact.SourceSystemClientID=dbo.ReferralFact.SourceSystemClientID
			LEFT JOIN Dim.DeathLocation
			ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
			LEFT JOIN Dim.EducationLevelLookup
			ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
				LEFT JOIN Dim.EducationLevel
				ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
			LEFT JOIN Dim.Gender
			ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
			LEFT JOIN Dim.Ethnicity
			ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
		LEFT JOIN Dim.ReferralPriority
		ON Dim.ReferralPriority.ReferralPriorityID=dbo.ReferralFact.ReferralPriorityID
		LEFT JOIN Dim.LocalReportingOffice
		ON Dim.LocalReportingOffice.LocalReportingOfficeID=dbo.ReferralFact.LocalReportingOfficeID
			LEFT JOIN Dim.Provider
			ON Dim.Provider.ProviderID=Dim.LocalReportingOffice.ProviderID
				LEFT JOIN Dim.Facility
				ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
					LEFT JOIN Dim.HSDA
					ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
				LEFT JOIN Dim.LevelOfCare
				ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
			LEFT JOIN Dim.CommunityProgram
			ON Dim.CommunityProgram.CommunityProgramID=Dim.LocalReportingOffice.CommunityProgramID
		LEFT JOIN Dim.ReasonEndingServiceLookup
		ON Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=dbo.ReferralFact.ReasonEndingServiceCodeID
			LEFT JOIN Dim.ReasonEndingService
			ON Dim.ReasonEndingService.ReasonEndingServiceID=Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
		LEFT JOIN Dim.ReferralReason
		ON Dim.ReferralReason.ReferralReasonID=dbo.ReferralFact.ReferralReasonID
		LEFT JOIN Dim.ReferralSourceLookup
		ON Dim.ReferralSourceLookup.ReferralSourceLookupID=dbo.ReferralFact.ReferralSourceLookupID
			LEFT JOIN Dim.ReferralSource
			ON Dim.ReferralSource.ReferralSourceID=Dim.ReferralSourceLookup.ReferralSourceID
		LEFT JOIN Dim.DischargeDispositionLookupCOM
		ON Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=dbo.ReferralFact.DischargeDispositionCodeID
			LEFT JOIN Dim.DischargeDisposition
			ON Dim.DischargeDisposition.DischargeDispositionID=Dim.DischargeDispositionLookupCOM.DischargeDispositionID
		LEFT JOIN Dim.ReferralType
		ON Dim.ReferralType.ReferralTypeID=dbo.ReferralFact.ReferralTypeID
		LEFT JOIN Dim.DischargeOutcome
		ON Dim.DischargeOutcome.DischargeOutcomeID=dbo.ReferralFact.DischargeOutcomeID
	LEFT JOIN Dim.AssessmentType
	ON Dim.AssessmentType.AssessmentTypeID=dbo.AssessmentHeaderFact.AssessmentTypeID
	LEFT JOIN Dim.AssessmentReason
	ON Dim.AssessmentReason.AssessmentReasonID=dbo.AssessmentHeaderFact.AssessmentReasonID
)
MERGE INTO dbo.YouthClinicActivityFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.CommunityDiseaseID=src.CommunityDiseaseID,
	dst.SourceReferralID=src.SourceReferralID,
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.GenderID=src.GenderID,
	dst.EthnicityID=src.EthnicityID,
	dst.ReferralPriorityID=src.ReferralPriorityID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.ReasonEndingServiceCodeID=src.ReasonEndingServiceCodeID,
	dst.ReasonEndingServiceID=src.ReasonEndingServiceID,
	dst.ReferralReasonID=src.ReferralReasonID,
	dst.ReferralSourceLookupID=src.ReferralSourceLookupID,
	dst.ReferralSourceID=src.ReferralSourceID,
	dst.DischargeDispositionCodeID=src.DischargeDispositionCodeID,
	dst.DischargeDispositionID=src.DischargeDispositionID,
	dst.ReferralTypeID=src.ReferralTypeID,
	dst.DischargeOutcomeID=src.DischargeOutcomeID,
	dst.AssessmentTypeID=src.AssessmentTypeID,
	dst.AssessmentReasonID=src.AssessmentReasonID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='dbo.YouthClinicActivityFact', 
@pRuleDesc='', 
@pConditionSQL='', 
@pActionID=, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='', 
@pTargetAttributePhysicalName='', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR dbo.YouthClinicActivityFact



--#region BR dbo.WeightGrowthFact
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '80de8c0c-7a27-11e6-bc20-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		dbo.WeightGrowthFact.ETLAuditID,
	dbo.PersonFact.DeathLocationID
		,dbo.PersonFact.EducationLevelCodeID
		,Dim.EducationLevelLookup.EducationLevelID
		,dbo.PersonFact.GenderID
		,dbo.PersonFact.EthnicityID
		,Dim.LocalReportingOffice.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,Dim.LocalReportingOffice.CommunityProgramID
FROM dbo.WeightGrowthFact
LEFT JOIN dbo.PersonFact
ON dbo.PersonFact.SourceSystemClientID=dbo.WeightGrowthFact.SourceSystemClientID
	LEFT JOIN Dim.DeathLocation
	ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
	LEFT JOIN Dim.EducationLevelLookup
	ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
		LEFT JOIN Dim.EducationLevel
		ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
	LEFT JOIN Dim.Gender
	ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
	LEFT JOIN Dim.Ethnicity
	ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
LEFT JOIN Dim.LocalReportingOffice
ON Dim.LocalReportingOffice.LocalReportingOfficeID=dbo.WeightGrowthFact.LocalReportingOfficeID
	LEFT JOIN Dim.Provider
	ON Dim.Provider.ProviderID=Dim.LocalReportingOffice.ProviderID
		LEFT JOIN Dim.Facility
		ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
			LEFT JOIN Dim.HSDA
			ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
		LEFT JOIN Dim.LevelOfCare
		ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
	LEFT JOIN Dim.CommunityProgram
	ON Dim.CommunityProgram.CommunityProgramID=Dim.LocalReportingOffice.CommunityProgramID
)
MERGE INTO dbo.WeightGrowthFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.DeathLocationID=src.DeathLocationID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.GenderID=src.GenderID,
	dst.EthnicityID=src.EthnicityID,
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.CommunityProgramID=src.CommunityProgramID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='dbo.WeightGrowthFact', 
@pRuleDesc='', 
@pConditionSQL='', 
@pActionID=, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='', 
@pTargetAttributePhysicalName='', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR dbo.WeightGrowthFact



--#region BR dbo.CaseNoteContactFact
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '80e087ec-7a27-11e6-a2cb-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		dbo.CaseNoteContactFact.ETLAuditID,
	dbo.CaseNoteHeaderFact.CaseNoteTypeID
		,dbo.CaseNoteHeaderFact.SourceReferralID
		,dbo.ReferralFact.SourceSystemClientID
		,dbo.PersonFact.DeathLocationID
		,dbo.PersonFact.EducationLevelCodeID
		,Dim.EducationLevelLookup.EducationLevelID
		,dbo.PersonFact.GenderID
		,dbo.PersonFact.EthnicityID
		,dbo.ReferralFact.ReferralPriorityID
		,dbo.ReferralFact.LocalReportingOfficeID
		,Dim.LocalReportingOffice.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,Dim.LocalReportingOffice.CommunityProgramID
		,dbo.ReferralFact.ReasonEndingServiceCodeID
		,Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
		,dbo.ReferralFact.ReferralReasonID
		,dbo.ReferralFact.ReferralSourceLookupID
		,Dim.ReferralSourceLookup.ReferralSourceID
		,dbo.ReferralFact.DischargeDispositionCodeID
		,Dim.DischargeDispositionLookupCOM.DischargeDispositionID
		,dbo.ReferralFact.ReferralTypeID
		,dbo.ReferralFact.DischargeOutcomeID
		,dbo.CaseNoteHeaderFact.CaseNoteReasonID
		,dbo.CaseNoteHeaderFact.SourceSystemClientID
		,dbo.PersonFact.DeathLocationID
		,dbo.PersonFact.EducationLevelCodeID
		,Dim.EducationLevelLookup.EducationLevelID
		,dbo.PersonFact.GenderID
		,dbo.PersonFact.EthnicityID
		,dbo.CaseNoteHeaderFact.LocalReportingOfficeID
		,Dim.LocalReportingOffice.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,Dim.LocalReportingOffice.CommunityProgramID
FROM dbo.CaseNoteContactFact
LEFT JOIN Dim.ContactType
ON Dim.ContactType.ContactTypeID=dbo.CaseNoteContactFact.ContactTypeID
LEFT JOIN dbo.CaseNoteHeaderFact
ON dbo.CaseNoteHeaderFact.SourceCaseNoteHeaderID=dbo.CaseNoteContactFact.SourceCaseNoteHeaderID
	LEFT JOIN Dim.CaseNoteType
	ON Dim.CaseNoteType.CaseNoteTypeID=dbo.CaseNoteHeaderFact.CaseNoteTypeID
	LEFT JOIN dbo.ReferralFact
	ON dbo.ReferralFact.SourceReferralID=dbo.CaseNoteHeaderFact.SourceReferralID
		LEFT JOIN dbo.PersonFact
		ON dbo.PersonFact.SourceSystemClientID=dbo.ReferralFact.SourceSystemClientID
			LEFT JOIN Dim.DeathLocation
			ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
			LEFT JOIN Dim.EducationLevelLookup
			ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
				LEFT JOIN Dim.EducationLevel
				ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
			LEFT JOIN Dim.Gender
			ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
			LEFT JOIN Dim.Ethnicity
			ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
		LEFT JOIN Dim.ReferralPriority
		ON Dim.ReferralPriority.ReferralPriorityID=dbo.ReferralFact.ReferralPriorityID
		LEFT JOIN Dim.LocalReportingOffice
		ON Dim.LocalReportingOffice.LocalReportingOfficeID=dbo.ReferralFact.LocalReportingOfficeID
			LEFT JOIN Dim.Provider
			ON Dim.Provider.ProviderID=Dim.LocalReportingOffice.ProviderID
				LEFT JOIN Dim.Facility
				ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
					LEFT JOIN Dim.HSDA
					ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
				LEFT JOIN Dim.LevelOfCare
				ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
			LEFT JOIN Dim.CommunityProgram
			ON Dim.CommunityProgram.CommunityProgramID=Dim.LocalReportingOffice.CommunityProgramID
		LEFT JOIN Dim.ReasonEndingServiceLookup
		ON Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=dbo.ReferralFact.ReasonEndingServiceCodeID
			LEFT JOIN Dim.ReasonEndingService
			ON Dim.ReasonEndingService.ReasonEndingServiceID=Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
		LEFT JOIN Dim.ReferralReason
		ON Dim.ReferralReason.ReferralReasonID=dbo.ReferralFact.ReferralReasonID
		LEFT JOIN Dim.ReferralSourceLookup
		ON Dim.ReferralSourceLookup.ReferralSourceLookupID=dbo.ReferralFact.ReferralSourceLookupID
			LEFT JOIN Dim.ReferralSource
			ON Dim.ReferralSource.ReferralSourceID=Dim.ReferralSourceLookup.ReferralSourceID
		LEFT JOIN Dim.DischargeDispositionLookupCOM
		ON Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=dbo.ReferralFact.DischargeDispositionCodeID
			LEFT JOIN Dim.DischargeDisposition
			ON Dim.DischargeDisposition.DischargeDispositionID=Dim.DischargeDispositionLookupCOM.DischargeDispositionID
		LEFT JOIN Dim.ReferralType
		ON Dim.ReferralType.ReferralTypeID=dbo.ReferralFact.ReferralTypeID
		LEFT JOIN Dim.DischargeOutcome
		ON Dim.DischargeOutcome.DischargeOutcomeID=dbo.ReferralFact.DischargeOutcomeID
	LEFT JOIN Dim.CaseNoteReason
	ON Dim.CaseNoteReason.CaseNoteReasonID=dbo.CaseNoteHeaderFact.CaseNoteReasonID
	LEFT JOIN dbo.PersonFact
	ON dbo.PersonFact.SourceSystemClientID=dbo.CaseNoteHeaderFact.SourceSystemClientID
		LEFT JOIN Dim.DeathLocation
		ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
		LEFT JOIN Dim.EducationLevelLookup
		ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
			LEFT JOIN Dim.EducationLevel
			ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
		LEFT JOIN Dim.Gender
		ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
		LEFT JOIN Dim.Ethnicity
		ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
	LEFT JOIN Dim.LocalReportingOffice
	ON Dim.LocalReportingOffice.LocalReportingOfficeID=dbo.CaseNoteHeaderFact.LocalReportingOfficeID
		LEFT JOIN Dim.Provider
		ON Dim.Provider.ProviderID=Dim.LocalReportingOffice.ProviderID
			LEFT JOIN Dim.Facility
			ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
				LEFT JOIN Dim.HSDA
				ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
			LEFT JOIN Dim.LevelOfCare
			ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
		LEFT JOIN Dim.CommunityProgram
		ON Dim.CommunityProgram.CommunityProgramID=Dim.LocalReportingOffice.CommunityProgramID
)
MERGE INTO dbo.CaseNoteContactFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.CaseNoteTypeID=src.CaseNoteTypeID,
	dst.SourceReferralID=src.SourceReferralID,
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.GenderID=src.GenderID,
	dst.EthnicityID=src.EthnicityID,
	dst.ReferralPriorityID=src.ReferralPriorityID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.ReasonEndingServiceCodeID=src.ReasonEndingServiceCodeID,
	dst.ReasonEndingServiceID=src.ReasonEndingServiceID,
	dst.ReferralReasonID=src.ReferralReasonID,
	dst.ReferralSourceLookupID=src.ReferralSourceLookupID,
	dst.ReferralSourceID=src.ReferralSourceID,
	dst.DischargeDispositionCodeID=src.DischargeDispositionCodeID,
	dst.DischargeDispositionID=src.DischargeDispositionID,
	dst.ReferralTypeID=src.ReferralTypeID,
	dst.DischargeOutcomeID=src.DischargeOutcomeID,
	dst.CaseNoteReasonID=src.CaseNoteReasonID,
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.GenderID=src.GenderID,
	dst.EthnicityID=src.EthnicityID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.CommunityProgramID=src.CommunityProgramID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='dbo.CaseNoteContactFact', 
@pRuleDesc='', 
@pConditionSQL='', 
@pActionID=, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='', 
@pTargetAttributePhysicalName='', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR dbo.CaseNoteContactFact



--#region BR dbo.PersonFact
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '80e2d1e8-7a27-11e6-b3f6-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		dbo.PersonFact.ETLAuditID,
	Dim.EducationLevelLookup.EducationLevelID
FROM dbo.PersonFact
LEFT JOIN Dim.DeathLocation
ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
LEFT JOIN Dim.EducationLevelLookup
ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
	LEFT JOIN Dim.EducationLevel
	ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
LEFT JOIN Dim.Gender
ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
LEFT JOIN Dim.Ethnicity
ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
)
MERGE INTO dbo.PersonFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.EducationLevelID=src.EducationLevelID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='dbo.PersonFact', 
@pRuleDesc='', 
@pConditionSQL='', 
@pActionID=, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='', 
@pTargetAttributePhysicalName='', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR dbo.PersonFact



--#region BR dbo.HoNOSFact
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '80e45894-7a27-11e6-a0cc-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		dbo.HoNOSFact.ETLAuditID,
	dbo.AssessmentHeaderFact.SourceReferralID
		,dbo.ReferralFact.SourceSystemClientID
		,dbo.PersonFact.DeathLocationID
		,dbo.PersonFact.EducationLevelCodeID
		,Dim.EducationLevelLookup.EducationLevelID
		,dbo.PersonFact.GenderID
		,dbo.PersonFact.EthnicityID
		,dbo.ReferralFact.ReferralPriorityID
		,dbo.ReferralFact.LocalReportingOfficeID
		,Dim.LocalReportingOffice.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,Dim.LocalReportingOffice.CommunityProgramID
		,dbo.ReferralFact.ReasonEndingServiceCodeID
		,Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
		,dbo.ReferralFact.ReferralReasonID
		,dbo.ReferralFact.ReferralSourceLookupID
		,Dim.ReferralSourceLookup.ReferralSourceID
		,dbo.ReferralFact.DischargeDispositionCodeID
		,Dim.DischargeDispositionLookupCOM.DischargeDispositionID
		,dbo.ReferralFact.ReferralTypeID
		,dbo.ReferralFact.DischargeOutcomeID
		,dbo.AssessmentHeaderFact.AssessmentTypeID
		,dbo.AssessmentHeaderFact.AssessmentReasonID
FROM dbo.HoNOSFact
LEFT JOIN dbo.AssessmentHeaderFact
ON dbo.AssessmentHeaderFact.SourceAssessmentID=dbo.HoNOSFact.SourceAssessmentID
	LEFT JOIN dbo.ReferralFact
	ON dbo.ReferralFact.SourceReferralID=dbo.AssessmentHeaderFact.SourceReferralID
		LEFT JOIN dbo.PersonFact
		ON dbo.PersonFact.SourceSystemClientID=dbo.ReferralFact.SourceSystemClientID
			LEFT JOIN Dim.DeathLocation
			ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
			LEFT JOIN Dim.EducationLevelLookup
			ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
				LEFT JOIN Dim.EducationLevel
				ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
			LEFT JOIN Dim.Gender
			ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
			LEFT JOIN Dim.Ethnicity
			ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
		LEFT JOIN Dim.ReferralPriority
		ON Dim.ReferralPriority.ReferralPriorityID=dbo.ReferralFact.ReferralPriorityID
		LEFT JOIN Dim.LocalReportingOffice
		ON Dim.LocalReportingOffice.LocalReportingOfficeID=dbo.ReferralFact.LocalReportingOfficeID
			LEFT JOIN Dim.Provider
			ON Dim.Provider.ProviderID=Dim.LocalReportingOffice.ProviderID
				LEFT JOIN Dim.Facility
				ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
					LEFT JOIN Dim.HSDA
					ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
				LEFT JOIN Dim.LevelOfCare
				ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
			LEFT JOIN Dim.CommunityProgram
			ON Dim.CommunityProgram.CommunityProgramID=Dim.LocalReportingOffice.CommunityProgramID
		LEFT JOIN Dim.ReasonEndingServiceLookup
		ON Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=dbo.ReferralFact.ReasonEndingServiceCodeID
			LEFT JOIN Dim.ReasonEndingService
			ON Dim.ReasonEndingService.ReasonEndingServiceID=Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
		LEFT JOIN Dim.ReferralReason
		ON Dim.ReferralReason.ReferralReasonID=dbo.ReferralFact.ReferralReasonID
		LEFT JOIN Dim.ReferralSourceLookup
		ON Dim.ReferralSourceLookup.ReferralSourceLookupID=dbo.ReferralFact.ReferralSourceLookupID
			LEFT JOIN Dim.ReferralSource
			ON Dim.ReferralSource.ReferralSourceID=Dim.ReferralSourceLookup.ReferralSourceID
		LEFT JOIN Dim.DischargeDispositionLookupCOM
		ON Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=dbo.ReferralFact.DischargeDispositionCodeID
			LEFT JOIN Dim.DischargeDisposition
			ON Dim.DischargeDisposition.DischargeDispositionID=Dim.DischargeDispositionLookupCOM.DischargeDispositionID
		LEFT JOIN Dim.ReferralType
		ON Dim.ReferralType.ReferralTypeID=dbo.ReferralFact.ReferralTypeID
		LEFT JOIN Dim.DischargeOutcome
		ON Dim.DischargeOutcome.DischargeOutcomeID=dbo.ReferralFact.DischargeOutcomeID
	LEFT JOIN Dim.AssessmentType
	ON Dim.AssessmentType.AssessmentTypeID=dbo.AssessmentHeaderFact.AssessmentTypeID
	LEFT JOIN Dim.AssessmentReason
	ON Dim.AssessmentReason.AssessmentReasonID=dbo.AssessmentHeaderFact.AssessmentReasonID
)
MERGE INTO dbo.HoNOSFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.SourceReferralID=src.SourceReferralID,
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.GenderID=src.GenderID,
	dst.EthnicityID=src.EthnicityID,
	dst.ReferralPriorityID=src.ReferralPriorityID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.ReasonEndingServiceCodeID=src.ReasonEndingServiceCodeID,
	dst.ReasonEndingServiceID=src.ReasonEndingServiceID,
	dst.ReferralReasonID=src.ReferralReasonID,
	dst.ReferralSourceLookupID=src.ReferralSourceLookupID,
	dst.ReferralSourceID=src.ReferralSourceID,
	dst.DischargeDispositionCodeID=src.DischargeDispositionCodeID,
	dst.DischargeDispositionID=src.DischargeDispositionID,
	dst.ReferralTypeID=src.ReferralTypeID,
	dst.DischargeOutcomeID=src.DischargeOutcomeID,
	dst.AssessmentTypeID=src.AssessmentTypeID,
	dst.AssessmentReasonID=src.AssessmentReasonID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='dbo.HoNOSFact', 
@pRuleDesc='', 
@pConditionSQL='', 
@pActionID=, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='', 
@pTargetAttributePhysicalName='', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR dbo.HoNOSFact



--#region BR dbo.AddressFact
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '80e6a292-7a27-11e6-bd38-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		dbo.AddressFact.ETLAuditID,
	dbo.PersonFact.DeathLocationID
		,dbo.PersonFact.EducationLevelCodeID
		,Dim.EducationLevelLookup.EducationLevelID
		,dbo.PersonFact.GenderID
		,dbo.PersonFact.EthnicityID
FROM dbo.AddressFact
LEFT JOIN Dim.AddressType
ON Dim.AddressType.AddressTypeID=dbo.AddressFact.AddressTypeID
LEFT JOIN Dim.HouseType
ON Dim.HouseType.HouseTypeID=dbo.AddressFact.HouseTypeID
LEFT JOIN dbo.PersonFact
ON dbo.PersonFact.SourceSystemClientID=dbo.AddressFact.SourceSystemClientID
	LEFT JOIN Dim.DeathLocation
	ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
	LEFT JOIN Dim.EducationLevelLookup
	ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
		LEFT JOIN Dim.EducationLevel
		ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
	LEFT JOIN Dim.Gender
	ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
	LEFT JOIN Dim.Ethnicity
	ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
LEFT JOIN Dim.PostalCode
ON Dim.PostalCode.PostalCodeID=dbo.AddressFact.PostalCodeID
)
MERGE INTO dbo.AddressFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.DeathLocationID=src.DeathLocationID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.GenderID=src.GenderID,
	dst.EthnicityID=src.EthnicityID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='dbo.AddressFact', 
@pRuleDesc='', 
@pConditionSQL='', 
@pActionID=, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='', 
@pTargetAttributePhysicalName='', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR dbo.AddressFact



--#region BR dbo.CaseNoteHeaderFact
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '80e8504c-7a27-11e6-ba9d-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		dbo.CaseNoteHeaderFact.ETLAuditID,
	dbo.ReferralFact.SourceSystemClientID
		,dbo.PersonFact.DeathLocationID
		,dbo.PersonFact.EducationLevelCodeID
		,Dim.EducationLevelLookup.EducationLevelID
		,dbo.PersonFact.GenderID
		,dbo.PersonFact.EthnicityID
		,dbo.ReferralFact.ReferralPriorityID
		,dbo.ReferralFact.LocalReportingOfficeID
		,Dim.LocalReportingOffice.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,Dim.LocalReportingOffice.CommunityProgramID
		,dbo.ReferralFact.ReasonEndingServiceCodeID
		,Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
		,dbo.ReferralFact.ReferralReasonID
		,dbo.ReferralFact.ReferralSourceLookupID
		,Dim.ReferralSourceLookup.ReferralSourceID
		,dbo.ReferralFact.DischargeDispositionCodeID
		,Dim.DischargeDispositionLookupCOM.DischargeDispositionID
		,dbo.ReferralFact.ReferralTypeID
		,dbo.ReferralFact.DischargeOutcomeID
		,dbo.PersonFact.DeathLocationID
		,dbo.PersonFact.EducationLevelCodeID
		,Dim.EducationLevelLookup.EducationLevelID
		,dbo.PersonFact.GenderID
		,dbo.PersonFact.EthnicityID
		,Dim.LocalReportingOffice.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,Dim.LocalReportingOffice.CommunityProgramID
FROM dbo.CaseNoteHeaderFact
LEFT JOIN Dim.CaseNoteType
ON Dim.CaseNoteType.CaseNoteTypeID=dbo.CaseNoteHeaderFact.CaseNoteTypeID
LEFT JOIN dbo.ReferralFact
ON dbo.ReferralFact.SourceReferralID=dbo.CaseNoteHeaderFact.SourceReferralID
	LEFT JOIN dbo.PersonFact
	ON dbo.PersonFact.SourceSystemClientID=dbo.ReferralFact.SourceSystemClientID
		LEFT JOIN Dim.DeathLocation
		ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
		LEFT JOIN Dim.EducationLevelLookup
		ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
			LEFT JOIN Dim.EducationLevel
			ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
		LEFT JOIN Dim.Gender
		ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
		LEFT JOIN Dim.Ethnicity
		ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
	LEFT JOIN Dim.ReferralPriority
	ON Dim.ReferralPriority.ReferralPriorityID=dbo.ReferralFact.ReferralPriorityID
	LEFT JOIN Dim.LocalReportingOffice
	ON Dim.LocalReportingOffice.LocalReportingOfficeID=dbo.ReferralFact.LocalReportingOfficeID
		LEFT JOIN Dim.Provider
		ON Dim.Provider.ProviderID=Dim.LocalReportingOffice.ProviderID
			LEFT JOIN Dim.Facility
			ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
				LEFT JOIN Dim.HSDA
				ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
			LEFT JOIN Dim.LevelOfCare
			ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
		LEFT JOIN Dim.CommunityProgram
		ON Dim.CommunityProgram.CommunityProgramID=Dim.LocalReportingOffice.CommunityProgramID
	LEFT JOIN Dim.ReasonEndingServiceLookup
	ON Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=dbo.ReferralFact.ReasonEndingServiceCodeID
		LEFT JOIN Dim.ReasonEndingService
		ON Dim.ReasonEndingService.ReasonEndingServiceID=Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
	LEFT JOIN Dim.ReferralReason
	ON Dim.ReferralReason.ReferralReasonID=dbo.ReferralFact.ReferralReasonID
	LEFT JOIN Dim.ReferralSourceLookup
	ON Dim.ReferralSourceLookup.ReferralSourceLookupID=dbo.ReferralFact.ReferralSourceLookupID
		LEFT JOIN Dim.ReferralSource
		ON Dim.ReferralSource.ReferralSourceID=Dim.ReferralSourceLookup.ReferralSourceID
	LEFT JOIN Dim.DischargeDispositionLookupCOM
	ON Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=dbo.ReferralFact.DischargeDispositionCodeID
		LEFT JOIN Dim.DischargeDisposition
		ON Dim.DischargeDisposition.DischargeDispositionID=Dim.DischargeDispositionLookupCOM.DischargeDispositionID
	LEFT JOIN Dim.ReferralType
	ON Dim.ReferralType.ReferralTypeID=dbo.ReferralFact.ReferralTypeID
	LEFT JOIN Dim.DischargeOutcome
	ON Dim.DischargeOutcome.DischargeOutcomeID=dbo.ReferralFact.DischargeOutcomeID
LEFT JOIN Dim.CaseNoteReason
ON Dim.CaseNoteReason.CaseNoteReasonID=dbo.CaseNoteHeaderFact.CaseNoteReasonID
LEFT JOIN dbo.PersonFact
ON dbo.PersonFact.SourceSystemClientID=dbo.CaseNoteHeaderFact.SourceSystemClientID
	LEFT JOIN Dim.DeathLocation
	ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
	LEFT JOIN Dim.EducationLevelLookup
	ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
		LEFT JOIN Dim.EducationLevel
		ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
	LEFT JOIN Dim.Gender
	ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
	LEFT JOIN Dim.Ethnicity
	ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
LEFT JOIN Dim.LocalReportingOffice
ON Dim.LocalReportingOffice.LocalReportingOfficeID=dbo.CaseNoteHeaderFact.LocalReportingOfficeID
	LEFT JOIN Dim.Provider
	ON Dim.Provider.ProviderID=Dim.LocalReportingOffice.ProviderID
		LEFT JOIN Dim.Facility
		ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
			LEFT JOIN Dim.HSDA
			ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
		LEFT JOIN Dim.LevelOfCare
		ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
	LEFT JOIN Dim.CommunityProgram
	ON Dim.CommunityProgram.CommunityProgramID=Dim.LocalReportingOffice.CommunityProgramID
)
MERGE INTO dbo.CaseNoteHeaderFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.GenderID=src.GenderID,
	dst.EthnicityID=src.EthnicityID,
	dst.ReferralPriorityID=src.ReferralPriorityID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.ReasonEndingServiceCodeID=src.ReasonEndingServiceCodeID,
	dst.ReasonEndingServiceID=src.ReasonEndingServiceID,
	dst.ReferralReasonID=src.ReferralReasonID,
	dst.ReferralSourceLookupID=src.ReferralSourceLookupID,
	dst.ReferralSourceID=src.ReferralSourceID,
	dst.DischargeDispositionCodeID=src.DischargeDispositionCodeID,
	dst.DischargeDispositionID=src.DischargeDispositionID,
	dst.ReferralTypeID=src.ReferralTypeID,
	dst.DischargeOutcomeID=src.DischargeOutcomeID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.GenderID=src.GenderID,
	dst.EthnicityID=src.EthnicityID,
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.CommunityProgramID=src.CommunityProgramID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='dbo.CaseNoteHeaderFact', 
@pRuleDesc='', 
@pConditionSQL='', 
@pActionID=, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='', 
@pTargetAttributePhysicalName='', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR dbo.CaseNoteHeaderFact



--#region BR dbo.SchoolHistoryFact
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '80ea9a4a-7a27-11e6-848f-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		dbo.SchoolHistoryFact.ETLAuditID,
	dbo.PersonFact.DeathLocationID
		,dbo.PersonFact.EducationLevelCodeID
		,Dim.EducationLevelLookup.EducationLevelID
		,dbo.PersonFact.GenderID
		,dbo.PersonFact.EthnicityID
FROM dbo.SchoolHistoryFact
LEFT JOIN dbo.PersonFact
ON dbo.PersonFact.SourceSystemClientID=dbo.SchoolHistoryFact.SourceSystemClientID
	LEFT JOIN Dim.DeathLocation
	ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
	LEFT JOIN Dim.EducationLevelLookup
	ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
		LEFT JOIN Dim.EducationLevel
		ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
	LEFT JOIN Dim.Gender
	ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
	LEFT JOIN Dim.Ethnicity
	ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
LEFT JOIN Dim.CommunityServiceLocation
ON Dim.CommunityServiceLocation.CommunityServiceLocationID=dbo.SchoolHistoryFact.CommunityServiceLocationID
)
MERGE INTO dbo.SchoolHistoryFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.DeathLocationID=src.DeathLocationID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.GenderID=src.GenderID,
	dst.EthnicityID=src.EthnicityID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='dbo.SchoolHistoryFact', 
@pRuleDesc='', 
@pConditionSQL='', 
@pActionID=, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='', 
@pTargetAttributePhysicalName='', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR dbo.SchoolHistoryFact



--#region BR dbo.ScreeningResultFact
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '80ec6f18-7a27-11e6-8527-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		dbo.ScreeningResultFact.ETLAuditID,
	dbo.ReferralFact.SourceSystemClientID
		,dbo.PersonFact.DeathLocationID
		,dbo.PersonFact.EducationLevelCodeID
		,Dim.EducationLevelLookup.EducationLevelID
		,dbo.PersonFact.GenderID
		,dbo.PersonFact.EthnicityID
		,dbo.ReferralFact.ReferralPriorityID
		,dbo.ReferralFact.LocalReportingOfficeID
		,Dim.LocalReportingOffice.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,Dim.LocalReportingOffice.CommunityProgramID
		,dbo.ReferralFact.ReasonEndingServiceCodeID
		,Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
		,dbo.ReferralFact.ReferralReasonID
		,dbo.ReferralFact.ReferralSourceLookupID
		,Dim.ReferralSourceLookup.ReferralSourceID
		,dbo.ReferralFact.DischargeDispositionCodeID
		,Dim.DischargeDispositionLookupCOM.DischargeDispositionID
		,dbo.ReferralFact.ReferralTypeID
		,dbo.ReferralFact.DischargeOutcomeID
		,dbo.PersonFact.DeathLocationID
		,dbo.PersonFact.EducationLevelCodeID
		,Dim.EducationLevelLookup.EducationLevelID
		,dbo.PersonFact.GenderID
		,dbo.PersonFact.EthnicityID
		,Dim.LocalReportingOffice.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,Dim.LocalReportingOffice.CommunityProgramID
FROM dbo.ScreeningResultFact
LEFT JOIN dbo.ReferralFact
ON dbo.ReferralFact.SourceReferralID=dbo.ScreeningResultFact.SourceReferralID
	LEFT JOIN dbo.PersonFact
	ON dbo.PersonFact.SourceSystemClientID=dbo.ReferralFact.SourceSystemClientID
		LEFT JOIN Dim.DeathLocation
		ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
		LEFT JOIN Dim.EducationLevelLookup
		ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
			LEFT JOIN Dim.EducationLevel
			ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
		LEFT JOIN Dim.Gender
		ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
		LEFT JOIN Dim.Ethnicity
		ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
	LEFT JOIN Dim.ReferralPriority
	ON Dim.ReferralPriority.ReferralPriorityID=dbo.ReferralFact.ReferralPriorityID
	LEFT JOIN Dim.LocalReportingOffice
	ON Dim.LocalReportingOffice.LocalReportingOfficeID=dbo.ReferralFact.LocalReportingOfficeID
		LEFT JOIN Dim.Provider
		ON Dim.Provider.ProviderID=Dim.LocalReportingOffice.ProviderID
			LEFT JOIN Dim.Facility
			ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
				LEFT JOIN Dim.HSDA
				ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
			LEFT JOIN Dim.LevelOfCare
			ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
		LEFT JOIN Dim.CommunityProgram
		ON Dim.CommunityProgram.CommunityProgramID=Dim.LocalReportingOffice.CommunityProgramID
	LEFT JOIN Dim.ReasonEndingServiceLookup
	ON Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=dbo.ReferralFact.ReasonEndingServiceCodeID
		LEFT JOIN Dim.ReasonEndingService
		ON Dim.ReasonEndingService.ReasonEndingServiceID=Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
	LEFT JOIN Dim.ReferralReason
	ON Dim.ReferralReason.ReferralReasonID=dbo.ReferralFact.ReferralReasonID
	LEFT JOIN Dim.ReferralSourceLookup
	ON Dim.ReferralSourceLookup.ReferralSourceLookupID=dbo.ReferralFact.ReferralSourceLookupID
		LEFT JOIN Dim.ReferralSource
		ON Dim.ReferralSource.ReferralSourceID=Dim.ReferralSourceLookup.ReferralSourceID
	LEFT JOIN Dim.DischargeDispositionLookupCOM
	ON Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=dbo.ReferralFact.DischargeDispositionCodeID
		LEFT JOIN Dim.DischargeDisposition
		ON Dim.DischargeDisposition.DischargeDispositionID=Dim.DischargeDispositionLookupCOM.DischargeDispositionID
	LEFT JOIN Dim.ReferralType
	ON Dim.ReferralType.ReferralTypeID=dbo.ReferralFact.ReferralTypeID
	LEFT JOIN Dim.DischargeOutcome
	ON Dim.DischargeOutcome.DischargeOutcomeID=dbo.ReferralFact.DischargeOutcomeID
LEFT JOIN dbo.PersonFact
ON dbo.PersonFact.SourceSystemClientID=dbo.ScreeningResultFact.SourceSystemClientID
	LEFT JOIN Dim.DeathLocation
	ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
	LEFT JOIN Dim.EducationLevelLookup
	ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
		LEFT JOIN Dim.EducationLevel
		ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
	LEFT JOIN Dim.Gender
	ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
	LEFT JOIN Dim.Ethnicity
	ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
LEFT JOIN Dim.LocalReportingOffice
ON Dim.LocalReportingOffice.LocalReportingOfficeID=dbo.ScreeningResultFact.LocalReportingOfficeID
	LEFT JOIN Dim.Provider
	ON Dim.Provider.ProviderID=Dim.LocalReportingOffice.ProviderID
		LEFT JOIN Dim.Facility
		ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
			LEFT JOIN Dim.HSDA
			ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
		LEFT JOIN Dim.LevelOfCare
		ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
	LEFT JOIN Dim.CommunityProgram
	ON Dim.CommunityProgram.CommunityProgramID=Dim.LocalReportingOffice.CommunityProgramID
LEFT JOIN Dim.ScreeningEventResult
ON Dim.ScreeningEventResult.ScreeningEventResultID=dbo.ScreeningResultFact.ScreeningEventResultID
LEFT JOIN Dim.ScreeningEvent
ON Dim.ScreeningEvent.ScreeningEventID=dbo.ScreeningResultFact.ScreeningEventID
LEFT JOIN Dim.CommunityServiceLocation
ON Dim.CommunityServiceLocation.CommunityServiceLocationID=dbo.ScreeningResultFact.CommunityServiceLocationID
)
MERGE INTO dbo.ScreeningResultFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.GenderID=src.GenderID,
	dst.EthnicityID=src.EthnicityID,
	dst.ReferralPriorityID=src.ReferralPriorityID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.ReasonEndingServiceCodeID=src.ReasonEndingServiceCodeID,
	dst.ReasonEndingServiceID=src.ReasonEndingServiceID,
	dst.ReferralReasonID=src.ReferralReasonID,
	dst.ReferralSourceLookupID=src.ReferralSourceLookupID,
	dst.ReferralSourceID=src.ReferralSourceID,
	dst.DischargeDispositionCodeID=src.DischargeDispositionCodeID,
	dst.DischargeDispositionID=src.DischargeDispositionID,
	dst.ReferralTypeID=src.ReferralTypeID,
	dst.DischargeOutcomeID=src.DischargeOutcomeID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.GenderID=src.GenderID,
	dst.EthnicityID=src.EthnicityID,
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.CommunityProgramID=src.CommunityProgramID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='dbo.ScreeningResultFact', 
@pRuleDesc='', 
@pConditionSQL='', 
@pActionID=, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='', 
@pTargetAttributePhysicalName='', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR dbo.ScreeningResultFact



--#region BR dbo.CurrentLocationFact
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '80eeb918-7a27-11e6-a39d-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		dbo.CurrentLocationFact.ETLAuditID,
	Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,Dim.LocalReportingOffice.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,Dim.LocalReportingOffice.CommunityProgramID
		,Dim.LHA.HSDAID
		,dbo.PersonFact.DeathLocationID
		,dbo.PersonFact.EducationLevelCodeID
		,Dim.EducationLevelLookup.EducationLevelID
		,dbo.PersonFact.GenderID
		,dbo.PersonFact.EthnicityID
FROM dbo.CurrentLocationFact
LEFT JOIN Dim.LocationType
ON Dim.LocationType.LocationTypeID=dbo.CurrentLocationFact.LocationTypeID
LEFT JOIN Dim.Provider
ON Dim.Provider.ProviderID=dbo.CurrentLocationFact.ProviderID
	LEFT JOIN Dim.Facility
	ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
		LEFT JOIN Dim.HSDA
		ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
	LEFT JOIN Dim.LevelOfCare
	ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
LEFT JOIN Dim.LocalReportingOffice
ON Dim.LocalReportingOffice.LocalReportingOfficeID=dbo.CurrentLocationFact.LocalReportingOfficeID
	LEFT JOIN Dim.Provider
	ON Dim.Provider.ProviderID=Dim.LocalReportingOffice.ProviderID
		LEFT JOIN Dim.Facility
		ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
			LEFT JOIN Dim.HSDA
			ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
		LEFT JOIN Dim.LevelOfCare
		ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
	LEFT JOIN Dim.CommunityProgram
	ON Dim.CommunityProgram.CommunityProgramID=Dim.LocalReportingOffice.CommunityProgramID
LEFT JOIN Dim.LHA
ON Dim.LHA.LHAID=dbo.CurrentLocationFact.LHAID
	LEFT JOIN Dim.HSDA
	ON Dim.HSDA.HSDAID=Dim.LHA.HSDAID
LEFT JOIN Dim.PostalCode
ON Dim.PostalCode.PostalCodeID=dbo.CurrentLocationFact.PostalCodeID
LEFT JOIN Dim.Province
ON Dim.Province.ProvinceID=dbo.CurrentLocationFact.ProvinceID
LEFT JOIN dbo.PersonFact
ON dbo.PersonFact.SourceSystemClientID=dbo.CurrentLocationFact.SourceSystemClientID
	LEFT JOIN Dim.DeathLocation
	ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
	LEFT JOIN Dim.EducationLevelLookup
	ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
		LEFT JOIN Dim.EducationLevel
		ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
	LEFT JOIN Dim.Gender
	ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
	LEFT JOIN Dim.Ethnicity
	ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
)
MERGE INTO dbo.CurrentLocationFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.HSDAID=src.HSDAID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.GenderID=src.GenderID,
	dst.EthnicityID=src.EthnicityID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='dbo.CurrentLocationFact', 
@pRuleDesc='', 
@pConditionSQL='', 
@pActionID=, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='', 
@pTargetAttributePhysicalName='', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR dbo.CurrentLocationFact



--#region BR dbo.WaitlistProviderOfferFact
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '80f08de4-7a27-11e6-ab58-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		dbo.WaitlistProviderOfferFact.ETLAuditID,
	dbo.WaitlistDefinitionFact.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,dbo.WaitlistDefinitionFact.WaitlistTypeID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
FROM dbo.WaitlistProviderOfferFact
LEFT JOIN dbo.WaitlistDefinitionFact
ON dbo.WaitlistDefinitionFact.SourceWaitlistDefinitionID=dbo.WaitlistProviderOfferFact.SourceWaitlistDefinitionID
	LEFT JOIN Dim.Provider
	ON Dim.Provider.ProviderID=dbo.WaitlistDefinitionFact.ProviderID
		LEFT JOIN Dim.Facility
		ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
			LEFT JOIN Dim.HSDA
			ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
		LEFT JOIN Dim.LevelOfCare
		ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
	LEFT JOIN Dim.WaitlistType
	ON Dim.WaitlistType.WaitlistTypeID=dbo.WaitlistDefinitionFact.WaitlistTypeID
LEFT JOIN Dim.Provider
ON Dim.Provider.ProviderID=dbo.WaitlistProviderOfferFact.ProviderID
	LEFT JOIN Dim.Facility
	ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
		LEFT JOIN Dim.HSDA
		ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
	LEFT JOIN Dim.LevelOfCare
	ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
LEFT JOIN Dim.WaitlistProviderOfferStatus
ON Dim.WaitlistProviderOfferStatus.WaitlistProviderOfferStatusID=dbo.WaitlistProviderOfferFact.WaitlistProviderOfferStatusID
LEFT JOIN Dim.WaitlistReasonOfferRemoved
ON Dim.WaitlistReasonOfferRemoved.WaitlistReasonOfferRemovedID=dbo.WaitlistProviderOfferFact.WaitlistReasonOfferRemovedID
)
MERGE INTO dbo.WaitlistProviderOfferFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.WaitlistTypeID=src.WaitlistTypeID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='dbo.WaitlistProviderOfferFact', 
@pRuleDesc='', 
@pConditionSQL='', 
@pActionID=, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='', 
@pTargetAttributePhysicalName='', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR dbo.WaitlistProviderOfferFact



--#region BR dbo.SubstanceUseFact
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '80f2d7e4-7a27-11e6-8cc9-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		dbo.SubstanceUseFact.ETLAuditID,
	dbo.AssessmentHeaderFact.SourceReferralID
		,dbo.ReferralFact.SourceSystemClientID
		,dbo.PersonFact.DeathLocationID
		,dbo.PersonFact.EducationLevelCodeID
		,Dim.EducationLevelLookup.EducationLevelID
		,dbo.PersonFact.GenderID
		,dbo.PersonFact.EthnicityID
		,dbo.ReferralFact.ReferralPriorityID
		,dbo.ReferralFact.LocalReportingOfficeID
		,Dim.LocalReportingOffice.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,Dim.LocalReportingOffice.CommunityProgramID
		,dbo.ReferralFact.ReasonEndingServiceCodeID
		,Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
		,dbo.ReferralFact.ReferralReasonID
		,dbo.ReferralFact.ReferralSourceLookupID
		,Dim.ReferralSourceLookup.ReferralSourceID
		,dbo.ReferralFact.DischargeDispositionCodeID
		,Dim.DischargeDispositionLookupCOM.DischargeDispositionID
		,dbo.ReferralFact.ReferralTypeID
		,dbo.ReferralFact.DischargeOutcomeID
		,dbo.AssessmentHeaderFact.AssessmentTypeID
		,dbo.AssessmentHeaderFact.AssessmentReasonID
FROM dbo.SubstanceUseFact
LEFT JOIN dbo.AssessmentHeaderFact
ON dbo.AssessmentHeaderFact.SourceAssessmentID=dbo.SubstanceUseFact.SourceAssessmentID
	LEFT JOIN dbo.ReferralFact
	ON dbo.ReferralFact.SourceReferralID=dbo.AssessmentHeaderFact.SourceReferralID
		LEFT JOIN dbo.PersonFact
		ON dbo.PersonFact.SourceSystemClientID=dbo.ReferralFact.SourceSystemClientID
			LEFT JOIN Dim.DeathLocation
			ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
			LEFT JOIN Dim.EducationLevelLookup
			ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
				LEFT JOIN Dim.EducationLevel
				ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
			LEFT JOIN Dim.Gender
			ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
			LEFT JOIN Dim.Ethnicity
			ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
		LEFT JOIN Dim.ReferralPriority
		ON Dim.ReferralPriority.ReferralPriorityID=dbo.ReferralFact.ReferralPriorityID
		LEFT JOIN Dim.LocalReportingOffice
		ON Dim.LocalReportingOffice.LocalReportingOfficeID=dbo.ReferralFact.LocalReportingOfficeID
			LEFT JOIN Dim.Provider
			ON Dim.Provider.ProviderID=Dim.LocalReportingOffice.ProviderID
				LEFT JOIN Dim.Facility
				ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
					LEFT JOIN Dim.HSDA
					ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
				LEFT JOIN Dim.LevelOfCare
				ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
			LEFT JOIN Dim.CommunityProgram
			ON Dim.CommunityProgram.CommunityProgramID=Dim.LocalReportingOffice.CommunityProgramID
		LEFT JOIN Dim.ReasonEndingServiceLookup
		ON Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=dbo.ReferralFact.ReasonEndingServiceCodeID
			LEFT JOIN Dim.ReasonEndingService
			ON Dim.ReasonEndingService.ReasonEndingServiceID=Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
		LEFT JOIN Dim.ReferralReason
		ON Dim.ReferralReason.ReferralReasonID=dbo.ReferralFact.ReferralReasonID
		LEFT JOIN Dim.ReferralSourceLookup
		ON Dim.ReferralSourceLookup.ReferralSourceLookupID=dbo.ReferralFact.ReferralSourceLookupID
			LEFT JOIN Dim.ReferralSource
			ON Dim.ReferralSource.ReferralSourceID=Dim.ReferralSourceLookup.ReferralSourceID
		LEFT JOIN Dim.DischargeDispositionLookupCOM
		ON Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=dbo.ReferralFact.DischargeDispositionCodeID
			LEFT JOIN Dim.DischargeDisposition
			ON Dim.DischargeDisposition.DischargeDispositionID=Dim.DischargeDispositionLookupCOM.DischargeDispositionID
		LEFT JOIN Dim.ReferralType
		ON Dim.ReferralType.ReferralTypeID=dbo.ReferralFact.ReferralTypeID
		LEFT JOIN Dim.DischargeOutcome
		ON Dim.DischargeOutcome.DischargeOutcomeID=dbo.ReferralFact.DischargeOutcomeID
	LEFT JOIN Dim.AssessmentType
	ON Dim.AssessmentType.AssessmentTypeID=dbo.AssessmentHeaderFact.AssessmentTypeID
	LEFT JOIN Dim.AssessmentReason
	ON Dim.AssessmentReason.AssessmentReasonID=dbo.AssessmentHeaderFact.AssessmentReasonID
LEFT JOIN Dim.MethodOfSubstanceIntake
ON Dim.MethodOfSubstanceIntake.MethodOfSubstanceIntakeID=dbo.SubstanceUseFact.MethodOfSubstanceIntakeID
LEFT JOIN Dim.SubstanceUseLookup
ON Dim.SubstanceUseLookup.SubstanceUseCodeID=dbo.SubstanceUseFact.SubstanceUseCodeID
)
MERGE INTO dbo.SubstanceUseFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.SourceReferralID=src.SourceReferralID,
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.GenderID=src.GenderID,
	dst.EthnicityID=src.EthnicityID,
	dst.ReferralPriorityID=src.ReferralPriorityID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.ReasonEndingServiceCodeID=src.ReasonEndingServiceCodeID,
	dst.ReasonEndingServiceID=src.ReasonEndingServiceID,
	dst.ReferralReasonID=src.ReferralReasonID,
	dst.ReferralSourceLookupID=src.ReferralSourceLookupID,
	dst.ReferralSourceID=src.ReferralSourceID,
	dst.DischargeDispositionCodeID=src.DischargeDispositionCodeID,
	dst.DischargeDispositionID=src.DischargeDispositionID,
	dst.ReferralTypeID=src.ReferralTypeID,
	dst.DischargeOutcomeID=src.DischargeOutcomeID,
	dst.AssessmentTypeID=src.AssessmentTypeID,
	dst.AssessmentReasonID=src.AssessmentReasonID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='dbo.SubstanceUseFact', 
@pRuleDesc='', 
@pConditionSQL='', 
@pActionID=, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='', 
@pTargetAttributePhysicalName='', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR dbo.SubstanceUseFact



--#region BR dbo.HCRSAssessmentFact
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '80f4fad2-7a27-11e6-8bb4-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		dbo.HCRSAssessmentFact.ETLAuditID,
	dbo.ReferralFact.SourceSystemClientID
		,dbo.PersonFact.DeathLocationID
		,dbo.PersonFact.EducationLevelCodeID
		,Dim.EducationLevelLookup.EducationLevelID
		,dbo.PersonFact.GenderID
		,dbo.PersonFact.EthnicityID
		,dbo.ReferralFact.ReferralPriorityID
		,dbo.ReferralFact.LocalReportingOfficeID
		,Dim.LocalReportingOffice.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,Dim.LocalReportingOffice.CommunityProgramID
		,dbo.ReferralFact.ReasonEndingServiceCodeID
		,Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
		,dbo.ReferralFact.ReferralReasonID
		,dbo.ReferralFact.ReferralSourceLookupID
		,Dim.ReferralSourceLookup.ReferralSourceID
		,dbo.ReferralFact.DischargeDispositionCodeID
		,Dim.DischargeDispositionLookupCOM.DischargeDispositionID
		,dbo.ReferralFact.ReferralTypeID
		,dbo.ReferralFact.DischargeOutcomeID
		,dbo.PersonFact.DeathLocationID
		,dbo.PersonFact.EducationLevelCodeID
		,Dim.EducationLevelLookup.EducationLevelID
		,dbo.PersonFact.GenderID
		,dbo.PersonFact.EthnicityID
		,Dim.LocalReportingOffice.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,Dim.LocalReportingOffice.CommunityProgramID
FROM dbo.HCRSAssessmentFact
LEFT JOIN dbo.ReferralFact
ON dbo.ReferralFact.SourceReferralID=dbo.HCRSAssessmentFact.SourceReferralID
	LEFT JOIN dbo.PersonFact
	ON dbo.PersonFact.SourceSystemClientID=dbo.ReferralFact.SourceSystemClientID
		LEFT JOIN Dim.DeathLocation
		ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
		LEFT JOIN Dim.EducationLevelLookup
		ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
			LEFT JOIN Dim.EducationLevel
			ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
		LEFT JOIN Dim.Gender
		ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
		LEFT JOIN Dim.Ethnicity
		ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
	LEFT JOIN Dim.ReferralPriority
	ON Dim.ReferralPriority.ReferralPriorityID=dbo.ReferralFact.ReferralPriorityID
	LEFT JOIN Dim.LocalReportingOffice
	ON Dim.LocalReportingOffice.LocalReportingOfficeID=dbo.ReferralFact.LocalReportingOfficeID
		LEFT JOIN Dim.Provider
		ON Dim.Provider.ProviderID=Dim.LocalReportingOffice.ProviderID
			LEFT JOIN Dim.Facility
			ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
				LEFT JOIN Dim.HSDA
				ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
			LEFT JOIN Dim.LevelOfCare
			ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
		LEFT JOIN Dim.CommunityProgram
		ON Dim.CommunityProgram.CommunityProgramID=Dim.LocalReportingOffice.CommunityProgramID
	LEFT JOIN Dim.ReasonEndingServiceLookup
	ON Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=dbo.ReferralFact.ReasonEndingServiceCodeID
		LEFT JOIN Dim.ReasonEndingService
		ON Dim.ReasonEndingService.ReasonEndingServiceID=Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
	LEFT JOIN Dim.ReferralReason
	ON Dim.ReferralReason.ReferralReasonID=dbo.ReferralFact.ReferralReasonID
	LEFT JOIN Dim.ReferralSourceLookup
	ON Dim.ReferralSourceLookup.ReferralSourceLookupID=dbo.ReferralFact.ReferralSourceLookupID
		LEFT JOIN Dim.ReferralSource
		ON Dim.ReferralSource.ReferralSourceID=Dim.ReferralSourceLookup.ReferralSourceID
	LEFT JOIN Dim.DischargeDispositionLookupCOM
	ON Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=dbo.ReferralFact.DischargeDispositionCodeID
		LEFT JOIN Dim.DischargeDisposition
		ON Dim.DischargeDisposition.DischargeDispositionID=Dim.DischargeDispositionLookupCOM.DischargeDispositionID
	LEFT JOIN Dim.ReferralType
	ON Dim.ReferralType.ReferralTypeID=dbo.ReferralFact.ReferralTypeID
	LEFT JOIN Dim.DischargeOutcome
	ON Dim.DischargeOutcome.DischargeOutcomeID=dbo.ReferralFact.DischargeOutcomeID
LEFT JOIN Dim.ReferralReason
ON Dim.ReferralReason.ReferralReasonID=dbo.HCRSAssessmentFact.ReferralReasonID
LEFT JOIN dbo.PersonFact
ON dbo.PersonFact.SourceSystemClientID=dbo.HCRSAssessmentFact.SourceSystemClientID
	LEFT JOIN Dim.DeathLocation
	ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
	LEFT JOIN Dim.EducationLevelLookup
	ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
		LEFT JOIN Dim.EducationLevel
		ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
	LEFT JOIN Dim.Gender
	ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
	LEFT JOIN Dim.Ethnicity
	ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
LEFT JOIN Dim.LocalReportingOffice
ON Dim.LocalReportingOffice.LocalReportingOfficeID=dbo.HCRSAssessmentFact.LocalReportingOfficeID
	LEFT JOIN Dim.Provider
	ON Dim.Provider.ProviderID=Dim.LocalReportingOffice.ProviderID
		LEFT JOIN Dim.Facility
		ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
			LEFT JOIN Dim.HSDA
			ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
		LEFT JOIN Dim.LevelOfCare
		ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
	LEFT JOIN Dim.CommunityProgram
	ON Dim.CommunityProgram.CommunityProgramID=Dim.LocalReportingOffice.CommunityProgramID
)
MERGE INTO dbo.HCRSAssessmentFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.GenderID=src.GenderID,
	dst.EthnicityID=src.EthnicityID,
	dst.ReferralPriorityID=src.ReferralPriorityID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.ReasonEndingServiceCodeID=src.ReasonEndingServiceCodeID,
	dst.ReasonEndingServiceID=src.ReasonEndingServiceID,
	dst.ReferralReasonID=src.ReferralReasonID,
	dst.ReferralSourceLookupID=src.ReferralSourceLookupID,
	dst.ReferralSourceID=src.ReferralSourceID,
	dst.DischargeDispositionCodeID=src.DischargeDispositionCodeID,
	dst.DischargeDispositionID=src.DischargeDispositionID,
	dst.ReferralTypeID=src.ReferralTypeID,
	dst.DischargeOutcomeID=src.DischargeOutcomeID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.GenderID=src.GenderID,
	dst.EthnicityID=src.EthnicityID,
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.CommunityProgramID=src.CommunityProgramID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='dbo.HCRSAssessmentFact', 
@pRuleDesc='', 
@pConditionSQL='', 
@pActionID=, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='', 
@pTargetAttributePhysicalName='', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR dbo.HCRSAssessmentFact



--#region BR dbo.WaitlistClientOfferFact
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '80f792f0-7a27-11e6-9406-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		dbo.WaitlistClientOfferFact.ETLAuditID,
	dbo.WaitlistEntryFact.SourceWaitlistDefinitionID
		,dbo.WaitlistDefinitionFact.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,dbo.WaitlistDefinitionFact.WaitlistTypeID
		,dbo.WaitlistEntryFact.WaitlistStatusID
		,dbo.WaitlistEntryFact.LocalReportingOfficeID
		,Dim.LocalReportingOffice.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,Dim.LocalReportingOffice.CommunityProgramID
		,dbo.WaitlistEntryFact.WaitlistPriorityID
		,dbo.WaitlistEntryFact.SourceSystemClientID
		,dbo.PersonFact.DeathLocationID
		,dbo.PersonFact.EducationLevelCodeID
		,Dim.EducationLevelLookup.EducationLevelID
		,dbo.PersonFact.GenderID
		,dbo.PersonFact.EthnicityID
		,dbo.WaitlistEntryFact.WaitListReasonID
		,dbo.WaitlistProviderOfferFact.SourceWaitlistDefinitionID
		,dbo.WaitlistDefinitionFact.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,dbo.WaitlistDefinitionFact.WaitlistTypeID
		,dbo.WaitlistProviderOfferFact.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,dbo.WaitlistProviderOfferFact.WaitlistProviderOfferStatusID
		,dbo.WaitlistProviderOfferFact.WaitlistReasonOfferRemovedID
FROM dbo.WaitlistClientOfferFact
LEFT JOIN Dim.WaitlistClientOfferStatus
ON Dim.WaitlistClientOfferStatus.WaitlistClientOfferStatusID=dbo.WaitlistClientOfferFact.WaitlistClientOfferStatusID
LEFT JOIN Dim.WaitlistReasonNotOffered
ON Dim.WaitlistReasonNotOffered.WaitlistReasonNotOfferedID=dbo.WaitlistClientOfferFact.WaitlistReasonNotOfferedID
LEFT JOIN dbo.WaitlistEntryFact
ON dbo.WaitlistEntryFact.SourceWaitlistEntryID=dbo.WaitlistClientOfferFact.SourceWaitlistEntryID
	LEFT JOIN dbo.WaitlistDefinitionFact
	ON dbo.WaitlistDefinitionFact.SourceWaitlistDefinitionID=dbo.WaitlistEntryFact.SourceWaitlistDefinitionID
		LEFT JOIN Dim.Provider
		ON Dim.Provider.ProviderID=dbo.WaitlistDefinitionFact.ProviderID
			LEFT JOIN Dim.Facility
			ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
				LEFT JOIN Dim.HSDA
				ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
			LEFT JOIN Dim.LevelOfCare
			ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
		LEFT JOIN Dim.WaitlistType
		ON Dim.WaitlistType.WaitlistTypeID=dbo.WaitlistDefinitionFact.WaitlistTypeID
	LEFT JOIN Dim.WaitlistStatus
	ON Dim.WaitlistStatus.WaitlistStatusID=dbo.WaitlistEntryFact.WaitlistStatusID
	LEFT JOIN Dim.LocalReportingOffice
	ON Dim.LocalReportingOffice.LocalReportingOfficeID=dbo.WaitlistEntryFact.LocalReportingOfficeID
		LEFT JOIN Dim.Provider
		ON Dim.Provider.ProviderID=Dim.LocalReportingOffice.ProviderID
			LEFT JOIN Dim.Facility
			ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
				LEFT JOIN Dim.HSDA
				ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
			LEFT JOIN Dim.LevelOfCare
			ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
		LEFT JOIN Dim.CommunityProgram
		ON Dim.CommunityProgram.CommunityProgramID=Dim.LocalReportingOffice.CommunityProgramID
	LEFT JOIN Dim.WaitlistPriority
	ON Dim.WaitlistPriority.WaitlistPriorityID=dbo.WaitlistEntryFact.WaitlistPriorityID
	LEFT JOIN dbo.PersonFact
	ON dbo.PersonFact.SourceSystemClientID=dbo.WaitlistEntryFact.SourceSystemClientID
		LEFT JOIN Dim.DeathLocation
		ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
		LEFT JOIN Dim.EducationLevelLookup
		ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
			LEFT JOIN Dim.EducationLevel
			ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
		LEFT JOIN Dim.Gender
		ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
		LEFT JOIN Dim.Ethnicity
		ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
	LEFT JOIN Dim.WaitListReason
	ON Dim.WaitListReason.WaitListReasonID=dbo.WaitlistEntryFact.WaitListReasonID
LEFT JOIN Dim.WaitlistOfferOutcome
ON Dim.WaitlistOfferOutcome.WaitlistOfferOutcomeID=dbo.WaitlistClientOfferFact.WaitlistOfferOutcomeID
LEFT JOIN Dim.WaitlistReasonRejected
ON Dim.WaitlistReasonRejected.WaitlistReasonRejectedID=dbo.WaitlistClientOfferFact.WaitlistReasonRejectedID
LEFT JOIN dbo.WaitlistProviderOfferFact
ON dbo.WaitlistProviderOfferFact.SourceWaitlistProviderOfferID=dbo.WaitlistClientOfferFact.SourceWaitlistProviderOfferID
	LEFT JOIN dbo.WaitlistDefinitionFact
	ON dbo.WaitlistDefinitionFact.SourceWaitlistDefinitionID=dbo.WaitlistProviderOfferFact.SourceWaitlistDefinitionID
		LEFT JOIN Dim.Provider
		ON Dim.Provider.ProviderID=dbo.WaitlistDefinitionFact.ProviderID
			LEFT JOIN Dim.Facility
			ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
				LEFT JOIN Dim.HSDA
				ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
			LEFT JOIN Dim.LevelOfCare
			ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
		LEFT JOIN Dim.WaitlistType
		ON Dim.WaitlistType.WaitlistTypeID=dbo.WaitlistDefinitionFact.WaitlistTypeID
	LEFT JOIN Dim.Provider
	ON Dim.Provider.ProviderID=dbo.WaitlistProviderOfferFact.ProviderID
		LEFT JOIN Dim.Facility
		ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
			LEFT JOIN Dim.HSDA
			ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
		LEFT JOIN Dim.LevelOfCare
		ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
	LEFT JOIN Dim.WaitlistProviderOfferStatus
	ON Dim.WaitlistProviderOfferStatus.WaitlistProviderOfferStatusID=dbo.WaitlistProviderOfferFact.WaitlistProviderOfferStatusID
	LEFT JOIN Dim.WaitlistReasonOfferRemoved
	ON Dim.WaitlistReasonOfferRemoved.WaitlistReasonOfferRemovedID=dbo.WaitlistProviderOfferFact.WaitlistReasonOfferRemovedID
)
MERGE INTO dbo.WaitlistClientOfferFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.SourceWaitlistDefinitionID=src.SourceWaitlistDefinitionID,
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.WaitlistTypeID=src.WaitlistTypeID,
	dst.WaitlistStatusID=src.WaitlistStatusID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.WaitlistPriorityID=src.WaitlistPriorityID,
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.GenderID=src.GenderID,
	dst.EthnicityID=src.EthnicityID,
	dst.WaitListReasonID=src.WaitListReasonID,
	dst.SourceWaitlistDefinitionID=src.SourceWaitlistDefinitionID,
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.WaitlistTypeID=src.WaitlistTypeID,
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.WaitlistProviderOfferStatusID=src.WaitlistProviderOfferStatusID,
	dst.WaitlistReasonOfferRemovedID=src.WaitlistReasonOfferRemovedID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='dbo.WaitlistClientOfferFact', 
@pRuleDesc='', 
@pConditionSQL='', 
@pActionID=, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='', 
@pTargetAttributePhysicalName='', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR dbo.WaitlistClientOfferFact



--#region BR dbo.InterventionFact
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '80fa0402-7a27-11e6-ab65-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		dbo.InterventionFact.ETLAuditID,
	Dim.Intervention.InterventionTypeID
		,dbo.ReferralFact.SourceSystemClientID
		,dbo.PersonFact.DeathLocationID
		,dbo.PersonFact.EducationLevelCodeID
		,Dim.EducationLevelLookup.EducationLevelID
		,dbo.PersonFact.GenderID
		,dbo.PersonFact.EthnicityID
		,dbo.ReferralFact.ReferralPriorityID
		,dbo.ReferralFact.LocalReportingOfficeID
		,Dim.LocalReportingOffice.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,Dim.LocalReportingOffice.CommunityProgramID
		,dbo.ReferralFact.ReasonEndingServiceCodeID
		,Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
		,dbo.ReferralFact.ReferralReasonID
		,dbo.ReferralFact.ReferralSourceLookupID
		,Dim.ReferralSourceLookup.ReferralSourceID
		,dbo.ReferralFact.DischargeDispositionCodeID
		,Dim.DischargeDispositionLookupCOM.DischargeDispositionID
		,dbo.ReferralFact.ReferralTypeID
		,dbo.ReferralFact.DischargeOutcomeID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
FROM dbo.InterventionFact
LEFT JOIN Dim.Intervention
ON Dim.Intervention.InterventionID=dbo.InterventionFact.InterventionID
	LEFT JOIN Dim.InterventionType
	ON Dim.InterventionType.InterventionTypeID=Dim.Intervention.InterventionTypeID
LEFT JOIN dbo.ReferralFact
ON dbo.ReferralFact.SourceReferralID=dbo.InterventionFact.SourceReferralID
	LEFT JOIN dbo.PersonFact
	ON dbo.PersonFact.SourceSystemClientID=dbo.ReferralFact.SourceSystemClientID
		LEFT JOIN Dim.DeathLocation
		ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
		LEFT JOIN Dim.EducationLevelLookup
		ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
			LEFT JOIN Dim.EducationLevel
			ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
		LEFT JOIN Dim.Gender
		ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
		LEFT JOIN Dim.Ethnicity
		ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
	LEFT JOIN Dim.ReferralPriority
	ON Dim.ReferralPriority.ReferralPriorityID=dbo.ReferralFact.ReferralPriorityID
	LEFT JOIN Dim.LocalReportingOffice
	ON Dim.LocalReportingOffice.LocalReportingOfficeID=dbo.ReferralFact.LocalReportingOfficeID
		LEFT JOIN Dim.Provider
		ON Dim.Provider.ProviderID=Dim.LocalReportingOffice.ProviderID
			LEFT JOIN Dim.Facility
			ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
				LEFT JOIN Dim.HSDA
				ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
			LEFT JOIN Dim.LevelOfCare
			ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
		LEFT JOIN Dim.CommunityProgram
		ON Dim.CommunityProgram.CommunityProgramID=Dim.LocalReportingOffice.CommunityProgramID
	LEFT JOIN Dim.ReasonEndingServiceLookup
	ON Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=dbo.ReferralFact.ReasonEndingServiceCodeID
		LEFT JOIN Dim.ReasonEndingService
		ON Dim.ReasonEndingService.ReasonEndingServiceID=Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
	LEFT JOIN Dim.ReferralReason
	ON Dim.ReferralReason.ReferralReasonID=dbo.ReferralFact.ReferralReasonID
	LEFT JOIN Dim.ReferralSourceLookup
	ON Dim.ReferralSourceLookup.ReferralSourceLookupID=dbo.ReferralFact.ReferralSourceLookupID
		LEFT JOIN Dim.ReferralSource
		ON Dim.ReferralSource.ReferralSourceID=Dim.ReferralSourceLookup.ReferralSourceID
	LEFT JOIN Dim.DischargeDispositionLookupCOM
	ON Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=dbo.ReferralFact.DischargeDispositionCodeID
		LEFT JOIN Dim.DischargeDisposition
		ON Dim.DischargeDisposition.DischargeDispositionID=Dim.DischargeDispositionLookupCOM.DischargeDispositionID
	LEFT JOIN Dim.ReferralType
	ON Dim.ReferralType.ReferralTypeID=dbo.ReferralFact.ReferralTypeID
	LEFT JOIN Dim.DischargeOutcome
	ON Dim.DischargeOutcome.DischargeOutcomeID=dbo.ReferralFact.DischargeOutcomeID
LEFT JOIN Dim.Provider
ON Dim.Provider.ProviderID=dbo.InterventionFact.ProviderID
	LEFT JOIN Dim.Facility
	ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
		LEFT JOIN Dim.HSDA
		ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
	LEFT JOIN Dim.LevelOfCare
	ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
)
MERGE INTO dbo.InterventionFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.InterventionTypeID=src.InterventionTypeID,
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.GenderID=src.GenderID,
	dst.EthnicityID=src.EthnicityID,
	dst.ReferralPriorityID=src.ReferralPriorityID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.ReasonEndingServiceCodeID=src.ReasonEndingServiceCodeID,
	dst.ReasonEndingServiceID=src.ReasonEndingServiceID,
	dst.ReferralReasonID=src.ReferralReasonID,
	dst.ReferralSourceLookupID=src.ReferralSourceLookupID,
	dst.ReferralSourceID=src.ReferralSourceID,
	dst.DischargeDispositionCodeID=src.DischargeDispositionCodeID,
	dst.DischargeDispositionID=src.DischargeDispositionID,
	dst.ReferralTypeID=src.ReferralTypeID,
	dst.DischargeOutcomeID=src.DischargeOutcomeID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='dbo.InterventionFact', 
@pRuleDesc='', 
@pConditionSQL='', 
@pActionID=, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='', 
@pTargetAttributePhysicalName='', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR dbo.InterventionFact



--#region BR dbo.CDPreviousTestResultFact
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '80fbd8cc-7a27-11e6-975d-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		dbo.CDPreviousTestResultFact.ETLAuditID,
	
FROM dbo.CDPreviousTestResultFact
LEFT JOIN Dim.CommunityDisease
ON Dim.CommunityDisease.CommunityDiseaseID=dbo.CDPreviousTestResultFact.CommunityDiseaseID
)
MERGE INTO dbo.CDPreviousTestResultFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 

;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='dbo.CDPreviousTestResultFact', 
@pRuleDesc='', 
@pConditionSQL='', 
@pActionID=, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='', 
@pTargetAttributePhysicalName='', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR dbo.CDPreviousTestResultFact



--#region BR dbo.ImmunizationAlertFact
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '80fd8688-7a27-11e6-99d7-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		dbo.ImmunizationAlertFact.ETLAuditID,
	dbo.PersonFact.DeathLocationID
		,dbo.PersonFact.EducationLevelCodeID
		,Dim.EducationLevelLookup.EducationLevelID
		,dbo.PersonFact.GenderID
		,dbo.PersonFact.EthnicityID
FROM dbo.ImmunizationAlertFact
LEFT JOIN Dim.Antigen
ON Dim.Antigen.AntigenID=dbo.ImmunizationAlertFact.AntigenID
LEFT JOIN dbo.PersonFact
ON dbo.PersonFact.SourceSystemClientID=dbo.ImmunizationAlertFact.SourceSystemClientID
	LEFT JOIN Dim.DeathLocation
	ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
	LEFT JOIN Dim.EducationLevelLookup
	ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
		LEFT JOIN Dim.EducationLevel
		ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
	LEFT JOIN Dim.Gender
	ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
	LEFT JOIN Dim.Ethnicity
	ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
LEFT JOIN Dim.ImmAlert
ON Dim.ImmAlert.ImmAlertID=dbo.ImmunizationAlertFact.ImmAlertID
LEFT JOIN Dim.ImmCategory
ON Dim.ImmCategory.ImmCategoryID=dbo.ImmunizationAlertFact.ImmCategoryID
)
MERGE INTO dbo.ImmunizationAlertFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.DeathLocationID=src.DeathLocationID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.GenderID=src.GenderID,
	dst.EthnicityID=src.EthnicityID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='dbo.ImmunizationAlertFact', 
@pRuleDesc='', 
@pConditionSQL='', 
@pActionID=, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='', 
@pTargetAttributePhysicalName='', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR dbo.ImmunizationAlertFact



--#region BR dbo.CDLabReportFact
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '81021a86-7a27-11e6-8a74-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		dbo.CDLabReportFact.ETLAuditID,
	dbo.AssessmentHeaderFact.SourceReferralID
		,dbo.ReferralFact.SourceSystemClientID
		,dbo.PersonFact.DeathLocationID
		,dbo.PersonFact.EducationLevelCodeID
		,Dim.EducationLevelLookup.EducationLevelID
		,dbo.PersonFact.GenderID
		,dbo.PersonFact.EthnicityID
		,dbo.ReferralFact.ReferralPriorityID
		,dbo.ReferralFact.LocalReportingOfficeID
		,Dim.LocalReportingOffice.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,Dim.LocalReportingOffice.CommunityProgramID
		,dbo.ReferralFact.ReasonEndingServiceCodeID
		,Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
		,dbo.ReferralFact.ReferralReasonID
		,dbo.ReferralFact.ReferralSourceLookupID
		,Dim.ReferralSourceLookup.ReferralSourceID
		,dbo.ReferralFact.DischargeDispositionCodeID
		,Dim.DischargeDispositionLookupCOM.DischargeDispositionID
		,dbo.ReferralFact.ReferralTypeID
		,dbo.ReferralFact.DischargeOutcomeID
		,dbo.AssessmentHeaderFact.AssessmentTypeID
		,dbo.AssessmentHeaderFact.AssessmentReasonID
		,dbo.CDPreviousTestResultFact.CommunityDiseaseID
FROM dbo.CDLabReportFact
LEFT JOIN dbo.AssessmentHeaderFact
ON dbo.AssessmentHeaderFact.SourceAssessmentID=dbo.CDLabReportFact.SourceAssessmentID
	LEFT JOIN dbo.ReferralFact
	ON dbo.ReferralFact.SourceReferralID=dbo.AssessmentHeaderFact.SourceReferralID
		LEFT JOIN dbo.PersonFact
		ON dbo.PersonFact.SourceSystemClientID=dbo.ReferralFact.SourceSystemClientID
			LEFT JOIN Dim.DeathLocation
			ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
			LEFT JOIN Dim.EducationLevelLookup
			ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
				LEFT JOIN Dim.EducationLevel
				ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
			LEFT JOIN Dim.Gender
			ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
			LEFT JOIN Dim.Ethnicity
			ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
		LEFT JOIN Dim.ReferralPriority
		ON Dim.ReferralPriority.ReferralPriorityID=dbo.ReferralFact.ReferralPriorityID
		LEFT JOIN Dim.LocalReportingOffice
		ON Dim.LocalReportingOffice.LocalReportingOfficeID=dbo.ReferralFact.LocalReportingOfficeID
			LEFT JOIN Dim.Provider
			ON Dim.Provider.ProviderID=Dim.LocalReportingOffice.ProviderID
				LEFT JOIN Dim.Facility
				ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
					LEFT JOIN Dim.HSDA
					ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
				LEFT JOIN Dim.LevelOfCare
				ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
			LEFT JOIN Dim.CommunityProgram
			ON Dim.CommunityProgram.CommunityProgramID=Dim.LocalReportingOffice.CommunityProgramID
		LEFT JOIN Dim.ReasonEndingServiceLookup
		ON Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=dbo.ReferralFact.ReasonEndingServiceCodeID
			LEFT JOIN Dim.ReasonEndingService
			ON Dim.ReasonEndingService.ReasonEndingServiceID=Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
		LEFT JOIN Dim.ReferralReason
		ON Dim.ReferralReason.ReferralReasonID=dbo.ReferralFact.ReferralReasonID
		LEFT JOIN Dim.ReferralSourceLookup
		ON Dim.ReferralSourceLookup.ReferralSourceLookupID=dbo.ReferralFact.ReferralSourceLookupID
			LEFT JOIN Dim.ReferralSource
			ON Dim.ReferralSource.ReferralSourceID=Dim.ReferralSourceLookup.ReferralSourceID
		LEFT JOIN Dim.DischargeDispositionLookupCOM
		ON Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=dbo.ReferralFact.DischargeDispositionCodeID
			LEFT JOIN Dim.DischargeDisposition
			ON Dim.DischargeDisposition.DischargeDispositionID=Dim.DischargeDispositionLookupCOM.DischargeDispositionID
		LEFT JOIN Dim.ReferralType
		ON Dim.ReferralType.ReferralTypeID=dbo.ReferralFact.ReferralTypeID
		LEFT JOIN Dim.DischargeOutcome
		ON Dim.DischargeOutcome.DischargeOutcomeID=dbo.ReferralFact.DischargeOutcomeID
	LEFT JOIN Dim.AssessmentType
	ON Dim.AssessmentType.AssessmentTypeID=dbo.AssessmentHeaderFact.AssessmentTypeID
	LEFT JOIN Dim.AssessmentReason
	ON Dim.AssessmentReason.AssessmentReasonID=dbo.AssessmentHeaderFact.AssessmentReasonID
LEFT JOIN dbo.CDPreviousTestResultFact
ON dbo.CDPreviousTestResultFact.SourceAssessmentID=dbo.CDLabReportFact.SourceAssessmentID
	LEFT JOIN Dim.CommunityDisease
	ON Dim.CommunityDisease.CommunityDiseaseID=dbo.CDPreviousTestResultFact.CommunityDiseaseID
)
MERGE INTO dbo.CDLabReportFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.SourceReferralID=src.SourceReferralID,
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.GenderID=src.GenderID,
	dst.EthnicityID=src.EthnicityID,
	dst.ReferralPriorityID=src.ReferralPriorityID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.ReasonEndingServiceCodeID=src.ReasonEndingServiceCodeID,
	dst.ReasonEndingServiceID=src.ReasonEndingServiceID,
	dst.ReferralReasonID=src.ReferralReasonID,
	dst.ReferralSourceLookupID=src.ReferralSourceLookupID,
	dst.ReferralSourceID=src.ReferralSourceID,
	dst.DischargeDispositionCodeID=src.DischargeDispositionCodeID,
	dst.DischargeDispositionID=src.DischargeDispositionID,
	dst.ReferralTypeID=src.ReferralTypeID,
	dst.DischargeOutcomeID=src.DischargeOutcomeID,
	dst.AssessmentTypeID=src.AssessmentTypeID,
	dst.AssessmentReasonID=src.AssessmentReasonID,
	dst.CommunityDiseaseID=src.CommunityDiseaseID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='dbo.CDLabReportFact', 
@pRuleDesc='', 
@pConditionSQL='', 
@pActionID=, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='', 
@pTargetAttributePhysicalName='', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR dbo.CDLabReportFact



--#region BR dbo.AssessmentHeaderFact
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '8104b2a6-7a27-11e6-9114-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		dbo.AssessmentHeaderFact.ETLAuditID,
	dbo.ReferralFact.SourceSystemClientID
		,dbo.PersonFact.DeathLocationID
		,dbo.PersonFact.EducationLevelCodeID
		,Dim.EducationLevelLookup.EducationLevelID
		,dbo.PersonFact.GenderID
		,dbo.PersonFact.EthnicityID
		,dbo.ReferralFact.ReferralPriorityID
		,dbo.ReferralFact.LocalReportingOfficeID
		,Dim.LocalReportingOffice.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,Dim.LocalReportingOffice.CommunityProgramID
		,dbo.ReferralFact.ReasonEndingServiceCodeID
		,Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
		,dbo.ReferralFact.ReferralReasonID
		,dbo.ReferralFact.ReferralSourceLookupID
		,Dim.ReferralSourceLookup.ReferralSourceID
		,dbo.ReferralFact.DischargeDispositionCodeID
		,Dim.DischargeDispositionLookupCOM.DischargeDispositionID
		,dbo.ReferralFact.ReferralTypeID
		,dbo.ReferralFact.DischargeOutcomeID
FROM dbo.AssessmentHeaderFact
LEFT JOIN dbo.ReferralFact
ON dbo.ReferralFact.SourceReferralID=dbo.AssessmentHeaderFact.SourceReferralID
	LEFT JOIN dbo.PersonFact
	ON dbo.PersonFact.SourceSystemClientID=dbo.ReferralFact.SourceSystemClientID
		LEFT JOIN Dim.DeathLocation
		ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
		LEFT JOIN Dim.EducationLevelLookup
		ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
			LEFT JOIN Dim.EducationLevel
			ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
		LEFT JOIN Dim.Gender
		ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
		LEFT JOIN Dim.Ethnicity
		ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
	LEFT JOIN Dim.ReferralPriority
	ON Dim.ReferralPriority.ReferralPriorityID=dbo.ReferralFact.ReferralPriorityID
	LEFT JOIN Dim.LocalReportingOffice
	ON Dim.LocalReportingOffice.LocalReportingOfficeID=dbo.ReferralFact.LocalReportingOfficeID
		LEFT JOIN Dim.Provider
		ON Dim.Provider.ProviderID=Dim.LocalReportingOffice.ProviderID
			LEFT JOIN Dim.Facility
			ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
				LEFT JOIN Dim.HSDA
				ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
			LEFT JOIN Dim.LevelOfCare
			ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
		LEFT JOIN Dim.CommunityProgram
		ON Dim.CommunityProgram.CommunityProgramID=Dim.LocalReportingOffice.CommunityProgramID
	LEFT JOIN Dim.ReasonEndingServiceLookup
	ON Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=dbo.ReferralFact.ReasonEndingServiceCodeID
		LEFT JOIN Dim.ReasonEndingService
		ON Dim.ReasonEndingService.ReasonEndingServiceID=Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
	LEFT JOIN Dim.ReferralReason
	ON Dim.ReferralReason.ReferralReasonID=dbo.ReferralFact.ReferralReasonID
	LEFT JOIN Dim.ReferralSourceLookup
	ON Dim.ReferralSourceLookup.ReferralSourceLookupID=dbo.ReferralFact.ReferralSourceLookupID
		LEFT JOIN Dim.ReferralSource
		ON Dim.ReferralSource.ReferralSourceID=Dim.ReferralSourceLookup.ReferralSourceID
	LEFT JOIN Dim.DischargeDispositionLookupCOM
	ON Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=dbo.ReferralFact.DischargeDispositionCodeID
		LEFT JOIN Dim.DischargeDisposition
		ON Dim.DischargeDisposition.DischargeDispositionID=Dim.DischargeDispositionLookupCOM.DischargeDispositionID
	LEFT JOIN Dim.ReferralType
	ON Dim.ReferralType.ReferralTypeID=dbo.ReferralFact.ReferralTypeID
	LEFT JOIN Dim.DischargeOutcome
	ON Dim.DischargeOutcome.DischargeOutcomeID=dbo.ReferralFact.DischargeOutcomeID
LEFT JOIN Dim.AssessmentType
ON Dim.AssessmentType.AssessmentTypeID=dbo.AssessmentHeaderFact.AssessmentTypeID
LEFT JOIN Dim.AssessmentReason
ON Dim.AssessmentReason.AssessmentReasonID=dbo.AssessmentHeaderFact.AssessmentReasonID
)
MERGE INTO dbo.AssessmentHeaderFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.GenderID=src.GenderID,
	dst.EthnicityID=src.EthnicityID,
	dst.ReferralPriorityID=src.ReferralPriorityID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.ReasonEndingServiceCodeID=src.ReasonEndingServiceCodeID,
	dst.ReasonEndingServiceID=src.ReasonEndingServiceID,
	dst.ReferralReasonID=src.ReferralReasonID,
	dst.ReferralSourceLookupID=src.ReferralSourceLookupID,
	dst.ReferralSourceID=src.ReferralSourceID,
	dst.DischargeDispositionCodeID=src.DischargeDispositionCodeID,
	dst.DischargeDispositionID=src.DischargeDispositionID,
	dst.ReferralTypeID=src.ReferralTypeID,
	dst.DischargeOutcomeID=src.DischargeOutcomeID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='dbo.AssessmentHeaderFact', 
@pRuleDesc='', 
@pConditionSQL='', 
@pActionID=, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='', 
@pTargetAttributePhysicalName='', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR dbo.AssessmentHeaderFact



--#region BR dbo.InvolvedProfessionFact
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '8106d594-7a27-11e6-935e-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		dbo.InvolvedProfessionFact.ETLAuditID,
	dbo.ReferralFact.SourceSystemClientID
		,dbo.PersonFact.DeathLocationID
		,dbo.PersonFact.EducationLevelCodeID
		,Dim.EducationLevelLookup.EducationLevelID
		,dbo.PersonFact.GenderID
		,dbo.PersonFact.EthnicityID
		,dbo.ReferralFact.ReferralPriorityID
		,dbo.ReferralFact.LocalReportingOfficeID
		,Dim.LocalReportingOffice.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,Dim.LocalReportingOffice.CommunityProgramID
		,dbo.ReferralFact.ReasonEndingServiceCodeID
		,Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
		,dbo.ReferralFact.ReferralReasonID
		,dbo.ReferralFact.ReferralSourceLookupID
		,Dim.ReferralSourceLookup.ReferralSourceID
		,dbo.ReferralFact.DischargeDispositionCodeID
		,Dim.DischargeDispositionLookupCOM.DischargeDispositionID
		,dbo.ReferralFact.ReferralTypeID
		,dbo.ReferralFact.DischargeOutcomeID
FROM dbo.InvolvedProfessionFact
LEFT JOIN Dim.ServiceProviderCategoryLookup
ON Dim.ServiceProviderCategoryLookup.ServiceProviderCategoryCodeID=dbo.InvolvedProfessionFact.ServiceProviderCategoryCodeID
LEFT JOIN dbo.ReferralFact
ON dbo.ReferralFact.SourceReferralID=dbo.InvolvedProfessionFact.SourceReferralID
	LEFT JOIN dbo.PersonFact
	ON dbo.PersonFact.SourceSystemClientID=dbo.ReferralFact.SourceSystemClientID
		LEFT JOIN Dim.DeathLocation
		ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
		LEFT JOIN Dim.EducationLevelLookup
		ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
			LEFT JOIN Dim.EducationLevel
			ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
		LEFT JOIN Dim.Gender
		ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
		LEFT JOIN Dim.Ethnicity
		ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
	LEFT JOIN Dim.ReferralPriority
	ON Dim.ReferralPriority.ReferralPriorityID=dbo.ReferralFact.ReferralPriorityID
	LEFT JOIN Dim.LocalReportingOffice
	ON Dim.LocalReportingOffice.LocalReportingOfficeID=dbo.ReferralFact.LocalReportingOfficeID
		LEFT JOIN Dim.Provider
		ON Dim.Provider.ProviderID=Dim.LocalReportingOffice.ProviderID
			LEFT JOIN Dim.Facility
			ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
				LEFT JOIN Dim.HSDA
				ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
			LEFT JOIN Dim.LevelOfCare
			ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
		LEFT JOIN Dim.CommunityProgram
		ON Dim.CommunityProgram.CommunityProgramID=Dim.LocalReportingOffice.CommunityProgramID
	LEFT JOIN Dim.ReasonEndingServiceLookup
	ON Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=dbo.ReferralFact.ReasonEndingServiceCodeID
		LEFT JOIN Dim.ReasonEndingService
		ON Dim.ReasonEndingService.ReasonEndingServiceID=Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
	LEFT JOIN Dim.ReferralReason
	ON Dim.ReferralReason.ReferralReasonID=dbo.ReferralFact.ReferralReasonID
	LEFT JOIN Dim.ReferralSourceLookup
	ON Dim.ReferralSourceLookup.ReferralSourceLookupID=dbo.ReferralFact.ReferralSourceLookupID
		LEFT JOIN Dim.ReferralSource
		ON Dim.ReferralSource.ReferralSourceID=Dim.ReferralSourceLookup.ReferralSourceID
	LEFT JOIN Dim.DischargeDispositionLookupCOM
	ON Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=dbo.ReferralFact.DischargeDispositionCodeID
		LEFT JOIN Dim.DischargeDisposition
		ON Dim.DischargeDisposition.DischargeDispositionID=Dim.DischargeDispositionLookupCOM.DischargeDispositionID
	LEFT JOIN Dim.ReferralType
	ON Dim.ReferralType.ReferralTypeID=dbo.ReferralFact.ReferralTypeID
	LEFT JOIN Dim.DischargeOutcome
	ON Dim.DischargeOutcome.DischargeOutcomeID=dbo.ReferralFact.DischargeOutcomeID
)
MERGE INTO dbo.InvolvedProfessionFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.GenderID=src.GenderID,
	dst.EthnicityID=src.EthnicityID,
	dst.ReferralPriorityID=src.ReferralPriorityID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.ReasonEndingServiceCodeID=src.ReasonEndingServiceCodeID,
	dst.ReasonEndingServiceID=src.ReasonEndingServiceID,
	dst.ReferralReasonID=src.ReferralReasonID,
	dst.ReferralSourceLookupID=src.ReferralSourceLookupID,
	dst.ReferralSourceID=src.ReferralSourceID,
	dst.DischargeDispositionCodeID=src.DischargeDispositionCodeID,
	dst.DischargeDispositionID=src.DischargeDispositionID,
	dst.ReferralTypeID=src.ReferralTypeID,
	dst.DischargeOutcomeID=src.DischargeOutcomeID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='dbo.InvolvedProfessionFact', 
@pRuleDesc='', 
@pConditionSQL='', 
@pActionID=, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='', 
@pTargetAttributePhysicalName='', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR dbo.InvolvedProfessionFact



--#region BR dbo.ClientGPFact
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '810946a6-7a27-11e6-a24b-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		dbo.ClientGPFact.ETLAuditID,
	dbo.PersonFact.DeathLocationID
		,dbo.PersonFact.EducationLevelCodeID
		,Dim.EducationLevelLookup.EducationLevelID
		,dbo.PersonFact.GenderID
		,dbo.PersonFact.EthnicityID
FROM dbo.ClientGPFact
LEFT JOIN dbo.PersonFact
ON dbo.PersonFact.SourceSystemClientID=dbo.ClientGPFact.SourceSystemClientID
	LEFT JOIN Dim.DeathLocation
	ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
	LEFT JOIN Dim.EducationLevelLookup
	ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
		LEFT JOIN Dim.EducationLevel
		ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
	LEFT JOIN Dim.Gender
	ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
	LEFT JOIN Dim.Ethnicity
	ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
)
MERGE INTO dbo.ClientGPFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.DeathLocationID=src.DeathLocationID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.GenderID=src.GenderID,
	dst.EthnicityID=src.EthnicityID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='dbo.ClientGPFact', 
@pRuleDesc='', 
@pConditionSQL='', 
@pActionID=, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='', 
@pTargetAttributePhysicalName='', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR dbo.ClientGPFact



--#region BR dbo.WaitlistEntryFact
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '810af462-7a27-11e6-9c9a-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		dbo.WaitlistEntryFact.ETLAuditID,
	dbo.WaitlistDefinitionFact.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,dbo.WaitlistDefinitionFact.WaitlistTypeID
		,Dim.LocalReportingOffice.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,Dim.LocalReportingOffice.CommunityProgramID
		,dbo.PersonFact.DeathLocationID
		,dbo.PersonFact.EducationLevelCodeID
		,Dim.EducationLevelLookup.EducationLevelID
		,dbo.PersonFact.GenderID
		,dbo.PersonFact.EthnicityID
FROM dbo.WaitlistEntryFact
LEFT JOIN dbo.WaitlistDefinitionFact
ON dbo.WaitlistDefinitionFact.SourceWaitlistDefinitionID=dbo.WaitlistEntryFact.SourceWaitlistDefinitionID
	LEFT JOIN Dim.Provider
	ON Dim.Provider.ProviderID=dbo.WaitlistDefinitionFact.ProviderID
		LEFT JOIN Dim.Facility
		ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
			LEFT JOIN Dim.HSDA
			ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
		LEFT JOIN Dim.LevelOfCare
		ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
	LEFT JOIN Dim.WaitlistType
	ON Dim.WaitlistType.WaitlistTypeID=dbo.WaitlistDefinitionFact.WaitlistTypeID
LEFT JOIN Dim.WaitlistStatus
ON Dim.WaitlistStatus.WaitlistStatusID=dbo.WaitlistEntryFact.WaitlistStatusID
LEFT JOIN Dim.LocalReportingOffice
ON Dim.LocalReportingOffice.LocalReportingOfficeID=dbo.WaitlistEntryFact.LocalReportingOfficeID
	LEFT JOIN Dim.Provider
	ON Dim.Provider.ProviderID=Dim.LocalReportingOffice.ProviderID
		LEFT JOIN Dim.Facility
		ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
			LEFT JOIN Dim.HSDA
			ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
		LEFT JOIN Dim.LevelOfCare
		ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
	LEFT JOIN Dim.CommunityProgram
	ON Dim.CommunityProgram.CommunityProgramID=Dim.LocalReportingOffice.CommunityProgramID
LEFT JOIN Dim.WaitlistPriority
ON Dim.WaitlistPriority.WaitlistPriorityID=dbo.WaitlistEntryFact.WaitlistPriorityID
LEFT JOIN dbo.PersonFact
ON dbo.PersonFact.SourceSystemClientID=dbo.WaitlistEntryFact.SourceSystemClientID
	LEFT JOIN Dim.DeathLocation
	ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
	LEFT JOIN Dim.EducationLevelLookup
	ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
		LEFT JOIN Dim.EducationLevel
		ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
	LEFT JOIN Dim.Gender
	ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
	LEFT JOIN Dim.Ethnicity
	ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
LEFT JOIN Dim.WaitListReason
ON Dim.WaitListReason.WaitListReasonID=dbo.WaitlistEntryFact.WaitListReasonID
)
MERGE INTO dbo.WaitlistEntryFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.WaitlistTypeID=src.WaitlistTypeID,
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.GenderID=src.GenderID,
	dst.EthnicityID=src.EthnicityID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='dbo.WaitlistEntryFact', 
@pRuleDesc='', 
@pConditionSQL='', 
@pActionID=, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='', 
@pTargetAttributePhysicalName='', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR dbo.WaitlistEntryFact



--#region BR dbo.ReferralFact
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '810cc92e-7a27-11e6-8273-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		dbo.ReferralFact.ETLAuditID,
	dbo.PersonFact.DeathLocationID
		,dbo.PersonFact.EducationLevelCodeID
		,Dim.EducationLevelLookup.EducationLevelID
		,dbo.PersonFact.GenderID
		,dbo.PersonFact.EthnicityID
		,Dim.LocalReportingOffice.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,Dim.LocalReportingOffice.CommunityProgramID
		,Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
		,Dim.ReferralSourceLookup.ReferralSourceID
		,Dim.DischargeDispositionLookupCOM.DischargeDispositionID
FROM dbo.ReferralFact
LEFT JOIN dbo.PersonFact
ON dbo.PersonFact.SourceSystemClientID=dbo.ReferralFact.SourceSystemClientID
	LEFT JOIN Dim.DeathLocation
	ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
	LEFT JOIN Dim.EducationLevelLookup
	ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
		LEFT JOIN Dim.EducationLevel
		ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
	LEFT JOIN Dim.Gender
	ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
	LEFT JOIN Dim.Ethnicity
	ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
LEFT JOIN Dim.ReferralPriority
ON Dim.ReferralPriority.ReferralPriorityID=dbo.ReferralFact.ReferralPriorityID
LEFT JOIN Dim.LocalReportingOffice
ON Dim.LocalReportingOffice.LocalReportingOfficeID=dbo.ReferralFact.LocalReportingOfficeID
	LEFT JOIN Dim.Provider
	ON Dim.Provider.ProviderID=Dim.LocalReportingOffice.ProviderID
		LEFT JOIN Dim.Facility
		ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
			LEFT JOIN Dim.HSDA
			ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
		LEFT JOIN Dim.LevelOfCare
		ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
	LEFT JOIN Dim.CommunityProgram
	ON Dim.CommunityProgram.CommunityProgramID=Dim.LocalReportingOffice.CommunityProgramID
LEFT JOIN Dim.ReasonEndingServiceLookup
ON Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=dbo.ReferralFact.ReasonEndingServiceCodeID
	LEFT JOIN Dim.ReasonEndingService
	ON Dim.ReasonEndingService.ReasonEndingServiceID=Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
LEFT JOIN Dim.ReferralReason
ON Dim.ReferralReason.ReferralReasonID=dbo.ReferralFact.ReferralReasonID
LEFT JOIN Dim.ReferralSourceLookup
ON Dim.ReferralSourceLookup.ReferralSourceLookupID=dbo.ReferralFact.ReferralSourceLookupID
	LEFT JOIN Dim.ReferralSource
	ON Dim.ReferralSource.ReferralSourceID=Dim.ReferralSourceLookup.ReferralSourceID
LEFT JOIN Dim.DischargeDispositionLookupCOM
ON Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=dbo.ReferralFact.DischargeDispositionCodeID
	LEFT JOIN Dim.DischargeDisposition
	ON Dim.DischargeDisposition.DischargeDispositionID=Dim.DischargeDispositionLookupCOM.DischargeDispositionID
LEFT JOIN Dim.ReferralType
ON Dim.ReferralType.ReferralTypeID=dbo.ReferralFact.ReferralTypeID
LEFT JOIN Dim.DischargeOutcome
ON Dim.DischargeOutcome.DischargeOutcomeID=dbo.ReferralFact.DischargeOutcomeID
)
MERGE INTO dbo.ReferralFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.DeathLocationID=src.DeathLocationID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.GenderID=src.GenderID,
	dst.EthnicityID=src.EthnicityID,
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.ReasonEndingServiceID=src.ReasonEndingServiceID,
	dst.ReferralSourceID=src.ReferralSourceID,
	dst.DischargeDispositionID=src.DischargeDispositionID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='dbo.ReferralFact', 
@pRuleDesc='', 
@pConditionSQL='', 
@pActionID=, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='', 
@pTargetAttributePhysicalName='', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR dbo.ReferralFact



--#region BR dbo.WaitlistDefinitionFact
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '810f1328-7a27-11e6-980d-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		dbo.WaitlistDefinitionFact.ETLAuditID,
	Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
FROM dbo.WaitlistDefinitionFact
LEFT JOIN Dim.Provider
ON Dim.Provider.ProviderID=dbo.WaitlistDefinitionFact.ProviderID
	LEFT JOIN Dim.Facility
	ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
		LEFT JOIN Dim.HSDA
		ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
	LEFT JOIN Dim.LevelOfCare
	ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
LEFT JOIN Dim.WaitlistType
ON Dim.WaitlistType.WaitlistTypeID=dbo.WaitlistDefinitionFact.WaitlistTypeID
)
MERGE INTO dbo.WaitlistDefinitionFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='dbo.WaitlistDefinitionFact', 
@pRuleDesc='', 
@pConditionSQL='', 
@pActionID=, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='', 
@pTargetAttributePhysicalName='', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR dbo.WaitlistDefinitionFact



--#region BR dbo.AssessmentContactFact
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '8110e7f6-7a27-11e6-bfb6-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		dbo.AssessmentContactFact.ETLAuditID,
	dbo.AssessmentHeaderFact.SourceReferralID
		,dbo.ReferralFact.SourceSystemClientID
		,dbo.PersonFact.DeathLocationID
		,dbo.PersonFact.EducationLevelCodeID
		,Dim.EducationLevelLookup.EducationLevelID
		,dbo.PersonFact.GenderID
		,dbo.PersonFact.EthnicityID
		,dbo.ReferralFact.ReferralPriorityID
		,dbo.ReferralFact.LocalReportingOfficeID
		,Dim.LocalReportingOffice.ProviderID
		,Dim.Provider.FacilityID
		,Dim.Facility.HSDAID
		,Dim.Provider.LevelOfCareId
		,Dim.LocalReportingOffice.CommunityProgramID
		,dbo.ReferralFact.ReasonEndingServiceCodeID
		,Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
		,dbo.ReferralFact.ReferralReasonID
		,dbo.ReferralFact.ReferralSourceLookupID
		,Dim.ReferralSourceLookup.ReferralSourceID
		,dbo.ReferralFact.DischargeDispositionCodeID
		,Dim.DischargeDispositionLookupCOM.DischargeDispositionID
		,dbo.ReferralFact.ReferralTypeID
		,dbo.ReferralFact.DischargeOutcomeID
		,dbo.AssessmentHeaderFact.AssessmentTypeID
		,dbo.AssessmentHeaderFact.AssessmentReasonID
FROM dbo.AssessmentContactFact
LEFT JOIN Dim.ContactType
ON Dim.ContactType.ContactTypeID=dbo.AssessmentContactFact.ContactTypeID
LEFT JOIN Dim.CommunityServiceLocation
ON Dim.CommunityServiceLocation.CommunityServiceLocationID=dbo.AssessmentContactFact.CommunityServiceLocationID
LEFT JOIN dbo.AssessmentHeaderFact
ON dbo.AssessmentHeaderFact.SourceAssessmentID=dbo.AssessmentContactFact.SourceAssessmentID
	LEFT JOIN dbo.ReferralFact
	ON dbo.ReferralFact.SourceReferralID=dbo.AssessmentHeaderFact.SourceReferralID
		LEFT JOIN dbo.PersonFact
		ON dbo.PersonFact.SourceSystemClientID=dbo.ReferralFact.SourceSystemClientID
			LEFT JOIN Dim.DeathLocation
			ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
			LEFT JOIN Dim.EducationLevelLookup
			ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
				LEFT JOIN Dim.EducationLevel
				ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
			LEFT JOIN Dim.Gender
			ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
			LEFT JOIN Dim.Ethnicity
			ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
		LEFT JOIN Dim.ReferralPriority
		ON Dim.ReferralPriority.ReferralPriorityID=dbo.ReferralFact.ReferralPriorityID
		LEFT JOIN Dim.LocalReportingOffice
		ON Dim.LocalReportingOffice.LocalReportingOfficeID=dbo.ReferralFact.LocalReportingOfficeID
			LEFT JOIN Dim.Provider
			ON Dim.Provider.ProviderID=Dim.LocalReportingOffice.ProviderID
				LEFT JOIN Dim.Facility
				ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
					LEFT JOIN Dim.HSDA
					ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
				LEFT JOIN Dim.LevelOfCare
				ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
			LEFT JOIN Dim.CommunityProgram
			ON Dim.CommunityProgram.CommunityProgramID=Dim.LocalReportingOffice.CommunityProgramID
		LEFT JOIN Dim.ReasonEndingServiceLookup
		ON Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=dbo.ReferralFact.ReasonEndingServiceCodeID
			LEFT JOIN Dim.ReasonEndingService
			ON Dim.ReasonEndingService.ReasonEndingServiceID=Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
		LEFT JOIN Dim.ReferralReason
		ON Dim.ReferralReason.ReferralReasonID=dbo.ReferralFact.ReferralReasonID
		LEFT JOIN Dim.ReferralSourceLookup
		ON Dim.ReferralSourceLookup.ReferralSourceLookupID=dbo.ReferralFact.ReferralSourceLookupID
			LEFT JOIN Dim.ReferralSource
			ON Dim.ReferralSource.ReferralSourceID=Dim.ReferralSourceLookup.ReferralSourceID
		LEFT JOIN Dim.DischargeDispositionLookupCOM
		ON Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=dbo.ReferralFact.DischargeDispositionCodeID
			LEFT JOIN Dim.DischargeDisposition
			ON Dim.DischargeDisposition.DischargeDispositionID=Dim.DischargeDispositionLookupCOM.DischargeDispositionID
		LEFT JOIN Dim.ReferralType
		ON Dim.ReferralType.ReferralTypeID=dbo.ReferralFact.ReferralTypeID
		LEFT JOIN Dim.DischargeOutcome
		ON Dim.DischargeOutcome.DischargeOutcomeID=dbo.ReferralFact.DischargeOutcomeID
	LEFT JOIN Dim.AssessmentType
	ON Dim.AssessmentType.AssessmentTypeID=dbo.AssessmentHeaderFact.AssessmentTypeID
	LEFT JOIN Dim.AssessmentReason
	ON Dim.AssessmentReason.AssessmentReasonID=dbo.AssessmentHeaderFact.AssessmentReasonID
)
MERGE INTO dbo.AssessmentContactFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.SourceReferralID=src.SourceReferralID,
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.GenderID=src.GenderID,
	dst.EthnicityID=src.EthnicityID,
	dst.ReferralPriorityID=src.ReferralPriorityID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.ReasonEndingServiceCodeID=src.ReasonEndingServiceCodeID,
	dst.ReasonEndingServiceID=src.ReasonEndingServiceID,
	dst.ReferralReasonID=src.ReferralReasonID,
	dst.ReferralSourceLookupID=src.ReferralSourceLookupID,
	dst.ReferralSourceID=src.ReferralSourceID,
	dst.DischargeDispositionCodeID=src.DischargeDispositionCodeID,
	dst.DischargeDispositionID=src.DischargeDispositionID,
	dst.ReferralTypeID=src.ReferralTypeID,
	dst.DischargeOutcomeID=src.DischargeOutcomeID,
	dst.AssessmentTypeID=src.AssessmentTypeID,
	dst.AssessmentReasonID=src.AssessmentReasonID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='dbo.AssessmentContactFact', 
@pRuleDesc='', 
@pConditionSQL='', 
@pActionID=, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='', 
@pTargetAttributePhysicalName='', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR dbo.AssessmentContactFact

