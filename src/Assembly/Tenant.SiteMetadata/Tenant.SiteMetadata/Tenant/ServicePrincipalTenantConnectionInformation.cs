using System.Security;

namespace Tenant.SiteMetadata
{
    public class ServicePrincipalTenantConnectionInformation : TenantConnectionInformation
    {
        public Guid ClientId { get; }
        
        public string CertificateThumbprint { get; }

        public ServicePrincipalTenantConnectionInformation(Guid tenantId, string tenantName, Guid clientId, string certificateThumbprint) : base(tenantId, tenantName)
        {
            this.ClientId = clientId;
            this.CertificateThumbprint = certificateThumbprint;
        }
    }
}
