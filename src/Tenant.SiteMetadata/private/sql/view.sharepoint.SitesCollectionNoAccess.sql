CREATE OR ALTER VIEW sharepoint.SitesCollectionNoAccess
AS
    SELECT    
        *
    FROM
        site.SiteCollection
    WHERE
        DeletedDate IS NULL AND LockState = 3 AND Template NOT LIKE 'SPS%'
