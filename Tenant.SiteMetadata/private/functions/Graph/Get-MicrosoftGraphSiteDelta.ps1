function Get-MicrosoftGraphSiteDelta
{
    [CmdletBinding()]
    param
    (
    )

    begin
    {
        $defaultUrl = "/beta/sites/delta"

    }
    process
    {
        Assert-MicrosoftGraphConnection -Cmdlet $PSCmdlet

        do
        {
            $response = Invoke-MgGraphRequest `
                            -Uri    $url `
                            -Method GET

            $response.value

            #$values += $response.value

            $url = $response.'@odata.nextLink'
        }
        while( $response.'@odata.nextLink' )


    }
    end
    {
    }
}