using System.Collections;

namespace Tenant.SiteMetadata
{
    public abstract class DatabaseConnectionInformation : IDatabaseConnectionInformation
    {
        public string DatabaseName { get; set; }

        public string DatabaseServer { get; set; }

        public int ConnectTimeout { get; set; } = 15;

        public bool Encrypt { get; set; } = true;

        public override string ToString()
        {
            return $"DatabaseName: {DatabaseName}, DatabaseServer: {DatabaseServer}, ConnectTimeout: {ConnectTimeout}, Encrypt: {Encrypt}";
        }
    }
}
