IF OBJECT_ID('dbo.SiteCollectionAdministrator', 'U') IS NULL
BEGIN
	CREATE TABLE dbo.SiteCollectionAdministrator
	(
		[SiteId]                 uniqueidentifier NOT NULL,
		[ObjectId]               uniqueidentifier NOT NULL,
		[IsPrimaryAdministrator] bit              NOT NULL,
	
		CONSTRAINT [PK_SiteCollectionAdministrator_SiteIdObjectId] 
			PRIMARY KEY (SiteId ASC, ObjectId ASC)
		--CONSTRAINT FK_SiteCollectionAdministrator_SiteId
		--		FOREIGN KEY (SiteId)
		--		REFERENCES dbo.SiteCollection (SiteId),
		--CONSTRAINT FK_SiteCollectionAdministrator_ObjectId
		--		FOREIGN KEY (ObjectId)
		--		REFERENCES dbo.Principal (ObjectId)
	)
END