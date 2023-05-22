function New-SharePointTenantSiteDetailBatchRequest
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [System.Collections.Generic.List[string]]
        $SiteId
    )
    
    begin
    {
        $connectionInformation = Get-SharePointTenantConnectionInformation
        $tenantAdminUrl        = Get-SharePointTenantAdminUrl
        $batches               = New-Object System.Collections.Generic.List[PSCustomObject]
    }
    process
    {
        while( $startIndex -lt $SiteId.Count )
        {
            $batchId = (New-Guid).ToString()

            # determine how many items to pull
            $chunkSize = [Math]::Min( 100 <# max allowed by SPO #>, $SiteId.Count - $startIndex )

            # pull chunk out of collection
            $ids = $SiteId.GetRange( $startIndex, $chunkSize ).ToArray()
    
            # build a list of urls to pull site details
            $urls = foreach ( $id in $ids ) { "/_api/Microsoft.Online.SharePoint.TenantAdministration.Tenant/sites('{0}')" -f $id }
    
            # create a formatted HTTP batch body
            $batchBody = New-SharePointTenantSiteDetailBatchRequestBody -Url $urls -BatchId $BatchId

            $batch = [PSCustomObject] @{
                         BatchId          = $batchId
                         BatchBody        = $batchBody
                         SitesIds         = $ids
                         TenantAdminUrl   = $tenantAdminUrl        # used to connect in runspace
                         TenantConnection = $connectionInformation # used to connect in runspace
                     }

            # add to the collection of batches to execute
            $batches.Add($batch)

            $startIndex += $chunkSize
        }

        return ,$batches
    }
    end
    {
    }        
}