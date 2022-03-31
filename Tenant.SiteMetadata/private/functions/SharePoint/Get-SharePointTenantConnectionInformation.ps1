function Get-SharePointTenantConnectionInformation
{
    [CmdletBinding()]
    param
    (
    )

    begin
    {
        Assert-ServiceConnection -Cmdlet $PSCmdlet
    }
    process
    {
        Get-ConfigurationSetting -ConfigurationSettingName "TenantConnectionInformation"
    }
    end
    {
    }
}