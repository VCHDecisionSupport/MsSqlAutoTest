IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MD_ObjectAttribute]') AND type in (N'U'))
    DROP TABLE [dbo].[MD_ObjectAttribute]
GO
CREATE TABLE [dbo].[MD_ObjectAttribute] (
[ObjectID] INTEGER  NOT NULL  
, [ObjectAttributeID] INTEGER  NOT NULL  
, [AttributeID] INTEGER  NOT NULL  
, [AttributeDetailID] INTEGER  NULL  
, [Sequence] TINYINT  NOT NULL  
, [AttributePhysicalName] VARCHAR(500)  NULL  
, [Datatype] VARCHAR(50)  NOT NULL  
, [AttributeLength] TINYINT  NOT NULL  
, [AttibuteExampleValues] VARCHAR(0)  NULL  
, [AttributeComment] VARCHAR(2000)  NULL  
, [AttributeDefaultValue] VARCHAR(100)  NULL  
, [AttributeETLRulesDescription] VARCHAR(0)  NULL  
, [AttributeUsageTips] VARCHAR(0)  NULL  
, [ISActive] BIT  NULL  
, [BaselineCreatedDT] DATETIME  NULL  
, [BaselineIntegerMean] INTEGER  NULL  
, [BaselineIntegerUpperControlLimit] INTEGER  NULL  
, [BaselineIntegerLowerControlLimit] INTEGER  NULL  
, [BaselineRealMean] FLOAT  NULL  
, [BaselineRealUpperControlLimit] FLOAT  NULL  
, [BaselineRealLowerControlLimit] FLOAT  NULL  
, [PercentMissing] DECIMAL(10,2)  NULL  
, [ContentMap] VARCHAR(0)  NULL  
, [QualityIndicator] INTEGER  NULL  
, [CreatedBy] VARCHAR(50)  NULL  
, [CreatedDT] DATETIME  NULL  
, [UpdatedBy] VARCHAR(50)  NULL  
, [UpdatedDT] DATETIME  NULL  
, [FKTableObjectID] INTEGER  NULL  
)
GO

ALTER TABLE [dbo].[MD_ObjectAttribute] ADD CONSTRAINT [PkcMD_ObjectAttribute] PRIMARY KEY CLUSTERED (
[ObjectAttributeID]
)
GO
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ObjectRegression]') AND type in (N'U'))
    DROP TABLE [dbo].[ObjectRegression]
GO
CREATE TABLE [dbo].[ObjectRegression] (
[ObjectProfileID] INTEGER  NOT NULL  
, [ObjectRegressionID] INTEGER  NOT NULL  
, [ObjectProfileAID] INTEGER  NOT NULL  
, [ObjectProfileBID] INTEGER  NOT NULL  
, [KeyMatchCount] INTEGER  NULL  
, [RecordMatchProfileID] INTEGER  NOT NULL  
)
GO

ALTER TABLE [dbo].[ObjectRegression] ADD CONSTRAINT [ObjectRegression_PK] PRIMARY KEY CLUSTERED (
[ObjectProfileID]
, [ObjectRegressionID]
)
GO
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MD_Object]') AND type in (N'U'))
    DROP TABLE [dbo].[MD_Object]
