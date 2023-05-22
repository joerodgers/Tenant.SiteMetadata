function ConvertTo-LogFileString
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true,ParameterSetName="SqlParameterCollection")]
        [System.Data.SqlClient.SqlParameterCollection]
        $SqlParameterCollection
    )

    process
    {
        $sb = New-Object System.Text.StringBuilder

        switch( $PSCmdlet.ParameterSetName )
        {
            "SqlParameterCollection"
            {
                $sb.Append("SqlParameterCollection: ")

                foreach( $parameter in $SqlParameterCollection )
                {
                    $sb.AppendFormat( "Name: '{0}', Value: '{1}', Type: '{2}'; ", $parameter.ParameterName, $parameter.SqlValue, $parameter.SqlDbType)
                }
            }
        }

        return $sb.ToString()
    }
}