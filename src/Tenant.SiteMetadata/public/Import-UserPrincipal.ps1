function Import-UserPrincipal
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

        # active user import

        # $uri = "v1.0/users?`$top=999&`$Select=$($properties -join ",")&`$Expand=Manager"

        $uri = "v1.0/users?`$top=999&`$Select=$($properties -join ",")"
        $counter = 0

        do
        {
            $counter++

            Write-PSFMessage -Message "Executing active user Graph API query number: $counter" -Level Verbose

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

                $json = $activeUser | ConvertTo-Json -Compress -AsArray
            
                Invoke-StoredProcedure -StoredProcedure "principal.proc_AddOrUpdateUserPrincipal" -Parameters @{ json =  $json; isActive = $true }  # markActive forces the proc to set DeletedDateTime to NULL
            }

            $uri = $results.'@odata.nextLink'
        }
        while( $uri )

        # deleted user import

        $uri = 'v1.0/directory/deleteditems/microsoft.graph.user?$select=Id,DisplayName,UserPrincipalName,UserType,DeletedDateTime&$top=999'

        $counter = 0
        do
        {
            $counter++

            Write-PSFMessage -Message "Executing deleted user Graph API query number: $counter" -Level Verbose

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

                $json = $deletedUser | ConvertTo-Json -Compress -AsArray

                Invoke-StoredProcedure -StoredProcedure "principal.proc_AddOrUpdateUserPrincipal" -Parameters @{ json =  $json; isActive = $false }
            }
        
            $uri = $results.'@odata.nextLink'
        }
        while( $uri )

        Write-PSFMessage -Message "Completed user principal import" -Level Verbose
    }
    end
    {
        Stop-CmdletExecution -Id $cmdletExecutionId -ErrorCount $Error.Count
    }
}
