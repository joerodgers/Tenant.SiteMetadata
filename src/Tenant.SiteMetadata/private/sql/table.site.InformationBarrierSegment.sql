IF OBJECT_ID('site.InformationBarrierSegment', 'U') IS NULL
BEGIN
    CREATE TABLE site.InformationBarrierSegment
    (
        [Id]                        uniqueidentifier NOT NULL,
        [InformationBarrierSegment] nvarchar(500)    NOT NULL,
        RowCreated                  datetime2(7)     NOT NULL,
        RowUpdated                  datetime2(7)     NOT NULL,
        CONSTRAINT PK_InformationBarrierSegmentId_Id PRIMARY KEY CLUSTERED (Id ASC)
    )
END