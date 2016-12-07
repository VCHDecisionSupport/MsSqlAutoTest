USE [master]
GO
DROP DATABASE [TestLog]
GO
CREATE DATABASE [TestLog]
GO
USE [TestLog]
GO

IF SCHEMA_ID('SnapShot') IS NULL
BEGIN
	DECLARE @sql VARCHAR(max) = 'CREATE SCHEMA SnapShot;'
	EXEC (@sql);
END
GO



IF OBJECT_ID('[dbo].[DataRequestTestConfig]') IS NOT NULL
	DROP TABLE [dbo].[DataRequestTestConfig];
GO
CREATE TABLE [dbo].[DataRequestTestConfig] (
	[DataRequestTestConfigID] INT IDENTITY(1, 1) NOT NULL
	,[DataRequestID] INT NOT NULL
	,[PkgID] INT NOT NULL
	,[ObjectID] INT NULL
)
GO
ALTER TABLE [dbo].[DataRequestTestConfig] ADD CONSTRAINT [DataRequestTestConfig_PK] PRIMARY KEY CLUSTERED ([DataRequestTestConfigID])
GO


IF OBJECT_ID('[dbo].[TestConfig]') IS NOT NULL
	DROP TABLE [dbo].[TestConfig];
GO
CREATE TABLE [dbo].[TestConfig] (
	[TestConfigID] INT IDENTITY(1, 1) NOT NULL
	,[DataRequestTestConfigID] INT NULL
	,[PkgID] INT NULL
	,[ObjectID] INT NULL
	,[PkgExecKey] INT NULL
	,[TestTypeID] INT NOT NULL
	,[DataRequestID] INT NULL
	,[PreEtlSnapShotSourceName] varchar(200)
	,[PostEtlSnapShotSourceName] varchar(200)
)
GO
ALTER TABLE [dbo].[TestConfig] ADD CONSTRAINT [TestConfig_PK] PRIMARY KEY CLUSTERED ([TestConfigID])
GO

IF OBJECT_ID('[dbo].[TestType]') IS NOT NULL
	DROP TABLE [dbo].[TestType];
GO
CREATE TABLE [dbo].[TestType] ([TestTypeID] INT IDENTITY(1, 1) NOT NULL, [TestTypeDesc] VARCHAR(100) NOT NULL)
GO
ALTER TABLE [dbo].[TestType] ADD CONSTRAINT [TestType_PK] PRIMARY KEY CLUSTERED ([TestTypeID])
GO
INSERT INTO dbo.TestType VALUES ('StandAloneProfile')
INSERT INTO dbo.TestType VALUES ('RuntimeRegressionTest')
INSERT INTO dbo.TestType VALUES ('AdHocComparison')
GO



IF OBJECT_ID('[dbo].[TableProfile]') IS NOT NULL
	DROP TABLE [dbo].[TableProfile];
GO
CREATE TABLE [dbo].[TableProfile] ([TableProfileID] INT IDENTITY(1, 1) NOT NULL
	,[TestConfigID] INT NOT NULL
	,[RecordCount] INT NOT NULL
	,[TableProfileDate] DATETIME NOT NULL
	,[TableProfileTypeID] INT NOT NULL
)
GO
ALTER TABLE [dbo].[TableProfile] ADD CONSTRAINT [TableProfile_PK] PRIMARY KEY CLUSTERED ([TableProfileID])
GO

IF OBJECT_ID('[dbo].[TableProfileType]') IS NOT NULL
	DROP TABLE [dbo].[TableProfileType];
