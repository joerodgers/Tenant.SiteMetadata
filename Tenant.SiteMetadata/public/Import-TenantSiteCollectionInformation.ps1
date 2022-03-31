using namespace Tenant.SiteMetadata

function Import-TenantSiteCollectionInformation
{
<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER DatabaseConnectionInformation

    .PARAMETER TenantConnectionInformation

    .EXAMPLE
#>
    [CmdletBinding(DefaultParameterSetName="All")]
    param
    (
        [Parameter(Mandatory=$false,ParameterSetName="Identity")]
        [System.Uri]
        $Identity,

        [Parameter(Mandatory=$false,ParameterSetName="All")]
        [switch]
        $All,

        [Parameter(Mandatory=$false,ParameterSetName="DeltaSync")]
        [switch]
        $UseDeltaSync,

        [Parameter(Mandatory=$false,ParameterSetName="ChangeDate")]
        [DateTime]
        $ChangedSince
    )

    begin
    {
        $cmdletExecutionId = Start-CmdletExecution -Cmdlet $PSCmdlet -ClearErrors

        $batchRequest = New-Object Tenant.SiteMetadata.BatchRequest
        
        $batchsize = [Math]::Min( (Get-ConfigurationSetting -ConfigurationSettingName "BatchSize" -DefaultValue 100), 100)

        $informationBarrierModes = Get-InformationBarrierMode -All
        $lockStates              = Get-LockState              -All

        $siteCollections = @()
        $counter = 0
    }
    process
    {
        Initialize-SharePointTenantConnection
        Assert-SharePointConnection -Cmdlet $PSCmdlet

        if( $PSCmdlet.ParameterSetName -eq "All" )
        {
            Invoke-SharePointTenantSiteCreationSourceImport
            Invoke-SharePointTenantDeletedSiteImport

            $siteCollections = @(Get-TenantSiteMetadataModelSiteCollection -All)
        }
        elseif( $PSCmdlet.ParameterSetName -eq "Identity" )
        {
            $siteCollections = @(Get-TenantSiteMetadataModelSiteCollection -SiteUrl $Identity)
        }
        elseif( $PSCmdlet.ParameterSetName -eq "DeltaSync" )
        {
            $deltaToken = Get-CmdletDeltaToken -Cmdlet $PSCmdlet.MyInvocation.MyCommand.Name

            if( [string]::IsNullOrWhiteSpace($deltaToken) )
            {
                Write-PSFMessage -Message "No existing delta token found, executing a full sync which will create a new delta token." -Level Warning
                $deltaToken = ""
            }

            $siteCollections = @(Get-TenantSiteMetadataModelSiteCollection -DeltaToken ([ref] $deltaToken))

            Write-PSFMessage -Message "Delta site count: $($siteCollections.Count)"

            if( [string]::IsNullOrWhiteSpace($deltaToken) )
            {
                Write-PSFMessage -Message "No delta token was not returned." -Level Warning
            }
            else
            {
                Set-CmdletDeltaToken -Cmdlet $PSCmdlet.MyInvocation.MyCommand.Name -DeltaToken $deltaToken
            }

            $excludedSiteCollections += Get-TenantSiteMetadataModelSiteCollection -ExcludedSiteTemplates

            Write-PSFMessage -Message "Excluded site templates site count: $($excludedSiteCollections.Count)"

            $siteCollections += $excludedSiteCollections
        }
        elseif( $PSCmdlet.ParameterSetName -eq "ChangeDate" )
        {
            $deltaToken = New-SharePointTenantSiteAllSitesListChangeToken -ChangedSince $ChangedSince
            $siteCollections  = @(Get-TenantSiteMetadataModelSiteCollection -DeltaToken ([ref] $deltaToken))
            $siteCollections += @(Get-TenantSiteMetadataModelSiteCollection -ExcludedSiteTemplates)
        }

        $lockedSiteCollections = @(Get-TenantSiteMetadataModelSiteCollection -LockState "NoAccess")

        Write-PSFMessage -Message "Discoverd site count: $($siteCollections.Count)"
        Write-PSFMessage -Message "Discoverd locked site count: $($lockedSiteCollections.Count)"
       
        foreach( $siteCollection in $siteCollections )
        {
            $counter++ 

            $registerParams = @{}
            $registerParams.SiteId               = $siteCollection.SiteId
            $registerParams.SiteUrl              = $siteCollection.SiteUrl
            $registerParams.LastItemModifiedDate = $siteCollection.LastModifiedDateTime
            $registerParams.CreatedDate          = $siteCollection.CreatedDateTime

            if( $lockedSiteCollections.SiteUrl -contains $siteCollection.SiteUrl )
            {
                # cannot do anyting else with locked sites but log the basics

                $registerParams.LockState = 3
                Register-SiteCollection @registerParams

                Write-PSFMessage -Message "Site locked 'NoAccess' - $($siteCollection.SiteUrl)"
                continue
            }

            if( $siteCollection.DeletedDate )
            {
                $registerParams.DeletedDate = $siteCollection.DeletedDate
            }

            # do a basic import into sql so we ensure all sites have a SiteId and SiteUrl
            Register-SiteCollection @registerParams

            if( $counter % 100 -eq 0 -or $counter -eq $siteCollections.Count ) { Write-PSFMessage -Message "Imported basic data for $counter site collections" }

            # build the batch requests
            $bri = New-Object Tenant.SiteMetadata.BatchRequestItem -Property @{
                Url        = "/_api/Microsoft.Online.SharePoint.TenantAdministration.Tenant/sites('$($siteCollection.SiteId.ToString())')"
                HttpMethod = [System.Net.Http.HttpMethod]::Get
            }

            $batchRequest.BatchRequestItems.Add($bri)
        }

        # split the batch requests into chunks of 100
        $batchRequests = Split-BatchRequest -BatchRequest $BatchRequest -ChunkSize $batchsize

        $successfulSiteIds = New-Object System.Collections.Generic.List[Guid]

        $batchCounter = 0
        # process each chunk
        foreach( $batchRequest in $batchRequests )
        {
            $batchCounter++ 
            Write-PSFMessage -Message "Executing $($batchCounter) of $($batchRequests.Count) batches"

            $batchResponse = Invoke-BatchRequest -BatchRequest $batchRequest

            $successfulResponses = @($batchResponse.BatchResponseItems | Where-Object -Property "StatusCode" -eq 200)
            $failedResponses     = @($batchResponse.BatchResponseItems | Where-Object -Property "StatusCode" -ne 200)

            Write-PSFMessage -Message "Batch $($batchRequest.BatchId.ToString()) contained $($batchResponse.BatchResponseItems.Count) responses, $($successfulResponses.Count) successful and $($failedResponses.Count) failed"

            foreach( $failedResponse in $failedResponses )
            {
                Write-PSFMessage -Message "Batch $($batchRequest.BatchId.ToString()) contained a failed response with StatusCode $($failedResponse.StatusCode) with response error: $($failedResponse.Content)" -Level Error
            }

            $counter = 0
            foreach( $successfulResponse in $successfulResponses )
            {
                $counter++

                if( $successfulResponse.ContentType -ne "application/json" )
                {
                    Write-PSFMessage -Message "Batch $($batchRequest.BatchId.ToString()) contained a response with content-type $($failedResponse.ContentType), expected 'application/json'" -Level Error
                    continue
                }

                try 
                {
                    try 
                    {
                        $site = $successfulResponse.Content | ConvertFrom-Json -ErrorAction Stop
                    }
                    catch
                    {
                        Write-PSFMessage -Message "Failed to parse response JSON content. Failed string: '$($successfulResponse.Content)'" -Level Error
                        continue
                    }
                    
                    $hubSiteId = $relatedGroupId = $sensitivityLabelId = [Guid]::Empty
                    
                    if( $site.'odata.id' -match "sites\('(?<SiteId>.*)'\)" )
                    {
                        $siteId = [Guid]::Parse($Matches.SiteId)
                    }
                    else 
                    {
                        Write-PSFMessage -Message "Failed to parse site from $($site.'odata.id') for site $($site.Url)" -Level Error
                        continue
                    }

                    $parameters = @{}
                    $parameters.SiteId                                     = $siteId
                    $parameters.LastItemModifiedDate                       = $site.LastContentModifiedDate
                    $parameters.SiteUrl                                    = $site.Url
                    $parameters.ConditionalAccessPolicy                    = $site.ConditionalAccessPolicy
                    $parameters.DenyAddAndCustomizePagesEnabled            = $site.DenyAddAndCustomizePages
                    $parameters.DeletedDate                                = $NULL # if we found it here, it could have been restored from the recycle bin so clear the deleted date value
                    $parameters.DisplayName                                = $site.Title
                    $parameters.ExternalUserExpirationInDays               = $site.ExternalUserExpirationInDays
                    $parameters.GroupId                                    = $site.GroupId
                    $parameters.HasHolds                                   = [boolean]::Parse( $site.HasHolds )
                    $parameters.IsGroupOwnerSiteAdmin                      = [boolean]::Parse( $site.IsGroupOwnerSiteAdmin )
                    $parameters.IsHubSite                                  = [boolean]::Parse( $site.IsHubSite )
                    $parameters.IsTeamsChannelConnected                    = [boolean]::Parse( $site.IsTeamsChannelConnected ) 
                    $parameters.IsTeamsConnected                           = [boolean]::Parse( $site.IsTeamsConnected )
                    $parameters.IsProjectConnected                         = $site.PWAEnabled -eq 2
                    $parameters.LastItemModifiedDate                       = $site.LastContentModifiedDate
                    $parameters.Lcid                                       = $site.Lcid
                    $parameters.OverrideTenantExternalUserExpirationPolicy = [boolean]::Parse( $site.OverrideTenantExternalUserExpirationPolicy )
                    $parameters.RestrictedToRegion                         = $site.RestrictedToRegion
                    $parameters.SharingCapability                          = $site.SharingCapability
                    $parameters.SharingDomainRestrictionMode               = $site.SharingDomainRestrictionMode
                    $parameters.SharingLockDownCanBeCleared                = [boolean]::Parse( $site.SharingLockDownCanBeCleared )
                    $parameters.SharingLockDownEnabled                     = [boolean]::Parse( $site.SharingLockDownEnabled )
                    $parameters.SiteDefinedSharingCapability               = $site.SiteDefinedSharingCapability
                    $parameters.SiteUrl                                    = $site.Url
                    $parameters.StorageQuota                               = $site.StorageMaximumLevel
                    $parameters.StorageUsed                                = $site.StorageUsage
                    $parameters.TeamsChannelType                           = $site.TeamsChannelType
                    $parameters.Template                                   = $site.Template
                    $parameters.TimeZoneId                                 = $site.TimeZoneId
                    $parameters.WebsCount                                  = $site.WebsCount

                    if( $informationBarrierModeId = $informationBarrierModes | Where-Object -Property "InformationBarrierMode" -EQ $site.IBMode )
                    {
                        $parameters.InformationBarrierMode = $informationBarrierModeId.Id
                    }

                    if( -not [string]::IsNullOrWhiteSpace( $site.HubSiteId) -and [Guid]::TryParse( $site.HubSiteId, [ref] $hubSiteId ) )
                    {
                        $parameters.HubSiteId = $hubSiteId
                    }

                    if( -not [string]::IsNullOrWhiteSpace( $site.RelatedGroupId) -and [Guid]::TryParse( $site.RelatedGroupId, [ref] $relatedGroupId ) )
                    {
                        $parameters.RelatedGroupId = $relatedGroupId
                    }

                    if( -not [string]::IsNullOrWhiteSpace( $site.SensitivityLabel2) -and [Guid]::TryParse( $site.SensitivityLabel2, [ref] $sensitivityLabelId ) )
                    {
                        $parameters.SensitivityLabel = $sensitivityLabelId
                    }

                    if( $informationBarrierModeId = $informationBarrierModes | Where-Object -Property "InformationBarrierMode" -EQ $site.IBMode )
                    {
                        $parameters.InformationBarrierMode = $informationBarrierModeId.Id
                    }

                    if( $lockState = $lockStates | Where-Object -Property "LockState" -EQ $site.LockState )
                    {
                        $parameters.LockState = $lockState.Id
                    }

                    Register-SiteCollection @parameters

                    $successfulSiteIds.Add( $siteId )

                    if( $counter % 10 -eq 0 -or $counter -eq $successfulResponses.Count ) { Write-PSFMessage -Message "Imported detailed data for $counter site collections" }
                }
                catch
                {
                    Write-PSFMessage -Message "Failed to import detailed site collection for a site in batch $($batchResponse.BatchId)" -ErrorRecord $_ -Level Error  
                }
            }
        }

        <#
        $missingSiteIds = Compare-Object -ReferenceObject $siteCollections.SiteId -DifferenceObject $successfulSiteIds.ToArray() | Where-Object -Property "SideIndicator" -EQ "<="

        foreach( $missingSiteId in $missingSiteIds.InputObject )
        {
            if( $lockStateId = Get-SharePointTenantSiteLockStateId -SiteId $missingSiteId )
            {
                Write-PSFMessage -Message "Setting site $missingSiteId to lock state $($lockStateId)"
                
                Register-SiteCollection `
                            -SiteId    $missingSiteId `
                            -LockState $lockStateId.LockStateId
            }
        }

        #>
    }
    end
    {
        Stop-CmdletExecution -Id $cmdletExecutionId -ErrorCount $Error.Count
    }
}