IF OBJECT_ID('site.SharingDomainRestrictionMode', 'U') IS NULL
BEGIN

    CREATE TABLE site.SharingDomainRestrictionMode
    (
        Id                 int           NOT NULL,
        SharingDomainRestrictionMode  nvarchar(100) NOT NULL,
        RowCreated         datetime2(7)  NOT NULL,
        RowUpdated         datetime2(7)  NOT NULL,
        CONSTRAINT PK_SharingDomainRestrictionMode_Id PRIMARY KEY CLUSTERED (Id ASC)
    )

    DECLARE @timestamp datetime2(7) = GETUTCDATE()

    INSERT INTO site.SharingDomainRestrictionMode (Id, SharingDomainRestrictionMode, RowCreated, RowUpdated ) VALUES ( 0, 'None',      @timestamp, @timestamp )
    INSERT INTO site.SharingDomainRestrictionMode (Id, SharingDomainRestrictionMode, RowCreated, RowUpdated ) VALUES ( 1, 'AllowList', @timestamp, @timestamp )
    INSERT INTO site.SharingDomainRestrictionMode (Id, SharingDomainRestrictionMode, RowCreated, RowUpdated ) VALUES ( 2, 'BlockList', @timestamp, @timestamp )

END