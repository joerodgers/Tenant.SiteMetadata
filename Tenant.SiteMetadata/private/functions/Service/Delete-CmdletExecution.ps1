function Start-CmdletExecution
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.Cmdlet]
        $Cmdlet
    )

    begin
    {
    }
    process
    {
        $commandlet = Get-Cmdlet -Cmdlet $Cmdlet

        return Invoke-ScalarQuery `
                    -Query      "EXEC proc_StartCmdletExecution @CmdletId = @CmdletId" `
                    -Parameters @{ CmdletId = $commandlet.Id }
    }
    end
    {
    }
}