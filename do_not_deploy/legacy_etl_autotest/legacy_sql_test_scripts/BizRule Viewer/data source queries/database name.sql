
SELECT *
FROM (
SELECT 
	db.DatabaseId, db.DatabaseName, db.DatabaseLongDescription, db.DatabaseShortDescription
	,COUNT(*) AS br_count
FROM DQMF.dbo.MD_Database AS db
JOIN DQMF.dbo.DQMF_BizRule AS br
ON db.DatabaseId = br.DatabaseId
GROUP BY db.DatabaseId, db.DatabaseName, db.DatabaseLongDescription, db.DatabaseShortDescription
) sub
ORDER BY sub.br_count DESC