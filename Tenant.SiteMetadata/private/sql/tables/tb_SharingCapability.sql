IF OBJECT_ID('dbo.SharingCapability', 'U') IS NULL
BEGIN
	CREATE TABLE dbo.SharingCapability
	(
        [Id]              int           NOT NULL,
        SharingCapability nvarchar(100) NOT NULL,
        CONSTRAINT PK_SharingCapability_Id PRIMARY KEY CLUSTERED (Id ASC)
    )
	INSERT INTO SharingCapability (Id, [SharingCapability]) VALUES (-1, 'Unknown')
END