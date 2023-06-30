
import-module C:\_projects\Tenant.SiteMetadata.v3\src\Tenant.SiteMetadata\Tenant.SiteMetadata.psd1 -Force -Verbose

$tenantConnectionInformation = new-tenantConnectionInformation -ClientId $env:O365_CLIENTID -CertificateThumbprint $env:O365_THUMBPRINT -TenantName "$($env:O365_TENANT).onmicrosoft.com" -TenantId $env:O365_TENANTID

$databaseConnectionInformation = new-databaseConnectionInformation -DatabaseName "TenantSiteMetadata.v4" -DatabaseServer "localhost\sqlexpress"

Connect-Service -DatabaseConnectionInformation $databaseConnectionInformation -TenantConnectionInformation $tenantConnectionInformation