GO
CREATE TABLE [dbo].[MD_Object] (
[DatabaseId] INTEGER  NOT NULL  
, [SubjectAreaID] INTEGER  NOT NULL  
, [ObjectID] INTEGER  NOT NULL  
, [ObjectDisplayName] VARCHAR(50)  NOT NULL  
, [ObjectSchemaName] VARCHAR(50)  NULL  
, [ObjectPhysicalName] VARCHAR(255)  NULL  
, [ObjectPKField] VARCHAR(255)  NULL  
, [ObjectType] VARCHAR(50)  NOT NULL  
, [ObjectPurpose] VARCHAR(50)  NOT NULL  
, [ObjectShortDescription] VARCHAR(250)  NULL  
, [ObjectLongDescription] VARCHAR(2000)  NULL  
, [ObjectUsageTips] VARCHAR(0)  NULL  
, [ObjectStewardContact] VARCHAR(50)  NULL  
, [LastRefreshDate] DATETIME  NULL  
, [UpdateFrequency] VARCHAR(5)  NULL  
, [ObjectOutputLocation] VARCHAR(1000)  NULL  
, [ObjectOutputRecipients] VARCHAR(0)  NULL  
, [IsActive] BIT  NULL  
, [CreatedBy] VARCHAR(50)  NOT NULL  
, [CreatedDT] DATETIME  NOT NULL  
, [UpdatedBy] LONGVARBINARY  NOT NULL  
, [UpdatedDT] DATETIME  NOT NULL  
, [KeyDateObjectAttributeID] INTEGER  NULL  
, [IsObjectInDB] BIT  NULL  
, [ObjectProfileID] INTEGER  NULL  
)
GO

ALTER TABLE [dbo].[MD_Object] ADD CONSTRAINT [PkcMD_Object] PRIMARY KEY CLUSTERED (
[ObjectID]
)
GO
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ETLBizruleAuditFact]') AND type in (N'U'))
    DROP TABLE [dbo].[ETLBizruleAuditFact]
GO
CREATE TABLE [dbo].[ETLBizruleAuditFact] (
[ETLId] INTEGER  NULL  
, [DQMF_ScheduleId] INTEGER  NOT NULL  
, [BRId] INTEGER  NOT NULL  
, [DatebaseId] INTEGER  NULL  
, [TableId] INTEGER  NULL  
, [AttributeId] INTEGER  NULL  
, [PreviousValue] VARCHAR(50)  NULL  
, [NewValue] VARCHAR(50)  NULL  
, [OlsonTypeID] INTEGER  NULL  
, [ActionID] INTEGER  NULL  
, [SeverityTypeID] INTEGER  NULL  
, [NegativeRating] TINYINT  NULL  
, [ISCorrected] BIT  NULL  
, [PkgExecKey] INTEGER  NULL  
, [ISFORDQ] BIT  NULL  
, [BusinessKey] VARCHAR(500)  NULL  
)
GO

ALTER TABLE [dbo].[ETLBizruleAuditFact] ADD CONSTRAINT [IDX1_AduitFact] PRIMARY KEY CLUSTERED (
[BRId]
)
GO
CREATE   INDEX [IDX2_AduitFact] ON [dbo].[ETLBizruleAuditFact] (
[ETLId]
)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AuditBizRuleAction4Execution]') AND type in (N'U'))
    DROP TABLE [dbo].[AuditBizRuleAction4Execution]
GO
CREATE TABLE [dbo].[AuditBizRuleAction4Execution] (
[BRID] INTEGER  NOT NULL  
, [ExtractFileKey] INTEGER  NOT NULL  
, [ActionSQL] VARCHAR(0)  NULL  
)
GO

ALTER TABLE [dbo].[AuditBizRuleAction4Execution] ADD CONSTRAINT [IX_BRID] PRIMARY KEY CLUSTERED (
[BRID]
)
GO
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DQMF_BizRuleSchedule]') AND type in (N'U'))
    DROP TABLE [dbo].[DQMF_BizRuleSchedule]
GO
CREATE TABLE [dbo].[DQMF_BizRuleSchedule] (
[BRID] INTEGER  NOT NULL  
, [ScheduleID] INTEGER  NOT NULL  
)
GO

ALTER TABLE [dbo].[DQMF_BizRuleSchedule] ADD CONSTRAINT [DQMF_BizRuleSchedule_PK] PRIMARY KEY CLUSTERED (
[ScheduleID]
, [BRID]
)
GO
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ObjectAttributeProfile]') AND type in (N'U'))
    DROP TABLE [dbo].[ObjectAttributeProfile]
