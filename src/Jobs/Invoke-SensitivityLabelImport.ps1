#requires -modules "Tenant.SiteMetadata"

[System.Net.ServicePointManager]::SecurityProtocol     = [System.Net.SecurityProtocolType]::Tls12
[System.Net.Http.HttpClient]::DefaultProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials

$timestamp = Get-Date -Format FileDateTime

Start-LogFileLogger -FilePath "C:\_temp\logs\sensitivity-label_$timestamp.csv"

$databaseConnectionInfo = New-DatabaseConnectionInformation `
    -DatabaseName          "TenantSiteMetadata.v4" `
    -DatabaseServer        "localhost\SQLEXPRESS"

$tenantConnectionInfo = New-TenantConnectionInformation `
    -ClientId              $env:O365_CLIENTID `
    -CertificateThumbprint $env:O365_THUMBPRINT `
    -TenantId              $env:O365_TENANTID `
    -TenantName            $env:O365_TENANT

Connect-Service `
    -DatabaseConnectionInformation $databaseConnectionInfo `
    -TenantConnectionInformation   $tenantConnectionInfo

Import-SensitivityLabel -Verbose

Stop-LogFileLogger
