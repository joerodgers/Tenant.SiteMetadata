function Get-SharePointTenantSharePointId
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false)]
        [ValidateRange(1,5000)]
        [int]
        $PageSize = 5000
    )

    begin
    {
        $url = '/_api/v2.1/sites/getallsites?$top={0}&select=Id' -f $PageSize

        # these template types are not returned by the _api/v2.1/sites/getallsites
        # $templates = "POINTPUBLISHINGHUB#0", "POINTPUBLISHINGPERSONAL#0", "POINTPUBLISHINGTOPIC#0", "RedirectSite#0", "SPSMSITEHOST#0"
        $templates = "RedirectSite#0", "SPSMSITEHOST#0"
    }
    process
    {
        while( $url ) 
        {
            Write-PSFMessage -Message "Executing site batch: $url" -Level Verbose

            $response = Invoke-PnPSPRestMethod -Url $url -ErrorAction Stop
            
            $response.value | Select-Object @{ Name="SiteId"; Expression={ $_.Id.Split(",")[1] }}

            $url = $response.'@odata.nextLink'

            Write-PSFMessage -Message "Site batch returned: $($siteIds.Count) sites" -Level Verbose
        }

        foreach( $template in $templates )
        {
            Get-SharePointTenantSiteSiteIdByTemplate -Template $template -ErrorAction Stop
        }
    }
    end
    {
    }
}
