using System;
using System.Collections.Generic;

namespace Tenant.SiteMetadata
{
    public interface IBatchRequest
    {
        Guid BatchId { get; }

        IEnumerable<IBatchRequestItem> BatchRequestItems { get; set; }
    }
}
