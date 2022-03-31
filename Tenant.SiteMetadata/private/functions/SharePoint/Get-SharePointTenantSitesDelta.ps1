function Get-SharePointTenantSitesDelta
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false)]
        [string]
        $DeltaToken = ""
    )

    begin
    {
        $url = '/_api/v2.0/sites/delta?$select=SharepointIds&token={0}' -f $DeltaToken

        $sites = New-Object System.Collections.Generic.List[PSCustomObject]
    }
    process
    {
        <#
            createdDateTime      : 2022-01-31T16:17:55Z
            lastModifiedDateTime : 2022-03-23T17:51:59.640969Z
            webUrl               : https://contoso.sharepoint.com/sites/foobar
            title                : Agile COE
            dataLocationCode     : 
            sharepointIds        : @{siteId=146672d2-a35b-407a-a93e-d96a7ce80e92; siteUrl=https://contoso.sharepoint.com/sites/foobar; tenantId=1216cd1f-b0c7-4253-a7f3-ccc9041aaaf9; webId=14ba64c4-6f87-48cb-843d-78a6940980ac}
            owner                : @{user=}
            template             : @{id=1}
            sensitivityLabel     : 
        #>

        do
        {
            try 
            {
                Write-PSFMessage "Executing Invoke-PnPSPRestMethod with Url: $($url)"

                $response = Invoke-PnPSPRestMethod `
                                        -Url    $url `
                                        -Method "GET" `
                                        -Raw `
                                        -ErrorAction Stop
                
                $object = $response | ConvertFrom-Json
            
                $url = $object.'@odata.nextLink' # next page

                Write-PSFMessage "Found: $($object.value.count) sites"

                foreach( $site in $object.value )
                {
                    $created  = [DateTime]::Parse( $site.createdDateTime )
                    $siteId   = [System.Guid]::Parse( $site.sharepointIds.siteId )
                    $siteUrl  = [System.Web.HttpUtility]::UrlDecode( $site.sharepointIds.siteUrl )

                    $site = [PSCustomObject] @{
                                SiteId               = $siteId
                                SiteUrl              = $siteUrl
                                CreatedDateTime      = $created
                                LastModifiedDateTime = $modified
                            }

                    $sites.Add($site)
                }
            }
            catch
            {
                Write-PSFMessage -Message "Failed to proccess sites REST call. URL='$($url)'" -ErrorRecord $_ -Level Error
            }
        }
        while( -not [string]::IsNullOrEmpty($url) )

        Write-PSFMessage -Message "deltalink: $($object.'@odata.deltaLink')"

        [PSCustomObject] @{
            value      = $sites.ToArray()
            DeltaToken = $object.'@delta.token'
        }
    }
    end
    {
    }
}