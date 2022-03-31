function ConvertTo-BatchRequestPostBody
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
        $builder = New-Object System.Text.StringBuilder
    }
    process
    {
        if( $changeSetBatchItems = $BatchRequest.BatchRequestItems | Where-Object -Property "HttpMethod" -In @( [System.Net.Http.HttpMethod]::Post, [System.Net.Http.HttpMethod]::Patch, [System.Net.Http.HttpMethod]::Delete ))
        {
            $changeSetId = New-Guid

            $builder.AppendLine( "--batch_$($BatchRequest.BatchId.ToString())" )
            $builder.AppendLine( "Content-Type: multipart/mixed; boundary=`"changeset_$($changeSetId)" )
            $builder.AppendLine( "Content-Transfer-Encoding: binary");

            foreach( $changeSetBatchItem in $changeSetBatchItems )
            {
                $null = $builder.AppendLine( "--changeset_$($changeSetId)" )
                $null = $builder.AppendLine( "Content-Type: application/http" )
                $null = $builder.AppendLine( "Content-Transfer-Encoding: binary" )
                $null = $builder.AppendLine()
                $null = $builder.AppendLine( "$($changeSetBatchItem.HttpMethod) $( $changeSetBatchItem.Url) HTTP/1.1" )
                $null = $builder.AppendLine( "Accept: application/json" )

                if( -not [string]::IsNullOrWhiteSpace( $changeSetBatchItem.Content ))
                {
                    $null = $builder.AppendLine( "Content-Type: application/json" )
                    $null = $builder.AppendLine()
                    $null = $builder.AppendLine(  $changeSetBatchItem.Content )
                }
                $null = $builder.AppendLine()
            }

            $null = $builder.AppendLine( "--changeset_$($changeSetId)--" )
        }
 
        if( $batchRequestItems = $BatchRequest.BatchRequestItems | Where-Object -Property "HttpMethod" -In @( [System.Net.Http.HttpMethod]::Get ) )
        {
            foreach( $batchRequestItem in $batchRequestItems )
            {
                $null = $builder.AppendLine( "--batch_$($BatchRequest.BatchId.ToString())" )
                $null = $builder.AppendLine( "Content-Type: application/http"    )
                $null = $builder.AppendLine( "Content-Transfer-Encoding: binary" )
                $null = $builder.AppendLine()
                $null = $builder.AppendLine( "$($batchRequestItem.HttpMethod.ToString()) $($batchRequestItem.Url) HTTP/1.1" )
                $null = $builder.AppendLine( "Accept: application/json" )
                $null = $builder.AppendLine()
            }
        }

        $null = $builder.AppendLine( "--batch_$($BatchRequest.BatchId.ToString())--" )
        $null = $builder.AppendLine()

        Write-PSFMessage -Message "Batch Request $($BatchRequest.BatchId.ToString()) Body: $($builder.ToString())" -Level Debug

        return $builder.ToString()
    }
    end
    {
    }
}