function Assert-MicrosoftGraphConnection
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
        if( [Microsoft.Graph.PowerShell.Authentication.GraphSession]::Exists )
        {
            return
        }

        $exception   = [System.InvalidOperationException]::new('No connection to Microsoft Graph. Use Connect-MgGraph* to establish a connection!')
        $errorRecord = [System.Management.Automation.ErrorRecord]::new($exception, "NotConnected", 'InvalidOperation', $null)
        $Cmdlet.ThrowTerminatingError($errorRecord)
    }
}
