using System.Data.SqlClient;

namespace Tenant.SiteMetadata
{
    public class SqlAuthenticationDatabaseConnectionInformation : DatabaseConnectionInformation
    {
        public SqlCredential SqlCredential { get; }

        public SqlAuthenticationDatabaseConnectionInformation(string databaseName,
                                                              string databaseServer,
                                                              SqlCredential sqlCredential,
                                                              int connectionTimeout = 15 ) : base(databaseName, databaseServer, connectionTimeout, true /* encrypt */ )
        {
            this.SqlCredential = sqlCredential ?? throw new ArgumentNullException(nameof(sqlCredential));
        }
    }
}
