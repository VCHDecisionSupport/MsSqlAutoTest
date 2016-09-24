

--#region BR Update/Merge CommunityMart.dbo.ImmunizationHistoryFact (denormalize)
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '54af82a4-7b82-11e6-8bfa-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		CommunityMart.dbo.ImmunizationHistoryFact.ETLAuditID
		,CommunityMart.dbo.PersonFact.SourceSystemClientID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
		,CommunityMart.Dim.Antigen.AntigenID
		,CommunityMart.Dim.CommunityServiceLocation.CommunityServiceLocationID
		,CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.CommunityProgram.CommunityProgramID
		,CommunityMart.dbo.PersonFact.PatientID
FROM CommunityMart.dbo.ImmunizationHistoryFact
LEFT JOIN CommunityMart.dbo.PersonFact
ON CommunityMart.dbo.PersonFact.SourceSystemClientID=CommunityMart.dbo.ImmunizationHistoryFact.SourceSystemClientID
	LEFT JOIN CommunityMart.Dim.DeathLocation
	ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
	LEFT JOIN CommunityMart.Dim.Ethnicity
	ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
	LEFT JOIN CommunityMart.Dim.Gender
	ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
	LEFT JOIN CommunityMart.Dim.EducationLevelLookup
	ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
		LEFT JOIN CommunityMart.Dim.EducationLevel
		ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
LEFT JOIN CommunityMart.Dim.Antigen
ON CommunityMart.Dim.Antigen.AntigenID=CommunityMart.dbo.ImmunizationHistoryFact.AntigenID
LEFT JOIN CommunityMart.Dim.CommunityServiceLocation
ON CommunityMart.Dim.CommunityServiceLocation.CommunityServiceLocationID=CommunityMart.dbo.ImmunizationHistoryFact.CommunityServiceLocationID
LEFT JOIN CommunityMart.Dim.LocalReportingOffice
ON CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID=CommunityMart.dbo.ImmunizationHistoryFact.LocalReportingOfficeID
	LEFT JOIN CommunityMart.Dim.Provider
	ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.Dim.LocalReportingOffice.ProviderID
		LEFT JOIN CommunityMart.Dim.LevelOfCare
		ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
		LEFT JOIN CommunityMart.Dim.Facility
		ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
			LEFT JOIN CommunityMart.Dim.HSDA
			ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
	LEFT JOIN CommunityMart.Dim.CommunityProgram
	ON CommunityMart.Dim.CommunityProgram.CommunityProgramID=CommunityMart.Dim.LocalReportingOffice.CommunityProgramID
)
MERGE INTO CommunityMart.dbo.ImmunizationHistoryFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.AntigenID=src.AntigenID,
	dst.CommunityServiceLocationID=src.CommunityServiceLocationID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.PatientID=src.PatientID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='Update/Merge CommunityMart.dbo.ImmunizationHistoryFact (denormalize)', 
@pRuleDesc='', 
@pConditionSQL=NULL, 
@pActionID=4, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=1000, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='CommunityMart.dbo.ImmunizationHistoryFact', 
@pTargetAttributePhysicalName='many', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python for CommunityMart.dbo.ImmunizationHistoryFact', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR Update/Merge CommunityMart.dbo.ImmunizationHistoryFact (denormalize)



--#region BR Update/Merge CommunityMart.dbo.ReferralFact (denormalize)
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '54b1a592-7b82-11e6-90e7-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		CommunityMart.dbo.ReferralFact.ETLAuditID
		,CommunityMart.Dim.ReferralPriority.ReferralPriorityID
		,CommunityMart.dbo.PersonFact.SourceSystemClientID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
		,CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID
		,CommunityMart.Dim.DischargeDisposition.DischargeDispositionID
		,CommunityMart.Dim.ReferralReason.ReferralReasonID
		,CommunityMart.Dim.ReferralType.ReferralTypeID
		,CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.CommunityProgram.CommunityProgramID
		,CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID
		,CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID
		,CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID
		,CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID
		,CommunityMart.Dim.ReferralSource.ReferralSourceID
		,CommunityMart.dbo.PersonFact.PatientID
FROM CommunityMart.dbo.ReferralFact
LEFT JOIN CommunityMart.Dim.ReferralPriority
ON CommunityMart.Dim.ReferralPriority.ReferralPriorityID=CommunityMart.dbo.ReferralFact.ReferralPriorityID
LEFT JOIN CommunityMart.dbo.PersonFact
ON CommunityMart.dbo.PersonFact.SourceSystemClientID=CommunityMart.dbo.ReferralFact.SourceSystemClientID
	LEFT JOIN CommunityMart.Dim.DeathLocation
	ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
	LEFT JOIN CommunityMart.Dim.Ethnicity
	ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
	LEFT JOIN CommunityMart.Dim.Gender
	ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
	LEFT JOIN CommunityMart.Dim.EducationLevelLookup
	ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
		LEFT JOIN CommunityMart.Dim.EducationLevel
		ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
LEFT JOIN CommunityMart.Dim.DischargeDispositionLookupCOM
ON CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=CommunityMart.dbo.ReferralFact.DischargeDispositionCodeID
	LEFT JOIN CommunityMart.Dim.DischargeDisposition
	ON CommunityMart.Dim.DischargeDisposition.DischargeDispositionID=CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionID
LEFT JOIN CommunityMart.Dim.ReferralReason
ON CommunityMart.Dim.ReferralReason.ReferralReasonID=CommunityMart.dbo.ReferralFact.ReferralReasonID
LEFT JOIN CommunityMart.Dim.ReferralType
ON CommunityMart.Dim.ReferralType.ReferralTypeID=CommunityMart.dbo.ReferralFact.ReferralTypeID
LEFT JOIN CommunityMart.Dim.LocalReportingOffice
ON CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID=CommunityMart.dbo.ReferralFact.LocalReportingOfficeID
	LEFT JOIN CommunityMart.Dim.Provider
	ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.Dim.LocalReportingOffice.ProviderID
		LEFT JOIN CommunityMart.Dim.LevelOfCare
		ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
		LEFT JOIN CommunityMart.Dim.Facility
		ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
			LEFT JOIN CommunityMart.Dim.HSDA
			ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
	LEFT JOIN CommunityMart.Dim.CommunityProgram
	ON CommunityMart.Dim.CommunityProgram.CommunityProgramID=CommunityMart.Dim.LocalReportingOffice.CommunityProgramID
LEFT JOIN CommunityMart.Dim.DischargeOutcome
ON CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID=CommunityMart.dbo.ReferralFact.DischargeOutcomeID
LEFT JOIN CommunityMart.Dim.ReasonEndingServiceLookup
ON CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=CommunityMart.dbo.ReferralFact.ReasonEndingServiceCodeID
	LEFT JOIN CommunityMart.Dim.ReasonEndingService
	ON CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID=CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
LEFT JOIN CommunityMart.Dim.ReferralSourceLookup
ON CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID=CommunityMart.dbo.ReferralFact.ReferralSourceLookupID
	LEFT JOIN CommunityMart.Dim.ReferralSource
	ON CommunityMart.Dim.ReferralSource.ReferralSourceID=CommunityMart.Dim.ReferralSourceLookup.ReferralSourceID
)
MERGE INTO CommunityMart.dbo.ReferralFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.ReferralPriorityID=src.ReferralPriorityID,
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.DischargeDispositionCodeID=src.DischargeDispositionCodeID,
	dst.DischargeDispositionID=src.DischargeDispositionID,
	dst.ReferralReasonID=src.ReferralReasonID,
	dst.ReferralTypeID=src.ReferralTypeID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.DischargeOutcomeID=src.DischargeOutcomeID,
	dst.ReasonEndingServiceCodeID=src.ReasonEndingServiceCodeID,
	dst.ReasonEndingServiceID=src.ReasonEndingServiceID,
	dst.ReferralSourceLookupID=src.ReferralSourceLookupID,
	dst.ReferralSourceID=src.ReferralSourceID,
	dst.PatientID=src.PatientID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='Update/Merge CommunityMart.dbo.ReferralFact (denormalize)', 
@pRuleDesc='', 
@pConditionSQL=NULL, 
@pActionID=4, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=1100, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='CommunityMart.dbo.ReferralFact', 
@pTargetAttributePhysicalName='many', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python for CommunityMart.dbo.ReferralFact', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR Update/Merge CommunityMart.dbo.ReferralFact (denormalize)



--#region BR Update/Merge CommunityMart.dbo.ImmAdverseEventFact (denormalize)
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '54b416a2-7b82-11e6-9c7a-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		CommunityMart.dbo.ImmAdverseEventFact.ETLAuditID
		,CommunityMart.dbo.PersonFact.SourceSystemClientID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
		,CommunityMart.dbo.PersonFact.PatientID
FROM CommunityMart.dbo.ImmAdverseEventFact
LEFT JOIN CommunityMart.dbo.PersonFact
ON CommunityMart.dbo.PersonFact.SourceSystemClientID=CommunityMart.dbo.ImmAdverseEventFact.SourceSystemClientID
	LEFT JOIN CommunityMart.Dim.DeathLocation
	ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
	LEFT JOIN CommunityMart.Dim.Ethnicity
	ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
	LEFT JOIN CommunityMart.Dim.Gender
	ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
	LEFT JOIN CommunityMart.Dim.EducationLevelLookup
	ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
		LEFT JOIN CommunityMart.Dim.EducationLevel
		ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
)
MERGE INTO CommunityMart.dbo.ImmAdverseEventFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.PatientID=src.PatientID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='Update/Merge CommunityMart.dbo.ImmAdverseEventFact (denormalize)', 
@pRuleDesc='', 
@pConditionSQL=NULL, 
@pActionID=4, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=1200, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='CommunityMart.dbo.ImmAdverseEventFact', 
@pTargetAttributePhysicalName='many', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python for CommunityMart.dbo.ImmAdverseEventFact', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR Update/Merge CommunityMart.dbo.ImmAdverseEventFact (denormalize)



--#region BR Update/Merge CommunityMart.dbo.CaseNoteContactFact (denormalize)
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '54b5eb6c-7b82-11e6-80c6-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		CommunityMart.dbo.CaseNoteContactFact.ETLAuditID
		,CommunityMart.dbo.CaseNoteHeaderFact.SourceCaseNoteHeaderID
		,CommunityMart.dbo.PersonFact.SourceSystemClientID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
		,CommunityMart.dbo.ReferralFact.SourceReferralID
		,CommunityMart.Dim.ReferralPriority.ReferralPriorityID
		,CommunityMart.dbo.PersonFact.SourceSystemClientID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
		,CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID
		,CommunityMart.Dim.DischargeDisposition.DischargeDispositionID
		,CommunityMart.Dim.ReferralReason.ReferralReasonID
		,CommunityMart.Dim.ReferralType.ReferralTypeID
		,CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.CommunityProgram.CommunityProgramID
		,CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID
		,CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID
		,CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID
		,CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID
		,CommunityMart.Dim.ReferralSource.ReferralSourceID
		,CommunityMart.Dim.CaseNoteType.CaseNoteTypeID
		,CommunityMart.Dim.CaseNoteReason.CaseNoteReasonID
		,CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.CommunityProgram.CommunityProgramID
		,CommunityMart.Dim.ContactType.ContactTypeID
		,CommunityMart.dbo.PersonFact.PatientID
FROM CommunityMart.dbo.CaseNoteContactFact
LEFT JOIN CommunityMart.dbo.CaseNoteHeaderFact
ON CommunityMart.dbo.CaseNoteHeaderFact.SourceCaseNoteHeaderID=CommunityMart.dbo.CaseNoteContactFact.SourceCaseNoteHeaderID
	LEFT JOIN CommunityMart.dbo.PersonFact
	ON CommunityMart.dbo.PersonFact.SourceSystemClientID=CommunityMart.dbo.CaseNoteHeaderFact.SourceSystemClientID
		LEFT JOIN CommunityMart.Dim.DeathLocation
		ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
		LEFT JOIN CommunityMart.Dim.Ethnicity
		ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
		LEFT JOIN CommunityMart.Dim.Gender
		ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
		LEFT JOIN CommunityMart.Dim.EducationLevelLookup
		ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
			LEFT JOIN CommunityMart.Dim.EducationLevel
			ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
	LEFT JOIN CommunityMart.dbo.ReferralFact
	ON CommunityMart.dbo.ReferralFact.SourceReferralID=CommunityMart.dbo.CaseNoteHeaderFact.SourceReferralID
		LEFT JOIN CommunityMart.Dim.ReferralPriority
		ON CommunityMart.Dim.ReferralPriority.ReferralPriorityID=CommunityMart.dbo.ReferralFact.ReferralPriorityID
		LEFT JOIN CommunityMart.dbo.PersonFact
		ON CommunityMart.dbo.PersonFact.SourceSystemClientID=CommunityMart.dbo.ReferralFact.SourceSystemClientID
			LEFT JOIN CommunityMart.Dim.DeathLocation
			ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
			LEFT JOIN CommunityMart.Dim.Ethnicity
			ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
			LEFT JOIN CommunityMart.Dim.Gender
			ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
			LEFT JOIN CommunityMart.Dim.EducationLevelLookup
			ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
				LEFT JOIN CommunityMart.Dim.EducationLevel
				ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
		LEFT JOIN CommunityMart.Dim.DischargeDispositionLookupCOM
		ON CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=CommunityMart.dbo.ReferralFact.DischargeDispositionCodeID
			LEFT JOIN CommunityMart.Dim.DischargeDisposition
			ON CommunityMart.Dim.DischargeDisposition.DischargeDispositionID=CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionID
		LEFT JOIN CommunityMart.Dim.ReferralReason
		ON CommunityMart.Dim.ReferralReason.ReferralReasonID=CommunityMart.dbo.ReferralFact.ReferralReasonID
		LEFT JOIN CommunityMart.Dim.ReferralType
		ON CommunityMart.Dim.ReferralType.ReferralTypeID=CommunityMart.dbo.ReferralFact.ReferralTypeID
		LEFT JOIN CommunityMart.Dim.LocalReportingOffice
		ON CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID=CommunityMart.dbo.ReferralFact.LocalReportingOfficeID
			LEFT JOIN CommunityMart.Dim.Provider
			ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.Dim.LocalReportingOffice.ProviderID
				LEFT JOIN CommunityMart.Dim.LevelOfCare
				ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
				LEFT JOIN CommunityMart.Dim.Facility
				ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
					LEFT JOIN CommunityMart.Dim.HSDA
					ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
			LEFT JOIN CommunityMart.Dim.CommunityProgram
			ON CommunityMart.Dim.CommunityProgram.CommunityProgramID=CommunityMart.Dim.LocalReportingOffice.CommunityProgramID
		LEFT JOIN CommunityMart.Dim.DischargeOutcome
		ON CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID=CommunityMart.dbo.ReferralFact.DischargeOutcomeID
		LEFT JOIN CommunityMart.Dim.ReasonEndingServiceLookup
		ON CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=CommunityMart.dbo.ReferralFact.ReasonEndingServiceCodeID
			LEFT JOIN CommunityMart.Dim.ReasonEndingService
			ON CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID=CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
		LEFT JOIN CommunityMart.Dim.ReferralSourceLookup
		ON CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID=CommunityMart.dbo.ReferralFact.ReferralSourceLookupID
			LEFT JOIN CommunityMart.Dim.ReferralSource
			ON CommunityMart.Dim.ReferralSource.ReferralSourceID=CommunityMart.Dim.ReferralSourceLookup.ReferralSourceID
	LEFT JOIN CommunityMart.Dim.CaseNoteType
	ON CommunityMart.Dim.CaseNoteType.CaseNoteTypeID=CommunityMart.dbo.CaseNoteHeaderFact.CaseNoteTypeID
	LEFT JOIN CommunityMart.Dim.CaseNoteReason
	ON CommunityMart.Dim.CaseNoteReason.CaseNoteReasonID=CommunityMart.dbo.CaseNoteHeaderFact.CaseNoteReasonID
	LEFT JOIN CommunityMart.Dim.LocalReportingOffice
	ON CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID=CommunityMart.dbo.CaseNoteHeaderFact.LocalReportingOfficeID
		LEFT JOIN CommunityMart.Dim.Provider
		ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.Dim.LocalReportingOffice.ProviderID
			LEFT JOIN CommunityMart.Dim.LevelOfCare
			ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
			LEFT JOIN CommunityMart.Dim.Facility
			ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
				LEFT JOIN CommunityMart.Dim.HSDA
				ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
		LEFT JOIN CommunityMart.Dim.CommunityProgram
		ON CommunityMart.Dim.CommunityProgram.CommunityProgramID=CommunityMart.Dim.LocalReportingOffice.CommunityProgramID
LEFT JOIN CommunityMart.Dim.ContactType
ON CommunityMart.Dim.ContactType.ContactTypeID=CommunityMart.dbo.CaseNoteContactFact.ContactTypeID
)
MERGE INTO CommunityMart.dbo.CaseNoteContactFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.SourceCaseNoteHeaderID=src.SourceCaseNoteHeaderID,
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.SourceReferralID=src.SourceReferralID,
	dst.ReferralPriorityID=src.ReferralPriorityID,
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.DischargeDispositionCodeID=src.DischargeDispositionCodeID,
	dst.DischargeDispositionID=src.DischargeDispositionID,
	dst.ReferralReasonID=src.ReferralReasonID,
	dst.ReferralTypeID=src.ReferralTypeID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.DischargeOutcomeID=src.DischargeOutcomeID,
	dst.ReasonEndingServiceCodeID=src.ReasonEndingServiceCodeID,
	dst.ReasonEndingServiceID=src.ReasonEndingServiceID,
	dst.ReferralSourceLookupID=src.ReferralSourceLookupID,
	dst.ReferralSourceID=src.ReferralSourceID,
	dst.CaseNoteTypeID=src.CaseNoteTypeID,
	dst.CaseNoteReasonID=src.CaseNoteReasonID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.ContactTypeID=src.ContactTypeID,
	dst.PatientID=src.PatientID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='Update/Merge CommunityMart.dbo.CaseNoteContactFact (denormalize)', 
@pRuleDesc='', 
@pConditionSQL=NULL, 
@pActionID=4, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=1300, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='CommunityMart.dbo.CaseNoteContactFact', 
@pTargetAttributePhysicalName='many', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python for CommunityMart.dbo.CaseNoteContactFact', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR Update/Merge CommunityMart.dbo.CaseNoteContactFact (denormalize)



--#region BR Update/Merge CommunityMart.dbo.CDPreviousTestResultFact (denormalize)
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '54b8aa9e-7b82-11e6-b54e-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		CommunityMart.dbo.CDPreviousTestResultFact.ETLAuditID
		,CommunityMart.Dim.CommunityDisease.CommunityDiseaseID
FROM CommunityMart.dbo.CDPreviousTestResultFact
LEFT JOIN CommunityMart.Dim.CommunityDisease
ON CommunityMart.Dim.CommunityDisease.CommunityDiseaseID=CommunityMart.dbo.CDPreviousTestResultFact.CommunityDiseaseID
)
MERGE INTO CommunityMart.dbo.CDPreviousTestResultFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.CommunityDiseaseID=src.CommunityDiseaseID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='Update/Merge CommunityMart.dbo.CDPreviousTestResultFact (denormalize)', 
@pRuleDesc='', 
@pConditionSQL=NULL, 
@pActionID=4, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=1400, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='CommunityMart.dbo.CDPreviousTestResultFact', 
@pTargetAttributePhysicalName='many', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python for CommunityMart.dbo.CDPreviousTestResultFact', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR Update/Merge CommunityMart.dbo.CDPreviousTestResultFact (denormalize)



