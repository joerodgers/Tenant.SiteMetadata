function Register-SensitivityLabel
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [Guid]
        $Id,

        [Parameter(Mandatory=$true)]
        [string]
        $SensitivityLabel
    )

    $storedProcedureName            = "proc_AddOrUpdateSensitivityLabel"
    $storedProcedureParameterString = $PSBoundParameters | ConvertTo-StoredProcedureParameterString
    $storedProcedureParameterValues = $PSBoundParameters | ConvertTo-StoredProcedureParameterHashTable
    $storedProcedureExectionString  = "EXEC $storedProcedureName $storedProcedureParameterString"

    Invoke-NonQuery `
        -Query      $storedProcedureExectionString `
        -Parameters $storedProcedureParameterValues
}
