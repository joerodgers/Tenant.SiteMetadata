CREATE OR ALTER VIEW sharepoint.SitesCollectionReadOnly
AS
    SELECT    
        *
    FROM
        site.SiteCollection
    WHERE
        DeletedDate IS NULL AND LockState = 2 AND Template NOT LIKE 'SPS%'
