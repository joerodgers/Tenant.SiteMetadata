function Assert-SharePointConnection
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
        if( $null -ne [PnP.PowerShell.Commands.Base.PnPConnection]::Current )
        {
            return
        }

        $exception   = [System.InvalidOperationException]::new('No connection to SharePoint Online. Use Connect-PnPOnline to establish a connection!')
        $errorRecord = [System.Management.Automation.ErrorRecord]::new($exception, "NotConnected", 'InvalidOperation', $null)
        $Cmdlet.ThrowTerminatingError($errorRecord)
    }
}
