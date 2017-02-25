---------------------------------------------------
-- create AutoTest database
---------------------------------------------------
USE master
GO

IF DB_ID('AutoTest') IS NULL
BEGIN
	PRINT('CREATE DATABASE AutoTest')
	CREATE DATABASE AutoTest;
END
GO