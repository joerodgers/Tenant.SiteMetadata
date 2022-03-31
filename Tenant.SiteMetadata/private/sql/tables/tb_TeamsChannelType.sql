IF OBJECT_ID('dbo.TeamsChannelType', 'U') IS NULL
BEGIN
	CREATE TABLE dbo.TeamsChannelType
	(
        Id               int           NOT NULL,
        TeamsChannelType nvarchar(100) NOT NULL,
        CONSTRAINT PK_TeamsChannelType_Id PRIMARY KEY CLUSTERED (Id ASC)
    )
	INSERT INTO TeamsChannelType (Id, TeamsChannelType) VALUES (0, 'None')
	INSERT INTO TeamsChannelType (Id, TeamsChannelType) VALUES (1, 'Private Channel')
	INSERT INTO TeamsChannelType (Id, TeamsChannelType) VALUES (2, 'Shared Channel')
	INSERT INTO TeamsChannelType (Id, TeamsChannelType) VALUES (3, 'Standard Channel')
END