function Get-SharePointTenantSiteIdByUrl
{
    [CmdletBinding(DefaultParameterSetName="Tenant")]
    param
    (
        [Parameter(Mandatory=$true,ParameterSetName="Tenant")]
        [Parameter(Mandatory=$true,ParameterSetName="AllSitesAggregatedStore")]
        [Parameter(Mandatory=$true,ParameterSetName="SitesAggregatedStore")]
        [System.Uri]
        $SiteUrl,

        [Parameter(Mandatory=$false,ParameterSetName="AllSitesAggregatedStore")]
        [switch]
        $UseAllSitesAggregatedStoreAsDataSource,

        [Parameter(Mandatory=$false,ParameterSetName="SitesAggregatedStore")]
        [switch]
        $UseSitesAggregatedStoreAsDataSource
    )

    begin
    {
    }
    process
    {
        Assert-SharePointConnection -Cmdlet $PSCmdlet

        if( $PSCmdlet.ParameterSetName -eq "AllSitesAggregatedStore" )
        {
            $endpoint = '/_api/web/lists/GetByTitle(''DO_NOT_DELETE_SPLIST_TENANTADMIN_ALL_SITES_AGGREGATED_SITECOLLECTIONS'')/items?$filter=SiteUrl eq ''{0}''&$select=SiteId' -f $SiteUrl.ToString().Trim().TrimEnd("/")

            $response = Invoke-PnPSPRestMethod `
                                -Method GET `
                                -Url $endpoint `
                                -Raw

            $object = $response | ConvertFrom-Json
            
            return $object.value
        }

        if( $PSCmdlet.ParameterSetName -eq "SitesAggregatedStore" )
        {
            $endpoint = '/_api/web/lists/GetByTitle(''DO_NOT_DELETE_SPLIST_TENANTADMIN_AGGREGATED_SITECOLLECTIONS'')/items?$filter=SiteUrl eq ''{0}''&$select=SiteId' -f $SiteUrl.ToString().Trim().TrimEnd("/")

            $response = Invoke-PnPSPRestMethod `
                                -Method GET `
                                -Url $endpoint `
                                -Raw

            $object = $response | ConvertFrom-Json
            
            return $object.value
        }

        if( $PSCmdlet.ParameterSetName -eq "Tenant" )
        {
            $tenant = Get-SharePointTenant

            return [Microsoft.SharePoint.Client.TenantExtensions]::GetSiteGuidByUrl( $tenant, $SiteUrl.ToString().Trim().TrimEnd("/") ) | Select-Object @{ Name="SiteId"; Expression={$_}}
        }   
    }
    end
    {
    }
}