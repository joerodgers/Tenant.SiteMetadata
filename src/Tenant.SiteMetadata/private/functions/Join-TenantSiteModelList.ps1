function Join-TenantSiteModelList
{
    [OutputType([System.Collections.Generic.List[TenantSiteModel]])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [System.Collections.Generic.List[TenantSiteModel]]
        $OuterList,

        [Parameter(Mandatory=$true)]
        [System.Collections.Generic.List[TenantSiteModel]]
        $InnerList
    )

    begin
    {
        Write-PSFMessage "Starting" -Level Verbose

        $keySelector = { param ($model) $model.SiteUrl } -as [System.Func[TenantSiteModel, string]]
    }
    process
    {
        $resultSelector = {
            param
            (
                $Outer,
                $InnerList
            )

            $inner = [System.Linq.Enumerable]::SingleOrDefault($InnerList) # this will throw an exception if there are duplicates
            
            $model = [TenantSiteModel]::new()
            $model.CreatedDate             = $Outer.CreatedDate             ?? $inner.CreatedDate
            $model.DeletedDate             = $Outer.DeletedDate             ?? $inner.DeletedDate
            $model.Description             = $Outer.Description             ?? $inner.Description
            $model.GroupId                 = $Outer.GroupId                 ?? $inner.GroupId
            $model.HubSiteId               = $Outer.HubSiteId               ?? $inner.HubSiteId
            $model.LastContentModifiedDate = $Outer.LastContentModifiedDate ?? $inner.LastContentModifiedDate
            $model.LockIssue               = $Outer.LockIssue               ?? $inner.LockIssue
            $model.LockState               = $Outer.LockState               ?? $inner.LockState
            $model.RelatedGroupId          = $Outer.RelatedGroupId          ?? $inner.RelatedGroupId
            $model.SensitivityLabel        = $Outer.SensitivityLabel        ?? $inner.SensitivityLabel
            $model.SiteCreationSource      = $Outer.SiteCreationSource      ?? $inner.SiteCreationSource
            $model.SiteId                  = $Outer.SiteId                  ?? $inner.SiteId
            $model.SiteUrl                 = $Outer.SiteUrl                 ?? $inner.SiteUrl
            $model.Status                  = $Outer.Status                  ?? $inner.Status
            $model.StorageMaximumLevel     = $Outer.StorageMaximumLevel     ?? $inner.StorageMaximumLevel
            $model.StorageQuotaType        = $Outer.StorageQuotaType        ?? $inner.StorageQuotaType
            $model.StorageUsage            = $Outer.StorageUsage            ?? $inner.StorageUsage
            $model.StorageWarningLevel     = $Outer.StorageWarningLevel     ?? $inner.StorageWarningLevel
            $model.Template                = $Outer.Template                ?? $inner.Template
            $model.Title                   = $Outer.Title                   ?? $inner.Title
            $model.TotalFileCount          = $Outer.TotalFileCount          ?? $inner.TotalFileCount
            
            return $model

        } -as [System.Func[TenantSiteModel, [Collections.Generic.IEnumerable[TenantSiteModel]], TenantSiteModel]]

        $joined = [System.Linq.Enumerable]::GroupJoin( $OuterList, $InnerList, $keySelector, $keySelector, $resultSelector )

        $list = [System.Linq.Enumerable]::ToList( $joined )
    }
    end
    {
        Write-PSFMessage "Completed" -Level Verbose

        return ,$list
    }
}
