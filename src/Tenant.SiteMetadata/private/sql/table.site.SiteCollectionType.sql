IF OBJECT_ID('site.SiteColletionType', 'U') IS NULL
BEGIN
    CREATE TABLE site.SiteColletionType
    (
        Id                int           NOT NULL,
        SiteColletionType nvarchar(100) NOT NULL,
        RowCreated        datetime2(7)  NOT NULL,
        RowUpdated        datetime2(7)  NOT NULL,
        CONSTRAINT PK_SiteColletionType_Id PRIMARY KEY CLUSTERED (Id ASC)
    )

    DECLARE @timestamp datetime2(7) = GETUTCDATE()

    INSERT INTO site.SiteColletionType (Id, SiteColletionType, RowCreated, RowUpdated) VALUES (1,  'SharePoint',      @timestamp, @timestamp )
    INSERT INTO site.SiteColletionType (Id, SiteColletionType, RowCreated, RowUpdated) VALUES (2,  'OneDrive',        @timestamp, @timestamp )
    INSERT INTO site.SiteColletionType (Id, SiteColletionType, RowCreated, RowUpdated) VALUES (4,  'Teams Connected', @timestamp, @timestamp )
    INSERT INTO site.SiteColletionType (Id, SiteColletionType, RowCreated, RowUpdated) VALUES (8,  'M365 Group',      @timestamp, @timestamp )
    INSERT INTO site.SiteColletionType (Id, SiteColletionType, RowCreated, RowUpdated) VALUES (16, 'Other',           @timestamp, @timestamp )

END
