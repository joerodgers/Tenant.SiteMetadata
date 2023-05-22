using namespace Tenant.SiteMetadata

function New-DatabaseConnectionInformation
{
    [cmdletbinding(DefaultParameterSetName="TrustedConnection")]
    param
    (
        # Name of the SQL database
        [Parameter(Mandatory=$true,ParameterSetName="TrustedConnection")]
        [Parameter(Mandatory=$true,ParameterSetName="ManagedIdentity")]
        [Parameter(Mandatory=$true,ParameterSetName="SqlAuthentication")]
        [Parameter(Mandatory=$true,ParameterSetName="ServicePrincipalCertificate")]
        [string]
        $DatabaseName,

        # Name of the SQL server or SQL and instance name
        [Parameter(Mandatory=$true,ParameterSetName="TrustedConnection")]
        [Parameter(Mandatory=$true,ParameterSetName="ManagedIdentity")]
        [Parameter(Mandatory=$true,ParameterSetName="SqlAuthentication")]
        [Parameter(Mandatory=$true,ParameterSetName="ServicePrincipalCertificate")]
        [string]
        $DatabaseServer,

        # Connection timeout, default is 15
        [Parameter(Mandatory=$false)]
        [int]
        $ConnectTimeout = 15,

        [Parameter(Mandatory=$false)]
        [switch]
        $Encrypt,

        [Parameter(Mandatory=$true,ParameterSetName="ManagedIdentity")]
        [switch]
        $SystemAssignedManagedIdentity,

        [Parameter(Mandatory=$true,ParameterSetName="SqlAuthentication")]
        [string]
        $SqlUserName,

        [Parameter(Mandatory=$true,ParameterSetName="SqlAuthentication")]
        [SecureString]
        $SqlPassword,

        [Parameter(Mandatory=$true,ParameterSetName="ServicePrincipalCertificate")]
        [string]
        $ClientId,

        [Parameter(Mandatory=$true,ParameterSetName="ServicePrincipalCertificate")]
        [string]
        $CertificateThumbprint,

        [Parameter(Mandatory=$true,ParameterSetName="ServicePrincipalCertificate")]
        [string]
        $TenantId
    )

    begin
    {
    }
    process
    {
        if( $PSCmdlet.ParameterSetName -eq "TrustedConnection" )
        {
            return New-Object Tenant.SiteMetadata.TrustedConnectionDatabaseConnectionInformation(
                $DatabaseName, 
                $DatabaseServer,
                $ConnectTimeout, 
                $Encrypt.IsPresent)
        }
        
        if( $PSCmdlet.ParameterSetName -eq "SqlAuthentication" )
        {
            $readOnlyPassword = $SqlPassword.Copy()
            $readOnlyPassword.MakeReadOnly()

            $sqlCredential = New-Object System.Data.SqlClient.SqlCredential( $SqlUserName, $readOnlyPassword ),

            return New-Object Tenant.SiteMetadata.SqlAuthenticationDatabaseConnectionInformation(
                $DatabaseName,
                $DatabaseServer,
                $sqlCredential,
                $ConnectTimeout)
        }
        
        if( $PSCmdlet.ParameterSetName -eq "ServicePrincipalClientSecret" )
        {
            return New-Object Tenant.SiteMetadata.ServicePrincipalDatabaseConnectionInformation(
                $DatabaseName,
                $DatabaseServer,
                $ClientId,
                $TenantId,
                $ClientSecret,
                $ConnectTimeout)
        }

        if( $PSCmdlet.ParameterSetName -eq "ServicePrincipalCertificate" )
        {
            return New-Object Tenant.SiteMetadata.ServicePrincipalDatabaseConnectionInformation(
                $DatabaseName,
                $DatabaseServer,
                $ClientId,
                $TenantId,
                $CertificateThumbprint,
                $ConnectTimeout)
        }

        if( $PSCmdlet.ParameterSetName -eq "ManagedIdentity" )
        {
            return New-Object Tenant.SiteMetadata.ManagedIdentityConnectionInformation(
                $DatabaseName,
                $DatabaseServer,
                $ConnectTimeout,
                $Encrypt.IsPresent)
        }
    }
    end
    {
    }
}

