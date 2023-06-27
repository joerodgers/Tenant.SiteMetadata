using namespace System.Collections.Generic
function Get-SharePointTenantAggregatedStoreSite
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false)]
        [switch]
        $IncludeDeletedSites,

        [Parameter(Mandatory=$false)]
        [ValidateRange(1,5000)]
        [int]
        $PageSize = 5000
    )

    begin
    {
        $parameters = @{}

        $propertyMap = @{ 
            "GroupId"            = "GroupId"
            "HubSiteId"          = "HubSiteId"
            "RelatedGroupId"     = "RelatedGroupId"
            "SensitivityLabel"   = "SensitivityLabel"
            "SiteCreationSource" = "SiteCreationSource"
            "SiteId"             = "SiteId"
            "SiteUrl"            = "SiteUrl"
            "TemplateName"       = "Template"
            "TimeCreated"        = "CreatedDate"
            "TimeDeleted"        = "DeletedDate"
            "Title"              = "Title"
            "NumOfFiles"         = "TotalFileCount"
        }

        # auto generate the select-object properties by building a dynamic mapping using the $propertyMap hashtable
        $properties = @( $propertyMap.Keys | ForEach-Object { @{ Name=$propertyMap[$_]; Expression=[ScriptBlock]::Create( "`$_.FieldValues.'$($_)'.ToString()" )} } )
    }
    process
    {
        Write-PSFMessage -Message "Reading items from $($parameters.List) list with query: $($parameters.Query)" -Level Verbose

        $items = Get-PnPListItem  -List "DO_NOT_DELETE_SPLIST_TENANTADMIN_AGGREGATED_SITECOLLECTIONS" -PageSize $PageSize | Select-Object $properties

        if( $IncludeDeletedSites.IsPresent )
        {
            # need to filter out any entries w/o a SiteId and SiteUrl
            $items = $items.Where( { $null -ne $_.SiteId -and $null -ne $_.SiteUrl })
        }
        else
        {
            # need to filter out any entries w/o a SiteId and SiteUrl and no DeletedDate
            $items = $items.Where( { $null -ne $_.SiteId -and $null -ne $_.SiteUrl -and $null -ne $_.DeletedDate})
        }

        Write-PSFMessage -Message "Read $($items.Count) items from $($parameters.List) list" -Level Verbose

        return ,[System.Collections.Generic.List[PSCustomObject]]$items
    }
    end
    {
    }
}