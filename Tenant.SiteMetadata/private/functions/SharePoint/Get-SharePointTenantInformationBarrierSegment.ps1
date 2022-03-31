function Get-SharePointTenantInformationBarrierSegment
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
            Invoke-PnPSPRestMethod `
                -Method "GET" `
                -Url    "/_api/Microsoft.Online.SharePoint.TenantAdministration.Tenant/GetTenantAllOrCompatibleIBSegments" `
                -ErrorAction Stop | Select-Object -ExpandProperty value
        }
        catch
        {
            Write-PSFMessage -Message "Failed to retrieve information barrier segments from SharePoint." -EnableException $true -ErrorRecord $_ -Level Critical
        }
    }
    end
    {
        Write-PSFMessage "Completed" -Level Debug
    }
}