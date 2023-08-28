function Save-SharePointTenantSiteAdministrator
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSObject[]]
        $Identity
    )

    begin
    {

    }
    process
    {
        Write-PSFMessage -Message "Committing $($Identity.Count) site administrators"

        try
        {
            $json = $Identity | Select-Object @{ Name="SiteId"; Expression={ $_.SiteId }}, @{ Name="LoginName"; Expression={ $_.loginName }}  | ConvertTo-Json -Compress
        }
        catch
        {
            Write-PSFMessage `
                -Message     "Failed to convert data to JSON: $_" `
                -Level       "Critical" `
                -ErrorRecord $_

            return
        }

        try
        {
            Invoke-StoredProcedure `
                -StoredProcedure "site.proc_AddOrUpdateSiteAdministrator" `
                -Parameters      @{ json = $json } `
                -CommandTimeout  300 `
                -ErrorAction     Stop
        }
        catch
        {
            Write-PSFMessage `
                -Message     "Failed to execute store procedure: proc_AddOrUpdateSiteAdministrator. Parameters: $json" `
                -Level       "Critical" `
                -ErrorRecord $_
        }
    }
    end
    {
    }
}