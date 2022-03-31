function Get-SharePointTenantAdminBatchApiUrl
{
    return '{0}/_api/$batch' -f (Get-SharePointTenantAdminUrl)
}