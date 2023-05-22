IF OBJECT_ID('site.LimitedAccessFileType', 'U') IS NULL
BEGIN
    CREATE TABLE site.LimitedAccessFileType
    (
        Id                    int            NOT NULL,
        LimitedAccessFileType nvarchar(100)  NOT NULL,
        RowCreated            datetime2(7)   NOT NULL,
        RowUpdated            datetime2(7)   NOT NULL,
        CONSTRAINT PK_LimitedAccessFileType_Id PRIMARY KEY CLUSTERED (Id ASC)
    )

    DECLARE @timestamp datetime2(7) = GETUTCDATE()

    INSERT INTO site.LimitedAccessFileType (Id, LimitedAccessFileType, RowCreated, RowUpdated ) VALUES ( 0, 'OfficeOnlineFilesOnly',  @timestamp, @timestamp )
    INSERT INTO site.LimitedAccessFileType (Id, LimitedAccessFileType, RowCreated, RowUpdated ) VALUES ( 1, 'WebPreviewableFiles',    @timestamp, @timestamp )
    INSERT INTO site.LimitedAccessFileType (Id, LimitedAccessFileType, RowCreated, RowUpdated ) VALUES ( 2, 'OtherFiles',             @timestamp, @timestamp )

END