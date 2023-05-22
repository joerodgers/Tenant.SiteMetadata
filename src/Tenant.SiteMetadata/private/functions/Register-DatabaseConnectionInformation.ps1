function Register-DatabaseConnectionInformation
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [Tenant.SiteMetadata.IDatabaseConnectionInformation]
        $DatabaseConnectionInformation
    )

    begin
    {
    }
    process
    {
        # keep FullName in sync with Get-DatabaseConnectionInformation

        Set-PSFConfig `
            -FullName    "Tenant.SiteMetadata.DatabaseConnectionInformation" `
            -Value       $DatabaseConnectionInformation `
            -Description "Configuration settings for connecting to the SQL database"
    }
    end
    {
    }
}