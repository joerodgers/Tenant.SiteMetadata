function Get-ConfidentialClientApplication
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
        # keep FullName in sync with Register-ConfidentialClientApplication
        Get-PSFConfig -FullName "Tenant.SiteMetadata.ConfidentialClientApplication" | Select-Object -ExpandProperty Value
    }
    end
    {
    }
}