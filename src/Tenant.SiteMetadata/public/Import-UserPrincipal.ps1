function Import-UserPrincipal
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

        $activeUserUri  = 'v1.0/users?$top=999&$Select=AccountEnabled,City,CompanyName,Country,CreatedDateTime,CreationType,DeletedDateTime,Department,DisplayName,EmployeeId,EmployeeType,ExternalUserState,ExternalUserStateChangeDateTime,FirstName,JobTitle,Surname,LastPasswordChangeDateTime,Mail,MailNickname,Manager,MobilePhone,Id,OfficeLocation,OnPremisesDistinguishedName,OnPremisesDomainName,OnPremisesImmutableId,OnPremisesLastSyncDateTime,OnPremisesSamAccountName,OnPremisesSecurityIdentifier,OnPremisesSyncEnabled,OnPremisesUserPrincipalName,PostalCode,PreferredDataLocation,PreferredLanguage,State,StreetAddress,UsageLocation,UserPrincipalName,UserType'
        $deletedUserUri = 'v1.0/directory/deleteditems/microsoft.graph.user?$select=Id,DisplayName,UserPrincipalName,UserType,DeletedDateTime&$top=999'
    
        $counter = 0
        
        $principalList = New-Object System.Collections.Generic.List[PSCustomObject]
    }
    process
    {
        try
        {
            Assert-MicrosoftGraphConnection -Cmdlet $PSCmdlet

            while( $activeUserUri )
            {
                Write-PSFMessage -Message "Executing active user Graph API query number: $((++$counter))" -Level Verbose

                $results = Invoke-MgRestMethod -Method GET -Uri $activeUserUri

                foreach( $result in $results.value )
                {
                    # these property names are case sensitive in OPENJSON in proc_AddOrUpdateUserPrincipal
                    $principal = [PSCustomObject] @{
                                    AccountEnabled                  = $result.AccountEnabled
                                    City                            = $result.City
                                    CompanyName                     = $result.CompanyName
                                    Country                         = $result.Country
                                    CreatedDateTime                 = $result.CreatedDateTime
                                    CreationType                    = $result.CreationType
                                    DeletedDateTime                 = $result.DeletedDateTime
                                    Department                      = $result.Department
                                    DisplayName                     = $result.DisplayName
                                    EmployeeId                      = $result.EmployeeId
                                    EmployeeType                    = $result.EmployeeType
                                    ExternalUserState               = $result.ExternalUserState
                                    ExternalUserStateChangeDateTime = $result.ExternalUserStateChangeDateTime
                                    FirstName                       = $result.FirstName
                                    JobTitle                        = $result.JobTitle
                                    Surname                         = $result.Surname
                                    LastPasswordChangeDateTime      = $result.LastPasswordChangeDateTime
                                    Mail                            = $result.Mail
                                    MailNickname                    = $result.MailNickname
                                  # Manager                         = $result.Manager.Id
                                    MobilePhone                     = $result.MobilePhone
                                    Id                              = $result.Id
                                    OfficeLocation                  = $result.OfficeLocation
                                    OnPremisesDistinguishedName     = $result.OnPremisesDistinguishedName
                                    OnPremisesDomainName            = $result.OnPremisesDomainName
                                    OnPremisesImmutableId           = $result.OnPremisesImmutableId
                                    OnPremisesLastSyncDateTime      = $result.OnPremisesLastSyncDateTime
                                    OnPremisesSamAccountName        = $result.OnPremisesSamAccountName
                                    OnPremisesSecurityIdentifier    = $result.OnPremisesSecurityIdentifier
                                    OnPremisesSyncEnabled           = $result.OnPremisesSyncEnabled
                                    OnPremisesUserPrincipalName     = $result.OnPremisesUserPrincipalName
                                    PostalCode                      = $result.PostalCode
                                    PreferredDataLocation           = $result.PreferredDataLocation
                                    PreferredLanguage               = $result.PreferredLanguage
                                    State                           = $result.State
                                    StreetAddress                   = $result.StreetAddress
                                    UsageLocation                   = $result.UsageLocation
                                    UserPrincipalName               = $result.UserPrincipalName
                                    UserType                        = $result.UserType
                                }

                    $principalList.Add($principal)

                    if( $principalList.Count -ge $BatchSize )
                    {
                        Write-PSFMessage -Message "Merging $($principalList.Count) active user principals" -Level Verbose

                        $json = $principalList | ConvertTo-Json -Compress -AsArray
                
                        Invoke-StoredProcedure -StoredProcedure "principal.proc_AddOrUpdateUserPrincipal" -Parameters @{ json =  $json; isActive = $true } -ErrorAction Stop # markActive forces the proc to set DeletedDateTime to NULL
                        
                        $principalList.Clear()
                    }
                }

                $activeUserUri = $results.'@odata.nextLink'
            }

            if( $principalList.Count -gt 0 )
            {
                Write-PSFMessage -Message "Merging $($principalList.Count) active user principals" -Level Verbose

                $json = $principalList | ConvertTo-Json -Compress -AsArray
        
                Invoke-StoredProcedure -StoredProcedure "principal.proc_AddOrUpdateUserPrincipal" -Parameters @{ json =  $json; isActive = $true } -ErrorAction Stop # markActive forces the proc to set DeletedDateTime to NULL
            }

            $principalList.Clear()
        }
        catch
        {
            $principalList = $null

            Stop-CmdletExecution -Id $cmdletExecutionId -ErrorCount $global:Error.Count

            Write-PSFMessage -Message "Failed to import active user principals." -ErrorRecord $_ -EnableException $true -Level Critical
        }

        try
        {
            $counter = 0
            $principalList.Clear()

            while( $deletedUserUri )
            {
                Write-PSFMessage -Message "Executing deleted user Graph API query number: $((++$counter))" -Level Verbose

                $results = Invoke-MgRestMethod -Method GET -Uri $deletedUserUri
            
                foreach( $result in $results.value )
                {
                    # these property names are case sensitive in OPENJSON in proc_AddOrUpdateUserPrincipal
                    $principal = [PSCustomObject] @{
                                    AccountEnabled    = $false # mark disabled if deleted
                                    Id                = $result.id
                                    DisplayName       = $result.displayName
                                    UserPrincipalName = $result.userPrincipalName -replace ($result.id -replace"-", ""), ""
                                    UserType          = $result.userType
                                    DeletedDateTime   = $result.deletedDateTime
                                 }

                    $principalList.Add($principal)

                    if( $principalList.Count -ge $BatchSize )
                    {
                        Write-PSFMessage -Message "Merging $($principalList.Count) deleted user principals" -Level Verbose

                        $json = $principalList | ConvertTo-Json -Compress -AsArray

                        Invoke-StoredProcedure -StoredProcedure "principal.proc_AddOrUpdateUserPrincipal" -Parameters @{ json =  $json; isActive = $false } -ErrorAction Stop # markActive forces the proc to set DeletedDateTime to NULL
                    
                        $principalList.Clear()
                    }
                }
            
                $deletedUserUri = $results.'@odata.nextLink'
            }

            if( $principalList.Count -gt 0 )
            {
                Write-PSFMessage -Message "Merging $($principalList.Count) deleted user principals" -Level Verbose

                $json = $principalList | ConvertTo-Json -Compress -AsArray
        
                Invoke-StoredProcedure -StoredProcedure "principal.proc_AddOrUpdateUserPrincipal" -Parameters @{ json =  $json; isActive = $false } -ErrorAction Stop # markActive forces the proc to set DeletedDateTime to NULL
            }
        }
        catch
        {
            $principalList = $null

            Stop-CmdletExecution -Id $cmdletExecutionId -ErrorCount $global:Error.Count

            Write-PSFMessage -Message "Failed to import deleted user principals." -ErrorRecord $_ -EnableException $true -Level Critical
        }

        $principalList = $null

        Write-PSFMessage -Message "Completed user principal import" -Level Verbose
    }
    end
    {
        Stop-CmdletExecution -Id $cmdletExecutionId -ErrorCount $global:Error.Count
    }
}
