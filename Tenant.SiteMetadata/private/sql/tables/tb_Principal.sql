IF OBJECT_ID('dbo.Principal', 'U') IS NULL
BEGIN
	-- Principal
	CREATE TABLE dbo.Principal 
	(
        ObjectId                   uniqueidentifier NOT NULL,
        Identifier                 nvarchar(100)    NOT NULL,
        DisplayName                nvarchar(500)    NOT NULL,
        PrincipalType              int              NOT NULL,
        IsDirectorySynced          bit              NOT NULL,
		DriveId                    uniqueidentifier NULL,
        DeletedDate                date             NULL,     -- getSharePointActivityUserDetail
		--LastActivityDate           date             NULL,     -- getSharePointActivityUserDetail
		--SyncedFileCount            int              NULL,     -- getSharePointActivityUserDetail
		--SharedInternallyFileCount  int              NULL,     -- getSharePointActivityUserDetail
		--SharedExternallyFileCount  int              NULL,     -- getSharePointActivityUserDetail
		--VisitedPageCount           int              NULL,     -- getSharePointActivityUserDetail
		--ViewedOrEditedFileCount    int              NULL,     -- getSharePointActivityUserDetail
        CONSTRAINT PK_Principal_ObjectId
			PRIMARY KEY CLUSTERED (ObjectId ASC)
		--CONSTRAINT FK_Principal_PrincipalType 
		--	FOREIGN KEY (PrincipalType)
		--	REFERENCES dbo.PrincipalType (Id)
	)
	CREATE NONCLUSTERED INDEX IX_Principal_Identifier ON dbo.Principal (Identifier ASC)
	INSERT INTO Principal (ObjectId, Identifier, DisplayName, PrincipalType, IsDirectorySynced, DeletedDate) VALUES ( '00000000-0000-0000-0000-000000000000', 'Unknown', 'Unknown', -1, 0, NULL)
END
