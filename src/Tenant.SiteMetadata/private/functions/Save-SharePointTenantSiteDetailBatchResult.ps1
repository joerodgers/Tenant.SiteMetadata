function Save-SharePointTenantSiteDetailBatchResult
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [System.Collections.Concurrent.ConcurrentDictionary[string,psobject]]
        $BatchResponse,

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSTasks.PSTaskJob]
        $BatchExecutionJob
    )
    
    begin
    {
        $total = 0
    }
    process
    {
        while( $BatchExecutionJob.State -eq 'Running' -or -not $BatchResponse.IsEmpty )
        {
            if( $BatchResponse.IsEmpty )
            {
                Write-PSFMessage -Message "Waiting for batch results" -Level Verbose
                Start-Sleep -Seconds 1
                continue
            }

            while( -not $BatchResponse.IsEmpty )
            {
                $rawresponse = $null

                $batchId = $BatchResponse.Keys | Select-Object -First 1

                Write-PSFMessage -Message "Removing batch '$batchId'" -Level Verbose

                if( -not $BatchResponse.TryRemove( $batchId, [ref] $rawresponse ) )
                {
                    Write-PSFMessage -Message "Failed to remove $batchId from batch responses" -Level Error
                    continue
                }

                # convert the raw batch response text into a PSObject List
                $sitesList = Convert-SharePointTenantBatchResponse -BatchResponse $rawresponse

                # merge the site data in the batch response
                Save-SharePointTenantActiveSite -SiteList $sitesList
            }

            Start-Sleep -Seconds 1
        }
    }
}