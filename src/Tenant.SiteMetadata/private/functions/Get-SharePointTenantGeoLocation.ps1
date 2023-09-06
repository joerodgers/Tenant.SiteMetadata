function Get-SharePointTenantGeoLocation
{
    [CmdletBinding()]
    param
    (
    )

    begin
    {
        $context = Get-PnPContext

        if( -not (Get-Variable -Name "GeoLocationCache" -Scope Script -ErrorAction Ignore ) )
        {
            Set-Variable -Name "GeoLocationCache" -Value @{} -Scope Script -ErrorAction Stop
        } 
    }
    process
    {
        if( -not $script:GeoLocationCache.ContainsKey( $context.Url ))
        {
            $response = Invoke-PnPSPRestMethod -Method "Get" -Url "/_api/TenantInformationCollection"

            foreach( $geo in $response.value )
            {
                $script:GeoLocationCache[ $geo.TenantAdminDomain ] = $geo.GeoLocation
            }
    
        }

        return $script:GeoLocationCache[ $context.Url ]
    }
    end
    {
    }
}