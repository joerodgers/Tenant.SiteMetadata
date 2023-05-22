function Import-GroupPrincipal
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false)]
        [string]
        $Filter,

        [Parameter(Mandatory=$false)]
        [ValidateRange(100,999)]
        [int]
        $PageSize = 100
    )

    begin
    {
        $cmdletExecutionId = Start-CmdletExecution -Cmdlet $PSCmdlet -ClearErrors

        $properties = @(
            "AssignedLabels"
            "Classification", 
            "CreatedDateTime", 
            "DeletedDateTime", 
            "Description", 
            "DisplayName", 
            "ExpirationDateTime",
            "GroupTypes",
            "Id",
            "IsAssignableToRole",
            "Mail", 
            "MailEnabled",
            "MailNickname",
            "MembershipRule",
            "MembershipRuleProcessingState",
            "ObjectId", 
            "OnPremisesLastSyncDateTime",
            "OnPremisesSamAccountName",
            "OnPremisesSecurityIdentifier",
            "OnPremisesSyncEnabled",
            "PreferredDataLocation",
            "PreferredLanguage",
            "RenewedDateTime",
            "ResourceProvisioningOptions",
            "SecurityEnabled",
            "SecurityIdentifier"
            "Theme",
            "Visibility"
        )

        $selectProperties = @(
            @{ Name = "Classification";                Expression={ $_.Classification }}
            @{ Name = "CreatedDateTime";               Expression={ $_.CreatedDateTime }}
            @{ Name = "DeletedDateTime";               Expression={ $_.DeletedDateTime }}
            @{ Name = "Description";                   Expression={ $_.Description }}
            @{ Name = "DisplayName";                   Expression={ $_.DisplayName }}
            @{ Name = "ExpirationDateTime";            Expression={ $_.ExpirationDateTime }}
            @{ Name = "IsAssignableToRole";            Expression={ $_.IsAssignableToRole }}
            @{ Name = "IsUnifiedGroup";                Expression={ $_.GroupTypes -contains "Unified" }}
            @{ Name = "IsTeamsGroup";                  Expression={ $_.ResourceProvisioningOptions -contains "Team" }}
            @{ Name = "IsPublic";                      Expression={ $_.Visibility -eq "Public" }}
            @{ Name = "Mail";                          Expression={ $_.Mail }}
            @{ Name = "MailEnabled";                   Expression={ $_.MailEnabled }}
            @{ Name = "MailNickname";                  Expression={ $_.MailNickname }}
            @{ Name = "MembershipRule";                Expression={ $_.MembershipRule }}
            @{ Name = "MembershipRuleProcessingState"; Expression={ $_.MembershipRuleProcessingState }}
            @{ Name = "ObjectId";                      Expression={ $_.Id }}
            @{ Name = "OnPremisesLastSyncDateTime";    Expression={ $_.OnPremisesLastSyncDateTime }}
            @{ Name = "OnPremisesSamAccountName";      Expression={ $_.OnPremisesSamAccountName }}
            @{ Name = "OnPremisesSecurityIdentifier";  Expression={ $_.OnPremisesSecurityIdentifier }}
            @{ Name = "OnPremisesSyncEnabled";         Expression={ $_.OnPremisesSyncEnabled }}
            @{ Name = "PreferredDataLocation";         Expression={ $_.PreferredDataLocation }}
            @{ Name = "PreferredLanguage";             Expression={ $_.PreferredLanguage }}
            @{ Name = "RenewedDateTime";               Expression={ $_.RenewedDateTime }}
            @{ Name = "SecurityEnabled";               Expression={ $_.SecurityEnabled }}
            @{ Name = "SecurityIdentifier";            Expression={ $_.SecurityIdentifier }}
            @{ Name = "SensitivityLabel";              Expression={ $_.assignedLabels.labelId }}
            @{ Name = "Theme";                         Expression={ $_.Theme }}
        )
    }
    process
    {
        Assert-MicrosoftGraphConnection -Cmdlet $PSCmdlet

        $counter  = 1
        $total    = 0
        $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

        $uri = '/v1.0/groups?$top={0}&$select={1}' -f $PageSize, ($properties -join ",")

        while( $uri )
        {
            Write-PSFMessage -Message "Executing Graph API group batch query #$counter" -Level Verbose

            $response = Invoke-MgRestMethod -Method GET -Uri $uri -Verbose:$false
        
            if( $response.value )
            {
                $json = $response.value | Select-Object $selectProperties | ConvertTo-Json -Compress

                Write-PSFMessage -Message "Merging $($response.value.Count) group principals into database" -Level Verbose

                Invoke-StoredProcedure -StoredProcedure "principal.proc_AddOrUpdateGroupPrincipal" -Parameters @{ json =  $json }
            }
            else
            {
                Write-PSFMessage -Message "Not results returned from group paged query" -Level Warning
            }

            $uri = $response.'@odata.nextLink'

            $counter++
            $total += $response.value.Count
        }
        
        Write-PSFMessage -Message "Completed importing $total groups in $([Math]::Round($stopwatch.Elapsed.TotalMinutes,2)) minutes" -Level Verbose
    }
    end
    {
        Stop-CmdletExecution -Id $cmdletExecutionId -ErrorCount $Error.Count
    }
}