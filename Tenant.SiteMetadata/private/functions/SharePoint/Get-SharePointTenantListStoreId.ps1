function Get-SharePointTenantAllSitesListId
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

        if( $configurationSetting = Get-ConfigurationSetting -ConfigurationSettingName $PSCmdlet.MyInvocation.MyCommand.Name )
        {
            return $configurationSetting
        }

        try 
        {   
            $list = Get-PnPList -Identity "DO_NOT_DELETE_SPLIST_TENANTADMIN_ALL_SITES_AGGREGATED_SITECOLLECTIONS" 

            Set-ConfigurationSetting -ConfigurationSettingName $PSCmdlet.MyInvocation.MyCommand.Name -ConfigurationSettingValue $list.Id.ToString()

            return $list.Id
        }
        catch
        {
            Write-PSFMessage -Message "Failed to return list.Id for list DO_NOT_DELETE_SPLIST_TENANTADMIN_ALL_SITES_AGGREGATED_SITECOLLECTIONS" -EnableException $true -ErrorRecord $_ -Level Critical
        }
    }
    end
    {
    }
}
