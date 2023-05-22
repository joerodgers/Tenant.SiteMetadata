namespace Tenant.SiteMetadata
{
    public class ManagedIdentityConnectionInformation : DatabaseConnectionInformation
    {
        public ManagedIdentityConnectionInformation(string databaseName,
                                                    string databaseServer,
                                                    int    connectionTimeout = 15,
                                                    bool   encrypt = true) : base(databaseName, databaseServer, connectionTimeout, encrypt)
        {
        }
    }
}
