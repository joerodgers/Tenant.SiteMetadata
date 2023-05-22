function Get-SharePointTenantConnectionInformation
{
    [CmdletBinding()]
    param
    (
    )

    begin
    {
    }
    process
    {
        Get-PSFConfig -FullName "Tenant.SiteMetadata.SharePointTenantConnectionInformation" | Select-Object -ExpandProperty Value
    }
    end
    {
    }
}