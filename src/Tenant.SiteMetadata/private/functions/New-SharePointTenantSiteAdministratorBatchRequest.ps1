using namespace System.Linq
using namespace System.Collections.Generic

function New-SharePointTenantSiteAdministratorBatchRequest
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [System.Collections.Generic.List[Guid]]
        $List
    )
    
    begin
    {
        $connectionInformation = Get-SharePointTenantConnectionInformation
        $tenantAdminUrl        = Get-SharePointTenantAdminUrl
        $models                = New-Object System.Collections.Generic.List[PSCustomObject]
        $orderedDictionary     = New-Object System.Collections.Specialized.OrderedDictionary
    }
    process
    {
        # split the endpoints in the chunks of 10 requests
        $batches = [System.Linq.Enumerable]::ToList( [System.Linq.Enumerable]::Chunk( $List, 14 <# spo has a max batch size of 10 #> ))
        
        Write-PSFMessage -Message "Created $($chunks.Count) chunks" -Level Debug

        $number = 0

        # process each chunk of 100 requests
        foreach( $batch in $batches )
        {
            $orderedDictionary = New-Object System.Collections.Specialized.OrderedDictionary

            $batchId = (New-Guid).ToString()

            Write-PSFMessage -Message "BatchId: $batchId, batch $number, has $($batch.Count) items" -Level Debug

            $list = [System.Linq.Enumerable]::ToList( $batch )

            $list | ForEach-Object { $orderedDictionary.Add( $_.ToString(), $_.ToString() ) }

            # build a HTTP request body for each REST endpoint in the current chunk
            $batchBody = New-SharePointTenantSiteAdministratorBatchRequestBody -Dictionary $orderedDictionary -BatchId $batchId

            # TODO: convert to concrete class
            $batch = [PSCustomObject] @{
                BatchId          = $batchId
                BatchBody        = $batchBody
                SiteIdDictionary = $orderedDictionary
                TenantAdminUrl   = $tenantAdminUrl        # used to connect in runspace
                TenantConnection = $connectionInformation # used to connect in runspace
            }

            # add to the collection of batches to execute
            $models.Add($batch)
        
            $number++
        }
    }
    end
    {
        return ,$models
    }        
}