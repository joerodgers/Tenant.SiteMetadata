IF OBJECT_ID('dbo.TimeZone', 'U') IS NULL
BEGIN
	CREATE TABLE dbo.TimeZone
	(
        Id            int           NOT NULL,
        Identifier    nvarchar(100) NOT NULL,
        [Description] nvarchar(100) NOT NULL,
		CONSTRAINT PK_TimeZone_Id PRIMARY KEY CLUSTERED (Id ASC)
    )
END