function Invoke-SharePointTenantSiteDetailBatch
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [System.Collections.Generic.List[string]]
        $SiteId,

        [Parameter(Mandatory=$false)]
        [int]
        $ThrottleLimit = 2
    )
    
    begin
    {
        $connectionInformation = Get-SharePointTenantConnectionInformation
        $tenantAdminUrl        = Get-SharePointTenantAdminUrl
        $batches               = New-Object System.Collections.Generic.List[PSCustomObject]
    }
    process
    {
        $batchCount = [Math]::Ceiling( $SiteId.Count / 100 )

        while( $startIndex -lt $SiteId.Count )
        {
            $counter++

            # determine how many items to pull
            $chunkSize = [Math]::Min( 100 <# max allowed by SPO #>, $SiteId.Count - $startIndex )

            # pull chunk out of collection
            $batchSiteIds = $SiteId.GetRange( $startIndex, $chunkSize ).ToArray()
    
            $startIndex += $chunkSize

            # build a list of batch urls to pull nearly all site details
            $batchUrls = foreach ( $batchSiteId in $batchSiteIds ) { "/_api/Microsoft.Online.SharePoint.TenantAdministration.Tenant/sites('{0}')" -f $batchSiteId }
    
            # create a formatted HTTP batch body
            $batch = New-SharePointTenantSiteDetailBatchRequest -Url $batchUrls

            # add connection info to allow the runspace to connect to the tenant
            $batch | Add-Member -MemberType "NoteProperty" -Name "TenantAdminUrl"    -Value $tenantAdminUrl
            $batch | Add-Member -MemberType "NoteProperty" -Name "TenantConnecttion" -Value $connectionInformation

            # add to the collection of batches to execute
            $batches.Add($batch)
        }

        try 
        {
            $batches = $SiteId | Foreach-Object -ThrottleLimit $ThrottleLimit -Parallel $script -AsJob
        }
        catch
        {
        }
    }
    end
    {
    }    
}