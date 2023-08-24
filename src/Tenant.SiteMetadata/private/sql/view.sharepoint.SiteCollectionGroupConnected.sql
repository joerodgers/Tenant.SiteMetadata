CREATE OR ALTER VIEW sharepoint.SiteCollectionGroupConnected
AS
    SELECT    
        *
    FROM
        site.SiteCollection
    WHERE
        DeletedDate IS NULL AND GroupId IS NOT NULL AND GroupId <> '00000000-0000-0000-0000-000000000000'
