using namespace Tenant.SiteMetadata

function Import-SiteCreationSource
{
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
        try
        {
            Assert-SharePointConnection -Cmdlet $PSCmdlet

            Write-PSFMessage -Message "Querying tenant for site creation sources" -Level Verbose

            $siteCreationSources = Invoke-PnPSPRestMethod `
                                        -Method "GET" `
                                        -Url    "/_api/Microsoft.Online.SharePoint.TenantAdministration.Tenant/GetSPOSiteCreationSources" | Select-Object -ExpandProperty value

            $siteCreationSources += [PSCustomObject] @{
                Id                 = "14D82EEC-204B-4C2F-B7E8-296A70DAB67E"
                SiteCreationSource = "Microsoft Graph"
            }

            $siteCreationSources += [PSCustomObject] @{
                Id                 = "5D9FFF84-5B34-4204-BC91-3AAF5F298C5D"
                SiteCreationSource = "PnP Lookbook"
            }

            $json = $siteCreationSources | ConvertTo-Json

            Write-PSFMessage -Message "Merging $($siteCreationSources.Count) site creation sources into database" -Level Verbose

            Invoke-StoredProcedure -StoredProcedure "site.proc_AddOrUpdateSiteCreationSource" -Parameters @{ json =  $json }
        }
        catch
        {
            Stop-CmdletExecution -Id $cmdletExecutionId -ErrorCount $global:Error.Count

            Write-PSFMessage -Message "Failed to import site creation sources" -ErrorRecord $_ -EnableException $true -Level Critical
        }
    }
    end
    {
        Stop-CmdletExecution -Id $cmdletExecutionId -ErrorCount $global:Error.Count
    }
}
