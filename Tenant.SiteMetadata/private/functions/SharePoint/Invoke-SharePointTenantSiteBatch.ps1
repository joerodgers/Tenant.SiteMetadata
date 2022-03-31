function Invoke-SharePointTenantSiteBatch
{
    [cmdletbinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [Guid]
        $BatchId,

        [Parameter(Mandatory=$true)]
        [string]
        $Batch
    )

    begin
    {
        $batchResponse = $null
    }
    process
    {
        Write-PSFMessage -Message "Executing Invoke-SharePointBatch -BatchId $BatchId"

        # this just returns raw text response data, need to convert to objects for later processing
        $rawResponse = Invoke-SharePointBatch -BatchId $BatchId -Batch $Batch 
        
        # convert the response to generic response objects
        $batchResponses = $rawResponse | ConvertTo-SharePointBatchResponse

        # let's enhance each response object by adding a SiteId so we can later match by SiteId
        foreach( $batchResponse in $batchResponses )
        {
            if( $batchResponse.Status.StatusCode -eq 200 )
            {
                $site = $batchResponse.Response

                # pull out the SiteId using a regex capture group
                $null = $site.'odata.id' -match "sites\('(?<SiteId>.*)'\)" 

                # add a new SiteId property to the object
                $site | Add-Member -MemberType NoteProperty -Name "SiteId" -Value ([Guid]::Parse($Matches.SiteId))

                # return all the native properties w/o the odata.* properties
                $site | Select-Object * -ExcludeProperty 'odata.id', 'odata.metadata', 'odata.type', 'odata.editlink'
            }
            else
            {
                Write-PSFMessage -Message "Tenant site batch response contained a failed response: StatusCode:$($batchResponse.Status.StatusCode), StatusText:$($batchResponse.Status.StatusText), Response: $($batchResponse.Response)" -Level Error   
            }
        }
    }
    end
    {
    }
}
