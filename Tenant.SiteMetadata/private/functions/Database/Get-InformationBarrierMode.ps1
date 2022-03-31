function Get-InformationBarrierMode
{
    [CmdletBinding(DefaultParameterSetName="All")]
    param
    (
        [Parameter(Mandatory=$true,ParameterSetName="All")]
        [switch]
        $All,

        [Parameter(Mandatory=$true,ParameterSetName="Id")]
        [Guid]
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
                        -Query "SELECT Id, InformationBarrierMode FROM dbo.InformationBarrierMode (nolock)" `
                        -As    "PSObject"
            }
            "Id"
            {
                return Get-DataTable `
                        -Query      "SELECT Id, InformationBarrierMode FROM dbo.InformationBarrierMode (nolock) WHERE @Id = @Id" `
                        -Parameters @{ Id = $Id } `
                        -As         "PSObject"
            }
            "Name"
            {
                return Get-DataTable `
                        -Query      "SELECT Id, InformationBarrierMode FROM dbo.InformationBarrierMode (nolock) WHERE @InformationBarrierMode = @InformationBarrierMode" `
                        -Parameters @{ InformationBarrierMode = $Name } `
                        -As         "PSObject"
            }
        }
    }
    end
    {
    }
}