GO
CREATE TABLE [dbo].[ObjectAttributeProfile] (
[ObjectAttributeProfileID] INTEGER  NOT NULL  
, [ObjectProfileID] INTEGER  NOT NULL  
, [ObjectAttributeID] INTEGER  NOT NULL  
, [NullCount] INTEGER  NOT NULL  
, [DistinctCount] INTEGER  NOT NULL  
, [ZeroCount] INTEGER  NOT NULL  
, [BlankCount] INTEGER  NOT NULL  
, [AttributeHistogramID] INTEGER  NULL  
)
GO

ALTER TABLE [dbo].[ObjectAttributeProfile] ADD CONSTRAINT [ObjectAttributeProfile_PK] PRIMARY KEY CLUSTERED (
[ObjectAttributeProfileID]
)
GO
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DataRequestTestConfig]') AND type in (N'U'))
    DROP TABLE [dbo].[DataRequestTestConfig]
GO
CREATE TABLE [dbo].[DataRequestTestConfig] (
[DataRequestConfigID] INTEGER  NOT NULL  
, [DataRequestID] INTEGER  NOT NULL  
, [PkgID] INTEGER  NOT NULL  
, [ObjectID] INTEGER  NOT NULL  
, [TestConfig] INTEGER  NULL  
)
GO

ALTER TABLE [dbo].[DataRequestTestConfig] ADD CONSTRAINT [DataRequestTestConfig_PK] PRIMARY KEY CLUSTERED (
[DataRequestConfigID]
)
GO
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DQMF_Schedule]') AND type in (N'U'))
    DROP TABLE [dbo].[DQMF_Schedule]
GO
CREATE TABLE [dbo].[DQMF_Schedule] (
[DQMF_ScheduleId] INTEGER  NOT NULL  
, [StageID] INTEGER  NULL  
, [DatabaseId] INTEGER  NOT NULL  
, [TableId] INTEGER  NOT NULL  
, [IsScheduleActive] BIT  NOT NULL  
, [CreatedBy] VARCHAR(50)  NOT NULL  
, [CreatedDT] DATETIME  NOT NULL  
, [UpdatedBy] VARCHAR(50)  NOT NULL  
, [UpdatedDT] DATETIME  NOT NULL  
)
GO

ALTER TABLE [dbo].[DQMF_Schedule] ADD CONSTRAINT [Pk_DQMFSchedule] PRIMARY KEY CLUSTERED (
[DQMF_ScheduleId]
)
GO
CREATE   INDEX [TableId] ON [dbo].[DQMF_Schedule] (
[TableId]
)
CREATE   INDEX [PkgKey] ON [dbo].[DQMF_Schedule] (
)
CREATE   INDEX [MD_DatabaseDQMF_Schedule] ON [dbo].[DQMF_Schedule] (
[DatabaseId]
)
CREATE   INDEX [ETL_PackageDQMF_Schedule] ON [dbo].[DQMF_Schedule] (
)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AuditBizRuleExecution]') AND type in (N'U'))
    DROP TABLE [dbo].[AuditBizRuleExecution]
GO
CREATE TABLE [dbo].[AuditBizRuleExecution] (
[BRID] INTEGER  NOT NULL  
, [ExecutionDate] DATETIME  NOT NULL  
, [ExtractFileKey] INTEGER  NOT NULL  
, [ExecSequence] INTEGER  NOT NULL  
)
GO

ALTER TABLE [dbo].[AuditBizRuleExecution] ADD CONSTRAINT [PK_AuditBizRuleExecution] PRIMARY KEY CLUSTERED (
[ExecSequence]
)
GO
CREATE   INDEX [IDX1_BRID] ON [dbo].[AuditBizRuleExecution] (
[BRID]
)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ObjectAttributeRegression]') AND type in (N'U'))
    DROP TABLE [dbo].[ObjectAttributeRegression]
