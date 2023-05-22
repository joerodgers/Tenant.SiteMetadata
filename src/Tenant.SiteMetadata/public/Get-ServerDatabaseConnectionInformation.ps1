using namespace Tenant.SiteMetadata

function Get-ServerDatabaseConnectionInformation
{
    [CmdletBinding()]
    param
    (
    )

    Get-DatabaseConnectionInformation
}