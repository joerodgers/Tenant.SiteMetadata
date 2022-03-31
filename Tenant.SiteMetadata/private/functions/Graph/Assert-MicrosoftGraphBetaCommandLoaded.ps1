function Assert-MicrosoftGraphBetaCommandLoaded
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $Command,

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.Cmdlet]
        $Cmdlet
    )

    process
    {
        if( Get-Command -Name $Command -ErrorAction SilentlyContinue )
        {
            return
        }

        $exception   = [System.InvalidOperationException]::new("Microsoft Graph beta command not found: $Command")
        $errorRecord = [System.Management.Automation.ErrorRecord]::new($exception, "NotConnected", 'InvalidOperation', $null)
        $Cmdlet.ThrowTerminatingError($errorRecord)
    }
}
