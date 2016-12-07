import uuid

biz_rule_template="""

--#region BR {short_name}
SET @UpdatedBy = 'VCH\GCrowell'
SET @CreatedBy ='VCH\GCrowell'
SET @IsActive = 1;
SET @IsLogged = 1;
SET @GUID = '{guid}'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID

SET @ActionSQL = '
BEGIN
	{action_sql}
END
'
EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='{short_name}', 
@pRuleDesc='{rule_desc}', 
@pConditionSQL=NULL, 
@pActionID=4, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=NULL, 
@pSeverityTypeID=NULL, 
@pSequence={sequence}, 
@pDefaultValue='0', 
@pDatabaseId=32, 
@pTargetObjectPhysicalName='{target_table}', 
@pTargetAttributePhysicalName='{target_column}', 
@pSourceObjectPhysicalName=NULL, 
@pSourceAttributePhysicalName=NULL, 
@pIsActive=@IsActive, 
@pComment='generated with python for {target_table}', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=@IsLogged, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=NULL

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID = @GUID
UPDATE DQMF.dbo.DQMF_BizRule SET IsLogged=@IsLogged, IsActive=@IsActive FROM DQMF.dbo.DQMF_BizRule AS br WHERE br.GUID = @GUID;
--#endregion BR {short_name}

"""

class BizRule(object):
	"""creates DQMF BizRule"""
	def __init__(self):
		super(BizRule, self).__init__()
		self.guid = uuid.uuid1()
		self.action_sql = ''
		self.short_name = ''
		self.rule_desc = ''
		self.condition_sql = ''
		self.action_id = ''
		self.sequence = ''
		self.target_table = ''
		self.target_column = ''

	def __str__(self):
		return biz_rule_template.format(**self.__dict__)

if __name__ == '__main__':
	br = BizRule()
	print(br)