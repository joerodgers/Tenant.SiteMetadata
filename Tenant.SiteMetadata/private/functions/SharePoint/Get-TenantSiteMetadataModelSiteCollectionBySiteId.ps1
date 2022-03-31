function Get-TenantSiteMetadataModelSiteCollectionBySiteId
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
    }
    process
    {
        Assert-SharePointConnection -Cmdlet $PSCmdlet

        try 
        {
            if( $siteUrl = Get-SharePointTenantSiteUrlBySiteId -SiteId $SiteId )
            {
                return Get-TenantSiteMetadataModelSiteCollectionBySiteUrl -SiteUrl $siteUrl
            }

            Write-PSFMessage -Message "Failed to find site with Id: $SiteId" 

            return $null
        }
        catch
        {
            Write-PSFMessage -Message "Failed to retrieve tenant sites by site Id: $SiteId " -EnableException $true -ErrorRecord $_ -Level Critical
        }
    }
    end
    {
    }
}
