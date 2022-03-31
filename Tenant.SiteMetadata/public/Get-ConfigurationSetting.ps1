function Get-ConfigurationSetting
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $ConfigurationSettingName,

        [Parameter(Mandatory=$false)]
        [object]
        $Defaultvalue = $null
    )

    begin
    {
    }
    process
    {
        $configuration = Initialize-Configuration

        if( $configuration.ContainsKey($ConfigurationSettingName) )
        {
            return $configuration[$ConfigurationSettingName]
        }

        return $DefaultValue
    }
    end
    {
    }
}
