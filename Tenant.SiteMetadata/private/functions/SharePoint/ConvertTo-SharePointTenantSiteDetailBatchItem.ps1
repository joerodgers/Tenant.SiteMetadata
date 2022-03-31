function ConvertTo-SharePointTenantSiteDetailBatchItem
{
    [cmdletbinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [SiteCollection[]]
        $SiteCollection
    )

    begin
    {
        $batchRequestItems = New-Object System.Collections.Generic.List[BatchRequestItem]
    }
    process
    {
        foreach( $sc in $SiteCollection )
        {
            $br = New-Object BatchRequestItem @{
                    Url      = "/_api/Microsoft.Online.SharePoint.TenantAdministration.Tenant/sites('{0}')" -f $sc.SiteId.ToString()
                    Method   = "GET"
                    $Content = $null
                    $Headers = @{}
                }
            
            $batchRequestItems.Add($br)
        }
    }
    end
    {
    }    
}