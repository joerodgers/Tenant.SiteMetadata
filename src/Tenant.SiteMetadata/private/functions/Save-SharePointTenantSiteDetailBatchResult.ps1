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
    }
    process
    {
        while( $BatchExecutionJob.State -eq 'Running' -or -not $BatchResponse.IsEmpty )
        {
            Write-PSFMessage -Message "Batch Job Information: JobId=$($BatchExecutionJob.Id), State=$($BatchExecutionJob.State)" -Level Verbose

            if( $BatchResponse.IsEmpty )
            {
                Write-PSFMessage -Message "Waiting for more batches to complete" -Level Verbose
                Start-Sleep -Seconds 1
                continue
            }

            while( -not $BatchResponse.IsEmpty )
            {
                $rawResponse = $null

                $batchId = $BatchResponse.Keys | Select-Object -First 1

                Write-PSFMessage -Message "Removing batch '$batchId'" -Level Verbose

                if( -not $BatchResponse.TryRemove( $batchId, [ref] $rawResponse ) )
                {
                    Write-PSFMessage -Message "Failed to remove $batchId from batch responses" -Level Error
                    continue
                }

                # convert the raw batch response text into a DetailedTenantSiteModel List
                $detailedTenantSiteModelList = ConvertTo-DetailedTenantSiteModelList -BatchResponse $rawResponse

                # save to database
                Save-TenantSiteModel -TenantSiteModelList $detailedTenantSiteModelList -BatchSize ($detailedTenantSiteModelList.Count) -ErrorAction Stop
            }

            Start-Sleep -Seconds 1
        }
    }
}