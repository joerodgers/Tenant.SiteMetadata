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
        Unregister-SharePointTenantConnectionInformation

        Unregister-DatabaseConnectionInformation

        try 
        {
            $null = Disconnect-PnPOnline -ErrorAction SilentlyContinue
        }
        catch
        {
        }

        try 
        {
            $null = Disconnect-MgGraph -ErrorAction SilentlyContinue
        }
        catch
        {
        }
    }
    end
    {
    }
}