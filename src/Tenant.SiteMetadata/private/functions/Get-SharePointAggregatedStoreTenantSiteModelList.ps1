function Get-SharePointAggregatedStoreTenantSiteModelList
{
    [OutputType([System.Collections.Generic.List[TenantSiteModel]])]
    [CmdletBinding()]
    param
    (
    )

    begin
    {
        Write-PSFMessage "Starting" -Level Verbose

        $models = New-Object System.Collections.Generic.List[TenantSiteModel]
    }
    process
    {
        Write-PSFMessage -Message "Reading items from 'DO_NOT_DELETE_SPLIST_TENANTADMIN_AGGREGATED_SITECOLLECTIONS' list with query." -Level Verbose

        $items = Get-PnPListItem  -List "DO_NOT_DELETE_SPLIST_TENANTADMIN_AGGREGATED_SITECOLLECTIONS" -PageSize 5000

        Write-PSFMessage -Message "Read $($items.Count) items from 'DO_NOT_DELETE_SPLIST_TENANTADMIN_AGGREGATED_SITECOLLECTIONS' list." -Level Verbose

        foreach( $item in $items )
        {
            if( [string]::IsNullOrEmpty($item.FieldValues.SiteUrl) -or [string]::IsNullOrEmpty($item.FieldValues.SiteId))
            {
                Write-PSFMessage -Message "Skipping item $($item.Id) due to empty SiteId or SiteUrl" -Level Warning
                continue
            }

            $model = [TenantSiteModel]::new()
            $model.CreatedDate             = $item.FieldValues.TimeCreated | Get-DateTimeOrNull
            $model.DeletedDate             = $item.FieldValues.TimeDeleted | Get-DateTimeOrNull
            $model.Description             = $null
            $model.GroupId                 = $item.FieldValues.GroupId   | Get-GuidOrNull
            $model.HubSiteId               = $item.FieldValues.HubSiteId | Get-GuidOrNull
            $model.LastContentModifiedDate = $null
            $model.LockIssue               = $null
            $model.LockState               = $null
            $model.RelatedGroupId          = $item.FieldValues.RelatedGroupId     | Get-GuidOrNull
            $model.SiteCreationSource      = $item.FieldValues.SiteCreationSource | Get-GuidOrNull
            $model.SensitivityLabel        = $item.FieldValues.SensitivityLabel   | Get-GuidOrNull
            $model.SiteId                  = $item.FieldValues.SiteId             | Get-GuidOrNull
            $model.SiteUrl                 = $item.FieldValues.SiteUrl
            $model.Status                  = $null
            $model.StorageMaximumLevel     = $item.FieldValues.StorageQuota
            $model.StorageQuotaType        = $null
            $model.StorageUsage            = $item.FieldValues.StorageUsed
            $model.StorageWarningLevel     = $null
            $model.Template                = $item.FieldValues.TemplateName
            $model.Title                   = $item.FieldValues.Title
            $model.TotalFileCount          = $item.FieldValues.NumOfFiles

            $models.Add($model)
        }

    }
    end
    {
        Write-PSFMessage "Completed" -Level Verbose

        return ,$models
    }
}
