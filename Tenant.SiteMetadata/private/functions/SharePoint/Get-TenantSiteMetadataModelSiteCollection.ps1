using namespace Tenant.SiteMetadata.Model

function Get-TenantSiteMetadataModelSiteCollection
{
    [CmdletBinding(DefaultParameterSetName="All")]
    param 
    (
        [Parameter(Mandatory=$true,ParameterSetName="SiteUrl")]
        [string]
        $SiteUrl,

        [Parameter(Mandatory=$true,ParameterSetName="SiteId")]
        [Guid]
        $SiteId,

        [Parameter(Mandatory=$true,ParameterSetName="LockState")]
        [ValidateSet( "NoAccess", "ReadOnly" )]
        [string]
        $LockState,

        [Parameter(Mandatory=$true,ParameterSetName="All")]
        [switch]
        $All,

        [Parameter(Mandatory=$true,ParameterSetName="DeltaToken")]
        [ref]
        $DeltaToken,

        [Parameter(Mandatory=$true,ParameterSetName="Template")]
        [ValidateSet( "APPCATALOG#0", "BICenterSite#0", "BLANKINTERNET#0", "EDISC#0", "EHS#1", "GROUP#0", "POINTPUBLISHINGHUB#0", "POINTPUBLISHINGPERSONAL#0", "POINTPUBLISHINGTOPIC#0", "RedirectSite#0", "SITEPAGEPUBLISHING#0", "SPSMSITEHOST#0", "SRCHCEN#0", "STS#-1", "STS#0", "STS#3", "TEAMCHANNEL#0", "TEAMCHANNEL#1", "PROJECTSITE#0", "PWA#0", IgnoreCase = $false)]
        $Template,

        [Parameter(Mandatory=$true,ParameterSetName="ExcludedSiteTemplates")]
        [switch]
        $ExcludedSiteTemplates,

        [Parameter(Mandatory=$true,ParameterSetName="Deleted")]
        [switch]
        $Deleted
    )
    
    begin
    {
        $templates = "SPSMSITEHOST#0", "RedirectSite#0", "TEAMCHANNEL#0", "TEAMCHANNEL#1", "POINTPUBLISHINGHUB#0", "POINTPUBLISHINGTOPIC#0", "POINTPUBLISHINGPERSONAL#0"
    }
    process
    {
        Assert-SharePointConnection -Cmdlet $PSCmdlet

        if( $PSCmdlet.ParameterSetName -eq "LockState" )
        {
            return Get-TenantSiteMetadataModelSiteCollectionByLockState -LockState $LockState
        }

        if( $PSCmdlet.ParameterSetName -eq "Template" )
        {
            return Get-TenantSiteMetadataModelSiteCollectionByTemplate -Template $Template
        }

        if( $PSCmdlet.ParameterSetName -eq "SiteUrl" )
        {
            return Get-TenantSiteMetadataModelSiteCollectionBySiteUrl -SiteUrl $SiteUrl
        }

        if( $PSCmdlet.ParameterSetName -eq "SiteId" )
        {
            return Get-TenantSiteMetadataModelSiteCollectionBySiteId -SiteId $SiteId
        }

        if( $PSCmdlet.ParameterSetName -eq "DeltaToken" )
        {
            return Get-TenantSiteMetadataModelSiteCollectionByDeltaToken -DeltaToken $DeltaToken
        }

        if( $PSCmdlet.ParameterSetName -eq "All" )
        {
            return Get-TenantSiteMetadataModelSiteCollectionByV2Api
        }

        if( $PSCmdlet.ParameterSetName -eq "ExcludedSiteTemplates" )
        {
            return ($templates | ForEach-Object { Get-TenantSiteMetadataModelSiteCollectionByTemplate -Template $_ })
        }
    }
    end
    {
    }
}