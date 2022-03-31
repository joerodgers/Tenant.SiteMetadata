IF OBJECT_ID('dbo.PrincipalManager', 'U') IS NULL
BEGIN
	-- PrincipalManager
	CREATE TABLE dbo.PrincipalManager
	(
        PrincipalObjectId  uniqueidentifier NOT NULL,
        ManagerObjectId    uniqueidentifier NOT NULL,
        CONSTRAINT PK_PrincipalManager_PrincipalObjectIdManagerObjectId PRIMARY KEY CLUSTERED (PrincipalObjectId ASC, ManagerObjectId ASC)
		--CONSTRAINT FK_Principal_PrincipalObjectId
		--	FOREIGN KEY (PrincipalObjectId) 
		--	REFERENCES dbo.Principal (ObjectId),
		--CONSTRAINT FK_Principal_ManagerObjectId
		--	FOREIGN KEY (ManagerObjectId)
		--	REFERENCES dbo.Principal (ObjectId) 
    )
END