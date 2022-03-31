function ConvertTo-BatchResponse
{
    [cmdletbinding()]
    param
    (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [string]
        $RawResponse,

        [Parameter(Mandatory=$true)]
        [HashTable]
        $ResponseHeaders
    )

    begin
    {
        # Content-Type: multipart/mixed; boundary=batchresponse_c111d175-b384-44e2-a3af-bf24994b7cb7
        $boundry = $ResponseHeaders.'Content-Type' -split "; " | Select-Object -Last 1

        $boundry = $boundry -replace "boundary=", ""
        $batchId = $boundry -replace "batchresponse_", ""

        Write-PSFMessage -Message "Response BatchId: $batchId" 
        Write-PSFMessage -Message "Response Boundry: $boundry"

        $batchResponse = New-Object Tenant.SiteMetadata.BatchResponse
        $batchResponse.BatchId = $batchId

        $batchResponseItem = $null 
    }
    process
    {
        $lines = $RawResponse -split [Environment]::NewLine

        foreach( $line in $lines )
        {
            if( [string]::IsNullOrWhiteSpace($line) )
            {
                continue
            }

            $line = $line.Trim()

            if( $line -eq "--$boundry" -or $line -eq "--$boundry--" )
            {
                # boundary=batchresponse_c111d175-b384-44e2-a3af-bf24994b7cb7

                if( $null -ne $batchResponseItem )
                {
                    $batchResponse.BatchResponseItems.Add( $batchResponseItem )
                }

                $batchResponseItem = New-Object Tenant.SiteMetadata.BatchResponseItem

                continue            
            }

            if( $line -cmatch "^Content-Type\: " -or $line -cmatch "^Content-Transfer-Encoding: ")
            {
                continue            
            }

            if( $line -match "^CONTENT-TYPE: " )
            {
                # CONTENT-TYPE: application/json;odata=minimalmetadata;streaming=true;charset=utf-8
                # CONTENT-TYPE: application/atom+xml;type=entry;charset=utf-8

                $contentType =  $line -split "CONTENT-TYPE: " | Select-Object -Last 1
                $contentType =  $contentType -split ";" | Select-Object -First 1

                $batchResponseItem.ContentType = $contentType
                continue
            }

            if( $line -cmatch "^HTTP/1.1 " )
            {
                # HTTP/1.1 200 OK
                $batchResponseItem.StatusCode = [int]($line -split " " | Select-Object -Skip 1 -First 1)
                continue
            }

            if( $line -cmatch '^{"odata.metadata"' -and $batchResponseItem.ContentType -eq "application/json" -and $batchResponseItem.StatusCode -eq 200 )
            {
                # {"odata.metadata":"https://tenant-admin.sharepoint.com/_api/$metadata#SP.ApiData.SitePropertiess/@Element","odata.
                #$batchResponseItem.Content = $line -split ": " | Select-Object -Last 1
                $batchResponseItem.Content = $line
                continue
            }

            if( $line -cmatch '^<?xml version="1.0' -and  $batchResponseItem.ContentType -eq "application/atom+xml" -and $batchResponseItem.StatusCode -eq 200 )
            {
                #$batchResponseItem.Content = $line -split ": " | Select-Object -Last 1
                $batchResponseItem.Content = $line
                continue
            }

            if( $line -cmatch '"odata.error"' -and $batchResponseItem.StatusCode -ge 500 )
            {
                # {"odata.error":{"code":"-2130575247, Microsoft.SharePoint.SPException","message":{"lang":"en-US","value":"SiteLocked"}}}
                #$batchResponseItem.Content = $line -split ": " | Select-Object -Last 1
                $batchResponseItem.Content = $line
                continue
            }
        }
    }
    end
    {
        Write-PSFMessage -Message "Response Count: $($batchResponse.BatchResponseItems.Count)"
        return $batchResponse
    }
}
