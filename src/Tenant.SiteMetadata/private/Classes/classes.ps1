using namespace Tenant.SiteMetadata

# defaulting all these to null to force the JSON to be NULL, which forces proc_AddOrUpdateSiteCollection to only update columns with non-null values
<#

if ( -not "SiteDetailBatchRequestModel" -as [Type] ) 
{
    class SiteDetailBatchRequestModel
    {
        [Guid]
        $BatchId

        [string]
        $BatchBody

        [System.Collections.Generic.List[Guid]]
        $SiteIdList

        [string]
        $TenantAdminUrl

        [Tenant.SiteMetadata.ITenantConnectionInformation]
        $TenantConnection
    }
}
#>

if ( -not "TenantSiteModel" -as [Type] ) 
{
    class TenantSiteModel
    {
        [Nullable[Guid]]
        $SiteId = $null
        
        [string]
        $SiteUrl = $null

        [Nullable[Guid]]
        $GroupId = $null

        [Nullable[DateTime]]
        $CreatedDate = $null

        [Nullable[DateTime]]
        $DeletedDate = $null

        [string]
        $Description = $null

        [Nullable[Guid]]
        $HubSiteId = $null

        [Nullable[DateTime]]
        $LastContentModifiedDate

        [string]
        $LockIssue = $null
        
        [string]
        $LockState = $null

        [Nullable[Guid]]
        $RelatedGroupId = $null

        [Nullable[Guid]]
        $SensitivityLabel = $null

        [Nullable[Guid]]
        $SiteCreationSource = $null

        [string]
        $Status = $null

        [Nullable[int64]]
        $StorageMaximumLevel = $null
        
        [string]
        $StorageQuotaType = $null
        
        [Nullable[int64]]
        $StorageUsage = $null

        [Nullable[int64]]
        $StorageWarningLevel = $null

        [string]
        $Template = $null

        [string]
        $Title = $null
        
        [Nullable[int]]
        $TotalFileCount = $null

        TenantSiteModel()
        {
        }
    }
}

if ( -not "DetailedTenantSiteModel" -as [Type] ) 
{
    class DetailedTenantSiteModel : TenantSiteModel
    {
        [Nullable[bool]]
        $AllowDownloadingNonWebViewableFiles

        [Nullable[bool]]
        $AllowEditing

        [Nullable[int64]]
        $AnonymousLinkExpirationInDays

        [Nullable[bool]]
        $AuthenticationContextLimitedAccess

        [string]
        $AuthenticationContextName

        [Nullable[int64]]
        $BlockDownloadLinksFileType

        [Nullable[bool]]
        $BlockDownloadPolicy

        [Nullable[int64]]
        $BlockGuestsAsSiteAdmin

        [Nullable[bool]]
        $ClearRestrictedAccessControl

        [Nullable[bool]]
        $CommentsOnSitePagesDisabled

        [Nullable[int64]]
        $CompatibilityLevel

        [Nullable[int64]]
        $ConditionalAccessPolicy

        [Nullable[int64]]
        $DefaultLinkPermission

        [Nullable[bool]]
        $DefaultLinkToExistingAccess

        [Nullable[bool]]
        $DefaultLinkToExistingAccessReset

        [Nullable[int64]]
        $DefaultShareLinkRole

        [Nullable[int64]]
        $DefaultShareLinkScope

        [Nullable[int64]]
        $DefaultSharingLinkType

        [Nullable[int64]]
        $DenyAddAndCustomizePages

        [Nullable[int64]]
        $DisableAppViews

        [Nullable[int64]]
        $DisableCompanyWideSharingLinks

        [Nullable[int64]]
        $DisableFlows

        [Nullable[bool]]
        $ExcludeBlockDownloadPolicySiteOwners

        [Nullable[int64]]
        $ExternalUserExpirationInDays

        [string]
        $Geolocation

        [Nullable[bool]]
        $HasHolds

        [string]
        $IBMode

        [Nullable[bool]]
        $IsHubSite

        [Nullable[bool]]
        $IsTeamsChannelConnected

        [Nullable[bool]]
        $IsTeamsConnected

        [string]
        $Lcid

        [Nullable[int64]]
        $LimitedAccessFileType

        [Nullable[bool]]
        $ListsShowHeaderAndNavigation

        [Nullable[int64]]
        $LoopDefaultSharingLinkRole

        [Nullable[int64]]
        $LoopDefaultSharingLinkScope

        [Nullable[bool]]
        $LoopOverrideSharingCapability

        [Nullable[int64]]
        $LoopSharingCapability

        [Nullable[int64]]
        $MediaTranscription

        [Nullable[int64]]
        $OverrideBlockUserInfoVisibility

        [Nullable[bool]]
        $OverrideSharingCapability

        [Nullable[bool]]
        $OverrideTenantAnonymousLinkExpirationPolicy

        [Nullable[bool]]
        $OverrideTenantExternalUserExpirationPolicy

        #[string]
        #$Owner

        [Nullable[int64]]
        $PWAEnabled

        [Nullable[bool]]
        $ReadOnlyAccessPolicy

        [Nullable[bool]]
        $ReadOnlyForBlockDownloadPolicy

        [Nullable[bool]]
        $ReadOnlyForUnmanagedDevices

        [Nullable[bool]]
        $RequestFilesLinkEnabled

        [Nullable[int64]]
        $RequestFilesLinkExpirationInDays

        [Nullable[bool]]
        $RestrictedAccessControl

        [Nullable[int64]]
        $RestrictedToRegion

        [string]
        $SharingAllowedDomainList

        [string]
        $SharingBlockedDomainList

        [Nullable[int64]]
        $SharingCapability

        [Nullable[int64]]
        $SharingDomainRestrictionMode

        [Nullable[bool]]
        $SharingLockDownCanBeCleared

        [Nullable[bool]]
        $SharingLockDownEnabled

        [Nullable[bool]]
        $ShowPeoplePickerSuggestionsForGuestUsers

        [Nullable[int64]]
        $SiteDefinedSharingCapability

        [Nullable[bool]]
        $SocialBarOnSitePagesDisabled

        [Nullable[int64]]
        $TeamsChannelType

        [Nullable[int64]]
        $TimeZoneId

        [Nullable[int64]]
        $WebsCount
    }
}
