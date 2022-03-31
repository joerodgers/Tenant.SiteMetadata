function Invoke-SharePointBatch
{
    [cmdletbinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [Guid]
        $BatchId,

        [Parameter(Mandatory=$true)]
        [string]
        $Batch
    )

    begin
    {
        Assert-SharePointConnection -Cmdlet $PSCmdlet

        $ctx = Get-PnPContext

        $accessToken = [Microsoft.SharePoint.Client.ClientContextExtensions]::GetAccessToken($ctx)

        $batchApiUri = '{0}/_api/$batch' -f $ctx.Url.TrimEnd("/")
    }
    process
    {
        Write-PSFMessage -Message "Invoking API batch $BatchId against $batchApiUri"

        Invoke-RestMethod `
                    -Method      Post `
                    -Uri         $batchApiUri `
                    -ContentType "multipart/mixed; boundary=batch_$BatchId" `
                    -Body        $Batch `
                    -Headers     @{ "Authorization" = "Bearer $accessToken";  "Accept" = "application/json" }
    }
    end
    {
    }
}
