IF OBJECT_ID('site.BlockGuestsAsSiteAdmin', 'U') IS NULL
BEGIN
    CREATE TABLE site.BlockGuestsAsSiteAdmin
    (
        Id                     int            NOT NULL,
        BlockGuestsAsSiteAdmin nvarchar(100)  NOT NULL,
        RowCreated             datetime2(7)   NOT NULL,
        RowUpdated             datetime2(7)   NOT NULL,
        CONSTRAINT PK_BlockGuestsAsSiteAdmin_Id PRIMARY KEY CLUSTERED (Id ASC)
    )

    DECLARE @timestamp datetime2(7) = GETUTCDATE()

    INSERT INTO site.BlockGuestsAsSiteAdmin (Id, BlockGuestsAsSiteAdmin, RowCreated, RowUpdated ) VALUES ( 0, 'Unspecified', @timestamp, @timestamp )
    INSERT INTO site.BlockGuestsAsSiteAdmin (Id, BlockGuestsAsSiteAdmin, RowCreated, RowUpdated ) VALUES ( 1, 'On',          @timestamp, @timestamp )
    INSERT INTO site.BlockGuestsAsSiteAdmin (Id, BlockGuestsAsSiteAdmin, RowCreated, RowUpdated ) VALUES ( 2, 'Off',         @timestamp, @timestamp )

END