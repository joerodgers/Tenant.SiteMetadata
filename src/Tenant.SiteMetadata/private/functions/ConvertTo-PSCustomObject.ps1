function ConvertTo-PSCustomObject
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="DataRow")]
        [System.Data.DataRow[]]
        $DataRow,

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="HashTable")]
        [System.Collections.Hashtable]
        $HashTable
    )

    begin
    {
        $excludedProperties = "ItemArray", "Table", "RowError", "RowState", "HasErrors"
    }
    process
    {
        if( $PSCmdlet.ParameterSetName -eq "DataRow" )
        {
            foreach( $row in $DataRow )
            {
                $row | Select-Object * -ExcludeProperty $excludedProperties | ConvertTo-Json | ConvertFrom-Json
            }
        }
        else
        {
            $object = [PSCustomObject] @{}

            foreach( $key in $HashTable.Keys )
            {
                $object | Add-Member -MemberType NoteProperty -Name $key -Value $HashTable.$Key
            }
            
            return $object
        }
    }
    end
    {
    }
}