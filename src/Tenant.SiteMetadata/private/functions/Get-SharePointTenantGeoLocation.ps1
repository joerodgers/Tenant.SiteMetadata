function Get-SharePointTenantGeoLocation
{
    [CmdletBinding()]
    param
    (
    )

    begin
    {
    }
    process
    {
        $response = Invoke-PnPSPRestMethod `
                            -Method "Get" `
                            -Url    "/_api/TenantInformationCollection"

        return $response.value.GeoLocation
    }
    end
    {
    }
}