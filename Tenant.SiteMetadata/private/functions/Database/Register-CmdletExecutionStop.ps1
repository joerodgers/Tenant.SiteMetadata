function Register-CmdletExecutionStop
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [int]
        $Id,

        [Parameter(Mandatory=$false)]
        [int]
        $ErrorCount = $Error.Count
    )

    $storedProcedureName            = "proc_StopCmdletExecution"
    $storedProcedureParameterString = $PSBoundParameters | ConvertTo-StoredProcedureParameterString
    $storedProcedureParameterValues = $PSBoundParameters | ConvertTo-StoredProcedureParameterHashTable
    $storedProcedureExectionString  = "EXEC $storedProcedureName $storedProcedureParameterString"

    Invoke-NonQuery `
        -Query      $storedProcedureExectionString `
        -Parameters $storedProcedureParameterValues
}
