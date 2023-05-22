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

        $storedProcedureName            = "history.proc_StartCmdletExecution"
        $storedProcedureParameterString = "@Cmdlet = @Cmdlet"
        $storedProcedureParameterValues = @{ Cmdlet = $Cmdlet.MyInvocation.MyCommand.Name }
        $storedProcedureExectionString  = "EXEC $storedProcedureName $storedProcedureParameterString"
    
        Invoke-ScalarQuery `
            -Query      $storedProcedureExectionString `
            -Parameters $storedProcedureParameterValues
    }
    end
    {
    }
}