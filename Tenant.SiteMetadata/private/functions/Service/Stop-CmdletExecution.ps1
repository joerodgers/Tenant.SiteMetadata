function Stop-CmdletExecution
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

    begin
    {
    }
    process
    {
        Register-CmdletExecutionStop `
                    -Id $Id `
                    -ErrorCount $ErrorCount

    }
    end
    {
    }
}
