function Get-GuidOrNull
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [AllowEmptyString()]
        [AllowNull()]
        [string]
        $GuidString
    )

    $guid = [Guid]::Empty

    if( -not [string]::IsNullOrEmpty($GuidString) -and [Guid]::TryParse( $GuidString, [ref] $guid ) )
    {
        return $guid
    }

    return $null
} 