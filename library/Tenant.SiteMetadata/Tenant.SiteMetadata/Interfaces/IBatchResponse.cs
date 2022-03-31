using System;
using System.Collections.Generic;

namespace Tenant.SiteMetadata
{
    public interface IBatchResponse
    {
        Guid BatchId { get; set; }

        IEnumerable<IBatchResponseItem> BatchResponseItems { get; set; }
    }
}
