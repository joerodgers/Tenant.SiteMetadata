IF OBJECT_ID('dbo.SiteCollectionUsageAndActivity', 'U') IS NULL
BEGIN
	CREATE TABLE dbo.SiteCollectionUsageAndActivity
	(
		SiteId                          uniqueidentifier NOT NULL,
		LastActivityDate                int NOT NULL, -- getOffice365GroupsActivityDetail, getSharePointSiteUsageDetail, getOneDriveUsageAccountDetail
        FileCount                       int NOT NULL, -- getOffice365GroupsActivityDetail, getSharePointSiteUsageDetail, getOneDriveUsageAccountDetail
		ActiveFileCount                 int NOT NULL, -- getOffice365GroupsActivityDetail, getSharePointSiteUsageDetail, getOneDriveUsageAccountDetail
		PageViewCount                   int NOT NULL, --                                   getSharePointSiteUsageDetail
		VisitedPageCount                int NOT NULL, --                                   getSharePointSiteUsageDetail
		ExchangeMailboxStorageUsed      int NOT NULL, -- getOffice365GroupsActivityDetail
		ExchangeMailboxTotalItemCount   int NOT NULL, -- getOffice365GroupsActivityDetail
		ExchangeReceivedEmailCount      int NOT NULL, -- getOffice365GroupsActivityDetail
		MemberCount                     int NOT NULL, -- getOffice365GroupsActivityDetail
		ExternalMemberCount             int NOT NULL, -- getOffice365GroupsActivityDetail
		AnonymousLinkCount              int NOT NULL, --                                   getSharePointSiteUsageDetail (beta)
		CompanyLinkCount                int NOT NULL, --                                   getSharePointSiteUsageDetail (beta) 
		GuestLinkCount                  int NOT NULL, --                                   getSharePointSiteUsageDetail (beta)
		MemberLinkCount                 int NOT NULL, --                                   getSharePointSiteUsageDetail (beta)
		SecureLinkForGuestCount         int NOT NULL, --                                   getSharePointSiteUsageDetail (beta)
		SecureLinkForMemberCount        int NOT NULL, --                                   getSharePointSiteUsageDetail (beta)
		CONSTRAINT [PK_SiteCollectionUsageAndActivity_SiteId] PRIMARY KEY CLUSTERED (SiteId ASC)
		--CONSTRAINT FK_SiteCollectionUsageAndActivity_SiteId
		--	FOREIGN KEY (SiteId)
		--	REFERENCES dbo.SiteCollection (SiteId) 
	)
END