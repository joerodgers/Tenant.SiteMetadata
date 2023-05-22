namespace Tenant.SiteMetadata
{
    public class TrustedConnectionDatabaseConnectionInformation : DatabaseConnectionInformation
    {
        public TrustedConnectionDatabaseConnectionInformation(string databaseName,
                                                              string databaseServer,
                                                              int    connectionTimeout = 15,
                                                              bool   encrypt = true) : base(databaseName, databaseServer, connectionTimeout, encrypt)
        {
        }
    }
}
