

--#region BR populate denomalized columns: dbo.ReferralFact
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = 'd104c1fe-77b9-11e6-a59c-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	SELECT
	DischargeOutcomeID
	,ReferralTypeID
	,ReferralReasonID
	,DischargeDispositionCodeID
	,DischargeDispositionID
	,SourceSystemClientID
	,GenderID
	,DeathLocationID
	,EducationLevelCodeID
	,EducationLevelID
	,EthnicityID
	,ReferralSourceLookupID
	,ReferralSourceID
	,LocalReportingOfficeID
	,ProviderID
	,FacilityID
	,HSDAID
	,LevelOfCareId
	,CommunityProgramID
	,ReasonEndingServiceCodeID
	,ReasonEndingServiceID
	,ReferralPriorityID
FROM dbo.ReferralFact
JOIN Dim.DischargeOutcome
ON Dim.DischargeOutcome.DischargeOutcomeID=dbo.ReferralFact.DischargeOutcomeID
JOIN Dim.ReferralType
ON Dim.ReferralType.ReferralTypeID=dbo.ReferralFact.ReferralTypeID
JOIN Dim.ReferralReason
ON Dim.ReferralReason.ReferralReasonID=dbo.ReferralFact.ReferralReasonID
JOIN Dim.DischargeDispositionLookupCOM
ON Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID=dbo.ReferralFact.DischargeDispositionCodeID
	JOIN Dim.DischargeDisposition
	ON Dim.DischargeDisposition.DischargeDispositionID=Dim.DischargeDispositionLookupCOM.DischargeDispositionID
JOIN dbo.PersonFact
ON dbo.PersonFact.SourceSystemClientID=dbo.ReferralFact.SourceSystemClientID
	JOIN Dim.Gender
	ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
	JOIN Dim.DeathLocation
	ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
	JOIN Dim.EducationLevelLookup
	ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
		JOIN Dim.EducationLevel
		ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
	JOIN Dim.Ethnicity
	ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
JOIN Dim.ReferralSourceLookup
ON Dim.ReferralSourceLookup.ReferralSourceLookupID=dbo.ReferralFact.ReferralSourceLookupID
	JOIN Dim.ReferralSource
	ON Dim.ReferralSource.ReferralSourceID=Dim.ReferralSourceLookup.ReferralSourceID
JOIN Dim.LocalReportingOffice
ON Dim.LocalReportingOffice.LocalReportingOfficeID=dbo.ReferralFact.LocalReportingOfficeID
	JOIN Dim.Provider
	ON Dim.Provider.ProviderID=Dim.LocalReportingOffice.ProviderID
		JOIN Dim.Facility
		ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
			JOIN Dim.HSDA
			ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
		JOIN Dim.LevelOfCare
		ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
	JOIN Dim.CommunityProgram
	ON Dim.CommunityProgram.CommunityProgramID=Dim.LocalReportingOffice.CommunityProgramID
JOIN Dim.ReasonEndingServiceLookup
ON Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID=dbo.ReferralFact.ReasonEndingServiceCodeID
	JOIN Dim.ReasonEndingService
	ON Dim.ReasonEndingService.ReasonEndingServiceID=Dim.ReasonEndingServiceLookup.ReasonEndingServiceID
JOIN Dim.ReferralPriority
ON Dim.ReferralPriority.ReferralPriorityID=dbo.ReferralFact.ReferralPriorityID
END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='populate denomalized columns: dbo.ReferralFact', 
@pRuleDesc='populates non-source columns from parent fact and dim tables: dbo.ReferralFact', 
@pConditionSQL='', 
@pActionID=, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence=666, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='dbo.ReferralFact', 
@pTargetAttributePhysicalName='many', 
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
--#endregion BR populate denomalized columns: dbo.ReferralFact

