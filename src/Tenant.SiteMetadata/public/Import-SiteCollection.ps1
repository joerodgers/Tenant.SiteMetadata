using namespace Tenant.SiteMetadata
using namespace System.Collections.Generic
using namespace System.Linq

function Import-SiteCollection
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false)]
        [ValidateRange(1,10)]
        [int]
        $ThrottleLimit = 2,

        [Parameter(Mandatory=$false)]
        [ValidateRange(1,100)]
        [int]
        $HttpBatchSize = 50,

        [Parameter(Mandatory=$false)]
        [ValidateRange(1,5000)]
        [int]
        $SqlBatchSize = 1000
    )

    begin
    {
        $cmdletExecutionId = Start-CmdletExecution -Cmdlet $PSCmdlet -ClearErrors

        $deletedPredicate  = { param ($model) return $null -ne $model.DeletedDate    } -as [System.Func[TenantSiteModel, bool]]
        $noAccessPredicate = { param ($model) return $model.LockState -ne 'NoAccess' } -as [System.Func[TenantSiteModel, bool]]
        $noSiteIDPredicate = { param ($model) return $null -ne $model.SiteId }         -as [System.Func[TenantSiteModel, bool]]
    }
    process
    {
        try 
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

            $count = $tenantSiteModelList.Count

            # remove any remaining entries with no SiteId value
            $tenantSiteModelList = [System.Linq.Enumerable]::ToList( [System.Linq.Enumerable]::Where( $tenantSiteModelList, $noSiteIDPredicate ) )

            Write-PSFMessage "Removed $( $count - $tenantSiteModelList.Count) sites due to missing SiteId value" -Level Verbose

            # save active sites into database
            Save-TenantSiteModel -TenantSiteModelList $tenantSiteModelList -BatchSize $SqlBatchSize -ErrorAction Stop

            $deletedAggregatedStoreSiteModelList = [System.Linq.Enumerable]::ToList( [System.Linq.Enumerable]::Where( $aggregatedStoreSiteModelList, $deletedPredicate ))

            # save deleted sites into database
            Save-TenantSiteModel -TenantSiteModelList $deletedAggregatedStoreSiteModelList -BatchSize $SqlBatchSize -ErrorAction Stop

            # remove all sites set to NoAccess
            $unlockedTenantSiteModelList = [System.Linq.Enumerable]::ToList( [System.Linq.Enumerable]::Where( $tenantSiteModelList, $noAccessPredicate ))

            Write-PSFMessage "Removed $( $tenantSiteModelList.Count - $unlockedTenantSiteModelList.Count) 'NoAccess' locked sites from site detail lookup." -Level Verbose

            # pull all tenant sites marked as active
            $sqlActiveSiteIds = Get-DataTable -Query "SELECT SiteId FROM sharepoint.SitesCollectionActive UNION SELECT SiteId FROM onedrive.SitesCollectionActive" -As "PSObject" | Select-Object -ExpandProperty SiteId

            # saw a cast failure on a cx environment, explict casting to fix
            $sqlActiveSiteIds = $sqlActiveSiteIds -as [System.Collections.Generic.List[Guid]]

            # saw a cast failure on a cx environment, explict casting to fix
            $tenantActiveSiteIds = $tenantSiteModelList.SiteId -as [System.Collections.Generic.List[Guid]]

            # get all SiteIds for sites that are marked as active in SQL, but are not present in live tenant dataset
            $delta = [System.Linq.Enumerable]::ToList([System.Linq.Enumerable]::Except( $sqlActiveSiteIds, $tenantActiveSiteIds ))

            Write-PSFMessage "Discovered $($delta.Count) sites that need to be marked as deleted." -Level Verbose

            foreach( $siteId in $delta )
            {
                Write-PSFMessage "Marking orphan site $siteId as deleted." -Level Verbose
                Invoke-NonQuery -Query "UPDATE site.SiteCollection SET DeletedDate = @DeletedDate WHERE SiteId = @SiteId" -Parameters @{ SiteId = $siteId; DeletedDate = ([System.Data.SqlTypes.SqlDateTime]::MinValue) }
            }

            Write-PSFMessage "Marked all $($delta.Count) sites as deleted." -Level Verbose

            # saw a cast failure on a cx environment, explict casting to fix
            $siteIds = $unlockedTenantSiteModelList.SiteId -as [System.Collections.Generic.List[Guid]]

            # generate batch requests for each unlocked site so we can pull detailed site information
            $batchRequests = New-SharePointTenantSiteDetailBatchRequest -SiteId $siteIds -BatchSize $HttpBatchSize -ErrorAction Stop
        
            # these concurrent dictionaries are written to in the parallel runspaces referenced in Invoke-SharePointTenantSiteDetailBatchRequest
            $batchResponses = [System.Collections.Concurrent.ConcurrentDictionary[[string],[PSCustomObject]]]::new()
            $batchErrors    = [System.Collections.Concurrent.ConcurrentDictionary[[string],[string]]]::new()

            # start a backgroup job to process each batch in parallel
            $batchExecutionJob = $batchRequests | ForEach-Object -ThrottleLimit $ThrottleLimit -Parallel ${function:Invoke-SharePointTenantSiteDetailBatchRequest} -AsJob

            # save the batch results as they are completed in the runspaces
            Save-SharePointTenantSiteDetailBatchResult -BatchResponse $batchResponses -BatchExecutionJob $batchExecutionJob

            Write-PSFMessage "Completed site metadata import" -Level Verbose

            # log any batch execution errors
            foreach( $batchError in $batchErrors.GetEnumerator() )
            {
                Write-PSFMessage "Batch execution error, BatchId: $($batchError.Key), Error: $($batchError.Value)" -Level Error
            }
        }
        catch
        {
            Stop-CmdletExecution -Id $cmdletExecutionId -ErrorCount $global:Error.Count

            Write-PSFMessage -Message "Failed to import site metadata" -ErrorRecord $_ -EnableException $true -Level Critical        
        }
    }
    end
    {
        Stop-CmdletExecution -Id $cmdletExecutionId -ErrorCount $global:Error.Count

        if( $batchErrors.Count -gt 0 )
        {
            throw "Failed to execute and import $($batchErrors.Count) batches of site metadata. Failure details are recorded in the log file."
        }
    }
}