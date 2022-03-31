function Get-LockState
{
    [CmdletBinding(DefaultParameterSetName="All")]
    param
    (
        [Parameter(Mandatory=$true,ParameterSetName="All")]
        [switch]
        $All,

        [Parameter(Mandatory=$true,ParameterSetName="Id")]
        [int]
        $Id,

        [Parameter(Mandatory=$true,ParameterSetName="Name")]
        [string]
        $Name
    )

    begin
    {
        Assert-ServiceConnection -Cmdlet $PSCmdlet
    }
    process
    {
        switch( $PSCmdlet.ParameterSetName )
        {
            "All"
            {
                return Get-DataTable `
                        -Query "SELECT Id, LockState FROM dbo.LockState (nolock)" `
                        -As    "PSObject"
            }
            "Id"
            {
                return Get-DataTable `
                        -Query      "SELECT Id, LockState FROM dbo.LockState (nolock) WHERE @Id = @Id" `
                        -Parameters @{ Id = $Id } `
                        -As         "PSObject"
            }
            "Name"
            {
                return Get-DataTable `
                        -Query      "SELECT Id, LockState FROM dbo.LockState (nolock) WHERE @LockState = @LockState" `
                        -Parameters @{ LockState = $Name } `
                        -As         "PSObject"
            }
        }
    }
    end
    {
    }
}