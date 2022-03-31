IF OBJECT_ID('dbo.PrincipalUsage', 'U') IS NULL
BEGIN
	-- PrincipalUsage
	CREATE TABLE dbo.PrincipalUsage
	(
        ObjectId                             uniqueidentifier NOT NULL,
		OneDriveSyncedFileCount              int  NULL,     -- getOneDriveActivityUserDetail
		OneDriveSharedInternallyFileCount    int  NULL,     -- getOneDriveActivityUserDetail
		OneDriveSharedExternallyFileCount    int  NULL,     -- getOneDriveActivityUserDetail
		OneDriveViewedOrEditedFileCount      int  NULL,     -- getOneDriveActivityUserDetail
		SharePointSyncedFileCount            int  NULL,     -- getSharePointActivityUserDetail
		SharePointSharedInternallyFileCount  int  NULL,     -- getSharePointActivityUserDetail
		SharePointSharedExternallyFileCount  int  NULL,     -- getSharePointActivityUserDetail
		SharePointViewedOrEditedFileCount    int  NULL,     -- getSharePointActivityUserDetail
		ExchangeLastActivityDate             date NULL,     -- getOffice365ActiveUserDetail
		OneDriveLastActivityDate             date NULL,     -- getOffice365ActiveUserDetail
		SharePointLastActivityDate           date NULL,     -- getOffice365ActiveUserDetail
		YammerLastActivityDate               date NULL,     -- getOffice365ActiveUserDetail
		TeamsLastActivityDate                date NULL,     -- getOffice365ActiveUserDetail
        CONSTRAINT PK_PrincipalUsage_ObjectId PRIMARY KEY CLUSTERED (ObjectId ASC)
		--CONSTRAINT FK_PrincipalUsage_ObjectId
		--	FOREIGN KEY (ObjectId)
		--	REFERENCES dbo.Principal (ObjectId) 
	)
END
