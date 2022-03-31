function Get-DatabaseConnectionInformation
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
        Get-ConfigurationSetting -ConfigurationSettingName "DatabaseConnectionInformation"
    }
    end
    {
    }
}