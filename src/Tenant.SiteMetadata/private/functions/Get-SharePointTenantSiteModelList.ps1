function Get-SharePointTenantSiteModelList
{
    [OutputType([System.Collections.Generic.List[TenantSiteModel]])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false)]
        [switch]
        $UseRestApi
    )

    begin
    {
        Write-PSFMessage "Starting" -Level Verbose

        $models = New-Object System.Collections.Generic.List[TenantSiteModel]
    }
    process
    {
        if( -not $UseRestApi.IsPresent )
        {
            Write-PSFMessage -Message "Querying tenant for all OD/SP site collections" -Level Verbose

            $tenantSites = Get-PnPTenantSite -IncludeOneDriveSites
            
            foreach( $ts in $tenantSites )
            {
                $model = [TenantSiteModel]::new()
                $model.CreatedDate             = $null
                $model.DeletedDate             = $null
                $model.Description             = $ts.Description
                $model.GroupId                 = $ts.GroupId
                $model.HubSiteId               = $ts.HubSiteId
                $model.LastContentModifiedDate = $ts.LastContentModifiedDate
                $model.LockIssue               = $ts.LockIssue
                $model.LockState               = $ts.LockState
                $model.RelatedGroupId          = $null
                $model.SensitivityLabel        = $null
                $model.SiteCreationSource      = $null
                $model.SiteId                  = $null
                $model.SiteUrl                 = $ts.Url
                $model.Status                  = $ts.Status
                $model.StorageMaximumLevel     = $ts.StorageQuota
                $model.StorageQuotaType        = $ts.StorageQuotaType
                $model.StorageUsage            = $ts.StorageUsageCurrent
                $model.StorageWarningLevel     = $ts.StorageQuotaWarningLevel
                $model.Template                = $ts.Template
                $model.Title                   = $ts.Title
                $model.TotalFileCount          = $null

                $models.Add($model)
            }
        }
        else
        {
            Write-PSFMessage -Message "Querying tenant for all OD/SP site collections using REST API" -Level Verbose

            $restApi = '/_api/v2.1/sites/getallsites?top=5000'

            while( $restApi ) 
            {
                Write-PSFMessage -Message "Executing site batch: $restApi" -Level Verbose
    
                # Invoke-PnPSPRestMethod was not including the '@odata.nextLink' property in the response object 
                $response = Invoke-PnPSPRestMethod -Url $restApi -Raw -ErrorAction Stop | ConvertFrom-Json -ErrorAction Stop
                
                foreach( $ts in $response.value )
                {
                    $model = [TenantSiteModel]::new()
                    $model.CreatedDate             = $ts.createdDateTime | Get-DateTimeOrNull
                    $model.DeletedDate             = $null
                    $model.Description             = $null
                    $model.GroupId                 = $null
                    $model.HubSiteId               = $null
                    $model.LastContentModifiedDate = $null
                    $model.LockIssue               = $null
                    $model.LockState               = $null
                    $model.RelatedGroupId          = $null
                    $model.SensitivityLabel        = $ts.sensitivityLabel | Get-GuidOrNull
                    $model.SiteCreationSource      = $null
                    $model.SiteId                  = ($ts.id -split ",")[1] # contoso.sharepoint.com,79974432-1fbe-4759-aa8c-05520be7ed4a,3f2a29e9-4773-4f10-bf51-3ba9bad0e9d6
                    $model.SiteUrl                 = $ts.webUrl
                    $model.Status                  = $null
                    $model.StorageMaximumLevel     = $null
                    $model.StorageQuotaType        = $null
                    $model.StorageUsage            = $null
                    $model.StorageWarningLevel     = $null
                    $model.Template                = $ts.template.name
                    $model.Title                   = $ts.name
                    $model.TotalFileCount          = $null
    
                    $models.Add($model)
                }

                $restApi = $response.'@odata.nextLink'
            }
    

        }

        Write-PSFMessage -Message "Tenant returned $($models.Count) site collections" -Level Verbose
    }
    end
    {
        Write-PSFMessage "Completed" -Level Verbose

        return ,$models
    }
}