--#region BR Update/Merge CommunityMart.dbo.YouthClinicActivityFact (denormalize)
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '54baa67e-7b82-11e6-90dd-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		CommunityMart.dbo.YouthClinicActivityFact.ETLAuditID
		,CommunityMart.Dim.ServiceProviderCategoryLookup.ServiceProviderCategoryCodeID
		,CommunityMart.Dim.CommunityServiceLocation.CommunityServiceLocationID
		,CommunityMart.dbo.CDPreviousTestResultFact.SourceAssessmentID
		,CommunityMart.Dim.CommunityDisease.CommunityDiseaseID
		,CommunityMart.dbo.AssessmentHeaderFact.SourceAssessmentID
		,CommunityMart.dbo.ReferralFact.SourceReferralID
		,CommunityMart.Dim.ReferralPriority.ReferralPriorityID
		,CommunityMart.dbo.PersonFact.SourceSystemClientID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
		,CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID
		,CommunityMart.Dim.DischargeDisposition.DischargeDispositionID
		,CommunityMart.Dim.ReferralReason.ReferralReasonID
		,CommunityMart.Dim.ReferralType.ReferralTypeID
		,CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.CommunityProgram.CommunityProgramID
		,CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID
		,CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID
		,CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID
		,CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID
		,CommunityMart.Dim.ReferralSource.ReferralSourceID
		,CommunityMart.Dim.AssessmentType.AssessmentTypeID
		,CommunityMart.Dim.AssessmentReason.AssessmentReasonID
		,CommunityMart.dbo.PersonFact.PatientID
FROM CommunityMart.dbo.YouthClinicActivityFact
LEFT JOIN CommunityMart.Dim.ServiceProviderCategoryLookup
ON CommunityMart.Dim.ServiceProviderCategoryLookup.ServiceProviderCategoryCodeID=CommunityMart.dbo.YouthClinicActivityFact.ServiceProviderCategoryCodeID
LEFT JOIN CommunityMart.Dim.CommunityServiceLocation
ON CommunityMart.Dim.CommunityServiceLocation.CommunityServiceLocationID=CommunityMart.dbo.YouthClinicActivityFact.CommunityServiceLocationID
LEFT JOIN CommunityMart.dbo.CDPreviousTestResultFact
ON CommunityMart.dbo.CDPreviousTestResultFact.SourceAssessmentID=CommunityMart.dbo.YouthClinicActivityFact.SourceAssessmentID
	LEFT JOIN CommunityMart.Dim.CommunityDisease
	ON CommunityMart.Dim.CommunityDisease.CommunityDiseaseID=CommunityMart.dbo.CDPreviousTestResultFact.CommunityDiseaseID
LEFT JOIN CommunityMart.dbo.AssessmentHeaderFact
ON CommunityMart.dbo.AssessmentHeaderFact.SourceAssessmentID=CommunityMart.dbo.YouthClinicActivityFact.SourceAssessmentID
	LEFT JOIN CommunityMart.dbo.ReferralFact
	ON CommunityMart.dbo.ReferralFact.SourceReferralID=CommunityMart.dbo.AssessmentHeaderFact.SourceReferralID
		LEFT JOIN CommunityMart.Dim.ReferralPriority
		ON CommunityMart.Dim.ReferralPriority.ReferralPriorityID=CommunityMart.dbo.ReferralFact.ReferralPriorityID
		LEFT JOIN CommunityMart.dbo.PersonFact
		ON CommunityMart.dbo.PersonFact.SourceSystemClientID=CommunityMart.dbo.ReferralFact.SourceSystemClientID
			LEFT JOIN CommunityMart.Dim.DeathLocation
			ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
			LEFT JOIN CommunityMart.Dim.Ethnicity
			ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
			LEFT JOIN CommunityMart.Dim.Gender
			ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
			LEFT JOIN CommunityMart.Dim.EducationLevelLookup
			ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
				LEFT JOIN CommunityMart.Dim.EducationLevel
				ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
		LEFT JOIN CommunityMart.Dim.DischargeDispositionLookupCOM
		ON CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=CommunityMart.dbo.ReferralFact.DischargeDispositionCodeID
			LEFT JOIN CommunityMart.Dim.DischargeDisposition
			ON CommunityMart.Dim.DischargeDisposition.DischargeDispositionID=CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionID
		LEFT JOIN CommunityMart.Dim.ReferralReason
		ON CommunityMart.Dim.ReferralReason.ReferralReasonID=CommunityMart.dbo.ReferralFact.ReferralReasonID
		LEFT JOIN CommunityMart.Dim.ReferralType
		ON CommunityMart.Dim.ReferralType.ReferralTypeID=CommunityMart.dbo.ReferralFact.ReferralTypeID
		LEFT JOIN CommunityMart.Dim.LocalReportingOffice
		ON CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID=CommunityMart.dbo.ReferralFact.LocalReportingOfficeID
			LEFT JOIN CommunityMart.Dim.Provider
			ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.Dim.LocalReportingOffice.ProviderID
				LEFT JOIN CommunityMart.Dim.LevelOfCare
				ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
				LEFT JOIN CommunityMart.Dim.Facility
				ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
					LEFT JOIN CommunityMart.Dim.HSDA
					ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
			LEFT JOIN CommunityMart.Dim.CommunityProgram
			ON CommunityMart.Dim.CommunityProgram.CommunityProgramID=CommunityMart.Dim.LocalReportingOffice.CommunityProgramID
		LEFT JOIN CommunityMart.Dim.DischargeOutcome
		ON CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID=CommunityMart.dbo.ReferralFact.DischargeOutcomeID
		LEFT JOIN CommunityMart.Dim.ReasonEndingServiceLookup
		ON CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=CommunityMart.dbo.ReferralFact.ReasonEndingServiceCodeID
			LEFT JOIN CommunityMart.Dim.ReasonEndingService
			ON CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID=CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
		LEFT JOIN CommunityMart.Dim.ReferralSourceLookup
		ON CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID=CommunityMart.dbo.ReferralFact.ReferralSourceLookupID
			LEFT JOIN CommunityMart.Dim.ReferralSource
			ON CommunityMart.Dim.ReferralSource.ReferralSourceID=CommunityMart.Dim.ReferralSourceLookup.ReferralSourceID
	LEFT JOIN CommunityMart.Dim.AssessmentType
	ON CommunityMart.Dim.AssessmentType.AssessmentTypeID=CommunityMart.dbo.AssessmentHeaderFact.AssessmentTypeID
	LEFT JOIN CommunityMart.Dim.AssessmentReason
	ON CommunityMart.Dim.AssessmentReason.AssessmentReasonID=CommunityMart.dbo.AssessmentHeaderFact.AssessmentReasonID
)
MERGE INTO CommunityMart.dbo.YouthClinicActivityFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.ServiceProviderCategoryCodeID=src.ServiceProviderCategoryCodeID,
	dst.CommunityServiceLocationID=src.CommunityServiceLocationID,
	dst.SourceAssessmentID=src.SourceAssessmentID,
	dst.CommunityDiseaseID=src.CommunityDiseaseID,
	dst.SourceAssessmentID=src.SourceAssessmentID,
	dst.SourceReferralID=src.SourceReferralID,
	dst.ReferralPriorityID=src.ReferralPriorityID,
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.DischargeDispositionCodeID=src.DischargeDispositionCodeID,
	dst.DischargeDispositionID=src.DischargeDispositionID,
	dst.ReferralReasonID=src.ReferralReasonID,
	dst.ReferralTypeID=src.ReferralTypeID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.DischargeOutcomeID=src.DischargeOutcomeID,
	dst.ReasonEndingServiceCodeID=src.ReasonEndingServiceCodeID,
	dst.ReasonEndingServiceID=src.ReasonEndingServiceID,
	dst.ReferralSourceLookupID=src.ReferralSourceLookupID,
	dst.ReferralSourceID=src.ReferralSourceID,
	dst.AssessmentTypeID=src.AssessmentTypeID,
	dst.AssessmentReasonID=src.AssessmentReasonID,
	dst.PatientID=src.PatientID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='Update/Merge CommunityMart.dbo.YouthClinicActivityFact (denormalize)', 
@pRuleDesc='', 
@pConditionSQL=NULL, 
@pActionID=4, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=1500, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='CommunityMart.dbo.YouthClinicActivityFact', 
@pTargetAttributePhysicalName='many', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python for CommunityMart.dbo.YouthClinicActivityFact', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR Update/Merge CommunityMart.dbo.YouthClinicActivityFact (denormalize)



--#region BR Update/Merge CommunityMart.dbo.HomeSupportActivityFact (denormalize)
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '54bd8cc0-7b82-11e6-9232-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		CommunityMart.dbo.HomeSupportActivityFact.ETLAuditID
		,CommunityMart.dbo.PersonFact.SourceSystemClientID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
		,CommunityMart.Dim.InterventionType.InterventionTypeID
		,CommunityMart.dbo.ReferralFact.SourceReferralID
		,CommunityMart.Dim.ReferralPriority.ReferralPriorityID
		,CommunityMart.dbo.PersonFact.SourceSystemClientID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
		,CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID
		,CommunityMart.Dim.DischargeDisposition.DischargeDispositionID
		,CommunityMart.Dim.ReferralReason.ReferralReasonID
		,CommunityMart.Dim.ReferralType.ReferralTypeID
		,CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.CommunityProgram.CommunityProgramID
		,CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID
		,CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID
		,CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID
		,CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID
		,CommunityMart.Dim.ReferralSource.ReferralSourceID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.CommunityProgram.CommunityProgramID
		,CommunityMart.dbo.InterventionFact.SourceInterventionID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.dbo.ReferralFact.SourceReferralID
		,CommunityMart.Dim.ReferralPriority.ReferralPriorityID
		,CommunityMart.dbo.PersonFact.SourceSystemClientID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
		,CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID
		,CommunityMart.Dim.DischargeDisposition.DischargeDispositionID
		,CommunityMart.Dim.ReferralReason.ReferralReasonID
		,CommunityMart.Dim.ReferralType.ReferralTypeID
		,CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.CommunityProgram.CommunityProgramID
		,CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID
		,CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID
		,CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID
		,CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID
		,CommunityMart.Dim.ReferralSource.ReferralSourceID
		,CommunityMart.Dim.Intervention.InterventionID
		,CommunityMart.Dim.InterventionType.InterventionTypeID
		,CommunityMart.Dim.Intervention.InterventionID
		,CommunityMart.Dim.InterventionType.InterventionTypeID
		,CommunityMart.dbo.PersonFact.PatientID
FROM CommunityMart.dbo.HomeSupportActivityFact
LEFT JOIN CommunityMart.dbo.PersonFact
ON CommunityMart.dbo.PersonFact.SourceSystemClientID=CommunityMart.dbo.HomeSupportActivityFact.SourceSystemClientID
	LEFT JOIN CommunityMart.Dim.DeathLocation
	ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
	LEFT JOIN CommunityMart.Dim.Ethnicity
	ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
	LEFT JOIN CommunityMart.Dim.Gender
	ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
	LEFT JOIN CommunityMart.Dim.EducationLevelLookup
	ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
		LEFT JOIN CommunityMart.Dim.EducationLevel
		ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
LEFT JOIN CommunityMart.Dim.InterventionType
ON CommunityMart.Dim.InterventionType.InterventionTypeID=CommunityMart.dbo.HomeSupportActivityFact.InterventionTypeID
LEFT JOIN CommunityMart.dbo.ReferralFact
ON CommunityMart.dbo.ReferralFact.SourceReferralID=CommunityMart.dbo.HomeSupportActivityFact.SourceReferralID
	LEFT JOIN CommunityMart.Dim.ReferralPriority
	ON CommunityMart.Dim.ReferralPriority.ReferralPriorityID=CommunityMart.dbo.ReferralFact.ReferralPriorityID
	LEFT JOIN CommunityMart.dbo.PersonFact
	ON CommunityMart.dbo.PersonFact.SourceSystemClientID=CommunityMart.dbo.ReferralFact.SourceSystemClientID
		LEFT JOIN CommunityMart.Dim.DeathLocation
		ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
		LEFT JOIN CommunityMart.Dim.Ethnicity
		ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
		LEFT JOIN CommunityMart.Dim.Gender
		ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
		LEFT JOIN CommunityMart.Dim.EducationLevelLookup
		ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
			LEFT JOIN CommunityMart.Dim.EducationLevel
			ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
	LEFT JOIN CommunityMart.Dim.DischargeDispositionLookupCOM
	ON CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=CommunityMart.dbo.ReferralFact.DischargeDispositionCodeID
		LEFT JOIN CommunityMart.Dim.DischargeDisposition
		ON CommunityMart.Dim.DischargeDisposition.DischargeDispositionID=CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionID
	LEFT JOIN CommunityMart.Dim.ReferralReason
	ON CommunityMart.Dim.ReferralReason.ReferralReasonID=CommunityMart.dbo.ReferralFact.ReferralReasonID
	LEFT JOIN CommunityMart.Dim.ReferralType
	ON CommunityMart.Dim.ReferralType.ReferralTypeID=CommunityMart.dbo.ReferralFact.ReferralTypeID
	LEFT JOIN CommunityMart.Dim.LocalReportingOffice
	ON CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID=CommunityMart.dbo.ReferralFact.LocalReportingOfficeID
		LEFT JOIN CommunityMart.Dim.Provider
		ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.Dim.LocalReportingOffice.ProviderID
			LEFT JOIN CommunityMart.Dim.LevelOfCare
			ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
			LEFT JOIN CommunityMart.Dim.Facility
			ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
				LEFT JOIN CommunityMart.Dim.HSDA
				ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
		LEFT JOIN CommunityMart.Dim.CommunityProgram
		ON CommunityMart.Dim.CommunityProgram.CommunityProgramID=CommunityMart.Dim.LocalReportingOffice.CommunityProgramID
	LEFT JOIN CommunityMart.Dim.DischargeOutcome
	ON CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID=CommunityMart.dbo.ReferralFact.DischargeOutcomeID
	LEFT JOIN CommunityMart.Dim.ReasonEndingServiceLookup
	ON CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=CommunityMart.dbo.ReferralFact.ReasonEndingServiceCodeID
		LEFT JOIN CommunityMart.Dim.ReasonEndingService
		ON CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID=CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
	LEFT JOIN CommunityMart.Dim.ReferralSourceLookup
	ON CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID=CommunityMart.dbo.ReferralFact.ReferralSourceLookupID
		LEFT JOIN CommunityMart.Dim.ReferralSource
		ON CommunityMart.Dim.ReferralSource.ReferralSourceID=CommunityMart.Dim.ReferralSourceLookup.ReferralSourceID
LEFT JOIN CommunityMart.Dim.Provider
ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.dbo.HomeSupportActivityFact.ProviderID
	LEFT JOIN CommunityMart.Dim.LevelOfCare
	ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
	LEFT JOIN CommunityMart.Dim.Facility
	ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
		LEFT JOIN CommunityMart.Dim.HSDA
		ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
LEFT JOIN CommunityMart.Dim.LocalReportingOffice
ON CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID=CommunityMart.dbo.HomeSupportActivityFact.LocalReportingOfficeID
	LEFT JOIN CommunityMart.Dim.Provider
	ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.Dim.LocalReportingOffice.ProviderID
		LEFT JOIN CommunityMart.Dim.LevelOfCare
		ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
		LEFT JOIN CommunityMart.Dim.Facility
		ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
			LEFT JOIN CommunityMart.Dim.HSDA
			ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
	LEFT JOIN CommunityMart.Dim.CommunityProgram
	ON CommunityMart.Dim.CommunityProgram.CommunityProgramID=CommunityMart.Dim.LocalReportingOffice.CommunityProgramID
LEFT JOIN CommunityMart.dbo.InterventionFact
ON CommunityMart.dbo.InterventionFact.SourceInterventionID=CommunityMart.dbo.HomeSupportActivityFact.SourceInterventionID
	LEFT JOIN CommunityMart.Dim.Provider
	ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.dbo.InterventionFact.ProviderID
		LEFT JOIN CommunityMart.Dim.LevelOfCare
		ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
		LEFT JOIN CommunityMart.Dim.Facility
		ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
			LEFT JOIN CommunityMart.Dim.HSDA
			ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
	LEFT JOIN CommunityMart.dbo.ReferralFact
	ON CommunityMart.dbo.ReferralFact.SourceReferralID=CommunityMart.dbo.InterventionFact.SourceReferralID
		LEFT JOIN CommunityMart.Dim.ReferralPriority
		ON CommunityMart.Dim.ReferralPriority.ReferralPriorityID=CommunityMart.dbo.ReferralFact.ReferralPriorityID
		LEFT JOIN CommunityMart.dbo.PersonFact
		ON CommunityMart.dbo.PersonFact.SourceSystemClientID=CommunityMart.dbo.ReferralFact.SourceSystemClientID
			LEFT JOIN CommunityMart.Dim.DeathLocation
			ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
			LEFT JOIN CommunityMart.Dim.Ethnicity
			ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
			LEFT JOIN CommunityMart.Dim.Gender
			ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
			LEFT JOIN CommunityMart.Dim.EducationLevelLookup
			ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
				LEFT JOIN CommunityMart.Dim.EducationLevel
				ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
		LEFT JOIN CommunityMart.Dim.DischargeDispositionLookupCOM
		ON CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=CommunityMart.dbo.ReferralFact.DischargeDispositionCodeID
			LEFT JOIN CommunityMart.Dim.DischargeDisposition
			ON CommunityMart.Dim.DischargeDisposition.DischargeDispositionID=CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionID
		LEFT JOIN CommunityMart.Dim.ReferralReason
		ON CommunityMart.Dim.ReferralReason.ReferralReasonID=CommunityMart.dbo.ReferralFact.ReferralReasonID
		LEFT JOIN CommunityMart.Dim.ReferralType
		ON CommunityMart.Dim.ReferralType.ReferralTypeID=CommunityMart.dbo.ReferralFact.ReferralTypeID
		LEFT JOIN CommunityMart.Dim.LocalReportingOffice
		ON CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID=CommunityMart.dbo.ReferralFact.LocalReportingOfficeID
			LEFT JOIN CommunityMart.Dim.Provider
			ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.Dim.LocalReportingOffice.ProviderID
				LEFT JOIN CommunityMart.Dim.LevelOfCare
				ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
				LEFT JOIN CommunityMart.Dim.Facility
				ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
					LEFT JOIN CommunityMart.Dim.HSDA
					ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
			LEFT JOIN CommunityMart.Dim.CommunityProgram
			ON CommunityMart.Dim.CommunityProgram.CommunityProgramID=CommunityMart.Dim.LocalReportingOffice.CommunityProgramID
		LEFT JOIN CommunityMart.Dim.DischargeOutcome
		ON CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID=CommunityMart.dbo.ReferralFact.DischargeOutcomeID
		LEFT JOIN CommunityMart.Dim.ReasonEndingServiceLookup
		ON CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=CommunityMart.dbo.ReferralFact.ReasonEndingServiceCodeID
			LEFT JOIN CommunityMart.Dim.ReasonEndingService
			ON CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID=CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
		LEFT JOIN CommunityMart.Dim.ReferralSourceLookup
		ON CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID=CommunityMart.dbo.ReferralFact.ReferralSourceLookupID
			LEFT JOIN CommunityMart.Dim.ReferralSource
			ON CommunityMart.Dim.ReferralSource.ReferralSourceID=CommunityMart.Dim.ReferralSourceLookup.ReferralSourceID
	LEFT JOIN CommunityMart.Dim.Intervention
	ON CommunityMart.Dim.Intervention.InterventionID=CommunityMart.dbo.InterventionFact.InterventionID
		LEFT JOIN CommunityMart.Dim.InterventionType
		ON CommunityMart.Dim.InterventionType.InterventionTypeID=CommunityMart.Dim.Intervention.InterventionTypeID
