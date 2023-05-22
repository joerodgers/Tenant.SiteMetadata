IF OBJECT_ID('site.SharingCapability', 'U') IS NULL
BEGIN

    CREATE TABLE site.SharingCapability
    (
        Id                 int           NOT NULL,
        SharingCapability  nvarchar(100) NOT NULL,
        RowCreated         datetime2(7)  NOT NULL,
        RowUpdated         datetime2(7)  NOT NULL,
        CONSTRAINT PK_SharingCapability_Id PRIMARY KEY CLUSTERED (Id ASC)
    )

    DECLARE @timestamp datetime2(7) = GETUTCDATE()

    INSERT INTO site.SharingCapability (Id, SharingCapability, RowCreated, RowUpdated ) VALUES ( 0, 'Disabled',                         @timestamp, @timestamp )
    INSERT INTO site.SharingCapability (Id, SharingCapability, RowCreated, RowUpdated ) VALUES ( 1, 'ExternalUserSharingOnly',          @timestamp, @timestamp )
    INSERT INTO site.SharingCapability (Id, SharingCapability, RowCreated, RowUpdated ) VALUES ( 2, 'ExternalUserAndGuestSharing',      @timestamp, @timestamp )
    INSERT INTO site.SharingCapability (Id, SharingCapability, RowCreated, RowUpdated ) VALUES ( 3, 'ExistingExternalUserSharingOnly',  @timestamp, @timestamp )

END