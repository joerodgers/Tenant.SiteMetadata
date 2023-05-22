function Get-DatabaseConnectionInformation
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
        # keep FullName in sync with Set-DatabaseConnectionInformation
        Get-PSFConfig -FullName "Tenant.SiteMetadata.DatabaseConnectionInformation" | Select-Object -ExpandProperty Value
    }
    end
    {
    }
}