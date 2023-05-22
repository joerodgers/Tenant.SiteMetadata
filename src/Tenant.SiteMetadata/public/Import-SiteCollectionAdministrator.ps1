using namespace Tenant.SiteMetadata

function Import-SiteCollectionAdministrator
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

        # read the sites from SQL instead of the tenant so we can filter as much as possible

            $sites = Get-DatabaseSiteCollection `
                -SiteCollectionType      ([Tenant.SiteMetadata.Enums.SiteCollectionType]::All.value__) `
                -SiteCollectionStatus    ([Tenant.SiteMetadata.Enums.SiteCollectionStatus]::Active.value__) `
                -SiteCollectionLockState ([Tenant.SiteMetadata.Enums.SiteCollectionLockState]::Unlock.value__)

            [System.Collections.Generic.List[Guid]]$siteIds = $sites | Select-Object -ExpandProperty SiteId
            
            # lookup the admins for each site
            $batchRequests = New-SharePointTenantSiteAdministratorBatchRequest -List $siteIds

            # these dictionaries are referenced in the parallel runspaces referenced in scriptblock Invoke-SharePointTenantSiteDetailBatchRequest
            $siteAdministratorsBatchResponses = [System.Collections.Concurrent.ConcurrentDictionary[[string],[PSCustomObject]]]::new()
            $siteAdministratorsBatchErrors    = [System.Collections.Concurrent.ConcurrentDictionary[[string],[string]]]::new()

            Write-PSFMessage "Starting $($batchRequests.Count) batch executions with a throttle limit of $ThrottleLimit"

            # start a backgroup job to process each batch in parallel
            $batchExecutionJob = $batchRequests | ForEach-Object -ThrottleLimit $ThrottleLimit -Parallel ${function:Invoke-SharePointTenantSiteAdministratorRequest} -AsJob

            # save the batch results as they are returned
            Save-SharePointTenantSiteAdministratorBatchResult -BatchRequest $batchRequests -BatchResponse $siteAdministratorsBatchResponses -BatchExecutionJob $batchExecutionJob
            
            # log any batch execution errors
            foreach( $siteAdministratorsBatchError in $siteAdministratorsBatchErrors.GetEnumerator() )
            {
                Write-PSFMessage "Batch execution error, BatchId: $($siteAdministratorsBatchError.Key), Error: $($siteAdministratorsBatchError.Value)" -Level Error
            }

        }
    end
    {
        Stop-CmdletExecution -Id $cmdletExecutionId -ErrorCount $Error.Count
    }
}

