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
            $global:Error.Clear()
        }

        $storedProcedureName            = "history.proc_StartCmdletExecution"
        $storedProcedureParameterString = "@Cmdlet = @Cmdlet, @Host = @Host"
        $storedProcedureParameterValues = @{ Cmdlet = $Cmdlet.MyInvocation.MyCommand.Name; Host = $env:COMPUTERNAME }
        $storedProcedureExectionString  = "EXEC $storedProcedureName $storedProcedureParameterString"
    
        Invoke-ScalarQuery `
            -Query      $storedProcedureExectionString `
            -Parameters $storedProcedureParameterValues
    }
    end
    {
    }
}