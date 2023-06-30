function Get-SharePointTenantGeoLocation
{
    [CmdletBinding()]
    param
    (
    )

    begin
    {
        $context = Get-PnPContext
    }
    process
    {
        $response = Invoke-PnPSPRestMethod -Method "Get" -Url "/_api/TenantInformationCollection"

        foreach( $geo in $response.value )
        {
            if(  $context.Url -eq $geo.TenantAdminDomain )
            {
                return $geo.GeoLocation
            }
        }

        return $null
    }
    end
    {
    }
}