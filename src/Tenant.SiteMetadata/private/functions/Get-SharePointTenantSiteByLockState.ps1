function Get-SharePointTenantSiteByLockState
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
        try 
        {
            Write-PSFMessage -Message "Querying tenant for sites with LockState = $LockState" -Level Verbose

            $noAccessSites = Get-PnPTenantSite -Filter "LOCKSTATE -eq '$LockState'" -IncludeOneDriveSites
            
            Write-PSFMessage -Message "Tenant returned $($noAccessSites.Count) sites with a LockState = $LockState" -Level Verbose

            $dictionary1 = [System.Collections.Generic.Dictionary[string,psobject]]::new()
            $dictionary2 = [System.Collections.Generic.Dictionary[string,psobject]]::new()

            # pulling the entire store is potentially excessive, but since we can pull in chunks of 5k, it's often more efficient 
            # to pull the entire list and filter locally than make an HTTP request for each site set to NoAccess
            #   -  845 sites in ~.5 seconds
            #   - 140k sites in ~48 seconds
            $aggregatedStoreSites = Get-TenantSiteCollectionFromAggregatedStore -AggregatedStore AggregatedStore -PageSize 5000

            # convert our two lists of sites to dictionaries so we can quickly pull out the rows of sites set to $LockState.  The 
            # $aggregatedStoreSites datasets can be large (200K+) rows and $noAccessSites I've seen be has high has 20k
            $noAccessSites        | ForEach-Object { $dictionary1.Add( $_.Url,     $_ ) } 
            $aggregatedStoreSites | ForEach-Object { $dictionary2.Add( $_.SiteUrl, $_ ) }

            # pull out all the NoAcesss Urls from the $aggregatedStoreSites dictionary and return it
            return $dictionary2.GetEnumerator().Where( { $dictionary1.ContainsKey( $_.Key )} ).Value | Select-Object *, @{ Name="LockState"; Expression={ $LockState }}
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