LEFT JOIN CommunityMart.Dim.Intervention
ON CommunityMart.Dim.Intervention.InterventionID=CommunityMart.dbo.HomeSupportActivityFact.InterventionID
	LEFT JOIN CommunityMart.Dim.InterventionType
	ON CommunityMart.Dim.InterventionType.InterventionTypeID=CommunityMart.Dim.Intervention.InterventionTypeID
)
MERGE INTO CommunityMart.dbo.HomeSupportActivityFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.InterventionTypeID=src.InterventionTypeID,
	dst.SourceReferralID=src.SourceReferralID,
	dst.ReferralPriorityID=src.ReferralPriorityID,
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.DischargeDispositionCodeID=src.DischargeDispositionCodeID,
	dst.DischargeDispositionID=src.DischargeDispositionID,
	dst.ReferralReasonID=src.ReferralReasonID,
	dst.ReferralTypeID=src.ReferralTypeID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.DischargeOutcomeID=src.DischargeOutcomeID,
	dst.ReasonEndingServiceCodeID=src.ReasonEndingServiceCodeID,
	dst.ReasonEndingServiceID=src.ReasonEndingServiceID,
	dst.ReferralSourceLookupID=src.ReferralSourceLookupID,
	dst.ReferralSourceID=src.ReferralSourceID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.SourceInterventionID=src.SourceInterventionID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.SourceReferralID=src.SourceReferralID,
	dst.ReferralPriorityID=src.ReferralPriorityID,
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.DischargeDispositionCodeID=src.DischargeDispositionCodeID,
	dst.DischargeDispositionID=src.DischargeDispositionID,
	dst.ReferralReasonID=src.ReferralReasonID,
	dst.ReferralTypeID=src.ReferralTypeID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.DischargeOutcomeID=src.DischargeOutcomeID,
	dst.ReasonEndingServiceCodeID=src.ReasonEndingServiceCodeID,
	dst.ReasonEndingServiceID=src.ReasonEndingServiceID,
	dst.ReferralSourceLookupID=src.ReferralSourceLookupID,
	dst.ReferralSourceID=src.ReferralSourceID,
	dst.InterventionID=src.InterventionID,
	dst.InterventionTypeID=src.InterventionTypeID,
	dst.InterventionID=src.InterventionID,
	dst.InterventionTypeID=src.InterventionTypeID,
	dst.PatientID=src.PatientID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='Update/Merge CommunityMart.dbo.HomeSupportActivityFact (denormalize)', 
@pRuleDesc='', 
@pConditionSQL=NULL, 
@pActionID=4, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=1600, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='CommunityMart.dbo.HomeSupportActivityFact', 
@pTargetAttributePhysicalName='many', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python for CommunityMart.dbo.HomeSupportActivityFact', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR Update/Merge CommunityMart.dbo.HomeSupportActivityFact (denormalize)



--#region BR Update/Merge CommunityMart.dbo.WaitlistClientOfferFact (denormalize)
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '54c0e834-7b82-11e6-b522-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		CommunityMart.dbo.WaitlistClientOfferFact.ETLAuditID
		,CommunityMart.Dim.WaitlistReasonRejected.WaitlistReasonRejectedID
		,CommunityMart.dbo.WaitlistProviderOfferFact.SourceWaitlistProviderOfferID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.dbo.WaitlistDefinitionFact.SourceWaitlistDefinitionID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.WaitlistType.WaitlistTypeID
		,CommunityMart.Dim.WaitlistReasonOfferRemoved.WaitlistReasonOfferRemovedID
		,CommunityMart.Dim.WaitlistProviderOfferStatus.WaitlistProviderOfferStatusID
		,CommunityMart.Dim.WaitlistReasonNotOffered.WaitlistReasonNotOfferedID
		,CommunityMart.Dim.WaitlistOfferOutcome.WaitlistOfferOutcomeID
		,CommunityMart.Dim.WaitlistClientOfferStatus.WaitlistClientOfferStatusID
		,CommunityMart.dbo.WaitlistEntryFact.SourceWaitlistEntryID
		,CommunityMart.dbo.PersonFact.SourceSystemClientID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
		,CommunityMart.Dim.WaitlistStatus.WaitlistStatusID
		,CommunityMart.Dim.WaitlistPriority.WaitlistPriorityID
		,CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.CommunityProgram.CommunityProgramID
		,CommunityMart.dbo.WaitlistDefinitionFact.SourceWaitlistDefinitionID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.WaitlistType.WaitlistTypeID
		,CommunityMart.Dim.WaitListReason.WaitListReasonID
		,CommunityMart.dbo.PersonFact.PatientID
FROM CommunityMart.dbo.WaitlistClientOfferFact
LEFT JOIN CommunityMart.Dim.WaitlistReasonRejected
ON CommunityMart.Dim.WaitlistReasonRejected.WaitlistReasonRejectedID=CommunityMart.dbo.WaitlistClientOfferFact.WaitlistReasonRejectedID
LEFT JOIN CommunityMart.dbo.WaitlistProviderOfferFact
ON CommunityMart.dbo.WaitlistProviderOfferFact.SourceWaitlistProviderOfferID=CommunityMart.dbo.WaitlistClientOfferFact.SourceWaitlistProviderOfferID
	LEFT JOIN CommunityMart.Dim.Provider
	ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.dbo.WaitlistProviderOfferFact.ProviderID
		LEFT JOIN CommunityMart.Dim.LevelOfCare
		ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
		LEFT JOIN CommunityMart.Dim.Facility
		ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
			LEFT JOIN CommunityMart.Dim.HSDA
			ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
	LEFT JOIN CommunityMart.dbo.WaitlistDefinitionFact
	ON CommunityMart.dbo.WaitlistDefinitionFact.SourceWaitlistDefinitionID=CommunityMart.dbo.WaitlistProviderOfferFact.SourceWaitlistDefinitionID
		LEFT JOIN CommunityMart.Dim.Provider
		ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.dbo.WaitlistDefinitionFact.ProviderID
			LEFT JOIN CommunityMart.Dim.LevelOfCare
			ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
			LEFT JOIN CommunityMart.Dim.Facility
			ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
				LEFT JOIN CommunityMart.Dim.HSDA
				ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
		LEFT JOIN CommunityMart.Dim.WaitlistType
		ON CommunityMart.Dim.WaitlistType.WaitlistTypeID=CommunityMart.dbo.WaitlistDefinitionFact.WaitlistTypeID
	LEFT JOIN CommunityMart.Dim.WaitlistReasonOfferRemoved
	ON CommunityMart.Dim.WaitlistReasonOfferRemoved.WaitlistReasonOfferRemovedID=CommunityMart.dbo.WaitlistProviderOfferFact.WaitlistReasonOfferRemovedID
	LEFT JOIN CommunityMart.Dim.WaitlistProviderOfferStatus
	ON CommunityMart.Dim.WaitlistProviderOfferStatus.WaitlistProviderOfferStatusID=CommunityMart.dbo.WaitlistProviderOfferFact.WaitlistProviderOfferStatusID
LEFT JOIN CommunityMart.Dim.WaitlistReasonNotOffered
ON CommunityMart.Dim.WaitlistReasonNotOffered.WaitlistReasonNotOfferedID=CommunityMart.dbo.WaitlistClientOfferFact.WaitlistReasonNotOfferedID
LEFT JOIN CommunityMart.Dim.WaitlistOfferOutcome
ON CommunityMart.Dim.WaitlistOfferOutcome.WaitlistOfferOutcomeID=CommunityMart.dbo.WaitlistClientOfferFact.WaitlistOfferOutcomeID
LEFT JOIN CommunityMart.Dim.WaitlistClientOfferStatus
ON CommunityMart.Dim.WaitlistClientOfferStatus.WaitlistClientOfferStatusID=CommunityMart.dbo.WaitlistClientOfferFact.WaitlistClientOfferStatusID
LEFT JOIN CommunityMart.dbo.WaitlistEntryFact
ON CommunityMart.dbo.WaitlistEntryFact.SourceWaitlistEntryID=CommunityMart.dbo.WaitlistClientOfferFact.SourceWaitlistEntryID
	LEFT JOIN CommunityMart.dbo.PersonFact
	ON CommunityMart.dbo.PersonFact.SourceSystemClientID=CommunityMart.dbo.WaitlistEntryFact.SourceSystemClientID
		LEFT JOIN CommunityMart.Dim.DeathLocation
		ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
		LEFT JOIN CommunityMart.Dim.Ethnicity
		ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
		LEFT JOIN CommunityMart.Dim.Gender
		ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
		LEFT JOIN CommunityMart.Dim.EducationLevelLookup
		ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
			LEFT JOIN CommunityMart.Dim.EducationLevel
			ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
	LEFT JOIN CommunityMart.Dim.WaitlistStatus
	ON CommunityMart.Dim.WaitlistStatus.WaitlistStatusID=CommunityMart.dbo.WaitlistEntryFact.WaitlistStatusID
	LEFT JOIN CommunityMart.Dim.WaitlistPriority
	ON CommunityMart.Dim.WaitlistPriority.WaitlistPriorityID=CommunityMart.dbo.WaitlistEntryFact.WaitlistPriorityID
	LEFT JOIN CommunityMart.Dim.LocalReportingOffice
	ON CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID=CommunityMart.dbo.WaitlistEntryFact.LocalReportingOfficeID
		LEFT JOIN CommunityMart.Dim.Provider
		ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.Dim.LocalReportingOffice.ProviderID
			LEFT JOIN CommunityMart.Dim.LevelOfCare
			ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
			LEFT JOIN CommunityMart.Dim.Facility
			ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
				LEFT JOIN CommunityMart.Dim.HSDA
				ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
		LEFT JOIN CommunityMart.Dim.CommunityProgram
		ON CommunityMart.Dim.CommunityProgram.CommunityProgramID=CommunityMart.Dim.LocalReportingOffice.CommunityProgramID
	LEFT JOIN CommunityMart.dbo.WaitlistDefinitionFact
	ON CommunityMart.dbo.WaitlistDefinitionFact.SourceWaitlistDefinitionID=CommunityMart.dbo.WaitlistEntryFact.SourceWaitlistDefinitionID
		LEFT JOIN CommunityMart.Dim.Provider
		ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.dbo.WaitlistDefinitionFact.ProviderID
			LEFT JOIN CommunityMart.Dim.LevelOfCare
			ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
			LEFT JOIN CommunityMart.Dim.Facility
			ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
				LEFT JOIN CommunityMart.Dim.HSDA
				ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
		LEFT JOIN CommunityMart.Dim.WaitlistType
		ON CommunityMart.Dim.WaitlistType.WaitlistTypeID=CommunityMart.dbo.WaitlistDefinitionFact.WaitlistTypeID
	LEFT JOIN CommunityMart.Dim.WaitListReason
	ON CommunityMart.Dim.WaitListReason.WaitListReasonID=CommunityMart.dbo.WaitlistEntryFact.WaitListReasonID
)
MERGE INTO CommunityMart.dbo.WaitlistClientOfferFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.WaitlistReasonRejectedID=src.WaitlistReasonRejectedID,
	dst.SourceWaitlistProviderOfferID=src.SourceWaitlistProviderOfferID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.SourceWaitlistDefinitionID=src.SourceWaitlistDefinitionID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.WaitlistTypeID=src.WaitlistTypeID,
	dst.WaitlistReasonOfferRemovedID=src.WaitlistReasonOfferRemovedID,
	dst.WaitlistProviderOfferStatusID=src.WaitlistProviderOfferStatusID,
	dst.WaitlistReasonNotOfferedID=src.WaitlistReasonNotOfferedID,
	dst.WaitlistOfferOutcomeID=src.WaitlistOfferOutcomeID,
	dst.WaitlistClientOfferStatusID=src.WaitlistClientOfferStatusID,
	dst.SourceWaitlistEntryID=src.SourceWaitlistEntryID,
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.WaitlistStatusID=src.WaitlistStatusID,
	dst.WaitlistPriorityID=src.WaitlistPriorityID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.SourceWaitlistDefinitionID=src.SourceWaitlistDefinitionID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.WaitlistTypeID=src.WaitlistTypeID,
	dst.WaitListReasonID=src.WaitListReasonID,
	dst.PatientID=src.PatientID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='Update/Merge CommunityMart.dbo.WaitlistClientOfferFact (denormalize)', 
@pRuleDesc='', 
@pConditionSQL=NULL, 
@pActionID=4, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=1700, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='CommunityMart.dbo.WaitlistClientOfferFact', 
@pTargetAttributePhysicalName='many', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python for CommunityMart.dbo.WaitlistClientOfferFact', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR Update/Merge CommunityMart.dbo.WaitlistClientOfferFact (denormalize)



--#region BR Update/Merge CommunityMart.dbo.SchoolHistoryFact (denormalize)
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '54c41c9c-7b82-11e6-ba09-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		CommunityMart.dbo.SchoolHistoryFact.ETLAuditID
		,CommunityMart.dbo.PersonFact.SourceSystemClientID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
		,CommunityMart.Dim.CommunityServiceLocation.CommunityServiceLocationID
		,CommunityMart.dbo.PersonFact.PatientID
FROM CommunityMart.dbo.SchoolHistoryFact
LEFT JOIN CommunityMart.dbo.PersonFact
ON CommunityMart.dbo.PersonFact.SourceSystemClientID=CommunityMart.dbo.SchoolHistoryFact.SourceSystemClientID
	LEFT JOIN CommunityMart.Dim.DeathLocation
	ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
	LEFT JOIN CommunityMart.Dim.Ethnicity
	ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
	LEFT JOIN CommunityMart.Dim.Gender
	ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
	LEFT JOIN CommunityMart.Dim.EducationLevelLookup
	ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
		LEFT JOIN CommunityMart.Dim.EducationLevel
		ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
LEFT JOIN CommunityMart.Dim.CommunityServiceLocation
ON CommunityMart.Dim.CommunityServiceLocation.CommunityServiceLocationID=CommunityMart.dbo.SchoolHistoryFact.CommunityServiceLocationID
)
MERGE INTO CommunityMart.dbo.SchoolHistoryFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.CommunityServiceLocationID=src.CommunityServiceLocationID,
	dst.PatientID=src.PatientID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='Update/Merge CommunityMart.dbo.SchoolHistoryFact (denormalize)', 
@pRuleDesc='', 
@pConditionSQL=NULL, 
@pActionID=4, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=1800, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='CommunityMart.dbo.SchoolHistoryFact', 
@pTargetAttributePhysicalName='many', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python for CommunityMart.dbo.SchoolHistoryFact', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR Update/Merge CommunityMart.dbo.SchoolHistoryFact (denormalize)



--#region BR Update/Merge CommunityMart.dbo.InterventionFact (denormalize)
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '54c5f166-7b82-11e6-82b3-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		CommunityMart.dbo.InterventionFact.ETLAuditID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.dbo.ReferralFact.SourceReferralID
		,CommunityMart.Dim.ReferralPriority.ReferralPriorityID
		,CommunityMart.dbo.PersonFact.SourceSystemClientID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
		,CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID
		,CommunityMart.Dim.DischargeDisposition.DischargeDispositionID
		,CommunityMart.Dim.ReferralReason.ReferralReasonID
		,CommunityMart.Dim.ReferralType.ReferralTypeID
		,CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.CommunityProgram.CommunityProgramID
		,CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID
		,CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID
		,CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID
		,CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID
		,CommunityMart.Dim.ReferralSource.ReferralSourceID
		,CommunityMart.Dim.Intervention.InterventionID
		,CommunityMart.Dim.InterventionType.InterventionTypeID
		,CommunityMart.dbo.PersonFact.PatientID
FROM CommunityMart.dbo.InterventionFact
LEFT JOIN CommunityMart.Dim.Provider
ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.dbo.InterventionFact.ProviderID
	LEFT JOIN CommunityMart.Dim.LevelOfCare
	ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
	LEFT JOIN CommunityMart.Dim.Facility
	ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
		LEFT JOIN CommunityMart.Dim.HSDA
		ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
LEFT JOIN CommunityMart.dbo.ReferralFact
ON CommunityMart.dbo.ReferralFact.SourceReferralID=CommunityMart.dbo.InterventionFact.SourceReferralID
	LEFT JOIN CommunityMart.Dim.ReferralPriority
	ON CommunityMart.Dim.ReferralPriority.ReferralPriorityID=CommunityMart.dbo.ReferralFact.ReferralPriorityID
	LEFT JOIN CommunityMart.dbo.PersonFact
	ON CommunityMart.dbo.PersonFact.SourceSystemClientID=CommunityMart.dbo.ReferralFact.SourceSystemClientID
		LEFT JOIN CommunityMart.Dim.DeathLocation
		ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
		LEFT JOIN CommunityMart.Dim.Ethnicity
		ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
		LEFT JOIN CommunityMart.Dim.Gender
		ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
		LEFT JOIN CommunityMart.Dim.EducationLevelLookup
		ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
			LEFT JOIN CommunityMart.Dim.EducationLevel
			ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
	LEFT JOIN CommunityMart.Dim.DischargeDispositionLookupCOM
	ON CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=CommunityMart.dbo.ReferralFact.DischargeDispositionCodeID
		LEFT JOIN CommunityMart.Dim.DischargeDisposition
		ON CommunityMart.Dim.DischargeDisposition.DischargeDispositionID=CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionID
	LEFT JOIN CommunityMart.Dim.ReferralReason
	ON CommunityMart.Dim.ReferralReason.ReferralReasonID=CommunityMart.dbo.ReferralFact.ReferralReasonID
	LEFT JOIN CommunityMart.Dim.ReferralType
	ON CommunityMart.Dim.ReferralType.ReferralTypeID=CommunityMart.dbo.ReferralFact.ReferralTypeID
	LEFT JOIN CommunityMart.Dim.LocalReportingOffice
	ON CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID=CommunityMart.dbo.ReferralFact.LocalReportingOfficeID
		LEFT JOIN CommunityMart.Dim.Provider
		ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.Dim.LocalReportingOffice.ProviderID
			LEFT JOIN CommunityMart.Dim.LevelOfCare
			ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
			LEFT JOIN CommunityMart.Dim.Facility
			ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
				LEFT JOIN CommunityMart.Dim.HSDA
				ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
		LEFT JOIN CommunityMart.Dim.CommunityProgram
		ON CommunityMart.Dim.CommunityProgram.CommunityProgramID=CommunityMart.Dim.LocalReportingOffice.CommunityProgramID
	LEFT JOIN CommunityMart.Dim.DischargeOutcome
	ON CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID=CommunityMart.dbo.ReferralFact.DischargeOutcomeID
	LEFT JOIN CommunityMart.Dim.ReasonEndingServiceLookup
	ON CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=CommunityMart.dbo.ReferralFact.ReasonEndingServiceCodeID
		LEFT JOIN CommunityMart.Dim.ReasonEndingService
		ON CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID=CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
	LEFT JOIN CommunityMart.Dim.ReferralSourceLookup
	ON CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID=CommunityMart.dbo.ReferralFact.ReferralSourceLookupID
		LEFT JOIN CommunityMart.Dim.ReferralSource
		ON CommunityMart.Dim.ReferralSource.ReferralSourceID=CommunityMart.Dim.ReferralSourceLookup.ReferralSourceID
LEFT JOIN CommunityMart.Dim.Intervention
ON CommunityMart.Dim.Intervention.InterventionID=CommunityMart.dbo.InterventionFact.InterventionID
	LEFT JOIN CommunityMart.Dim.InterventionType
	ON CommunityMart.Dim.InterventionType.InterventionTypeID=CommunityMart.Dim.Intervention.InterventionTypeID
)
MERGE INTO CommunityMart.dbo.InterventionFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.SourceReferralID=src.SourceReferralID,
	dst.ReferralPriorityID=src.ReferralPriorityID,
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.DischargeDispositionCodeID=src.DischargeDispositionCodeID,
	dst.DischargeDispositionID=src.DischargeDispositionID,
	dst.ReferralReasonID=src.ReferralReasonID,
	dst.ReferralTypeID=src.ReferralTypeID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.DischargeOutcomeID=src.DischargeOutcomeID,
	dst.ReasonEndingServiceCodeID=src.ReasonEndingServiceCodeID,
	dst.ReasonEndingServiceID=src.ReasonEndingServiceID,
	dst.ReferralSourceLookupID=src.ReferralSourceLookupID,
	dst.ReferralSourceID=src.ReferralSourceID,
	dst.InterventionID=src.InterventionID,
	dst.InterventionTypeID=src.InterventionTypeID,
	dst.PatientID=src.PatientID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='Update/Merge CommunityMart.dbo.InterventionFact (denormalize)', 
@pRuleDesc='', 
@pConditionSQL=NULL, 
@pActionID=4, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=1900, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='CommunityMart.dbo.InterventionFact', 
@pTargetAttributePhysicalName='many', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python for CommunityMart.dbo.InterventionFact', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR Update/Merge CommunityMart.dbo.InterventionFact (denormalize)



