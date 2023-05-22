IF OBJECT_ID('site.InformationBarrierMode', 'U') IS NULL
BEGIN
    CREATE TABLE site.InformationBarrierMode 
    (
        Id                     int           NOT NULL,
        InformationBarrierMode nvarchar(255) NOT NULL,
        RowCreated             datetime2(7)  NOT NULL,
        RowUpdated             datetime2(7)  NOT NULL,
        CONSTRAINT [PK_InformationBarrierMode_Id] PRIMARY KEY CLUSTERED (Id ASC)
    )

    DECLARE @timestamp datetime2(7) = GETUTCDATE()

    INSERT INTO site.InformationBarrierMode (Id, InformationBarrierMode, RowCreated, RowUpdated ) VALUES ( -1, 'Unknown',        @timestamp, @timestamp )
    INSERT INTO site.InformationBarrierMode (Id, InformationBarrierMode, RowCreated, RowUpdated ) VALUES (  1, 'Open',           @timestamp, @timestamp )
    INSERT INTO site.InformationBarrierMode (Id, InformationBarrierMode, RowCreated, RowUpdated ) VALUES (  2, 'Implicit',       @timestamp, @timestamp )
    INSERT INTO site.InformationBarrierMode (Id, InformationBarrierMode, RowCreated, RowUpdated ) VALUES (  3, 'Explicit',       @timestamp, @timestamp )
    INSERT INTO site.InformationBarrierMode (Id, InformationBarrierMode, RowCreated, RowUpdated ) VALUES (  4, 'OwnerModerated', @timestamp, @timestamp )
    INSERT INTO site.InformationBarrierMode (Id, InformationBarrierMode, RowCreated, RowUpdated ) VALUES (  5, 'Inferred',       @timestamp, @timestamp )

END