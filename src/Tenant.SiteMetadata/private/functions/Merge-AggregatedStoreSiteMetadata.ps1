function Merge-AggregatedStoreSiteMetadata
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [System.Collections.Generic.List[PSCustomObject]]
        $Left,

        [Parameter(Mandatory=$true)]
        [System.Collections.Generic.List[PSCustomObject]]
        $Right
    )

    begin
    {
        $func = { param ($site) $site.SiteUrl } -as [System.Func[System.Object, string]]
    }
    process
    {
        $resultSelector = {
            param
            (
                $Left,
                $Right
            )

            $r = [System.Linq.Enumerable]::SingleOrDefault($Right)

            [PSCustomObject] @{
                SiteUrl                           = $Left.SiteUrl
                Description                       = $Left.Description
                DisableSharingForNonOwnersStatus  = $Left.DisableSharingForNonOwnersStatus
                HubSiteId                         = $Left.HubSiteId
                LastContentModifiedDate           = $Left.LastContentModifiedDate
                LockIssue                         = $Left.LockIssue
                LockState                         = $Left.LockState
                OwnerEmail                        = $Left.OwnerEmail
                OwnerLoginName                    = $Left.OwnerLoginName
                OwnerName                         = $Left.OwnerName
                Status                            = $Left.Status
                StorageQuota                      = $Left.StorageQuota
                StorageQuotaType                  = $Left.StorageQuotaType
                StorageQuotaWarningLevel          = $Left.StorageQuotaWarningLevel
                StorageUsageCurrent               = $Left.StorageUsageCurrent
                SiteId                            = $r.SiteId
                GroupId                           = $r.GroupId
                RelatedGroupId                    = $r.RelatedGroupId
                SensitivityLabel                  = $r.SensitivityLabel
                SiteCreationSource                = $r.SiteCreationSource
                Template                          = $r.Template
                CreatedDate                       = $r.CreateDate
                DeletedDate                       = $r.DeletedDate
                Title                             = $r.Title
            }

        } -as [System.Func[System.Object, [Collections.Generic.IEnumerable[System.Object]], System.Object]]

        Write-PSFMessage "Merging aggregated store site metadata" -Level Verbose

        $joined = [System.Linq.Enumerable]::GroupJoin( $Left, $Right, $func, $func, $resultSelector )

        $list = [System.Linq.Enumerable]::ToList( $joined )

        Write-PSFMessage "Merged aggregated store site metadata" -Level Verbose

        return ,$list
    }
    end
    {
    }
}
