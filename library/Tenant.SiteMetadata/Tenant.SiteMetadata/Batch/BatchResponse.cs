using System;
using System.Collections.Generic;

namespace Tenant.SiteMetadata
{
    public class BatchResponse : IBatchResponse
    {
        public Guid BatchId { get; set; }

        public IEnumerable<IBatchResponseItem> BatchResponseItems { get; set; } = new List<BatchResponseItem>();
    }
}
