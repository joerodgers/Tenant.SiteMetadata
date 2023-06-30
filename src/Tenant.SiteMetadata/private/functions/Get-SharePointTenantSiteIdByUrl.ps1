function Get-SharePointTenantSiteIdByUrl
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [System.Uri]
        $SiteUrl
    )

    begin
    {
        # Write-PSFMessage "Starting" -Level Verbose
    }
    process
    {
        $tenant = Get-SharePointTenant

        return [Microsoft.SharePoint.Client.TenantExtensions]::GetSiteGuidByUrl( $tenant, $SiteUrl.ToString().Trim().TrimEnd("/") ) # | Select-Object @{ Name="SiteId"; Expression={$_}}
    }
    end
    {
        # Write-PSFMessage "Completed" -Level Verbose
    }
}