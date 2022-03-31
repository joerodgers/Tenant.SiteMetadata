function Get-CmdletDeltaToken
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $Cmdlet
    )

    $storedProcedureName            = "proc_GetCmdletDeltaToken"
    $storedProcedureParameterString = $PSBoundParameters | ConvertTo-StoredProcedureParameterString
    $storedProcedureParameterValues = $PSBoundParameters | ConvertTo-StoredProcedureParameterHashTable
    $storedProcedureExectionString  = "EXEC $storedProcedureName $storedProcedureParameterString"

    Get-DataTable `
        -Query      $storedProcedureExectionString `
        -Parameters $storedProcedureParameterValues `
        -As         "SingleValue"
}
