CREATE OR ALTER VIEW sharepoint.SiteCollectionActive
AS
    SELECT    
        *
    FROM
        site.SiteCollection
    WHERE
        DeletedDate IS NULL AND Template NOT LIKE 'SPS%'
