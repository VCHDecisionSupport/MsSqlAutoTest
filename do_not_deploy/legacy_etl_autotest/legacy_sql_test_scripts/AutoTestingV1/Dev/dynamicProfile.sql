--SELECT @sql = FORMATMESSAGE('SELECT %s FROM CommunityMart.dbo.AssessmentContactFact AS pre',@cols)
--PRINT @sql

--SELECT *
--FROM (
--SELECT @pObjectID AS ObjectID, COUNT(DISTINCT pre.SourceAssessmentID) AS SourceAssessmentID, COUNT(DISTINCT pre.SourceContactKey) AS SourceContactKey, COUNT(DISTINCT pre.UDFTable) AS UDFTable, COUNT(DISTINCT pre.ContactDateID) AS ContactDateID, COUNT(DISTINCT pre.ContactTypeID) AS ContactTypeID, COUNT(DISTINCT pre.deplicatedCommunityLocationID) AS deplicatedCommunityLocationID, COUNT(DISTINCT pre.CreateDate) AS CreateDate, COUNT(DISTINCT pre.AmendedDate) AS AmendedDate, COUNT(DISTINCT pre.SourceUpdateDate) AS SourceUpdateDate, COUNT(DISTINCT pre.IsVoid) AS IsVoid, COUNT(DISTINCT pre.IsInvalid) AS IsInvalid, COUNT(DISTINCT pre.ETLAuditID) AS ETLAuditID, COUNT(DISTINCT pre.GestationWeek) AS GestationWeek, COUNT(DISTINCT pre.CommunityServiceLocationID) AS CommunityServiceLocationID, COUNT(DISTINCT pre.BreastFeedingLkupID) AS BreastFeedingLkupID, COUNT(DISTINCT pre.AgeIntervalLkupID) AS AgeIntervalLkupID FROM CommunityMart.dbo.AssessmentContactFact AS pre
--) AS s
--UNPIVOT 
--(
--	DistinctCount FOR ColumnName IN (SourceAssessmentID, SourceContactKey, UDFTable, ContactDateID, ContactTypeID, deplicatedCommunityLocationID, CreateDate, AmendedDate, SourceUpdateDate, IsVoid, IsInvalid, ETLAuditID, GestationWeek, CommunityServiceLocationID, BreastFeedingLkupID, AgeIntervalLkupID)
--) AS pvt

GO
DECLARE @tableName nvarchar(100) = 'CommunityMart.dbo.AssessmentContactFact';
DECLARE @objectID int = 53913;

DECLARE @sql nvarchar(max);
DECLARE @param nvarchar(max);
DECLARE @pAggFmt nvarchar(max) = ', COUNT(DISTINCT %s) AS %s'
DECLARE @AggCols nvarchar(max);
SELECT @AggCols=dbo.ufnGetColumnNames(@objectID,@pAggFmt)
DECLARE @cols nvarchar(max);
SELECT @cols=dbo.ufnGetColumnNames(@objectID,null)
DECLARE @TableProfileID int = 1
DECLARE @ColumnProfileTypeID int = 2

