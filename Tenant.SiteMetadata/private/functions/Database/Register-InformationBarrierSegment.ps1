function Register-InformationBarrierSegment
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [Guid]
        $Id,

        [Parameter(Mandatory=$true)]
        [string]
        $InformationBarrierSegment
    )

    $storedProcedureName            = "proc_AddOrUpdateInformationBarrierSegment"
    $storedProcedureParameterString = $PSBoundParameters | ConvertTo-StoredProcedureParameterString
    $storedProcedureParameterValues = $PSBoundParameters | ConvertTo-StoredProcedureParameterHashTable
    $storedProcedureExectionString  = "EXEC $storedProcedureName $storedProcedureParameterString"

    Invoke-NonQuery `
        -Query      $storedProcedureExectionString `
        -Parameters $storedProcedureParameterValues
}
