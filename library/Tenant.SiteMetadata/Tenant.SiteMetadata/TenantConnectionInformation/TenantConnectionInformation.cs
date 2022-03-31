using System;
using System.Collections;

namespace Tenant.SiteMetadata
{
    public class TenantConnectionInformation : ITenantConnectionInformation
    {
        public Guid ClientId { get; set; }
        
        public Guid TenantId { get; set; }
        
        public string CertificateThumbprint { get; set; }
        
        public string TenantName { get; set; }

        public override string ToString()
        {
            return $"ClientId: {ClientId}, TenantId: {TenantId}, CertificateThumbprint: {CertificateThumbprint}, TenantName: {TenantName}";
        }
    }
}