SET @sql = FORMATMESSAGE('
INSERT INTO TestLog.dbo.ColumnProfile (ColumnID, DistinctCount, TableProfileID, ColumnProfileTypeID)
output iNSERTED.*
SELECT attr.Sequence AS ColumnID, pvt.DistinctCount, %i AS TableProfileID, %i AS ColumnProfileTypeID
FROM (
SELECT %i AS ObjectID, %s FROM %s
) AS sub
UNPIVOT 
(
	DistinctCount FOR ColumnName IN (%s)
) AS pvt
JOIN DQMF.dbo.MD_ObjectAttribute AS attr
ON attr.AttributePhysicalName = pvt.ColumnName
AND attr.ObjectID = pvt.ObjectID
',@TableProfileID, @ColumnProfileTypeID, @objectID, @AggCols, @tableName, @cols)
PRINT @sql
EXEC(@sql);


SET @pAggFmt = FORMATMESSAGE(' INSERT INTO TestLog.dbo.ColumnHistogram (ColumnProfileID, ColumnValue, ValueCount, ColumnHistogramTypeID) SELECT TOP 500 pro.ColumnProfileID AS ColumnProfileID, ISNULL(CAST(%s AS varchar(100)), ''NULL'') AS ColumnValue, COUNT(*) AS ValueCount, %i AS ColumnHistogramTypeID FROM %s JOIN DQMF.dbo.MD_ObjectAttribute as attr ON attr.AttributePhysicalName = ''%s'' AND attr.ObjectID = %i JOIN ColumnProfile as pro ON pro.TableProfileID = %i AND pro.ColumnID = attr.Sequence GROUP BY %s, pro.ColumnProfileID ORDER BY COUNT(*) DESC; ', '%s', 666, @tableName, '%s',@objectID,@TableProfileID, '%s');
PRINT @pAggFmt
SELECT @AggCols=dbo.ufnGetColumnNames(@objectID,@pAggFmt)
PRINT @AggCols
EXEC(@AggCols)


--INSERT INTO TestLog.dbo.ColumnHistogram (ColumnProfileID, ColumnValue, ValueCount, ColumnHistogramTypeID) SELECT TOP 500 pro.ColumnProfileID, SourceAssessmentID AS ColumnValue, COUNT(*) AS ValueCount, 2 AS ColumnHistogramTypeID FROM CommunityMart.dbo.AssessmentContactFact 
--JOIN DQMF.dbo.MD_ObjectAttribute as attr
--ON attr.AttributePhysicalName = 'SourceAssessmentID'
--AND attr.ObjectID = 53913
--JOIN ColumnProfile as pro
--ON pro.TableProfileID = 1
--AND pro.ColumnID = attr.Sequence


--GROUP BY SourceAssessmentID, pro.ColumnProfileID ORDER BY COUNT(*) DESC;


INSERT INTO TestLog.dbo.ColumnHistogram (ColumnProfileID, ColumnValue, ValueCount, ColumnHistogramTypeID) SELECT TOP 500 pro.ColumnProfileID AS ColumnProfileID, ISNULL(CAST(SourceAssessmentID AS varchar(100)), 'NULL') AS ColumnValue, COUNT(*) AS ValueCount, 666 AS ColumnHistogramTypeID FROM CommunityMart.dbo.AssessmentContactFact JOIN DQMF.dbo.MD_ObjectAttribute as attr ON attr.AttributePhysicalName = 'SourceAssessmentID' AND attr.ObjectID = 53913 JOIN ColumnProfile as pro ON pro.TableProfileID = 1 AND pro.ColumnID = attr.Sequence GROUP BY SourceAssessmentID, pro.ColumnProfileID ORDER BY COUNT(*) DESC; 

INSERT INTO TestLog.dbo.ColumnHistogram (ColumnProfileID, ColumnValue, ValueCount, ColumnHistogramTypeID) SELECT TOP 500 pro.ColumnProfileID AS ColumnProfileID, ISNULL(CAST(SourceAssessmentID AS varchar(100)), 'NULL') AS ColumnValue, COUNT(*) AS ValueCount, 666 AS ColumnHistogramTypeID FROM CommunityMart.dbo.AssessmentContactFact JOIN DQMF.dbo.MD_ObjectAttribute as attr ON attr.AttributePhysicalName = 'SourceAssessmentID' AND attr.ObjectID = 53913 JOIN ColumnProfile as pro ON pro.TableProfileID = 1 AND pro.ColumnID = attr.Sequence GROUP BY SourceAssessmentID, pro.ColumnProfileID ORDER BY COUNT(*) DESC;  INSERT INTO TestLog.dbo.ColumnHistogram (ColumnProfileID, ColumnValue, ValueCount, ColumnHistogramTypeID) SELECT TOP 500 pro.ColumnProfileID AS ColumnProfileID, ISNULL(CAST(SourceContactKey AS varchar(100)), 'NULL') AS ColumnValue, COUNT(*) AS ValueCount, 666 AS ColumnHistogramTypeID FROM CommunityMart.dbo.AssessmentContactFact JOIN DQMF.dbo.MD_ObjectAttribute as attr ON attr.AttributePhysicalName = 'SourceContactKey' AND attr.ObjectID = 53913 JOIN ColumnProfile as pro ON pro.TableProfileID = 1 AND pro.ColumnID = attr.Sequence GROUP BY SourceContactKey, pro.ColumnProfileID ORDER BY COUNT(*) DESC;  INSERT INTO TestLog.dbo.ColumnHistogram (ColumnProfileID, ColumnValue, ValueCount, ColumnHistogramTypeID) SELECT TOP 500 pro.ColumnProfileID AS ColumnProfileID, ISNULL(CAST(UDFTable AS varchar(100)), 'NULL') AS ColumnValue, COUNT(*) AS ValueCount, 666 AS ColumnHistogramTypeID FROM CommunityMart.dbo.AssessmentContactFact JOIN DQMF.dbo.MD_ObjectAttribute as attr ON attr.AttributePhysicalName = 'UDFTable' AND attr.ObjectID = 53913 JOIN ColumnProfile as pro ON pro.TableProfileID = 1 AND pro.ColumnID = attr.Sequence GROUP BY UDFTable, pro.ColumnProfileID ORDER BY COUNT(*) DESC;  INSERT INTO TestLog.dbo.ColumnHistogram (ColumnProfileID, ColumnValue, ValueCount, ColumnHistogramTypeID) SELECT TOP 500 pro.ColumnProfileID AS ColumnProfileID, ISNULL(CAST(ContactDateID AS varchar(100)), 'NULL') AS ColumnValue, COUNT(*) AS ValueCount, 666 AS ColumnHistogramTypeID FROM CommunityMart.dbo.AssessmentContactFact JOIN DQMF.dbo.MD_ObjectAttribute as attr ON attr.AttributePhysicalName = 'ContactDateID' AND attr.ObjectID = 53913 JOIN ColumnProfile as pro ON pro.TableProfileID = 1 AND pro.ColumnID = attr.Sequence GROUP BY ContactDateID, pro.ColumnProfileID ORDER BY COUNT(*) DESC;  INSERT INTO TestLog.dbo.ColumnHistogram (ColumnProfileID, ColumnValue, ValueCount, ColumnHistogramTypeID) SELECT TOP 500 pro.ColumnProfileID AS ColumnProfileID, ISNULL(CAST(ContactTypeID AS varchar(100)), 'NULL') AS ColumnValue, COUNT(*) AS ValueCount, 666 AS ColumnHistogramTypeID FROM CommunityMart.dbo.AssessmentContactFact JOIN DQMF.dbo.MD_ObjectAttribute as attr ON attr.AttributePhysicalName = 'ContactTypeID' AND attr.ObjectID = 53913 JOIN ColumnProfile as pro ON pro.TableProfileID = 1 AND pro.ColumnID = attr.Sequence GROUP BY ContactTypeID, pro.ColumnProfileID ORDER BY COUNT(*) DESC;  INSERT INTO TestLog.dbo.ColumnHistogram (ColumnProfileID, ColumnValue, ValueCount, ColumnHistogramTypeID) SELECT TOP 500 pro.ColumnProfileID AS ColumnProfileID, ISNULL(CAST(deplicatedCommunityLocationID AS varchar(100)), 'NULL') AS ColumnValue, COUNT(*) AS ValueCount, 666 AS ColumnHistogramTypeID FROM CommunityMart.dbo.AssessmentContactFact JOIN DQMF.dbo.MD_ObjectAttribute as attr ON attr.AttributePhysicalName = 'deplicatedCommunityLocationID' AND attr.ObjectID = 53913 JOIN ColumnProfile as pro ON pro.TableProfileID = 1 AND pro.ColumnID = attr.Sequence GROUP BY deplicatedCommunityLocationID, pro.ColumnProfileID ORDER BY COUNT(*) DESC;  INSERT INTO TestLog.dbo.ColumnHistogram (ColumnProfileID, ColumnValue, ValueCount, ColumnHistogramTypeID) SELECT TOP 500 pro.ColumnProfileID AS ColumnProfileID, ISNULL(CAST(CreateDate AS varchar(100)), 'NULL') AS ColumnValue, COUNT(*) AS ValueCount, 666 AS ColumnHistogramTypeID FROM CommunityMart.dbo.AssessmentContactFact JOIN DQMF.dbo.MD_ObjectAttribute as attr ON