GO
CREATE TABLE [dbo].[ObjectAttributeRegression] (
[ObjectAttributeRegressionID] INTEGER  NOT NULL  
, [ObjectRegressionID] INTEGER  NOT NULL  
, [ValueMatchCount] INTEGER  NULL  
, [ValueMatchHistogramID] INTEGER  NULL  
, [ObjectAValueMisMatchHistogramID] INTEGER  NULL  
, [ObjectBValueMisMatchHistogramID] INTEGER  NULL  
, [ObjectAttributeProfileID] INTEGER  NOT NULL  
)
GO

ALTER TABLE [dbo].[ObjectAttributeRegression] ADD CONSTRAINT [ObjectAttributeRegression_PK] PRIMARY KEY CLUSTERED (
[ObjectAttributeRegressionID]
)
GO
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AuditExtractFile]') AND type in (N'U'))
    DROP TABLE [dbo].[AuditExtractFile]
GO
CREATE TABLE [dbo].[AuditExtractFile] (
[ExtractFileKey] INTEGER  NOT NULL  
, [PkgExecKey] INTEGER  NOT NULL  
, [ExtractFilePhysicalLocation] VARCHAR(250)  NOT NULL  
, [ExtractFileProcessStartDT] DATETIME  NULL  
, [ExtractFileProcessStopDT] DATETIME  NULL  
, [ExtractFileCreatedDT] DATETIME  NULL  
, [IsProcessSuccess] BIT  NOT NULL  
)
GO

ALTER TABLE [dbo].[AuditExtractFile] ADD CONSTRAINT [IDX1_AuditExtractFile_PK] PRIMARY KEY CLUSTERED (
[ExtractFileKey]
)
GO
CREATE   INDEX [PkgExecKey] ON [dbo].[AuditExtractFile] (
[PkgExecKey]
)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Histogram]') AND type in (N'U'))
    DROP TABLE [dbo].[Histogram]
GO
CREATE TABLE [dbo].[Histogram] (
[HistogramID] INTEGER  NOT NULL  
, [Value] VARCHAR(10)  NULL  
, [ValueCount] INTEGER  NULL  
)
GO

ALTER TABLE [dbo].[Histogram] ADD CONSTRAINT [Histogram_PK] PRIMARY KEY CLUSTERED (
[HistogramID]
)
GO
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DQMF_Stage]') AND type in (N'U'))
    DROP TABLE [dbo].[DQMF_Stage]
GO
CREATE TABLE [dbo].[DQMF_Stage] (
[StageID] INTEGER  NOT NULL  
, [StageName] VARCHAR(50)  NOT NULL  
, [StageDescription] VARCHAR(0)  NOT NULL  
, [StageOrder] TINYINT  NOT NULL  
)
GO

ALTER TABLE [dbo].[DQMF_Stage] ADD CONSTRAINT [PK_DQMF_Stage] PRIMARY KEY CLUSTERED (
[StageID]
)
GO
CREATE UNIQUE  INDEX [IDU_DQMFStage] ON [dbo].[DQMF_Stage] (
[StageName]
)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MD_Database]') AND type in (N'U'))
    DROP TABLE [dbo].[MD_Database]
GO
CREATE TABLE [dbo].[MD_Database] (
[DatabaseId] INTEGER  NOT NULL  
, [DatabaseName] VARCHAR(50)  NOT NULL  
, [DatabaseShortDescription] VARCHAR(250)  NOT NULL  
, [DatabaseLongDescription] VARCHAR(0)  NULL  
, [DatabaseType] VARCHAR(50)  NULL  
, [IsActive] BIT  NULL  
)
GO

ALTER TABLE [dbo].[MD_Database] ADD CONSTRAINT [aaaaaMD_Database_PK] PRIMARY KEY CLUSTERED (
[DatabaseId]
)
GO
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ETL_Package]') AND type in (N'U'))
    DROP TABLE [dbo].[ETL_Package]
