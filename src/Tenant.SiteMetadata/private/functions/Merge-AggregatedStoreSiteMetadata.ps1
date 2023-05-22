function Merge-AggregatedStoreSiteMetadata
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [System.Collections.Generic.IList[PSCustomObject]]
        $TenantSitesList,

        [Parameter(Mandatory=$true)]
        [System.Collections.Generic.IList[PSCustomObject]]
        $AggregatedStoreSitesList
    )

    begin
    {
    }
    process
    {
        foreach( $tenantSite in $TenantSitesList.GetEnumerator() )
        {
            $site = $AggregatedStoreSitesList.Where( { $_.SiteUrl -eq $tenantSite.SiteUrl } )
        
            if( $site )
            {
                $tenantSite.SiteId             = $site.SiteId
                $tenantSite.GroupId            = $site.GroupId
                $tenantSite.HubSiteId          = $site.HubSiteId
                $tenantSite.RelatedGroupId     = $site.RelatedGroupId
                $tenantSite.SensitivityLabel   = $site.SensitivityLabel
                $tenantSite.SiteCreationSource = $site.SiteCreationSource
                $tenantSite.Template           = $site.Template
                $tenantSite.CreatedDate        = $site.CreateDate
                $tenantSite.DeletedDate        = $site.DeletedDate
                $tenantSite.Title              = $site.Title
            }
        }
    }
    end
    {

    }
}