﻿function Initialize-SharePointTenantConnection
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
        if( [PnP.PowerShell.Commands.Base.PnPConnection]::Current -and ([PnP.PowerShell.Commands.Base.PnPConnection]::Current.ClientId -ne $TenantConnectionInformation.ClientId.ToString() -or [PnP.PowerShell.Commands.Base.pnpconnection]::Current.ConnectionType -ne [PnP.PowerShell.Commands.Enums.ConnectionType]::TenantAdmin))
        {
            Disconnect-PnPOnline -ErrorAction SilentlyContinue
        }

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
    end
    {
    }
}