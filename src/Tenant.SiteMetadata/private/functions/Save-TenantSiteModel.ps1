function Save-TenantSiteModel
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [System.Collections.Generic.List[TenantSiteModel]]
        $TenantSiteModelList,

        [Parameter(Mandatory=$false)]
        [ValidateRange(1,5000)]
        [int]
        $BatchSize = 1000
    )

    begin
    {
        Write-PSFMessage "Starting" -Level Verbose

        $predicate = { param ($model) return $null -ne $model.SiteId } -as [System.Func[TenantSiteModel, bool]]

        $counter = 0
    }
    process
    {
        # make sure all models passed in have a SiteId value
        $models = [System.Linq.Enumerable]::ToList( [System.Linq.Enumerable]::Where( $TenantSiteModelList, $predicate ) )
       
        Write-PSFMessage "Removed $($TenantSiteModelList.Count - $models.Count) of $($TenantSiteModelList.Count) rows due to missing SiteId"

        # break the collection into chunks of 1,000 sites
        $batches =  [System.Linq.Enumerable]::ToList( [System.Linq.Enumerable]::Chunk( $models, $BatchSize ) )
        
        # process each batch
        foreach( $batch in $batches )
        {
            $counter++

            $rowCount = [Math]::Min( $batch.Count, $BatchSize )  

            try
            {
                # convert TenantSiteModel list to JSON string 
                $json = $batch | ConvertTo-Json -Depth 1 -Compress -ErrorAction Stop

                Write-PSFMessage -Message "($counter/$($batches.Count)) - Merging batch of $rowCount rows"

                Invoke-StoredProcedure `
                        -StoredProcedure "site.proc_AddOrUpdateSiteCollection" `
                        -Parameters      @{ json = $json } `
                        -ErrorAction     Stop

                Write-PSFMessage -Message "($counter/$($batches.Count)) - Merged batch of $rowCount rows"
            }
            catch
            {
                Write-PSFMessage `
                        -Message     "Failed to execute store procedure: proc_AddOrUpdateActiveSite. Parameters: $json" `
                        -Level       "Critical" `
                        -ErrorRecord $_
            }
        }
    }
    end
    {
        Write-PSFMessage "Completed" -Level Verbose
    }
}