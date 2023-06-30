function Get-DateTimeOrNull 
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [AllowEmptyString()]
        [AllowNull()]
        [string]
        $DateTimeString
    )

    $dateTime = Get-Date 

    if( -not [string]::IsNullOrEmpty($DateTimeString) -and [DateTime]::TryParse( $DateTimeString, [ref] $dateTime ) )
    {
        return $dateTime
    }

    return $null
} 