GO
CREATE TABLE [dbo].[TableProfileType] (
	[TableProfileTypeID] INT IDENTITY(1, 1) NOT NULL
	,[TableProfileTypeDesc] VARCHAR(100) NOT NULL
)
GO
ALTER TABLE [dbo].[TableProfileType] ADD CONSTRAINT [TableProfileType_PK] PRIMARY KEY CLUSTERED ([TableProfileTypeID])
GO
INSERT INTO dbo.TableProfileType VALUES ('StandAloneTableProfile')
INSERT INTO dbo.TableProfileType VALUES ('StandAloneViewTableProfile')
INSERT INTO dbo.TableProfileType VALUES ('RecordMatchTableProfile')
INSERT INTO dbo.TableProfileType VALUES ('PreEtlKeyMisMatchTableProfile')
INSERT INTO dbo.TableProfileType VALUES ('PostEtlKeyMisMatchTableProfile')
INSERT INTO dbo.TableProfileType VALUES ('KeyMatchTableProfile')
GO


IF OBJECT_ID('[dbo].[ColumnProfile]') IS NOT NULL
	DROP TABLE [dbo].[ColumnProfile];
GO
CREATE TABLE [dbo].[ColumnProfile] (
	[ColumnProfileID] INT IDENTITY(1, 1) NOT NULL
	,[ColumnName] varchar(200) NOT NULL
	,[ColumnCount] INT NOT NULL
	,[TableProfileID] INT NOT NULL
	,[ColumnProfileTypeID] INT NOT NULL
)
GO
ALTER TABLE [dbo].[ColumnProfile] ADD CONSTRAINT [ColumnProfile_PK] PRIMARY KEY CLUSTERED ([ColumnProfileID])
GO

IF OBJECT_ID('[dbo].[ColumnProfileType]') IS NOT NULL
	DROP TABLE [dbo].[ColumnProfileType];
GO
CREATE TABLE [dbo].[ColumnProfileType] (
	[ColumnProfileTypeID] INT IDENTITY(1, 1) NOT NULL
	,[ColumnProfileTypeDesc] VARCHAR(100) NOT NULL
)
GO
ALTER TABLE [dbo].[ColumnProfileType] ADD CONSTRAINT [ColumnProfileType_PK] PRIMARY KEY CLUSTERED ([ColumnProfileTypeID])
GO
INSERT INTO dbo.ColumnProfileType VALUES ('StandAloneColumnProfile');
INSERT INTO dbo.ColumnProfileType VALUES ('RecordMatchColumnProfile');
INSERT INTO dbo.ColumnProfileType VALUES ('PreEtlKeyMisMatchColumnProfile');
INSERT INTO dbo.ColumnProfileType VALUES ('PostEtlKeyMisMatchColumnProfile');
INSERT INTO dbo.ColumnProfileType VALUES ('KeyMatchValueMatchColumnProfile');
INSERT INTO dbo.ColumnProfileType VALUES ('KeyMatchValueMisMatchColumnProfile');
GO


IF OBJECT_ID('[dbo].[ColumnHistogram]') IS NOT NULL
	DROP TABLE [dbo].[ColumnHistogram];
GO
CREATE TABLE [dbo].[ColumnHistogram] (
	[ColumnHistogramID] INT IDENTITY(1, 1) NOT NULL
	,[ColumnProfileID] INT NOT NULL
	,[ColumnValue] NVARCHAR(200) NULL
	,[ValueCount] INT NOT NULL
	,[ColumnHistogramTypeID] INT NOT NULL
)
GO
ALTER TABLE [dbo].[ColumnHistogram] ADD CONSTRAINT [ColumnHistogram_PK] PRIMARY KEY CLUSTERED ([ColumnHistogramID])
GO

IF OBJECT_ID('[dbo].[ColumnHistogramType]') IS NOT NULL
	DROP TABLE [dbo].[ColumnHistogramType];
