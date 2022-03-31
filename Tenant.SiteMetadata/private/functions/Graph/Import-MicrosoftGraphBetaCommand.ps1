function Import-MicrosoftGraphBetaCommand
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $Command,

        [Parameter(Mandatory=$false)]
        [int]
        $MaxAttempts = 10
    )

    begin
    {
        Assert-MicrosoftGraphConnection -Cmdlet $PSCmdlet
    }
    process
    {
        $attempt = 0

        # rare occasions saw switching profiles didn't work the first time so adding some retry logic to make sure it loads the necessary beta cmdlet.
        while( $attempt -le $MaxAttempts -and $null -eq (Get-command -Name $Command -ErrorAction SilentlyContinue) )
        {
            Write-PSFMessage -Message "Loading Microsoft.Graph beta profile to utilize cmdlet: $Command"

            if( $attempt -gt 0) { Start-Sleep -Seconds 1 }

            Select-MgProfile -Name "beta"

            $attempt++
        }
    }
    end
    {
    }
}
