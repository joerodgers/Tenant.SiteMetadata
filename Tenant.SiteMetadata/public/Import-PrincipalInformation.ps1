using namespace Tenant.SiteMetadata

function Import-PrincipalInformation
{
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

        Invoke-MicrosoftGraphPrincipalImport
    }
    end
    {
        Stop-CmdletExecution -Id $cmdletExecutionId -ErrorCount $Error.Count
    }
}
