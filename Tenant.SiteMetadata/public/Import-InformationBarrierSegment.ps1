function Import-InformationBarrierSegment
{
    [CmdletBinding()]
    param
    (
    )

    begin
    {
        $cmdletExecutionId = Start-CmdletExecution -Cmdlet $PSCmdlet -ClearErrors

        Initialize-SharePointTenantConnection

    }
    process
    {
        Assert-SharePointConnection -Cmdlet $PSCmdlet

        $segments = Get-SharePointTenantInformationBarrierSegment

        foreach( $segment in $segments )
        {
            Write-PSFMessage -Message "Executing Register-InformationBarrierSegment -Id $($segment.ObjectId) -InformationBarrierSegment $($segment.DisplayName)"

            Register-InformationBarrierSegment `
                        -Id                        $segment.ObjectId `
                        -InformationBarrierSegment $segment.DisplayName
        }
    }
    end
    {
        Stop-CmdletExecution -Id $cmdletExecutionId -ErrorCount $Error.Count
    }
}
