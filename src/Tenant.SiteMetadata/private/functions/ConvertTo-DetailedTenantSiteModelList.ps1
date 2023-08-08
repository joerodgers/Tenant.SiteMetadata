function ConvertTo-DetailedTenantSiteModelList
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $BatchResponse
    )    

    begin
    {
        $geoLocation = Get-SharePointTenantGeoLocation

        $models = New-Object System.Collections.Generic.List[DetailedTenantSiteModel]
    }
    process
    {
        Write-PSFMessage -Message "Processing batch response" -Level Verbose

        $batches = $BatchResponse.Split( @(, "--batchresponse_"), [System.StringSplitOptions]::RemoveEmptyEntries )

        foreach ( $batch in $batches )
        {
            if ($batch -notmatch "HTTP/1\.1 200 OK" )
            {
                continue
            }

            $lines = $batch -split [Environment]::NewLine
            
            foreach ( $line in $lines )
            {
                if ( $line.Contains( '{"odata.metadata"') )
                {
                    # convert json string to PSObject
                    $obj = $line | ConvertFrom-Json
                    
                    # extract the SiteId 
                    $null = $obj.'odata.id' -match "sites\('(?<SiteId>.*)'\)" 

                    # determine SiteId from response.  The $siteId variable is referenced during the execution of $properties 
                    $siteId = [Guid]::Parse($Matches.SiteId)

                    $model = [DetailedTenantSiteModel]::new()
                    $model.AllowDownloadingNonWebViewableFiles         = $obj.AllowDownloadingNonWebViewableFiles
                    $model.AllowEditing                                = $obj.AllowEditing
                    $model.AnonymousLinkExpirationInDays               = $obj.AnonymousLinkExpirationInDays
                    $model.AuthenticationContextLimitedAccess          = $obj.AuthenticationContextLimitedAccess
                    $model.AuthenticationContextName                   = $obj.AuthenticationContextName
                    $model.BlockDownloadLinksFileType                  = $obj.BlockDownloadLinksFileType
                    $model.BlockDownloadPolicy                         = $obj.BlockDownloadPolicy
                    $model.BlockGuestsAsSiteAdmin                      = $obj.BlockGuestsAsSiteAdmin
                    $model.ClearRestrictedAccessControl                = $obj.ClearRestrictedAccessControl
                    $model.CommentsOnSitePagesDisabled                 = $obj.CommentsOnSitePagesDisabled
                    $model.CompatibilityLevel                          = $obj.CompatibilityLevel
                    $model.ConditionalAccessPolicy                     = $obj.ConditionalAccessPolicy
                    $model.CreatedDate                                 = $null # not returned by rest api
                    $model.DefaultLinkPermission                       = $obj.DefaultLinkPermission
                    $model.DefaultLinkToExistingAccess                 = $obj.DefaultLinkToExistingAccess
                    $model.DefaultLinkToExistingAccessReset            = $obj.DefaultLinkToExistingAccessReset
                    $model.DefaultShareLinkRole                        = $obj.DefaultShareLinkRole
                    $model.DefaultShareLinkScope                       = $obj.DefaultShareLinkScope
                    $model.DefaultSharingLinkType                      = $obj.DefaultSharingLinkType
                    $model.DeletedDate                                 = $null # not returned by rest api
                    $model.DenyAddAndCustomizePages                    = $obj.DenyAddAndCustomizePages
                    $model.Description                                 = $obj.Description
                    $model.DisableAppViews                             = $obj.DisableAppViews
                    $model.DisableCompanyWideSharingLinks              = $obj.DisableCompanyWideSharingLinks
                    $model.DisableFlows                                = $obj.DisableFlows
                    $model.ExcludeBlockDownloadPolicySiteOwners        = $obj.ExcludeBlockDownloadPolicySiteOwners
                    $model.ExternalUserExpirationInDays                = $obj.ExternalUserExpirationInDays
                    $model.Geolocation                                 = $geoLocation
                    $model.GroupId                                     = $obj.GroupId ? $obj.GroupId : [Guid]::Empty
                    $model.HasHolds                                    = $obj.HasHolds
                    $model.HubSiteId                                   = $obj.HubSiteId ? $obj.HubSiteId : [Guid]::Empty
                    $model.IBMode                                      = $obj.IBMode
                    $model.IsHubSite                                   = $obj.IsHubSite
                    $model.IsTeamsChannelConnected                     = $obj.IsTeamsChannelConnected
                    $model.IsTeamsConnected                            = $obj.IsTeamsConnected
                    $model.LastContentModifiedDate                     = $obj.LastContentModifiedDate ? $obj.LastContentModifiedDate : $null
                    $Model.Lcid                                        = $obj.Lcid
                    $model.LimitedAccessFileType                       = $obj.LimitedAccessFileType
                    $model.ListsShowHeaderAndNavigation                = $obj.ListsShowHeaderAndNavigation
                    $model.LockIssue                                   = $obj.LockIssue
                    $model.LockState                                   = $obj.LockState
                    $model.LoopDefaultSharingLinkRole                  = $obj.LoopDefaultSharingLinkRole
                    $model.LoopDefaultSharingLinkScope                 = $obj.LoopDefaultSharingLinkScope
                    $model.LoopOverrideSharingCapability               = $obj.LoopOverrideSharingCapability
                    $model.LoopSharingCapability                       = $obj.LoopSharingCapability
                    $model.MediaTranscription                          = $obj.MediaTranscription
                    $model.OverrideBlockUserInfoVisibility             = $obj.OverrideBlockUserInfoVisibility
                    $model.OverrideSharingCapability                   = $obj.OverrideSharingCapability
                    $model.OverrideTenantAnonymousLinkExpirationPolicy = $obj.OverrideTenantAnonymousLinkExpirationPolicy
                    $model.OverrideTenantExternalUserExpirationPolicy  = $obj.OverrideTenantExternalUserExpirationPolicy
                    $model.Owner                                       = $obj.Owner
                    $model.PWAEnabled                                  = $obj.PWAEnabled
                    $model.ReadOnlyAccessPolicy                        = $obj.ReadOnlyAccessPolicy
                    $model.ReadOnlyForBlockDownloadPolicy              = $obj.ReadOnlyForBlockDownloadPolicy
                    $model.ReadOnlyForUnmanagedDevices                 = $obj.ReadOnlyForUnmanagedDevices
                    $model.RelatedGroupId                              = $obj.RelatedGroupId ? $obj.RelatedGroupId : [Guid]::Empty
                    $model.RequestFilesLinkEnabled                     = $obj.RequestFilesLinkEnabled
                    $model.RequestFilesLinkExpirationInDays            = $obj.RequestFilesLinkExpirationInDays
                    $model.RestrictedAccessControl                     = $obj.RestrictedAccessControl
                    $model.RestrictedToRegion                          = $obj.RestrictedToRegion
                    $model.SensitivityLabel                            = $obj.SensitivityLabel2 ? $obj.SensitivityLabel2 : [Guid]::Empty
                    $model.SharingAllowedDomainList                    = $obj.SharingAllowedDomainList
                    $model.SharingBlockedDomainList                    = $obj.SharingBlockedDomainList
                    $model.SharingCapability                           = $obj.SharingCapability
                    $model.SharingDomainRestrictionMode                = $obj.SharingDomainRestrictionMode
                    $model.SharingLockDownCanBeCleared                 = $obj.SharingLockDownCanBeCleared
                    $model.SharingLockDownEnabled                      = $obj.SharingLockDownEnabled
                    $model.ShowPeoplePickerSuggestionsForGuestUsers    = $obj.ShowPeoplePickerSuggestionsForGuestUsers
                    $model.SiteCreationSource                          = $null # not returned by rest api
                    $model.SiteDefinedSharingCapability                = $obj.SiteDefinedSharingCapability
                    $model.SiteId                                      = $siteId
                    $model.SiteUrl                                     = $obj.Url
                    $model.SocialBarOnSitePagesDisabled                = $obj.SocialBarOnSitePagesDisabled
                    $model.Status                                      = $obj.Status
                    $model.StorageMaximumLevel                         = $obj.StorageMaximumLevel
                    $model.StorageQuotaType                            = $obj.StorageQuotaType
                    $Model.StorageUsage                                = $obj.StorageUsage
                    $model.StorageWarningLevel                         = $obj.StorageWarningLevel
                    $model.TeamsChannelType                            = $obj.TeamsChannelType
                    $model.Template                                    = $obj.Template
                    $model.TimeZoneId                                  = $obj.TimeZoneId
                    $model.Title                                       = $obj.Title
                    $model.TotalFileCount                              = $null # not returned by rest api
                    $model.WebsCount                                   = $obj.WebsCount

                    $models.Add( $model )
                }
            }
        }
    }
    end
    {
        return ,$models
    }
}