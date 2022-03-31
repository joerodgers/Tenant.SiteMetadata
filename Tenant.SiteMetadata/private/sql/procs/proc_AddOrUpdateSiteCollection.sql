CREATE OR ALTER PROCEDURE [dbo].[proc_AddOrUpdateSiteCollection]
    @SiteId                                     uniqueidentifier,
    @GroupId                                    uniqueidentifier = NULL,
    @ConditionalAccessPolicy                    int              = NULL,
    @CreatedBy                                  uniqueidentifier = NULL,
    @CreatedDate                                date             = NULL,
    @DeletedBy                                  uniqueidentifier = NULL,
    @DeletedDate                                date             = '1753-01-01',
    @DenyAddAndCustomizePagesEnabled            bit              = NULL,
    @DisplayName                                nvarchar(255)    = NULL,
    @ExternalUserExpirationInDays               int              = NULL,
    @GeoLocation                                nvarchar(10)     = NULL,
    @HasHolds                                   bit              = NULL,
    @HubSiteId                                  uniqueidentifier = NULL,
    @InformationBarrierMode                     int              = NULL,
    @IsGroupOwnerSiteAdmin                      bit              = NULL,
    @IsHubSite                                  bit              = NULL,
    @IsProjectConnected                         bit              = NULL,
    @IsPublic                                   bit              = NULL,
    @IsTeamsChannelConnected                    bit              = NULL,
    @IsTeamsConnected                           bit              = NULL,
    @IsYammerConnected                          bit              = NULL, 
    @IsPlannerConnected                         bit              = NULL,
    @LastCertificationDate                      datetime2(7)     = NULL,
    @LastItemModifiedDate                       datetime2(7)     = NULL,
    @Lcid                                       int              = NULL,
    @LockState                                  int              = NULL,
    @OverrideTenantExternalUserExpirationPolicy bit              = NULL,
    @RelatedGroupId                             uniqueidentifier = NULL,
    @RestrictedToRegion                         int              = NULL,
    @SensitivityLabel                           uniqueidentifier = NULL,
    @SharingCapability                          int              = NULL,
    @SharingDomainRestrictionMode               int              = NULL,
    @SharingLockDownCanBeCleared                bit              = NULL,
    @SharingLockDownEnabled                     bit              = NULL,
    @SiteDefinedSharingCapability               int              = NULL,
    @SiteCreationSource                         uniqueidentifier = NULL,
    @SiteUrl                                    nvarchar(450)    = NULL,
    @StorageQuota                               bigint           = NULL,
    @StorageUsed                                bigint           = NULL,
    @TeamsChannelType                           int              = NULL,
    @Template                                   nvarchar(255)    = NULL,
    @TimeZoneId                                 int              = NULL,
    @UnmanagedDevicePolicy                      [nchar](10)      = NULL,
    @WebsCount                                  int              = NULL
