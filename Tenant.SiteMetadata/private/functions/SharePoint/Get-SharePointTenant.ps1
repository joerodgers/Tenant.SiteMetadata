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
        Assert-SharePointConnection -Cmdlet $PSCmdlet

        $context = Get-PnPContext

        return New-Object Microsoft.Online.SharePoint.TenantAdministration.Tenant($context)
    }
}