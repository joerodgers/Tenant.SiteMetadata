function Get-MicrosoftGraphUserPrincipal
{
    [CmdletBinding()]
    param
    (
    )

    begin
    {
        Assert-MicrosoftGraphConnection -Cmdlet $PSCmdlet
    }
    process
    {
        try 
        {
            Write-PSFMessage -Message "Executing Get-MgUser" -Level Verbose

            $users = Get-MgUser `
                    -All `
                    -Property "id", "userPrincipalName", "manager", "userType", "onPremisesSyncEnabled", "displayName" `
                    -ExpandProperty "manager" `
                    -ErrorAction Stop
            
            Write-PSFMessage -Message "Microsoft.Graph returned $($users.Count) user principals"
            
            foreach( $user in $users )
            {
                switch( $user.UserType )
                {
                    "Member"
                    {
                        $principalType = [PrincipalType]::Member
                    }
                    "Guest"
                    {
                        $principalType = [PrincipalType]::Guest
                    }
                    default
                    {
                        $principalType = [PrincipalType]::Unknown
                    }
                }

                [PSCustomObject] @{
                    ObjectId              = $user.Id
                    UserPrincipalName     = $user.UserPrincipalName
                    OnPremisesSyncEnabled = $($null -ne $user.OnPremisesSyncEnabled -and $user.OnPremisesSyncEnabled )
                    DisplayName           = $user.DisplayName
                    PrincipalType         = $principalType
                    ManagerObjectId       = $user.Manager.Id
                }
            }
        }
        catch
        {
            Write-PSFMessage -Message "Failed to retrieve user principals from Microsoft.Graph" -EnableException $true -ErrorRecord $_ -Level Critical
        }
    }
    end
    {
        Write-PSFMessage "Completed" -Level Debug
    }
}