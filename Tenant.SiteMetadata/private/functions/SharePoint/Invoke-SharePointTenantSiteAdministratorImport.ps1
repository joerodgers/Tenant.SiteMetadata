function Invoke-SharePointTenantSiteAdministratorImport
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [AllowEmptyCollection()]
        [Guid[]]
        $SiteId
    )

    begin
    {
    }
    process
    {
        $sites = Get-SiteCollection -SiteType ([SiteType]::All) -SiteStatus ([ObjectStatus]::Active)
    
        
    }
    end
    {
    }  
}