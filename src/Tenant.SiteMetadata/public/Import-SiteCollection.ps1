﻿using namespace Tenant.SiteMetadata
using namespace System.Collections.Generic
using namespace System.Linq

function Import-SiteCollection
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false)]
        [int]
        $ThrottleLimit = 2
    )

    begin
    {
        $cmdletExecutionId = Start-CmdletExecution -Cmdlet $PSCmdlet -ClearErrors
    }
    process
    {
        Assert-SharePointConnection -Cmdlet $PSCmdlet

        # pull tenant data once

            $activeSites          = Get-SharePointTenantActiveSite
            $aggregatedStoreSites = Get-SharePointTenantAggregatedStoreSite -IncludeDeletedSites -AggregatedStore "AggregatedStore"

            $deletedAggregatedStoreSites = [Linq.Enumerable]::ToList( $aggregatedStoreSites.Where({ $_.DeletedDate })      )
            $activeAggregatedStoreSites  = [Linq.Enumerable]::ToList( $aggregatedStoreSites.Where({ -not $_.DeletedDate }) )
            $noAccessLockedSites         = [Linq.Enumerable]::ToList( $activeSites.Where({ $_.LockState -eq "NoAccess" })  )
            
        # merge basic site tenant data

            # merge the two datasets
            Merge-AggregatedStoreSiteMetadata -TenantSitesList $activeSites -AggregatedStoreSitesList $activeAggregatedStoreSites
            
            # pull out all sites that have a SiteId
            $sitesWithSiteId = [Linq.Enumerable]::ToList( $activeSites.Where( { $_.SiteId }) )

            # merge active sites into database
            Write-PSFMessage "Merging active sites" -Level Verbose
            Save-SharePointTenantActiveSite -SiteList $sitesWithSiteId

            # merge deleted sites into database
            Write-PSFMessage "Merging deleted sites" -Level Verbose
            Save-SharePointTenantActiveSite -SiteList $deletedAggregatedStoreSites

        # merge detailed site tenant data

            # get a list of SiteIds for all active sites in SPO and OD4B
            $activeSitesIds = Get-SharePointTenantSharePointId

            # remove all SiteIds that are in the NoAccess list
            [List[string]]$activeUnlockedSiteIdsList = @(Remove-StringItem -ReferenceObject $activeSitesIds.SiteId -DifferenceObject $noAccessLockedSites.SiteId)

            $batchRequests = New-SharePointTenantSiteDetailBatchRequest -SiteId $activeUnlockedSiteIdsList

            # these dictionaries are referenced in the parallel runspaces referenced in scriptblock Invoke-SharePointTenantSiteDetailBatchRequest
            $batchResponses = [System.Collections.Concurrent.ConcurrentDictionary[[string],[PSCustomObject]]]::new()
            $batchErrors    = [System.Collections.Concurrent.ConcurrentDictionary[[string],[string]]]::new()

            # start a backgroup job to process each batch in parallel
            $batchExecutionJob = $batchRequests | ForEach-Object -ThrottleLimit $ThrottleLimit -Parallel ${function:Invoke-SharePointTenantSiteDetailBatchRequest} -AsJob

            # save the batch results as they are returned
            Save-SharePointTenantSiteDetailBatchResult -BatchResponse $batchResponses -BatchExecutionJob $batchExecutionJob

            # log any batch execution errors
             foreach( $batchError in $batchErrors.GetEnumerator() )
            {
                Write-PSFMessage "Batch execution error, BatchId: $($batchError.Key), Error: $($batchError.Value)" -Level Error
            }
        }
    end
    {
        Stop-CmdletExecution -Id $cmdletExecutionId -ErrorCount $Error.Count
    }
}