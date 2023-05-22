function Register-ConfidentialClientApplication
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [Microsoft.Identity.Client.ConfidentialClientApplication]
        $ConfidentialClientApplication
    )

    begin
    {
    }
    process
    {
        # keep FullName in sync with Get-ConfidentialClientApplication

        Set-PSFConfig `
            -FullName    "Tenant.SiteMetadata.ConfidentialClientApplication" `
            -Value       $ConfidentialClientApplication `
            -Description "ConfidentialClientApplication used to manage Azure SQL token cache"
    }
    end
    {
    }
}