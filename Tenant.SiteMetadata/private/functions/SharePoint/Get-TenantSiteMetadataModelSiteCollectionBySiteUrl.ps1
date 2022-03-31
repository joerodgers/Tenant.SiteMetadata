function Get-TenantSiteMetadataModelSiteCollectionBySiteUrl
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [Uri]
        $SiteUrl
    )

    begin
    {
    }
    process
    {
        Assert-SharePointConnection -Cmdlet $PSCmdlet

        try 
        {
            $siteId = Get-SharePointTenantSiteIdByUrl -SiteUrl $tenantsite.Url | Select-Object -ExpandProperty SiteId

            $tenantsite = Get-PnPTenantSite -Identity $SiteUrl -Detailed -IncludeOneDriveSites -ErrorAction Stop

            ,(ConvertTo-TenantSiteMetadataModelSiteCollection -SiteId $siteId -PnPTenantSite $tenantsite)
        }
        catch
        {
            Write-PSFMessage -Message "Failed to retrieve tenant sites by site url: $SiteUrl " -EnableException $true -ErrorRecord $_ -Level Critical
        }
    }
    end
    {
    }
}
