namespace Tenant.SiteMetadata
{
    public class BatchResponseItem : IBatchResponseItem
    {
        public string ContentType { get; set; }
        public int StatusCode { get; set; }
        public string Content { get; set; }
    }
}
