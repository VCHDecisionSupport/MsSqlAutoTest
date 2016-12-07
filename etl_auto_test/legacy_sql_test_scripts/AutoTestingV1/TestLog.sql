USE master
GO

DECLARE @sql nvarchar(max);
DECLARE @params nvarchar(max);

IF NOT EXISTS(SELECT * FROM sys.databases AS db WHERE db.name = 'TestLog')
BEGIN
	SET @sql = FORMATMESSAGE('CREATE DATABASE TestLog')
	EXEC(@sql);
END
GO

USE TestLog
GO

DECLARE @sql nvarchar(max);
DECLARE @params nvarchar(max);

IF SCHEMA_ID('SnapShot') IS NULL
BEGIN
	SET @sql = 'CREATE SCHEMA SnapShot;';
	EXEC(@sql);
END



DECLARE fk_cur CURSOR
FOR
SELECT tab.name AS TableName, fk.name AS ForeignKeyName
FROM sys.foreign_keys AS fk
JOIN sys.tables AS tab
ON fk.parent_object_id = tab.object_id
WHERE tab.name NOT LIKE '%sys%'
AND tab.name NOT LIKE 'DQMF%'

OPEN fk_cur;

DECLARE @tb_name varchar(128);
DECLARE @fk_name varchar(128);

FETCH NEXT FROM fk_cur INTO @tb_name, @fk_name;

WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @tb_name, @fk_name;

	SET @sql = 'ALTER TABLE '+@tb_name +' DROP CONSTRAINT '+ @fk_name;
	PRINT @sql
	EXEC(@sql);
	FETCH NEXT FROM fk_cur INTO @tb_name, @fk_name;
END
GO
CLOSE fk_cur;
DEALLOCATE fk_cur;
GO




IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DataDesc]') AND type in (N'U'))
    DROP TABLE [dbo].DataDesc
GO
CREATE TABLE [dbo].DataDesc (
[DataDescID] int IDENTITY(1,1) NOT NULL  
, DataDescLong nvarchar(100) NOT NULL  
, DataDescPrefix nvarchar(100) NOT NULL  
)
GO

INSERT INTO DataDesc (DataDescLong, DataDescPrefix) VALUES
	('PreEtlFullSnapShot','PreSnap'),
	('PostEtlFullSnapShot','PostSnap'),
	('RecordMatch','Match'),
	('PreEtlKeyMatch','PrePkMatch'),
	('PostEtlKeyMatch','PostPkMatch'),
	('PreEtlKeyMisMatch','PrePkMis'),
	('PostEtlKeyMisMatch','PostPkMis')

ALTER TABLE [dbo].DataDesc ADD CONSTRAINT DataDesc_PK PRIMARY KEY CLUSTERED (
[DataDescID]
)
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DataRequestTestConfig]') AND type in (N'U'))
    DROP TABLE [dbo].[DataRequestTestConfig]
GO
CREATE TABLE [dbo].[DataRequestTestConfig] (
[DataRequestTestConfigID] int IDENTITY(1,1) NOT NULL  
, [DataRequestID] int  NOT NULL  
, [PkgID] int  NOT NULL  
, [ObjectID] int  NULL  
)
GO

ALTER TABLE [dbo].[DataRequestTestConfig] ADD CONSTRAINT [DataRequestTestConfig_PK] PRIMARY KEY CLUSTERED (
[DataRequestTestConfigID]
)
GO
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ColumnProfile]') AND type in (N'U'))
    DROP TABLE [dbo].[ColumnProfile]
GO
CREATE TABLE [dbo].[ColumnProfile] (
[ColumnProfileID] int IDENTITY(1,1) NOT NULL  
, [ColumnID] int  NOT NULL  
, [DistinctCount] int  NOT NULL  
, [NullCount] int  NOT NULL  
, [ZeroCount] int  NOT NULL  
, [BlankCount] int  NOT NULL  
, [TableProfileID] int  NULL  
)
GO