--#region BR Update/Merge CommunityMart.dbo.AssessmentContactFact (denormalize)
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '54c8b098-7b82-11e6-b43b-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		CommunityMart.dbo.AssessmentContactFact.ETLAuditID
		,CommunityMart.Dim.ContactType.ContactTypeID
		,CommunityMart.Dim.CommunityServiceLocation.CommunityServiceLocationID
		,CommunityMart.dbo.AssessmentHeaderFact.SourceAssessmentID
		,CommunityMart.dbo.ReferralFact.SourceReferralID
		,CommunityMart.Dim.ReferralPriority.ReferralPriorityID
		,CommunityMart.dbo.PersonFact.SourceSystemClientID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
		,CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID
		,CommunityMart.Dim.DischargeDisposition.DischargeDispositionID
		,CommunityMart.Dim.ReferralReason.ReferralReasonID
		,CommunityMart.Dim.ReferralType.ReferralTypeID
		,CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.CommunityProgram.CommunityProgramID
		,CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID
		,CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID
		,CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID
		,CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID
		,CommunityMart.Dim.ReferralSource.ReferralSourceID
		,CommunityMart.Dim.AssessmentType.AssessmentTypeID
		,CommunityMart.Dim.AssessmentReason.AssessmentReasonID
		,CommunityMart.dbo.PersonFact.PatientID
FROM CommunityMart.dbo.AssessmentContactFact
LEFT JOIN CommunityMart.Dim.ContactType
ON CommunityMart.Dim.ContactType.ContactTypeID=CommunityMart.dbo.AssessmentContactFact.ContactTypeID
LEFT JOIN CommunityMart.Dim.CommunityServiceLocation
ON CommunityMart.Dim.CommunityServiceLocation.CommunityServiceLocationID=CommunityMart.dbo.AssessmentContactFact.CommunityServiceLocationID
LEFT JOIN CommunityMart.dbo.AssessmentHeaderFact
ON CommunityMart.dbo.AssessmentHeaderFact.SourceAssessmentID=CommunityMart.dbo.AssessmentContactFact.SourceAssessmentID
	LEFT JOIN CommunityMart.dbo.ReferralFact
	ON CommunityMart.dbo.ReferralFact.SourceReferralID=CommunityMart.dbo.AssessmentHeaderFact.SourceReferralID
		LEFT JOIN CommunityMart.Dim.ReferralPriority
		ON CommunityMart.Dim.ReferralPriority.ReferralPriorityID=CommunityMart.dbo.ReferralFact.ReferralPriorityID
		LEFT JOIN CommunityMart.dbo.PersonFact
		ON CommunityMart.dbo.PersonFact.SourceSystemClientID=CommunityMart.dbo.ReferralFact.SourceSystemClientID
			LEFT JOIN CommunityMart.Dim.DeathLocation
			ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
			LEFT JOIN CommunityMart.Dim.Ethnicity
			ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
			LEFT JOIN CommunityMart.Dim.Gender
			ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
			LEFT JOIN CommunityMart.Dim.EducationLevelLookup
			ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
				LEFT JOIN CommunityMart.Dim.EducationLevel
				ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
		LEFT JOIN CommunityMart.Dim.DischargeDispositionLookupCOM
		ON CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=CommunityMart.dbo.ReferralFact.DischargeDispositionCodeID
			LEFT JOIN CommunityMart.Dim.DischargeDisposition
			ON CommunityMart.Dim.DischargeDisposition.DischargeDispositionID=CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionID
		LEFT JOIN CommunityMart.Dim.ReferralReason
		ON CommunityMart.Dim.ReferralReason.ReferralReasonID=CommunityMart.dbo.ReferralFact.ReferralReasonID
		LEFT JOIN CommunityMart.Dim.ReferralType
		ON CommunityMart.Dim.ReferralType.ReferralTypeID=CommunityMart.dbo.ReferralFact.ReferralTypeID
		LEFT JOIN CommunityMart.Dim.LocalReportingOffice
		ON CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID=CommunityMart.dbo.ReferralFact.LocalReportingOfficeID
			LEFT JOIN CommunityMart.Dim.Provider
			ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.Dim.LocalReportingOffice.ProviderID
				LEFT JOIN CommunityMart.Dim.LevelOfCare
				ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
				LEFT JOIN CommunityMart.Dim.Facility
				ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
					LEFT JOIN CommunityMart.Dim.HSDA
					ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
			LEFT JOIN CommunityMart.Dim.CommunityProgram
			ON CommunityMart.Dim.CommunityProgram.CommunityProgramID=CommunityMart.Dim.LocalReportingOffice.CommunityProgramID
		LEFT JOIN CommunityMart.Dim.DischargeOutcome
		ON CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID=CommunityMart.dbo.ReferralFact.DischargeOutcomeID
		LEFT JOIN CommunityMart.Dim.ReasonEndingServiceLookup
		ON CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=CommunityMart.dbo.ReferralFact.ReasonEndingServiceCodeID
			LEFT JOIN CommunityMart.Dim.ReasonEndingService
			ON CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID=CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
		LEFT JOIN CommunityMart.Dim.ReferralSourceLookup
		ON CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID=CommunityMart.dbo.ReferralFact.ReferralSourceLookupID
			LEFT JOIN CommunityMart.Dim.ReferralSource
			ON CommunityMart.Dim.ReferralSource.ReferralSourceID=CommunityMart.Dim.ReferralSourceLookup.ReferralSourceID
	LEFT JOIN CommunityMart.Dim.AssessmentType
	ON CommunityMart.Dim.AssessmentType.AssessmentTypeID=CommunityMart.dbo.AssessmentHeaderFact.AssessmentTypeID
	LEFT JOIN CommunityMart.Dim.AssessmentReason
	ON CommunityMart.Dim.AssessmentReason.AssessmentReasonID=CommunityMart.dbo.AssessmentHeaderFact.AssessmentReasonID
)
MERGE INTO CommunityMart.dbo.AssessmentContactFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.ContactTypeID=src.ContactTypeID,
	dst.CommunityServiceLocationID=src.CommunityServiceLocationID,
	dst.SourceAssessmentID=src.SourceAssessmentID,
	dst.SourceReferralID=src.SourceReferralID,
	dst.ReferralPriorityID=src.ReferralPriorityID,
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.DischargeDispositionCodeID=src.DischargeDispositionCodeID,
	dst.DischargeDispositionID=src.DischargeDispositionID,
	dst.ReferralReasonID=src.ReferralReasonID,
	dst.ReferralTypeID=src.ReferralTypeID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.DischargeOutcomeID=src.DischargeOutcomeID,
	dst.ReasonEndingServiceCodeID=src.ReasonEndingServiceCodeID,
	dst.ReasonEndingServiceID=src.ReasonEndingServiceID,
	dst.ReferralSourceLookupID=src.ReferralSourceLookupID,
	dst.ReferralSourceID=src.ReferralSourceID,
	dst.AssessmentTypeID=src.AssessmentTypeID,
	dst.AssessmentReasonID=src.AssessmentReasonID,
	dst.PatientID=src.PatientID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='Update/Merge CommunityMart.dbo.AssessmentContactFact (denormalize)', 
@pRuleDesc='', 
@pConditionSQL=NULL, 
@pActionID=4, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=2000, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='CommunityMart.dbo.AssessmentContactFact', 
@pTargetAttributePhysicalName='many', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python for CommunityMart.dbo.AssessmentContactFact', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR Update/Merge CommunityMart.dbo.AssessmentContactFact (denormalize)



--#region BR Update/Merge CommunityMart.dbo.CaseNoteHeaderFact (denormalize)
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '54cbbdec-7b82-11e6-9c0a-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		CommunityMart.dbo.CaseNoteHeaderFact.ETLAuditID
		,CommunityMart.dbo.PersonFact.SourceSystemClientID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
		,CommunityMart.dbo.ReferralFact.SourceReferralID
		,CommunityMart.Dim.ReferralPriority.ReferralPriorityID
		,CommunityMart.dbo.PersonFact.SourceSystemClientID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
		,CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID
		,CommunityMart.Dim.DischargeDisposition.DischargeDispositionID
		,CommunityMart.Dim.ReferralReason.ReferralReasonID
		,CommunityMart.Dim.ReferralType.ReferralTypeID
		,CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.CommunityProgram.CommunityProgramID
		,CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID
		,CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID
		,CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID
		,CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID
		,CommunityMart.Dim.ReferralSource.ReferralSourceID
		,CommunityMart.Dim.CaseNoteType.CaseNoteTypeID
		,CommunityMart.Dim.CaseNoteReason.CaseNoteReasonID
		,CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.CommunityProgram.CommunityProgramID
		,CommunityMart.dbo.PersonFact.PatientID
FROM CommunityMart.dbo.CaseNoteHeaderFact
LEFT JOIN CommunityMart.dbo.PersonFact
ON CommunityMart.dbo.PersonFact.SourceSystemClientID=CommunityMart.dbo.CaseNoteHeaderFact.SourceSystemClientID
	LEFT JOIN CommunityMart.Dim.DeathLocation
	ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
	LEFT JOIN CommunityMart.Dim.Ethnicity
	ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
	LEFT JOIN CommunityMart.Dim.Gender
	ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
	LEFT JOIN CommunityMart.Dim.EducationLevelLookup
	ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
		LEFT JOIN CommunityMart.Dim.EducationLevel
		ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
LEFT JOIN CommunityMart.dbo.ReferralFact
ON CommunityMart.dbo.ReferralFact.SourceReferralID=CommunityMart.dbo.CaseNoteHeaderFact.SourceReferralID
	LEFT JOIN CommunityMart.Dim.ReferralPriority
	ON CommunityMart.Dim.ReferralPriority.ReferralPriorityID=CommunityMart.dbo.ReferralFact.ReferralPriorityID
	LEFT JOIN CommunityMart.dbo.PersonFact
	ON CommunityMart.dbo.PersonFact.SourceSystemClientID=CommunityMart.dbo.ReferralFact.SourceSystemClientID
		LEFT JOIN CommunityMart.Dim.DeathLocation
		ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
		LEFT JOIN CommunityMart.Dim.Ethnicity
		ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
		LEFT JOIN CommunityMart.Dim.Gender
		ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
		LEFT JOIN CommunityMart.Dim.EducationLevelLookup
		ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
			LEFT JOIN CommunityMart.Dim.EducationLevel
			ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
	LEFT JOIN CommunityMart.Dim.DischargeDispositionLookupCOM
	ON CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=CommunityMart.dbo.ReferralFact.DischargeDispositionCodeID
		LEFT JOIN CommunityMart.Dim.DischargeDisposition
		ON CommunityMart.Dim.DischargeDisposition.DischargeDispositionID=CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionID
	LEFT JOIN CommunityMart.Dim.ReferralReason
	ON CommunityMart.Dim.ReferralReason.ReferralReasonID=CommunityMart.dbo.ReferralFact.ReferralReasonID
	LEFT JOIN CommunityMart.Dim.ReferralType
	ON CommunityMart.Dim.ReferralType.ReferralTypeID=CommunityMart.dbo.ReferralFact.ReferralTypeID
	LEFT JOIN CommunityMart.Dim.LocalReportingOffice
	ON CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID=CommunityMart.dbo.ReferralFact.LocalReportingOfficeID
		LEFT JOIN CommunityMart.Dim.Provider
		ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.Dim.LocalReportingOffice.ProviderID
			LEFT JOIN CommunityMart.Dim.LevelOfCare
			ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
			LEFT JOIN CommunityMart.Dim.Facility
			ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
				LEFT JOIN CommunityMart.Dim.HSDA
				ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
		LEFT JOIN CommunityMart.Dim.CommunityProgram
		ON CommunityMart.Dim.CommunityProgram.CommunityProgramID=CommunityMart.Dim.LocalReportingOffice.CommunityProgramID
	LEFT JOIN CommunityMart.Dim.DischargeOutcome
	ON CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID=CommunityMart.dbo.ReferralFact.DischargeOutcomeID
	LEFT JOIN CommunityMart.Dim.ReasonEndingServiceLookup
	ON CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=CommunityMart.dbo.ReferralFact.ReasonEndingServiceCodeID
		LEFT JOIN CommunityMart.Dim.ReasonEndingService
		ON CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID=CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
	LEFT JOIN CommunityMart.Dim.ReferralSourceLookup
	ON CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID=CommunityMart.dbo.ReferralFact.ReferralSourceLookupID
		LEFT JOIN CommunityMart.Dim.ReferralSource
		ON CommunityMart.Dim.ReferralSource.ReferralSourceID=CommunityMart.Dim.ReferralSourceLookup.ReferralSourceID
LEFT JOIN CommunityMart.Dim.CaseNoteType
ON CommunityMart.Dim.CaseNoteType.CaseNoteTypeID=CommunityMart.dbo.CaseNoteHeaderFact.CaseNoteTypeID
LEFT JOIN CommunityMart.Dim.CaseNoteReason
ON CommunityMart.Dim.CaseNoteReason.CaseNoteReasonID=CommunityMart.dbo.CaseNoteHeaderFact.CaseNoteReasonID
LEFT JOIN CommunityMart.Dim.LocalReportingOffice
ON CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID=CommunityMart.dbo.CaseNoteHeaderFact.LocalReportingOfficeID
	LEFT JOIN CommunityMart.Dim.Provider
	ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.Dim.LocalReportingOffice.ProviderID
		LEFT JOIN CommunityMart.Dim.LevelOfCare
		ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
		LEFT JOIN CommunityMart.Dim.Facility
		ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
			LEFT JOIN CommunityMart.Dim.HSDA
			ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
	LEFT JOIN CommunityMart.Dim.CommunityProgram
	ON CommunityMart.Dim.CommunityProgram.CommunityProgramID=CommunityMart.Dim.LocalReportingOffice.CommunityProgramID
)
MERGE INTO CommunityMart.dbo.CaseNoteHeaderFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.SourceReferralID=src.SourceReferralID,
	dst.ReferralPriorityID=src.ReferralPriorityID,
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.DischargeDispositionCodeID=src.DischargeDispositionCodeID,
	dst.DischargeDispositionID=src.DischargeDispositionID,
	dst.ReferralReasonID=src.ReferralReasonID,
	dst.ReferralTypeID=src.ReferralTypeID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.DischargeOutcomeID=src.DischargeOutcomeID,
	dst.ReasonEndingServiceCodeID=src.ReasonEndingServiceCodeID,
	dst.ReasonEndingServiceID=src.ReasonEndingServiceID,
	dst.ReferralSourceLookupID=src.ReferralSourceLookupID,
	dst.ReferralSourceID=src.ReferralSourceID,
	dst.CaseNoteTypeID=src.CaseNoteTypeID,
	dst.CaseNoteReasonID=src.CaseNoteReasonID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.PatientID=src.PatientID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='Update/Merge CommunityMart.dbo.CaseNoteHeaderFact (denormalize)', 
@pRuleDesc='', 
@pConditionSQL=NULL, 
@pActionID=4, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=2100, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='CommunityMart.dbo.CaseNoteHeaderFact', 
@pTargetAttributePhysicalName='many', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python for CommunityMart.dbo.CaseNoteHeaderFact', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR Update/Merge CommunityMart.dbo.CaseNoteHeaderFact (denormalize)



--#region BR Update/Merge CommunityMart.dbo.ClientGPFact (denormalize)
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '54cea430-7b82-11e6-bc85-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		CommunityMart.dbo.ClientGPFact.ETLAuditID
		,CommunityMart.dbo.PersonFact.SourceSystemClientID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
		,CommunityMart.dbo.PersonFact.PatientID
FROM CommunityMart.dbo.ClientGPFact
LEFT JOIN CommunityMart.dbo.PersonFact
ON CommunityMart.dbo.PersonFact.SourceSystemClientID=CommunityMart.dbo.ClientGPFact.SourceSystemClientID
	LEFT JOIN CommunityMart.Dim.DeathLocation
	ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
	LEFT JOIN CommunityMart.Dim.Ethnicity
	ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
	LEFT JOIN CommunityMart.Dim.Gender
	ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
	LEFT JOIN CommunityMart.Dim.EducationLevelLookup
	ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
		LEFT JOIN CommunityMart.Dim.EducationLevel
		ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
)
MERGE INTO CommunityMart.dbo.ClientGPFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.PatientID=src.PatientID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='Update/Merge CommunityMart.dbo.ClientGPFact (denormalize)', 
@pRuleDesc='', 
@pConditionSQL=NULL, 
@pActionID=4, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=2200, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='CommunityMart.dbo.ClientGPFact', 
@pTargetAttributePhysicalName='many', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python for CommunityMart.dbo.ClientGPFact', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR Update/Merge CommunityMart.dbo.ClientGPFact (denormalize)



--#region BR Update/Merge CommunityMart.dbo.WeightGrowthFact (denormalize)
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '54d2c2fa-7b82-11e6-b805-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		CommunityMart.dbo.WeightGrowthFact.ETLAuditID
		,CommunityMart.dbo.PersonFact.SourceSystemClientID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
		,CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.CommunityProgram.CommunityProgramID
		,CommunityMart.dbo.PersonFact.PatientID
FROM CommunityMart.dbo.WeightGrowthFact
LEFT JOIN CommunityMart.dbo.PersonFact
ON CommunityMart.dbo.PersonFact.SourceSystemClientID=CommunityMart.dbo.WeightGrowthFact.SourceSystemClientID
	LEFT JOIN CommunityMart.Dim.DeathLocation
	ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
	LEFT JOIN CommunityMart.Dim.Ethnicity
	ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
	LEFT JOIN CommunityMart.Dim.Gender
	ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
	LEFT JOIN CommunityMart.Dim.EducationLevelLookup
	ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
		LEFT JOIN CommunityMart.Dim.EducationLevel
		ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
LEFT JOIN CommunityMart.Dim.LocalReportingOffice
ON CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID=CommunityMart.dbo.WeightGrowthFact.LocalReportingOfficeID
	LEFT JOIN CommunityMart.Dim.Provider
	ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.Dim.LocalReportingOffice.ProviderID
		LEFT JOIN CommunityMart.Dim.LevelOfCare
		ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
		LEFT JOIN CommunityMart.Dim.Facility
		ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
			LEFT JOIN CommunityMart.Dim.HSDA
			ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
	LEFT JOIN CommunityMart.Dim.CommunityProgram
	ON CommunityMart.Dim.CommunityProgram.CommunityProgramID=CommunityMart.Dim.LocalReportingOffice.CommunityProgramID
)
MERGE INTO CommunityMart.dbo.WeightGrowthFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.PatientID=src.PatientID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='Update/Merge CommunityMart.dbo.WeightGrowthFact (denormalize)', 
@pRuleDesc='', 
@pConditionSQL=NULL, 
@pActionID=4, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=2300, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='CommunityMart.dbo.WeightGrowthFact', 
@pTargetAttributePhysicalName='many', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python for CommunityMart.dbo.WeightGrowthFact', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR Update/Merge CommunityMart.dbo.WeightGrowthFact (denormalize)



--#region BR Update/Merge CommunityMart.dbo.WaitlistEntryFact (denormalize)
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '54d5822c-7b82-11e6-a317-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		CommunityMart.dbo.WaitlistEntryFact.ETLAuditID
		,CommunityMart.dbo.PersonFact.SourceSystemClientID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
		,CommunityMart.Dim.WaitlistStatus.WaitlistStatusID
		,CommunityMart.Dim.WaitlistPriority.WaitlistPriorityID
		,CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.CommunityProgram.CommunityProgramID
		,CommunityMart.dbo.WaitlistDefinitionFact.SourceWaitlistDefinitionID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.WaitlistType.WaitlistTypeID
		,CommunityMart.Dim.WaitListReason.WaitListReasonID
		,CommunityMart.dbo.PersonFact.PatientID
FROM CommunityMart.dbo.WaitlistEntryFact
LEFT JOIN CommunityMart.dbo.PersonFact
ON CommunityMart.dbo.PersonFact.SourceSystemClientID=CommunityMart.dbo.WaitlistEntryFact.SourceSystemClientID
	LEFT JOIN CommunityMart.Dim.DeathLocation
	ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
	LEFT JOIN CommunityMart.Dim.Ethnicity
	ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
	LEFT JOIN CommunityMart.Dim.Gender
	ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
	LEFT JOIN CommunityMart.Dim.EducationLevelLookup
	ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
		LEFT JOIN CommunityMart.Dim.EducationLevel
		ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
