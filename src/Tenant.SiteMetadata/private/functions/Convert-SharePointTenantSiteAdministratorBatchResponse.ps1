function Convert-SharePointTenantSiteAdministratorBatchResponse
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [System.Collections.Specialized.OrderedDictionary]
        $Dictionary,

        [Parameter(Mandatory=$true)]
        [string]
        $BatchResponse
    )    

    begin
    {
        <# expected raw response format
         
            --batchresponse_253455a4-8973-4ab3-bf1e-9704e5e344a9
            Content-Type: application/http
            Content-Transfer-Encoding: binary

            HTTP/1.1 200 OK
            CONTENT-TYPE: application/json;odata=minimalmetadata;streaming=true;charset=utf-8

            {"odata.metadata":"https://contoso-admin.sharepoint.com/_api/$metadata#Collection(Microsoft.Online.SharePoint.TenantAdministration.SiteAdministratorsInfo)","value":[{"email":"aaronp@contoso.com","loginName":"i:0#.f|membership|aaronp@contoso.com","name":"Aaron Painter","userPrincipalName":"aaronp@contoso.com"},{"email":"adamb@contoso.com","loginName":"i:0#.f|membership|adamb@contoso.com","name":"Adam Barr","userPrincipalName":"adamb@contoso.com"},{"email":"","loginName":"c:0t.c|tenant|241b7197-5d66-4139-af62-84c1d7f25c14","name":"Executives","userPrincipalName":null},{"email":"joe.rodgers@contoso.onmicrosoft.com","loginName":"i:0#.f|membership|joe.rodgers@contoso.onmicrosoft.com","name":"Joe Rodgers","userPrincipalName":"joe.rodgers@contoso.onmicrosoft.com"},{"email":"contoso@microsoft.com","loginName":"i:0#.f|membership|contoso_microsoft.com#ext#@contoso.onmicrosoft.com","name":"Joe Rodgers (MSFT)","userPrincipalName":"contoso_microsoft.com#ext#@contoso.onmicrosoft.com"},{"email":"mailenabledsecuritygroup@contoso.onmicrosoft.com","loginName":"c:0t.c|tenant|bd89ac1c-7268-4231-a1d5-1ab6843538fd","name":"Mail Enabled Security Group","userPrincipalName":null},{"email":"","loginName":"c:0t.c|tenant|0b9a7cdc-7bfa-425e-a1c3-b4ea125719a5","name":"OneDriveUsers","userPrincipalName":null}]}
            --batchresponse_253455a4-8973-4ab3-bf1e-9704e5e344a9
            Content-Type: application/http
            Content-Transfer-Encoding: binary

            HTTP/1.1 200 OK
            CONTENT-TYPE: application/json;odata=minimalmetadata;streaming=true;charset=utf-8

            {"odata.metadata":"https://contoso-admin.sharepoint.com/_api/$metadata#Collection(Microsoft.Online.SharePoint.TenantAdministration.SiteAdministratorsInfo)","value":[{"email":"aaronp@contoso.com","loginName":"i:0#.f|membership|aaronp@contoso.com","name":"Aaron Painter","userPrincipalName":"aaronp@contoso.com"},{"email":"adamb@contoso.com","loginName":"i:0#.f|membership|adamb@contoso.com","name":"Adam Barr","userPrincipalName":"adamb@contoso.com"},{"email":"","loginName":"c:0t.c|tenant|241b7197-5d66-4139-af62-84c1d7f25c14","name":"Executives","userPrincipalName":null},{"email":"joe.rodgers@contoso.onmicrosoft.com","loginName":"i:0#.f|membership|joe.rodgers@contoso.onmicrosoft.com","name":"Joe Rodgers","userPrincipalName":"joe.rodgers@contoso.onmicrosoft.com"},{"email":"contoso@microsoft.com","loginName":"i:0#.f|membership|contoso_microsoft.com#ext#@contoso.onmicrosoft.com","name":"Joe Rodgers (MSFT)","userPrincipalName":"contoso_microsoft.com#ext#@contoso.onmicrosoft.com"},{"email":"mailenabledsecuritygroup@contoso.onmicrosoft.com","loginName":"c:0t.c|tenant|bd89ac1c-7268-4231-a1d5-1ab6843538fd","name":"Mail Enabled Security Group","userPrincipalName":null},{"email":"","loginName":"c:0t.c|tenant|0b9a7cdc-7bfa-425e-a1c3-b4ea125719a5","name":"OneDriveUsers","userPrincipalName":null}]}
            --batchresponse_253455a4-8973-4ab3-bf1e-9704e5e344a9
            Content-Type: application/http
            Content-Transfer-Encoding: binary

            HTTP/1.1 200 OK
            CONTENT-TYPE: application/json;odata=minimalmetadata;streaming=true;charset=utf-8

            {"odata.metadata":"https://contoso-admin.sharepoint.com/_api/$metadata#Collection(Microsoft.Online.SharePoint.TenantAdministration.SiteAdministratorsInfo)","value":[{"email":"aaronp@contoso.com","loginName":"i:0#.f|membership|aaronp@contoso.com","name":"Aaron Painter","userPrincipalName":"aaronp@contoso.com"},{"email":"adamb@contoso.com","loginName":"i:0#.f|membership|adamb@contoso.com","name":"Adam Barr","userPrincipalName":"adamb@contoso.com"},{"email":"","loginName":"c:0t.c|tenant|241b7197-5d66-4139-af62-84c1d7f25c14","name":"Executives","userPrincipalName":null},{"email":"joe.rodgers@contoso.onmicrosoft.com","loginName":"i:0#.f|membership|joe.rodgers@contoso.onmicrosoft.com","name":"Joe Rodgers","userPrincipalName":"joe.rodgers@contoso.onmicrosoft.com"},{"email":"contoso@microsoft.com","loginName":"i:0#.f|membership|contoso_microsoft.com#ext#@contoso.onmicrosoft.com","name":"Joe Rodgers (MSFT)","userPrincipalName":"contoso_microsoft.com#ext#@contoso.onmicrosoft.com"},{"email":"mailenabledsecuritygroup@contoso.onmicrosoft.com","loginName":"c:0t.c|tenant|bd89ac1c-7268-4231-a1d5-1ab6843538fd","name":"Mail Enabled Security Group","userPrincipalName":null},{"email":"","loginName":"c:0t.c|tenant|0b9a7cdc-7bfa-425e-a1c3-b4ea125719a5","name":"OneDriveUsers","userPrincipalName":null}]}
            --batchresponse_253455a4-8973-4ab3-bf1e-9704e5e344a9--
        #>
    }
    process
    {
        # Write-PSFMessage -Message "Processing batch response" -Level Verbose

        if( $BatchResponse -match '--batchresponse_[a-fA-F\d]{8}-[a-fA-F\d]{4}-[a-fA-F\d]{4}-[a-fA-F\d]{4}-[a-fA-F\d]{12}' )
        {
            $delineator = $Matches[0]
        }
        else 
        {
            Write-Error "Unable to find batch delineator"
            return
        }
        
        if( $delineator -match '[a-fA-F\d]{8}-[a-fA-F\d]{4}-[a-fA-F\d]{4}-[a-fA-F\d]{4}-[a-fA-F\d]{12}' )
        {
            # $batchId = $Matches[0]
        }
        else 
        {
            Write-Error "Unable to find batch id"
            return
        }

        $batches = $BatchResponse.Split( @(,"$delineator`r"), [System.StringSplitOptions]::RemoveEmptyEntries )

        $counter = 0

        $results = foreach ( $batch in $batches )
        {
            if ($batch -match "HTTP/1\.1" -and $batch -notmatch "HTTP/1\.1 200 OK" )
            {
                # batch failed
                $counter++

                Write-PSFMessage -Message "Batch request failed. Batch Text: $batch" -Level Error
                continue
            }
        
            $lines = $batch -split [Environment]::NewLine
                    
            foreach ( $line in $lines )
            {
                if ( $line.Contains( '{"odata.metadata"') )
                {
                    # convert json string to PSObject
                    $obj = $line | ConvertFrom-Json
        
                    # pull out serivce identities we can't resolve to AAD objects
                    $obj.value | Select-Object @{ Name="SiteId"; Expression={ $Dictionary[$counter] }}, LoginName

                    $counter++

                    break
                }
            }
        }

        return ,($results -as [System.Collections.Generic.List[PSCustomObject]])
    }
    end
    {
    }
}
