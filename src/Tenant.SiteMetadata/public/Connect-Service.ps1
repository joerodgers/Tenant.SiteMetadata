using namespace Tenant.SiteMetadata

function Connect-Service
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [Tenant.SiteMetadata.IDatabaseConnectionInformation]
        $DatabaseConnectionInformation,

        [Parameter(Mandatory=$true)]
        [Tenant.SiteMetadata.ITenantConnectionInformation]
        $TenantConnectionInformation
    )

    $module = Get-Module -Name "PnP.Powershell" -ErrorAction Stop
    
    Write-PSFMessage -Message "Loaded PnP.Powershell module version: $($module.Version)" -Level Verbose

    $module = Get-Module -Name "Tenant.SiteMetadata" -ErrorAction Stop
    
    Write-PSFMessage -Message "Loaded Tenant.SiteMetadata module version: $($module.Version)" -Level Verbose

    Write-HttpsProxyServerConfigurationWarning

    Register-DatabaseConnectionInformation -DatabaseConnectionInformation $DatabaseConnectionInformation

    Register-SharePointTenantConnectionInformation -TenantConnectionInformation $TenantConnectionInformation

    Connect-SharePointTenant

    Connect-MicrosoftGraph
}