LEFT JOIN CommunityMart.Dim.WaitlistStatus
ON CommunityMart.Dim.WaitlistStatus.WaitlistStatusID=CommunityMart.dbo.WaitlistEntryFact.WaitlistStatusID
LEFT JOIN CommunityMart.Dim.WaitlistPriority
ON CommunityMart.Dim.WaitlistPriority.WaitlistPriorityID=CommunityMart.dbo.WaitlistEntryFact.WaitlistPriorityID
LEFT JOIN CommunityMart.Dim.LocalReportingOffice
ON CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID=CommunityMart.dbo.WaitlistEntryFact.LocalReportingOfficeID
	LEFT JOIN CommunityMart.Dim.Provider
	ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.Dim.LocalReportingOffice.ProviderID
		LEFT JOIN CommunityMart.Dim.LevelOfCare
		ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
		LEFT JOIN CommunityMart.Dim.Facility
		ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
			LEFT JOIN CommunityMart.Dim.HSDA
			ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
	LEFT JOIN CommunityMart.Dim.CommunityProgram
	ON CommunityMart.Dim.CommunityProgram.CommunityProgramID=CommunityMart.Dim.LocalReportingOffice.CommunityProgramID
LEFT JOIN CommunityMart.dbo.WaitlistDefinitionFact
ON CommunityMart.dbo.WaitlistDefinitionFact.SourceWaitlistDefinitionID=CommunityMart.dbo.WaitlistEntryFact.SourceWaitlistDefinitionID
	LEFT JOIN CommunityMart.Dim.Provider
	ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.dbo.WaitlistDefinitionFact.ProviderID
		LEFT JOIN CommunityMart.Dim.LevelOfCare
		ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
		LEFT JOIN CommunityMart.Dim.Facility
		ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
			LEFT JOIN CommunityMart.Dim.HSDA
			ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
	LEFT JOIN CommunityMart.Dim.WaitlistType
	ON CommunityMart.Dim.WaitlistType.WaitlistTypeID=CommunityMart.dbo.WaitlistDefinitionFact.WaitlistTypeID
LEFT JOIN CommunityMart.Dim.WaitListReason
ON CommunityMart.Dim.WaitListReason.WaitListReasonID=CommunityMart.dbo.WaitlistEntryFact.WaitListReasonID
)
MERGE INTO CommunityMart.dbo.WaitlistEntryFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.WaitlistStatusID=src.WaitlistStatusID,
	dst.WaitlistPriorityID=src.WaitlistPriorityID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.SourceWaitlistDefinitionID=src.SourceWaitlistDefinitionID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.WaitlistTypeID=src.WaitlistTypeID,
	dst.WaitListReasonID=src.WaitListReasonID,
	dst.PatientID=src.PatientID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='Update/Merge CommunityMart.dbo.WaitlistEntryFact (denormalize)', 
@pRuleDesc='', 
@pConditionSQL=NULL, 
@pActionID=4, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=2400, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='CommunityMart.dbo.WaitlistEntryFact', 
@pTargetAttributePhysicalName='many', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python for CommunityMart.dbo.WaitlistEntryFact', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR Update/Merge CommunityMart.dbo.WaitlistEntryFact (denormalize)



--#region BR Update/Merge CommunityMart.dbo.AddressFact (denormalize)
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '54d7cc2c-7b82-11e6-a3da-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		CommunityMart.dbo.AddressFact.ETLAuditID
		,CommunityMart.dbo.PersonFact.SourceSystemClientID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
		,CommunityMart.Dim.AddressType.AddressTypeID
		,CommunityMart.Dim.HouseType.HouseTypeID
		,CommunityMart.Dim.PostalCode.PostalCodeID
		,CommunityMart.dbo.PersonFact.PatientID
FROM CommunityMart.dbo.AddressFact
LEFT JOIN CommunityMart.dbo.PersonFact
ON CommunityMart.dbo.PersonFact.SourceSystemClientID=CommunityMart.dbo.AddressFact.SourceSystemClientID
	LEFT JOIN CommunityMart.Dim.DeathLocation
	ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
	LEFT JOIN CommunityMart.Dim.Ethnicity
	ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
	LEFT JOIN CommunityMart.Dim.Gender
	ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
	LEFT JOIN CommunityMart.Dim.EducationLevelLookup
	ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
		LEFT JOIN CommunityMart.Dim.EducationLevel
		ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
LEFT JOIN CommunityMart.Dim.AddressType
ON CommunityMart.Dim.AddressType.AddressTypeID=CommunityMart.dbo.AddressFact.AddressTypeID
LEFT JOIN CommunityMart.Dim.HouseType
ON CommunityMart.Dim.HouseType.HouseTypeID=CommunityMart.dbo.AddressFact.HouseTypeID
LEFT JOIN CommunityMart.Dim.PostalCode
ON CommunityMart.Dim.PostalCode.PostalCodeID=CommunityMart.dbo.AddressFact.PostalCodeID
)
MERGE INTO CommunityMart.dbo.AddressFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.AddressTypeID=src.AddressTypeID,
	dst.HouseTypeID=src.HouseTypeID,
	dst.PostalCodeID=src.PostalCodeID,
	dst.PatientID=src.PatientID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='Update/Merge CommunityMart.dbo.AddressFact (denormalize)', 
@pRuleDesc='', 
@pConditionSQL=NULL, 
@pActionID=4, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=2500, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='CommunityMart.dbo.AddressFact', 
@pTargetAttributePhysicalName='many', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python for CommunityMart.dbo.AddressFact', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR Update/Merge CommunityMart.dbo.AddressFact (denormalize)



--#region BR Update/Merge CommunityMart.dbo.CDLabReportFact (denormalize)
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '54da3d3a-7b82-11e6-9144-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		CommunityMart.dbo.CDLabReportFact.ETLAuditID
		,CommunityMart.dbo.AssessmentHeaderFact.SourceAssessmentID
		,CommunityMart.dbo.ReferralFact.SourceReferralID
		,CommunityMart.Dim.ReferralPriority.ReferralPriorityID
		,CommunityMart.dbo.PersonFact.SourceSystemClientID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
		,CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID
		,CommunityMart.Dim.DischargeDisposition.DischargeDispositionID
		,CommunityMart.Dim.ReferralReason.ReferralReasonID
		,CommunityMart.Dim.ReferralType.ReferralTypeID
		,CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.CommunityProgram.CommunityProgramID
		,CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID
		,CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID
		,CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID
		,CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID
		,CommunityMart.Dim.ReferralSource.ReferralSourceID
		,CommunityMart.Dim.AssessmentType.AssessmentTypeID
		,CommunityMart.Dim.AssessmentReason.AssessmentReasonID
		,CommunityMart.dbo.CDPreviousTestResultFact.SourceAssessmentID
		,CommunityMart.Dim.CommunityDisease.CommunityDiseaseID
		,CommunityMart.dbo.PersonFact.PatientID
FROM CommunityMart.dbo.CDLabReportFact
LEFT JOIN CommunityMart.dbo.AssessmentHeaderFact
ON CommunityMart.dbo.AssessmentHeaderFact.SourceAssessmentID=CommunityMart.dbo.CDLabReportFact.SourceAssessmentID
	LEFT JOIN CommunityMart.dbo.ReferralFact
	ON CommunityMart.dbo.ReferralFact.SourceReferralID=CommunityMart.dbo.AssessmentHeaderFact.SourceReferralID
		LEFT JOIN CommunityMart.Dim.ReferralPriority
		ON CommunityMart.Dim.ReferralPriority.ReferralPriorityID=CommunityMart.dbo.ReferralFact.ReferralPriorityID
		LEFT JOIN CommunityMart.dbo.PersonFact
		ON CommunityMart.dbo.PersonFact.SourceSystemClientID=CommunityMart.dbo.ReferralFact.SourceSystemClientID
			LEFT JOIN CommunityMart.Dim.DeathLocation
			ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
			LEFT JOIN CommunityMart.Dim.Ethnicity
			ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
			LEFT JOIN CommunityMart.Dim.Gender
			ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
			LEFT JOIN CommunityMart.Dim.EducationLevelLookup
			ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
				LEFT JOIN CommunityMart.Dim.EducationLevel
				ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
		LEFT JOIN CommunityMart.Dim.DischargeDispositionLookupCOM
		ON CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=CommunityMart.dbo.ReferralFact.DischargeDispositionCodeID
			LEFT JOIN CommunityMart.Dim.DischargeDisposition
			ON CommunityMart.Dim.DischargeDisposition.DischargeDispositionID=CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionID
		LEFT JOIN CommunityMart.Dim.ReferralReason
		ON CommunityMart.Dim.ReferralReason.ReferralReasonID=CommunityMart.dbo.ReferralFact.ReferralReasonID
		LEFT JOIN CommunityMart.Dim.ReferralType
		ON CommunityMart.Dim.ReferralType.ReferralTypeID=CommunityMart.dbo.ReferralFact.ReferralTypeID
		LEFT JOIN CommunityMart.Dim.LocalReportingOffice
		ON CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID=CommunityMart.dbo.ReferralFact.LocalReportingOfficeID
			LEFT JOIN CommunityMart.Dim.Provider
			ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.Dim.LocalReportingOffice.ProviderID
				LEFT JOIN CommunityMart.Dim.LevelOfCare
				ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
				LEFT JOIN CommunityMart.Dim.Facility
				ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
					LEFT JOIN CommunityMart.Dim.HSDA
					ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
			LEFT JOIN CommunityMart.Dim.CommunityProgram
			ON CommunityMart.Dim.CommunityProgram.CommunityProgramID=CommunityMart.Dim.LocalReportingOffice.CommunityProgramID
		LEFT JOIN CommunityMart.Dim.DischargeOutcome
		ON CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID=CommunityMart.dbo.ReferralFact.DischargeOutcomeID
		LEFT JOIN CommunityMart.Dim.ReasonEndingServiceLookup
		ON CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=CommunityMart.dbo.ReferralFact.ReasonEndingServiceCodeID
			LEFT JOIN CommunityMart.Dim.ReasonEndingService
			ON CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID=CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
		LEFT JOIN CommunityMart.Dim.ReferralSourceLookup
		ON CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID=CommunityMart.dbo.ReferralFact.ReferralSourceLookupID
			LEFT JOIN CommunityMart.Dim.ReferralSource
			ON CommunityMart.Dim.ReferralSource.ReferralSourceID=CommunityMart.Dim.ReferralSourceLookup.ReferralSourceID
	LEFT JOIN CommunityMart.Dim.AssessmentType
	ON CommunityMart.Dim.AssessmentType.AssessmentTypeID=CommunityMart.dbo.AssessmentHeaderFact.AssessmentTypeID
	LEFT JOIN CommunityMart.Dim.AssessmentReason
	ON CommunityMart.Dim.AssessmentReason.AssessmentReasonID=CommunityMart.dbo.AssessmentHeaderFact.AssessmentReasonID
LEFT JOIN CommunityMart.dbo.CDPreviousTestResultFact
ON CommunityMart.dbo.CDPreviousTestResultFact.SourceAssessmentID=CommunityMart.dbo.CDLabReportFact.SourceAssessmentID
	LEFT JOIN CommunityMart.Dim.CommunityDisease
	ON CommunityMart.Dim.CommunityDisease.CommunityDiseaseID=CommunityMart.dbo.CDPreviousTestResultFact.CommunityDiseaseID
)
MERGE INTO CommunityMart.dbo.CDLabReportFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.SourceAssessmentID=src.SourceAssessmentID,
	dst.SourceReferralID=src.SourceReferralID,
	dst.ReferralPriorityID=src.ReferralPriorityID,
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.DischargeDispositionCodeID=src.DischargeDispositionCodeID,
	dst.DischargeDispositionID=src.DischargeDispositionID,
	dst.ReferralReasonID=src.ReferralReasonID,
	dst.ReferralTypeID=src.ReferralTypeID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.DischargeOutcomeID=src.DischargeOutcomeID,
	dst.ReasonEndingServiceCodeID=src.ReasonEndingServiceCodeID,
	dst.ReasonEndingServiceID=src.ReasonEndingServiceID,
	dst.ReferralSourceLookupID=src.ReferralSourceLookupID,
	dst.ReferralSourceID=src.ReferralSourceID,
	dst.AssessmentTypeID=src.AssessmentTypeID,
	dst.AssessmentReasonID=src.AssessmentReasonID,
	dst.SourceAssessmentID=src.SourceAssessmentID,
	dst.CommunityDiseaseID=src.CommunityDiseaseID,
	dst.PatientID=src.PatientID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='Update/Merge CommunityMart.dbo.CDLabReportFact (denormalize)', 
@pRuleDesc='', 
@pConditionSQL=NULL, 
@pActionID=4, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=2600, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='CommunityMart.dbo.CDLabReportFact', 
@pTargetAttributePhysicalName='many', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python for CommunityMart.dbo.CDLabReportFact', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR Update/Merge CommunityMart.dbo.CDLabReportFact (denormalize)



--#region BR Update/Merge CommunityMart.dbo.WaitlistDefinitionFact (denormalize)
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '54dd237e-7b82-11e6-b072-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		CommunityMart.dbo.WaitlistDefinitionFact.ETLAuditID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.WaitlistType.WaitlistTypeID
FROM CommunityMart.dbo.WaitlistDefinitionFact
LEFT JOIN CommunityMart.Dim.Provider
ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.dbo.WaitlistDefinitionFact.ProviderID
	LEFT JOIN CommunityMart.Dim.LevelOfCare
	ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
	LEFT JOIN CommunityMart.Dim.Facility
	ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
		LEFT JOIN CommunityMart.Dim.HSDA
		ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
LEFT JOIN CommunityMart.Dim.WaitlistType
ON CommunityMart.Dim.WaitlistType.WaitlistTypeID=CommunityMart.dbo.WaitlistDefinitionFact.WaitlistTypeID
)
MERGE INTO CommunityMart.dbo.WaitlistDefinitionFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.WaitlistTypeID=src.WaitlistTypeID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='Update/Merge CommunityMart.dbo.WaitlistDefinitionFact (denormalize)', 
@pRuleDesc='', 
@pConditionSQL=NULL, 
@pActionID=4, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=2700, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='CommunityMart.dbo.WaitlistDefinitionFact', 
@pTargetAttributePhysicalName='many', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python for CommunityMart.dbo.WaitlistDefinitionFact', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR Update/Merge CommunityMart.dbo.WaitlistDefinitionFact (denormalize)



--#region BR Update/Merge CommunityMart.dbo.HCRSAssessmentFact (denormalize)
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '54df6d7e-7b82-11e6-a1c8-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		CommunityMart.dbo.HCRSAssessmentFact.ETLAuditID
		,CommunityMart.dbo.ReferralFact.SourceReferralID
		,CommunityMart.Dim.ReferralPriority.ReferralPriorityID
		,CommunityMart.dbo.PersonFact.SourceSystemClientID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
		,CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID
		,CommunityMart.Dim.DischargeDisposition.DischargeDispositionID
		,CommunityMart.Dim.ReferralReason.ReferralReasonID
		,CommunityMart.Dim.ReferralType.ReferralTypeID
		,CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.CommunityProgram.CommunityProgramID
		,CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID
		,CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID
		,CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID
		,CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID
		,CommunityMart.Dim.ReferralSource.ReferralSourceID
		,CommunityMart.dbo.PersonFact.SourceSystemClientID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
		,CommunityMart.Dim.ReferralReason.ReferralReasonID
		,CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.CommunityProgram.CommunityProgramID
		,CommunityMart.dbo.PersonFact.PatientID
FROM CommunityMart.dbo.HCRSAssessmentFact
LEFT JOIN CommunityMart.dbo.ReferralFact
ON CommunityMart.dbo.ReferralFact.SourceReferralID=CommunityMart.dbo.HCRSAssessmentFact.SourceReferralID
	LEFT JOIN CommunityMart.Dim.ReferralPriority
	ON CommunityMart.Dim.ReferralPriority.ReferralPriorityID=CommunityMart.dbo.ReferralFact.ReferralPriorityID
	LEFT JOIN CommunityMart.dbo.PersonFact
	ON CommunityMart.dbo.PersonFact.SourceSystemClientID=CommunityMart.dbo.ReferralFact.SourceSystemClientID
		LEFT JOIN CommunityMart.Dim.DeathLocation
		ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
		LEFT JOIN CommunityMart.Dim.Ethnicity
		ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
		LEFT JOIN CommunityMart.Dim.Gender
		ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
		LEFT JOIN CommunityMart.Dim.EducationLevelLookup
		ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
			LEFT JOIN CommunityMart.Dim.EducationLevel
			ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
	LEFT JOIN CommunityMart.Dim.DischargeDispositionLookupCOM
	ON CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=CommunityMart.dbo.ReferralFact.DischargeDispositionCodeID
		LEFT JOIN CommunityMart.Dim.DischargeDisposition
		ON CommunityMart.Dim.DischargeDisposition.DischargeDispositionID=CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionID
	LEFT JOIN CommunityMart.Dim.ReferralReason
	ON CommunityMart.Dim.ReferralReason.ReferralReasonID=CommunityMart.dbo.ReferralFact.ReferralReasonID
	LEFT JOIN CommunityMart.Dim.ReferralType
	ON CommunityMart.Dim.ReferralType.ReferralTypeID=CommunityMart.dbo.ReferralFact.ReferralTypeID
	LEFT JOIN CommunityMart.Dim.LocalReportingOffice
	ON CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID=CommunityMart.dbo.ReferralFact.LocalReportingOfficeID
		LEFT JOIN CommunityMart.Dim.Provider
		ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.Dim.LocalReportingOffice.ProviderID
			LEFT JOIN CommunityMart.Dim.LevelOfCare
			ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
			LEFT JOIN CommunityMart.Dim.Facility
			ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
				LEFT JOIN CommunityMart.Dim.HSDA
				ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
		LEFT JOIN CommunityMart.Dim.CommunityProgram
		ON CommunityMart.Dim.CommunityProgram.CommunityProgramID=CommunityMart.Dim.LocalReportingOffice.CommunityProgramID
	LEFT JOIN CommunityMart.Dim.DischargeOutcome
	ON CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID=CommunityMart.dbo.ReferralFact.DischargeOutcomeID
	LEFT JOIN CommunityMart.Dim.ReasonEndingServiceLookup
	ON CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=CommunityMart.dbo.ReferralFact.ReasonEndingServiceCodeID
		LEFT JOIN CommunityMart.Dim.ReasonEndingService
		ON CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID=CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
	LEFT JOIN CommunityMart.Dim.ReferralSourceLookup
	ON CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID=CommunityMart.dbo.ReferralFact.ReferralSourceLookupID
		LEFT JOIN CommunityMart.Dim.ReferralSource
		ON CommunityMart.Dim.ReferralSource.ReferralSourceID=CommunityMart.Dim.ReferralSourceLookup.ReferralSourceID
LEFT JOIN CommunityMart.dbo.PersonFact
ON CommunityMart.dbo.PersonFact.SourceSystemClientID=CommunityMart.dbo.HCRSAssessmentFact.SourceSystemClientID
	LEFT JOIN CommunityMart.Dim.DeathLocation
	ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
	LEFT JOIN CommunityMart.Dim.Ethnicity
	ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
	LEFT JOIN CommunityMart.Dim.Gender
	ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
	LEFT JOIN CommunityMart.Dim.EducationLevelLookup
	ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
		LEFT JOIN CommunityMart.Dim.EducationLevel
		ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
