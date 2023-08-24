CREATE OR ALTER VIEW sharepoint.SiteCollectionReadOnly
AS
    SELECT    
        *
    FROM
        site.SiteCollection
    WHERE
        DeletedDate IS NULL AND LockState = 2 AND Template NOT LIKE 'SPS%'
