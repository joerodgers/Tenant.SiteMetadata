function Unregister-SharePointTenantConnectionInformation
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
        Set-PSFConfig `
            -FullName    "Tenant.SiteMetadata.SharePointTenantConnectionInformation" `
            -Value       $NULL `
            -Description "Configuration settings for connecting to the SharePoint Online Tenant"
    }
    end
    {
    }
}