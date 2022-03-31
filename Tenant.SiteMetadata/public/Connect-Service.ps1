function Connect-Service
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [Tenant.SiteMetadata.IDatabaseConnectionInformation]
        $DatabaseConnectionInformation,

        [Parameter(Mandatory=$true)]
        [Tenant.SiteMetadata.ITenantConnectionInformation]
        $TenantConnectionInformation
    )

    begin
    {
    }
    process
    {
        Set-ConfigurationSetting `
            -ConfigurationSettingName "TenantConnectionInformation" `
            -ConfigurationSettingValue $TenantConnectionInformation
        
        Set-ConfigurationSetting `
            -ConfigurationSettingName "DatabaseConnectionInformation" `
            -ConfigurationSettingValue $DatabaseConnectionInformation

        Assert-ServiceConnection -Cmdlet $PSCmdlet
    }
    end
    {
    }
}