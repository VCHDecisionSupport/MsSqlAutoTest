--CREATE TABLE A (
--	id int not null
--	,abc varchar(12)
--	,w int
--	,x char(10) NOT NULL
--	,y varchar(12)
--	,z AS PI()
--	,CONSTRAINT pkA PRIMARY KEY CLUSTERED (id)
--);

--CREATE TABLE B (
--	id int identity(1,1)
--	,abc varchar(12)
--	,w int NOT NULL
--	,x char(10) NOT NULL
--	,y varchar(12)
--	,z numeric(12,5)
--	,waldo nvarchar(32)
--	,CONSTRAINT pkB PRIMARY KEY CLUSTERED (id)
--);
USE TestLog
GO

WITH A AS(
	SELECT
	col.name
	,typ.name AS typ
	,col.max_length
	FROM TestLog.sys.schemas AS sch
	INNER JOIN TestLog.sys.tables AS tab
	ON sch.schema_id = tab.schema_id
	INNER JOIN TestLog.sys.columns AS col
	ON col.object_id = tab.object_id
	INNER JOIN TestLog.sys.types AS typ
	ON typ.system_type_id = col.system_type_id
	WHERE sch.name = 'dbo'
	AND tab.name = 'A'
), B AS (
	SELECT
	col.name
	,typ.name AS typ
	,col.max_length

	FROM TestLog.sys.schemas AS sch
	INNER JOIN TestLog.sys.tables AS tab
	ON sch.schema_id = tab.schema_id
	INNER JOIN TestLog.sys.columns AS col
	ON col.object_id = tab.object_id
	INNER JOIN TestLog.sys.types AS typ
	ON typ.system_type_id = col.system_type_id
	WHERE sch.name = 'dbo'
	AND tab.name = 'B'
)
SELECT *
FROM A
FULL JOIN B
ON A.name = B.name