IF OBJECT_ID('site.Administrator', 'U') IS NULL
BEGIN
    CREATE TABLE site.Administrator
    (
        SiteId      uniqueidentifier NOT NULL,
        PrincipalId uniqueidentifier NOT NULL,
        RowCreated  datetime2(7)     NOT NULL,
        RowUpdated  datetime2(7)     NOT NULL,
        CONSTRAINT PK_Administrator_SiteId_PrincipalId PRIMARY KEY CLUSTERED (SiteId,PrincipalId)
    )
END
