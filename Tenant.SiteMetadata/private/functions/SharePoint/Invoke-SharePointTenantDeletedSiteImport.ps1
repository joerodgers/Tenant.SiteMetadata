function Invoke-SharePointTenantDeletedSiteImport
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
        Assert-SharePointConnection -Cmdlet $PSCmdlet

        $deletedSites = @(Get-TenantSiteMetadataModelSiteCollectionMarkedAsDeletedFromAggregatedStore)

        Write-PSFMessage -Message "Discovered $($deletedSites.Count) deleted sites from the aggregate store"

        foreach( $deletedSite in $deletedSites )
        {
            Register-SiteCollection `
                -SiteId             $deletedSite.SiteId `
                -SiteUrl            $deletedSite.SiteUrl `
                -DeletedDate        $deletedSite.DeletedDate `
                -StorageQuota       $deletedSite.StorageQuota `
                -DisplayName        $deletedSite.DisplayName `
                -SiteCreationSource $deletedSite.SiteCreationSource `
                -Template           $deletedSite.Template
        }
    }
    end
    {
    }
}