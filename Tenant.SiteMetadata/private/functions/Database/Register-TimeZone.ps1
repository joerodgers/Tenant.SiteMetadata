function Register-TimeZone
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [int]
        $Id,

        [Parameter(Mandatory=$true)]
        [ValidateLength(1, 100)]
        [string]
        $Identifier,

        [Parameter(Mandatory=$true)]
        [ValidateLength(1, 100)]
        [string]
        $Description
    )

    $storedProcedureName            = "proc_AddOrUpdateTimeZone"
    $storedProcedureParameterString = $PSBoundParameters | ConvertTo-StoredProcedureParameterString
    $storedProcedureParameterValues = $PSBoundParameters | ConvertTo-StoredProcedureParameterHashTable
    $storedProcedureExectionString  = "EXEC $storedProcedureName $storedProcedureParameterString"

    Invoke-NonQuery `
        -Query      $storedProcedureExectionString `
        -Parameters $storedProcedureParameterValues
}
