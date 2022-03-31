function ConvertTo-SharePointBatchResponse
{
    [cmdletbinding()]
    param
    (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [string]
        $Response
    )

    begin
    {
        $obj = [PSCustomObject] @{
            BatchId  = $null
            Status   = $null
            Response = $null
        }
    }
    process
    {
        $lines = $Response -split [Environment]::NewLine

        foreach( $line in $lines )
        {
            if( [string]::IsNullOrWhiteSpace($line) )
            {
                continue
            }

            $line = $line.Trim()

            # the schema that comes back often times has two Id columns, just differing in case, which makes for invalid JSON
            $line = $line -creplace '"ID":', '"ID_":'

            if( $line -match "--batchresponse_(?<BatchId>.*)" )
            {
                $obj.BatchId = $Matches.BatchId
            }
            elseif( $line -match "HTTP/1.1" )
            {
                $obj.Status = $line | ConvertTo-SharePointBatchResponseStatus
            }
            elseif( $obj.Status.StatusCode -eq 200 -and $line -match "^{" )
            {
                $obj.Response = $line | ConvertFrom-Json

                $obj

                $obj = [PSCustomObject] @{
                    BatchId  = $null
                    Status   = $null
                    Response = $null
                }
            }
            elseif( $obj.Status.StatusCode -gt 200 -and $line -match "^{" )
            {
                # tbd if an error message should be handled differently, right now just treat as raw text
                $obj.Response = $line # | ConvertFrom-Json
                
                $obj

                $obj = [PSCustomObject] @{
                    BatchId  = $null
                    Status   = $null
                    Response = $null
                }
            }
            else 
            {
                # Write-PSFMessage -Message "Failed to match line: '$line'"
            }
        }
    }
    end
    {
    }
}