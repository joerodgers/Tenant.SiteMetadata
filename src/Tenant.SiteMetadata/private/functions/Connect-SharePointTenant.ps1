function Connect-SharePointTenant
{
    [CmdletBinding()]
    param 
    (
    )
    
    begin
    {
        Assert-ServiceConnection -Cmdlet $PSCmdlet

        $tenantConnectionInformation = Get-SharePointTenantConnectionInformation
    }
    process
    {
        if( [PnP.PowerShell.Commands.Base.PnPConnection]::Current -and 
           ([PnP.PowerShell.Commands.Base.PnPConnection]::Current.ClientId -ne $TenantConnectionInformation.ClientId.ToString() -or 
            [PnP.PowerShell.Commands.Base.pnpconnection]::Current.ConnectionType -ne [PnP.PowerShell.Commands.Enums.ConnectionType]::TenantAdmin))
        {
            Disconnect-PnPOnline -ErrorAction SilentlyContinue
        }

        if( $tenantConnectionInformation -is [Tenant.SiteMetadata.ManagedIdentityTenantConnectionInformation] )
        {
            try 
            {
                Write-PSFMessage -Message "Executing Connect-PnPOnline with system assigned managed identity" -Level Verbose

                $tenantAdminUrl = Get-SharePointTenantAdminUrl -ErrorAction Stop

                # requires pnp.powershell v2.1.0+
                Connect-PnPOnline -Url $tenantAdminUrl -ManagedIdentity -ErrorAction Stop
            }
            catch
            {
                Write-PSFMessage -Message "Failed to connect to SharePoint tenant admin at $tenantAdminUrl" -EnableException $true -ErrorRecord $_ -Level Critical
            }
        }
        else
        {
            try 
            {
                Write-PSFMessage -Message "Executing Connect-PnPOnline with configuration: $($tenantConnectionInformation.ToString())" -Level Verbose

                $tenantAdminUrl = Get-SharePointTenantAdminUrl
        
                Connect-PnPOnline `
                            -Url        $tenantAdminUrl `
                            -ClientId   $tenantConnectionInformation.ClientId.ToString() `
                            -Thumbprint $tenantConnectionInformation.CertificateThumbprint `
                            -Tenant     $tenantConnectionInformation.TenantId.ToString() `
                            -ErrorAction Stop
            }
            catch
            {
                Write-PSFMessage -Message "Failed to connect to SharePoint tenant admin at $tenantAdminUrl" -EnableException $true -ErrorRecord $_ -Level Critical
            }
        }
    }
    end
    {
    }
}