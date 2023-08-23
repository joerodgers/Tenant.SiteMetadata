function Get-SharePointDeletedSiteModelList
{
    [OutputType([System.Collections.Generic.List[TenantSiteModel]])]
    [CmdletBinding()]
    param
    (
    )

    begin
    {
        $models = New-Object System.Collections.Generic.List[TenantSiteModel]
    }
    process
    {
        Write-PSFMessage -Message "Querying tenant for all deleted OD/SP site collections" -Level Verbose
        
        $tenantSites = Get-PnPTenantDeletedSite -IncludePersonalSite -Limit ([System.UInt32]::MaxValue)  
            
        foreach( $ts in $tenantSites )
        {
            $model = [TenantSiteModel]::new()
            $model.DeletedDate             = $ts.DeletionTime
            $model.SiteId                  = $null
            $model.SiteUrl                 = $ts.Url
            $model.Status                  = $ts.Status
            $model.StorageMaximumLevel     = $ts.StorageQuota

            $models.Add($model)
        }

        Write-PSFMessage -Message "Tenant returned $($models.Count) deleted site collections" -Level Verbose
    }
    end
    {
        return ,$models
    }
}