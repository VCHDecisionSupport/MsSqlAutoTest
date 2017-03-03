IF DB_ID('GenericProfile') IS NOT NULL
BEGIN
	DROP DATABASE GenericProfile;
END
GO
CREATE DATABASE GenericProfile;
GO
USE GenericProfile
GO

IF OBJECT_ID('dbo.ServerConnection') IS NOT NULL
BEGIN
	DROP TABLE dbo.ServerConnection;
END
CREATE TABLE [dbo].[ServerConnection]
(
	[ServerConnectionId] INT NOT NULL , 
    [ServerName] NCHAR(50) NOT NULL, 
    [DataSourceName] NCHAR(100) NOT NULL, 
    CONSTRAINT [PK_ServerConnection] PRIMARY KEY ([ServerConnectionId])
)

IF OBJECT_ID('dbo.DatabaseSchema') IS NOT NULL
BEGIN
	DROP TABLE dbo.DatabaseSchema;
END
CREATE TABLE [dbo].[DatabaseSchema]
(
	[DatabaseSchemaId] INT NOT NULL, 
    [ServerConnectionId] INT NOT NULL,
	[DatabaseName] NCHAR(100) NOT NULL, 
    [SchemaPath] NCHAR(200) NOT NULL, 
    CONSTRAINT [PK_DatabaseSchema] PRIMARY KEY ([DatabaseSchemaId]),
    CONSTRAINT [FK_DatabaseSchema_ServerConnection] FOREIGN KEY ([ServerConnectionId]) REFERENCES [ServerConnection]([ServerConnectionId])
)

IF OBJECT_ID('dbo.ProfileSource') IS NOT NULL
BEGIN
	DROP TABLE dbo.ProfileSource;
END
CREATE TABLE [dbo].[ProfileSource]
(
	[ProfileSourceId] INT NOT NULL,
	[DatabaseSchemaId] INT NOT NULL,
	[QueryableName] VARCHAR(100) NOT NULL,
    CONSTRAINT [PK_ProfileSource] PRIMARY KEY ([ProfileSourceId]),
    CONSTRAINT [FK_ProfileSource_DatabaseSchema] FOREIGN KEY ([DatabaseSchemaId]) REFERENCES [DatabaseSchema]([DatabaseSchemaId])
)

IF OBJECT_ID('dbo.ProfileField') IS NOT NULL
BEGIN
	DROP TABLE dbo.ProfileField;
END
CREATE TABLE [dbo].[ProfileField]
(
	[ProfileFieldId] INT NOT NULL,
	[ProfileSourceId] INT NOT NULL,
	[ProfileField] VARCHAR(100) NOT NULL,
    CONSTRAINT [PK_ProfileField] PRIMARY KEY ([ProfileFieldId]),
    CONSTRAINT [FK_ProfileField_ProfileSource] FOREIGN KEY ([ProfileSourceId]) REFERENCES [ProfileSource]([ProfileSourceId])
)

IF OBJECT_ID('dbo.FieldValue') IS NOT NULL
BEGIN
	DROP TABLE dbo.FieldValue;
END
CREATE TABLE [dbo].[FieldValue]
(
	[FieldValueId] INT NOT NULL,
	[ProfileFieldId] INT NOT NULL,
	[FieldValue] VARCHAR(100) NOT NULL,
    CONSTRAINT [PK_FieldValue] PRIMARY KEY ([FieldValueId]),
    CONSTRAINT [FK_FieldValue_ProfileField] FOREIGN KEY ([ProfileFieldId]) REFERENCES [ProfileField]([ProfileFieldId])
)

IF OBJECT_ID('dbo.AggregationDefinition') IS NOT NULL
BEGIN
	DROP TABLE dbo.AggregationDefinition;
END
CREATE TABLE [dbo].[AggregationDefinition]
(
	[AggregationDefinitionId] INT NOT NULL,
	[AggregationDefinition] VARCHAR(100) NOT NULL,
    CONSTRAINT [PK_AggregationDefinition] PRIMARY KEY ([AggregationDefinitionId]),
)

IF OBJECT_ID('dbo.AggregationOutput') IS NOT NULL
BEGIN
	DROP TABLE dbo.AggregationOutput;
END
CREATE TABLE [dbo].[AggregationOutput]
(
	[AggregationOutputId] INT NOT NULL,
	[AggregationDefinitionId] INT NOT NULL,
	[AggregationOutput] VARCHAR(100) NOT NULL,
    CONSTRAINT [PK_AggregationOutput] PRIMARY KEY ([AggregationOutputId]),
    CONSTRAINT [FK_AggregationOutput_AggregationDefinition] FOREIGN KEY ([AggregationDefinitionId]) REFERENCES [AggregationDefinition]([AggregationDefinitionId])
)

IF OBJECT_ID('dbo.MapFieldValueAggregation') IS NOT NULL
BEGIN
	DROP TABLE dbo.MapFieldValueAggregation;
END
CREATE TABLE [dbo].[MapFieldValueAggregation]
(
	[FieldValueId] INT NOT NULL,
	[AggregationOutputId] INT NOT NULL,
    CONSTRAINT [PK_MapFieldValueAggregation] PRIMARY KEY ([FieldValueId], [AggregationOutputId]),
    CONSTRAINT [FK_MapFieldValueAggregation_FieldValue] FOREIGN KEY ([FieldValueId]) REFERENCES [FieldValue]([FieldValueId]),
    CONSTRAINT [FK_MapFieldValueAggregation_AggregationOutput] FOREIGN KEY ([AggregationOutputId]) REFERENCES [AggregationOutput]([AggregationOutputId])
)



