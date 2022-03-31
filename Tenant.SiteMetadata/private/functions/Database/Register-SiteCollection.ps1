function Register-SiteCollection
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [Guid]
        $SiteId,

        [Parameter(Mandatory=$false)]
        [ValidateSet(0,1,2,3)]
        [int]
        $ConditionalAccessPolicy,

        [Parameter(Mandatory=$false)]
        [Nullable[DateTime]]
        $CreatedDate,

        [Parameter(Mandatory=$false)]
        [Nullable[DateTime]]
        $DeletedDate,

        [Parameter(Mandatory=$false)]
        [ValidateSet(0,1,2)]
        [int]
        $DenyAddAndCustomizePagesEnabled,

        [Parameter(Mandatory=$false)]
        [string]
        $DisplayName,

        [Parameter(Mandatory=$false)]
        [int]
        $ExternalUserExpirationInDays,

        [Parameter(Mandatory=$false)]
        [Guid]
        $GroupId,

        #[Parameter(Mandatory=$false)]
        #[string]
        #$GroupOwnerLoginName,

        [Parameter(Mandatory=$false)]
        [bool]
        $HasHolds,

        [Parameter(Mandatory=$false)]
        [Guid]
        $HubSiteId,

        [Parameter(Mandatory=$false)]
        [ValidateSet(0,1,2,3,4)]
        [int]
        $InformationBarrierMode,

        [Parameter(Mandatory=$false)]
        [Guid[]]
        $IBSegment,

        [Parameter(Mandatory=$false)]
        [bool]
        $IsHubSite,

        [Parameter(Mandatory=$false)]
        [bool]
        $IsGroupOwnerSiteAdmin,

        [Parameter(Mandatory=$false)]
        [bool]
        $IsTeamsChannelConnected,

        [Parameter(Mandatory=$false)]
        [bool]
        $IsTeamsConnected,

        [Parameter(Mandatory=$false)]
        [Nullable[DateTime]]
        $LastItemModifiedDate,

        [Parameter(Mandatory=$false)]
        [int]
        $Lcid,
        
        [Parameter(Mandatory=$false)]
        [ValidateSet(0,1,2,3)]
        [int]
        $LockState,

        [Parameter(Mandatory=$false)]
        [bool]
        $IsProjectConnected,

        [Parameter(Mandatory=$false)]
        [Guid]
        $RelatedGroupId,

        [Parameter(Mandatory=$false)]
        [bool]
        $OverrideTenantExternalUserExpirationPolicy,

        [Parameter(Mandatory=$false)]
        [ValidateSet(0,1,2,3)]
        [int]
        $RestrictedToRegion,

        [Parameter(Mandatory=$false)]
        [Guid]
        $SensitivityLabel,

        [Parameter(Mandatory=$false)]
        [string]
        $SharingAllowedDomainList,

        [Parameter(Mandatory=$false)]
        [string]
        $SharingBlockedDomainList,

        [Parameter(Mandatory=$false)]
        [int]
        [ValidateSet(0,1,2,3)]
        $SharingCapability,

        [Parameter(Mandatory=$false)]
        [ValidateSet(0,1,2)]
        [int]
        $SharingDomainRestrictionMode,
        
        [Parameter(Mandatory=$false)]
        [bool]
        $SharingLockDownCanBeCleared,

        [Parameter(Mandatory=$false)]
        [bool]
        $SharingLockDownEnabled,

        [Parameter(Mandatory=$false)]
        [Guid]
        $SiteCreationSource,

        [Parameter(Mandatory=$false)]
        [ValidateSet(0,1,2,3)]
        [int]
        $SiteDefinedSharingCapability,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [Parameter(Mandatory=$false)]
        [long]
        $StorageQuota,

        [Parameter(Mandatory=$false)]
        [long]
        $StorageUsed,

        [Parameter(Mandatory=$false)]
        [ValidateSet(0,1,2,3)]
        [int]
        $TeamsChannelType,

        [Parameter(Mandatory=$false)]
        [string]
        $Template,

        [Parameter(Mandatory=$false)]
        [int]
        $TimeZoneId,

        [Parameter(Mandatory=$false)]
        [int]
        $WebsCount
    )
<#
    ConditionalAccessPolicy                     : 0
    DenyAddAndCustomizePages                    : 2
    ExternalUserExpirationInDays                : 0
    GroupId                                     : 921e46b1-9140-4982-8aa8-e3df9805ba40
    GroupOwnerLoginName                         : c:0o.c|federateddirectoryclaimprovider|921e46b1-9140-4982-8aa8-e3df9805ba40_o
    HasHolds                                    : False
    HubSiteId                                   : 00000000-0000-0000-0000-000000000000
    IBMode                                      : 
    IBSegments                                  : {}
    IBSegmentsToAdd                             : 
    IBSegmentsToRemove                          : 
    IsHubSite                                   : False
    IsGroupOwnerSiteAdmin                       : True
    IsTeamsChannelConnected                     : False
    IsTeamsConnected                            : True
    LastContentModifiedDate                     : 2022-02-10T05:12:48.29
    Lcid                                        : 1033
    LockState                                   : Unlock
    Owner                                       : 921e46b1-9140-4982-8aa8-e3df9805ba40_o
    PWAEnabled                                  : 0
    RelatedGroupId                              : 921e46b1-9140-4982-8aa8-e3df9805ba40
    RestrictedToRegion                          : 3
    SensitivityLabel2                           : 339aa8f2-9815-4b49-b71a-f3f903233b50
    SharingAllowedDomainList                    : 
    SharingBlockedDomainList                    : 
    SharingCapability                           : 1
    SharingDomainRestrictionMode                : 0
    SharingLockDownCanBeCleared                 : True
    SharingLockDownEnabled                      : False
    StorageMaximumLevel                         : 26214400
    StorageUsage                                : 1
    TeamsChannelType                            : 0
    Template                                    : GROUP#0
    TimeZoneId                                  : 13
    Title                                       : 000 Public Team
    Url                                         : https://josrod.sharepoint.com/sites/000PublicTeam
    WebsCount                                   : 1
#>

    $storedProcedureName            = "proc_AddOrUpdateSiteCollection"
    $storedProcedureParameterString = $PSBoundParameters | ConvertTo-StoredProcedureParameterString
    $storedProcedureParameterValues = $PSBoundParameters | ConvertTo-StoredProcedureParameterHashTable
    $storedProcedureExectionString  = "EXEC $storedProcedureName $storedProcedureParameterString"

    try
    {
        Invoke-NonQuery `
            -Query      $storedProcedureExectionString `
            -Parameters $storedProcedureParameterValues `
            -ErrorAction Stop
    }
    catch
    {
        Write-PSFMessage -Message "Failed to execute $storedProcedureName." -EnableException $true -ErrorRecord $_ -Level Critical
        throw $_.Exception
    }
}
