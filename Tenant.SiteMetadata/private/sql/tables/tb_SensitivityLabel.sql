IF OBJECT_ID('dbo.SensitivityLabel', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.SensitivityLabel
	(
        Id               uniqueidentifier NOT NULL,
        SensitivityLabel nvarchar(100)    NOT NULL,
        CONSTRAINT PK_SensitivityLabel_Id PRIMARY KEY CLUSTERED (Id ASC)
    )
	INSERT INTO SensitivityLabel (Id, [SensitivityLabel]) VALUES ('00000000-0000-0000-0000-000000000000', 'None/Unknown')
END