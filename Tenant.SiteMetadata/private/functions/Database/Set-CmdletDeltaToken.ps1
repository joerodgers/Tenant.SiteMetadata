function Set-CmdletDeltaToken
{
    [CmdletBinding()]
    [OutputType([int])]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $Cmdlet,

        [Parameter(Mandatory=$true)]
        [string]
        $DeltaToken
    )

    Write-PSFMessage -Message "Saving delta token: $($DeltaToken) for $($Cmdlet)"

    $storedProcedureName            = "proc_AddOrUpdateCmdletDeltaToken"
    $storedProcedureParameterString = $PSBoundParameters | ConvertTo-StoredProcedureParameterString
    $storedProcedureParameterValues = $PSBoundParameters | ConvertTo-StoredProcedureParameterHashTable
    $storedProcedureExectionString  = "EXEC $storedProcedureName $storedProcedureParameterString"

    Invoke-NonQuery `
        -Query      $storedProcedureExectionString `
        -Parameters $storedProcedureParameterValues
}
