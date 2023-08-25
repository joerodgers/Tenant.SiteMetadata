CREATE OR ALTER VIEW sharepoint.SiteCollectionDeleted
AS
    SELECT    
        *
    FROM
        site.SiteCollection
    WHERE
        DeletedDate IS NOT NULL AND Template NOT LIKE 'SPS%'
