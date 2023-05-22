IF OBJECT_ID('principal.GroupPrincipal', 'U') IS NULL
BEGIN
    CREATE TABLE principal.GroupPrincipal
    (
        ObjectId                      uniqueidentifier NOT NULL,
        Classification                nvarchar(100)    NULL,
        CreatedDateTime               datetime2(7)     NULL,
        DeletedDateTime               datetime2(7)     NULL,
        [Description]                 nvarchar(500)    NULL,
        DisplayName                   nvarchar(100)    NULL,
        ExpirationDateTime            datetime2(7)     NULL,
        IsAssignableToRole            bit              NULL,
        IsPublic                      bit              NULL,
        IsTeamsGroup                  bit              NULL,
        IsUnifiedGroup                bit              NULL,
        Mail                          nvarchar(100)    NULL,
        MailEnabled                   bit              NULL,
        MailNickname                  nvarchar(100)    NULL,
        MembershipRule                nvarchar(1000)   NULL,
        MembershipRuleProcessingState nvarchar(100)    NULL,
        OnPremisesLastSyncDateTime    datetime2(7)     NULL,
        OnPremisesSamAccountName      nvarchar(100)    NULL,
        OnPremisesSecurityIdentifier  nvarchar(100)    NULL,
        OnPremisesSyncEnabled         bit              NULL,
        PreferredDataLocation         nvarchar(100)    NULL,
        PreferredLanguage             nvarchar(100)    NULL,
        RenewedDateTime               datetime2(7)     NULL,
        SecurityEnabled               bit              NULL,
        SecurityIdentifier            nvarchar(100)    NULL,
        SensitivityLabel              uniqueidentifier NULL,
        Theme                         nvarchar(100)    NULL,
        RowCreated                    datetime2(7)     NOT NULL,
        RowUpdated                    datetime2(7)     NOT NULL,
        CONSTRAINT PK_Principal_ObjectId PRIMARY KEY CLUSTERED (ObjectId)
    )

    DECLARE @timestamp datetime2(7) = GETUTCDATE()

    -- keep guids in sync with Save-SharePointTenantSiteAdministratorBatchResult.ps1
    INSERT INTO principal.GroupPrincipal (ObjectId, DisplayName, RowCreated, RowUpdated) VALUES ( '00000000-0000-0000-0000-00000000000E', 'Everyone',                       @timestamp, @timestamp ) -- c:0(.s|true
    INSERT INTO principal.GroupPrincipal (ObjectId, DisplayName, RowCreated, RowUpdated) VALUES ( '00000000-0000-0000-0000-000000000EEE', 'Everyone Except External Users', @timestamp, @timestamp ) -- spo-grid-all-users\<tenantid>
    
END