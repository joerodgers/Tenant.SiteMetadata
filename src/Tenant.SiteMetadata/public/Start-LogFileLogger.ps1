function Start-LogFileLogger
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $FilePath
    )

    begin
    {
    }
    process
    {
        Set-PSFLoggingProvider -Name "logfile" -Enabled $true -FilePath $FilePath
    }
    end
    {
    }
}