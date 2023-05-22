IF OBJECT_ID('site.ConditionalAccessPolicyType', 'U') IS NULL
BEGIN
    CREATE TABLE site.ConditionalAccessPolicyType
    (
        Id                          int            NOT NULL,
        ConditionalAccessPolicyType nvarchar(100)  NOT NULL,
        RowCreated                  datetime2(7)   NOT NULL,
        RowUpdated                  datetime2(7)   NOT NULL,
        CONSTRAINT PK_ConditionalAccessPolicyType_Id PRIMARY KEY CLUSTERED (Id ASC)
    )

    DECLARE @timestamp datetime2(7) = GETUTCDATE()

    INSERT INTO site.ConditionalAccessPolicyType (Id, ConditionalAccessPolicyType, RowCreated, RowUpdated ) VALUES ( 0, 'AllowFullAccess',       @timestamp, @timestamp )
    INSERT INTO site.ConditionalAccessPolicyType (Id, ConditionalAccessPolicyType, RowCreated, RowUpdated ) VALUES ( 1, 'AllowLimitedAccess',    @timestamp, @timestamp )
    INSERT INTO site.ConditionalAccessPolicyType (Id, ConditionalAccessPolicyType, RowCreated, RowUpdated ) VALUES ( 2, 'BlockAccess',           @timestamp, @timestamp )
    INSERT INTO site.ConditionalAccessPolicyType (Id, ConditionalAccessPolicyType, RowCreated, RowUpdated ) VALUES ( 3, 'AuthenticationContext', @timestamp, @timestamp )

END