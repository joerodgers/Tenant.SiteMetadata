using namespace Tenant.SiteMetadata

function Import-SiteCollectionAdministrator
{
    [CmdletBinding(DefaultParameterSetName="SharePoint")]
    param
    (
        [Parameter(Mandatory=$false)]
        [int]
        $ThrottleLimit = 2,

        [Parameter(Mandatory=$true,ParameterSetName="OneDrive")]
        [switch]
        $OneDriveSites,

        [Parameter(Mandatory=$true,ParameterSetName="Sharepoint")]
        [switch]
        $SharePointSites
    )

    begin
    {
        $cmdletExecutionId = Start-CmdletExecution -Cmdlet $PSCmdlet -ClearErrors
    }
    process
    {
        try 
        {
            Assert-SharePointConnection -Cmdlet $PSCmdlet

            # read the sites from SQL instead of the tenant so we can filter as much as possible

            if( $PSCmdlet.ParameterSetName -eq "Sharepoint")
            {
                [System.Collections.Generic.List[Guid]]$siteIds = Get-DataTable `
                                                                        -Query "SELECT SiteId, LockState FROM sharepoint.SiteCollectionActive WHERE LockState = 1 AND TEMPLATE NOT IN ( 'REDIRECTSITE#0' )" `
                                                                        -As "PsObject" | Select-Object -ExpandProperty SiteId
            }
            else
            {
                [System.Collections.Generic.List[Guid]]$siteIds = Get-DataTable `
                                                                        -Query "SELECT SiteId, LockState FROM onedrive.SiteCollectionActive WHERE LockState = 1" `
                                                                        -As "PsObject" | Select-Object -ExpandProperty SiteId
            }

            if( $siteIds.Count -eq 0 )
            {
                Write-PSFMessage "No unlocked $($PSCmdlet.ParameterSetName) sites found in the database." -Level Warning
                return
            }
            
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
            
            Write-PSFMessage -Message "Site Administrator import completed" -ErrorRecord $_ -EnableException $true -Level Critical

            # log any batch execution errors
            foreach( $siteAdministratorsBatchError in $siteAdministratorsBatchErrors.GetEnumerator() )
            {
                Write-PSFMessage "Batch execution error, BatchId: $($siteAdministratorsBatchError.Key), Error: $($siteAdministratorsBatchError.Value)" -Level Critical
            }
        }
        catch
        {
            Stop-CmdletExecution -Id $cmdletExecutionId -ErrorCount $global:Error.Count

            Write-PSFMessage -Message "Failed to import site collection administrators" -ErrorRecord $_ -EnableException $true -Level Critical
        }
    }
    end
    {
        Stop-CmdletExecution -Id $cmdletExecutionId -ErrorCount $global:Error.Count

        if( $siteAdministratorsBatchErrors.Count -gt 0 )
        {
            throw "Failed to execute and import $($siteAdministratorsBatchErrors.Count) batches of site collection admins. Failure details are recorded in the log file."
        }
    }
}

