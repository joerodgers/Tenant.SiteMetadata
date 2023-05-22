function Get-DatabaseSiteCollection
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [int]
        $SiteCollectionType,

        [Parameter(Mandatory=$true)]
        [int]
        $SiteCollectionStatus,

        [Parameter(Mandatory=$true)]
        [int]
        $SiteCollectionLockState
    )

    begin
    {
    }
    process
    {
        Assert-ServiceConnection -Cmdlet $PSCmdlet

        $query = "SELECT * FROM site.tvf_SiteCollection( $SiteCollectionType, $SiteCollectionStatus, $SiteCollectionLockState )" 

        $results = Get-DataTable -Query $query -As "PsObject"
   
        return $results
    }
    end
    {
    }
}