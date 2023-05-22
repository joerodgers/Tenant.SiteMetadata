IF OBJECT_ID('site.TimeZone', 'U') IS NULL
BEGIN
  CREATE TABLE site.TimeZone
  (
        Id          int           NOT NULL,
        Identifier  nvarchar(100) NOT NULL,
        Description nvarchar(100) NOT NULL,
        RowCreated  datetime2(7)  NOT NULL,
        RowUpdated  datetime2(7)  NOT NULL,
        CONSTRAINT PK_TimeZone_Id PRIMARY KEY CLUSTERED (Id ASC)
    )
END