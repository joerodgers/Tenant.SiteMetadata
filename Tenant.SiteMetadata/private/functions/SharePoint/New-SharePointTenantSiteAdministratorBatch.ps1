function New-SharePointTenantSiteAdministratorBatch
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [Guid[]]
        $SiteId,

        [Parameter(Mandatory=$false)]
        [int]
        $BatchSize = 100
    )

    begin
    {
        $requests = New-Object System.Collections.Generic.List[PSCustomObject]

        foreach( $id in $SiteId )
        {
            $request =  [PSCustomObject] @{
                            SiteId      = $Id.ToString()
                            EndPointUri = "/_api/Microsoft.Online.SharePoint.TenantAdministration.Tenant/GetSiteSecondaryAdministrators"
                        }

            $requests.Add( $request )
        }

        if( -not $PSBoundParameters.ContainsKey("BatchSize") -and (Get-ConfigurationSetting -ConfigurationSettingName "BatchSize") )
        {
            $BatchSize = Get-ConfigurationSetting -ConfigurationSettingName "BatchSize"
        }
    }
    process
    {
        if( $requests.Count -eq 0 )
        {
            Write-PSFMessage -Message "No sites found to import" -Level Warning
            return
        }

        $chunks = 0 

        do 
        {
            $chunkSize = [System.Math]::Min( $requests.Count, $BatchSize )

            $chunk = $requests.GetRange(0, $chunkSize)

            $batch = New-SharePointBatch -Url $chunk.EndPointUri -Method "GET"

            [PSCustomObject] @{
                SiteIds = $chunk.SiteId
                Batch   = $batch
            }

            $requests.RemoveRange(0, $chunkSize )

            $chunks++
        }             
        while( $requests.Count -gt 0 )

        Write-PSFMessage -Message "Created $($chunks) SharePoint tenant site batches"
    }
    end
    {
    }
}
