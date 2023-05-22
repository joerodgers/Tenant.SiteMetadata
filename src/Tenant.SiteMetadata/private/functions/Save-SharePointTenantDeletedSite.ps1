function Save-SharePointTenantDeletedSite
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [PSCustomObject[]]
        $Identity
    )

    begin
    {

    }
    process
    {
        $json = $Identity | ConvertTo-Json -Compress

        try
        {
            Invoke-StoredProcedure `
                -StoredProcedure "site.proc_AddOrUpdateDeletedSite" `
                -Parameters      @{ json = $json }`
                -ErrorAction     Stop
        }
        catch
        {
            Write-PSFMessage `
                -Message     "Failed to execute store procedure: proc_AddOrUpdateDeletedSiteCollection. Parameters: $json" `
                -Level       "Critical" `
                -ErrorRecord $_
        }
    }
    end
    {
    }
}