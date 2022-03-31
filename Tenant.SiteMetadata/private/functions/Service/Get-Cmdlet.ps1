function Get-Cmdlet
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.Cmdlet]
        $Cmdlet
    )

    begin
    {
    }
    process
    {
        Register-Cmdlet -Cmdlet $Cmdlet.MyInvocation.MyCommand.Name

        return Get-DataTable `
                    -Query      "EXEC proc_GetCmdlet @Cmdlet = @Cmdlet" `
                    -Parameters @{ Cmdlet = $Cmdlet.MyInvocation.MyCommand.Name } `
                    -As         "PSObject"
    }
    end
    {
    }
}