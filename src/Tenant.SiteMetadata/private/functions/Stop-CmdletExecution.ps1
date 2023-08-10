function Stop-CmdletExecution
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [int]
        $Id,

        [Parameter(Mandatory=$false)]
        [int]
        $ErrorCount = $global:Error.Count
    )

    begin
    {
    }
    process
    {
        $storedProcedureName            = "history.proc_StopCmdletExecution"
        $storedProcedureParameterString = $PSBoundParameters | ConvertTo-StoredProcedureParameterString
        $storedProcedureParameterValues = $PSBoundParameters | ConvertTo-StoredProcedureParameterHashTable
        $storedProcedureExectionString  = "EXEC $storedProcedureName $storedProcedureParameterString"
    
        Invoke-NonQuery `
            -Query      $storedProcedureExectionString `
            -Parameters $storedProcedureParameterValues
    }
    end
    {
    }
}
