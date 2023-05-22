function Import-SharePointTenantSharedObjectBlob
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [Microsoft.Azure.Commands.Management.Storage.Models.PSStorageAccount]
        $StorageAccount,

        [Parameter(Mandatory=$false)]
        [switch]
        $DeleteBlobAfterSuccessfullImport,

        [Parameter(Mandatory=$false)]
        [switch]
        $TruncateTable
    )

    begin
    {
        $container = "spo-sharing"
        
        if( $TruncateTable.IsPresent )
        {
            $storedProcedure = "proc_MergeSharePointSharedObject"
        }
        else
        {
            $storedProcedure = "proc_AddSharePointSharedObject"
        }

        $counter = 0
    }
    process
    {
        $blobs = @(Get-AzStorageBlob -Container $Container -Context $StorageAccount.Context -WarningAction SilentlyContinue -ErrorAction Stop | Where-Object -Property "Name" -notmatch "^metadata")

        Write-Verbose "[$(Get-Date)] - Container: $Container - Discovered $($blobs.Count) blobs"

        if( $blobs.Count -eq 0 )
        {
            Write-Warning "No data blobs found, exiting"
            return
        }

        if( $TruncateTable.IsPresent )
        {
            Write-Verbose "[$(Get-Date)] - Executing 'TRUNCATE TABLE dbo.SharePointSharedObject'"

            Invoke-AzSqlPsNonQuery `
                            -DatabaseName   $DatabaseName `
                            -DatabaseServer $DatabaseServer `
                            -Query          "TRUNCATE TABLE dbo.SharePointSharedObject" `
                            -CommandType    "Text"
        }

        foreach( $blob in $blobs )
        {
            $counter++

            if( $blob.Name -match "^metadata" )
            {
                Write-Verbose "[$(Get-Date)] - Skipping blob: $($blob.Name)"
                continue
            }

            Write-Verbose "[$(Get-Date)] - ($counter/$($blobs.Count)) Container: $Container - Downloading blob content: $($blob.Name)"

            try
            {
                $content = $blob.ICloudBlob.DownloadText()
            }
            catch
            {
                Write-Host "Failed to download blob content. Error: $_"
                continue
            }

            $rows = $content.Split( "`n", [System.StringSplitOptions]::RemoveEmptyEntries)
        
            $json = "[ $($rows -join ",") ]"

            Write-Verbose "[$(Get-Date)] - ($counter/$($blobs.Count)) Container: $Container - Importing $($rows.Count.ToString("N0")) rows"

            try
            {
                Invoke-AzSqlPsNonQuery `
                            -DatabaseName   $DatabaseName `
                            -DatabaseServer $DatabaseServer `
                            -Query          $storedProcedure `
                            -CommandType    "StoredProcedure" `
                            -Parameters     @{ json = $json } `
                            -ErrorAction    Stop `
                            -CommandTimeout 0
        
                if( $DeleteBlobAfterSuccessfullImport.IsPresent )
                {
                    Write-Verbose "[$(Get-Date)] - ($counter/$($blobs.Count)) Container: $Container - Deleting blob content: $($blob.Name)"
                
                    $blob | Remove-AzStorageBlob -Confirm:$false
                }
            }
            catch
            {
               Write-Error "Failed to execute stored procedure: $storedProcedure. Error: $_" 
            }
        }
    }
}
