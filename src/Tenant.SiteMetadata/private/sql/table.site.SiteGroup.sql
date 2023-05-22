IF OBJECT_ID('site.SiteGroup', 'U') IS NULL
BEGIN
    CREATE TABLE site.SiteGroup
    (
        SiteId            UNIQUEIDENTIFIER NOT NULL,
        GroupId           INT                  NULL,
        GroupLinkId       UNIQUEIDENTIFIER     NULL,
        GroupType         NVARCHAR(500)        NULL,
        DisplayName       NVARCHAR(500)        NULL,
        Description       NVARCHAR(2000)       NULL,
        PrincipalType     NVARCHAR(500)        NULL,
        PrincipalName     NVARCHAR(500)        NULL,
        PrincipalEmail    NVARCHAR(500)        NULL,
        PrincipalObjectId UNIQUEIDENTIFIER     NULL,
        SnapshotDate      DATETIME2(2)     NOT NULL,
    )
    CREATE CLUSTERED INDEX IX_SiteGroup_SiteId ON site.SiteGroup (SiteId ASC)
END