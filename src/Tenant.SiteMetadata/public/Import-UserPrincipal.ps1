﻿function Import-UserPrincipal
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false)]
        [int]
        $BatchSize = 1000
    )

    begin
    {
        $cmdletExecutionId = Start-CmdletExecution -Cmdlet $PSCmdlet -ClearErrors

        $properties = @(
            "AccountEnabled",
            "City",
            "CompanyName",
            "Country",
            "CreatedDateTime",
            "CreationType",
            "DeletedDateTime",
            "Department",
            "DisplayName",
            "EmployeeId",
            "EmployeeType",
            "ExternalUserState",
            "ExternalUserStateChangeDateTime",
            "FirstName",
            "JobTitle",
            "Surname",
            "LastPasswordChangeDateTime",
            "Mail",
            "MailNickname",
            "Manager",
            "MobilePhone",
            "Id",
            "OfficeLocation",
            "OnPremisesDistinguishedName",
            "OnPremisesDomainName",
            "OnPremisesImmutableId",
            "OnPremisesLastSyncDateTime",
            "OnPremisesSamAccountName",
            "OnPremisesSecurityIdentifier",
            "OnPremisesSyncEnabled",
            "OnPremisesUserPrincipalName",
            "PostalCode",
            "PreferredDataLocation",
            "PreferredLanguage",
            "State",
            "StreetAddress",
            "UsageLocation",
            "UserPrincipalName",
            "UserType"
        )
    }
    process
    {
        Assert-MicrosoftGraphConnection -Cmdlet $PSCmdlet

        # active users

        Write-PSFMessage -Message "Querying Microsoft Graph for active users" -Level Verbose

        $activeUserList = New-Object System.Collections.Generic.List[PSCustomObject]

        $uri = "v1.0/users?`$top=999&`$Select=$($properties -join ",")&`$Expand=Manager"

        do
        {
            $results = Invoke-MgRestMethod -Method GET -Uri $uri

            foreach( $result in $results.value )
            {
                # these property names are case sensitive in OPENJSON in proc_AddOrUpdateUserPrincipal
                $activeUser = [PSCustomObject] @{
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
                                    Manager                         = $result.Manager.Id
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

                $activeUserList.Add($activeUser)
            }

            $uri = $results.'@odata.nextLink'
        }
        while( $uri )

        Write-PSFMessage -Message "Microsoft Graph return $($activeUsersList.Count) active users" -Level Verbose

        # break list into chunks of $BatchSize
        $chunks = [System.Linq.Enumerable]::Chunk( $activeUsersList, $BatchSize )

        # merge each chunk
        foreach( $chunk in $chunks )
        {
            Write-PSFMessage -Message "Merging batch of $($chunk.Count) users" -Level Verbose

            $list = [System.Linq.Enumerable]::ToList( $chunk )

            $json = $list | ConvertTo-Json -Compress
            
            Invoke-StoredProcedure -StoredProcedure "principal.proc_AddOrUpdateUserPrincipal" -Parameters @{ json =  $json; isActive = $true }  # markActive forces the proc to set DeletedDateTime to NULL
        }

        # deleted users

            Write-PSFMessage -Message "Querying Microsoft Graph for deleted users" -Level Verbose

            $deletedUserList = New-Object System.Collections.Generic.List[PSCustomObject]

            $uri = 'v1.0/directory/deleteditems/microsoft.graph.user?$select=Id,DisplayName,UserPrincipalName,UserType,DeletedDateTime&$top=999'

            do
            {
                $results = Invoke-MgRestMethod -Method GET -Uri $uri
            
                foreach( $result in $results.value )
                {
                    # these property names are case sensitive in OPENJSON in proc_AddOrUpdateUserPrincipal
                    $deletedUser =  [PSCustomObject] @{
                                        Id                = $result.id
                                        DisplayName       = $result.displayName
                                        UserPrincipalName = $result.userPrincipalName -replace ($result.id -replace"-", ""), ""
                                        UserType          = $result.userType
                                        DeletedDateTime   = $result.deletedDateTime
                                    }

                    $deletedUserList.Add($deletedUser)
                }
            
                $uri = $results.'@odata.nextLink'
            }
            while( $uri )

            Write-PSFMessage -Message "Microsoft Graph returned $($deletedUserList.Count) deleted users" -Level Verbose

            # break list into chunks of $BatchSize
            $chunks = [System.Linq.Enumerable]::Chunk( $deletedUserList, $BatchSize )

            # merge each chunk
            foreach( $chunk in $chunks )
            {
                Write-PSFMessage -Message "Merging batch of $($chunk.Count) deleted users" -Level Verbose

                $json = @($chunk) | ConvertTo-Json -Compress -AsArray
            
                Invoke-StoredProcedure -StoredProcedure "principal.proc_AddOrUpdateUserPrincipal" -Parameters @{ json =  $json; isActive = $false }
            }

            Write-PSFMessage -Message "Completed user principal import" -Level Verbose
    }
    end
    {
        Stop-CmdletExecution -Id $cmdletExecutionId -ErrorCount $Error.Count
    }
}
