#requires -modules "Tenant.SiteMetadata"

[System.Net.ServicePointManager]::SecurityProtocol     = [System.Net.SecurityProtocolType]::Tls12
[System.Net.Http.HttpClient]::DefaultProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials

$timestamp = Get-Date -Format FileDateTime

Start-LogFileLogger -FilePath "C:\_temp\logs\database-schema_$timestamp.csv"

$databaseConnectionInfo = New-DatabaseConnectionInformation `
    -DatabaseName          "TenantSiteMetadatav3" `
    -DatabaseServer        "localhost\SQLEXPRESS"

$tenantConnectionInfo = New-TenantConnectionInformation `
    -ClientId              $env:O365_CLIENTID `
    -CertificateThumbprint $env:O365_THUMBPRINT `
    -TenantId              $env:O365_TENANTID `
    -TenantName            $env:O365_TENANT

Connect-Service `
    -DatabaseConnectionInformation $databaseConnectionInfo `
    -TenantConnectionInformation   $tenantConnectionInfo

Update-DatabaseSchema -Verbose

Stop-LogFileLogger