<#

class SiteCollection
{
    [Guid]
    $SiteId

    [System.Uri]
    $SiteUrl

    [Nullable[DateTime]]
    $CreatedDateTime

    [Nullable[DateTime]]
    $LastModifiedDateTime
}

class BatchRequestItem
{
    [string]
    $Url

    [string]
    $Method

    [string]
    $Content

    [HashTable]
    $Headers
}

class BatchResponseItem
{
    [string]
    $Id

    [string]
    $Status

    [string]
    $Body
}

class BatchResponse
{
    BatchResponse()
    {
        $this.BatchResponseItems = New-Object System.Collections.Generic.List[BatchResponseItem]
    }

    [System.Collections.Generic.List[BatchResponseItem]]
    $BatchResponseItems
}

class BatchRequest
{
    BatchRequest()
    {
        $this.BatchRequestItems = New-Object System.Collections.Generic.List[BatchRequestItem]
    }

    [System.Collections.Generic.List[BatchRequestItem]]
    $BatchRequestItems
}
#>