LEFT JOIN CommunityMart.Dim.ReferralReason
ON CommunityMart.Dim.ReferralReason.ReferralReasonID=CommunityMart.dbo.HCRSAssessmentFact.ReferralReasonID
LEFT JOIN CommunityMart.Dim.LocalReportingOffice
ON CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID=CommunityMart.dbo.HCRSAssessmentFact.LocalReportingOfficeID
	LEFT JOIN CommunityMart.Dim.Provider
	ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.Dim.LocalReportingOffice.ProviderID
		LEFT JOIN CommunityMart.Dim.LevelOfCare
		ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
		LEFT JOIN CommunityMart.Dim.Facility
		ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
			LEFT JOIN CommunityMart.Dim.HSDA
			ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
	LEFT JOIN CommunityMart.Dim.CommunityProgram
	ON CommunityMart.Dim.CommunityProgram.CommunityProgramID=CommunityMart.Dim.LocalReportingOffice.CommunityProgramID
)
MERGE INTO CommunityMart.dbo.HCRSAssessmentFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.SourceReferralID=src.SourceReferralID,
	dst.ReferralPriorityID=src.ReferralPriorityID,
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.DischargeDispositionCodeID=src.DischargeDispositionCodeID,
	dst.DischargeDispositionID=src.DischargeDispositionID,
	dst.ReferralReasonID=src.ReferralReasonID,
	dst.ReferralTypeID=src.ReferralTypeID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.DischargeOutcomeID=src.DischargeOutcomeID,
	dst.ReasonEndingServiceCodeID=src.ReasonEndingServiceCodeID,
	dst.ReasonEndingServiceID=src.ReasonEndingServiceID,
	dst.ReferralSourceLookupID=src.ReferralSourceLookupID,
	dst.ReferralSourceID=src.ReferralSourceID,
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.ReferralReasonID=src.ReferralReasonID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.PatientID=src.PatientID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='Update/Merge CommunityMart.dbo.HCRSAssessmentFact (denormalize)', 
@pRuleDesc='', 
@pConditionSQL=NULL, 
@pActionID=4, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=2800, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='CommunityMart.dbo.HCRSAssessmentFact', 
@pTargetAttributePhysicalName='many', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python for CommunityMart.dbo.HCRSAssessmentFact', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR Update/Merge CommunityMart.dbo.HCRSAssessmentFact (denormalize)



--#region BR Update/Merge CommunityMart.dbo.CDPublicHealthMeasureFact (denormalize)
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '54e2059c-7b82-11e6-94c0-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		CommunityMart.dbo.CDPublicHealthMeasureFact.ETLAuditID
		,CommunityMart.dbo.AssessmentHeaderFact.SourceAssessmentID
		,CommunityMart.dbo.ReferralFact.SourceReferralID
		,CommunityMart.Dim.ReferralPriority.ReferralPriorityID
		,CommunityMart.dbo.PersonFact.SourceSystemClientID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
		,CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID
		,CommunityMart.Dim.DischargeDisposition.DischargeDispositionID
		,CommunityMart.Dim.ReferralReason.ReferralReasonID
		,CommunityMart.Dim.ReferralType.ReferralTypeID
		,CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.CommunityProgram.CommunityProgramID
		,CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID
		,CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID
		,CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID
		,CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID
		,CommunityMart.Dim.ReferralSource.ReferralSourceID
		,CommunityMart.Dim.AssessmentType.AssessmentTypeID
		,CommunityMart.Dim.AssessmentReason.AssessmentReasonID
		,CommunityMart.dbo.CDPreviousTestResultFact.SourceAssessmentID
		,CommunityMart.Dim.CommunityDisease.CommunityDiseaseID
		,CommunityMart.dbo.PersonFact.PatientID
FROM CommunityMart.dbo.CDPublicHealthMeasureFact
LEFT JOIN CommunityMart.dbo.AssessmentHeaderFact
ON CommunityMart.dbo.AssessmentHeaderFact.SourceAssessmentID=CommunityMart.dbo.CDPublicHealthMeasureFact.SourceAssessmentID
	LEFT JOIN CommunityMart.dbo.ReferralFact
	ON CommunityMart.dbo.ReferralFact.SourceReferralID=CommunityMart.dbo.AssessmentHeaderFact.SourceReferralID
		LEFT JOIN CommunityMart.Dim.ReferralPriority
		ON CommunityMart.Dim.ReferralPriority.ReferralPriorityID=CommunityMart.dbo.ReferralFact.ReferralPriorityID
		LEFT JOIN CommunityMart.dbo.PersonFact
		ON CommunityMart.dbo.PersonFact.SourceSystemClientID=CommunityMart.dbo.ReferralFact.SourceSystemClientID
			LEFT JOIN CommunityMart.Dim.DeathLocation
			ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
			LEFT JOIN CommunityMart.Dim.Ethnicity
			ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
			LEFT JOIN CommunityMart.Dim.Gender
			ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
			LEFT JOIN CommunityMart.Dim.EducationLevelLookup
			ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
				LEFT JOIN CommunityMart.Dim.EducationLevel
				ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
		LEFT JOIN CommunityMart.Dim.DischargeDispositionLookupCOM
		ON CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=CommunityMart.dbo.ReferralFact.DischargeDispositionCodeID
			LEFT JOIN CommunityMart.Dim.DischargeDisposition
			ON CommunityMart.Dim.DischargeDisposition.DischargeDispositionID=CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionID
		LEFT JOIN CommunityMart.Dim.ReferralReason
		ON CommunityMart.Dim.ReferralReason.ReferralReasonID=CommunityMart.dbo.ReferralFact.ReferralReasonID
		LEFT JOIN CommunityMart.Dim.ReferralType
		ON CommunityMart.Dim.ReferralType.ReferralTypeID=CommunityMart.dbo.ReferralFact.ReferralTypeID
		LEFT JOIN CommunityMart.Dim.LocalReportingOffice
		ON CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID=CommunityMart.dbo.ReferralFact.LocalReportingOfficeID
			LEFT JOIN CommunityMart.Dim.Provider
			ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.Dim.LocalReportingOffice.ProviderID
				LEFT JOIN CommunityMart.Dim.LevelOfCare
				ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
				LEFT JOIN CommunityMart.Dim.Facility
				ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
					LEFT JOIN CommunityMart.Dim.HSDA
					ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
			LEFT JOIN CommunityMart.Dim.CommunityProgram
			ON CommunityMart.Dim.CommunityProgram.CommunityProgramID=CommunityMart.Dim.LocalReportingOffice.CommunityProgramID
		LEFT JOIN CommunityMart.Dim.DischargeOutcome
		ON CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID=CommunityMart.dbo.ReferralFact.DischargeOutcomeID
		LEFT JOIN CommunityMart.Dim.ReasonEndingServiceLookup
		ON CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=CommunityMart.dbo.ReferralFact.ReasonEndingServiceCodeID
			LEFT JOIN CommunityMart.Dim.ReasonEndingService
			ON CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID=CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
		LEFT JOIN CommunityMart.Dim.ReferralSourceLookup
		ON CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID=CommunityMart.dbo.ReferralFact.ReferralSourceLookupID
			LEFT JOIN CommunityMart.Dim.ReferralSource
			ON CommunityMart.Dim.ReferralSource.ReferralSourceID=CommunityMart.Dim.ReferralSourceLookup.ReferralSourceID
	LEFT JOIN CommunityMart.Dim.AssessmentType
	ON CommunityMart.Dim.AssessmentType.AssessmentTypeID=CommunityMart.dbo.AssessmentHeaderFact.AssessmentTypeID
	LEFT JOIN CommunityMart.Dim.AssessmentReason
	ON CommunityMart.Dim.AssessmentReason.AssessmentReasonID=CommunityMart.dbo.AssessmentHeaderFact.AssessmentReasonID
LEFT JOIN CommunityMart.dbo.CDPreviousTestResultFact
ON CommunityMart.dbo.CDPreviousTestResultFact.SourceAssessmentID=CommunityMart.dbo.CDPublicHealthMeasureFact.SourceAssessmentID
	LEFT JOIN CommunityMart.Dim.CommunityDisease
	ON CommunityMart.Dim.CommunityDisease.CommunityDiseaseID=CommunityMart.dbo.CDPreviousTestResultFact.CommunityDiseaseID
)
MERGE INTO CommunityMart.dbo.CDPublicHealthMeasureFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.SourceAssessmentID=src.SourceAssessmentID,
	dst.SourceReferralID=src.SourceReferralID,
	dst.ReferralPriorityID=src.ReferralPriorityID,
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.DischargeDispositionCodeID=src.DischargeDispositionCodeID,
	dst.DischargeDispositionID=src.DischargeDispositionID,
	dst.ReferralReasonID=src.ReferralReasonID,
	dst.ReferralTypeID=src.ReferralTypeID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.DischargeOutcomeID=src.DischargeOutcomeID,
	dst.ReasonEndingServiceCodeID=src.ReasonEndingServiceCodeID,
	dst.ReasonEndingServiceID=src.ReasonEndingServiceID,
	dst.ReferralSourceLookupID=src.ReferralSourceLookupID,
	dst.ReferralSourceID=src.ReferralSourceID,
	dst.AssessmentTypeID=src.AssessmentTypeID,
	dst.AssessmentReasonID=src.AssessmentReasonID,
	dst.SourceAssessmentID=src.SourceAssessmentID,
	dst.CommunityDiseaseID=src.CommunityDiseaseID,
	dst.PatientID=src.PatientID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='Update/Merge CommunityMart.dbo.CDPublicHealthMeasureFact (denormalize)', 
@pRuleDesc='', 
@pConditionSQL=NULL, 
@pActionID=4, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=2900, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='CommunityMart.dbo.CDPublicHealthMeasureFact', 
@pTargetAttributePhysicalName='many', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python for CommunityMart.dbo.CDPublicHealthMeasureFact', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR Update/Merge CommunityMart.dbo.CDPublicHealthMeasureFact (denormalize)



--#region BR Update/Merge CommunityMart.dbo.PersonFact (denormalize)
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '54e4ebe2-7b82-11e6-9e76-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		CommunityMart.dbo.PersonFact.ETLAuditID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
FROM CommunityMart.dbo.PersonFact
LEFT JOIN CommunityMart.Dim.DeathLocation
ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
LEFT JOIN CommunityMart.Dim.Ethnicity
ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
LEFT JOIN CommunityMart.Dim.Gender
ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
LEFT JOIN CommunityMart.Dim.EducationLevelLookup
ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
	LEFT JOIN CommunityMart.Dim.EducationLevel
	ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
)
MERGE INTO CommunityMart.dbo.PersonFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='Update/Merge CommunityMart.dbo.PersonFact (denormalize)', 
@pRuleDesc='', 
@pConditionSQL=NULL, 
@pActionID=4, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=3000, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='CommunityMart.dbo.PersonFact', 
@pTargetAttributePhysicalName='many', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python for CommunityMart.dbo.PersonFact', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR Update/Merge CommunityMart.dbo.PersonFact (denormalize)



--#region BR Update/Merge CommunityMart.dbo.CurrentLocationFact (denormalize)
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '54e735de-7b82-11e6-a350-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		CommunityMart.dbo.CurrentLocationFact.ETLAuditID
		,CommunityMart.Dim.LocationType.LocationTypeID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.dbo.PersonFact.SourceSystemClientID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
		,CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.CommunityProgram.CommunityProgramID
		,CommunityMart.Dim.Province.ProvinceID
		,CommunityMart.Dim.LHA.LHAID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.PostalCode.PostalCodeID
		,CommunityMart.dbo.PersonFact.PatientID
FROM CommunityMart.dbo.CurrentLocationFact
LEFT JOIN CommunityMart.Dim.LocationType
ON CommunityMart.Dim.LocationType.LocationTypeID=CommunityMart.dbo.CurrentLocationFact.LocationTypeID
LEFT JOIN CommunityMart.Dim.Provider
ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.dbo.CurrentLocationFact.ProviderID
	LEFT JOIN CommunityMart.Dim.LevelOfCare
	ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
	LEFT JOIN CommunityMart.Dim.Facility
	ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
		LEFT JOIN CommunityMart.Dim.HSDA
		ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
LEFT JOIN CommunityMart.dbo.PersonFact
ON CommunityMart.dbo.PersonFact.SourceSystemClientID=CommunityMart.dbo.CurrentLocationFact.SourceSystemClientID
	LEFT JOIN CommunityMart.Dim.DeathLocation
	ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
	LEFT JOIN CommunityMart.Dim.Ethnicity
	ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
	LEFT JOIN CommunityMart.Dim.Gender
	ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
	LEFT JOIN CommunityMart.Dim.EducationLevelLookup
	ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
		LEFT JOIN CommunityMart.Dim.EducationLevel
		ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
LEFT JOIN CommunityMart.Dim.LocalReportingOffice
ON CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID=CommunityMart.dbo.CurrentLocationFact.LocalReportingOfficeID
	LEFT JOIN CommunityMart.Dim.Provider
	ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.Dim.LocalReportingOffice.ProviderID
		LEFT JOIN CommunityMart.Dim.LevelOfCare
		ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
		LEFT JOIN CommunityMart.Dim.Facility
		ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
			LEFT JOIN CommunityMart.Dim.HSDA
			ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
	LEFT JOIN CommunityMart.Dim.CommunityProgram
	ON CommunityMart.Dim.CommunityProgram.CommunityProgramID=CommunityMart.Dim.LocalReportingOffice.CommunityProgramID
LEFT JOIN CommunityMart.Dim.Province
ON CommunityMart.Dim.Province.ProvinceID=CommunityMart.dbo.CurrentLocationFact.ProvinceID
LEFT JOIN CommunityMart.Dim.LHA
ON CommunityMart.Dim.LHA.LHAID=CommunityMart.dbo.CurrentLocationFact.LHAID
	LEFT JOIN CommunityMart.Dim.HSDA
	ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.LHA.HSDAID
LEFT JOIN CommunityMart.Dim.PostalCode
ON CommunityMart.Dim.PostalCode.PostalCodeID=CommunityMart.dbo.CurrentLocationFact.PostalCodeID
)
MERGE INTO CommunityMart.dbo.CurrentLocationFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.LocationTypeID=src.LocationTypeID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.ProvinceID=src.ProvinceID,
	dst.LHAID=src.LHAID,
	dst.HSDAID=src.HSDAID,
	dst.PostalCodeID=src.PostalCodeID,
	dst.PatientID=src.PatientID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='Update/Merge CommunityMart.dbo.CurrentLocationFact (denormalize)', 
@pRuleDesc='', 
@pConditionSQL=NULL, 
@pActionID=4, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=3100, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='CommunityMart.dbo.CurrentLocationFact', 
@pTargetAttributePhysicalName='many', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python for CommunityMart.dbo.CurrentLocationFact', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR Update/Merge CommunityMart.dbo.CurrentLocationFact (denormalize)



--#region BR Update/Merge CommunityMart.dbo.AssessmentHeaderFact (denormalize)
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '54e9a6f0-7b82-11e6-a520-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		CommunityMart.dbo.AssessmentHeaderFact.ETLAuditID
		,CommunityMart.dbo.ReferralFact.SourceReferralID
		,CommunityMart.Dim.ReferralPriority.ReferralPriorityID
		,CommunityMart.dbo.PersonFact.SourceSystemClientID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
		,CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID
		,CommunityMart.Dim.DischargeDisposition.DischargeDispositionID
		,CommunityMart.Dim.ReferralReason.ReferralReasonID
		,CommunityMart.Dim.ReferralType.ReferralTypeID
		,CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.CommunityProgram.CommunityProgramID
		,CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID
		,CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID
		,CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID
		,CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID
		,CommunityMart.Dim.ReferralSource.ReferralSourceID
		,CommunityMart.Dim.AssessmentType.AssessmentTypeID
		,CommunityMart.Dim.AssessmentReason.AssessmentReasonID
		,CommunityMart.dbo.PersonFact.PatientID
FROM CommunityMart.dbo.AssessmentHeaderFact
LEFT JOIN CommunityMart.dbo.ReferralFact
ON CommunityMart.dbo.ReferralFact.SourceReferralID=CommunityMart.dbo.AssessmentHeaderFact.SourceReferralID
	LEFT JOIN CommunityMart.Dim.ReferralPriority
	ON CommunityMart.Dim.ReferralPriority.ReferralPriorityID=CommunityMart.dbo.ReferralFact.ReferralPriorityID
	LEFT JOIN CommunityMart.dbo.PersonFact
	ON CommunityMart.dbo.PersonFact.SourceSystemClientID=CommunityMart.dbo.ReferralFact.SourceSystemClientID
		LEFT JOIN CommunityMart.Dim.DeathLocation
		ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
		LEFT JOIN CommunityMart.Dim.Ethnicity
		ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
		LEFT JOIN CommunityMart.Dim.Gender
		ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
		LEFT JOIN CommunityMart.Dim.EducationLevelLookup
		ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
			LEFT JOIN CommunityMart.Dim.EducationLevel
			ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
	LEFT JOIN CommunityMart.Dim.DischargeDispositionLookupCOM
	ON CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=CommunityMart.dbo.ReferralFact.DischargeDispositionCodeID
		LEFT JOIN CommunityMart.Dim.DischargeDisposition
		ON CommunityMart.Dim.DischargeDisposition.DischargeDispositionID=CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionID
	LEFT JOIN CommunityMart.Dim.ReferralReason
	ON CommunityMart.Dim.ReferralReason.ReferralReasonID=CommunityMart.dbo.ReferralFact.ReferralReasonID
	LEFT JOIN CommunityMart.Dim.ReferralType
	ON CommunityMart.Dim.ReferralType.ReferralTypeID=CommunityMart.dbo.ReferralFact.ReferralTypeID
	LEFT JOIN CommunityMart.Dim.LocalReportingOffice
	ON CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID=CommunityMart.dbo.ReferralFact.LocalReportingOfficeID
		LEFT JOIN CommunityMart.Dim.Provider
		ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.Dim.LocalReportingOffice.ProviderID
			LEFT JOIN CommunityMart.Dim.LevelOfCare
			ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
			LEFT JOIN CommunityMart.Dim.Facility
			ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
				LEFT JOIN CommunityMart.Dim.HSDA
				ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
		LEFT JOIN CommunityMart.Dim.CommunityProgram
		ON CommunityMart.Dim.CommunityProgram.CommunityProgramID=CommunityMart.Dim.LocalReportingOffice.CommunityProgramID
	LEFT JOIN CommunityMart.Dim.DischargeOutcome
	ON CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID=CommunityMart.dbo.ReferralFact.DischargeOutcomeID
	LEFT JOIN CommunityMart.Dim.ReasonEndingServiceLookup
	ON CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=CommunityMart.dbo.ReferralFact.ReasonEndingServiceCodeID
		LEFT JOIN CommunityMart.Dim.ReasonEndingService
		ON CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID=CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
	LEFT JOIN CommunityMart.Dim.ReferralSourceLookup
	ON CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID=CommunityMart.dbo.ReferralFact.ReferralSourceLookupID
		LEFT JOIN CommunityMart.Dim.ReferralSource
		ON CommunityMart.Dim.ReferralSource.ReferralSourceID=CommunityMart.Dim.ReferralSourceLookup.ReferralSourceID
LEFT JOIN CommunityMart.Dim.AssessmentType
ON CommunityMart.Dim.AssessmentType.AssessmentTypeID=CommunityMart.dbo.AssessmentHeaderFact.AssessmentTypeID
LEFT JOIN CommunityMart.Dim.AssessmentReason
ON CommunityMart.Dim.AssessmentReason.AssessmentReasonID=CommunityMart.dbo.AssessmentHeaderFact.AssessmentReasonID
)
MERGE INTO CommunityMart.dbo.AssessmentHeaderFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.SourceReferralID=src.SourceReferralID,
	dst.ReferralPriorityID=src.ReferralPriorityID,
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.DischargeDispositionCodeID=src.DischargeDispositionCodeID,
	dst.DischargeDispositionID=src.DischargeDispositionID,
	dst.ReferralReasonID=src.ReferralReasonID,
	dst.ReferralTypeID=src.ReferralTypeID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.DischargeOutcomeID=src.DischargeOutcomeID,
	dst.ReasonEndingServiceCodeID=src.ReasonEndingServiceCodeID,
	dst.ReasonEndingServiceID=src.ReasonEndingServiceID,
	dst.ReferralSourceLookupID=src.ReferralSourceLookupID,
	dst.ReferralSourceID=src.ReferralSourceID,
	dst.AssessmentTypeID=src.AssessmentTypeID,
	dst.AssessmentReasonID=src.AssessmentReasonID,
	dst.PatientID=src.PatientID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='Update/Merge CommunityMart.dbo.AssessmentHeaderFact (denormalize)', 
