function Set-ConfigurationSetting
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $ConfigurationSettingName,

        [Parameter(Mandatory=$true)]
        [object]
        $ConfigurationSettingValue
    )

    begin
    {
    }
    process
    {
        $configuration = Initialize-Configuration

        $configuration[$ConfigurationSettingName] = $ConfigurationSettingValue
    }
    end
    {
    }
}
