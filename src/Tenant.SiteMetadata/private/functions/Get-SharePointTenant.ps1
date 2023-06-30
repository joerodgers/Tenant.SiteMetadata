function Get-SharePointTenant
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
        $context = Get-PnPContext

        return New-Object Microsoft.Online.SharePoint.TenantAdministration.Tenant($context)
    }
}