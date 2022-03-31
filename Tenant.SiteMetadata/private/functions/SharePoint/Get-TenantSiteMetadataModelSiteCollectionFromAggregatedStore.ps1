
function Get-TenantSiteMetadataModelSiteCollectionFromAggregatedStore
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $SiteUrl,

        [Parameter(Mandatory=$true)]
        [ValidateSet("AggregatedStore", "AllSitesAggregatedStore")]
        [string]
        $AggregatedStore
    )

    begin
    {
        if( $AggregatedStore -eq "AggregatedStore" )
        {
            $properties = @( "ConditionalAccessPolicy", "ExternalSharing", "GroupId", "HubSiteId", "RelatedGroupId", "SensitivityLabel", "SiteCreationSource", "SiteId", "SiteUrl", "StorageQuota", "StorageUsed", "TemplateName", "TimeCreated", "TimeDeleted", "Title" )

            $endpoint = '/_api/web/lists/GetByTitle(''DO_NOT_DELETE_SPLIST_TENANTADMIN_AGGREGATED_SITECOLLECTIONS'')/items?$filter=SiteUrl eq ''{0}''&$select={1}' -f $SiteUrl, ($properties -join ',')
        }
        else 
        {
            $properties = @( "ConditionalAccessPolicy", "LastItemModifiedDate", "SensitivityLabel", "ShareByEmailEnabled", "SiteId", "SiteUrl", "StorageQuota", "StorageUsed", "TemplateName", "TimeCreated", "TimeDeleted", "Title" )

            $endpoint = '/_api/web/lists/GetByTitle(''DO_NOT_DELETE_SPLIST_TENANTADMIN_ALL_SITES_AGGREGATED_SITECOLLECTIONS'')/items?$filter=SiteUrl eq ''{0}''&$select={1}' -f $SiteUrl, ($properties -join ',')
        }

        $propertyMap = @{ 
            "ConditionalAccessPolicy" = "ConditionalAccessPolicy"
            "LastItemModifiedDate"    = "LastItemModifiedDate"
            "GroupId"                 = "GroupId"
            "HubSiteId"               = "HubSiteId" 
            "RelatedGroupId"          = "RelatedGroupId"
            "SensitivityLabel"        = "SensitivityLabel"
            "SiteCreationSource"      = "SiteCreationSource"
            "SiteId"                  = "SiteId"
            "SiteUrl"                 = "SiteId"
            "StorageQuota"            = "StorageQuota"
            "StorageUsed"             = "StorageUsed"
            "TemplateName"            = "Template"
            "TimeCreated"             = "CreatedDate"
            "TimeDeleted"             = "DeletedDate"
            "Title"                   = "Title"
        }
    }
    process
    {
        Assert-SharePointConnection -Cmdlet $PSCmdlet

        $response = Invoke-PnPSPRestMethod `
                            -Method Get `
                            -Url    $endpoint `
                            -Raw

        $object = $response | ConvertFrom-Json
    
        $model = New-Object Tenant.SiteMetadata.Model.SiteCollection

        foreach( $property in $properties )
        {
            if( $object.$property )
            {
                $model."$($propertyMap.$property)" =  $object.$property
            }
        }

        return $model
    }
    end
    {
    }
}