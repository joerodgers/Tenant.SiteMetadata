namespace Tenant.SiteMetadata
{
    public abstract class DatabaseConnectionInformation : IDatabaseConnectionInformation
    {
        public string DatabaseName { get; }

        public string DatabaseServer { get; }

        public int ConnectTimeout { get; } = 15;

        public bool Encrypt { get; } = true;

        public DatabaseConnectionInformation(string databaseName, string databaseServer, int connectionTimeout = 15, bool encrypt = true)
        {
            this.DatabaseName   = databaseName   ?? throw new ArgumentNullException(nameof(databaseName));
            this.DatabaseServer = databaseServer ?? throw new ArgumentNullException(nameof(databaseServer));
            this.ConnectTimeout = connectionTimeout;
            this.Encrypt        = encrypt;
        }

        public override string ToString()
        {
            return $"DatabaseName: {DatabaseName}, DatabaseServer: {DatabaseServer}, ConnectTimeout: {ConnectTimeout}, Encrypt: {Encrypt}";
        }
    }
}
