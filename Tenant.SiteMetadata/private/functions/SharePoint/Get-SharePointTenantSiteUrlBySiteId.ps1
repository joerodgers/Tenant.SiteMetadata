function Get-SharePointTenantSiteUrlBySiteId
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [Guid]
        $SiteId
    )

    begin
    {
    }
    process
    {
        Assert-SharePointConnection -Cmdlet $PSCmdlet

        $accessToken = Get-SharePointTenantAdminAccessToken

        $response = Invoke-RestMethod `
                            -Url    "_api/v2.0/sites/$($SiteId.ToString())" `
                            -Method "GET" `
                            -Headers @{ "Authorization" = "Bearer $accessToken"; "accept" = "application/json" } `
                            -ErrorAction Stop

        $object = $response | ConvertFrom-Json

        if( $object.value )
        {
            return [System.Web.HttpUtility]::UrlDecode($object.value[0].webUrl)
        }

        return $null
    }
    end
    {
    }
}