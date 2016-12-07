USE TestLog
GO

DECLARE @sql nvarchar(max);
DECLARE @params nvarchar(max);

DECLARE fk_cur CURSOR
FOR
SELECT tab.name AS TableName, fk.name AS ForeignKeyName
FROM sys.foreign_keys AS fk
JOIN sys.tables AS tab
ON fk.parent_object_id = tab.object_id
WHERE tab.name NOT LIKE '%sys%'
AND tab.name LIKE 'MD%'

OPEN fk_cur;

DECLARE @tb_name varchar(128);
DECLARE @fk_name varchar(128);

FETCH NEXT FROM fk_cur INTO @tb_name, @fk_name;

WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @tb_name, @fk_name;

	SET @sql = 'ALTER TABLE '+@tb_name +' DROP CONSTRAINT '+ @fk_name;
	PRINT @sql
	EXEC(@sql);
	FETCH NEXT FROM fk_cur INTO @tb_name, @fk_name;
END
GO
CLOSE fk_cur;
DEALLOCATE fk_cur;
GO

DROP TABLE MD_Object;

DROP TABLE MD_Database;

SELECT *
INTO MD_Database
FROM DQMF.dbo.MD_Database;

SELECT *
INTO MD_Object
FROM DQMF.dbo.MD_Object;

ALTER TABLE MD_Object ALTER COLUMN DatabaseID int NOT NULL;
ALTER TABLE MD_Database ALTER COLUMN DatabaseID int NOT NULL;
ALTER TABLE MD_Object ADD CONSTRAINT Pk_MD_Object_ObjectID PRIMARY KEY (ObjectID);
ALTER TABLE MD_Database ADD CONSTRAINT Pk_MD_Database_DatabaseID PRIMARY KEY (DatabaseID);
CREATE INDEX Ix_MD_Object_DatabaseID ON MD_Object(DatabaseID);
ALTER TABLE MD_Object ADD CONSTRAINT Fk_MD_Object_MD_Database FOREIGN KEY (DatabaseID) REFERENCES MD_Database(DatabaseID) ON DELETE CASCADE;


