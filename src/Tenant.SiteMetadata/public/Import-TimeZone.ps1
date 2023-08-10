function Import-TimeZone
{
[CmdletBinding()]
param
(
)
    begin
    {
        $cmdletExecutionId = Start-CmdletExecution -Cmdlet $PSCmdlet -ClearErrors
    }
    process
    {
        try 
        {
            Assert-SharePointConnection -Cmdlet $PSCmdlet

            [System.Collections.Generic.List[Object]]$list = Get-PnPTimeZoneId 

            $json = $list | Select-Object Id, Identifier, Description | ConvertTo-Json

            Invoke-StoredProcedure -StoredProcedure "site.proc_AddOrUpdateTimeZone" -Parameters @{ json =  $json }
        }
        catch
        {
            Stop-CmdletExecution -Id $cmdletExecutionId -ErrorCount $global:Error.Count

            Write-PSFMessage -Message "Failed to import site timezones" -ErrorRecord $_ -EnableException $true -Level Critical
        }
    }
    end
    {
        Stop-CmdletExecution -Id $cmdletExecutionId -ErrorCount $global:Error.Count
    }
}