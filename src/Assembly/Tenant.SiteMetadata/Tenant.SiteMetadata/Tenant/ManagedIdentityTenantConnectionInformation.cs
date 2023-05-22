using Tenant.SiteMetadata;

namespace Tenant.SiteMetadata
{
    public class ManagedIdentityTenantConnectionInformation : TenantConnectionInformation
    {
        public ManagedIdentityTenantConnectionInformation(Guid tenantId, string tenantName) : base(tenantId, tenantName)
        {
        }
    }
}
