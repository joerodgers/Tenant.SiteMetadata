function Write-HttpsProxyServerConfigurationWarning
{
    [CmdletBinding()]
    param
    (
    )

    begin
    {
        $envs = [System.Environment]::GetEnvironmentVariables()
    }
    process
    {
        # gentle reminder that to use PowerShell 7.x behind a proxy server, the HTTPS_PROXY env variable must be set.
        if( $env:SkipTenantSiteMetadataProxyCheck -ne "On" -and -not $envs.ContainsKey("HTTPS_PROXY") -or -not $env:HTTPS_PROXY )
        {
            Write-PSFMessage `
                -Message "Environment variable HTTPS_PROXY is not defined or empty.  This could impact internet access on machines that require a proxy egress for HTTPS traffic." `
                -Level Warning
        }
    }
    end
    {
    }
}