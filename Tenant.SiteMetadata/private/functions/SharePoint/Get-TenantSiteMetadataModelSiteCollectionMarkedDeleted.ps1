function Get-TenantSiteMetadataModelSiteCollectionMarkedDeleted
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

        try 
        {
            $deletedSites = @(Get-PnPTenantDeletedSite -IncludePersonalSite -Limit 0)

            foreach( $deletedSite in $deletedSites )
            {
                $model = New-Object Tenant.SiteMetadata.Model.SiteCollection
                $model.SiteId       = $deletedSite.SiteId
                $model.DeletedDate  = $deletedSite.DeletionTime
                $model.StorageQuota = $deletedSite.StorageQuota

                ,$model
            }
        }
        catch
        {
            Write-PSFMessage -Message "Failed to retrieve deleted tenant sites" -EnableException $true -ErrorRecord $_ -Level Critical
        }
    }
    end
    {
    }
}