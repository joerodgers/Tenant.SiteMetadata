function Save-SharePointTenantActiveSite
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [System.Collections.Generic.IList[PSCustomObject]]
        $SiteList,

        [Parameter(Mandatory=$false)]
        [int]
        $BatchSize = 5000
    )

    begin
    {
        $startIndex = $counter = 0
    }
    process
    {
        Write-PSFMessage "Saving active $($SiteList.Count) sites" -Level Verbose

        # make sure all sites passed in 
        $sites = [Linq.Enumerable]::ToList($SiteList.Where( { $_.SiteId }))

        if( $sites.Count -ne $SiteList.Count)
        {
            Write-PSFMessage -Message "$($SiteList.Count - $sites.Count) sites are missing a SiteId value and will be skipped" -Level Warning
        }

        $batchCount = [Math]::Ceiling( $sites.Count / $BatchSize )

        while( $startIndex -lt $sites.Count )
        {
            $counter++ 

            $chunkSize = [Math]::Min( $BatchSize, $sites.Count - $startIndex )
        
            $chunk = $sites.GetRange( $startIndex, $chunkSize ).ToArray()

            $startIndex += $chunkSize

            $json = $chunk | ConvertTo-Json -Compress

            Write-PSFMessage -Message "($counter/$batchCount) - Merging $chunkSize batch results"

            try
            {
                Invoke-StoredProcedure `
                    -StoredProcedure "site.proc_AddOrUpdateActiveSite" `
                    -Parameters      @{ json = $json } `
                    -ErrorAction     Stop
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
    }
}