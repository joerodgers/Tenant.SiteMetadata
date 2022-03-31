CREATE OR ALTER VIEW dbo.SitesHubConnected
AS
    SELECT
        *
    FROM            
        dbo.tvf_Sites(15,1)
    WHERE
        HubSiteId IS NOT NULL
        AND HubSiteId <> '00000000-0000-0000-0000-000000000000'
