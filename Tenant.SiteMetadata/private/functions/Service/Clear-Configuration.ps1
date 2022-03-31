function Clear-Configuration
{
    [CmdletBinding()]
    param
    (
    )

    begin
    {
        #  keep __TenantSiteMetadataConfiguration in sync with Initialize-Configuration
        $configurationVariableName = "__TenantSiteMetadataConfiguration"
    }
    process
    {
        Remove-Variable `
            -Name  $configurationVariableName `
            -Scope "Global" `
            -Force `
            -ErrorAction SilentlyContinue
    }
    end
    {
    }
}