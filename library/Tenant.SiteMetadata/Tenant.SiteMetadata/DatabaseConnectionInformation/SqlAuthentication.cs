using System.Data.SqlClient;

namespace Tenant.SiteMetadata
{
    public class SqlAuthenticationDatabaseConnectionInformation : DatabaseConnectionInformation
    {
        public SqlCredential SqlCredential { get; set; }
    }
}
