
function Invoke-SharePointTenantSiteDetailBatchRequest
{
    begin
    {
        # set a process scoped environment variable to increase the HttpClient timeout from 100 to 500 seconds
        if( -not [Environment]::GetEnvironmentVariable( "SharePointPnPHttpTimeout", [System.EnvironmentVariableTarget]::Process )  )
        {
            [Environment]::SetEnvironmentVariable( "SharePointPnPHttpTimeout", "500", [System.EnvironmentVariableTarget]::Process )
        }
        
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
            Import-Module -Name "PnP.PowerShell" -RequiredVersion "1.12.0" -ErrorAction Stop

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
                if( $attempts -le $MaxRetryAttempts )
                {
                    Start-Sleep -Seconds ($attempts * 60)

                    $attempts++

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

