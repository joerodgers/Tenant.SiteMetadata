using System;

namespace Tenant.SiteMetadata
{
    public class ServicePrincipalDatabaseConnectionInformation : DatabaseConnectionInformation 
    {
        public Guid ClientId { get; set; }

        public Guid TenantId { get; set; }

        public string ClientSecret { get; set; }
    }
}
