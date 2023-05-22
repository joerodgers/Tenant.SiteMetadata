function Assert-ServiceConnection
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.Cmdlet]
        $Cmdlet
    )

    process
    {
        if( -not (Get-DatabaseConnectionInformation) )
        {
            $exception   = [System.InvalidOperationException]::new("Database service connection not configured.  Run Connect-Service before running.")
            $errorRecord = [System.Management.Automation.ErrorRecord]::new($exception, "NotConnected", 'InvalidOperation', $null)
            $Cmdlet.ThrowTerminatingError($errorRecord)
        }

        if( -not (Get-SharePointTenantConnectionInformation) )
        {
            $exception   = [System.InvalidOperationException]::new("Tenant service connection not configured.  Run Connect-Service before running.")
            $errorRecord = [System.Management.Automation.ErrorRecord]::new($exception, "NotConnected", 'InvalidOperation', $null)
            $Cmdlet.ThrowTerminatingError($errorRecord)
        }
    }    
}