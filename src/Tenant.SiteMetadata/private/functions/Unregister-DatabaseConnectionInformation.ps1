function Unregister-DatabaseConnectionInformation
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
        # keep FullName in sync with Get-DatabaseConnectionInformation

        Set-PSFConfig `
            -FullName    "Tenant.SiteMetadata.DatabaseConnectionInformation" `
            -Value       $NULL `
            -Description "Configuration settings for connecting to the SQL database"
    }
    end
    {
    }
}