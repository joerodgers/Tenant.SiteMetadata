function Disconnect-Service
{
    [CmdletBinding()]
    param
    (
    )

    begin
    {
    }
    process
    {
        Disconnect-PnPOnline -ErrorAction SilentlyContinue

        Disconnect-MgGraph -ErrorAction SilentlyContinue

        Clear-Configuration
    }
    end
    {
    }
}