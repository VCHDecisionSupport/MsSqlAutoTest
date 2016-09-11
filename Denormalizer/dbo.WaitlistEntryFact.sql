

--#region BR dbo.WaitlistEntryFact
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '7a5f4980-77c7-11e6-ac18-00232444dba2'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	SELECT
	WaitlistStatusID
	,WaitListReasonID
	,SourceSystemClientID
	,EthnicityID
	,EducationLevelCodeID
	,EducationLevelID
	,DeathLocationID
	,GenderID
	,SourceWaitlistDefinitionID
	,WaitlistTypeID
	,ProviderID
	,LevelOfCareId
	,FacilityID
	,HSDAID
	,WaitlistPriorityID
	,LocalReportingOfficeID
	,ProviderID
	,LevelOfCareId
	,FacilityID
	,HSDAID
	,CommunityProgramID
FROM dbo.WaitlistEntryFact
JOIN Dim.WaitlistStatus
ON Dim.WaitlistStatus.WaitlistStatusID=dbo.WaitlistEntryFact.WaitlistStatusID
JOIN Dim.WaitListReason
ON Dim.WaitListReason.WaitListReasonID=dbo.WaitlistEntryFact.WaitListReasonID
JOIN dbo.PersonFact
ON dbo.PersonFact.SourceSystemClientID=dbo.WaitlistEntryFact.SourceSystemClientID
	JOIN Dim.Ethnicity
	ON Dim.Ethnicity.EthnicityID=dbo.PersonFact.EthnicityID
	JOIN Dim.EducationLevelLookup
	ON Dim.EducationLevelLookup.EducationLevelCodeID=dbo.PersonFact.EducationLevelCodeID
		JOIN Dim.EducationLevel
		ON Dim.EducationLevel.EducationLevelID=Dim.EducationLevelLookup.EducationLevelID
	JOIN Dim.DeathLocation
	ON Dim.DeathLocation.DeathLocationID=dbo.PersonFact.DeathLocationID
	JOIN Dim.Gender
	ON Dim.Gender.GenderID=dbo.PersonFact.GenderID
JOIN dbo.WaitlistDefinitionFact
ON dbo.WaitlistDefinitionFact.SourceWaitlistDefinitionID=dbo.WaitlistEntryFact.SourceWaitlistDefinitionID
	JOIN Dim.WaitlistType
	ON Dim.WaitlistType.WaitlistTypeID=dbo.WaitlistDefinitionFact.WaitlistTypeID
	JOIN Dim.Provider
	ON Dim.Provider.ProviderID=dbo.WaitlistDefinitionFact.ProviderID
		JOIN Dim.LevelOfCare
		ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
		JOIN Dim.Facility
		ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
			JOIN Dim.HSDA
			ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
JOIN Dim.WaitlistPriority
ON Dim.WaitlistPriority.WaitlistPriorityID=dbo.WaitlistEntryFact.WaitlistPriorityID
JOIN Dim.LocalReportingOffice
ON Dim.LocalReportingOffice.LocalReportingOfficeID=dbo.WaitlistEntryFact.LocalReportingOfficeID
	JOIN Dim.Provider
	ON Dim.Provider.ProviderID=Dim.LocalReportingOffice.ProviderID
		JOIN Dim.LevelOfCare
		ON Dim.LevelOfCare.LevelOfCareId=Dim.Provider.LevelOfCareId
		JOIN Dim.Facility
		ON Dim.Facility.FacilityID=Dim.Provider.FacilityID
			JOIN Dim.HSDA
			ON Dim.HSDA.HSDAID=Dim.Facility.HSDAID
	JOIN Dim.CommunityProgram
	ON Dim.CommunityProgram.CommunityProgramID=Dim.LocalReportingOffice.CommunityProgramID
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

