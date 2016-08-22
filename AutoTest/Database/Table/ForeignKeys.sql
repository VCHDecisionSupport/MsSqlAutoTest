USE AutoTest
GO


ALTER TABLE dbo.TestConfig     
ADD CONSTRAINT FK_TestType FOREIGN KEY (TestTypeID)     
    REFERENCES dbo.TestType(TestTypeID)
;    