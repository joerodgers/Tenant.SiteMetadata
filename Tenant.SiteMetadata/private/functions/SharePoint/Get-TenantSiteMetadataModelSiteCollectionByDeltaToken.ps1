function Get-TenantSiteMetadataModelSiteCollectionByDeltaToken
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [ref]
        $DeltaToken
    )

    begin
    {
        $endpoint = '/_api/v2.0/sites/delta?$select=SharepointIds&token={0}' -f $DeltaToken.Value.ToString()
    }
    process
    {
        Assert-SharePointConnection -Cmdlet $PSCmdlet

        do
        {
            Write-PSFMessage -Message "Executing: Invoke-PnPSPRestMethod -Method GET -Url $endpoint"

            $response = Invoke-PnPSPRestMethod `
                                    -Method "GET" `
                                    -Url    $endpoint `
                                    -Raw `
                                    -ErrorAction Stop

            $object = $response | ConvertFrom-Json

            if( $object.value )
            {
                foreach( $tenantSite in $object.value )
                {
                    $model = New-Object Tenant.SiteMetadata.Model.SiteCollection
                    $model.DisplayName = $tenantSite.title
                    $model.SiteId      = $tenantSite.sharepointIds.SiteId
                    $model.SiteUrl     = [System.Web.HttpUtility]::UrlDecode($tenantSite.sharepointIds.SiteUrl)
    
                    if( $tenantSite.createdDateTime )
                    {
                        $model.CreatedDate = $tenantSite.createdDateTime
                    }
    
                    if( $object.sensitivityLabel )
                    {
                        $model.SensitivityLabel = $tenantSite.sensitivityLabel 
                    }
    
                    if( $object.lastModifiedDateTime )
                    {
                        $model.LastItemModifiedDate = $tenantSite.lastModifiedDateTime
                    }
    
                    ,$model
                }
            }

            $endpoint = $object.'@odata.nextLink'
        }
        while($endpoint)

        $DeltaToken.Value = $object.'@delta.token'
    }
    end
    {
    }
}