@pRuleDesc='', 
@pConditionSQL=NULL, 
@pActionID=4, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=3200, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='CommunityMart.dbo.AssessmentHeaderFact', 
@pTargetAttributePhysicalName='many', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python for CommunityMart.dbo.AssessmentHeaderFact', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR Update/Merge CommunityMart.dbo.AssessmentHeaderFact (denormalize)



--#region BR Update/Merge CommunityMart.dbo.InvolvedProfessionFact (denormalize)
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '54ec6624-7b82-11e6-8bcf-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		CommunityMart.dbo.InvolvedProfessionFact.ETLAuditID
		,CommunityMart.Dim.ServiceProviderCategoryLookup.ServiceProviderCategoryCodeID
		,CommunityMart.dbo.ReferralFact.SourceReferralID
		,CommunityMart.Dim.ReferralPriority.ReferralPriorityID
		,CommunityMart.dbo.PersonFact.SourceSystemClientID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
		,CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID
		,CommunityMart.Dim.DischargeDisposition.DischargeDispositionID
		,CommunityMart.Dim.ReferralReason.ReferralReasonID
		,CommunityMart.Dim.ReferralType.ReferralTypeID
		,CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.CommunityProgram.CommunityProgramID
		,CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID
		,CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID
		,CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID
		,CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID
		,CommunityMart.Dim.ReferralSource.ReferralSourceID
		,CommunityMart.dbo.PersonFact.PatientID
FROM CommunityMart.dbo.InvolvedProfessionFact
LEFT JOIN CommunityMart.Dim.ServiceProviderCategoryLookup
ON CommunityMart.Dim.ServiceProviderCategoryLookup.ServiceProviderCategoryCodeID=CommunityMart.dbo.InvolvedProfessionFact.ServiceProviderCategoryCodeID
LEFT JOIN CommunityMart.dbo.ReferralFact
ON CommunityMart.dbo.ReferralFact.SourceReferralID=CommunityMart.dbo.InvolvedProfessionFact.SourceReferralID
	LEFT JOIN CommunityMart.Dim.ReferralPriority
	ON CommunityMart.Dim.ReferralPriority.ReferralPriorityID=CommunityMart.dbo.ReferralFact.ReferralPriorityID
	LEFT JOIN CommunityMart.dbo.PersonFact
	ON CommunityMart.dbo.PersonFact.SourceSystemClientID=CommunityMart.dbo.ReferralFact.SourceSystemClientID
		LEFT JOIN CommunityMart.Dim.DeathLocation
		ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
		LEFT JOIN CommunityMart.Dim.Ethnicity
		ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
		LEFT JOIN CommunityMart.Dim.Gender
		ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
		LEFT JOIN CommunityMart.Dim.EducationLevelLookup
		ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
			LEFT JOIN CommunityMart.Dim.EducationLevel
			ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
	LEFT JOIN CommunityMart.Dim.DischargeDispositionLookupCOM
	ON CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=CommunityMart.dbo.ReferralFact.DischargeDispositionCodeID
		LEFT JOIN CommunityMart.Dim.DischargeDisposition
		ON CommunityMart.Dim.DischargeDisposition.DischargeDispositionID=CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionID
	LEFT JOIN CommunityMart.Dim.ReferralReason
	ON CommunityMart.Dim.ReferralReason.ReferralReasonID=CommunityMart.dbo.ReferralFact.ReferralReasonID
	LEFT JOIN CommunityMart.Dim.ReferralType
	ON CommunityMart.Dim.ReferralType.ReferralTypeID=CommunityMart.dbo.ReferralFact.ReferralTypeID
	LEFT JOIN CommunityMart.Dim.LocalReportingOffice
	ON CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID=CommunityMart.dbo.ReferralFact.LocalReportingOfficeID
		LEFT JOIN CommunityMart.Dim.Provider
		ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.Dim.LocalReportingOffice.ProviderID
			LEFT JOIN CommunityMart.Dim.LevelOfCare
			ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
			LEFT JOIN CommunityMart.Dim.Facility
			ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
				LEFT JOIN CommunityMart.Dim.HSDA
				ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
		LEFT JOIN CommunityMart.Dim.CommunityProgram
		ON CommunityMart.Dim.CommunityProgram.CommunityProgramID=CommunityMart.Dim.LocalReportingOffice.CommunityProgramID
	LEFT JOIN CommunityMart.Dim.DischargeOutcome
	ON CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID=CommunityMart.dbo.ReferralFact.DischargeOutcomeID
	LEFT JOIN CommunityMart.Dim.ReasonEndingServiceLookup
	ON CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=CommunityMart.dbo.ReferralFact.ReasonEndingServiceCodeID
		LEFT JOIN CommunityMart.Dim.ReasonEndingService
		ON CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID=CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
	LEFT JOIN CommunityMart.Dim.ReferralSourceLookup
	ON CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID=CommunityMart.dbo.ReferralFact.ReferralSourceLookupID
		LEFT JOIN CommunityMart.Dim.ReferralSource
		ON CommunityMart.Dim.ReferralSource.ReferralSourceID=CommunityMart.Dim.ReferralSourceLookup.ReferralSourceID
)
MERGE INTO CommunityMart.dbo.InvolvedProfessionFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.ServiceProviderCategoryCodeID=src.ServiceProviderCategoryCodeID,
	dst.SourceReferralID=src.SourceReferralID,
	dst.ReferralPriorityID=src.ReferralPriorityID,
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.DischargeDispositionCodeID=src.DischargeDispositionCodeID,
	dst.DischargeDispositionID=src.DischargeDispositionID,
	dst.ReferralReasonID=src.ReferralReasonID,
	dst.ReferralTypeID=src.ReferralTypeID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.DischargeOutcomeID=src.DischargeOutcomeID,
	dst.ReasonEndingServiceCodeID=src.ReasonEndingServiceCodeID,
	dst.ReasonEndingServiceID=src.ReasonEndingServiceID,
	dst.ReferralSourceLookupID=src.ReferralSourceLookupID,
	dst.ReferralSourceID=src.ReferralSourceID,
	dst.PatientID=src.PatientID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='Update/Merge CommunityMart.dbo.InvolvedProfessionFact (denormalize)', 
@pRuleDesc='', 
@pConditionSQL=NULL, 
@pActionID=4, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=3300, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='CommunityMart.dbo.InvolvedProfessionFact', 
@pTargetAttributePhysicalName='many', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python for CommunityMart.dbo.InvolvedProfessionFact', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR Update/Merge CommunityMart.dbo.InvolvedProfessionFact (denormalize)



--#region BR Update/Merge CommunityMart.dbo.ScreeningResultFact (denormalize)
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '54ef4c64-7b82-11e6-834a-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		CommunityMart.dbo.ScreeningResultFact.ETLAuditID
		,CommunityMart.dbo.PersonFact.SourceSystemClientID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
		,CommunityMart.Dim.ScreeningEvent.ScreeningEventID
		,CommunityMart.dbo.ReferralFact.SourceReferralID
		,CommunityMart.Dim.ReferralPriority.ReferralPriorityID
		,CommunityMart.dbo.PersonFact.SourceSystemClientID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
		,CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID
		,CommunityMart.Dim.DischargeDisposition.DischargeDispositionID
		,CommunityMart.Dim.ReferralReason.ReferralReasonID
		,CommunityMart.Dim.ReferralType.ReferralTypeID
		,CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.CommunityProgram.CommunityProgramID
		,CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID
		,CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID
		,CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID
		,CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID
		,CommunityMart.Dim.ReferralSource.ReferralSourceID
		,CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.CommunityProgram.CommunityProgramID
		,CommunityMart.Dim.ScreeningEventResult.ScreeningEventResultID
		,CommunityMart.Dim.CommunityServiceLocation.CommunityServiceLocationID
		,CommunityMart.dbo.PersonFact.PatientID
FROM CommunityMart.dbo.ScreeningResultFact
LEFT JOIN CommunityMart.dbo.PersonFact
ON CommunityMart.dbo.PersonFact.SourceSystemClientID=CommunityMart.dbo.ScreeningResultFact.SourceSystemClientID
	LEFT JOIN CommunityMart.Dim.DeathLocation
	ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
	LEFT JOIN CommunityMart.Dim.Ethnicity
	ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
	LEFT JOIN CommunityMart.Dim.Gender
	ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
	LEFT JOIN CommunityMart.Dim.EducationLevelLookup
	ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
		LEFT JOIN CommunityMart.Dim.EducationLevel
		ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
LEFT JOIN CommunityMart.Dim.ScreeningEvent
ON CommunityMart.Dim.ScreeningEvent.ScreeningEventID=CommunityMart.dbo.ScreeningResultFact.ScreeningEventID
LEFT JOIN CommunityMart.dbo.ReferralFact
ON CommunityMart.dbo.ReferralFact.SourceReferralID=CommunityMart.dbo.ScreeningResultFact.SourceReferralID
	LEFT JOIN CommunityMart.Dim.ReferralPriority
	ON CommunityMart.Dim.ReferralPriority.ReferralPriorityID=CommunityMart.dbo.ReferralFact.ReferralPriorityID
	LEFT JOIN CommunityMart.dbo.PersonFact
	ON CommunityMart.dbo.PersonFact.SourceSystemClientID=CommunityMart.dbo.ReferralFact.SourceSystemClientID
		LEFT JOIN CommunityMart.Dim.DeathLocation
		ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
		LEFT JOIN CommunityMart.Dim.Ethnicity
		ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
		LEFT JOIN CommunityMart.Dim.Gender
		ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
		LEFT JOIN CommunityMart.Dim.EducationLevelLookup
		ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
			LEFT JOIN CommunityMart.Dim.EducationLevel
			ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
	LEFT JOIN CommunityMart.Dim.DischargeDispositionLookupCOM
	ON CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=CommunityMart.dbo.ReferralFact.DischargeDispositionCodeID
		LEFT JOIN CommunityMart.Dim.DischargeDisposition
		ON CommunityMart.Dim.DischargeDisposition.DischargeDispositionID=CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionID
	LEFT JOIN CommunityMart.Dim.ReferralReason
	ON CommunityMart.Dim.ReferralReason.ReferralReasonID=CommunityMart.dbo.ReferralFact.ReferralReasonID
	LEFT JOIN CommunityMart.Dim.ReferralType
	ON CommunityMart.Dim.ReferralType.ReferralTypeID=CommunityMart.dbo.ReferralFact.ReferralTypeID
	LEFT JOIN CommunityMart.Dim.LocalReportingOffice
	ON CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID=CommunityMart.dbo.ReferralFact.LocalReportingOfficeID
		LEFT JOIN CommunityMart.Dim.Provider
		ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.Dim.LocalReportingOffice.ProviderID
			LEFT JOIN CommunityMart.Dim.LevelOfCare
			ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
			LEFT JOIN CommunityMart.Dim.Facility
			ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
				LEFT JOIN CommunityMart.Dim.HSDA
				ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
		LEFT JOIN CommunityMart.Dim.CommunityProgram
		ON CommunityMart.Dim.CommunityProgram.CommunityProgramID=CommunityMart.Dim.LocalReportingOffice.CommunityProgramID
	LEFT JOIN CommunityMart.Dim.DischargeOutcome
	ON CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID=CommunityMart.dbo.ReferralFact.DischargeOutcomeID
	LEFT JOIN CommunityMart.Dim.ReasonEndingServiceLookup
	ON CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=CommunityMart.dbo.ReferralFact.ReasonEndingServiceCodeID
		LEFT JOIN CommunityMart.Dim.ReasonEndingService
		ON CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID=CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
	LEFT JOIN CommunityMart.Dim.ReferralSourceLookup
	ON CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID=CommunityMart.dbo.ReferralFact.ReferralSourceLookupID
		LEFT JOIN CommunityMart.Dim.ReferralSource
		ON CommunityMart.Dim.ReferralSource.ReferralSourceID=CommunityMart.Dim.ReferralSourceLookup.ReferralSourceID
LEFT JOIN CommunityMart.Dim.LocalReportingOffice
ON CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID=CommunityMart.dbo.ScreeningResultFact.LocalReportingOfficeID
	LEFT JOIN CommunityMart.Dim.Provider
	ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.Dim.LocalReportingOffice.ProviderID
		LEFT JOIN CommunityMart.Dim.LevelOfCare
		ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
		LEFT JOIN CommunityMart.Dim.Facility
		ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
			LEFT JOIN CommunityMart.Dim.HSDA
			ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
	LEFT JOIN CommunityMart.Dim.CommunityProgram
	ON CommunityMart.Dim.CommunityProgram.CommunityProgramID=CommunityMart.Dim.LocalReportingOffice.CommunityProgramID
LEFT JOIN CommunityMart.Dim.ScreeningEventResult
ON CommunityMart.Dim.ScreeningEventResult.ScreeningEventResultID=CommunityMart.dbo.ScreeningResultFact.ScreeningEventResultID
LEFT JOIN CommunityMart.Dim.CommunityServiceLocation
ON CommunityMart.Dim.CommunityServiceLocation.CommunityServiceLocationID=CommunityMart.dbo.ScreeningResultFact.CommunityServiceLocationID
)
MERGE INTO CommunityMart.dbo.ScreeningResultFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.ScreeningEventID=src.ScreeningEventID,
	dst.SourceReferralID=src.SourceReferralID,
	dst.ReferralPriorityID=src.ReferralPriorityID,
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.DischargeDispositionCodeID=src.DischargeDispositionCodeID,
	dst.DischargeDispositionID=src.DischargeDispositionID,
	dst.ReferralReasonID=src.ReferralReasonID,
	dst.ReferralTypeID=src.ReferralTypeID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.DischargeOutcomeID=src.DischargeOutcomeID,
	dst.ReasonEndingServiceCodeID=src.ReasonEndingServiceCodeID,
	dst.ReasonEndingServiceID=src.ReasonEndingServiceID,
	dst.ReferralSourceLookupID=src.ReferralSourceLookupID,
	dst.ReferralSourceID=src.ReferralSourceID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.ScreeningEventResultID=src.ScreeningEventResultID,
	dst.CommunityServiceLocationID=src.CommunityServiceLocationID,
	dst.PatientID=src.PatientID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='Update/Merge CommunityMart.dbo.ScreeningResultFact (denormalize)', 
@pRuleDesc='', 
@pConditionSQL=NULL, 
@pActionID=4, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=3400, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='CommunityMart.dbo.ScreeningResultFact', 
@pTargetAttributePhysicalName='many', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python for CommunityMart.dbo.ScreeningResultFact', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR Update/Merge CommunityMart.dbo.ScreeningResultFact (denormalize)



--#region BR Update/Merge CommunityMart.dbo.WaitlistProviderOfferFact (denormalize)
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '54f20b98-7b82-11e6-9815-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		CommunityMart.dbo.WaitlistProviderOfferFact.ETLAuditID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.dbo.WaitlistDefinitionFact.SourceWaitlistDefinitionID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.WaitlistType.WaitlistTypeID
		,CommunityMart.Dim.WaitlistReasonOfferRemoved.WaitlistReasonOfferRemovedID
		,CommunityMart.Dim.WaitlistProviderOfferStatus.WaitlistProviderOfferStatusID
FROM CommunityMart.dbo.WaitlistProviderOfferFact
LEFT JOIN CommunityMart.Dim.Provider
ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.dbo.WaitlistProviderOfferFact.ProviderID
	LEFT JOIN CommunityMart.Dim.LevelOfCare
	ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
	LEFT JOIN CommunityMart.Dim.Facility
	ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
		LEFT JOIN CommunityMart.Dim.HSDA
		ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
LEFT JOIN CommunityMart.dbo.WaitlistDefinitionFact
ON CommunityMart.dbo.WaitlistDefinitionFact.SourceWaitlistDefinitionID=CommunityMart.dbo.WaitlistProviderOfferFact.SourceWaitlistDefinitionID
	LEFT JOIN CommunityMart.Dim.Provider
	ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.dbo.WaitlistDefinitionFact.ProviderID
		LEFT JOIN CommunityMart.Dim.LevelOfCare
		ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
		LEFT JOIN CommunityMart.Dim.Facility
		ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
			LEFT JOIN CommunityMart.Dim.HSDA
			ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
	LEFT JOIN CommunityMart.Dim.WaitlistType
	ON CommunityMart.Dim.WaitlistType.WaitlistTypeID=CommunityMart.dbo.WaitlistDefinitionFact.WaitlistTypeID
LEFT JOIN CommunityMart.Dim.WaitlistReasonOfferRemoved
ON CommunityMart.Dim.WaitlistReasonOfferRemoved.WaitlistReasonOfferRemovedID=CommunityMart.dbo.WaitlistProviderOfferFact.WaitlistReasonOfferRemovedID
LEFT JOIN CommunityMart.Dim.WaitlistProviderOfferStatus
ON CommunityMart.Dim.WaitlistProviderOfferStatus.WaitlistProviderOfferStatusID=CommunityMart.dbo.WaitlistProviderOfferFact.WaitlistProviderOfferStatusID
)
MERGE INTO CommunityMart.dbo.WaitlistProviderOfferFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.SourceWaitlistDefinitionID=src.SourceWaitlistDefinitionID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.WaitlistTypeID=src.WaitlistTypeID,
	dst.WaitlistReasonOfferRemovedID=src.WaitlistReasonOfferRemovedID,
	dst.WaitlistProviderOfferStatusID=src.WaitlistProviderOfferStatusID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='Update/Merge CommunityMart.dbo.WaitlistProviderOfferFact (denormalize)', 
@pRuleDesc='', 
@pConditionSQL=NULL, 
@pActionID=4, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=3500, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='CommunityMart.dbo.WaitlistProviderOfferFact', 
@pTargetAttributePhysicalName='many', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python for CommunityMart.dbo.WaitlistProviderOfferFact', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR Update/Merge CommunityMart.dbo.WaitlistProviderOfferFact (denormalize)



--#region BR Update/Merge CommunityMart.dbo.HoNOSFact (denormalize)
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '54f40776-7b82-11e6-aa1c-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		CommunityMart.dbo.HoNOSFact.ETLAuditID
		,CommunityMart.dbo.AssessmentHeaderFact.SourceAssessmentID
		,CommunityMart.dbo.ReferralFact.SourceReferralID
		,CommunityMart.Dim.ReferralPriority.ReferralPriorityID
		,CommunityMart.dbo.PersonFact.SourceSystemClientID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
		,CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID
		,CommunityMart.Dim.DischargeDisposition.DischargeDispositionID
		,CommunityMart.Dim.ReferralReason.ReferralReasonID
		,CommunityMart.Dim.ReferralType.ReferralTypeID
		,CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.CommunityProgram.CommunityProgramID
		,CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID
		,CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID
		,CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID
		,CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID
		,CommunityMart.Dim.ReferralSource.ReferralSourceID
		,CommunityMart.Dim.AssessmentType.AssessmentTypeID
		,CommunityMart.Dim.AssessmentReason.AssessmentReasonID
		,CommunityMart.dbo.PersonFact.PatientID
