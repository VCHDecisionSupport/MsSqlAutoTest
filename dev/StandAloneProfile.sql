DECLARE @TestTypeID int;
DECLARE @TableProfileTypeID int;
DECLARE @ColumnProfileTypeID int;
DECLARE @ColumnHistogramTypeID int;
SELECT @TestTypeID = TestTypeID FROM AutoTest.dbo.TestType WHERE TestTypeDesc = 'StandAloneTableProfile'
SELECT @TableProfileTypeID = TableProfileTypeID FROM AutoTest.dbo.TableProfileType WHERE TableProfileTypeDesc = 'StandAloneTableProfile'
SELECT @ColumnProfileTypeID = ColumnProfileTypeID FROM AutoTest.dbo.ColumnProfileType WHERE ColumnProfileTypeDesc = 'StandAloneColumnProfile'
SELECT @ColumnHistogramTypeID = ColumnHistogramTypeID FROM AutoTest.dbo.ColumnHistogramType WHERE ColumnHistogramTypeDesc = 'StandAloneColumnHistogram'



DECLARE @pTestConfigID int = 25;
SELECT @pTestConfigID=MAX(TestConfigID) FROM AutoTest.dbo.TestConfig
SET @pTestConfigID = 25;
DECLARE @PreEtlKeyMisMatchSnapShotName varchar(100)
SELECT @PreEtlKeyMisMatchSnapShotName = RecordMatchSnapShotName
FROM AutoTest.dbo.TestConfig WHERE TestConfigID = @pTestConfigID
