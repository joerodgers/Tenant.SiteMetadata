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
        # $cmdletExecutionId = Start-CmdletExecution -Cmdlet $PSCmdlet -ClearErrors

        $tables    = Get-ChildItem -Recurse -Path "$PSScriptRoot\..\private\SQL" -Filter "tb_*.sql"
        $functions = Get-ChildItem -Recurse -Path "$PSScriptRoot\..\private\SQL" -Filter "tvf_*.sql"
        $procs     = Get-ChildItem -Recurse -Path "$PSScriptRoot\..\private\SQL" -Filter "proc_*.sql"
        $views     = Get-ChildItem -Recurse -Path "$PSScriptRoot\..\private\SQL" -Filter "vw_*.sql"
        $upgrades  = Get-ChildItem -Recurse -Path "$PSScriptRoot\..\private\SQL" -Filter "upgrade*.sql"
    }
    process
    {
        foreach( $path in $tables )
        {
            Write-Verbose "$(Get-Date) - $($PSCmdlet.MyInvocation.MyCommand) - Executing table file: $($path.Fullname)"

            if( $query = Get-Content -Path $path.FullName -Raw )
            {
                Invoke-NonQuery -Query $query 
            }

            if( -not $?) { return }
        }

        foreach( $path in $functions )
        {
            Write-Verbose "$(Get-Date) - $($PSCmdlet.MyInvocation.MyCommand) - Executing function file: $($path.Fullname)"

            if( $query = Get-Content -Path $path.FullName -Raw )
            {
                Invoke-NonQuery -Query $query 
            }

            if( -not $?) { return }
        }

        foreach( $path in $procs )
        {
            Write-Verbose "$(Get-Date) - $($PSCmdlet.MyInvocation.MyCommand) - Executing proc file: $($path.Fullname)"

            if( $query = Get-Content -Path $path.FullName -Raw )
            {
                Invoke-NonQuery -Query $query 
            }

            if( -not $?) { return }
        }

        foreach( $path in $views )
        {
            Write-Verbose "$(Get-Date) - $($PSCmdlet.MyInvocation.MyCommand) - Executing view file: $($path.Fullname)"

            if( $query = Get-Content -Path $path.FullName -Raw )
            {
                Invoke-NonQuery -Query $query 
            }

            if( -not $?) { return }
        }

        foreach( $path in $upgrades )
        {
            Write-Verbose "$(Get-Date) - $($PSCmdlet.MyInvocation.MyCommand) - Executing upgrade file: $($path.Fullname)"

            if( $query = Get-Content -Path $path.FullName -Raw )
            {
                Invoke-NonQuery -Query $query 
            }

            if( -not $?) { return }
        }
    }
    end
    {
        # Stop-CmdletExecution -Id $cmdletExecutionId -ErrorCount $Error.Count
    }
}


