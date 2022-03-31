function Get-SharePointTenantSiteCreationSource
{
    [CmdletBinding()]
    param
    (
    )

    begin
    {
        Assert-SharePointConnection -Cmdlet $PSCmdlet
    }
    process
    {
        Write-PSFMessage -Message "Executing Invoke-PnPSPRestMethod against $url"

        try 
        {
            [PSCustomObject] @{
                Id                 = "14D82EEC-204B-4C2F-B7E8-296A70DAB67E"
                SiteCreationSource = "Microsoft Graph"
            }
    
            [PSCustomObject] @{
                Id                 = "5D9FFF84-5B34-4204-BC91-3AAF5F298C5D"
                SiteCreationSource = "PnP Lookbook"
            }

            $siteCreationSources = Invoke-PnPSPRestMethod `
                                        -Method "GET" `
                                        -Url    "/_api/Microsoft.Online.SharePoint.TenantAdministration.Tenant/GetSPOSiteCreationSources" | Select-Object -ExpandProperty value

            foreach( $siteCreationSource in $siteCreationSources )
            {
                [PSCustomObject] @{
                    Id                 = $siteCreationSource.Id
                    SiteCreationSource = $siteCreationSource.DisplayName
                }
            }
        }
        catch
        {
            Write-PSFMessage -Message "Failed to retrieve site creation sources from SharePoint." -EnableException $true -ErrorRecord $_ -Level Critical
        }
    }
    end
    {
    }
}