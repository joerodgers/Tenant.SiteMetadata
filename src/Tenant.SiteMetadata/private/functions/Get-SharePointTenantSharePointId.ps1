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
        $url = '/_api/v2.0/sites?$select=SharepointIds&$top={0}' -f $PageSize

        # these template types are not returned by the _api/v2.0/sites
        # $templates = "POINTPUBLISHINGHUB#0", "POINTPUBLISHINGPERSONAL#0", "POINTPUBLISHINGTOPIC#0", "RedirectSite#0", "SPSMSITEHOST#0", "TEAMCHANNEL#0", "TEAMCHANNEL#1"
        $templates = "RedirectSite#0", "SPSMSITEHOST#0", "TEAMCHANNEL#0", "TEAMCHANNEL#1"
    }
    process
    {
        while( $url ) 
        {
            Write-PSFMessage -Message "Executing site batch: $url" -Level Verbose

            $response = Invoke-PnPSPRestMethod -Url $url -Raw |  ConvertFrom-Json
    
            $siteIds = $response.value.sharepointIds | Select-Object SiteId
    
            $url = $response.'@odata.nextLink'

            Write-PSFMessage -Message "Site batch returned: $($siteIds.Count) sites" -Level Verbose
            
            $siteIds
        }

        foreach( $template in $templates )
        {
            Get-SharePointTenantSiteSiteIdByTemplate -Template $template
        }
    }
    end
    {
    }
}
