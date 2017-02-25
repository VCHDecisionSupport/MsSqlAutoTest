---------------------------------------------------
-- create AutoTest database
---------------------------------------------------
USE master
GO

/*
2017-02-27 Graham Crowell DR9581 initial deployment
*/

IF DB_ID('AutoTest') IS NULL
BEGIN
	PRINT('CREATE DATABASE AutoTest')
	CREATE DATABASE AutoTest;
END
GO