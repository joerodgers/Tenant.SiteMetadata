function Register-Principal
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [Guid]
        $ObjectId,

        [Parameter(Mandatory=$false)]
        [string]
        $Identifier,

        [Parameter(Mandatory=$false)]
        [string]
        $DisplayName,

        [Parameter(Mandatory=$false)]
        [PrincipalType]
        $PrincipalType,

        [Parameter(Mandatory=$false)]
        [bool]
        $IsDirectorySynced,

        [Parameter(Mandatory=$false)]
        [Nullable[DateTime]]
        $DeletedDate
    )

    $storedProcedureName            = "proc_AddOrUpdatePrincipal"
    $storedProcedureParameterString = $PSBoundParameters | ConvertTo-StoredProcedureParameterString
    $storedProcedureParameterValues = $PSBoundParameters | ConvertTo-StoredProcedureParameterHashTable
    $storedProcedureExectionString  = "EXEC $storedProcedureName $storedProcedureParameterString"

    Invoke-NonQuery `
        -Query      $storedProcedureExectionString `
        -Parameters $storedProcedureParameterValues
}
