function Update-DatabaseSchema
{
<#
    .SYNOPSIS
    Updates the database schema to match the module build. 

    .DESCRIPTION
    Updates the database schema to match the module build. 

    .PARAMETER DatabaseConnectionInformation
    Database Connection Information

    .EXAMPLE
    PS C:\> Update-DatabaseSchema -DatabaseConnectionInformation <database connection information> 
#>
    [CmdletBinding()]
    param
    (
    )

    begin
    {
        $Error.Clear()

        $schemas   = Get-ChildItem -Recurse -Path "$PSScriptRoot\..\private\SQL" -Filter "schema.*.sql"
        $tables    = Get-ChildItem -Recurse -Path "$PSScriptRoot\..\private\SQL" -Filter "table.*.sql"
        $functions = Get-ChildItem -Recurse -Path "$PSScriptRoot\..\private\SQL" -Filter "function.*.sql"
        $procs     = Get-ChildItem -Recurse -Path "$PSScriptRoot\..\private\SQL" -Filter "proc.*.sql"
        $views     = Get-ChildItem -Recurse -Path "$PSScriptRoot\..\private\SQL" -Filter "view.*.sql"
        $upgrades  = Get-ChildItem -Recurse -Path "$PSScriptRoot\..\private\SQL" -Filter "upgrade.*.sql"
    }
    process
    {
        foreach( $path in $schemas )
        {
            Write-PSFMessage -Message "Executing schemas file: $($path.Fullname)" -Level Verbose

            if( $query = Get-Content -Path $path.FullName -Raw )
            {
                Invoke-NonQuery -Query $query 
            }

            if( -not $?) { return }
        }

        foreach( $path in $tables )
        {
            Write-PSFMessage -Message "Executing table file: $($path.Fullname)" -Level Verbose

            if( $query = Get-Content -Path $path.FullName -Raw )
            {
                Invoke-NonQuery -Query $query 
            }

            if( -not $?) { return }
        }

        foreach( $path in $functions )
        {
            Write-PSFMessage -Message "Executing function file: $($path.Fullname)" -Level Verbose

            if( $query = Get-Content -Path $path.FullName -Raw )
            {
                Invoke-NonQuery -Query $query 
            }

            if( -not $?) { return }
        }

        foreach( $path in $procs )
        {
            Write-PSFMessage -Message "Executing procedure file: $($path.Fullname)" -Level Verbose

            if( $query = Get-Content -Path $path.FullName -Raw )
            {
                Invoke-NonQuery -Query $query 
            }

            if( -not $?) { return }
        }

        foreach( $path in $views )
        {
            Write-PSFMessage -Message "Executing view file: $($path.Fullname)" -Level Verbose

            if( $query = Get-Content -Path $path.FullName -Raw )
            {
                Invoke-NonQuery -Query $query 
            }

            if( -not $?) { return }
        }

        foreach( $path in $upgrades )
        {
            Write-PSFMessage -Message "Executing upgrade file: $($path.Fullname)" -Level Verbose

            if( $query = Get-Content -Path $path.FullName -Raw )
            {
                Invoke-NonQuery -Query $query 
            }

            if( -not $?) { return }
        }
    }
    end
    {
        # running at the end b/c we won't know if we have the required tables and procs in place yet
        $cmdletExecutionId = Start-CmdletExecution -Cmdlet $PSCmdlet

        Stop-CmdletExecution -Id $cmdletExecutionId -ErrorCount $Error.Count
    }
}


