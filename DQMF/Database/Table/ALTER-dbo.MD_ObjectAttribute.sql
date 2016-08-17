USE DQMF
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE OBJECT_NAME(object_id) = 'MD_ObjectAttribute' AND name = 'IsBusinessKey')
	ALTER TABLE DQMF.dbo.MD_ObjectAttribute ADD IsBusinessKey int NULL;

