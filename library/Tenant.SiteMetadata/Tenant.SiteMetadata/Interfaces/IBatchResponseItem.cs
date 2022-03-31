namespace Tenant.SiteMetadata
{
    public interface IBatchResponseItem
    {
        string ContentType { get; set; }

        int StatusCode { get; set; }

        string Content { get; set; }
    }
}
