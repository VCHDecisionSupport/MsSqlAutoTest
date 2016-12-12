DECLARE @TableName varchar(500);
DECLARE @ColumnName varchar(500);
DECLARE @sql varchar(max);

SET @TableName = 'CommunityMart.dbo.ReferralFact'
SET @ColumnName = 'ReferralReasonID'

BEGIN
	
	

	SET @sql = '
SELECT 
	GETDATE() AS ColumnHistogramDate
	,'''+@TableName+''' AS TableName
	,'''+@ColumnName+''' AS ColumnName
	,'+@ColumnName+' AS ColumnValue
	,COUNT(*) AS ValueCount
FROM '+@TableName+'
GROUP BY '+@ColumnName+';';

RAISERROR(@sql,0,1) WITH NOWAIT;

EXEC(@sql);

END


