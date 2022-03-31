function ConvertTo-TenantSiteMetadataModelSiteCollection
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [Guid]
        $SiteId,

        [Parameter(Mandatory=$true)]
        [PnP.PowerShell.Commands.Model.SPOSite]
        $PnPTenantSite
    )

    begin
    {
    }
    process
    {
        try 
        {
            $model = New-Object Tenant.SiteMetadata.Model.SiteCollection
            $model.SiteId                                     = $SiteId
            $model.ConditionalAccessPolicy                    = switch( $PnPTenantSite.ConditionalAccessPolicy ) { "AllowFullAccess"{ 0 }; "AllowLimitedAccess"{ 1 }; "BlockAccess"{ 2 }; "AuthenticationContext"{ 3 }; default{ -1 } } 
            $model.DisplayName                                = $PnPTenantSite.Title
            $model.DenyAddAndCustomizePagesEnabled            = switch( $PnPTenantSite.DenyAddAndCustomizePages ) { "Enabled"{ $true }; default{ $false } } 
            $model.ExternalUserExpirationInDays               = $PnPTenantSite.ExternalUserExpirationInDays
            $model.GroupId                                    = $PnPTenantSite.GroupId
            $model.HubSiteId                                  = $PnPTenantSite.HubSiteId
            $model.IsProjectConnected                         = switch( $PnPTenantSite.PWAEnabled ) { "Enabled"{ $true }; default{ $false } } 
            $model.LastItemModifiedDate                       = $PnPTenantSite.LastContentModifiedDate
            $model.Lcid                                       = $PnPTenantSite.LocaleId
            $model.LockState                                  = switch( $PnPTenantSite.LockState ) { "Unlock"{ 1 } "ReadOnly"{ 2 }; "NoAccess"{ 3 }; default { -1 } } 
            $model.OverrideTenantExternalUserExpirationPolicy = $PnPTenantSite.OverrideTenantExternalUserExpirationPolicy
            $model.RelatedGroupId                             = $PnPTenantSite.RelatedGroupId
            # $model.InformationSegment                         = $tenantsite.InformationSegment
            # $model.RestrictedToGeo                            = $tenantsite.RestrictedToGeo
            $model.SiteDefinedSharingCapability               = $PnPTenantSite.SiteDefinedSharingCapability
            $model.SharingCapability                          = $PnPTenantSite.SharingCapability
            $model.SharingDomainRestrictionMode               = switch( $PnPTenantSite.SharingDomainRestrictionMode ) { "None"{ 0 } "AllowList"{ 1 }; "BlockList"{ 2 }; } 
            $model.SiteUrl                                    = $PnPTenantSite.Url
            $model.Template                                   = $PnPTenantSite.Template
            $model.StorageQuota                               = $PnPTenantSite.StorageQuota # MB
            $model.StorageUsed                                = $PnPTenantSite.StorageUsageCurrent # MB
            
            if( $PnPTenantSite.SensitivityLabel )
            {
                $model.SensitivityLabel = $PnPTenantSite.SensitivityLabel
            }
    
            $model
        }
        catch 
        {
            Write-PSFMessage -Message "failed to convert:" -ErrorRecord $_
        }
    }
    end
    {
    }
}