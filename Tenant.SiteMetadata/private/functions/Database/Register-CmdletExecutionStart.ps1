function Register-CmdletExecutionStart
{
    [CmdletBinding()]
    [OutputType([int])]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $Cmdlet
    )

    $storedProcedureName            = "proc_StartCmdletExecution"
    $storedProcedureParameterString = $PSBoundParameters | ConvertTo-StoredProcedureParameterString
    $storedProcedureParameterValues = $PSBoundParameters | ConvertTo-StoredProcedureParameterHashTable
    $storedProcedureExectionString  = "EXEC $storedProcedureName $storedProcedureParameterString"

    Invoke-ScalarQuery `
        -Query      $storedProcedureExectionString `
        -Parameters $storedProcedureParameterValues
}
