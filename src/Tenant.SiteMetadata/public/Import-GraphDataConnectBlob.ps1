function Import-GraphDataConnectBlob
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [Microsoft.Azure.Commands.Management.Storage.Models.PSStorageAccount]
        $StorageAccount,

        [Parameter(Mandatory=$false)]
        [ValidateSet('SharingBlob','GroupBlob')]
        [string]
        $BlobType,

        [Parameter(Mandatory=$false)]
        [switch]
        $DeleteBlobAfterSuccessfullImport
    )
    
    begin
    {
        $cmdletExecutionId = Start-CmdletExecution -Cmdlet $PSCmdlet -ClearErrors

        switch( $BlobType )
        {
            "SharingBlob"
            {
                $storedProcedure = "site.proc_AddSharedObject"
                $container       = "spo-sharing"
            }
            "GroupBlob"
            {
                $storedProcedure = "site.proc_AddSharePointGroup"
                $container       = "spo-groups"
            }
        }

        $counter = 0
    }
    process
    {
        $blobs = @(Get-AzStorageBlob `
                        -Container     $container `
                        -Context       $StorageAccount.Context `
                        -WarningAction SilentlyContinue `
                        -ErrorAction   Stop | Where-Object -Property "Name" -notmatch "^metadata")

        if( $blobs.Count -eq 0 )
        {
            Write-PSFMessage -Message "No data blobs found" -Level Warning
            return
        }

        foreach( $blob in $blobs )
        {
            $counter++

            if( $blob.Name -match "^metadata" )
            {
                Write-PSFMessage -Message "Skipping blob: $($blob.Name)" -Level Verbose
                continue
            }

            Write-PSFMessage -Message "($counter/$($blobs.Count)) Container: $Container - Downloading blob content: $($blob.Name)"

            try
            {
                $content = $blob.ICloudBlob.DownloadText()
            }
            catch
            {
                Write-PSFMessage -Message "Failed to download blob content from blob: $($blob.BlobClient.Uri)" -ErrorRecord $_ -Level Error
                continue
            }

            $rows = $content.Split( "`n", [System.StringSplitOptions]::RemoveEmptyEntries)
        
            $json = "[ $($rows -join ",") ]"

            Write-PSFMessage -Message "($counter/$($blobs.Count)) Container: $Container - Importing $($rows.Count.ToString("N0")) rows" -ErrorRecord $_ -Level Verbose

            try
            {
                Invoke-StoredProcedure `
                            -StoredProcedure $storedProcedure `
                            -Parameters      @{ json = $json; truncate = ($counter -eq 1) } `
                            -CommandTimeout  0 `
                            -ErrorAction     Stop
            }
            catch
            {
                Write-Error "Failed to execute stored procedure: $storedProcedure. Error: $_" 
                continue
            }

            if( $DeleteBlobAfterSuccessfullImport.IsPresent )
            {
                Write-PSFMessage -Message "($counter/$($blobs.Count)) Container: $Container - Deleting blob content: $($blob.Name)" -ErrorRecord $_ -Level Verbose
            
                try
                {
                    $blob | Remove-AzStorageBlob -Confirm:$false -ErrorAction Stop
                }
                catch 
                {
                    Write-PSFMessage -Message "Failed to delete storage blob: $($blob.BlobClient.Uri)" -ErrorRecord $_ -Level Error
                }
            }
        }
    }
    end
    {
        Stop-CmdletExecution -Id $cmdletExecutionId -ErrorCount $Error.Count
    }
}