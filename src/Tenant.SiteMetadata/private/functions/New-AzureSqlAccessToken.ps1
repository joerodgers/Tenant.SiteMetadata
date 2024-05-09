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
            if( -not ($confidentialClientApplication = Get-ConfidentialClientApplication) )
            {
                $confidentialClientApplication = [Microsoft.Identity.Client.ConfidentialClientApplicationBuilder]::Create($ClientId).WithCertificate($certificate).WithTenantId($TenantId).Build()
               
                Register-ConfidentialClientApplication -ConfidentialClientApplication $confidentialClientApplication
            }

            $builder = $confidentialClientApplication.AcquireTokenForClient( $scopes )

            $authenticationResult = $builder.ExecuteAsync().GetAwaiter().GetResult()

            $authenticationResult.AccessToken
        }
    }
}

