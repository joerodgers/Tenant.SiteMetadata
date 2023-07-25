using namespace Tenant.SiteMetadata

function New-SqlServerDatabaseConnection
{
    [cmdletbinding()]
    param
    (
    )

    begin
    {
        Assert-ServiceConnection -Cmdlet $PSCmdlet

        $connection = $null

        $databaseConnectionInformation = Get-DatabaseConnectionInformation
    }
    process
    {
        try 
        {
            $sqlConnectionStringBuilder = New-Object System.Data.SqlClient.SqlConnectionStringBuilder
            $sqlConnectionStringBuilder.PSBase.InitialCatalog           = $databaseConnectionInformation.DatabaseName
            $sqlConnectionStringBuilder.PSBase.DataSource               = $databaseConnectionInformation.DatabaseServer
            $sqlConnectionStringBuilder.PSBase.IntegratedSecurity       = $true
            $sqlConnectionStringBuilder.PSBase.ConnectTimeout           = $databaseConnectionInformation.ConnectTimeout
            $sqlConnectionStringBuilder.PSBase.Encrypt                  = $databaseConnectionInformation.Encypt
            $sqlConnectionStringBuilder.PSBase.TrustServerCertificate   = $databaseConnectionInformation.Encypt
            $sqlConnectionStringBuilder.PSBase.MultipleActiveResultSets = $false
    
            if( $databaseConnectionInformation -is [Tenant.SiteMetadata.TrustedConnectionDatabaseConnectionInformation] )
            {
                $connection = New-Object System.Data.SqlClient.SqlConnection($sqlConnectionStringBuilder.PSBase.ConnectionString)
            }
            elseif( $databaseConnectionInformation -is [Tenant.SiteMetadata.SqlAuthenticationDatabaseConnectionInformation] )
            {
                $sqlConnectionStringBuilder.PSBase.IntegratedSecurity     = $false
                $sqlConnectionStringBuilder.PSBase.Encrypt                = $true
                $sqlConnectionStringBuilder.PSBase.TrustServerCertificate = $true
        
                $connection = New-Object System.Data.SqlClient.SqlConnection($sqlConnectionStringBuilder.PSBase.ConnectionString, $databaseConnectionInformation.SqlCredential)
            }
            elseif( $databaseConnectionInformation -is [Tenant.SiteMetadata.ServicePrincipalDatabaseConnectionInformation] )
            {
                $sqlConnectionStringBuilder.PSBase.IntegratedSecurity     = $false
                $sqlConnectionStringBuilder.PSBase.Encrypt                = $true
                $sqlConnectionStringBuilder.PSBase.TrustServerCertificate = $true
                $sqlConnectionStringBuilder.PSBase.PersistSecurityInfo    = $true # allows the AccessToken property to the viewed after the connection is made
    
                $connection = New-Object System.Data.SqlClient.SqlConnection($sqlConnectionStringBuilder.PSBase.ConnectionString)
    
                # generate an access token from Azure AD
                $accessToken = New-AzureSqlAccessToken `
                                    -ClientId              $databaseConnectionInformation.ClientId `
                                    -CertificateThumbprint $databaseConnectionInformation.CertificateThumbprint `
                                    -TenantId              $databaseConnectionInformation.TenantId

                $connection.AccessToken = $accessToken
            }
            elseif( $databaseConnectionInformation -is [Tenant.SiteMetadata.ManagedIdentityTenantConnectionInformation] )
            {
                # generate an access token from Azure AD
                $accessToken = New-AzureSqlAccessToken `
                                    -ClientId              $databaseConnectionInformation.ClientId `
                                    -CertificateThumbprint $databaseConnectionInformation.CertificateThumbprint `
                                    -TenantId              $databaseConnectionInformation.TenantId
            }
            Write-PSFMessage -Level Debug -Message "Opening database connection with connection string: $($sqlConnectionStringBuilder.PSBase.ConnectionString)"

            # open the connection
            $connection.Open()
    
            if( -not $connection -or $connection.State -ne "Open" )
            {
                Write-PSFMessage -Level Critical -Message "Failed to open a connection.  Connection string: $($sqlConnectionStringBuilder.PSBase.ConnectionString)"
                throw "Invalid Connection"
            }
    
            return $connection
        }
        catch
        {
            Stop-PSFFunction -Message "Failed to create new database connection." -EnableException $true -ErrorRecord $_
        }
    }
    end
    {
    }
}
