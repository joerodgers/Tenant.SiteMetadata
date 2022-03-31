function Start-CmdletExecution
{
    [CmdletBinding()]
    [OutputType([int])]
    param
    (
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.Cmdlet]
        $Cmdlet,

        [Parameter(Mandatory=$false)]
        [switch]
        $ClearErrors
    )

    begin
    {
    }
    process
    {
        if( $ClearErrors.IsPresent )
        {
            $Error.Clear()
        }

        Register-CmdletExecutionStart -Cmdlet $Cmdlet.MyInvocation.MyCommand.Name
    }
    end
    {
    }
}