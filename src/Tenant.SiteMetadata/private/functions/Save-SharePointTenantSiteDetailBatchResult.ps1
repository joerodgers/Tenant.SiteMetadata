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
        Write-PSFMessage -Message "Total Batch Jobs: $($BatchExecutionJob.ChildJobs.Count)" -Level Verbose

        while( $BatchExecutionJob.State -eq 'Running' -or -not $BatchResponse.IsEmpty )
        {
            $status = $BatchExecutionJob.ChildJobs | Group-Object -Property State | ForEach-Object { "{0}={1}" -f $_.Name, $_.Count } 

            Write-PSFMessage -Message "Batch Job Progress: $($status -join ' | ')" -Level Verbose

            if( $BatchResponse.IsEmpty )
            {
                Start-Sleep -Seconds 1
                continue
            }

            while( -not $BatchResponse.IsEmpty )
            {
                $rawResponse = $null

                $batchId = $BatchResponse.Keys | Select-Object -First 1

                if( -not $BatchResponse.TryRemove( $batchId, [ref] $rawResponse ) )
                {
                    Write-PSFMessage -Message "Failed to remove $batchId from batch responses" -Level Error
                    continue
                }

                try
                {
                    # convert the raw batch response text into a DetailedTenantSiteModel List
                    $detailedTenantSiteModelList = ConvertTo-DetailedTenantSiteModelList -BatchResponse $rawResponse

                    Save-TenantSiteModel -TenantSiteModelList $detailedTenantSiteModelList -BatchSize ($detailedTenantSiteModelList.Count) -ErrorVariable "sqlexceptions" -ErrorAction Stop
                }
                catch
                {
                    Write-PSFMessage -Message "Error saving site metadata." -ErrorRecord $_ -Level Error
                }
            }

            Start-Sleep -Seconds 1
        }
    }
}