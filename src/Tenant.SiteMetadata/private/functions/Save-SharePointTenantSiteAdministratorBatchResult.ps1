function Save-SharePointTenantSiteAdministratorBatchResult
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [System.Collections.Generic.List[PSCustomObject]]
        $BatchRequest,

        [Parameter(Mandatory=$true)]
        [System.Collections.Concurrent.ConcurrentDictionary[string,psobject]]
        $BatchResponse,

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSTasks.PSTaskJob]
        $BatchExecutionJob
    )
    
    begin
    {
        $total = 0
    }
    process
    {
        while( $BatchExecutionJob.State -eq 'Running' -or -not $BatchResponse.IsEmpty )
        {
            if( $BatchResponse.IsEmpty )
            {
                Write-PSFMessage -Message "Waiting for batch results" -Level Verbose
                Start-Sleep -Seconds 1
                continue
            }

            while( -not $BatchResponse.IsEmpty )
            {
                $rawResponse = $null

                $batchId = $BatchResponse.Keys | Select-Object -First 1

                Write-PSFMessage -Message "Removing batch '$batchId'" -Level Verbose

                if( -not $BatchResponse.TryRemove( $batchId, [ref] $rawResponse ) )
                {
                    Write-PSFMessage -Message "Failed to remove $batchId from batch responses" -Level Error
                    continue
                }

                $request = $BatchRequest.Where( { $_.BatchId -eq $batchId } )

                # convert the raw batch response text into a PSObject List
                $siteAdministrators = Convert-SharePointTenantSiteAdministratorBatchResponse -BatchResponse $rawResponse -Dictionary $request.SiteIdDictionary

                # remove "nt service\\sptimerv4" and "nt service\\spsearch"
                $siteAdministrators = $siteAdministrators | Where-Object -Property "LoginName" -NotIn @( "nt service\\sptimerv4", "nt service\\spsearch" )

                # parse each administrator returned and clean up the entries so they can be easily mapped to uses/groups in the database
                $administrators = foreach( $siteAdministrator in $siteAdministrators )
                {
                    # skip all Windows claims identities for backend service accounts; sptimerv4, spsearch, etc.
                    if( $siteAdministrator.loginName -match "^i:0#\.w" )
                    {
                        Write-PSFMessage -Message "Skipping backend service account '$($siteAdministrator.loginName) in batch $batchId'" -Level Verbose
                        continue
                    }

                    #remove claims prefix: i:0#.f|membership| and c:0t.c|tenant| and c:0o.c|federateddirectoryclaimprovider|
                    if( $siteAdministrator.loginName.LastIndexOf("|") -gt 0 )
                    {
                        $siteAdministrator.loginName = $siteAdministrator.loginName.Substring( $siteAdministrator.loginName.LastIndexOf("|") + 1 )
                    }
                    
                    # if we find EEEU, we want to log it, but need to force to a hard coded ObjectId in table.principal.Group
                    if( $siteAdministrator.loginName -match '^spo-grid-all-users' )
                    {
                        # keep guid in sync with table.principal.Group.sql
                        $siteAdministrator.loginName = "00000000-0000-0000-0000-000000000EEE"
                    }
                    # if we find Everyone, we want to log it, but need to force to a hard coded ObjectId in table.principal.Group
                    elseif( $siteAdministrator.loginName -eq "true" )
                    {
                        # keep guid in sync with table.principal.Group.sql
                        $siteAdministrator.loginName = "00000000-0000-0000-0000-00000000000E"
                    }
                    # remove the _o suffix for unified group owners
                    elseif( $siteAdministrator.loginName -match '_o$' -and $siteAdministrator.loginName.Length -eq 38 )
                    {
                        $siteAdministrator.loginName = $siteAdministrator.loginName.Substring( 0, 36 )
                    }

                    $siteAdministrator
                } 

                $total += $administrators.Count

                # merge the site data in the batch response
                Save-SharePointTenantSiteAdministrator -Identity $administrators
            }
        }
    }
}