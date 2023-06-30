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
        $deletedPredicate  = { param ($model) return $null -ne $model.DeletedDate    } -as [System.Func[TenantSiteModel, bool]]
        $noAccessPredicate = { param ($model) return $model.LockState -ne 'NoAccess' } -as [System.Func[TenantSiteModel, bool]]
    }
    process
    {
        Assert-SharePointConnection -Cmdlet $PSCmdlet

        # pull tenant data (the slow part)

        $tenantSiteModelList          = Get-SharePointTenantSiteModelList -ErrorAction Stop
        $restApiTenantSiteModelList   = Get-SharePointTenantSiteModelList -UseRestApi -ErrorAction Stop
        $aggregatedStoreSiteModelList = Get-SharePointAggregatedStoreTenantSiteModelList -ErrorAction Stop

        # merge the two model collections into a single collection
        $tenantSiteModelList = Join-TenantSiteModelList -OuterList $tenantSiteModelList -InnerList $restApiTenantSiteModelList -ErrorAction Stop

        # merge the two model collections into a single collection
        $tenantSiteModelList = Join-TenantSiteModelList -OuterList $tenantSiteModelList -InnerList $aggregatedStoreSiteModelList -ErrorAction Stop

        # backfill as many SiteIds as possible, the bulk of these should be RedirectSite#0 templates
        $tenantSiteModelList = Add-MissingTenantSiteModelSiteId -TenantSiteModelList $tenantSiteModelList -ErrorAction Stop

        # save active sites into database
        Save-TenantSiteModel -TenantSiteModelList $tenantSiteModelList -ErrorAction Stop

        $deletedAggregatedStoreSiteModelList = [System.Linq.Enumerable]::ToList( [System.Linq.Enumerable]::Where( $aggregatedStoreSiteModelList, $deletedPredicate ))

        # save deleted sites into database
        Save-TenantSiteModel -TenantSiteModelList $deletedAggregatedStoreSiteModelList -ErrorAction Stop

        # remove all sites set to NoAccess
        $unlockedTenantSiteModelList = [System.Linq.Enumerable]::ToList( [System.Linq.Enumerable]::Where( $tenantSiteModelList, $noAccessPredicate ))

        Write-PSFMessage "Removed $( $tenantSiteModelList.Count - $unlockedTenantSiteModelList.Count) 'NoAccess' locked sites from site detail lookup." -Level Verbose

        $siteIds = $unlockedTenantSiteModelList.SiteId -as [System.Collections.Generic.List[Guid]]

        # generate batch requests for each unlocked site so we can pull detailed site information
        $batchRequests = New-SharePointTenantSiteDetailBatchRequest -SiteId $siteIds -BatchSize 100
     
        # these concurrent dictionaries are written to in the parallel runspaces referenced in Invoke-SharePointTenantSiteDetailBatchRequest
        $batchResponses = [System.Collections.Concurrent.ConcurrentDictionary[[string],[PSCustomObject]]]::new()
        $batchErrors    = [System.Collections.Concurrent.ConcurrentDictionary[[string],[string]]]::new()

        # start a backgroup job to process each batch in parallel
        $batchExecutionJob = $batchRequests | ForEach-Object -ThrottleLimit $ThrottleLimit -Parallel ${function:Invoke-SharePointTenantSiteDetailBatchRequest} -AsJob

        # save the batch results as they are completed in the runspaces
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