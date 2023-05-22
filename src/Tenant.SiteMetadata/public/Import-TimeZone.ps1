function Import-TimeZone
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
        Assert-SharePointConnection -Cmdlet $PSCmdlet

        [System.Collections.Generic.List[Object]]$list = Get-PnPTimeZoneId 

        $json = $list | Select-Object Id, Identifier, Description | ConvertTo-Json

        Invoke-StoredProcedure -StoredProcedure "site.proc_AddOrUpdateTimeZone" -Parameters @{ json =  $json }
    }
    end
    {
        Stop-CmdletExecution -Id $cmdletExecutionId -ErrorCount $Error.Count
    }
}