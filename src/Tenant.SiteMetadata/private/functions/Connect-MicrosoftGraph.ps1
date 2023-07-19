function Connect-MicrosoftGraph
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
        if( [Microsoft.Graph.PowerShell.Authentication.GraphSession]::Instance.AuthContext -and 
            [Microsoft.Graph.PowerShell.Authentication.GraphSession]::Instance.AuthContext.ClientId -eq $tenantConnectionInformation.ClientId.ToString() )
        {
            return
        }

        if( $null -ne [Microsoft.Graph.PowerShell.Authentication.GraphSession]::Instance.AuthContext -and 
            [Microsoft.Graph.PowerShell.Authentication.GraphSession]::Instance.AuthContext.ClientId -ne $tenantConnectionInformation.ClientId.ToString() )
        {
            Disconnect-MgGraph
        }

        if( $tenantConnectionInformation -is [Tenant.SiteMetadata.ManagedIdentityConnectionInformation] )
        {
            try 
            {
                Write-PSFMessage -Message "Executing Connect-MgGraph with System Assignged Managed Identity" 
        
                # requires Microsoft.Graph v2.0.0+
                $null = Connect-MgGraph -Identity -ErrorAction Stop
            }
            catch
            {
                Write-PSFMessage -Message "Failed to connect to Microsoft.Graph" -EnableException $true -ErrorRecord $_ -Level Critical
            }    
        }
        else
        {
            try 
            {
                Write-PSFMessage -Message "Executing Connect-MgGraph with configuration: $($tenantConnectionInformation.ToString())" 
        
                $null = Connect-MgGraph `
                            -ClientId              $tenantConnectionInformation.ClientId.ToString() `
                            -CertificateThumbprint $tenantConnectionInformation.CertificateThumbprint `
                            -TenantId              $tenantConnectionInformation.TenantId.ToString() `
                            -ForceRefresh `
                            -ErrorAction Stop
            }
            catch
            {
                Write-PSFMessage -Message "Failed to connect to Microsoft.Graph" -EnableException $true -ErrorRecord $_ -Level Critical
            }    
        }
    }
    end
    {
    }
}