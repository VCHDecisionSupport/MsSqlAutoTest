USE [TestLog]
GO
/****** Object:  Table [dbo].[SnapShotObject]    Script Date: 7/18/2016 2:36:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF OBJECT_ID('dbo.SnapShotObject') IS NOT NULL
BEGIN
	PRINT 'drop dbo.SnapShotObject'
	DROP TABLE dbo.SnapShotObject
END
GO

CREATE TABLE [dbo].[SnapShotObject](
	[SnapShotObjectID] [int] IDENTITY(1,1) NOT NULL,
	[DataRequestID] int,
	[CallingPackageName] varchar(100),
	[DatabaseName] [varchar](100) NULL,
	[SchemaName] [varchar](100) NULL,
	[TableName] [varchar](100) NULL,
	[SchemaTableName]  AS ((quotename([SchemaName])+'.')+quotename([TableName])),
	[DatabaseSchemaTableName]  AS (quotename([DatabaseName])+'.')+(quotename([SchemaName])+'.')+quotename([TableName]),
	[DestinationDatabaseSchemaTableName] AS 'SELECT TOP 0 * INTO '+quotename('DR'+CAST(DataRequestID AS varchar)+'_'+CallingPackageName+'_'+DatabaseName+'_'+SchemaName++'_'+TableName)+' FROM '+quotename([DatabaseName])+'.'+quotename([SchemaName])+'.'+quotename([TableName])
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO

;
INSERT INTO TestLog.dbo.SnapShotObject
SELECT 565, 'CCRS', db.DatabaseName, ObjectSchemaName, obj.ObjectPhysicalName
FROM dqmf.dbo.MD_Object obj
JOIN dqmf.dbo.MD_Database db
ON obj.DatabaseId = db.DatabaseId
WHERE 1=1
AND obj.ObjectPurpose = 'Fact'
AND obj.ObjectPhysicalName IN ('SLPActivityFact', 'SubstanceUseFact')
AND obj.ObjectSchemaName IN ('dbo', 'Community')



SELECT * FROM TestLog.dbo.SnapShotObject;