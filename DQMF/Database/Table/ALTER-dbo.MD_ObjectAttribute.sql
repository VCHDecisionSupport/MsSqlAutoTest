USE DQMF
GO

DECLARE @name varchar(200) = 'MD_ObjectAttribute';
RAISERROR(@name, 1, 1) WITH NOWAIT;

IF NOT EXISTS(SELECT * FROM sys.columns WHERE OBJECT_NAME(object_id) = @name AND name = 'IsBusinessKey')
	ALTER TABLE DQMF.dbo.MD_ObjectAttribute ADD IsBusinessKey bit NULL;

IF NOT EXISTS(SELECT * FROM sys.columns WHERE OBJECT_NAME(object_id) = @name AND name = 'IsDistinct')
	ALTER TABLE DQMF.dbo.MD_ObjectAttribute ADD IsDistinct bit NULL;

IF NOT EXISTS(SELECT * FROM sys.columns WHERE OBJECT_NAME(object_id) = @name AND name = 'FkReference')
	ALTER TABLE DQMF.dbo.MD_ObjectAttribute ADD FkReference varchar(200) NULL;

