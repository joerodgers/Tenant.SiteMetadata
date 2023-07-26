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

        # the serialization of the JSON is case sensitive in the OPENJSON statement in SQL, need to make sure all the are pascal cased
        $pascalCasedSelect = @($properties | ForEach-Object { @{ Name="$_"; Expression=[ScriptBlock]::Create("`$_.$_") }} )
    }
    process
    {
        Assert-MicrosoftGraphConnection -Cmdlet $PSCmdlet

        # active users

            Write-PSFMessage -Message "Querying Microsoft Graph for active users" -Level Verbose

            # query graph to pull all active users
            $activeUsers = Get-MgUser -Property $properties -ExpandProperty Manager -All -PageSize 999

            # convert the Manager object into just the GUID
            $activeUsers = $activeUsers | Select-Object *, @{Name="Manager"; Expression={$_.Manager.Id}} -ExcludeProperty Manager

            # convert to generic collection (for easy chunking) and format the object names for sql json parsing 
            $activeUsersList = ($activeUsers | Select-Object $pascalCasedSelect) -as [System.Collections.Generic.List[PSCustomObject]]

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

            $deletedusers = Get-MgDirectoryDeletedItem -DirectoryObjectId "microsoft.graph.user" -Property Id, DisplayName, UserPrincipalName, UserType, DeletedDateTime -All -PageSize 999

            # need to reformat the deleted user response from this cmdlet
            foreach( $deletedUser in $deletedusers.AdditionalProperties.value.GetEnumerator() )
            {
                $deletedUserList.Add((
                    [PSCustomObject] @{
                        Id                = $deletedUser.id
                        DisplayName       = $deletedUser.displayName
                        UserPrincipalName = $deletedUser.userPrincipalName -replace ($deletedUser.id -replace"-", ""), ""
                        UserType          = $deletedUser.userType
                        DeletedDateTime   = $deletedUser.deletedDateTime
                    }
                ))
            }
 
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
