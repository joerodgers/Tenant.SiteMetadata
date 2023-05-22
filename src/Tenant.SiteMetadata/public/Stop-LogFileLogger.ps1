function Stop-LogFileLogger
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false)]
        [int]
        $Timeout = 600
    )

    begin
    {
    }
    process
    {
        Wait-PSFMessage -Timeout "${Timeout}s" -Terminate # wait up to x seconds to termine the logging runspace

        Set-PSFLoggingProvider -Name 'logfile' -Enabled $false    
    }
    end
    {
    }
}