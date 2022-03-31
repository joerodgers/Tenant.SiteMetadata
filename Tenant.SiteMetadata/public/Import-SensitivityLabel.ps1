using namespace Tenant.SiteMetadata

function Import-SensitivityLabel
{
<#
    .SYNOPSIS
    Imports tenant sensitivity label's Id (GUID) and Name into the SQL database 

    Azure Active Directory Application Principal requires Graph > Application > InformationProtectionPolicy.Read.All

    .DESCRIPTION
    Imports tenant sensitivity label's Id and Name into the SQL database 

    Azure Active Directory Application Principal requires Graph > Application > InformationProtectionPolicy.Read.All

    .PARAMETER ClientId
    Azure Active Directory Application Principal Client/Application Id

    .PARAMETER Thumbprint
    Thumbprint of certificate associated with the Azure Active Directory Application Principal

    .PARAMETER Tenant
    Name of the O365 Tenant

    .PARAMETER DatabaseConnectionInformation
    Database Connection Information

    .EXAMPLE
    PS C:\> Import-SensitivityLabel -ClientId <clientId> -Thumbprint <thumbprint> -Tenant <tenant> -DatabaseConnectionInformation <database connection information>
#>
    [CmdletBinding()]
    param
    (
    )

    begin
    {
        $cmdletExecutionId = Start-CmdletExecution -Cmdlet $PSCmdlet -ClearErrors

        Initialize-MicrosoftGraphConnection
    }    
    process
    {
        Assert-MicrosoftGraphConnection -Cmdlet $PSCmdlet

        $sensitivityLabels = Get-MicrosoftGraphSensitivityLabel
        
        foreach( $sensitivityLabel in $sensitivityLabels )
        {
            Write-PSFMessage -Message "Executing Register-SensitivityLabel -Id $($sensitivityLabel.Id) -SensitivityLabel $($sensitivityLabel.Name)"

            Register-SensitivityLabel `
                    -Id               $sensitivityLabel.Id `
                    -SensitivityLabel $sensitivityLabel.Name
        }
    }
    end
    {
        Stop-CmdletExecution -Id $cmdletExecutionId -ErrorCount $Error.Count
    }
}
