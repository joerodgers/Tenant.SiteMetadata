namespace Tenant.SiteMetadata
{
    public abstract class TenantConnectionInformation : ITenantConnectionInformation
    {
        public Guid TenantId { get; }

        public string TenantName { get; }

        protected TenantConnectionInformation(Guid tenantId, string tenantName)
        {
            TenantId   = tenantId;
            TenantName = tenantName ?? throw new ArgumentNullException(nameof(tenantName));
        }
    }
}
