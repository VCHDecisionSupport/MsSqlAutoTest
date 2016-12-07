EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'TestLog'
GO
USE [master]
GO
ALTER DATABASE [TestLog] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
USE [master]
GO
DROP DATABASE [TestLog]
GO

USE Master
GO
CREATE DATABASE [TestLog]
GO
USE [TestLog]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ColumnProfileType]') AND type in (N'U'))
    DROP TABLE [dbo].[ColumnProfileType]
GO
CREATE TABLE [dbo].[ColumnProfileType] (
[ColumnProfileTypeID] int  NOT NULL  
, [ColumnProfileTypeDesc] varchar(100)  NOT NULL  
)
GO

ALTER TABLE [dbo].[ColumnProfileType] ADD CONSTRAINT [ColumnProfileType_PK] PRIMARY KEY CLUSTERED (
[ColumnProfileTypeID]
)
GO
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TableProfileType]') AND type in (N'U'))
    DROP TABLE [dbo].[TableProfileType]
GO
CREATE TABLE [dbo].[TableProfileType] (
[TableProfileTypeID] int  NOT NULL  
, [TableProfileTypeDesc] varchar(100)  NOT NULL  
)
GO

ALTER TABLE [dbo].[TableProfileType] ADD CONSTRAINT [TableProfileType_PK] PRIMARY KEY CLUSTERED (
[TableProfileTypeID]
)
GO
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DataRequestTestConfig]') AND type in (N'U'))
    DROP TABLE [dbo].[DataRequestTestConfig]
GO
CREATE TABLE [dbo].[DataRequestTestConfig] (
[DataRequestTestConfigID] int  NOT NULL  
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
[ColumnProfileID] int  NOT NULL  
, [ColumnID] int  NOT NULL  
, [DistinctCount] int  NOT NULL  
, [TableProfileID] int  NOT NULL  
, [ColumnProfileTypeID] int  NOT NULL  
)
GO

ALTER TABLE [dbo].[ColumnProfile] ADD CONSTRAINT [ColumnProfile_PK] PRIMARY KEY CLUSTERED (
[ColumnProfileID]
)
GO
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TestType]') AND type in (N'U'))
    DROP TABLE [dbo].[TestType]
GO
CREATE TABLE [dbo].[TestType] (
[TestTypeID] int  NOT NULL  
, [TestTypeDesc] varchar(100)  NOT NULL  
)
GO

ALTER TABLE [dbo].[TestType] ADD CONSTRAINT [TestType_PK] PRIMARY KEY CLUSTERED (
[TestTypeID]
)
GO
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TableProfile]') AND type in (N'U'))
    DROP TABLE [dbo].[TableProfile]
GO
CREATE TABLE [dbo].[TableProfile] (
[TableProfileID] int  NOT NULL  
, [TestConfigID] int  NOT NULL  
, [RecordCount] int  NOT NULL  
, [TableProfileDate] datetime  NOT NULL  
, [TableProfileTypeID] int  NOT NULL  
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
[ColumnHistogramID] int  NOT NULL  
, [ColumnProfileID] int  NOT NULL  
, [ColumnValue] nvarchar(200)  NOT NULL  
, [ValueCount] int  NOT NULL  
, [ColumnHistogramTypeID] int  NOT NULL  
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
[TestConfigID] int  NOT NULL  
, [DataRequestTestConfigID] int  NOT NULL  
, [PkgID] int  NOT NULL  
, [ObjectID] int  NOT NULL  
, [PkgExecKey] int  NOT NULL  
, [TestTypeID] int  NOT NULL  
, [DataRequestID] int  NULL  
)
GO

ALTER TABLE [dbo].[TestConfig] ADD CONSTRAINT [TestConfig_PK] PRIMARY KEY CLUSTERED (
[TestConfigID]
)
GO
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ColumnHistogramType]') AND type in (N'U'))
    DROP TABLE [dbo].[ColumnHistogramType]
GO
CREATE TABLE [dbo].[ColumnHistogramType] (
[ColumnHistogramTypeID] int  NOT NULL  
, [ColumnHistogramTypeDesc] varchar(100)  NOT NULL  
)
GO

ALTER TABLE [dbo].[ColumnHistogramType] ADD CONSTRAINT [ColumnHistogramType_PK] PRIMARY KEY CLUSTERED (
[ColumnHistogramTypeID]
)
GO
GO

GO

GO

GO

ALTER TABLE [dbo].[ColumnProfile] WITH CHECK ADD CONSTRAINT [TableProfile_ColumnProfile_FK1] FOREIGN KEY (
[TableProfileID]
)
REFERENCES [dbo].[TableProfile] (
[TableProfileID]
)
ALTER TABLE [dbo].[ColumnProfile] WITH CHECK ADD CONSTRAINT [ColumnProfileType_ColumnProfile_FK1] FOREIGN KEY (
[ColumnProfileTypeID]
)
REFERENCES [dbo].[ColumnProfileType] (
[ColumnProfileTypeID]
)
GO

GO

ALTER TABLE [dbo].[TableProfile] WITH CHECK ADD CONSTRAINT [TableProfileType_TableProfile_FK1] FOREIGN KEY (
[TableProfileTypeID]
)
REFERENCES [dbo].[TableProfileType] (
[TableProfileTypeID]
)
ALTER TABLE [dbo].[TableProfile] WITH CHECK ADD CONSTRAINT [TestConfig_TableProfile_FK1] FOREIGN KEY (
[TestConfigID]
)
REFERENCES [dbo].[TestConfig] (
[TestConfigID]
)
ALTER TABLE [dbo].[TableProfile] WITH CHECK ADD CONSTRAINT [DataRequestTestConfig_TableProfile_FK1] FOREIGN KEY (
[TestConfigID]
)
REFERENCES [dbo].[DataRequestTestConfig] (
[DataRequestTestConfigID]
)
GO

ALTER TABLE [dbo].[ColumnHistogram] WITH CHECK ADD CONSTRAINT [ColumnHistogramType_ColumnHistogram_FK1] FOREIGN KEY (
[ColumnHistogramTypeID]
)
REFERENCES [dbo].[ColumnHistogramType] (
[ColumnHistogramTypeID]
)
ALTER TABLE [dbo].[ColumnHistogram] WITH CHECK ADD CONSTRAINT [ColumnProfile_ColumnHistogram_FK1] FOREIGN KEY (
[ColumnProfileID]
)
REFERENCES [dbo].[ColumnProfile] (
[ColumnProfileID]
)
GO

ALTER TABLE [dbo].[TestConfig] WITH CHECK ADD CONSTRAINT [TestType_TestConfig_FK1] FOREIGN KEY (
[TestTypeID]
)
REFERENCES [dbo].[TestType] (
[TestTypeID]
)
ALTER TABLE [dbo].[TestConfig] WITH CHECK ADD CONSTRAINT [DataRequestTestConfig_TestConfig_FK1] FOREIGN KEY (
[DataRequestTestConfigID]
)
REFERENCES [dbo].[DataRequestTestConfig] (
[DataRequestTestConfigID]
)
GO

GO

