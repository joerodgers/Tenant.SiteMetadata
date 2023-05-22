using System;
using System.Security;
using System.Text.Json.Serialization;
using Tenant.SiteMetadata.Enums;

namespace Tenant.SiteMetadata
{
    public class ServicePrincipalDatabaseConnectionInformation : DatabaseConnectionInformation 
    {
        public ServicePrincipalAuthenticationType ServicePrincipalAuthenticationType { get; }

        public Guid ClientId { get; } = Guid.Empty;

        public Guid TenantId { get; } = Guid.Empty;

        // public SecureString? ClientSecret { get; } 

        public string CertificateThumbprint { get; } = string.Empty;

        //public ServicePrincipalDatabaseConnectionInformation(string databaseName,
        //                                                     string databaseServer,
        //                                                     Guid   clientId,
        //                                                     Guid   tenantId,
        //                                                     SecureString clientSecret,
        //                                                     int    connectionTimeout = 15) : base(databaseName, databaseServer, connectionTimeout, true /* encrypt */ )
        //{
        //    this.ClientId = clientId;
        //    this.TenantId = tenantId;
        //    this.ClientSecret = clientSecret;
        //    this.ServicePrincipalAuthenticationType = ServicePrincipalAuthenticationType.ClientSecret;
        //}

        public ServicePrincipalDatabaseConnectionInformation(string databaseName,
                                                             string databaseServer,
                                                             Guid   clientId,
                                                             Guid   tenantId,
                                                             string certificateThumbprint,
                                                             int    connectionTimeout = 15) : base(databaseName, databaseServer, connectionTimeout, true /* encrypt */ )
        {
            this.ClientId = clientId;
            this.TenantId = tenantId;
            this.CertificateThumbprint = certificateThumbprint;
            this.ServicePrincipalAuthenticationType = ServicePrincipalAuthenticationType.Certificate;
        }
    }
}
