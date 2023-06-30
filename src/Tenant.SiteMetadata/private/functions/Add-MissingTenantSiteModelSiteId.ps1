function Add-MissingTenantSiteModelSiteId
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [System.Collections.Generic.List[TenantSiteModel]]
        $TenantSiteModelList
    )
    
    begin
    {
        Write-PSFMessage "Starting" -Level Verbose
    }
    process
    {
        foreach( $tenantSiteModel in $TenantSiteModelList )
        {
            if( $null -eq $tenantSiteModel.SiteId )
            {
                Write-PSFMessage "Looking up siteid for $($tenantSiteModel.SiteUrl), Template: $($tenantSiteModel.Template)" -Level Verbose

                if( $siteId = Get-SharePointTenantSiteIdByUrl -SiteUrl $tenantSiteModel.SiteUrl -ErrorAction Stop )
                {
                    $tenantSiteModel.SiteId = $siteId
                }
            }
        }

        return ,$TenantSiteModelList
    }
    end
    {
        Write-PSFMessage "Completed" -Level Verbose
    }
}