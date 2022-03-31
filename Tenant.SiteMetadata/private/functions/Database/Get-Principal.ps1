function Get-Principal
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [PrincipalType]
        $PrincipalType,

        [Parameter(Mandatory=$true)]
        [ObjectStatus]
        $PrincipalStatus
    )

    begin
    {
        Assert-ServiceConnection -Cmdlet $PSCmdlet
    }
    process
    {
        Get-DataTable -Query "SELECT * FROM dbo.tvf_Principals($($PrincipalType.value__),$($PrincipalStatus.value__))" -As "PsObject"
    }
    end
    {
    }
}