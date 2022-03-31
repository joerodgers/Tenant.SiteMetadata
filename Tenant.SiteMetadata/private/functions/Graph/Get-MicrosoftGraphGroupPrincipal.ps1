function Get-MicrosoftGraphGroupPrincipal
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
            Write-PSFMessage -Message "Executing Get-MgGroup"
    
            $groups = Get-MgGroup `
                            -All `
                            -Property "id", "onPremisesSyncEnabled", "displayName", "groupTypes", "visibility" `
                            -ErrorAction Stop
    
            Write-PSFMessage -Message "Microsoft.Graph returned $($groups.Count) group principals"

            foreach( $group in $groups )
            {
                if( $group.GroupTypes -contains "Unified" )
                {
                    $principalType = [PrincipalType]::M365Group
                } 
                else
                {
                    $principalType = [PrincipalType]::SecurityGroup
                }

                [PSCustomObject] @{
                    ObjectId              = $group.Id
                    DisplayName           = $group.DisplayName
                    OnPremisesSyncEnabled = $($null -ne $group.OnPremisesSyncEnabled -and $group.OnPremisesSyncEnabled )
                    PrincipalType         = $principalType
                }
            }
        }
        catch
        {
            Write-PSFMessage -Message "Failed to retrieve group principals from Microsoft.Graph" -EnableException $true -ErrorRecord $_ -Level Critical
        }
    }
    end
    {
    }
}