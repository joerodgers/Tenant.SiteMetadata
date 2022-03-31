IF OBJECT_ID('dbo.PrincipalType', 'U') IS NULL
BEGIN
	CREATE TABLE dbo.PrincipalType
	(
        Id            int           NOT NULL,
        PrincipalType nvarchar(100) NOT NULL,
        CONSTRAINT PK_PrincipalType_Id PRIMARY KEY CLUSTERED (Id ASC)
    )

	-- Keep in sync with PrincipalType in Enums.ps1
	INSERT INTO PrincipalType (Id, [PrincipalType]) VALUES ( 1,  'Unknown'             )
	INSERT INTO PrincipalType (Id, [PrincipalType]) VALUES ( 2,  'Member'              )
	INSERT INTO PrincipalType (Id, [PrincipalType]) VALUES ( 4,  'Guest'               )
	INSERT INTO PrincipalType (Id, [PrincipalType]) VALUES ( 8,  'Microsoft 365 Group' )
	INSERT INTO PrincipalType (Id, [PrincipalType]) VALUES ( 16, 'Security Group'      )
END
