namespace Tenant.SiteMetadata
{
    public interface ITenantConnectionInformation
    {
        Guid TenantId { get; }

        string TenantName { get; }
    }
}