AS
BEGIN

    -- remove trailing slash from SiteUrl
    IF RIGHT(@SiteUrl, 1) = '/'
        SET @SiteUrl = SUBSTRING( @SiteUrl, 0, LEN(@SiteUrl))

    -- ensure site entry exists
    IF NOT EXISTS(SELECT 1 FROM dbo.SiteCollection WHERE SiteId = @SiteId)
    BEGIN
        INSERT INTO SiteCollection
        (
            SiteId, 
            SiteUrl
        ) 
        VALUES 
        (
            @SiteId, 
            @SiteUrl
        )
    END

    IF (@DeletedDate = '1753-01-01' ) -- parameter default, use existing row value
        SELECT @DeletedDate = DeletedDate FROM dbo.SiteCollection WHERE SiteId = @SiteId

    UPDATE 
        dbo.SiteCollection 
    SET 
        GroupId                                    = ISNULL(@GroupId, GroupId),
        ConditionalAccessPolicy                    = ISNULL(@ConditionalAccessPolicy, ConditionalAccessPolicy),
        CreatedBy                                  = ISNULL(@CreatedBy, CreatedBy),
        CreatedDate                                = ISNULL(@CreatedDate, CreatedDate),
        --DeletedBy                                  = ISNULL(@DeletedBy, DeletedBy),
        DeletedDate                                = @DeletedDate,
        DenyAddAndCustomizePagesEnabled            = ISNULL(@DenyAddAndCustomizePagesEnabled, DenyAddAndCustomizePagesEnabled),
        DisplayName                                = ISNULL(@DisplayName, DisplayName),
        ExternalUserExpirationInDays               = ISNULL(@ExternalUserExpirationInDays, ExternalUserExpirationInDays),
        GeoLocation                                = ISNULL(@GeoLocation, GeoLocation),
        HasHolds                                   = ISNULL(@HasHolds, HasHolds),
        HubSiteId                                  = ISNULL(@HubSiteId, HubSiteId),
        InformationBarrierMode                     = ISNULL(@InformationBarrierMode, InformationBarrierMode), 
        IsGroupOwnerSiteAdmin                      = ISNULL(@IsGroupOwnerSiteAdmin, IsGroupOwnerSiteAdmin),
        IsHubSite                                  = ISNULL(@IsHubSite, IsHubSite),
        IsProjectConnected                         = ISNULL(@IsProjectConnected, IsProjectConnected),
        IsPublic                                   = ISNULL(@IsPublic, IsPublic),
        IsTeamsChannelConnected                    = ISNULL(@IsTeamsChannelConnected, IsTeamsChannelConnected),
        IsTeamsConnected                           = ISNULL(@IsTeamsConnected, IsTeamsConnected),
        IsYammerConnected                          = ISNULL(@IsYammerConnected, IsYammerConnected),
        IsPlannerConnected                         = ISNULL(@IsPlannerConnected, IsPlannerConnected),
        --LastCertificationDate                      = ISNULL(@LastCertificationDate, LastCertificationDate),
        LastItemModifiedDate                       = ISNULL(@LastItemModifiedDate, LastItemModifiedDate),
        Lcid                                       = ISNULL(@Lcid, Lcid),
        LockState                                  = ISNULL(@LockState, LockState),
        OverrideTenantExternalUserExpirationPolicy = ISNULL(@OverrideTenantExternalUserExpirationPolicy, OverrideTenantExternalUserExpirationPolicy),
        RelatedGroupId                             = ISNULL(@RelatedGroupId, RelatedGroupId),
        RestrictedToRegion                         = ISNULL(@RestrictedToRegion, RestrictedToRegion),   
        SensitivityLabel                           = ISNULL(@SensitivityLabel, SensitivityLabel),
        SharingCapability                          = ISNULL(@SharingCapability, SharingCapability),
        SharingDomainRestrictionMode               = ISNULL(@SharingDomainRestrictionMode, SharingDomainRestrictionMode),
        SharingLockDownCanBeCleared                = ISNULL(@SharingLockDownCanBeCleared, SharingLockDownCanBeCleared),  
        SharingLockDownEnabled                     = ISNULL(@SharingLockDownEnabled, SharingLockDownEnabled),
        SiteDefinedSharingCapability               = ISNULL(@SiteDefinedSharingCapability, SiteDefinedSharingCapability),
        SiteCreationSource                         = ISNULL(@SiteCreationSource, SiteCreationSource),
        SiteUrl                                    = ISNULL(@SiteUrl, SiteUrl),
        StorageQuota                               = ISNULL(@StorageQuota, StorageQuota),
        StorageUsed                                = ISNULL(@StorageUsed, StorageUsed),
        TeamsChannelType                           = ISNULL(@TeamsChannelType, TeamsChannelType),
        Template                                   = ISNULL(@Template, Template),
        TimeZoneId                                 = ISNULL(@TimeZoneId, TimeZoneId),
        UnmanagedDevicePolicy                      = ISNULL(@UnmanagedDevicePolicy, UnmanagedDevicePolicy),
        WebsCount                                  = ISNULL(@WebsCount, WebsCount)
    WHERE
        SiteId = @SiteId

END