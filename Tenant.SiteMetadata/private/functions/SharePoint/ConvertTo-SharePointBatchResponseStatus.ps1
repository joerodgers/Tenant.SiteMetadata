function ConvertTo-SharePointBatchResponseStatus
{
    [cmdletbinding()]
    param
    (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [string]
        $StatusString
    )

    begin
    {
        Write-PSFMessage "Starting" -Level Debug
    }
    process
    {
        if( $StatusString -match "^HTTP/1.1 " )
        {
            # example string:
            # HTTP/1.1 200 OK
            # HTTP/1.1 500 Internal Server Error

            $StatusString = $StatusString -replace "^HTTP/1.1 ", ""

            if( $StatusString.IndexOf(" ") -gt 0 )
            {
                $statusCodeAsInt = $null
                $statusCode = $StatusString.Substring(0, $StatusString.IndexOf(" ") ).Trim()
                $statusText = $StatusString.Substring($StatusString.IndexOf(" ")).Trim()

                if( [int]::TryParse( $statusCode, [ref] $statusCodeAsInt ))
                {
                    $statusCode = $statusCodeAsInt
                }

                return [PSCustomObject] @{
                    StatusCode = $statusCode
                    StatusText = $statusText
                }
            }
        } 
        
        return $null
    }
    end
    {
        Write-PSFMessage "Completed" -Level Debug
    }
}