GO
CREATE TABLE [dbo].[ETL_Package] (
[PkgID] INTEGER  NOT NULL  
, [PkgName] VARCHAR(100)  NOT NULL  
, [PkgDescription] VARCHAR(0)  NOT NULL  
, [CreatedBy] VARCHAR(50)  NOT NULL  
, [CreatedDT] DATETIME  NOT NULL  
, [UpdatedBy] VARCHAR(50)  NOT NULL  
, [UpdatedDT] DATETIME  NOT NULL  
, [IsLocking] BIT  NULL  
, [isActive] BIT  NULL  
)
GO

ALTER TABLE [dbo].[ETL_Package] ADD CONSTRAINT [aaaaaETL_Package_PK] PRIMARY KEY CLUSTERED (
[PkgID]
)
GO
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AuditPkgExecution]') AND type in (N'U'))
    DROP TABLE [dbo].[AuditPkgExecution]
GO
CREATE TABLE [dbo].[AuditPkgExecution] (
[PkgExecKey] INTEGER  NOT NULL  
, [ParentPkgExecKey] INTEGER  NULL  
, [PkgName] VARCHAR(100)  NOT NULL  
, [PkgKey] INTEGER  NOT NULL  
, [PkgVersionMajor] TINYINT  NULL  
, [PkgVersionMinor] TINYINT  NULL  
, [ExecStartDT] DATETIME  NOT NULL  
, [ExecStopDT] DATETIME  NULL  
, [IsPackageSuccessful] BIT  NOT NULL  
)
GO

ALTER TABLE [dbo].[AuditPkgExecution] ADD CONSTRAINT [PK_AuditPkgExecution] PRIMARY KEY CLUSTERED (
[PkgExecKey]
)
GO
CREATE   INDEX [TableProcessKey] ON [dbo].[AuditPkgExecution] (
[PkgExecKey]
)
CREATE   INDEX [PkgGUID] ON [dbo].[AuditPkgExecution] (
[PkgKey]
)
CREATE   INDEX [ParentPkgExecKey] ON [dbo].[AuditPkgExecution] (
[ParentPkgExecKey]
)
CREATE   INDEX [ETL_PackageAuditPkgExecution] ON [dbo].[AuditPkgExecution] (
[PkgKey]
)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MD_SubjectArea]') AND type in (N'U'))
    DROP TABLE [dbo].[MD_SubjectArea]
GO
CREATE TABLE [dbo].[MD_SubjectArea] (
[DatabaseID] INTEGER  NOT NULL  
, [SubjectAreaID] INTEGER  NOT NULL  
, [SubjectAreaName] VARCHAR(50)  NULL  
, [SubjectAreaShortDescription] VARCHAR(250)  NULL  
, [SubjectAreaLongDescription] LONGVARBINARY  NULL  
, [BusinessProcessArea] VARCHAR(50)  NULL  
, [ISActive] VARCHAR(5)  NULL  
, [SubjectAreaStewardContact] VARCHAR(50)  NULL  
, [SubjectAreaBusinessContact] VARCHAR(500)  NULL  
, [CreatedBy] VARCHAR(50)  NULL  
, [CreatedDT] DATETIME  NULL  
, [UpdatedBy] VARCHAR(50)  NULL  
, [UpdatedDT] DATETIME  NULL  
)
GO

ALTER TABLE [dbo].[MD_SubjectArea] ADD CONSTRAINT [PkcMD_SubjectArea] PRIMARY KEY CLUSTERED (
[SubjectAreaID]
)
GO
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ObjectProfile]') AND type in (N'U'))
    DROP TABLE [dbo].[ObjectProfile]
