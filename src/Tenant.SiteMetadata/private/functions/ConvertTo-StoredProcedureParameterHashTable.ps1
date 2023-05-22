function ConvertTo-StoredProcedureParameterHashTable
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
        $parameters = @{}
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
    
            $parameters[$BoundParameter.Key] = $BoundParameter.Value
        }
    }
    end
    {
        $parameters
    }
}