IF OBJECT_ID('dbo.SiteCollection', 'U') IS NULL
BEGIN
	CREATE TABLE dbo.SiteCollection
	(
		SiteId                                     uniqueidentifier NOT NULL,
		GroupId                                    uniqueidentifier NULL, -- sites REST API
		ConditionalAccessPolicy                    int              NULL, -- sites REST API
		CreatedBy                                  uniqueidentifier NULL,
		CreatedDate                                date             NULL,
--		DeletedBy                                  uniqueidentifier NULL,
		DeletedDate                                date             NULL,
		DenyAddAndCustomizePagesEnabled            bit              NULL, -- sites REST API
		DisplayName                                nvarchar(255)    NULL, -- sites REST API
		ExternalUserExpirationInDays               int              NULL, -- sites REST API
		GeoLocation                                nvarchar(10)     NULL, -- getSharePointSiteUsageDetail (beta)
		HasHolds                                   bit              NULL, -- sites REST API
		HubSiteId                                  uniqueidentifier NULL, -- sites REST API
		InformationBarrierMode                     int              NULL, -- sites REST API         
--		IsDeleted                                  bit              NULL, -- getSharePointSiteUsageDetail (beta)
		IsGroupOwnerSiteAdmin                      bit              NULL, -- sites REST API
		IsHubSite                                  bit              NULL, -- sites REST API
		IsProjectConnected                         bit              NULL,  -- sites REST API
		IsPublic                                   bit              NULL, -- getOffice365GroupsActivityDetail
		IsTeamsChannelConnected                    bit              NULL, -- sites REST API
		IsTeamsConnected                           bit              NULL, -- sites REST API
		IsYammerConnected                          bit              NULL, 
		IsPlannerConnected                         bit              NULL, 
--		LastCertificationDate                      datetime2(7)     NULL,
		LastItemModifiedDate                       datetime2(7)     NULL, -- sites REST API
		Lcid                                       int              NULL, -- sites REST API
		LockState                                  int              NULL, -- sites REST API
		OverrideTenantExternalUserExpirationPolicy bit              NULL, -- sites REST API	 
		RelatedGroupId                             uniqueidentifier NULL, -- sites REST API
        RestrictedToRegion                         int              NULL, -- sites REST API           
		SensitivityLabel                           uniqueidentifier NULL, -- sites REST API
		SharingCapability                          int              NULL, -- sites REST API
		SharingDomainRestrictionMode               int              NULL, -- sites REST API
		SharingLockDownCanBeCleared                bit              NULL, -- sites REST API          
        SharingLockDownEnabled                     bit              NULL, -- sites REST API
		SiteDefinedSharingCapability               int              NULL, -- sites REST API
		SiteCreationSource                         uniqueidentifier NULL, -- DO_NOT_DELETE_SPLIST_TENANTADMIN_AGGREGATED_SITECOLLECTIONS
		SiteUrl                                    nvarchar(450)    NULL, -- sites REST API
		StorageQuota                               bigint           NULL, -- sites REST API
		StorageUsed                                bigint           NULL, -- sites REST API
		TeamsChannelType                           int              NULL, -- sites REST API
		Template                                   nvarchar(255)    NULL, -- sites REST API
		TimeZoneId                                 int              NULL, -- sites REST API
		UnmanagedDevicePolicy                      [nchar](10)      NULL, -- getSharePointSiteUsageDetail (beta)
		WebsCount                                  int              NULL, -- sites REST API
		CONSTRAINT PK_Entity_SiteId PRIMARY KEY CLUSTERED (SiteId ASC),
	)
	CREATE NONCLUSTERED INDEX IX_SiteCollection_GroupId ON dbo.SiteCollection (GroupId ASC)
END