GO
CREATE TABLE [dbo].[ColumnHistogramType] (
	[ColumnHistogramTypeID] INT IDENTITY(1, 1) NOT NULL
	,[ColumnHistogramTypeDesc] VARCHAR(100) NOT NULL
)
GO
ALTER TABLE [dbo].[ColumnHistogramType] ADD CONSTRAINT [ColumnHistogramType_PK] PRIMARY KEY CLUSTERED ([ColumnHistogramTypeID])
GO
INSERT INTO dbo.ColumnHistogramType VALUES ('StandAloneColumnHistogram')
INSERT INTO dbo.ColumnHistogramType VALUES ('RecordMatchColumnHistogram')
INSERT INTO dbo.ColumnHistogramType VALUES ('PreEtlKeyMisMatchColumnHistogram')
INSERT INTO dbo.ColumnHistogramType VALUES ('PostEtlKeyMisMatchColumnHistogram')
INSERT INTO dbo.ColumnHistogramType VALUES ('KeyMatchValueMatchColumnHistogram')
INSERT INTO dbo.ColumnHistogramType VALUES ('PreEtlKeyMatchValueMisMatchColumnHistogram')
INSERT INTO dbo.ColumnHistogramType VALUES ('PostEtlKeyMatchValueMisMatchColumnHistogram')
GO
SELECT * FROM [dbo].[ColumnHistogramType]
-- ALTER TABLE [dbo].[ColumnProfile] WITH CHECK ADD CONSTRAINT [TableProfile_ColumnProfile_FK1] FOREIGN KEY (
-- [TableProfileID]
-- )
-- REFERENCES [dbo].[TableProfile] (
-- [TableProfileID]
-- )
-- ALTER TABLE [dbo].[ColumnProfile] WITH CHECK ADD CONSTRAINT [ColumnProfileType_ColumnProfile_FK1] FOREIGN KEY (
-- [ColumnProfileTypeID]
-- )
-- REFERENCES [dbo].[ColumnProfileType] (
-- [ColumnProfileTypeID]
-- )
-- GO
-- GO
-- ALTER TABLE [dbo].[TableProfile] WITH CHECK ADD CONSTRAINT [TableProfileType_TableProfile_FK1] FOREIGN KEY (
-- [TableProfileTypeID]
-- )
-- REFERENCES [dbo].[TableProfileType] (
-- [TableProfileTypeID]
-- )
-- ALTER TABLE [dbo].[TableProfile] WITH CHECK ADD CONSTRAINT [TestConfig_TableProfile_FK1] FOREIGN KEY (
-- [TestConfigID]
-- )
-- REFERENCES [dbo].[TestConfig] (
-- [TestConfigID]
-- )
-- ALTER TABLE [dbo].[TableProfile] WITH CHECK ADD CONSTRAINT [DataRequestTestConfig_TableProfile_FK1] FOREIGN KEY (
-- [TestConfigID]
-- )
-- REFERENCES [dbo].[DataRequestTestConfig] (
-- [DataRequestTestConfigID]
-- )
-- GO
-- ALTER TABLE [dbo].[ColumnHistogram] WITH CHECK ADD CONSTRAINT [ColumnHistogramType_ColumnHistogram_FK1] FOREIGN KEY (
-- [ColumnHistogramTypeID]
-- )
-- REFERENCES [dbo].[ColumnHistogramType] (
-- [ColumnHistogramTypeID]
-- )
-- ALTER TABLE [dbo].[ColumnHistogram] WITH CHECK ADD CONSTRAINT [ColumnProfile_ColumnHistogram_FK1] FOREIGN KEY (
-- [ColumnProfileID]
-- )
-- REFERENCES [dbo].[ColumnProfile] (
-- [ColumnProfileID]
-- )
-- GO
-- ALTER TABLE [dbo].[TestConfig] WITH CHECK ADD CONSTRAINT [TestType_TestConfig_FK1] FOREIGN KEY (
-- [TestTypeID]
-- )
-- REFERENCES [dbo].[TestType] (
-- [TestTypeID]
-- )
-- ALTER TABLE [dbo].[TestConfig] WITH CHECK ADD CONSTRAINT [DataRequestTestConfig_TestConfig_FK1] FOREIGN KEY (
-- [DataRequestTestConfigID]
-- )
-- REFERENCES [dbo].[DataRequestTestConfig] (
-- [DataRequestTestConfigID]
-- )
-- GO
GO

