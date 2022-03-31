function Get-MicrosoftGraphSensitivityLabel
{
    [CmdletBinding()]
    param
    (
    )

    begin
    {
        Assert-MicrosoftGraphConnection -Cmdlet $PSCmdlet

        Import-MicrosoftGraphBetaCommand -Command "Get-MgInformationProtectionPolicyLabel"

        Assert-MicrosoftGraphBetaCommandLoaded -Command "Get-MgInformationProtectionPolicyLabel" -Cmdlet $PSCmdlet
    }
    process
    {
        try 
        {
            Get-MgInformationProtectionPolicyLabel -All -ErrorAction Stop
        }    
        catch
        {
            Write-PSFMessage -Message "Failed to retrieve sensitivity labels from Microsoft.Graph" -EnableException $true -ErrorRecord $_ -Level Critical
        }
    }
    end
    {
        Select-MgProfile -Name "v1.0"
    }
}