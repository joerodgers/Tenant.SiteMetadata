function Invoke-MicrosoftGraphPrincipalImport
{
    [CmdletBinding()]
    param
    (
    )

    begin
    {
        Assert-MicrosoftGraphConnection -Cmdlet $PSCmdlet

        $counter = 0

        $users  = Get-MicrosoftGraphUserPrincipal
        $groups = Get-MicrosoftGraphGroupPrincipal
    }
    process
    {
        if( $null -eq $users -or $users.Count -eq 0 )
        {
            Write-PSFMessage "Microsoft Graph API returned 0 users" -Level Critical
            return
        }

        if( $null -eq $groups -or $groups.Count -eq 0 )
        {
            Write-PSFMessage "Microsoft Graph API returned 0 groups" -Level Critical
            return
        }

        foreach( $user in $users )
        {
            $counter++ 

            if( $counter % 100 -eq 0 ) { Write-PSFMessage -Message "Registered $counter user principals" }

            Write-PSFMessage -Message "Registering User: $($user.UserPrincipalName)" -Level Debug    

            try 
            {
                Register-Principal `
                    -ObjectId          $user.ObjectId `
                    -Identifier        $user.UserPrincipalName `
                    -DisplayName       $user.DisplayName `
                    -PrincipalType     $user.PrincipalType `
                    -IsDirectorySynced $user.OnPremisesSyncEnabled `
                    -ErrorAction Stop
            }
            catch
            {
                Write-PSFMessage -Message "Failed to register user: $($user.UserPrincipalName)" -Level Error -ErrorRecord $_    
            }
        }

        $counter = 0

        foreach( $user in $users )
        {
            if( [string]::IsNullOrWhiteSpace($user.ManagerObjectId) ) { continue }

            $counter++ 

            if( $counter % 500 -eq 0 ) { Write-PSFMessage -Message "Registered $counter user principal managers" }

            try 
            {
                Register-PrincipalManager `
                    -PrincipalObjectId  $user.ObjectId `
                    -ManagerObjectId    $user.ManagerObjectId `
                    -ErrorAction        Stop
            }
            catch
            {
                Write-PSFMessage -Message "Failed to register principal manager.  Principal: $($userPrincipal.Id), Manager: $($userPrincipal.Manager)" -Level Error -ErrorRecord $_    
            }

        }

        Write-PSFMessage "Marking users missing from import as deleted"

        $activeDatabaseUsers = Get-Principal -PrincipalType ([PrincipalType]::Member -bor [PrincipalType]::Guest) -PrincipalStatus ([ObjectStatus]::Active)

        if( $activeDatabaseUsers.Count -gt 0 )
        {
            $deltas = Compare-Object -ReferenceObject $activeDatabaseUsers.ObjectId -DifferenceObject $users.ObjectId

            $objectIdsToMarkDeleted = @($deltas | Where-Object -Property "SideIndicator" -EQ "=>" | Select-Object -ExpandProperty "InputObject")

            Write-PSFMessage "Calculated $($objectIdsToMarkDeleted.Count) users to be marked as deleted"

            foreach( $objectId in $objectIdsToMarkDeleted )
            {
                Write-PSFMessage "Marking user $($objectId) as deleted"

                Register-Principal `
                    -ObjectId      $objectId `
                    -DeletedDate   (Get-Date)
            }
        }

        $counter = 0

        foreach( $group in $groups )
        {
            $counter++

            if( $counter % 100 -eq 0 ) { Write-PSFMessage -Message "Registered $counter group principals" }

            Write-PSFMessage -Message "Registering Group: $($group.DisplayName)" -Level Debug    

            try 
            {
                Register-Principal `
                    -ObjectId          $group.ObjectId `
                    -Identifier        $group.ObjectId `
                    -DisplayName       $group.DisplayName `
                    -PrincipalType     $group.PrincipalType `
                    -IsDirectorySynced $group.OnPremisesSyncEnabled `
                    -ErrorAction Stop
            }
            catch
            {
                Write-PSFMessage -Message "Failed to register group: $($group.ObjectId)" -Level Error -ErrorRecord $_    
            }
        }

        $activeDatabaseGroups = Get-Principal -PrincipalType $([PrincipalType]::M365Group -bor [PrincipalType]::SecurityGroup) -PrincipalStatus ([ObjectStatus]::Active)

        if( $activeDatabaseGroups.Count -gt 0 )
        {
            $deltas = Compare-Object -ReferenceObject $activeDatabaseGroups.ObjectId -DifferenceObject $group.ObjectId

            $objectIdsToMarkDeleted = @($deltas | Where-Object -Property "SideIndicator" -EQ "=>" | Select-Object -ExpandProperty "InputObject")

            Write-PSFMessage "Calculated $($objectIdsToMarkDeleted.Count) groups to be marked as deleted"

            foreach( $objectId in $objectIdsToMarkDeleted )
            {
                Write-PSFMessage "Marking group $($objectId) as deleted"

                Register-Principal `
                    -ObjectId    $objectId `
                    -Identifier  $group.ObjectId `
                    -DeletedDate (Get-Date) 
            }
        }
    }
    end
    {
    }
}