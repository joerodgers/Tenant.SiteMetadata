function Import-GroupPrincipal
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false)]
        [int]
        $BatchSize = 5000
    )

    begin
    {
        $cmdletExecutionId = Start-CmdletExecution -Cmdlet $PSCmdlet -ClearErrors

        $counter = 0

        $groupsUri = '/v1.0/groups?$top=999&$select=Classification,CreatedDateTime,DeletedDateTime,Description,DisplayName,ExpirationDateTime,GroupTypes,Id,IsAssignableToRole,Mail,MailEnabled,MailNickname,MembershipRule,MembershipRuleProcessingState,ObjectId,OnPremisesLastSyncDateTime,OnPremisesSamAccountName,OnPremisesSecurityIdentifier,OnPremisesSyncEnabled,PreferredDataLocation,PreferredLanguage,RenewedDateTime,ResourceProvisioningOptions,SecurityEnabled,SecurityIdentifier,Theme,Visibility' -f ($properties -join ",")

        $principalList = New-Object System.Collections.Generic.List[PSCustomObject]
    }
    process
    {
        Assert-MicrosoftGraphConnection -Cmdlet $PSCmdlet

        try
        {
            while( $groupsUri )
            {
                Write-PSFMessage -Message "Executing Graph API group batch query #$((++$counter))" -Level Verbose
    
                $results = Invoke-MgRestMethod -Method GET -Uri $groupsUri
            
                foreach( $result in $results.value )
                {
                    # these property names are case sensitive in OPENJSON in proc_AddOrUpdateGroupPrincipal
                    $principal = [PSCustomObject] @{
                        Classification                 = $result.Classification
                        CreatedDateTime                = $result.CreatedDateTime
                        DeletedDateTime                = $result.DeletedDateTime
                        Description                    = $result.Description
                        DisplayName                    = $result.DisplayName
                        ExpirationDateTime             = $result.ExpirationDateTime
                        IsAssignableToRole             = $result.IsAssignableToRole
                        IsUnifiedGroup                 = $result.GroupTypes -contains "Unified"
                        IsTeamsGroup                   = $result.ResourceProvisioningOptions -contains "Team"
                        IsPublic                       = $result.Visibility -eq "Public"
                        Mail                           = $result.Mail
                        MailEnabled                    = $result.MailEnabled
                        MailNickname                   = $result.MailNickname
                        MembershipRule                 = $result.MembershipRule
                        MembershipRuleProcessingState  = $result.MembershipRuleProcessingState
                        ObjectId                       = $result.Id
                        OnPremisesLastSyncDateTime     = $result.OnPremisesLastSyncDateTime
                        OnPremisesSamAccountName       = $result.OnPremisesSamAccountName
                        OnPremisesSecurityIdentifier   = $result.OnPremisesSecurityIdentifier
                        OnPremisesSyncEnabled          = $result.OnPremisesSyncEnabled
                        PreferredDataLocation          = $result.PreferredDataLocation
                        PreferredLanguage              = $result.PreferredLanguage
                        RenewedDateTime                = $result.RenewedDateTime
                        SecurityEnabled                = $result.SecurityEnabled
                        SecurityIdentifier             = $result.SecurityIdentifier
                        SensitivityLabel               = $result.assignedLabels.labelId
                        Theme                          = $result.Theme
                    }

                    $principalList.Add($principal)

                    if( $principalList.Count -ge $BatchSize )
                    {
                        Write-PSFMessage -Message "Merging $($principalList.Count) group principals" -Level Verbose

                        $json = $principalList | ConvertTo-Json -Compress -AsArray
                
                        Invoke-StoredProcedure -StoredProcedure "principal.proc_AddOrUpdateGroupPrincipal" -Parameters @{ json =  $json }
                        
                        $principalList.Clear()
                    }
                }
    
                $groupsUri = $results.'@odata.nextLink'
            }

            if( $principalList.Count -gt 0 )
            {
                Write-PSFMessage -Message "Merging $($principalList.Count) group principals" -Level Verbose

                $json = $principalList | ConvertTo-Json -Compress -AsArray
        
                Invoke-StoredProcedure -StoredProcedure "principal.proc_AddOrUpdateGroupPrincipal" -Parameters @{ json =  $json }
                
            }

            $principalList = $null

            Write-PSFMessage -Message "Completed group import." -Level Verbose
        }
        catch
        {
            $principalList = $null

            Stop-CmdletExecution -Id $cmdletExecutionId -ErrorCount $global:Error.Count

            Write-PSFMessage -Message "Failed to import group principals." -ErrorRecord $_ -EnableException $true 
        }
    }
    end
    {
        Stop-CmdletExecution -Id $cmdletExecutionId -ErrorCount $global:Error.Count
    }
}