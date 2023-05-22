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

    Write-HttpsProxyServerConfigurationWarning

    Register-DatabaseConnectionInformation -DatabaseConnectionInformation $DatabaseConnectionInformation

    Register-SharePointTenantConnectionInformation -TenantConnectionInformation $TenantConnectionInformation

    Connect-SharePointTenant

    Connect-MicrosoftGraph
}