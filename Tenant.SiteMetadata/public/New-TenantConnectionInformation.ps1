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
        [Parameter(Mandatory=$true)]
        [Guid]$ClientId,

        [Parameter(Mandatory=$true)]
        [string]$CertificateThumbprint,

        [Parameter(Mandatory=$true)]
        [string]$TenantName,

        [Parameter(Mandatory=$true)]
        [Guid]$TenantId
    )

    begin
    {
        $TenantName = $TenantName -replace "\.onmicrosoft\.com", ""
    }
    process
    {
        return New-Object Tenant.SiteMetadata.TenantConnectionInformation -Property @{
            ClientId              = $ClientId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            TenantName            = $TenantName
        }
    }
    end
    {
    }
}
