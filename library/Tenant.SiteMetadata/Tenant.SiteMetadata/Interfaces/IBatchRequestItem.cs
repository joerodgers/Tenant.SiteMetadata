using System.Collections;
using System.Net.Http;

namespace Tenant.SiteMetadata
{
    public interface IBatchRequestItem
    {
        string Url { get; set; }

        HttpMethod HttpMethod { get; set; }

        string Content { get; set; }

        Hashtable Headers { get; set; }
    }
}
