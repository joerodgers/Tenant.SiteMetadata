function Get-SharePointTenantAdminUrl
{
    [CmdletBinding()]
    param
    (
    )

    $connectionInformation = Get-SharePointTenantConnectionInformation 

    $tenant = $connectionInformation.TenantName -Replace ".onmicrosoft.com", ""

    return "https://$($tenant)-admin.sharepoint.com"
}