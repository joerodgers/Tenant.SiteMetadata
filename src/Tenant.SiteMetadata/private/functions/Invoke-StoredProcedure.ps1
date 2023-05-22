using namespace Tenant.SiteMetadata

 function Invoke-StoredProcedure
 {
    [CmdletBinding()]
    param
    (
        # TSQL statement
        [Parameter(Mandatory=$true)]
        [string]
        $StoredProcedure,

        # Hashtable of parameters to the SQL query.  Do not include the '@' character in the key name.
        [Parameter(Mandatory=$false)]
        [HashTable]
        $Parameters = @{},

        # SQL command timeout. Default is 30 seconds
        [Parameter(Mandatory=$false)]
        [int]
        $CommandTimeout = 30
    )

    begin
    {
        Assert-ServiceConnection -Cmdlet $PSCmdlet
    }
    process
    {
        try
        {
            $connection = New-SqlServerDatabaseConnection

            if( $connection )
            {
                $command = New-Object System.Data.SqlClient.SqlCommand($StoredProcedure, $connection)     
                $command.CommandTimeout = $CommandTimeout
                $command.CommandType    = [System.Data.CommandType]::StoredProcedure

                foreach( $parameter in $Parameters.GetEnumerator() )
                {
                    if( $null -eq $parameter.Value )
                    {
                        # Write-PSFMessage -Message "Parameter: $($parameter.Key), Value=DBNULL" -Level Debug
                        $null = $command.Parameters.AddWithValue( "@$($parameter.Key)", [System.DBNull]::Value )
                    }
                    else 
                    {
                        # Write-PSFMessage -Message "Parameter: $($parameter.Key), Value='$($parameter.Value)'" -Level Debug
                        $null = $command.Parameters.AddWithValue( "@$($parameter.Key)", $parameter.Value )
                    }
                }

                Write-PSFMessage -Message "Executing stored procedure: '$StoredProcedure'" -Level Debug

                $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

                $null = $command.ExecuteNonQuery()

                Write-PSFMessage -Message "Executed store procedure '$StoredProcedure' in $($stopwatch.Elapsed.TotalMilliseconds) milliseconds" -Level Debug
            }
        }
        catch
        {
            $parameterString = ConvertTo-LogFileString -SqlParameterCollection $command.Parameters
            Stop-PSFFunction -Message "Failed to execute stored procedure: $StoredProcedure. Parameters: $parameterString" -Exception $_.Exception  #-EnableException $true -Exception $_.Exception
        }
        finally
        {
            if($command)
            {
                $command.Dispose()
            }

            if($connection)
            {
                $connection.Close()
                $connection.Dispose()
            }
        }
    }
    end
    {
    }
}
 