GO
CREATE TABLE [dbo].[ObjectProfile] (
[ObjectProfileID] INTEGER  NOT NULL  
, [ObjectID] INTEGER  NULL  
, [PkgExecKey] INTEGER  NULL  
, [DataRequestID] INTEGER  NULL  
, [RecordCount] INTEGER  NULL  
, [ObjectProfileDate] DATETIME  NULL  
, [TestConfig] CHAR(10)  NULL  
, [DataRequestConfigID] INTEGER  NULL  
)
GO

ALTER TABLE [dbo].[ObjectProfile] ADD CONSTRAINT [ObjectProfile_PK] PRIMARY KEY CLUSTERED (
[ObjectProfileID]
)
GO
GO

GO

ALTER TABLE [dbo].[ObjectRegression] WITH CHECK ADD CONSTRAINT [ObjectProfile_ObjectRegression_FK4] FOREIGN KEY (
[RecordMatchProfileID]
)
REFERENCES [dbo].[ObjectProfile] (
[ObjectProfileID]
)
ALTER TABLE [dbo].[ObjectRegression] WITH CHECK ADD CONSTRAINT [ObjectProfile_ObjectRegression_FK5] FOREIGN KEY (
[ObjectProfileBID]
)
REFERENCES [dbo].[ObjectProfile] (
[ObjectProfileID]
)
ALTER TABLE [dbo].[ObjectRegression] WITH CHECK ADD CONSTRAINT [ObjectProfile_ObjectRegression_FK6] FOREIGN KEY (
[RecordMatchProfileID]
)
REFERENCES [dbo].[ObjectProfile] (
[ObjectProfileID]
)
ALTER TABLE [dbo].[ObjectRegression] WITH CHECK ADD CONSTRAINT [ObjectProfile_ObjectRegression_FK2] FOREIGN KEY (
[ObjectProfileBID]
)
REFERENCES [dbo].[ObjectProfile] (
[ObjectProfileID]
)
ALTER TABLE [dbo].[ObjectRegression] WITH CHECK ADD CONSTRAINT [ObjectProfile_ObjectRegression_FK1] FOREIGN KEY (
[ObjectProfileAID]
)
REFERENCES [dbo].[ObjectProfile] (
[ObjectProfileID]
)
ALTER TABLE [dbo].[ObjectRegression] WITH CHECK ADD CONSTRAINT [ObjectProfile_ObjectRegression_FK3] FOREIGN KEY (
[RecordMatchProfileID]
)
REFERENCES [dbo].[ObjectProfile] (
[ObjectProfileID]
)
GO

ALTER TABLE [dbo].[MD_Object] WITH CHECK ADD CONSTRAINT [ObjectProfile_MD_Object_FK1] FOREIGN KEY (
[ObjectProfileID]
)
REFERENCES [dbo].[ObjectProfile] (
[ObjectProfileID]
)
GO

GO

GO

GO

ALTER TABLE [dbo].[ObjectAttributeProfile] WITH CHECK ADD CONSTRAINT [Histogram_ObjectAttributeProfile_FK1] FOREIGN KEY (
[AttributeHistogramID]
)
REFERENCES [dbo].[Histogram] (
[HistogramID]
)
ALTER TABLE [dbo].[ObjectAttributeProfile] WITH CHECK ADD CONSTRAINT [MD_ObjectAttribute_ObjectAttributeProfile_FK1] FOREIGN KEY (
[ObjectAttributeID]
)
REFERENCES [dbo].[MD_ObjectAttribute] (
[ObjectAttributeID]
)
ALTER TABLE [dbo].[ObjectAttributeProfile] WITH CHECK ADD CONSTRAINT [ObjectProfile_ObjectAttributeProfile_FK1] FOREIGN KEY (
[ObjectProfileID]
)
REFERENCES [dbo].[ObjectProfile] (
[ObjectProfileID]
)
GO

GO

