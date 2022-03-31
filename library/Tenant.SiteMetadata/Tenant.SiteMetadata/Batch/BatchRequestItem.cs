using System.Collections;
using System.Net.Http;

namespace Tenant.SiteMetadata
{
    public class BatchRequestItem : IBatchRequestItem
    {
        public string Url 
        { 
            get; 
            set; 
        }

        public HttpMethod HttpMethod 
        { 
            get; 
            set; 
        }

        public string Content 
        { 
            get; 
            set; 
        }

        public Hashtable Headers 
        { 
            get; 
            set; 
        }
    }
}
