using namespace Tenant.SiteMetadata

function Import-SiteCreationSource
{
<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER DatabaseConnectionInformation

    .EXAMPLE
#>
    [CmdletBinding()]
    param
    (
    )

    begin
    {
        $cmdletExecutionId = Start-CmdletExecution -Cmdlet $PSCmdlet -ClearErrors

        Initialize-SharePointTenantConnection
    }
    process
    {
        Assert-SharePointConnection -Cmdlet $PSCmdlet

        $siteCreationSources = Get-SharePointTenantSiteCreationSource

        foreach( $siteCreationSource in $siteCreationSources )
        {
            Register-SiteCreationSource `
                        -Id                 $siteCreationSource.Id `
                        -SiteCreationSource $siteCreationSource.SiteCreationSource
        }
    }
    end
    {
        Stop-CmdletExecution -Id $cmdletExecutionId -ErrorCount $Error.Count
    }
}
