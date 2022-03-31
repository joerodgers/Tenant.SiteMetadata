function Register-PrincipalManager
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [Guid]
        $PrincipalObjectId,

        [Parameter(Mandatory=$true)]
        [Guid]
        $ManagerObjectId
    )

    $storedProcedureName            = "proc_AddOrUpdatePrincipalManager"
    $storedProcedureParameterString = $PSBoundParameters | ConvertTo-StoredProcedureParameterString
    $storedProcedureParameterValues = $PSBoundParameters | ConvertTo-StoredProcedureParameterHashTable
    $storedProcedureExectionString  = "EXEC $storedProcedureName $storedProcedureParameterString"

    Invoke-NonQuery `
        -Query      $storedProcedureExectionString `
        -Parameters $storedProcedureParameterValues
}
