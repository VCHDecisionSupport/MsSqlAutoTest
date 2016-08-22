USE AutoTest
GO

--#region Foreign Key to Dim-like tables
IF OBJECT_ID('FK_TestType','F') IS NOT NULL
BEGIN
	ALTER TABLE dbo.TestConfig
	DROP CONSTRAINT FK_TestType;
END;

ALTER TABLE dbo.TestConfig WITH NOCHECK
ADD CONSTRAINT FK_TestType FOREIGN KEY (TestTypeID)
	REFERENCES dbo.TestType(TestTypeID);

IF OBJECT_ID('FK_TableProfileType','F') IS NOT NULL
BEGIN
	ALTER TABLE dbo.TableProfile
	DROP CONSTRAINT FK_TableProfileType;
END;

ALTER TABLE dbo.TableProfile WITH NOCHECK
ADD CONSTRAINT FK_TableProfileType FOREIGN KEY (TableProfileTypeID)
	REFERENCES dbo.TableProfileType(TableProfileTypeID);

IF OBJECT_ID('FK_ColumnProfileType','F') IS NOT NULL
BEGIN
	ALTER TABLE dbo.ColumnProfile
	DROP CONSTRAINT FK_ColumnProfileType;
END;

ALTER TABLE dbo.ColumnProfile WITH NOCHECK
ADD CONSTRAINT FK_ColumnProfileType FOREIGN KEY (ColumnProfileTypeID)
	REFERENCES dbo.ColumnProfileType(ColumnProfileTypeID);

IF OBJECT_ID('FK_ColumnHistogramType','F') IS NOT NULL
BEGIN
	ALTER TABLE dbo.ColumnHistogram
	DROP CONSTRAINT FK_ColumnHistogramType;
END;

ALTER TABLE dbo.ColumnHistogram WITH NOCHECK
ADD CONSTRAINT FK_ColumnHistogramType FOREIGN KEY (ColumnHistogramTypeID)
	REFERENCES dbo.ColumnHistogramType(ColumnHistogramTypeID);
--#endregion Foreign Key to Dim-like tables

--#region Foreign Key between Fact-like tables
IF OBJECT_ID('FK_TableProfile_TestConfig','F') IS NOT NULL
BEGIN
	ALTER TABLE dbo.TableProfile
	DROP CONSTRAINT FK_TableProfile_TestConfig;
END;

ALTER TABLE dbo.TableProfile WITH NOCHECK
ADD CONSTRAINT FK_TableProfile_TestConfig FOREIGN KEY (TestConfigID)
	REFERENCES dbo.TestConfig(TestConfigID);

IF OBJECT_ID('FK_ColumnProfile_TableProfile','F') IS NOT NULL
BEGIN
	ALTER TABLE dbo.ColumnProfile
	DROP CONSTRAINT FK_ColumnProfile_TableProfile;
END;

ALTER TABLE dbo.ColumnProfile WITH NOCHECK
ADD CONSTRAINT FK_ColumnProfile_TableProfile FOREIGN KEY (TableProfileID)
	REFERENCES dbo.TableProfile(TableProfileID);

IF OBJECT_ID('FK_ColumnHistogram_ColumnProfile','F') IS NOT NULL
BEGIN
	ALTER TABLE dbo.ColumnHistogram
	DROP CONSTRAINT FK_ColumnHistogram_ColumnProfile;
END;

ALTER TABLE dbo.ColumnHistogram WITH NOCHECK
ADD CONSTRAINT FK_ColumnHistogram_ColumnProfile FOREIGN KEY (ColumnProfileID)
	REFERENCES dbo.ColumnProfile(ColumnProfileID);
--#endregion Foreign Key between Fact-like tables
