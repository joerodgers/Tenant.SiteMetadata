function Split-BatchRequest
{
    [cmdletbinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [Tenant.SiteMetadata.IBatchRequest]
        $BatchRequest,

        [Parameter(Mandatory=$true)]
        [int]
        $ChunkSize
    )

    begin
    {
    }
    process
    {   
        $collection = $BatchRequest.BatchRequestItems

        Write-PSFMessage -Message "Splitting $($BatchRequest.BatchRequestItems.Count) batch requests into $([Math]::Ceiling($BatchRequest.BatchRequestItems.Count / $ChunkSize)) chunks."

        do 
        {
            $batch = New-Object Tenant.SiteMetadata.BatchRequest
            $batch.BatchRequestItems.AddRange( $collection.GetRange(0, [System.Math]::Min( $Collection.Count, $ChunkSize) ) )
           ,$batch

           $collection.RemoveRange(0, [System.Math]::Min( $collection.Count, $ChunkSize ) )
        }
        while ( $collection.Count -gt 0 )
    }
    end
    {
    }
}
