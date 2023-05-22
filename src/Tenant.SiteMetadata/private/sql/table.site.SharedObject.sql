IF OBJECT_ID('site.SharedObject', 'U') IS NULL
BEGIN
    CREATE TABLE site.SharedObject
    (
        SiteId                 UNIQUEIDENTIFIER NOT NULL,
        WebId                  UNIQUEIDENTIFIER NOT NULL,
        ItemType               NVARCHAR(500)    NOT NULL,
        ItemUrl                NVARCHAR(1000)       NULL,
        FileExtension          NVARCHAR(50)         NULL,
        RoleDefinition         NVARCHAR(500)    NOT NULL,
        LinkId                 UNIQUEIDENTIFIER     NULL,
        ScopeId                UNIQUEIDENTIFIER NOT NULL,
        LinkScope              NVARCHAR(500)        NULL,
        SnapshotDate           DATETIME2(2)     NOT NULL,
        ShareCreatedBy         NVARCHAR(500)        NULL,
        ShareCreatedTime       DATETIME2(2)         NULL,
        ShareLastModifiedBy    NVARCHAR(500)        NULL,
        ShareLastModifiedTime  DATETIME2(2)         NULL,
        ShareExpirationTime    DATETIME2(2)         NULL,
        SharedWithType         NVARCHAR(500)        NULL,
        SharedWithName         NVARCHAR(500)        NULL,
        SharedWithEmail        NVARCHAR(500)        NULL
    )
    CREATE CLUSTERED INDEX IX_SharedObject_SiteId ON site.SharedObject (SiteId ASC)
END