function Convert-SharePointTenantBatchResponse
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

        $siteCollectionTableColumnMappings = @{
            AllowDownloadingNonWebViewableFiles         = "AllowDownloadingNonWebViewableFiles"         # bool
            AllowEditing                                = "AllowEditing"                                # bool
            AnonymousLinkExpirationInDays               = "AnonymousLinkExpirationInDays"               # int
            AuthContextStrength                         = "AuthContextStrength"                         # string
            AuthenticationContextLimitedAccess          = "AuthenticationContextLimitedAccess"          # bool
            AuthenticationContextName                   = "AuthenticationContextName"                   # string
            BlockDownloadLinksFileType                  = "BlockDownloadLinksFileType"                  # int
            BlockDownloadPolicy                         = "BlockDownloadPolicy"                         # bool
            BlockGuestsAsSiteAdmin                      = "BlockGuestsAsSiteAdmin"                      # int
            CommentsOnSitePagesDisabled                 = "CommentsOnSitePagesDisabled"                 # bool
            CompatibilityLevel                          = "CompatibilityLevel"                          # int
            ConditionalAccessPolicy                     = "ConditionalAccessPolicy"                     # int
            DefaultLinkPermission                       = "DefaultLinkPermission"                       # int
            DefaultLinkToExistingAccess                 = "DefaultLinkToExistingAccess"                 # bool
            DefaultLinkToExistingAccessReset            = "DefaultLinkToExistingAccessReset"            # bool
            DefaultShareLinkRole                        = "DefaultShareLinkRole"                        # int
            DefaultShareLinkScope                       = "DefaultShareLinkScope"                       # int
            DefaultSharingLinkType                      = "DefaultSharingLinkType"                      # int
            DenyAddAndCustomizePages                    = "DenyAddAndCustomizePages"                    # int
            Description                                 = "Description"                                 # string
            DisableCompanyWideSharingLinks              = "DisableCompanyWideSharingLinks"              # int
            ExcludeBlockDownloadPolicySiteOwners        = "ExcludeBlockDownloadPolicySiteOwners"        # bool
            ExcludedBlockDownloadGroupIds               = "ExcludedBlockDownloadGroupIds"               # string
            ExternalUserExpirationInDays                = "ExternalUserExpirationInDays"                # int
            GroupId                                     = "GroupId"                                     # Guid
            GeoLocation                                 = { $geoLocation }                              # string
            HasHolds                                    = "HasHolds"                                    # bool
            HubSiteId                                   = "HubSiteId"                                   # Guid
            IBMode                                      = "IBMode"                                      # string
            IsHubSite                                   = "IsHubSite"                                   # bool
            IsTeamsChannelConnected                     = "IsTeamsChannelConnected"                     # bool
            IsTeamsConnected                            = "IsTeamsConnected"                            # bool
            LastContentModifiedDate                     = "LastContentModifiedDate"                     # datetime
            Lcid                                        = "Lcid"                                        # int
            LimitedAccessFileType                       = "LimitedAccessFileType"                       # int
            LockIssue                                   = "LockIssue"                                   # string
            LockState                                   = "LockState"                                   # int
            LoopDefaultSharingLinkRole                  = "LoopDefaultSharingLinkRole"                  # int
            LoopDefaultSharingLinkScope                 = "LoopDefaultSharingLinkScope"                 # int
            LoopOverrideSharingCapability               = "LoopOverrideSharingCapability"               # bool
            LoopSharingCapability                       = "LoopSharingCapability"                       # int
            MediaTranscription                          = "MediaTranscription"                          # int
            OverrideBlockUserInfoVisibility             = "OverrideBlockUserInfoVisibility"             # int
            OverrideSharingCapability                   = "OverrideSharingCapability"                   # bool
            OverrideTenantAnonymousLinkExpirationPolicy = "OverrideTenantAnonymousLinkExpirationPolicy" # bool
            OverrideTenantExternalUserExpirationPolicy  = "OverrideTenantExternalUserExpirationPolicy"  # bool
            PWAEnabled                                  = "PWAEnabled"                                  # bool
            ReadOnlyAccessPolicy                        = "ReadOnlyAccessPolicy"                        # bool
            ReadOnlyForUnmanagedDevices                 = "ReadOnlyForUnmanagedDevices"                 # bool
            RelatedGroupId                              = "RelatedGroupId"                              # Guid
            RequestFilesLinkEnabled                     = "RequestFilesLinkEnabled"                     # true
            RequestFilesLinkExpirationInDays            = "RequestFilesLinkExpirationInDays"            # int
            RestrictedAccessControl                     = "RestrictedAccessControl"                     # bool
            RestrictedAccessControlGroups               = "RestrictedAccessControlGroups"               # string
            RestrictedToRegion                          = "RestrictedToRegion"                          # int
            SensitivityLabel                            = { $_.SensitivityLabel2 ? $_.SensitivityLabel2 : [Guid]::Empty.ToString() } # Guid
            SharingAllowedDomainList                    = "SharingAllowedDomainList"                    # string
            SharingBlockedDomainList                    = "SharingBlockedDomainList"                    # string
            SharingCapability                           = "SharingCapability"                           # int
            SharingDomainRestrictionMode                = "SharingDomainRestrictionMode"                # int
            SharingLockDownCanBeCleared                 = "SharingLockDownCanBeCleared"                 # bool
            SharingLockDownEnabled                      = "SharingLockDownEnabled"                      # bool
            ShowPeoplePickerSuggestionsForGuestUsers    = "ShowPeoplePickerSuggestionsForGuestUsers"    # bool
            SiteDefinedSharingCapability                = "SiteDefinedSharingCapability"                # int
            SiteId                                      = { $SiteId }                                   # Guid
            SiteUrl                                     = "Url"                                         # string
            SocialBarOnSitePagesDisabled                = "SocialBarOnSitePagesDisabled"                # bool
            Status                                      = "Status"                                      # string
            StorageMaximumLevel                         = "StorageMaximumLevel"                         # int64
            StorageQuotaType                            = "StorageQuotaType"                            # string
            StorageUsage                                = "StorageUsage"                                # int64
            StorageWarningLevel                         = "StorageWarningLevel"                         # int64
            TeamsChannelType                            = "TeamsChannelType"                            # int
            Template                                    = "Template"                                    # string
            TimeZoneId                                  = "TimeZoneId"                                  # int
            Title                                       = "Title"                                       # string
            WebsCount                                   = "WebsCount"                                   # int
        }

        $properties = foreach ( $mapping in $siteCollectionTableColumnMappings.GetEnumerator() )
        {
            if ( $mapping.value -is [string] )
            {
                @{
                    Name       = $mapping.Key
                    Expression = [ScriptBlock]::Create( "`$_.'$($mapping.value)'" )
                }
            }
            else
            {
                @{
                    Name       = $mapping.Key
                    Expression = $mapping.value
                }
            }
        }
    }
    process
    {
        Write-PSFMessage -Message "Processing batch response" -Level Verbose

        $batches = $BatchResponse.Split( @(, "--batchresponse_"), [System.StringSplitOptions]::RemoveEmptyEntries )

        $counter = 0

        $results = foreach ( $batch in $batches )
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
                    $siteId = [Guid]::Parse($Matches.SiteId).ToString()

                    # Write-PSFMessage -Message "Parsed response for site: $siteId" -Level Verbose

                    $obj | Select-Object $properties

                    $counter++
                }
            }
        }

        return ,($results -as [System.Collections.Generic.List[PSCustomObject]])
    }
    end
    {
    }
}