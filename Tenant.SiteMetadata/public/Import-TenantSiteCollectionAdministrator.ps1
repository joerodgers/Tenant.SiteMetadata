using namespace Tenant.SiteMetadata

function Import-TenantSiteCollectionAdministrator
{
<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER DatabaseConnectionInformation

    .EXAMPLE
#>
    [CmdletBinding(DefaultParameterSetName="All")]
    param
    (
    )

    begin
    {
        $cmdletExecutionId = Start-CmdletExecution -Cmdlet $PSCmdlet -ClearErrors

        Initialize-SharePointTenantConnection
        Initialize-MicrosoftGraphConnection
    }
    process
    {
        Assert-MicrosoftGraphConnection -Cmdlet $PSCmdlet
        Assert-SharePointConnection     -Cmdlet $PSCmdlet
    }
    end
    {
        Disconnect-MgGraph -ErrorAction SilentlyContinue

        Stop-CmdletExecution -Id $cmdletExecutionId -ErrorCount $Error.Count
    }
}

