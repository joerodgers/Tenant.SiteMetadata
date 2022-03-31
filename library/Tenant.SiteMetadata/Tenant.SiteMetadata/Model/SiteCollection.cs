using System;

namespace Tenant.SiteMetadata.Model
{
    public class SiteCollection
    {
        public Guid SiteId { get; set; }

        public Guid GroupId { get; set; }

		public int ConditionalAccessPolicy { get; set; }

		public Guid CreatedBy { get; set; }

		public DateTime? CreatedDate { get; set; }

		public DateTime? DeletedDate { get; set; }

		public bool DenyAddAndCustomizePagesEnabled { get; set; }

		public string DisplayName { get; set; }

		public int ExternalUserExpirationInDays { get; set; }

		public string GeoLocation { get; set; }

		public bool HasHolds { get; set; }

		public Guid HubSiteId { get; set; }

		public int InformationBarrierMode { get; set; }

		public bool IsGroupOwnerSiteAdmin { get; set; }
		
		public bool IsProjectConnected { get; set; }

		public bool IsPublic { get; set; }

		public bool IsTeamsChannelConnected { get; set; }

		public bool IsTeamsConnected { get; set; }

		public bool IsYammerConnected { get; set; }

		public bool IsPlannerConnected { get; set; }

		public DateTime? LastItemModifiedDate { get; set; }

		public int Lcid { get; set; }

		public int LockState { get; set; }

		public int OverrideTenantExternalUserExpirationPolicy { get; set; }

		public Guid RelatedGroupId { get; set; }

		public int RestrictedToRegion { get; set; }

		public Guid SensitivityLabel { get; set; }

		public int SharingCapability { get; set; }

		public int SharingDomainRestrictionMode { get; set; }

		public bool SharingLockDownCanBeCleared { get; set; }

		public bool SharingLockDownEnabled { get; set; }

		public int SiteDefinedSharingCapability { get; set; }

		public Guid SiteCreationSource { get; set; }

		public Uri SiteUrl { get; set; }

		public long StorageQuota { get; set; }

		public long StorageUsed { get; set; }

		public int TeamsChannelType { get; set; }

		public string Template { get; set; }

		public int TimeZoneId { get; set; }

		public string UnmanagedDevicePolicy { get; set; }

		public int WebsCount { get; set; }
	}
}