ALTER TABLE [dbo].[DQMF_Schedule] WITH CHECK ADD CONSTRAINT [DQMF_BizRuleSchedule_DQMF_Schedule_FK1] FOREIGN KEY (
)
REFERENCES [dbo].[DQMF_BizRuleSchedule] (
)
ALTER TABLE [dbo].[DQMF_Schedule] WITH CHECK ADD CONSTRAINT [MD_Database_DQMF_Schedule_FK1] FOREIGN KEY (
[DatabaseId]
)
REFERENCES [dbo].[MD_Database] (
[DatabaseId]
)
ALTER TABLE [dbo].[DQMF_Schedule] WITH CHECK ADD CONSTRAINT [DQMF_Stage_DQMF_Schedule_FK1] FOREIGN KEY (
[StageID]
)
REFERENCES [dbo].[DQMF_Stage] (
[StageID]
)
GO

GO

ALTER TABLE [dbo].[ObjectAttributeRegression] WITH CHECK ADD CONSTRAINT [ObjectAttributeProfile_ObjectAttributeRegression_FK1] FOREIGN KEY (
[ObjectAttributeProfileID]
)
REFERENCES [dbo].[ObjectAttributeProfile] (
[ObjectAttributeProfileID]
)
ALTER TABLE [dbo].[ObjectAttributeRegression] WITH CHECK ADD CONSTRAINT [ObjectRegression_ObjectAttributeRegression_FK1] FOREIGN KEY (
[ObjectRegressionID]
)
REFERENCES [dbo].[ObjectRegression] (
[ObjectProfileID]
)
GO

GO

ALTER TABLE [dbo].[Histogram] WITH CHECK ADD CONSTRAINT [ObjectAttributeRegression_Histogram_FK3] FOREIGN KEY (
[HistogramID]
)
REFERENCES [dbo].[ObjectAttributeRegression] (
[ObjectBValueMisMatchHistogramID]
)
ALTER TABLE [dbo].[Histogram] WITH CHECK ADD CONSTRAINT [ObjectAttributeRegression_Histogram_FK2] FOREIGN KEY (
[HistogramID]
)
REFERENCES [dbo].[ObjectAttributeRegression] (
[ValueMatchHistogramID]
)
ALTER TABLE [dbo].[Histogram] WITH CHECK ADD CONSTRAINT [ObjectAttributeProfile_Histogram_FK1] FOREIGN KEY (
[HistogramID]
)
REFERENCES [dbo].[ObjectAttributeProfile] (
[AttributeHistogramID]
)
ALTER TABLE [dbo].[Histogram] WITH CHECK ADD CONSTRAINT [ObjectAttributeRegression_Histogram_FK1] FOREIGN KEY (
[HistogramID]
)
REFERENCES [dbo].[ObjectAttributeRegression] (
[ObjectAValueMisMatchHistogramID]
)
GO

GO

GO

ALTER TABLE [dbo].[ETL_Package] WITH CHECK ADD CONSTRAINT [DataRequestTestConfig_ETL_Package_FK1] FOREIGN KEY (
)
REFERENCES [dbo].[DataRequestTestConfig] (
)
ALTER TABLE [dbo].[ETL_Package] WITH CHECK ADD CONSTRAINT [AuditPkgExecution_ETL_Package_FK1] FOREIGN KEY (
[PkgID]
)
REFERENCES [dbo].[AuditPkgExecution] (
[PkgKey]
)
GO

GO

GO

ALTER TABLE [dbo].[ObjectProfile] WITH CHECK ADD CONSTRAINT [AuditPkgExecution_ObjectProfile_FK1] FOREIGN KEY (
[PkgExecKey]
)
REFERENCES [dbo].[AuditPkgExecution] (
[PkgExecKey]
)
ALTER TABLE [dbo].[ObjectProfile] WITH CHECK ADD CONSTRAINT [DataRequestTestConfig_ObjectProfile_FK1] FOREIGN KEY (
[DataRequestConfigID]
)
REFERENCES [dbo].[DataRequestTestConfig] (
[DataRequestConfigID]
)
GO

