function New-SharePointTenantSiteDetailBatchRequestBody
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string[]]
        $Url,

        [Parameter(Mandatory=$true)]
        [Guid]
        $BatchId
    )
    
    begin
    {
        $builder = New-Object System.Text.StringBuilder
    }
    process
    {
        foreach( $u in $Url )
        {
            $null = $builder.AppendLine( "--batch_$BatchId" )
            $null = $builder.AppendLine( "Content-Type: application/http"    )
            $null = $builder.AppendLine( "Content-Transfer-Encoding: binary" )
            $null = $builder.AppendLine()
            $null = $builder.AppendLine( "GET $u HTTP/1.1" )
            $null = $builder.AppendLine( "Accept: application/json" )
            $null = $builder.AppendLine()
        }

        $null = $builder.AppendLine( "--batch_$BatchId--" )
        $null = $builder.AppendLine()

        return $builder.ToString()
    }
    end
    {
    }
}