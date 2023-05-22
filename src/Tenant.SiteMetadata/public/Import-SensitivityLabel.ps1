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

    }    
    process
    {
        Assert-MicrosoftGraphConnection -Cmdlet $PSCmdlet

        Select-MgProfile -Name beta -ErrorAction Stop

        try 
        {
            Write-PSFMessage -Message "Querying Graph API for sensitivity labels" -Level Verbose

            $sensitivityLabels = Get-MgInformationProtectionPolicyLabel -All -ErrorAction Stop
        }    
        catch
        {
            Write-PSFMessage -Message "Failed to retrieve sensitivity labels from Microsoft.Graph" -EnableException $true -ErrorRecord $_ -Level Critical
            return
        }


        $json = $sensitivityLabels | Select-Object Id, Name | ConvertTo-Json

        Write-PSFMessage -Message "Merging $($sensitivityLabels.Count) sensitivity labels into database" -Level Verbose

        Invoke-StoredProcedure -StoredProcedure "site.proc_AddOrUpdateSensitivityLabel" -Parameters @{ json = $json }
    }
    end
    {
        Select-MgProfile -Name v1.0

        Stop-CmdletExecution -Id $cmdletExecutionId -ErrorCount $Error.Count
    }
}
