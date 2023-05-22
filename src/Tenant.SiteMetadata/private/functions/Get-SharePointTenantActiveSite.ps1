using namespace System.Collections.Generic

function Get-SharePointTenantActiveSite
{

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false)]
        [switch]
        $IncludeOneDriveSites
    )

    begin
    {
        # these are the only properties returned when querying the tenant for anything but a single site
        $properties =   "Description",
                        "DisableSharingForNonOwnersStatus",
                        "GroupId",
                        "HubSiteId",
                        "LastContentModifiedDate",
                        "LockIssue",
                        "LockState",
                        "OwnerEmail",
                        "OwnerLoginName",
                        "OwnerName",
                        "RelatedGroupId",
                        @{ Name="SiteUrl"; Expression={ $_.Url }},
                        "Status",
                        "StorageQuota",
                        "StorageQuotaType",
                        "StorageQuotaWarningLevel",
                        "StorageUsageCurrent",
                        "Template",
                        "Title",
                        # these properties are populated later by merging in the aggregate list data
                        "SiteId",
                        "SensitivityLabel",
                        "SiteCreationSource",
                        "CreatedDate",
                        "DeletedDate"
    }
    process
    {
        Write-PSFMessage -Message "Querying tenant for all ODSP site collections" -Level Verbose

        $sites = Get-PnPTenantSite -IncludeOneDriveSites:$IncludeOneDriveSites.IsPresent | Select-Object $properties

        Write-PSFMessage -Message "Tenant query return $($sites.Count) site collections" -Level Verbose

        return ,[System.Collections.Generic.List[PSCustomObject]]$sites
    }
    end
    {
    }
}


