IF OBJECT_ID('history.Cmdlet', 'U') IS NULL
BEGIN
    CREATE TABLE history.Cmdlet
    (
        [Id]                     int IDENTITY(1,1) NOT NULL,
        Cmdlet                   nvarchar(100)     NOT NULL,
        RowCreated               datetime2(7)      NOT NULL,
        RowUpdated               datetime2(7)      NOT NULL,
        CONSTRAINT PK_Cmdlet_Id PRIMARY KEY CLUSTERED (Id ASC)
    )
    CREATE NONCLUSTERED INDEX IX_Cmdlet_Cmdlet ON history.Cmdlet (Cmdlet ASC)
END