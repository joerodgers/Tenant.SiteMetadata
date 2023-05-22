CREATE OR ALTER VIEW sharepoint.SitesCollectionActive
AS
    SELECT    
        *
    FROM
        site.SiteCollection
    WHERE
        DeletedDate IS NULL AND Template NOT LIKE 'SPS%'
