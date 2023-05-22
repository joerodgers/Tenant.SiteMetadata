IF OBJECT_ID('site.SensitivityLabel', 'U') IS NULL
BEGIN
    CREATE TABLE site.SensitivityLabel
    (
        Id               uniqueidentifier NOT NULL,
        SensitivityLabel nvarchar(100)    NOT NULL,
        RowCreated       datetime2(7)     NOT NULL,
        RowUpdated       datetime2(7)     NOT NULL,
        CONSTRAINT PK_SensitivityLabel_Id PRIMARY KEY CLUSTERED (Id ASC)
    )

    DECLARE @timestamp datetime2(7) = GETUTCDATE()

    INSERT INTO site.SensitivityLabel (Id, SensitivityLabel, RowCreated, RowUpdated) VALUES ('00000000-0000-0000-0000-000000000000', 'None/Unknown', @timestamp, @timestamp)
END