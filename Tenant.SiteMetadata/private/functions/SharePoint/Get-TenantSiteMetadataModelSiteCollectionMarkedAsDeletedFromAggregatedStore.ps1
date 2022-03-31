
function Get-TenantSiteMetadataModelSiteCollectionMarkedAsDeletedFromAggregatedStore
{
    [CmdletBinding()]
    param
    (
    )

    begin
    {
        # maps the columns in the AggregatedStore list with Tenant.SiteMetadata.Model.SiteCollection

        $propertyMap = @{ 
            "ConditionalAccessPolicy" = "ConditionalAccessPolicy"
            "LastItemModifiedDate"    = "LastItemModifiedDate"
            "SensitivityLabel"        = "SensitivityLabel"
            "SiteId"                  = "SiteId"
            "SiteUrl"                 = "SiteUrl"
            "StorageQuota"            = "StorageQuota"
            "StorageUsed"             = "StorageUsed"
            "TemplateName"            = "Template"
            "TimeCreated"             = "CreatedDate"
            "TimeDeleted"             = "DeletedDate"
            "Title"                   = "DisplayName"
        }

        $endpoint = '/_api/web/lists/GetByTitle(''DO_NOT_DELETE_SPLIST_TENANTADMIN_ALL_SITES_AGGREGATED_SITECOLLECTIONS'')/items?$filter=TimeDeleted ne null&$select={0}' -f ($propertyMap.Keys -join ',')
    }
    process
    {
        Assert-SharePointConnection -Cmdlet $PSCmdlet

        do 
        {
            
            $response = Invoke-PnPSPRestMethod `
                                -Method Get `
                                -Url    $endpoint `
                                -Raw

            $object = $response | ConvertFrom-Json
            
            $endpoint = $object.'@odata.nextLink'

            foreach( $deletedSite in $object.value )
            {
                $model = New-Object Tenant.SiteMetadata.Model.SiteCollection

                foreach( $property in $propertyMap.Keys )
                {
                    if( $deletedSite.$property )
                    {
                        if( $object.$property -eq "StorageQuota" )
                        {
                            $model.StorageQuota = ($deletedSite.$property / 1MB) # convert bytes to mb
                            continue
                        }

                        if( $object.$property -eq "StorageUsed" )
                        {
                            $model.StorageUsed = ($deletedSite.$property / 1MB) # convert bytes to mb
                            continue
                        }

                        $model."$($propertyMap.$property)" =  $deletedSite.$property
                    }
                }

                ,$model
            }
        }
        while( $endpoint )
    }
    end
    {
    }
}