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
            if( $null -eq $tenantSiteModel.SiteId -and $tenantSiteModel.LockState -ne "NoAccess" )
            {
                Write-PSFMessage "Looking up siteid for $($tenantSiteModel.SiteUrl), Template: $($tenantSiteModel.Template)" -Level Verbose

                try
                {
                    if( $siteId = Get-SharePointTenantSiteIdByUrl -SiteUrl $tenantSiteModel.SiteUrl -ErrorAction Stop )
                    {
                        $tenantSiteModel.SiteId = $siteId
                    }
                }
                catch
                {
                    Write-PSFMessage "Failed to lookup SiteId for $($tenantSiteModel.SiteUrl)" -Level Error -ErrorRecord $_
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