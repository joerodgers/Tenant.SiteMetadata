function New-SharePointTenantSiteAllSitesListChangeToken
{
    [cmdletbinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [DateTime]
        $ChangedSince
    )

    begin
    {
        $listId = Get-SharePointTenantAllSitesListId
    }
    process
    {
        $deltaToken = "1;3;{0};{1};-1" -f $listId, $ChangedSince.ToUniversalTime().Ticks.ToString()

        Write-PSFMessage -Message "Generated Delta Token: $deltaToken"

        return [System.Convert]::ToBase64String( [System.Text.Encoding]::UTF8.GetBytes($deltaToken) )
    }
    end
    {
    }    
}