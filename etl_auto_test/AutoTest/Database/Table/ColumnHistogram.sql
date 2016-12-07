USE AutoTest
GO

DECLARE @name varchar(100) = 'dbo.ColumnHistogram'
RAISERROR(@name,1,1) WITH NOWAIT;

IF OBJECT_ID('dbo.ColumnHistogram') IS NOT NULL
	DROP TABLE dbo.ColumnHistogram;
GO
CREATE TABLE dbo.ColumnHistogram (
	ColumnHistogramID INT IDENTITY(1, 1) NOT NULL
	,ColumnProfileID INT NOT NULL
	,ColumnValue NVARCHAR(200) NULL
	,ValueCount INT NOT NULL
	,ColumnHistogramTypeID INT NOT NULL
)
GO
ALTER TABLE dbo.ColumnHistogram ADD CONSTRAINT ColumnHistogram_PK PRIMARY KEY CLUSTERED (ColumnHistogramID)
GO