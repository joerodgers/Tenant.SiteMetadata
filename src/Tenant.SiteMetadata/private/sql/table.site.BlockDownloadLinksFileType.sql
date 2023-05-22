IF OBJECT_ID('site.BlockDownloadLinksFileType', 'U') IS NULL
BEGIN
    CREATE TABLE site.BlockDownloadLinksFileType
    (
        Id                         int            NOT NULL,
        BlockDownloadLinksFileType nvarchar(100)  NOT NULL,
        RowCreated                 datetime2(7)   NOT NULL,
        RowUpdated                 datetime2(7)   NOT NULL,
        CONSTRAINT PK_BlockDownloadLinksFileType_Id PRIMARY KEY CLUSTERED (Id ASC)
    )

    DECLARE @timestamp datetime2(7) = GETUTCDATE()

    INSERT INTO site.BlockDownloadLinksFileType (Id, BlockDownloadLinksFileType, RowCreated, RowUpdated ) VALUES ( 1, 'WebPreviewableFiles',     @timestamp, @timestamp )
    INSERT INTO site.BlockDownloadLinksFileType (Id, BlockDownloadLinksFileType, RowCreated, RowUpdated ) VALUES ( 2, 'ServerRenderedFilesOnly', @timestamp, @timestamp )

END