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
        $headers = 'Timestamp', 'FunctionName', 'Level', 'Line', 'Message'
    }
    process
    {
        Set-PSFLoggingProvider -Name "logfile" -Enabled $true -FilePath $FilePath -Headers $headers
    }
    end
    {
    }
}