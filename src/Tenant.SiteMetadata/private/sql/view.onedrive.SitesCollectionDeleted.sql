CREATE OR ALTER VIEW onedrive.SitesCollectionDeleted
AS
    SELECT    
        *
    FROM
        site.SiteCollection 
    WHERE
        Template LIKE 'SPS%' AND DeletedDate IS NOT NULL

