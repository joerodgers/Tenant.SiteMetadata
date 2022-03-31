function Invoke-BatchRequest
{
    [cmdletbinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [Tenant.SiteMetadata.IBatchRequest]
        $BatchRequest
    )

    begin
    {
        Assert-SharePointConnection -Cmdlet $PSCmdlet

        $accessToken = Get-SharePointTenantAdminAccessToken
        $batchApiUri = Get-SharePointTenantAdminBatchApiUrl
    }
    process
    {
        $body = ConvertTo-BatchRequestPostBody -BatchRequest $BatchRequest

        Write-PSFMessage -Message "Executing batch $($BatchRequest.BatchId.ToString()) with $($BatchRequest.BatchRequestItems.Count) requests"

        try 
        {
            $responseHeaders = $null

            $rawResponse = Invoke-RestMethod `
                            -Method      Post `
                            -Uri         $batchApiUri `
                            -ContentType "multipart/mixed; boundary=batch_$($BatchRequest.BatchId.ToString())" `
                            -Body        $body `
                            -Headers     @{ "Authorization" = "Bearer $accessToken";  "Accept" = "application/json" } `
                            -ResponseHeadersVariable "responseHeaders" `
                            -ErrorAction Stop

            if( Test-Path -Path "C:\_temp" -PathType Container )
            {
                Write-PSFMessage -Message "LOGGING BATCH RESPONSE TO: C:\_temp\batch-data-$($BatchRequest.BatchId.ToString()).txt"
                $rawResponse | Set-Content -Path "C:\_temp\batch-data-$($BatchRequest.BatchId.ToString()).txt"
            }

            $batchResponse = ConvertTo-BatchResponse -RawResponse $rawResponse -ResponseHeaders $responseHeaders

            Write-PSFMessage -Message "Batch $($BatchRequest.BatchId.ToString()) returned $($batchResponse.BatchResponseItems.Count) responses"

            return $batchResponse
        }
        catch 
        {
            Write-PSFMessage -Message "Failed to execute batch $($BatchRequest.BatchId.ToString)." -ErrorRecord $_ -Level Critical
        }
    }
    end
    {
    }
}