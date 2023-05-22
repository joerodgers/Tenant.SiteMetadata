function ConvertTo-StoredProcedureParameterString
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [HashTable]
        $BoundParameters,

        [Parameter(Mandatory=$false)]
        [AllowEmptyCollection()]
        [string[]]
        $ExcludedParameter = @(),

        [Parameter(Mandatory=$false)]
        [switch]
        $ExcludeNullValueParameters
    )

    begin
    {
        $parameters = @()
    }
    process
    {
        foreach( $BoundParameter in $BoundParameters.GetEnumerator() )
        {
            if( $ExcludeNullValueParameters.IsPresent -and $null -eq $BoundParameter.Value )
            {
                continue 
            }

            if( [System.Management.Automation.PSCmdlet]::CommonParameters -contains $BoundParameter.Key )
            {
                continue
            }
    
            if( $ExcludedParameter -contains $BoundParameter.Key )
            {
                continue
            }
    
            $parameters += "@{0} = @{0}" -f $BoundParameter.Key
        }
    }
    end
    {
        $parameters -join ", "

        Write-PSFMessage "Completed" -Level Debug
    }
}