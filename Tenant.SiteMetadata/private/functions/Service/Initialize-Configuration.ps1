function Initialize-Configuration
{
    [CmdletBinding()]
    param
    (
    )

    begin
    {
        #  keep __TenantSiteMetadataConfiguration in sync with Clear-Configuration
        $configurationVariableName = "__TenantSiteMetadataConfiguration"
    }
    process
    {
        $configuration = Get-Variable `
                                -Name  $configurationVariableName `
                                -Scope "Global" `
                                -ErrorAction SilentlyContinue

        if( $null -eq $configuration )
        {
            New-Variable `
                    -Name  $configurationVariableName `
                    -Scope "Global" `
                    -Value @{}
        }

        Get-Variable `
                -Name  $configurationVariableName `
                -Scope "Global" `
                -ValueOnly
    }
    end
    {
    }
}