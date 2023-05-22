function Get-SharePointTenantDeletedSite
{
    [CmdletBinding()]
    param
    (
    )

    begin
    {
    }
    process
    {
        Assert-SharePointConnection -Cmdlet $PSCmdlet

        # very unlikely anyone would have >100k sites in the recycle bin
        Get-PnPTenantDeletedSite -IncludePersonalSite -Limit 100000 | Select-Object SiteId, 
                                                                                    SiteUrl,                                                                            
                                                                                    @{ Name="DeleteDate";     Expression={ $_.DeletionTime }}, 
                                                                                    @{ Name="IsInRecycleBin"; Expression={ $true }}
    }
    end
    {
    }
}