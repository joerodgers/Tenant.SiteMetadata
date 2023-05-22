CREATE OR ALTER PROCEDURE [principal].[proc_AddOrUpdateGroupPrincipal]
	@json nvarchar(max)
AS
BEGIN

    DECLARE @timestamp datetime2(7) = GETUTCDATE()

    ;WITH groups AS
    (
        SELECT
            Classification, 
            CreatedDateTime, 
            DeletedDateTime, 
            [Description], 
            DisplayName, 
            ExpirationDateTime,
            IsAssignableToRole,
            IsPublic,
            IsTeamsGroup,
            IsUnifiedGroup,
            Mail, 
            MailEnabled,
            MailNickname,
            MembershipRule,
            MembershipRuleProcessingState,
            ObjectId, 
            OnPremisesLastSyncDateTime,
            OnPremisesSamAccountName,
            OnPremisesSecurityIdentifier,
            OnPremisesSyncEnabled,
            PreferredDataLocation,
            PreferredLanguage,
            RenewedDateTime,
            SecurityEnabled,
            SecurityIdentifier,
            SensitivityLabel,
            Theme,
            RowCreated = @timestamp,
            RowUpdated = @timestamp
        FROM 
            OPENJSON (@json, N'$') WITH 
            (
                Classification                nvarchar(100)    N'$.Classification',
                CreatedDateTime               datetime2(7)     N'$.CreatedDateTime',
                DeletedDateTime               datetime2(7)     N'$.DeletedDateTime',
                [Description]                 nvarchar(100)    N'$.Description',
                DisplayName                   nvarchar(100)    N'$.DisplayName',
                ExpirationDateTime            datetime2(7)     N'$.ExpirationDateTime',
                IsAssignableToRole            bit              N'$.IsAssignableToRole',
                IsPublic                      bit              N'$.IsPublic',
                IsTeamsGroup                  bit              N'$.IsTeamsGroup',
                IsUnifiedGroup                bit              N'$.IsUnifiedGroup',
                Mail                          nvarchar(100)    N'$.Mail',
                MailEnabled                   bit              N'$.MailEnabled',
                MailNickname                  nvarchar(100)    N'$.MailNickname',
                MembershipRule                nvarchar(1000)   N'$.MembershipRule',
                MembershipRuleProcessingState nvarchar(100)    N'$.MembershipRuleProcessingState',
                ObjectId                      uniqueidentifier N'$.ObjectId',
                OnPremisesLastSyncDateTime    datetime2(7)     N'$.OnPremisesLastSyncDateTime',
                OnPremisesSamAccountName      nvarchar(100)    N'$.OnPremisesSamAccountName',
                OnPremisesSecurityIdentifier  nvarchar(100)    N'$.OnPremisesSecurityIdentifier',
                OnPremisesSyncEnabled         bit              N'$.OnPremisesSyncEnabled',
                PreferredDataLocation         nvarchar(100)    N'$.PreferredDataLocation',
                PreferredLanguage             nvarchar(100)    N'$.PreferredLanguage',
                RenewedDateTime               datetime2(7)     N'$.RenewedDateTime',
                SecurityEnabled               bit              N'$.SecurityEnabled',
                SecurityIdentifier            nvarchar(100)    N'$.SecurityIdentifier',
                SensitivityLabel              uniqueidentifier N'$.SensitivityLabel',
                Theme                         nvarchar(100)    N'$.Theme'
            )
    )

    MERGE INTO principal.GroupPrincipal AS Existing
    USING groups AS New
    ON New.ObjectId = Existing.ObjectId
    WHEN MATCHED THEN
        UPDATE SET
            Existing.Classification               = ISNULL(New.Classification,               Existing.Classification), 
            Existing.CreatedDateTime              = ISNULL(New.CreatedDateTime,              Existing.CreatedDateTime), 
            Existing.DeletedDateTime              = ISNULL(New.DeletedDateTime,              Existing.DeletedDateTime), 
            Existing.Description                  = ISNULL(New.Description,                  Existing.Description), 
            Existing.DisplayName                  = ISNULL(New.DisplayName,                  Existing.DisplayName), 
            Existing.ExpirationDateTime           = ISNULL(New.ExpirationDateTime,           Existing.ExpirationDateTime), 
            Existing.IsAssignableToRole           = ISNULL(New.IsAssignableToRole,           Existing.IsAssignableToRole), 
            Existing.IsPublic                     = ISNULL(New.IsPublic,                     Existing.IsPublic),
            Existing.IsTeamsGroup                 = ISNULL(New.IsTeamsGroup,                 Existing.IsTeamsGroup),
            Existing.IsUnifiedGroup               = ISNULL(New.IsUnifiedGroup,               Existing.IsUnifiedGroup),
            Existing.Mail                         = ISNULL(New.Mail,                         Existing.Mail), 
            Existing.MailEnabled                  = ISNULL(New.MailEnabled,                  Existing.MailEnabled), 
            Existing.MailNickname                 = ISNULL(New.MailNickname,                 Existing.MailNickname), 
            Existing.OnPremisesLastSyncDateTime   = ISNULL(New.OnPremisesLastSyncDateTime,   Existing.OnPremisesLastSyncDateTime), 
            Existing.OnPremisesSamAccountName     = ISNULL(New.OnPremisesSamAccountName,     Existing.OnPremisesSamAccountName), 
            Existing.OnPremisesSecurityIdentifier = ISNULL(New.OnPremisesSecurityIdentifier, Existing.OnPremisesSecurityIdentifier), 
            Existing.OnPremisesSyncEnabled        = ISNULL(New.OnPremisesSyncEnabled,        Existing.OnPremisesSyncEnabled), 
            Existing.PreferredDataLocation        = ISNULL(New.PreferredDataLocation,        Existing.PreferredDataLocation), 
            Existing.PreferredLanguage            = ISNULL(New.PreferredLanguage,            Existing.PreferredLanguage), 
            Existing.RenewedDateTime              = ISNULL(New.RenewedDateTime,              Existing.RenewedDateTime), 
            Existing.SecurityEnabled              = ISNULL(New.SecurityEnabled,              Existing.SecurityEnabled), 
            Existing.SecurityIdentifier           = ISNULL(New.SecurityIdentifier,           Existing.SecurityIdentifier), 
            Existing.SensitivityLabel             = ISNULL(New.SensitivityLabel,             Existing.SensitivityLabel), 
            Existing.Theme                        = ISNULL(New.Theme,                        Existing.Theme), 
            Existing.RowUpdated                   = New.RowUpdated
    WHEN NOT MATCHED THEN
        INSERT
        (
            Classification, 
            CreatedDateTime, 
            DeletedDateTime, 
            [Description], 
            DisplayName, 
            ExpirationDateTime,
            IsAssignableToRole,
            IsPublic,
            IsTeamsGroup,
            IsUnifiedGroup,
            Mail, 
            MailEnabled,
            MailNickname,
            MembershipRule,
            MembershipRuleProcessingState,
            ObjectId, 
            OnPremisesLastSyncDateTime,
            OnPremisesSamAccountName,
            OnPremisesSecurityIdentifier,
            OnPremisesSyncEnabled,
            PreferredDataLocation,
            PreferredLanguage,
            RenewedDateTime,
            SecurityEnabled,
            SecurityIdentifier,
            SensitivityLabel,
            Theme,
            RowCreated,
            RowUpdated     
        )
        VALUES 
        (
            Classification, 
            CreatedDateTime, 
            DeletedDateTime, 
            [Description], 
            DisplayName, 
            ExpirationDateTime,
            IsAssignableToRole,
            IsPublic,
            IsTeamsGroup,
            IsUnifiedGroup,
            Mail, 
            MailEnabled,
            MailNickname,
            MembershipRule,
            MembershipRuleProcessingState,
            ObjectId, 
            OnPremisesLastSyncDateTime,
            OnPremisesSamAccountName,
            OnPremisesSecurityIdentifier,
            OnPremisesSyncEnabled,
            PreferredDataLocation,
            PreferredLanguage,
            RenewedDateTime,
            SecurityEnabled,
            SecurityIdentifier,
            SensitivityLabel,
            Theme,
            RowCreated,
            RowUpdated     
     );
END