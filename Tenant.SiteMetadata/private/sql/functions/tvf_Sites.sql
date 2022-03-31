CREATE OR ALTER FUNCTION dbo.tvf_Sites
(
	@SiteType   int = 1, 
	@SiteStatus int = 1
)
RETURNS @SiteCollection TABLE
(
		SiteId                                     uniqueidentifier NOT NULL,
		GroupId                                    uniqueidentifier NULL,
		ConditionalAccessPolicy                    int              NULL,
		CreatedBy                                  uniqueidentifier NULL,
		CreatedDate                                date             NULL,
		DeletedDate                                date             NULL,
		DenyAddAndCustomizePagesEnabled            bit              NULL,
		DisplayName                                nvarchar(255)    NULL,
		ExternalUserExpirationInDays               int              NULL,
		GeoLocation                                nvarchar(10)     NULL,
		HasHolds                                   bit              NULL,
		HubSiteId                                  uniqueidentifier NULL,
		InformationBarrierMode                     int              NULL,         
		IsGroupOwnerSiteAdmin                      bit              NULL,
		IsHubSite                                  bit              NULL,
		IsProjectConnected                         bit              NULL, 
		IsPublic                                   bit              NULL,
		IsTeamsChannelConnected                    bit              NULL,
		IsTeamsConnected                           bit              NULL,
		IsYammerConnected                          bit              NULL, 
		IsPlannerConnected                         bit              NULL, 
		LastItemModifiedDate                       datetime2(7)     NULL,
		Lcid                                       int              NULL,
		LockState                                  int              NULL,
		OverrideTenantExternalUserExpirationPolicy bit              NULL,	 
		RelatedGroupId                             uniqueidentifier NULL,
        RestrictedToRegion                         int              NULL,           
		SensitivityLabel                           uniqueidentifier NULL,
		SharingCapability                          int              NULL,
		SharingDomainRestrictionMode               int              NULL,
		SharingLockDownCanBeCleared                bit              NULL,          
        SharingLockDownEnabled                     bit              NULL,
		SiteDefinedSharingCapability               int              NULL,
		SiteCreationSource                         uniqueidentifier NULL,
		SiteUrl                                    nvarchar(450)    NULL,
		StorageQuota                               bigint           NULL,
		StorageUsed                                bigint           NULL,
		TeamsChannelType                           int              NULL,
		Template                                   nvarchar(255)    NULL,
		TimeZoneId                                 int              NULL,
		UnmanagedDevicePolicy                      [nchar](10)      NULL,
		WebsCount                                  int              NULL 
) 
AS
BEGIN

	/*
		Enums.ps1

			SiteStatus
				Active    = 1
				Deleted   = 2

			SiteType
				SharePoint = 1
				OneDrive   = 2
				Teams      = 4
				Group      = 8
				All        = 15
	*/

	-- SHAREPOINT
    IF (@SiteType & 1) <> 0 AND (@SiteStatus & 1) <> 0
        INSERT INTO @SiteCollection SELECT * FROM dbo.SiteCollection WHERE Template NOT LIKE 'SPSMSITEHOST%' AND Template NOT LIKE 'SPSPERS%' AND DeletedDate IS NULL AND SiteId NOT IN (SELECT SiteId FROM @SiteCollection)
    IF (@SiteType & 1) <> 0 AND (@SiteStatus & 2) <> 0
        INSERT INTO @SiteCollection SELECT * FROM dbo.SiteCollection WHERE Template NOT LIKE 'SPSMSITEHOST%' AND Template NOT LIKE 'SPSPERS%' AND DeletedDate IS NOT NULL AND SiteId NOT IN (SELECT SiteId FROM @SiteCollection)

	-- ONEDRIVE
    IF (@SiteType & 2) <> 0 AND (@SiteStatus & 1) <> 0
        INSERT INTO @SiteCollection SELECT * FROM dbo.SiteCollection WHERE (Template LIKE 'SPSMSITEHOST%' OR Template LIKE 'SPSPERS%') AND DeletedDate IS NULL AND SiteId NOT IN (SELECT SiteId FROM @SiteCollection)
    IF (@SiteType & 2) <> 0 AND (@SiteStatus & 2) <> 0
        INSERT INTO @SiteCollection SELECT * FROM dbo.SiteCollection WHERE (Template LIKE 'SPSMSITEHOST%' OR Template LIKE 'SPSPERS%') AND DeletedDate IS NOT NULL AND SiteId NOT IN (SELECT SiteId FROM @SiteCollection)

	-- TEAMS
    IF (@SiteType & 4) <> 0 AND (@SiteStatus & 1) <> 0
        INSERT INTO @SiteCollection SELECT * FROM dbo.SiteCollection WHERE IsTeamsConnected = 1 AND DeletedDate IS NULL AND SiteId NOT IN (SELECT SiteId FROM @SiteCollection)
    IF (@SiteType & 4) <> 0 AND (@SiteStatus & 2) <> 0
        INSERT INTO @SiteCollection SELECT * FROM dbo.SiteCollection WHERE IsTeamsConnected = 1 AND DeletedDate IS NOT NULL AND SiteId NOT IN (SELECT SiteId FROM @SiteCollection)

	-- GROUPS
    IF (@SiteType & 8) <> 0 AND (@SiteStatus & 1) <> 0
        INSERT INTO @SiteCollection SELECT * FROM dbo.SiteCollection WHERE GroupId IS NOT NULL AND GroupId <> '00000000-0000-0000-0000-000000000000' AND DeletedDate IS NULL AND SiteId NOT IN (SELECT SiteId FROM @SiteCollection)
    IF (@SiteType & 8) <> 0 AND (@SiteStatus & 2) <> 0
        INSERT INTO @SiteCollection SELECT * FROM dbo.SiteCollection WHERE GroupId IS NOT NULL AND GroupId <> '00000000-0000-0000-0000-000000000000' AND DeletedDate IS NOT NULL AND SiteId NOT IN (SELECT SiteId FROM @SiteCollection)

    RETURN

END
