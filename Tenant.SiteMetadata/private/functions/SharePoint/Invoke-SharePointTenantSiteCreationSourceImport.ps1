function Invoke-SharePointTenantSiteCreationSourceImport
{
    [CmdletBinding()]
    param
    (
    )
    

    begin
    {
    }
    process
    {
        # since getting site creation source is expensive, let's get sites with a no SiteCreationSource, it never changes
        $sitesWithNullSiteCreationSource = Get-DataTable `
                                                -Query "SELECT SiteId, SiteUrl FROM SitesWithoutSiteCreationSource" `
                                                -As    "PSObject"
        
        Write-PSFMessage -Message "Discovered $($sitesWithNullSiteCreationSource.Count) sites missing site creation source"

        if( $sitesWithNullSiteCreationSource.Count -eq 0 )
        { 
            return
        }

        foreach( $siteWithNullSiteCreationSource in $sitesWithNullSiteCreationSource )
        {
            $site = Get-SharePointTenantSiteIdByUrl -SiteUrl $siteWithNullSiteCreationSource.SiteUrl -UseSitesAggregatedStoreAsDataSource   

            if( $site.SiteId -eq $siteWithNullSiteCreationSource.SiteId -and $site.SiteCreationSource )
            {
                Write-PSFMessage -Message "Updating site creation source for site $($site.SiteUrl)"

                Register-SiteCollection -SiteId $site.SiteId -SiteCreationSource $site.SiteCreationSource
            }
        }
    }
    end
    {
    }
}