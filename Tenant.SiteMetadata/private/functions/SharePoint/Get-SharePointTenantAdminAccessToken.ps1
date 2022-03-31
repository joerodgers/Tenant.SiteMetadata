function Get-SharePointTenantAdminAccessToken
{
    begin
    {
    }
    process
    {
        Assert-SharePointConnection -Cmdlet $PSCmdlet

        $context = Get-PnPContext

        return [Microsoft.SharePoint.Client.ClientContextExtensions]::GetAccessToken($context)
    }
    end
    {
    }    
}