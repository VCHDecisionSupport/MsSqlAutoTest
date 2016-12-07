--#region CREATE/ALTER PROC
USE TestLog
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspInsAutoTestConfig';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspInsAutoTestConfig
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
	DECLARE @fmt nvarchar(4000);
	SELECT @fmt=REPLICATE(char(13), 4)+'  uspInsAutoTestConfig'
	RAISERROR(@fmt, 0, 1) WITH NOWAIT;
	
	DECLARE @sql nvarchar(max);
	DECLARE @param nvarchar(max);
	;with stg_fact AS (
	SELECT sub2.*
	FROM (
	SELECT sub.*
		,ROW_NUMBER() OVER(PARTITION BY factTableName ORDER BY commonColCount DESC) as commonColRank
		,1.0*commonColCount/(MAX(commonColCount) OVER(PARTITION BY factTableName ORDER BY commonColCount DESC)) as commonColPercent
		--,ISNULL(1.*sub.commonColCount/(LAG(sub.commonColCount) OVER(PARTITION BY factTableName ORDER BY sub.commonColCount DESC)),1.0)  as maxCommonColCountIndicator
	FROM (
	SELECT 
		fact.ObjectPhysicalName AS factTableName
		,fact.ObjectSchemaName +'.'+fact.ObjectPhysicalName AS factFullName
		,stg.ObjectPhysicalName AS stgTableName
		,ROW_NUMBER() OVER(PARTITION BY fact.ObjectPhysicalName, stg.ObjectPhysicalName ORDER BY fact_attr.AttributePhysicalName) as commonColCount
		,LEAD(stg.ObjectPhysicalName) OVER(PARTITION BY fact.ObjectPhysicalName, stg.ObjectPhysicalName ORDER BY fact_attr.AttributePhysicalName) as maxCommonColCountIndicator
		,stg.ObjectSchemaName +'.'+stg.ObjectPhysicalName AS stgFullName
		,stg.ObjectID AS stgObjectID
		,fact.ObjectID AS factObjectID
	FROM DQMF.dbo.MD_Object fact
	JOIN DQMF.dbo.MD_ObjectAttribute AS fact_attr
	ON fact.objectid = fact_attr.objectid
	CROSS JOIN DQMF.dbo.MD_Object AS stg
	JOIN DQMF.dbo.MD_ObjectAttribute AS stg_attr
	ON stg.objectid = stg_attr.objectid
	AND stg_attr.AttributePhysicalName = fact_attr.AttributePhysicalName
	WHERE 1=1
	AND fact.IsActive=1
	AND fact.IsObjectInDB = 1
	AND fact.ObjectSchemaName NOT IN ('Staging','Dim')
	AND fact.ObjectType LIKE 'Table'
	AND fact.DatabaseId = 2
	AND stg.IsActive=1
	AND stg.IsObjectInDB = 1
	AND stg.ObjectSchemaName LIKE 'Staging'
	AND stg.DatabaseId = 2
	) sub
	WHERE 1=1
	AND sub.maxCommonColCountIndicator IS NULL
	) sub2
	WHERE sub2.commonColRank = 1)


	SELECT
		DISTINCT
		--MAX(ISNULL(pkg.PkgName,0)) AS pkg,
		pkg.PkgName
		,obj.ObjectID
		,obj.ObjectPhysicalName
		--stg_fact.stgFullName
		--,stg_fact.factFullName
	FROM DQMF.dbo.ETL_Package AS pkg
	JOIN DQMF.dbo.DQMF_Schedule AS sch
	ON pkg.PkgID = sch.PkgKey
	JOIN DQMF.dbo.DQMF_BizRuleSchedule AS br_sch
	ON sch.DQMF_ScheduleId = br_sch.ScheduleID
	JOIN DQMF.dbo.DQMF_BizRule AS br
	ON br.BRId = br_sch.BRID
	LEFT JOIN DQMF.dbo.MD_ObjectAttribute AS attr
	ON br.FactTableObjectAttributeId = attr.ObjectAttributeID
	LEFT JOIN DQMF.dbo.MD_Object AS obj
	ON obj.ObjectID = attr.ObjectID
	LEFT JOIN DQMF.dbo.MD_SubjectArea AS sub
	ON obj.SubjectAreaID = sub.SubjectAreaID
	FULL JOIN stg_fact
	ON br.TargetObjectPhysicalName = stg_fact.stgFullName
	WHERE 1=1
	AND pkg.IsACtive=1
	AND obj.ObjectID IS NOT NULL


	SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
	RAISERROR('!uspInsAutoTestConfig: runtime: %i seconds', 0, 1, @runtime) WITH NOWAIT;
	RETURN(@runtime);
END
GO
--#endregion CREATE/ALTER PROC
--EXEC dbo.uspInsAutoTestConfig
