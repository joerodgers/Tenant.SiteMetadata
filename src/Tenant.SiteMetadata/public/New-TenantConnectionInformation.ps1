using namespace Tenant.SiteMetadata

function New-TenantConnectionInformation
{
<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER ClientId
    Azure Active Directory Application Principal Client/Application Id

    .PARAMETER Thumbprint
    Thumbprint of certificate associated with the Azure Active Directory Application Principal

    .PARAMETER Tenant
    Name of the O365 Tenant

    .EXAMPLE
#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true,ParameterSetName="ManagedIdentity")]
        [switch]
        $SystemAssignedManagedIdentity,

        [Parameter(Mandatory=$true,ParameterSetName="ServicePrincipal")]
        [Guid]
        $ClientId,

        [Parameter(Mandatory=$true,ParameterSetName="ServicePrincipal")]
        [string]
        $CertificateThumbprint,

        [Parameter(Mandatory=$true)]
        [string]
        $TenantName,

        [Parameter(Mandatory=$true)]
        [Guid]
        $TenantId
    )

    begin
    {
        $TenantName = $TenantName -replace "\.onmicrosoft\.com", ""
    }
    process
    {
        if( $PSCmdlet.ParameterSetName -eq "ServicePrincipal" )
        {
            return New-Object Tenant.SiteMetadata.ServicePrincipalTenantConnectionInformation(
                $TenantId,
                $TenantName,
                $ClientId,
                $CertificateThumbprint)
        }
        else
        {
            return New-Object Tenant.SiteMetadata.ManagedIdentityTenantConnectionInformation(
                $TenantId,
                $TenantName)
        }
    }
    end
    {
    }
}
