function Get-SiteCollection
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [SiteType]
        $SiteType,

        [Parameter(Mandatory=$true)]
        [ObjectStatus]
        $SiteStatus
    )

    begin
    {
        Assert-ServiceConnection -Cmdlet $PSCmdlet
    }
    process
    {
        Get-DataTable -Query "SELECT * FROM dbo.tvf_Sites($($SiteType.value__),$($SiteStatus.value__))" -As "PsObject"
    }
    end
    {
    }
}