FROM CommunityMart.dbo.HoNOSFact
LEFT JOIN CommunityMart.dbo.AssessmentHeaderFact
ON CommunityMart.dbo.AssessmentHeaderFact.SourceAssessmentID=CommunityMart.dbo.HoNOSFact.SourceAssessmentID
	LEFT JOIN CommunityMart.dbo.ReferralFact
	ON CommunityMart.dbo.ReferralFact.SourceReferralID=CommunityMart.dbo.AssessmentHeaderFact.SourceReferralID
		LEFT JOIN CommunityMart.Dim.ReferralPriority
		ON CommunityMart.Dim.ReferralPriority.ReferralPriorityID=CommunityMart.dbo.ReferralFact.ReferralPriorityID
		LEFT JOIN CommunityMart.dbo.PersonFact
		ON CommunityMart.dbo.PersonFact.SourceSystemClientID=CommunityMart.dbo.ReferralFact.SourceSystemClientID
			LEFT JOIN CommunityMart.Dim.DeathLocation
			ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
			LEFT JOIN CommunityMart.Dim.Ethnicity
			ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
			LEFT JOIN CommunityMart.Dim.Gender
			ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
			LEFT JOIN CommunityMart.Dim.EducationLevelLookup
			ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
				LEFT JOIN CommunityMart.Dim.EducationLevel
				ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
		LEFT JOIN CommunityMart.Dim.DischargeDispositionLookupCOM
		ON CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=CommunityMart.dbo.ReferralFact.DischargeDispositionCodeID
			LEFT JOIN CommunityMart.Dim.DischargeDisposition
			ON CommunityMart.Dim.DischargeDisposition.DischargeDispositionID=CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionID
		LEFT JOIN CommunityMart.Dim.ReferralReason
		ON CommunityMart.Dim.ReferralReason.ReferralReasonID=CommunityMart.dbo.ReferralFact.ReferralReasonID
		LEFT JOIN CommunityMart.Dim.ReferralType
		ON CommunityMart.Dim.ReferralType.ReferralTypeID=CommunityMart.dbo.ReferralFact.ReferralTypeID
		LEFT JOIN CommunityMart.Dim.LocalReportingOffice
		ON CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID=CommunityMart.dbo.ReferralFact.LocalReportingOfficeID
			LEFT JOIN CommunityMart.Dim.Provider
			ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.Dim.LocalReportingOffice.ProviderID
				LEFT JOIN CommunityMart.Dim.LevelOfCare
				ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
				LEFT JOIN CommunityMart.Dim.Facility
				ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
					LEFT JOIN CommunityMart.Dim.HSDA
					ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
			LEFT JOIN CommunityMart.Dim.CommunityProgram
			ON CommunityMart.Dim.CommunityProgram.CommunityProgramID=CommunityMart.Dim.LocalReportingOffice.CommunityProgramID
		LEFT JOIN CommunityMart.Dim.DischargeOutcome
		ON CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID=CommunityMart.dbo.ReferralFact.DischargeOutcomeID
		LEFT JOIN CommunityMart.Dim.ReasonEndingServiceLookup
		ON CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=CommunityMart.dbo.ReferralFact.ReasonEndingServiceCodeID
			LEFT JOIN CommunityMart.Dim.ReasonEndingService
			ON CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID=CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
		LEFT JOIN CommunityMart.Dim.ReferralSourceLookup
		ON CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID=CommunityMart.dbo.ReferralFact.ReferralSourceLookupID
			LEFT JOIN CommunityMart.Dim.ReferralSource
			ON CommunityMart.Dim.ReferralSource.ReferralSourceID=CommunityMart.Dim.ReferralSourceLookup.ReferralSourceID
	LEFT JOIN CommunityMart.Dim.AssessmentType
	ON CommunityMart.Dim.AssessmentType.AssessmentTypeID=CommunityMart.dbo.AssessmentHeaderFact.AssessmentTypeID
	LEFT JOIN CommunityMart.Dim.AssessmentReason
	ON CommunityMart.Dim.AssessmentReason.AssessmentReasonID=CommunityMart.dbo.AssessmentHeaderFact.AssessmentReasonID
)
MERGE INTO CommunityMart.dbo.HoNOSFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.SourceAssessmentID=src.SourceAssessmentID,
	dst.SourceReferralID=src.SourceReferralID,
	dst.ReferralPriorityID=src.ReferralPriorityID,
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.DischargeDispositionCodeID=src.DischargeDispositionCodeID,
	dst.DischargeDispositionID=src.DischargeDispositionID,
	dst.ReferralReasonID=src.ReferralReasonID,
	dst.ReferralTypeID=src.ReferralTypeID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.DischargeOutcomeID=src.DischargeOutcomeID,
	dst.ReasonEndingServiceCodeID=src.ReasonEndingServiceCodeID,
	dst.ReasonEndingServiceID=src.ReasonEndingServiceID,
	dst.ReferralSourceLookupID=src.ReferralSourceLookupID,
	dst.ReferralSourceID=src.ReferralSourceID,
	dst.AssessmentTypeID=src.AssessmentTypeID,
	dst.AssessmentReasonID=src.AssessmentReasonID,
	dst.PatientID=src.PatientID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='Update/Merge CommunityMart.dbo.HoNOSFact (denormalize)', 
@pRuleDesc='', 
@pConditionSQL=NULL, 
@pActionID=4, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=3600, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='CommunityMart.dbo.HoNOSFact', 
@pTargetAttributePhysicalName='many', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python for CommunityMart.dbo.HoNOSFact', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR Update/Merge CommunityMart.dbo.HoNOSFact (denormalize)



--#region BR Update/Merge CommunityMart.dbo.ImmunizationAlertFact (denormalize)
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '54f6edb8-7b82-11e6-840f-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		CommunityMart.dbo.ImmunizationAlertFact.ETLAuditID
		,CommunityMart.dbo.PersonFact.SourceSystemClientID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
		,CommunityMart.Dim.Antigen.AntigenID
		,CommunityMart.Dim.ImmAlert.ImmAlertID
		,CommunityMart.Dim.ImmCategory.ImmCategoryID
		,CommunityMart.dbo.PersonFact.PatientID
FROM CommunityMart.dbo.ImmunizationAlertFact
LEFT JOIN CommunityMart.dbo.PersonFact
ON CommunityMart.dbo.PersonFact.SourceSystemClientID=CommunityMart.dbo.ImmunizationAlertFact.SourceSystemClientID
	LEFT JOIN CommunityMart.Dim.DeathLocation
	ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
	LEFT JOIN CommunityMart.Dim.Ethnicity
	ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
	LEFT JOIN CommunityMart.Dim.Gender
	ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
	LEFT JOIN CommunityMart.Dim.EducationLevelLookup
	ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
		LEFT JOIN CommunityMart.Dim.EducationLevel
		ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
LEFT JOIN CommunityMart.Dim.Antigen
ON CommunityMart.Dim.Antigen.AntigenID=CommunityMart.dbo.ImmunizationAlertFact.AntigenID
LEFT JOIN CommunityMart.Dim.ImmAlert
ON CommunityMart.Dim.ImmAlert.ImmAlertID=CommunityMart.dbo.ImmunizationAlertFact.ImmAlertID
LEFT JOIN CommunityMart.Dim.ImmCategory
ON CommunityMart.Dim.ImmCategory.ImmCategoryID=CommunityMart.dbo.ImmunizationAlertFact.ImmCategoryID
)
MERGE INTO CommunityMart.dbo.ImmunizationAlertFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.AntigenID=src.AntigenID,
	dst.ImmAlertID=src.ImmAlertID,
	dst.ImmCategoryID=src.ImmCategoryID,
	dst.PatientID=src.PatientID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='Update/Merge CommunityMart.dbo.ImmunizationAlertFact (denormalize)', 
@pRuleDesc='', 
@pConditionSQL=NULL, 
@pActionID=4, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=3700, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='CommunityMart.dbo.ImmunizationAlertFact', 
@pTargetAttributePhysicalName='many', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python for CommunityMart.dbo.ImmunizationAlertFact', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR Update/Merge CommunityMart.dbo.ImmunizationAlertFact (denormalize)



--#region BR Update/Merge CommunityMart.dbo.SubstanceUseFact (denormalize)
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '54f985da-7b82-11e6-a857-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		CommunityMart.dbo.SubstanceUseFact.ETLAuditID
		,CommunityMart.Dim.SubstanceUseLookup.SubstanceUseCodeID
		,CommunityMart.dbo.AssessmentHeaderFact.SourceAssessmentID
		,CommunityMart.dbo.ReferralFact.SourceReferralID
		,CommunityMart.Dim.ReferralPriority.ReferralPriorityID
		,CommunityMart.dbo.PersonFact.SourceSystemClientID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
		,CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID
		,CommunityMart.Dim.DischargeDisposition.DischargeDispositionID
		,CommunityMart.Dim.ReferralReason.ReferralReasonID
		,CommunityMart.Dim.ReferralType.ReferralTypeID
		,CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.CommunityProgram.CommunityProgramID
		,CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID
		,CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID
		,CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID
		,CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID
		,CommunityMart.Dim.ReferralSource.ReferralSourceID
		,CommunityMart.Dim.AssessmentType.AssessmentTypeID
		,CommunityMart.Dim.AssessmentReason.AssessmentReasonID
		,CommunityMart.Dim.MethodOfSubstanceIntake.MethodOfSubstanceIntakeID
		,CommunityMart.dbo.PersonFact.PatientID
FROM CommunityMart.dbo.SubstanceUseFact
LEFT JOIN CommunityMart.Dim.SubstanceUseLookup
ON CommunityMart.Dim.SubstanceUseLookup.SubstanceUseCodeID=CommunityMart.dbo.SubstanceUseFact.SubstanceUseCodeID
LEFT JOIN CommunityMart.dbo.AssessmentHeaderFact
ON CommunityMart.dbo.AssessmentHeaderFact.SourceAssessmentID=CommunityMart.dbo.SubstanceUseFact.SourceAssessmentID
	LEFT JOIN CommunityMart.dbo.ReferralFact
	ON CommunityMart.dbo.ReferralFact.SourceReferralID=CommunityMart.dbo.AssessmentHeaderFact.SourceReferralID
		LEFT JOIN CommunityMart.Dim.ReferralPriority
		ON CommunityMart.Dim.ReferralPriority.ReferralPriorityID=CommunityMart.dbo.ReferralFact.ReferralPriorityID
		LEFT JOIN CommunityMart.dbo.PersonFact
		ON CommunityMart.dbo.PersonFact.SourceSystemClientID=CommunityMart.dbo.ReferralFact.SourceSystemClientID
			LEFT JOIN CommunityMart.Dim.DeathLocation
			ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
			LEFT JOIN CommunityMart.Dim.Ethnicity
			ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
			LEFT JOIN CommunityMart.Dim.Gender
			ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
			LEFT JOIN CommunityMart.Dim.EducationLevelLookup
			ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
				LEFT JOIN CommunityMart.Dim.EducationLevel
				ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
		LEFT JOIN CommunityMart.Dim.DischargeDispositionLookupCOM
		ON CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=CommunityMart.dbo.ReferralFact.DischargeDispositionCodeID
			LEFT JOIN CommunityMart.Dim.DischargeDisposition
			ON CommunityMart.Dim.DischargeDisposition.DischargeDispositionID=CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionID
		LEFT JOIN CommunityMart.Dim.ReferralReason
		ON CommunityMart.Dim.ReferralReason.ReferralReasonID=CommunityMart.dbo.ReferralFact.ReferralReasonID
		LEFT JOIN CommunityMart.Dim.ReferralType
		ON CommunityMart.Dim.ReferralType.ReferralTypeID=CommunityMart.dbo.ReferralFact.ReferralTypeID
		LEFT JOIN CommunityMart.Dim.LocalReportingOffice
		ON CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID=CommunityMart.dbo.ReferralFact.LocalReportingOfficeID
			LEFT JOIN CommunityMart.Dim.Provider
			ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.Dim.LocalReportingOffice.ProviderID
				LEFT JOIN CommunityMart.Dim.LevelOfCare
				ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
				LEFT JOIN CommunityMart.Dim.Facility
				ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
					LEFT JOIN CommunityMart.Dim.HSDA
					ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
			LEFT JOIN CommunityMart.Dim.CommunityProgram
			ON CommunityMart.Dim.CommunityProgram.CommunityProgramID=CommunityMart.Dim.LocalReportingOffice.CommunityProgramID
		LEFT JOIN CommunityMart.Dim.DischargeOutcome
		ON CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID=CommunityMart.dbo.ReferralFact.DischargeOutcomeID
		LEFT JOIN CommunityMart.Dim.ReasonEndingServiceLookup
		ON CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=CommunityMart.dbo.ReferralFact.ReasonEndingServiceCodeID
			LEFT JOIN CommunityMart.Dim.ReasonEndingService
			ON CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID=CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
		LEFT JOIN CommunityMart.Dim.ReferralSourceLookup
		ON CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID=CommunityMart.dbo.ReferralFact.ReferralSourceLookupID
			LEFT JOIN CommunityMart.Dim.ReferralSource
			ON CommunityMart.Dim.ReferralSource.ReferralSourceID=CommunityMart.Dim.ReferralSourceLookup.ReferralSourceID
	LEFT JOIN CommunityMart.Dim.AssessmentType
	ON CommunityMart.Dim.AssessmentType.AssessmentTypeID=CommunityMart.dbo.AssessmentHeaderFact.AssessmentTypeID
	LEFT JOIN CommunityMart.Dim.AssessmentReason
	ON CommunityMart.Dim.AssessmentReason.AssessmentReasonID=CommunityMart.dbo.AssessmentHeaderFact.AssessmentReasonID
LEFT JOIN CommunityMart.Dim.MethodOfSubstanceIntake
ON CommunityMart.Dim.MethodOfSubstanceIntake.MethodOfSubstanceIntakeID=CommunityMart.dbo.SubstanceUseFact.MethodOfSubstanceIntakeID
)
MERGE INTO CommunityMart.dbo.SubstanceUseFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.SubstanceUseCodeID=src.SubstanceUseCodeID,
	dst.SourceAssessmentID=src.SourceAssessmentID,
	dst.SourceReferralID=src.SourceReferralID,
	dst.ReferralPriorityID=src.ReferralPriorityID,
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.DischargeDispositionCodeID=src.DischargeDispositionCodeID,
	dst.DischargeDispositionID=src.DischargeDispositionID,
	dst.ReferralReasonID=src.ReferralReasonID,
	dst.ReferralTypeID=src.ReferralTypeID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.DischargeOutcomeID=src.DischargeOutcomeID,
	dst.ReasonEndingServiceCodeID=src.ReasonEndingServiceCodeID,
	dst.ReasonEndingServiceID=src.ReasonEndingServiceID,
	dst.ReferralSourceLookupID=src.ReferralSourceLookupID,
	dst.ReferralSourceID=src.ReferralSourceID,
	dst.AssessmentTypeID=src.AssessmentTypeID,
	dst.AssessmentReasonID=src.AssessmentReasonID,
	dst.MethodOfSubstanceIntakeID=src.MethodOfSubstanceIntakeID,
	dst.PatientID=src.PatientID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='Update/Merge CommunityMart.dbo.SubstanceUseFact (denormalize)', 
@pRuleDesc='', 
@pConditionSQL=NULL, 
@pActionID=4, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=3800, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='CommunityMart.dbo.SubstanceUseFact', 
@pTargetAttributePhysicalName='many', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python for CommunityMart.dbo.SubstanceUseFact', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR Update/Merge CommunityMart.dbo.SubstanceUseFact (denormalize)



--#region BR Update/Merge CommunityMart.dbo.WaitTimeFact (denormalize)
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '54fc450a-7b82-11e6-8f53-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	
;WITH src AS (
	SELECT
		CommunityMart.dbo.WaitTimeFact.ETLAuditID
		,CommunityMart.Dim.ReferralPriority.ReferralPriorityID
		,CommunityMart.dbo.PersonFact.SourceSystemClientID
		,CommunityMart.Dim.DeathLocation.DeathLocationID
		,CommunityMart.Dim.Ethnicity.EthnicityID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID
		,CommunityMart.Dim.EducationLevel.EducationLevelID
		,CommunityMart.Dim.CommunityLHA.CommunityLHAID
		,CommunityMart.Dim.Age.AgeID
		,CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID
		,CommunityMart.Dim.Provider.ProviderID
		,CommunityMart.Dim.LevelOfCare.LevelOfCareId
		,CommunityMart.Dim.Facility.FacilityID
		,CommunityMart.Dim.HSDA.HSDAID
		,CommunityMart.Dim.CommunityProgram.CommunityProgramID
		,CommunityMart.Dim.Gender.GenderID
		,CommunityMart.dbo.PersonFact.PatientID
FROM CommunityMart.dbo.WaitTimeFact
LEFT JOIN CommunityMart.Dim.ReferralPriority
ON CommunityMart.Dim.ReferralPriority.ReferralPriorityID=CommunityMart.dbo.WaitTimeFact.ReferralPriorityID
LEFT JOIN CommunityMart.dbo.PersonFact
ON CommunityMart.dbo.PersonFact.SourceSystemClientID=CommunityMart.dbo.WaitTimeFact.SourceSystemClientID
	LEFT JOIN CommunityMart.Dim.DeathLocation
	ON CommunityMart.Dim.DeathLocation.DeathLocationID=CommunityMart.dbo.PersonFact.DeathLocationID
	LEFT JOIN CommunityMart.Dim.Ethnicity
	ON CommunityMart.Dim.Ethnicity.EthnicityID=CommunityMart.dbo.PersonFact.EthnicityID
	LEFT JOIN CommunityMart.Dim.Gender
	ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.PersonFact.GenderID
	LEFT JOIN CommunityMart.Dim.EducationLevelLookup
	ON CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID=CommunityMart.dbo.PersonFact.EducationLevelCodeID
		LEFT JOIN CommunityMart.Dim.EducationLevel
		ON CommunityMart.Dim.EducationLevel.EducationLevelID=CommunityMart.Dim.EducationLevelLookup.EducationLevelID
LEFT JOIN CommunityMart.Dim.CommunityLHA
ON CommunityMart.Dim.CommunityLHA.CommunityLHAID=CommunityMart.dbo.WaitTimeFact.CommunityLHAID
LEFT JOIN CommunityMart.Dim.Age
ON CommunityMart.Dim.Age.AgeID=CommunityMart.dbo.WaitTimeFact.AgeID
LEFT JOIN CommunityMart.Dim.LocalReportingOffice
ON CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID=CommunityMart.dbo.WaitTimeFact.LocalReportingOfficeID
	LEFT JOIN CommunityMart.Dim.Provider
	ON CommunityMart.Dim.Provider.ProviderID=CommunityMart.Dim.LocalReportingOffice.ProviderID
		LEFT JOIN CommunityMart.Dim.LevelOfCare
		ON CommunityMart.Dim.LevelOfCare.LevelOfCareId=CommunityMart.Dim.Provider.LevelOfCareId
		LEFT JOIN CommunityMart.Dim.Facility
		ON CommunityMart.Dim.Facility.FacilityID=CommunityMart.Dim.Provider.FacilityID
			LEFT JOIN CommunityMart.Dim.HSDA
			ON CommunityMart.Dim.HSDA.HSDAID=CommunityMart.Dim.Facility.HSDAID
	LEFT JOIN CommunityMart.Dim.CommunityProgram
	ON CommunityMart.Dim.CommunityProgram.CommunityProgramID=CommunityMart.Dim.LocalReportingOffice.CommunityProgramID
LEFT JOIN CommunityMart.Dim.Gender
ON CommunityMart.Dim.Gender.GenderID=CommunityMart.dbo.WaitTimeFact.GenderID
)
MERGE INTO CommunityMart.dbo.WaitTimeFact AS dst
USING src
ON dst.ETLAuditID = src.ETLAuditID
WHEN MATCHED THEN
UPDATE SET 
	dst.ReferralPriorityID=src.ReferralPriorityID,
	dst.SourceSystemClientID=src.SourceSystemClientID,
	dst.DeathLocationID=src.DeathLocationID,
	dst.EthnicityID=src.EthnicityID,
	dst.GenderID=src.GenderID,
	dst.EducationLevelCodeID=src.EducationLevelCodeID,
	dst.EducationLevelID=src.EducationLevelID,
	dst.CommunityLHAID=src.CommunityLHAID,
	dst.AgeID=src.AgeID,
	dst.LocalReportingOfficeID=src.LocalReportingOfficeID,
	dst.ProviderID=src.ProviderID,
	dst.LevelOfCareId=src.LevelOfCareId,
	dst.FacilityID=src.FacilityID,
	dst.HSDAID=src.HSDAID,
	dst.CommunityProgramID=src.CommunityProgramID,
	dst.GenderID=src.GenderID,
	dst.PatientID=src.PatientID
;

END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='Update/Merge CommunityMart.dbo.WaitTimeFact (denormalize)', 
@pRuleDesc='', 
@pConditionSQL=NULL, 
@pActionID=4, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=3900, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='CommunityMart.dbo.WaitTimeFact', 
@pTargetAttributePhysicalName='many', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python for CommunityMart.dbo.WaitTimeFact', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR Update/Merge CommunityMart.dbo.WaitTimeFact (denormalize)

