namespace Tenant.SiteMetadata
{
    public interface IDatabaseConnectionInformation
    {
        string DatabaseName { get; }

        string DatabaseServer { get; }

        int ConnectTimeout { get; }

        bool Encrypt { get; }
    }
}
