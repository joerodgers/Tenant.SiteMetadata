#requires -modules "Tenant.SiteMetadata"

[System.Net.ServicePointManager]::SecurityProtocol     = [System.Net.SecurityProtocolType]::Tls12
[System.Net.Http.HttpClient]::DefaultProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials

$timestamp = Get-Date -Format FileDateTime

Start-LogFileLogger -FilePath "C:\_temp\logs\graph-data-connect_$timestamp.csv"


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


$null = Connect-AzAccount `
    -ApplicationId         $env:O365_CLIENTID `
    -CertificateThumbprint $env:O365_THUMBPRINT `
    -Tenant                $env:O365_TENANTID `
    -Subscription          $env:AZ_SUBSCRIPTION_ID `
    -ServicePrincipal

$storageAccount = Get-AzStorageAccount -ResourceGroupName "rg-msdataconnect" -Name "stscytib5s2qno4"

Import-GraphDataConnectBlob -StorageAccount $storageAccount -BlobType GroupBlob -Verbose

Import-GraphDataConnectBlob -StorageAccount $storageAccount -BlobType SharingBlob -Verbose

Stop-LogFileLogger
