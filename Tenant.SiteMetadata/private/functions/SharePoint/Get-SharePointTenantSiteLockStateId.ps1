function Get-SharePointTenantSiteLockStateId
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [Guid]
        $SiteId
    )

    begin
    {
        Assert-SharePointConnection -Cmdlet $PSCmdlet
    }
    process
    {
        try 
        {
            Write-PSFMessage -Message "Executing Invoke-PnPSPRestMethod -Method `"GET`" -Url: `"/_api/Microsoft.Online.SharePoint.TenantAdministration.Tenant/sites/GetLockStateById('$SiteId')`" -Raw"

            $response = Invoke-PnPSPRestMethod `
                            -Method "GET" `
                            -Url    "/_api/Microsoft.Online.SharePoint.TenantAdministration.Tenant/sites/GetLockStateById('$SiteId')" `
                            -Raw `
                            -ErrorAction Stop | ConvertFrom-Json

            return $response.value 
        }
        catch
        {
            Write-PSFMessage -Message "Failed to retrieve site lock state for site $($SiteId) from SharePoint." -EnableException $true -ErrorRecord $_ -Level Critical
        }
    }
    end
    {
    }
}