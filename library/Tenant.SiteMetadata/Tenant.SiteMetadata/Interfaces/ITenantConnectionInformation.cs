using System;
using System.Collections;

namespace Tenant.SiteMetadata
{
    public interface ITenantConnectionInformation
    {
        Guid ClientId { get; set; }

        Guid TenantId { get; set; }

        string CertificateThumbprint { get; set; }

        string TenantName { get; set; }

        string ToString();
    }
}
