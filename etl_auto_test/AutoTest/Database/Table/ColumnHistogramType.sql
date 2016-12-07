USE AutoTest
GO

DECLARE @name varchar(100) = 'dbo.ColumnHistogramType'
RAISERROR(@name,1,1) WITH NOWAIT;

IF OBJECT_ID('dbo.ColumnHistogramType') IS NOT NULL
	DROP TABLE dbo.ColumnHistogramType;
GO
CREATE TABLE dbo.ColumnHistogramType (
	ColumnHistogramTypeID INT IDENTITY(1, 1) NOT NULL
	,ColumnHistogramTypeDesc VARCHAR(100) NOT NULL
)
GO
ALTER TABLE dbo.ColumnHistogramType ADD CONSTRAINT ColumnHistogramType_PK PRIMARY KEY CLUSTERED (ColumnHistogramTypeID)
GO
INSERT INTO dbo.ColumnHistogramType VALUES ('StandAloneColumnHistogram')
INSERT INTO dbo.ColumnHistogramType VALUES ('RecordMatchColumnHistogram')
INSERT INTO dbo.ColumnHistogramType VALUES ('PreEtlKeyMisMatchColumnHistogram')
INSERT INTO dbo.ColumnHistogramType VALUES ('PostEtlKeyMisMatchColumnHistogram')
INSERT INTO dbo.ColumnHistogramType VALUES ('KeyMatchValueMatchColumnHistogram')
INSERT INTO dbo.ColumnHistogramType VALUES ('PreEtlKeyMatchValueMisMatchColumnHistogram')
INSERT INTO dbo.ColumnHistogramType VALUES ('PostEtlKeyMatchValueMisMatchColumnHistogram')
GO