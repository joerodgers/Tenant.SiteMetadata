IF OBJECT_ID('principal.UserPrincipal', 'U') IS NULL
BEGIN
    CREATE TABLE principal.UserPrincipal 
    (
        ObjectId                        uniqueidentifier NOT NULL,
        AccountEnabled                  bit              NULL,
        City                            nvarchar(100)    NULL,
        CompanyName                     nvarchar(100)    NULL,
        Country                         nvarchar(100)    NULL,
        CreatedDateTime                 datetime2(7)     NULL,
        CreationType                    nvarchar(100)    NULL,
        DeletedDateTime                 datetime2(7)     NULL,
        Department                      nvarchar(100)    NULL,
        DisplayName                     nvarchar(100)    NULL,
        EmployeeId                      nvarchar(100)    NULL,
        EmployeeType                    nvarchar(100)    NULL,
        ExternalUserState               nvarchar(100)    NULL,
        ExternalUserStateChangeDateTime datetime2(7)     NULL,
        FirstName                       nvarchar(100)    NULL,
        JobTitle                        nvarchar(100)    NULL,
        LastName                        nvarchar(100)    NULL,
        LastPasswordChangeDateTime      datetime2(7)     NULL,
        Mail                            nvarchar(100)    NULL,
        MailNickname                    nvarchar(100)    NULL,
        Manager                         uniqueidentifier NULL,
        MobilePhone                     nvarchar(100)    NULL,
        MySite                          nvarchar(400)    NULL,
        OfficeLocation                  nvarchar(100)    NULL,
        OnPremisesDistinguishedName     nvarchar(100)    NULL,
        OnPremisesDomainName            nvarchar(100)    NULL,
        OnPremisesImmutableId           nvarchar(100)    NULL,
        OnPremisesLastSyncDateTime      datetime2(7)     NULL,
        OnPremisesSamAccountName        nvarchar(100)    NULL,
        OnPremisesSecurityIdentifier    nvarchar(100)    NULL,
        OnPremisesSyncEnabled           bit              NULL,
        OnPremisesUserPrincipalName     nvarchar(100)    NULL,
        PreferredDataLocation           nvarchar(100)    NULL,
        PostalCode                      nvarchar(100)    NULL,
        PreferredLanguage               nvarchar(100)    NULL,
        PreferredName                   nvarchar(100)    NULL,
        PrincipalType                   int              NULL,
        [State]                         nvarchar(100)    NULL,
        StreetAddress                   nvarchar(100)    NULL,
        UsageLocation                   nvarchar(100)    NULL,
        UserPrincipalName               nvarchar(100)    NULL,
        RowCreated                      datetime2(7)     NOT NULL,
        RowUpdated                      datetime2(7)     NOT NULL,
        CONSTRAINT PK_UserPrincipal_ObjectId PRIMARY KEY CLUSTERED (ObjectId)
    )

    DECLARE @timestamp datetime2(7) = GETUTCDATE()

    INSERT INTO principal.UserPrincipal (ObjectId, DisplayName, UserPrincipalName, PrincipalType, RowCreated, RowUpdated) VALUES ( '00000000-0000-0000-0000-000000000000', 'Unknown',               'Unknown',        1,  @timestamp, @timestamp)
    INSERT INTO principal.UserPrincipal (ObjectId, DisplayName, UserPrincipalName, PrincipalType, RowCreated, RowUpdated) VALUES ( '00000003-0000-0ff1-ce00-000000000000', 'SharePoint Online App', 'app@sharepoint', 1,  @timestamp, @timestamp)

    CREATE NONCLUSTERED INDEX IX_UserPrincipal_UserPrincipalName ON principal.UserPrincipal (UserPrincipalName ASC)
    CREATE NONCLUSTERED INDEX IX_UserPrincipal_DeletedDateTime   ON principal.UserPrincipal (DeletedDateTime   ASC)

END