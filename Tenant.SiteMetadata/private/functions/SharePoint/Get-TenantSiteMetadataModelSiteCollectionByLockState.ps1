function Get-TenantSiteMetadataModelSiteCollectionByLockState
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [ValidateSet( "Unlock", "NoAccess", "ReadOnly" )]
        [string]
        $LockState
    )

    begin
    {
    }
    process
    {
        Assert-SharePointConnection -Cmdlet $PSCmdlet

        try 
        {
            Write-PSFMessage -Message "Executing: Get-PnPTenantSite -Filter `"LOCKSTATE -eq '$LockState'`""

            $tenantsites = Get-PnPTenantSite -Filter "LOCKSTATE -eq '$LockState'" -IncludeOneDriveSites

            Write-PSFMessage -Message "Executed: Get-PnPTenantSite -Filter `"LOCKSTATE -eq '$LockState'`", ResultCount: $($tenantsites.Count)"

            foreach( $tenantsite in $tenantsites )
            {
                if( $LockState -eq "NoAccess")
                {
                    $siteId = Get-SharePointTenantSiteIdByUrl -SiteUrl $tenantsite.Url -UseAllSitesAggregatedStore | Select-Object -ExpandProperty SiteId 
                }
                else 
                {
                    $siteId = Get-SharePointTenantSiteIdByUrl -SiteUrl $tenantsite.Url | Select-Object -ExpandProperty SiteId
                }

                $model = (ConvertTo-TenantSiteMetadataModelSiteCollection -SiteId $siteId -PnPTenantSite $tenantsite)

                ,$model
            }
        }
        catch
        {
            Write-PSFMessage -Message "Failed to retrieve tenant sites by lock state: $LockState" -EnableException $true -ErrorRecord $_ -Level Critical
        }
    }
    end
    {
    }
}
