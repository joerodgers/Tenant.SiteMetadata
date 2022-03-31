IF OBJECT_ID('dbo.PrincipalMembership', 'U') IS NULL
BEGIN
	-- PrincipalMembership
	CREATE TABLE dbo.PrincipalMembership
	(
        GroupObjectId      uniqueidentifier NOT NULL,
        PrincipalObjectId  uniqueidentifier NOT NULL,
        MembershipType     int              NOT NULL,
        CONSTRAINT PK_PrincipalMembership_GroupObjectIdPrincipalObjectId PRIMARY KEY (GroupObjectId ASC, PrincipalObjectId ASC)
		--CONSTRAINT FK_PrincipalMembership_GroupObjectId
		--	FOREIGN KEY (GroupObjectId)
		--	REFERENCES dbo.Principal (ObjectId), 
		--CONSTRAINT FK_PrincipalMembership_PrincipalObjectId
		--	FOREIGN KEY (PrincipalObjectId)
		--	REFERENCES dbo.Principal (ObjectId), 
	)
END