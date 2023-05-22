
function Invoke-SharePointTenantSiteDetailBatchRequest
{
    begin
    {
        Import-Module -Name "PnP.PowerShell" -ErrorAction Stop

        $batchRequest   = $PSItem
        $batchResponses = $using:batchResponses
        $batchErrors    = $using:batchErrors

        $attempts      = 1
        $batchResponse = $null
        $connection    = $null
    }
    process
    {
        # connect to tenant

            try
            {
                $connection = Connect-PnPOnline `
                                        -Url        $batchRequest.TenantAdminUrl `
                                        -ClientId   $batchRequest.TenantConnection.ClientId.ToString() `
                                        -Thumbprint $batchRequest.TenantConnection.CertificateThumbprint `
                                        -Tenant     $batchRequest.TenantConnection.TenantId.ToString() `
                                        -ReturnConnection `
                                        -ErrorAction Stop
            }
            catch
            {
                $batchErrors.TryAdd( $batchRequest.BatchId, "Failed to connect to tenant for batch request. Error: $($_.ToString())" )
                return
            }

        # execute batch request

            while( $attempts -le 10 )
            {
                try 
                {
                    $batchResponse = Invoke-PnPSPRestMethod `
                                                -Method      'Post' `
                                                -Url         '/_api/$batch' `
                                                -ContentType "multipart/mixed; boundary=batch_$($batchRequest.BatchId)" `
                                                -Content     $batchRequest.BatchBody`
                                                -Connection  $connection `
                                                -Raw `
                                                -ErrorAction Stop
                   
                    $null = $batchResponses.TryAdd( $batchRequest.BatchId, $batchResponse )
                    return
                }
                catch
                {
                    if( $attempts -lt $MaxRetryAttempts )
                    {
                        $attempts++

                        $retrySeconds = $attempts * 10

                        $logger.TryAdd( "Batch $($batchRequest.BatchId) failed $attempts times, retrying in $retrySeconds seconds. Error: $($_.ToString())")

                        Start-Sleep -Seconds $retrySeconds

                        continue
                    }

                    $batchErrors.TryAdd( $batchRequest.BatchId, "Failed to process batch $($batchRequest.BatchId). Error: $($_.ToString())" )
                    return
                }
            }
    }
    end
    {
    }
}

