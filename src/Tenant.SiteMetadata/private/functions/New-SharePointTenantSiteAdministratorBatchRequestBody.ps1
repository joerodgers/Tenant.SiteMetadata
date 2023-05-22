function New-SharePointTenantSiteAdministratorBatchRequestBody
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [System.Collections.Specialized.OrderedDictionary]
        $Dictionary,

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
        foreach( $entry in $Dictionary.GetEnumerator() )
        {
            $null = $builder.AppendLine( "--batch_$BatchId" )
            $null = $builder.AppendLine( "Content-Type: application/http"    )
            $null = $builder.AppendLine( "Content-Transfer-Encoding: binary" )
            $null = $builder.AppendLine()
            $null = $builder.AppendLine( "GET /_api/Microsoft.Online.SharePoint.TenantAdministration.Tenant/GetSiteAdministrators?siteId='$($entry.Value)' HTTP/1.1" )
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