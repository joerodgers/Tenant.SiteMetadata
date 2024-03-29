﻿function Import-InformationBarrierSegment
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
        
            Write-PSFMessage -Message "Querying tenant for information barrier segments" -Level Verbose
    
            $results = Invoke-PnPSPRestMethod `
                            -Method "GET" `
                            -Url    "/_api/Microsoft.Online.SharePoint.TenantAdministration.Tenant/GetTenantAllOrCompatibleIBSegments" `
                            -ErrorAction Stop
    
            $json = $results.value | ConvertTo-Json
    
            Write-PSFMessage -Message "Merging $($results.value.Count) information barrier segments into database" -Level Verbose
    
            Invoke-StoredProcedure -StoredProcedure "site.proc_AddOrUpdateInformationBarrierSegment" -Parameters @{ json = $json }
        }
        catch
        {
            Stop-CmdletExecution -Id $cmdletExecutionId -ErrorCount $global:Error.Count

            Write-PSFMessage -Message "Failed to import information barrier segments." -ErrorRecord $_ -EnableException $true 
        }
    }
    end
    {
        Stop-CmdletExecution -Id $cmdletExecutionId -ErrorCount $global:Error.Count
    }
}