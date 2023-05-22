function Register-SharePointTenantConnectionInformation
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [Tenant.SiteMetadata.ITenantConnectionInformation]
        $TenantConnectionInformation
    )

    begin
    {
    }
    process
    {
        Set-PSFConfig `
            -FullName    "Tenant.SiteMetadata.SharePointTenantConnectionInformation" `
            -Value       $TenantConnectionInformation `
            -Description "Configuration settings for connecting to the SharePoint Online Tenant"
    }
    end
    {
    }
}