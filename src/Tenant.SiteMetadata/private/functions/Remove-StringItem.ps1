using namespace System.Collections.Generic

function Remove-StringItem
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string[]]
        $ReferenceObject,

        [Parameter(Mandatory=$true)]
        [AllowEmptyCollection()]
        [string[]]
        $DifferenceObject
    )

    begin
    {
    }
    process
    {
        [HashSet[string]]$referenceObjectHashSet  = $ReferenceObject
        [HashSet[string]]$differenceObjectHashSet = $DifferenceObject
        
        $referenceObjectHashSet.SymmetricExceptWith($differenceObjectHashSet)

        return $referenceObjectHashSet
    }
    end
    {
    }
}
