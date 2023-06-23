using namespace Tenant.SiteMetadata
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

            Write-PSFMessage "Filtering sites list" -Level Verbose

            $deletedAggregatedStoreSites = [Linq.Enumerable]::ToList( $aggregatedStoreSites.Where({ $null -ne $_.DeletedDate }) ) # ~1s on a collection of 250k rows
            $activeAggregatedStoreSites  = [Linq.Enumerable]::ToList( $aggregatedStoreSites.Where({ $null -eq $_.DeletedDate }) ) # ~1s on a collection of 250k rows
            # $noAccessLockedSites         = [Linq.Enumerable]::ToList( $activeSites.Where({ $_.LockState -eq "NoAccess" })       ) # ~1s on a collection of 250k rows
            
            Write-PSFMessage "Filtered sites list" -Level Verbose

        # merge basic site tenant data

            # merge the two datasets into a single collection
            $activeSites = Merge-AggregatedStoreSiteMetadata -Left $activeSites -Right $activeAggregatedStoreSites

            $noAccessLockedSites = [Linq.Enumerable]::ToList( $activeSites.Where({ $_.LockState -eq "NoAccess" }) ) # ~1s on a collection of 250k rows

            Write-PSFMessage "'No Access' site count: $($noAccessLockedSites.Count)" -Level Verbose

            # pull out all sites that have a SiteId
            $sitesWithSiteId = [Linq.Enumerable]::ToList( $activeSites.Where( { $null -ne $_.SiteId }) )

            # merge active sites into database
            Write-PSFMessage "Merging $($sitesWithSiteId.Count) active sites" -Level Verbose
            Save-SharePointTenantActiveSite -SiteList $sitesWithSiteId

            # merge deleted sites into database
            Write-PSFMessage "Merging $($deletedAggregatedStoreSites.Count) deleted sites" -Level Verbose
            Save-SharePointTenantActiveSite -SiteList $deletedAggregatedStoreSites

        # merge detailed site tenant data

            # get a list of SiteIds for all active sites in SPO and OD4B
            $activeSitesIds = Get-SharePointTenantSharePointId

            # remove all SiteIds that are in the NoAccess list
            [List[string]]$activeUnlockedSiteIdsList = @(Remove-StringItem -ReferenceObject $activeSitesIds.SiteId -DifferenceObject $noAccessLockedSites.SiteId)

            $batchRequests = New-SharePointTenantSiteDetailBatchRequest -SiteId $activeUnlockedSiteIdsList

            Write-PSFMessage "Created $($batchRequests.Count) batche requests" -Level Verbose

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