ALTER TABLE [dbo].[ColumnProfile] ADD CONSTRAINT [ColumnProfile_PK] PRIMARY KEY CLUSTERED (
[ColumnProfileID]
)
GO
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TableProfile]') AND type in (N'U'))
    DROP TABLE [dbo].[TableProfile]
GO
CREATE TABLE [dbo].[TableProfile] (
[TableProfileID] int IDENTITY(1,1) NOT NULL  
, [TestConfigID] int  NOT NULL  
, [DataDesc] varchar(200)  NOT NULL  
, [RecordCount] int  NULL  
, [TableProfileDate] datetime  NOT NULL  
)
GO

ALTER TABLE [dbo].[TableProfile] ADD CONSTRAINT [TableProfile_PK] PRIMARY KEY CLUSTERED (
[TableProfileID]
)
GO
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ColumnHistogram]') AND type in (N'U'))
    DROP TABLE [dbo].[ColumnHistogram]
GO
CREATE TABLE [dbo].[ColumnHistogram] (
[ColumnHistogramID] int IDENTITY(1,1) NOT NULL  
, [ColumnProfileID] int  NOT NULL  
, [ColumnValue] nvarchar(200)  NULL  
, [ValueCount] int  NULL  
)
GO

ALTER TABLE [dbo].[ColumnHistogram] ADD CONSTRAINT [ColumnHistogram_PK] PRIMARY KEY CLUSTERED (
[ColumnHistogramID]
)
GO
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TestConfig]') AND type in (N'U'))
    DROP TABLE [dbo].[TestConfig]
GO
CREATE TABLE [dbo].[TestConfig] (
[TestConfigID] int IDENTITY(1,1) NOT NULL  
, [DataRequestTestConfigID] int  NOT NULL  
, [DataRequestID] int  NULL  
, [PkgID] int  NULL  
, [ObjectID] int  NULL  
, [PkgExecKey] int  NULL  
, [PreEtlSnapShotDate] datetime  NULL  
, [PostEtlSnapShotDate] datetime  NULL  
, [TestTypeDesc] varchar(100)  NULL  
, [?PKField] int  NULL  
)
GO

ALTER TABLE [dbo].[TestConfig] ADD CONSTRAINT [TestConfig_PK] PRIMARY KEY CLUSTERED (
[TestConfigID]
)
GO
GO

GO

--ALTER TABLE [dbo].[ColumnProfile] WITH CHECK ADD CONSTRAINT [TableProfile_ColumnProfile_FK1] FOREIGN KEY (
--[TableProfileID]
--)
--REFERENCES [dbo].[TableProfile] (
--[TableProfileID]
--)
--GO

--ALTER TABLE [dbo].[TableProfile] WITH CHECK ADD CONSTRAINT [TestConfig_TableProfile_FK1] FOREIGN KEY (
--[TestConfigID]
--)
--REFERENCES [dbo].[TestConfig] (
--[TestConfigID]
--)
--ALTER TABLE [dbo].[TableProfile] WITH CHECK ADD CONSTRAINT [DataRequestTestConfig_TableProfile_FK1] FOREIGN KEY (
--[TestConfigID]
--)
--REFERENCES [dbo].[DataRequestTestConfig] (
--[DataRequestTestConfigID]
--)
--GO

--ALTER TABLE [dbo].[ColumnHistogram] WITH CHECK ADD CONSTRAINT [ColumnProfile_ColumnHistogram_FK1] FOREIGN KEY (
--[ColumnProfileID]
--)
--REFERENCES [dbo].[ColumnProfile] (
--[ColumnProfileID]
--)
--GO

--ALTER TABLE [dbo].[TestConfig] WITH CHECK ADD CONSTRAINT [DataRequestTestConfig_TestConfig_FK1] FOREIGN KEY (
--[DataRequestTestConfigID]
--)
--REFERENCES [dbo].[DataRequestTestConfig] (
--[DataRequestTestConfigID]
--)
GO

