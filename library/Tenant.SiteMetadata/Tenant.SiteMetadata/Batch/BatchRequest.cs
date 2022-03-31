using System;
using System.Collections.Generic;

namespace Tenant.SiteMetadata
{
    public class BatchRequest : IBatchRequest
    {
        public Guid BatchId { get; private set; }

        public IEnumerable<IBatchRequestItem> BatchRequestItems { get; set; } = new List<BatchRequestItem>();

        public BatchRequest()
        {
            this.BatchId = Guid.NewGuid();
        }
    }
}
