function Get-SharePointTenantSiteSiteIdByTemplate
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [ValidateSet( "APPCATALOG#0", "BICenterSite#0", "BLANKINTERNET#0", "EDISC#0", "EHS#1", "GROUP#0", "POINTPUBLISHINGHUB#0", "POINTPUBLISHINGPERSONAL#0", "POINTPUBLISHINGTOPIC#0", "RedirectSite#0", "SITEPAGEPUBLISHING#0", "SPSMSITEHOST#0", "SRCHCEN#0", "STS#-1", "STS#0", "STS#3", "TEAMCHANNEL#0", "TEAMCHANNEL#1", "PROJECTSITE#0", "PWA#0", IgnoreCase = $false)]
        [string]
        $Template
    )

    begin
    {
    }
    process
    {
        Assert-SharePointConnection -Cmdlet $PSCmdlet

        try 
        {
            Write-PSFMessage -Message "Executing: Get-PnPTenantSite -Template $Template"
            
            $tenantsites = Get-PnPTenantSite -Template $Template -Filter "LockState -ne 'NoAccess'" -IncludeOneDriveSites -ErrorAction Stop

            Write-PSFMessage -Message "Executed: Get-PnPTenantSite -Template $Template, Result Count: $($tenantsites.Count)"

            foreach( $tenantsite in $tenantsites )
            {
                Get-SharePointTenantSiteIdByUrl -SiteUrl $tenantsite.Url    
            }
        }
        catch
        {
            Write-PSFMessage -Message "Failed to retrieve tenant sites by template type: $Template" -EnableException $true -ErrorRecord $_ -Level Critical
        }
    }
    end
    {
    }
}
