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

        try 
        {
            Write-PSFMessage -Message "Querying Graph API for sensitivity labels" -Level Verbose

            $response = Invoke-MgGraphRequest -Method GET -Uri "beta/informationProtection/policy/labels" -ErrorAction Stop  

            $sensitivityLabels = foreach( $label in $response.value )
            {
                [PSCustomObject] @{
                    Id   = $label.Id
                    Name = $label.Name
                }
            }
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
        Stop-CmdletExecution -Id $cmdletExecutionId -ErrorCount $Error.Count
    }
}
