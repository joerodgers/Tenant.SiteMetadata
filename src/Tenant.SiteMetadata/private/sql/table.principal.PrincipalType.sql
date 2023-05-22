IF OBJECT_ID('principal.PrincipalType', 'U') IS NULL
BEGIN
    CREATE TABLE principal.PrincipalType
    (
        Id            int           NOT NULL,
        PrincipalType nvarchar(100) NOT NULL,
        RowCreated    datetime2(7)  NOT NULL,
        RowUpdated    datetime2(7)  NOT NULL,
        CONSTRAINT PK_PrincipalType_Id PRIMARY KEY CLUSTERED (Id ASC)
    )

    DECLARE @timestamp datetime2(7) = GETUTCDATE()

    -- Keep in sync with PrincipalType in Enums.ps1
    INSERT INTO principal.PrincipalType (Id, PrincipalType, RowCreated, RowUpdated ) VALUES ( 1,  'Unknown',             @timestamp, @timestamp )
    INSERT INTO principal.PrincipalType (Id, PrincipalType, RowCreated, RowUpdated ) VALUES ( 2,  'Member',              @timestamp, @timestamp )
    INSERT INTO principal.PrincipalType (Id, PrincipalType, RowCreated, RowUpdated ) VALUES ( 4,  'Guest',               @timestamp, @timestamp )
    INSERT INTO principal.PrincipalType (Id, PrincipalType, RowCreated, RowUpdated ) VALUES ( 8,  'Microsoft 365 Group', @timestamp, @timestamp )
    INSERT INTO principal.PrincipalType (Id, PrincipalType, RowCreated, RowUpdated ) VALUES ( 16, 'Security Group',      @timestamp, @timestamp )
END
