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
        $c = Get-Cmdlet -Cmdlet $Cmdlet
    }
    end
    {
    }
}