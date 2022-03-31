namespace Tenant.SiteMetadata
{
    public interface IDatabaseConnectionInformation
    {
        string DatabaseName { get; set; }

        string DatabaseServer { get; set; }

        int ConnectTimeout { get; set; }

        bool Encrypt { get; set; }
    }
}
