IF OBJECT_ID('site.SharingPermissionType', 'U') IS NULL
BEGIN
    CREATE TABLE site.SharingPermissionType 
    (
        Id                    int           NOT NULL,
        SharingPermissionType nvarchar(255) NOT NULL,
        RowCreated            datetime2(7)  NOT NULL,
        RowUpdated            datetime2(7)  NOT NULL,
        CONSTRAINT [PK_SharingPermissionType_Id] PRIMARY KEY CLUSTERED (Id ASC)
    )

    DECLARE @timestamp datetime2(7) = GETUTCDATE()

    INSERT INTO site.SharingPermissionType (Id, SharingPermissionType, RowCreated, RowUpdated ) VALUES ( -1, 'None', @timestamp, @timestamp )
    INSERT INTO site.SharingPermissionType (Id, SharingPermissionType, RowCreated, RowUpdated ) VALUES (  1, 'View', @timestamp, @timestamp )
    INSERT INTO site.SharingPermissionType (Id, SharingPermissionType, RowCreated, RowUpdated ) VALUES (  2, 'Edit', @timestamp, @timestamp )

END