using namespace System.Collections.Generic
using namespace Microsoft.Identity.Web

function New-AzureSqlAccessToken
{
    [cmdletbinding()]
    param
    (
        # Azure AD App Principal Application/Client Id
        [Parameter(Mandatory=$true)]
        [string]
        $ClientId,

        # Azure AD App Principal Application/Client Secret
        [Parameter(Mandatory=$true)]
        [string]
        $CertificateThumbprint,

        # Azure AD TenantId
        [Parameter(Mandatory=$true)]
        [string]
        $TenantId
    )

    begin
    {
        $certificate = Get-ChildItem -Path Cert:\LocalMachine\My\$CertificateThumbprint

        [string[]]$scopes = "https://database.windows.net/.default"
    }
    process
    {
        if( $false )
        {
            $authenticationManager = [PnP.Framework.AuthenticationManager]::CreateWithCertificate( $ClientId, $certificate, $TenantId )
            
            $authenticationManager.GetAccessTokenAsync( @(,"https://database.windows.net/") ).GetAwaiter().GetResult()
        }
        else 
        {
            # this version leverages an in memory token cache.  cache automatically handles token expiration

            if( -not ($confidentialClientApplication = Get-ConfidentialClientApplication) )
            {
                $confidentialClientApplication = [Microsoft.Identity.Client.ConfidentialClientApplicationBuilder]::Create($ClientId).WithCertificate($certificate).WithTenantId($TenantId).Build()

                # if this ever gets removed, it's safe to remove the following from the RequiredAssembly section the .psd1 
                #   - Microsoft.Identity.*.dll 
                #   - Microsoft.Extensions.*.dll
                #   - Microsoft.AspNetCore.DataProtection.Abstractions.dll
                $confidentialClientApplication = [Microsoft.Identity.Web.TokenCacheExtensions]::AddInMemoryTokenCache($confidentialClientApplication)

                Register-ConfidentialClientApplication -ConfidentialClientApplication $confidentialClientApplication
            }

            $builder = $confidentialClientApplication.AcquireTokenForClient( $scopes )

            $authenticationResult = $builder.ExecuteAsync().GetAwaiter().GetResult()

            $authenticationResult.AccessToken
        }
    }
}

