function New-SharePointTenantSiteDetailBatchRequest
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [System.Collections.Generic.List[Guid]]
        $SiteId,

        [Parameter(Mandatory=$false)]
        [ValidateRange(1,100)]
        [int]
        $BatchSize = 100
    )
    
    begin
    {
        Write-PSFMessage "Starting" -Level Verbose

        $connectionInformation = Get-SharePointTenantConnectionInformation
        $tenantAdminUrl        = Get-SharePointTenantAdminUrl

        #$models = New-Object System.Collections.Generic.List[SiteDetailBatchRequestModel]
        $models = New-Object System.Collections.Generic.List[PSCustomObject]
    }
    process
    {
        Write-PSFMessage "Creating batch requests for $($SiteId.Count) sites." -Level Verbose

        # break the collection into chunks of 100 sites (max supported)
        $batches =  [System.Linq.Enumerable]::ToList( [System.Linq.Enumerable]::Chunk( $SiteId, $BatchSize ) )

        # process each batch
        foreach( $batch in $batches )
        {
            try
            {
                # build a list of urls to pull site details
                $restEndpoints = foreach ( $guid in $batch ) { "/_api/Microsoft.Online.SharePoint.TenantAdministration.Tenant/sites('{0}')" -f $guid }

                $batchId = New-Guid

                # create a formatted HTTP batch body
                $batchBody = New-SharePointTenantSiteDetailBatchRequestBody -Url $restEndpoints -BatchId $batchId

                <#
                $model = [SiteDetailBatchRequestModel]::new()
                $model.BatchId          = $batchId
                $model.BatchBody        = $batchBody
                $model.SiteIdList       = $batch
                $model.TenantAdminUrl   = $tenantAdminUrl        # used to connect in runspace
                $model.TenantConnection = $connectionInformation # used to connect in runspace

                $models.Add($model)
                #>

                $model = [PSCustomObject] @{
                    BatchId          = $batchId
                    BatchBody        = $batchBody
                    TenantAdminUrl   = $tenantAdminUrl        # used to connect in runspace
                    TenantConnection = $connectionInformation # used to connect in runspace
                }

                $models.Add($model)
            }
            catch
            {
                Write-PSFMessage `
                        -Message     "Failed to contruct batch requests" `
                        -Level       "Critical" `
                        -ErrorRecord $_
            }
        }
    }
    end
    {
        Write-PSFMessage "Completed" -Level Verbose

        return ,$models
    }        
}