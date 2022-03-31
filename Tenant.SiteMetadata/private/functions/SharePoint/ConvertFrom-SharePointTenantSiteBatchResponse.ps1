
function ConvertFrom-SharePointTenantSiteBatchResponse_OLD
{
    [cmdletbinding()]
    param
    (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [string]
        $Response
    )

    begin
    {
    }
    process
    {
        $lines = $Response -split [Environment]::NewLine
    
        foreach( $line in $lines )
        {
            if( $line -eq '{"odata.error":{"code":"-2130575247, Microsoft.SharePoint.SPException","message":{"lang":"en-US","value":"SiteLocked"}}}' )
            {
                Write-PSFMessage -Message "Unknown locked site found in batch." -Level Warning
                continue
            }

            if( $line -notmatch '^{"odata.metadata"' )
            {
                continue
            }

            $result = $line | ConvertFrom-Json 

            # pull out the SiteId using a regex capture group
            $null = $result.'odata.id' -match "sites\('(?<SiteId>.*)'\)" 
            
            # add a new SiteId property to the object
            $result | Add-Member -MemberType NoteProperty -Name "SiteId" -Value $Matches.SiteId

            # return all the native properties w/o the odata.* properties
            $result | Select-Object * -ExcludeProperty 'odata.id', 'odata.metadata', 'odata.type', 'odata.editlink'
        }
    }
    end
    {
    }
}